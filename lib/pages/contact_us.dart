import 'package:flutter/material.dart' ;
import 'package:detector/pages/util/various_assets.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
      ),
      body: const SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextAndWidget(name: "Ishan Ghimire", data: "Number: 9862108466\nEmail: ishangh64@gmail.com")
          ],
        )
      ),
    );
  }
}