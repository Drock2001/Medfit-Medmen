import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medfit/discover.dart';
import 'package:medfit/signincontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_button/slider_button.dart';

import 'main.dart';

enum BestTutorSite { Male, Female }

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController fitnessController = TextEditingController();

  BestTutorSite _site;

  GoogleSignIn googleSignIn = GoogleSignIn();
  String userId = " ";
  String name = " ";
  bool isreg = true;
  String bmi = " ";
  String bmr = " ";

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.getString('id');
      name = sharedPreferences.getString('name');
    });
    DocumentSnapshot variable = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    bool userLoggedIn = (variable.data()["age"]??'').isNotEmpty;

    if(userLoggedIn){
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => Discover()));
    }
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Registration"),
          backgroundColor: Colors.black,
          shadowColor: Colors.green[800],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Hi there, " + name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "We just need some details from you to make your experience more comfortable",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: TextField(
                        controller: ageController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Age',
                            labelStyle: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: const Text('Male', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                fontSize: 20),),
                            leading: Radio(
                              value: BestTutorSite.Male,
                              activeColor: Colors.white,
                              groupValue: _site,
                              onChanged: (BestTutorSite value) {
                                setState(() {
                                  _site = value;
                                  genderController.text = "Male";
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Female', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                fontSize: 20),),
                            leading: Radio(
                              value: BestTutorSite.Female,
                              groupValue: _site,
                              activeColor: Colors.white,
                              hoverColor: Colors.white,
                              focusColor: Colors.white,
                              onChanged: (BestTutorSite value) {
                                setState(() {
                                  _site = value;
                                  genderController.text = "Female";
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: TextField(
                        controller: weightController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Weight(in kg)',
                            labelStyle: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: TextField(
                        controller: heightController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Height(in cm)',
                            labelStyle: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: TextField(
                        controller: fitnessController,
                        style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Fitness Goals',
                            labelStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Center(child: SliderButton(
                      action: () {
                        ///Do something here
                        if(ageController.text.isEmpty  || genderController.text.isEmpty|| weightController.text.isEmpty || heightController.text.isEmpty || fitnessController.text.isEmpty){
                          print("empty");
                          return;
                        }
                        bmicalculator();
                        bmrcalculator();
                        FirebaseFirestore.instance.collection("users").doc(userId).update({
                          "age" : ageController.text,
                          "gender" : genderController.text,
                          "weight" : weightController.text,
                          "height" : heightController.text,
                          "fitness" : fitnessController.text,
                          "isregistered" : true,
                          "bmi" : bmi,
                          "bmr" : bmr,
                        }).catchError((onError){print("error in update");});
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Discover()));
                      },
                      label: Text(
                        "Register",
                        style: TextStyle(
                            color: Color(0xff4a4a4a), fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                      icon: Icon(Icons.add, size: 30,),

                    )),
                  ],
                ),
            ),
            ),
          ),
      );
    }
    bmicalculator() {
      double w = double.parse(weightController.text);
      double h = double.parse(heightController.text);
      double b = roundDouble((w*100*100) / (h*h), 2);
      print(b);
      setState(() {
        bmi = b.toString();
      });
    }
    roundDouble(double value, int places) {
        double mod = pow(10.0, places);
        return ((value * mod).round().toDouble() / mod);
    }

    bmrcalculator() {
      double w = double.parse(weightController.text);
      double h = double.parse(heightController.text);
      double a = double.parse(ageController.text);
      double b;
      if(genderController.text == "Male") {
        b = roundDouble(66.47 + (13.75*w) + (5.003*h) - 6.755*a, 2);
      }
      else{
        b = roundDouble(655.1 + (9.563*w) + (1.85*h) - 4.676*a, 2);
      }
      setState(() {
        bmr = b.toString();
      });
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