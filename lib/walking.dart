import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:medfit/calorie.dart';
import 'package:medfit/counter.dart';
import 'package:medfit/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class Walking extends StatefulWidget {
  @override
  _WalkingState createState() => _WalkingState();
}

class _WalkingState extends State<Walking> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  String userId;
  String userPhoto;
  String cal = " ";
  String datenow = " ";

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async{
    final DateTime now = DateTime.now();
    datenow = DateFormat('yyyy-MM-dd').format(now);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.getString('id');
    });

  }

  @override
  Widget build(BuildContext context) {
    getUserId();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: MaterialButton(onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Task()));
          },color: Colors.transparent,child: Icon(Icons.arrow_back,color: Colors.white,)),
          backgroundColor: Colors.black,
          title: Text("Walking"),
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
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(userId).collection('Walking').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ListView.builder(
                      itemBuilder: (listContext, index) =>
                          buildItem(snapshot.data.docs[index]),
                      itemCount: snapshot.data.docs.length,
                    );
                  }

                  return Container(
                    height: 10,
                    width: 40,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  buildItem(doc) {
    return Card(

      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Text("Objective: "+doc.get('objective'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Spacer(),
                  Text("created at: "+
                    timeago.format(
                        DateTime.fromMillisecondsSinceEpoch(int.parse(doc.get('id')))),
                  ),

                ],
              ),
              Container(
                height: 10,
              ),
              Text("Duration: "+doc.get('duration') + " min", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Container(
                height: 10,
              ),
              Text("Due date: "+doc.get('duedate'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Container(
                height: 10,
              ),
              Center(
                child: MaterialButton(onPressed: () async{
                  FirebaseFirestore.instance.collection("users").doc(userId).update({
                    "duration": doc.get('duration'),
                  }).catchError((onError){print("error in update");});

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CountDownTimer()));
                },
                  color: Colors.white54,
                  child: Container(
                    width: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.play_arrow, size: 30,),
                        Container(
                          width: 10,
                        ),
                        Text("Start", style: TextStyle(fontSize: 24),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
