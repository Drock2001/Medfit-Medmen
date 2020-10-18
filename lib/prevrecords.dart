import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:medfit/calorie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrevRecords extends StatefulWidget {
  @override
  _PrevRecordsState createState() => _PrevRecordsState();
}

class _PrevRecordsState extends State<PrevRecords> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  String userId;
  String userPhoto;
  String cal = " ";
  String calo = " ";
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
                MaterialPageRoute(builder: (context) => Calorie()));
          },color: Colors.transparent,child: Icon(Icons.arrow_back,color: Colors.white,)),
          backgroundColor: Colors.black,
          title: Text("Your Previous Records"),
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
                stream: FirebaseFirestore.instance.collection('users').doc(userId).collection('calories').snapshots(),
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
              children: <Widget>[
                Container(
                  height: 5,
                ),
                Center(
                  child: Text("Date: "+doc.get('id'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                Container(
                  height: 10,
                ),
                Center(
                  child: Text("Total Calorie Intake: "+doc.get('cal') + " cal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                ),
                Container(
                  height: 10,
                ),
                Center(
                  child: Text("Total Calorie Burn: "+doc.get('calo') + " cal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                ),
                Container(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      );
  }
}
