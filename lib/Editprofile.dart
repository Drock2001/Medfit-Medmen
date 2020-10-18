import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medfit/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_button/slider_button.dart';
class Editprofile extends StatefulWidget {
  @override
  _EditprofileState createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController fitnessController = TextEditingController();

  GoogleSignIn googleSignIn = GoogleSignIn();
  String userId = " ";
  String age = " ";
  String gender = " ";
  String height = " ";
  String weight = " ";
  String name= " ";
  String fit = " ";
  String bmi = " ";
  String bmr = " ";

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString('id');
    DocumentSnapshot variable = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    print(variable.data()["name"]);
    setState(() {
      name = variable.data()['name'];
      age = variable.data()['age'];
      weight = variable.data()['weight'];
      height = variable.data()['height'];
      fit = variable.data()['fitness'];
      gender = variable.data()['gender'];

      weightController.text = weight;
      heightController.text = height;
      ageController.text = age;
      fitnessController.text = fit;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
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
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Hi, " + name,
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
                  "We hope you achieved your fitness goal!!",
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
                if(ageController.text.isEmpty  ||  weightController.text.isEmpty || heightController.text.isEmpty || fitnessController.text.isEmpty){
                  print("empty");
                  return;
                }
                bmicalculator();
                bmrcalculator();
                FirebaseFirestore.instance.collection("users").doc(userId).update({
                  "age" : ageController.text,
                  "weight" : weightController.text,
                  "height" : heightController.text,
                  "fitness" : fitnessController.text,
                  "bmi" : bmi,
                  "bmr" : bmr,
                }).catchError((onError){print("error in update");});
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              label: Text(
                "Update Data!!",
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
    if(gender == "Male") {
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
