
import 'package:flutter/material.dart';

class Help extends StatelessWidget{
  const Help({super.key});

  static final Map<int, String> _diseaseNameMap = {
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
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for(var x in _diseaseNameMap.entries){
      children.add(Text("${x.value}\n"));
    }
    return Scaffold(
      appBar: AppBar(title:const Text("Help"),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("This application detects diseases in plants using several AI models (efficientNet and ResNet)\n"
                  "The diseases this app can detect include:\n"),
              ...children
            ],
          ),
        ),
      ),
    );
  }
}