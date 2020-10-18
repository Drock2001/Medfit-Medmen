import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medfit/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_button/slider_button.dart';

class Addtask extends StatefulWidget {
  @override
  _AddtaskState createState() => _AddtaskState();
}

enum Taskmode {Walking, Running, Cycling, Swimming}

class _AddtaskState extends State<Addtask> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final TextEditingController objectiveController = TextEditingController();
  final TextEditingController modeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController duedateController = TextEditingController();

  GoogleSignIn googleSignIn = GoogleSignIn();
  String userId = " ";
  String name = " ";
  bool isreg = true;
  String bmi = " ";
  String bmr = " ";
  String createdat = " ";

  Taskmode _site;

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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
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
                  "Doing exercise is best way to achieve goal\nAdd some tasks here",
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
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('Walking', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                            fontSize: 20),),
                        leading: Radio(
                          value: Taskmode.Walking,
                          activeColor: Colors.white,
                          groupValue: _site,
                          onChanged: (Taskmode value) {
                            setState(() {
                              _site = value;
                              modeController.text = "Walking";
                            });
                          },
                        ),
                      ),

                      ListTile(
                        title: const Text('Running', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                            fontSize: 20),),
                        leading: Radio(
                          value: Taskmode.Running,
                          activeColor: Colors.white,
                          groupValue: _site,
                          onChanged: (Taskmode value) {
                            setState(() {
                              _site = value;
                              modeController.text = "Running";
                            });
                          },
                        ),
                      ),

                      ListTile(
                        title: const Text('Cycling', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                            fontSize: 20),),
                        leading: Radio(
                          value: Taskmode.Cycling,
                          activeColor: Colors.white,
                          groupValue: _site,
                          onChanged: (Taskmode value) {
                            setState(() {
                              _site = value;
                              modeController.text = "Cycling";
                            });
                          },
                        ),
                      ),

                      ListTile(
                        title: const Text('Swimming', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                            fontSize: 20),),
                        leading: Radio(
                          value: Taskmode.Swimming,
                          activeColor: Colors.white,
                          groupValue: _site,
                          onChanged: (Taskmode value) {
                            setState(() {
                              _site = value;
                              modeController.text = "Swimming";
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
                    controller: objectiveController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        labelText: 'Objective',
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
                    controller: durationController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        labelText: 'Duration(in mins(numbers only))',
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
                    controller: duedateController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        labelText: 'Due Date (yyyy/mm/dd)',
                        labelStyle: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        border: InputBorder.none),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Center(child: SliderButton(
                  action: () {
                    ///Do something here
                    createdat = (DateTime.now().millisecondsSinceEpoch).toString();
                    if(modeController.text.isEmpty  || objectiveController.text.isEmpty|| duedateController.text.isEmpty || durationController.text.isEmpty){
                      print("empty");
                      return;
                    }
                    FirebaseFirestore.instance.collection("users").doc(userId).collection(modeController.text).doc(createdat).set({
                      "id": createdat,
                      "objective": objectiveController.text,
                      "duration": durationController.text,
                      "duedate": duedateController.text,
                    }).catchError((onError){print("error in update");});
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Task()));
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
}
