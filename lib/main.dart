import 'dart:io';

import 'package:detector/pages/add.dart';
import 'package:detector/pages/make_comment.dart';
import 'package:detector/pages/see_post.dart';
import 'package:flutter/material.dart';
import 'package:detector/MongoDb/mongo_work.dart';
import 'package:detector/pages/app_entry.dart';
import 'package:detector/pages/contact_us.dart';
import 'package:detector/pages/help.dart';
import 'package:detector/pages/posts.dart';
import 'package:detector/pages/register.dart';
import 'package:detector/pages/search.dart';
import 'package:detector/pages/settings.dart';
import 'package:detector/pages/sign_in.dart';
import 'package:detector/pages/util/nav.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
export 'package:provider/provider.dart';

class OnDeviceStorage extends ChangeNotifier{

  late File file;

  OnDeviceStorage(File x){
    file = x;
  }

  bool get exists => file.existsSync();

  Account get userAcc{
      if(exists){
        if(file.lengthSync() != 0){
          try{
            String data = file.readAsStringSync();
            Account x = accountFromJson(data);
            return x;
          }catch(_){
          }
        }
      }
      return Account();
  }

  set userAcc(Account x){
    String data = accountToJson(x);
    file.writeAsStringSync(data);
    notifyListeners();
  }

}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  MongoDatabase.connect();
  Directory applicationFiles = await getApplicationDocumentsDirectory();
  File my = File("${applicationFiles.path}/Account.json");

  runApp(ChangeNotifierProvider(create: (context) => OnDeviceStorage(my),
    child: const MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    return MaterialApp(
      title: 'Crop Disease Detection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff8dd691), brightness: brightness),
      ),
      initialRoute: '/',
      routes: {
        '/': (context)=> const AppEntry(),
        '/sign_in' : (context) => const SignIn(),
        '/register' : (context) => const Register(),
        '/search' : (context) => const Search(),
        '/nav': (context) => const Nav(),
        '/posts': (context) => const Posts(),
        '/help' : (context) => const Help(),
        '/contactus': (context) => const ContactUs(),
        '/settings': (context) => const Settings(),
        '/see_post': (context) => const SeePost(),
        '/make_comment': (context) => const MakeComment(),
        '/add': (context) => const Add(),
      },
    );
  }
}