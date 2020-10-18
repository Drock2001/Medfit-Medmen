import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:medfit/Profile.dart';
import 'package:medfit/caloriecalculator.dart';
import 'package:medfit/discover.dart';
import 'package:medfit/main.dart';
import 'package:medfit/prevrecords.dart';
import 'package:medfit/signincontroller.dart';
import 'package:medfit/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calorie extends StatefulWidget {
  @override
  _CalorieState createState() => _CalorieState();
}

class _CalorieState extends State<Calorie> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  String userId = " ";
  String bmr = " ";
  String name= " ";
  String datenow = " ";
  String cal = " ";
  String calo = " ";
  bool New = true;
  DocumentSnapshot calc;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    Dialogs.showLoadingDialog(context, _keyLoader);

    final DateTime now = DateTime.now();
    datenow = DateFormat('yyyy-MM-dd').format(now);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString('id');
    DocumentSnapshot variable = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    print(variable.data()["name"]);
    setState(() {
      name = variable.data()['name'];
      bmr = variable.data()['bmr'];
    });
    //DocumentSnapshot vard = await FirebaseFirestore.instance.collection('users').doc(userId).collection('calories').doc(datenow).get();
    /*
    if(vard.data()["id"].isnotEmpty){
      setState(() {
        New = false;
      });
    }

     */
    final res = (await FirebaseFirestore.instance.collection('users').doc(userId).collection('calories').where('id', isEqualTo: datenow).get()).docs;
    print(res.length);
    if(res.length == 0){
      FirebaseFirestore.instance.collection('users').doc(userId).collection('calories').doc(datenow).set({
        'id': datenow.toString(),
        'cal': "0",
        'calo' : "0",
      });
    }
    documenter();
    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
  }
  documenter() async{
    DocumentSnapshot vard = await FirebaseFirestore.instance.collection('users').doc(userId).collection('calories').doc(datenow).get();
    setState(() {
      cal = vard.data()["cal"];
      calo = vard.data()["calo"];
    });
  }
  @override
  Widget build(BuildContext context) {
    documenter();
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Calorie Intake"),
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
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              Text("Hi, " + name,style: TextStyle(color: Colors.white, fontSize: 24),),
              SizedBox(height: 30,),
              Text("The Table shown down below is just for choose calories intake according to your exercise routine!!",
                style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,),
              SizedBox(height: 30,),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(4),
                      1: FlexColumnWidth(1)
                    },
                    children: [
                      TableRow(children: [
                        Text(
                          "No Exercise", style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.2,
                        ),
                        Text(calorieintake(1.2),style: TextStyle(color: Colors.white), textScaleFactor: 1.2),
                      ]),
                      TableRow(children: [
                        Text(
                          "Little Exercise", style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.2,
                        ),
                        Text(calorieintake(1.375),style: TextStyle(color: Colors.white), textScaleFactor: 1.2),
                      ]),
                      TableRow(
                          children: [
                        Text(
                          "Moderate Exercise(3-5 days/wk)", style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.2,
                        ),
                        Text(calorieintake(1.55),style: TextStyle(color: Colors.white), textScaleFactor: 1.2),
                      ]),
                      TableRow(children: [
                        Text(
                          "Very Active(6-7 days/wk)", style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.2,
                        ),
                        Text(calorieintake(1.725),style: TextStyle(color: Colors.white), textScaleFactor: 1.2),
                      ]),
                      TableRow(children: [
                        Text(
                          "Hardcore", style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.2,
                        ),
                        Text(calorieintake(1.9),style: TextStyle(color: Colors.white), textScaleFactor: 1.2),
                      ]),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text("Today's Calorie Intake: " + calchecker(cal) + " cal",style: TextStyle(color: Colors.white, fontSize: 22),),
              SizedBox(height: 30,),
              Text("Today's Calorie Burn: " + calchecker(calo) + " cal",style: TextStyle(color: Colors.white, fontSize: 22),),
              SizedBox(height: 30,),
              MaterialButton(onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CalorieCalculator()));
              },
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                elevation: 5,
                height: 50,
                child: Container(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Calorie Calculator',
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30,),
              MaterialButton(onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PrevRecords()));
              },
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                elevation: 5,
                height: 50,
                child: Container(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Previous Records',
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  calchecker(cali) {
    if(cali.isEmpty){
      return "0";
    }
    else {
        return cali;
      }
  }
  calorieintake(value) {
    double cal = roundDouble(double.parse(bmr) * value, 2);
    return cal.toString();
  }

  roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: [
                Spacer(),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/logo1.png'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: <Widget>[
                    Spacer(),
                    Text(
                      'MEDFIT',
                      style: TextStyle(
                          color: Colors.green[800],
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                  ],
                ),
                Spacer(),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
          ),
          ListTile(
            leading: Icon(Icons.rss_feed),
            title: Text('Discover'),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Discover())),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => Profile())),
          ),
          ListTile(
            leading: Icon(Icons.calculate),
            title: Text('Calorie meter'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.work),
            title: Text('Task'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => Task())),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }

  logout(context) {
    AuthProvider().logOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MyApp(),
      ),
      (route) => false,
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
