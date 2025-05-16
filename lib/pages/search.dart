import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:detector/MongoDb/mongo_work.dart';
import 'package:detector/TFlite/tf_work.dart';
import 'package:detector/pages/util/various_assets.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  static const Map<int, String> diseaseNameMap = {
    0: 'Healthy Apple',
    1: 'Rotten Apple',
    2: 'Apple with Rust',
    3: 'Apple with Scab',
    4: 'Healthy Corn',
    5: 'Corn Leaf with Blight',
    6: 'Corn Leaf with Gray Spot',
    7: 'Corn Leaf with Green Spot',
    8: 'Corn Leaf with Rust',
    9: 'Healthy Coffee',
    10: 'Coffee with Rust',
    11: 'Bell pepper with bacterial Spot',
    12: 'Healthy Bell pepper',
    13: 'Potato with Early Blight',
    14: 'Healthy Potato',
    15: 'Potato with Late Blight',
    16: 'Healthy Rice',
    17: 'Rice Leaf with Blast',
    18: 'Rice Leaf with Blight',
    19: 'Rice Leaf with Brown Spot',
    20: 'Healthy Strawberry',
    21: 'Scorched Strawberry Leaf',
    22: 'Tea Algal Sot',
    23: 'Tea with Brown Blight',
    24: 'Healthy Tea',
    25: 'Tea with Red Leaf Spot',
    26: 'Tomato with Bacterial Spot',
    27: 'Tomato with Early Blight',
    28: 'Healthy Tomato',
    29: 'Tomato with Late Blight',
    30: 'Tomato with Leaf Mold',
    31: 'Tomato with Mosiac Virus',
    32: 'Tomato with Septoria Leaf Spot',
    33: 'Tomato with Target Spot'
  };

  @override
  State<Search> createState() => _Search();
}

class _Search extends State<Search> {

  File? _image;
  late ImagePicker _picker;
  OverlayEntry? _overlayEntry;
  late AnimationController controller;
  Widget child = const SizedBox();

  void _showInfo(
      List<({String modelName, Disease disease, double confidence})> info) {
    void removeInfo() {
      _overlayEntry!.remove();
      _overlayEntry!.dispose();
      _overlayEntry = null;
      setState(() {});
    }
    List<Widget> children = [];
    for (var x in info) {
      children.add(
        TextAndWidget(
          name: "${x.modelName} found:",
          pic: x.disease.diseaseImage,
          data:
              "${x.disease.dname}.\nWith a confidence of ${(x.confidence * 100).toString().substring(0, 4)}%",
        ),
      );
    }

    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.surface.withAlpha(127),
          child: Column(children: [
            ...children,
            designedButton(context, "Dismiss", removeInfo)
          ]),
        ),
      );
    });

    Overlay.of(context).insert(_overlayEntry!);
  }

  Future<void> _galleryOption() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _cameraOption() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<List<({String modelName, Disease disease, double confidence})>>
      _handleSearch() async {
    try {
      if (_image == null) throw "Select an image first";

      var results = await TfWork.getPredictions(_image!);
      List<({String modelName, Disease disease, double confidence})> ret = [];
      for (var x in results) {
        try {
          Disease detectedDisease = await Disease.retreiveDisease(x.index);
          if (!detectedDisease.isnull) {
            ret.add((
              modelName: x.modelName,
              disease: detectedDisease,
              confidence: x.confidence
            ));
          } else {
            ret.add((
              modelName: x.modelName,
              disease:
                  Disease(dname: Search.diseaseNameMap[x.index], jsonId: x.index),
              confidence: x.confidence
            ));
          }
        } catch (e) {
          ret.add((
            modelName: x.modelName,
            disease: Disease(dname: Search.diseaseNameMap[x.index], jsonId: x.index),
            confidence: x.confidence
          ));
        }
      }

      ret.sort((a, b) => b.confidence.compareTo(a.confidence));

      return ret;
    } catch (e) {
      rethrow;
    }
  }

  Widget _predictionsWidget() {
    ThemeData theme = Theme.of(context);
    return FutureBuilder<
            List<({String modelName, Disease disease, double confidence})>>(
        future: _handleSearch(),
        builder: (BuildContext context,
            AsyncSnapshot<
                    List<
                        ({
                          String modelName,
                          Disease disease,
                          double confidence
                        })>>
                snapshot) {
          List<Widget> snapshotWidgets = [];
          if (snapshot.hasData) {
            snapshotWidgets.add(const SizedBox(height: 20));

            snapshotWidgets.add(TextAndWidget(
              name: "Possible Detections Found:",
              pic: snapshot.data![0].disease.diseaseImage,
              data: snapshot.data![0].disease.dname,
              extra: Container(
                decoration: const BoxDecoration(
                    color: Color(0x44ffffff), shape: BoxShape.circle),
                child: GestureDetector(
                    onTap: () => _showInfo(snapshot.data!),
                    child: const Icon(
                      Icons.info,
                      size: 20,
                    )),
              ),
            ));
          } else if (snapshot.hasError) {
            snapshotWidgets.add(
                Text("Detection Error", style: theme.textTheme.labelLarge));
            snapshotWidgets.add(Text(snapshot.error.toString(),
                style: theme.textTheme.bodyMedium));
          } else {
            snapshotWidgets.add(const CircularProgressIndicator());
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: snapshotWidgets,
          );
        });
  }



  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detection Page"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              if (_image != null) Image.file(_image!, width: 300),

              child,

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _cameraOption,
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return theme.colorScheme.tertiary;
                        }
                        return theme.colorScheme.inversePrimary;
                      }),
                      foregroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return theme.colorScheme.surface;
                        }
                        return theme.colorScheme.inverseSurface;
                      }),
                    ),
                    child: const Icon(Icons.camera_alt, size: 100),
                  ),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: _galleryOption,
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return theme.colorScheme.tertiary;
                        }
                        return theme.colorScheme.inversePrimary;
                      }),
                      foregroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return theme.colorScheme.surface;
                        }
                        return theme.colorScheme.inverseSurface;
                      }),
                    ),
                    child: const Icon(Icons.image, size: 100),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              designedButton(context, "Detect", () {
                _handleSearch();
                setState(() {
                  child = _predictionsWidget();
                });
              }),
            ],
          ),
        ),
      ),
    );
  }
}
