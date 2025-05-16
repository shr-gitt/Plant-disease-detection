
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:detector/MongoDb/mongo_work.dart';
import 'package:detector/main.dart';
import 'package:detector/pages/util/various_assets.dart';

class Settings extends StatefulWidget{
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  File? _image;
  late TextEditingController firstNameController;
  late TextEditingController middleNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late ImagePicker _picker;

  Future<void> _galleryOption() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery) ;
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path) ;
      });
    }
  }

  Future<void> _cameraOption() async{
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if(pickedFile != null){
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState(){
    super.initState();
    firstNameController = TextEditingController();
    middleNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text ("Edit your account info:", style: theme.textTheme.titleLarge),

              const SizedBox(height: 20),

              Text("  First Name (Optional)", style: theme.textTheme.titleLarge),

              DesignedTextController(hintText: "John", controller:  firstNameController),

              const SizedBox(height: 20),

              Text("  Middle Name (Optional)", style: theme.textTheme.titleLarge),

              DesignedTextController(hintText:  "", controller:  middleNameController),

              const SizedBox(height: 20),

              Text("  Last Name (Optional)", style: theme.textTheme.titleLarge),

              DesignedTextController(hintText: "Doe", controller:  lastNameController),

              const SizedBox(height: 20),

              Text("  Email", style: theme.textTheme.titleLarge),

              DesignedTextController(hintText: "example@123.com", controller:  emailController),

              const SizedBox(height: 20),

              Text("  Password", style: theme.textTheme.titleLarge),

              DesignedTextController(hintText:  "****", controller: passwordController, isPassword: true),

              const SizedBox(height: 40),

              Text("  Choose a profile picture (Optional)", style: theme.textTheme.titleLarge),

              if(_image != null) Image.file(_image!,width: 300),

              const SizedBox(height: 20),

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
                child: designedButton(context, "Update", () {
                  Account a = Account(accountId: Provider.of<Account>(context, listen: false).accountId,
                    firstname: firstNameController.text,
                    middlename: middleNameController.text,
                    lastname: lastNameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    pfp: _image
                  );

                  Account.modifyAccount(a);
                } ),
              ),

              const SizedBox(width: 40),

            ],
          ),
        ),
      ),
    );
  }
}