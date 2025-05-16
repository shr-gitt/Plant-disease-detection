import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class TfWork {

  static List<({String path, String modelName, int imgRes})> modelRecords= [
    (path: "models/efficientNetB0.tflite", modelName: "efficientNetB0", imgRes: 224),
    (path: "models/efficientNetB1.tflite", modelName: "efficientNetB1", imgRes: 240),
    (path: "models/resNet.tflite", modelName: "resNet", imgRes: 224),
  ];

  ///returns a [Future] with a [List] of Records in the format: modelName, index, confidence

  static Future<List<({String modelName, int index, double confidence})>> getPredictions(File userPic) async{

    final imageBytes = await userPic.readAsBytes();

    final img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception('Could not decode the image.');
    }

    List<({String modelName, int index, double confidence})> y = [];

    for(var x in modelRecords) {
      img.Image resizedImage = img.copyResize(image, width: x.imgRes, height: x.imgRes);

      var input = [List.generate(x.imgRes, (y) {
        return List.generate(x.imgRes, (x) {
          var pixel = resizedImage.getPixel(x, y);
          return [
            pixel.r,
            pixel.g,
            pixel.b
          ];
        });
      })];

      List<List<double>> output = [List.filled(34, 0.0)];

      Interpreter interpreter = await Interpreter.fromAsset(x.path);
      interpreter.allocateTensors();
      interpreter.run(input, output);
      interpreter.close();

      int index = 0;
      double maxTemp = output[0][0];
      int i = 0;

      for (var x in output[0]) {
        if (x > maxTemp) {
          maxTemp = x;
          index = i;
        }
        i++;
      }
      
      y.add((modelName: x.modelName, index: index, confidence: maxTemp));
      
    }

    return y;
  }

}
