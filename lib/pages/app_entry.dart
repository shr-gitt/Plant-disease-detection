import 'package:flutter/material.dart';
import 'package:detector/main.dart';
import 'package:detector/pages/util/various_assets.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context){
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Crop Disease Detection",style: theme.textTheme.titleLarge),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset('images/logo.png', height: 200,),

          Align(
            alignment: Alignment.center,
            child:
             designedButton(context, "Sign In", () {
               if(Provider.of<OnDeviceStorage>(context,listen: false).userAcc.isnull){
                 Navigator.pushNamed(context, '/sign_in');
               }
               else{
                 Navigator.pushNamed(context, '/nav');
               }

             })
          ),

          designedButton(context, "Register", () {
              Navigator.pushNamed(context, '/register');
            }
          ),

          designedButton(context, "Offline", () {
              Navigator.pushNamed(context, '/search');
            }
          ),

          designedButton(context, "Add", () {
            Navigator.pushNamed(context, '/add');
          }
          ),
        ],
      )
    );
  }
}