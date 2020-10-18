import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medfit/calorie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CalorieCalculator extends StatefulWidget {
  @override
  _CalorieCalculatorState createState() => _CalorieCalculatorState();
}

class _CalorieCalculatorState extends State<CalorieCalculator> {
  GlobalKey A;
  GlobalKey B;
  int apple = 0;
  int banana = 0;
  int rice = 0;
  int chapati = 0;
  int egg = 0;
  int calorie = 0;
  String userId = " ";
  String datenow = " ";
  String date = " ";
  String cal = " ";

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    final DateTime now = DateTime.now();
    print(now);
    datenow = DateFormat('yyyy-MM-dd').format(now);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString('id');
    DocumentSnapshot variable = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    DocumentSnapshot vard = await FirebaseFirestore.instance.collection('users').doc(userId).collection('calories').doc(datenow).get();
    setState(() {
      cal = vard.data()["cal"];
    });
    print(variable.data()["name"]);
    print(datenow);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calorie Intake = " + calorie.toString() + " cal"),
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
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text("Apple(per pcs)", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, ),),
                      Spacer(),
                      MaterialButton(
                        key: A,
                        minWidth: 10,
                        onPressed: (){
                          setState(() {
                            apple = apple + 1;
                            calorie = calorie + 95;
                          });
                        },
                        child: Icon(Icons.add,),
                        color: Colors.green[800],

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        key: A,
                        minWidth: 10,
                        onPressed: (){
                          setState(() {
                            if(apple > 0){
                              apple = apple - 1;
                              calorie = calorie - 95;
                            }
                          });
                        },
                        child: Icon(Icons.remove,),
                        color: Colors.red,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(apple.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, ),),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text("Banana(per pcs)", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, ),),
                      Spacer(),
                      MaterialButton(
                        key: B,
                        minWidth: 10,
                        onPressed: (){
                          setState(() {
                            banana = banana + 1;
                            calorie = calorie + 105;
                          });
                        },
                        child: Icon(Icons.add,),
                        color: Colors.green[800],

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        key: B,
                        minWidth: 10,
                        onPressed: (){
                          if(banana > 0){
                            setState(() {
                              banana = banana - 1;
                              calorie = calorie - 105;
                            });
                          }
                        },
                        child: Icon(Icons.remove,),
                        color: Colors.red,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(banana.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, ),),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text("Rice(100g)", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, ),),
                      Spacer(),
                      MaterialButton(
                        minWidth: 10,
                        onPressed: (){
                          setState(() {
                            rice = rice + 1;
                            calorie = calorie + 130;
                          });
                        },
                        child: Icon(Icons.add,),
                        color: Colors.green[800],

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        minWidth: 10,
                        onPressed: (){
                          if(rice > 0){
                            setState(() {
                              rice = rice - 1;
                              calorie = calorie - 130;
                            });
                          }
                        },
                        child: Icon(Icons.remove,),
                        color: Colors.red,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(rice.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, ),),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text("Chapati(per pcs)", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, ),),
                      Spacer(),
                      MaterialButton(
                        minWidth: 10,
                        onPressed: (){
                          setState(() {
                            chapati = chapati + 1;
                            calorie = calorie + 104;
                          });
                        },
                        child: Icon(Icons.add,),
                        color: Colors.green[800],

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        minWidth: 10,
                        onPressed: (){
                          if(chapati > 0){
                            setState(() {
                              chapati = chapati - 1;
                              calorie = calorie - 104;
                            });
                          }
                        },
                        child: Icon(Icons.remove,),
                        color: Colors.red,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(chapati.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, ),),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text("Egg(per pcs)", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, ),),
                      Spacer(),
                      MaterialButton(
                        minWidth: 10,
                        onPressed: (){
                          setState(() {
                            egg = egg + 1;
                            calorie = calorie + 72;
                          });
                        },
                        child: Icon(Icons.add,),
                        color: Colors.green[800],

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        minWidth: 10,
                        onPressed: (){
                          if(egg > 0){
                            setState(() {
                              egg = egg - 1;
                              calorie = calorie - 72;
                            });
                          }
                        },
                        child: Icon(Icons.remove,),
                        color: Colors.red,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(egg.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, ),),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green[700],
        onPressed: (){
          calc();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Calorie()));
        },
      ),
    );
  }
  calc() async {
    final result = (await FirebaseFirestore.instance.collection('users').doc(userId).collection('calories').where('id', isEqualTo: datenow).get()).docs;

    FirebaseFirestore.instance.collection('users').doc(userId).collection('calories').doc(datenow).update({
      'cal' : (double.parse(cal)+calorie).toString(),
    });

  }
}
