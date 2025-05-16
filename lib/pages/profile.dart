
import 'package:flutter/material.dart';
import 'package:detector/pages/util/various_assets.dart';

class Profile extends StatelessWidget{
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed("/help"),
              child: const TextAndWidget(name: "Help", pic: Icon(Icons.help),)
            ),

            GestureDetector(
                onTap: () => Navigator.of(context).pushNamed("/contactus"),
                child: const TextAndWidget(name: "Contact Us", pic: Icon(Icons.contacts),)
            ),

            GestureDetector(
                onTap: () => Navigator.of(context).pushNamed("/settings"),
                child: const TextAndWidget(name: "Settings", pic: Icon(Icons.settings),)
            ),
          ],
        )
    );
  }
}