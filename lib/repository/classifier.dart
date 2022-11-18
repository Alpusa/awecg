import 'dart:typed_data';

import 'package:flutter/services.dart';

// Import tflite_flutter
import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {
  // name of the model file
  final _modelFile = 'model.tflite';

  // TensorFlow Lite Interpreter object
  Interpreter? _interpreter;

  Classifier() {
    // Load model when the classifier is initialized.

    _loadModel();
  }

  void _loadModel() async {
    // Creating the interpreter using Interpreter.fromAsset
    _interpreter != null
        ? _interpreter!.close()
        : _interpreter = await Interpreter.fromAsset(_modelFile);
    print('Interpreter loaded successfully');
  }

  List<double> classify(List<double> inData) {
    if (_interpreter != null) {
      Float32List matrix = Float32List.fromList(inData);
      var m = <Float32List>[];
      print(m.shape);
      matrix.forEach((element) {
        m.add(Float32List.fromList([element]));
      });
      print(m.shape);
      List<List<Float32List>> input = [m];

      //print(input);
      // create a output tensor with the shape of the model's output tensor
      List<double> output = List<double>.filled(3, 0.0);
      // run the interpreter
      var r = [output];
      _interpreter!.run(input, r);
      print(r);
      return r[0];
    }
    return [];
  }
}
