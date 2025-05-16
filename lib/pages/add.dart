import 'dart:io';

import 'package:detector/MongoDb/mongo_work.dart';
import 'package:detector/pages/util/various_assets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Add extends StatefulWidget{
  const Add({super.key});

  @override
  State<StatefulWidget> createState() => _Add();
}

class _Add extends State<Add>{
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController jsonIdController;
  late TextEditingController solnController;
  File? image;

  Future<void> _handleAdd() async{
    Disease d = Disease(dname: nameController.text, jsonId: int.parse(jsonIdController.text),dimg: image,soln: solnController.text);
    Disease.enterNewDisease(d);
    displayError(context, "Done");
  }

  Future<void> _galleryOption() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery) ;
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<void> _cameraOption() async{
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if(pickedFile != null){
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    jsonIdController = TextEditingController();
    solnController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Disease"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Enter the name: "),

            DesignedTextController(hintText: "Name", controller: nameController),

            const Text("Enter the Description: "),

            DesignedTextController(hintText: "Description", controller: descriptionController),

            const Text("Enter the jsonId: "),

            DesignedTextController(hintText: "json", controller: jsonIdController),

            const SizedBox(height: 20,),

            DesignedTextController(hintText: "soln", controller: solnController),

            const SizedBox(height: 20,),

            if(image != null) Image.file(image!),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _cameraOption,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states){
                      if(states.contains(WidgetState.pressed)){
                        return theme.colorScheme.tertiary;
                      }
                      return theme.colorScheme.inversePrimary;
                    }),
                    foregroundColor:WidgetStateProperty.resolveWith((states){
                      if(states.contains(WidgetState.pressed)){
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
                    backgroundColor: WidgetStateProperty.resolveWith((states){
                      if(states.contains(WidgetState.pressed)){
                        return theme.colorScheme.tertiary;
                      }
                      return theme.colorScheme.inversePrimary;
                    }),
                    foregroundColor:WidgetStateProperty.resolveWith((states){
                      if(states.contains(WidgetState.pressed)){
                        return theme.colorScheme.surface;
                      }
                      return theme.colorScheme.inverseSurface;
                    }),
                  ),
                  child: const Icon(Icons.image, size: 100),
                ),
              ],
            ),

            Align(
              child: designedButton(context, "Add",(){
                try{
                  _handleAdd();
                }catch(e){
                  displayError(context, e);
                }
              }),
            ),

            const SizedBox(width: 40),

          ],
        ),
      ),
    );

  }
}