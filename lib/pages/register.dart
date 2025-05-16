
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:detector/main.dart';
import 'package:detector/pages/util/various_assets.dart';
import 'package:detector/MongoDb/mongo_work.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>{

  File? image;


  late TextEditingController firstNameController;
  late TextEditingController middleNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  void _handleRegAndNavigate() async{
    try{
      if(MongoDatabase.isConnected == false) {
        throw "Could not connect to database.";
      }
      else if(MongoDatabase.dbError != null){
        throw MongoDatabase.dbError!;
      }
      Account foo = await Account.retreiveAccountep(emailController.text,passwordController.text);
      if(foo.isnull){
        await Account.insertAccount(firstNameController.text, middleNameController.text, lastNameController.text, emailController.text, passwordController.text, image);
        foo = await Account.retreiveAccountep(emailController.text,passwordController.text);

        if(!foo.isnull){
          WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<OnDeviceStorage>(context, listen: false).userAcc = foo;
          Navigator.of(context).pushReplacementNamed('/nav');
          });
        }
        else{
          throw "Could not verify insertion of details.";
        }

      }
      else{
        throw "This Account Already exists";
      }
    }catch(e){
      rethrow;
    }

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
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          
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
          
              if(image != null) Image.file(image!,width: 300),
          
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
                child: designedButton(context, "Register",(){
                  try{
                    _handleRegAndNavigate();
                  }catch(e){
                    displayError(context, e);
                  }
                }),
              ),
          
              const SizedBox(width: 40),
          
            ],
          ),
        ),
      ),
    );
  }
}