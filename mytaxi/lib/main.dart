import 'package:flutter/material.dart';
import 'package:mytaxi/app/landing_page.dart';
import 'package:mytaxi/app/locator.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(ChangeNotifierProvider(
      create: (_)=>UserModel(),
      child: App()));
}

class App extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      title:"myTaxi",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      home: LandingPage(),
    );
  }
}


