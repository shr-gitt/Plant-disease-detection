import 'package:flutter/material.dart' ;
import 'package:detector/main.dart';
import 'package:detector/pages/util/various_assets.dart';
import 'package:detector/MongoDb/mongo_work.dart';

class SignIn extends StatefulWidget{
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignIn();
}

class _SignIn extends State<SignIn> with TickerProviderStateMixin<SignIn>{

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late AnimationController progressController;

  void _handleSignInAndPush() async{
    try{
      if(MongoDatabase.isConnected == false){
        throw "Could not connect to database.";
      }
      else if(MongoDatabase.dbError != null){
        throw MongoDatabase.dbError!;
      }
      Account foo = await Account.retreiveAccountep(emailController.text,passwordController.text);
      if(foo.isnull) {
        throw "Could not retrieve the specified account.";
      }
      else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<OnDeviceStorage>(context, listen: false).userAcc = foo;
        Navigator.of(context).pushReplacementNamed('/nav');
        });
      }
    }catch(e){
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    progressController = AnimationController(vsync: this)..addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            Text("  Email", style: theme.textTheme.titleLarge),

            DesignedTextController(hintText:  "example@123.com", controller:  emailController),

            const SizedBox(height: 20),

            Text("  Password", style: theme.textTheme.titleLarge),

            DesignedTextController(hintText: "****", controller:  passwordController),

            const SizedBox(height: 20),

            Align(
              child: designedButton(context, "Sign In", () {
                try{
                _handleSignInAndPush();
                }catch(e){
                  displayError(context, e);
                }
              }),
            ),
          ],
        ),
    );
  }
}