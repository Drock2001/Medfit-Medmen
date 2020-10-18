import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medfit/Profile.dart';
import 'package:medfit/calorie.dart';
import 'package:medfit/caloriecalculator.dart';
import 'package:medfit/discover.dart';
import 'package:medfit/register.dart';
import 'package:medfit/signincontroller.dart';
import 'package:medfit/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        disabledColor: Colors.white,


        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black54,
          child: Column(
            children: <Widget>[
              Spacer(),
              Center(
                  child: Image.asset(
                    'assets/logo1.png',
                    height: 200,
                  )),

              SizedBox(
                height: 50,
              ),
              Text(
                "MEDFIT",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white),
              ),
              Text(
                "The Health and Fitness App",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    color: Colors.white),
              ),
              Spacer(),
              MaterialButton(
                onPressed: () async {
                  Dialogs.showLoadingDialog(context, _keyLoader);
                  bool res = await AuthProvider().loginwithGoogle();
                  Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                  if(!res)
                    print("error");
                  else{
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Registration()));
                  }
                },
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                elevation: 5,
                height: 50,
                child: Container(
                  width: 100,
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.google),
                    SizedBox(width: 10),
                    Text('Sign-in',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
              ),
                ),
              ),
              Spacer(),
              Center(child: Text(
                  "@The Medmen",
                  style: TextStyle(color: Colors.white,fontSize: 20)
              )),
              Container(height: 10,),
            ],
          ),
      ),
      ),
    );
  }
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10,),
                        Text("Please Wait....",style: TextStyle(color: Colors.green),)
                      ]),
                    )
                  ]));
        });
  }
}
