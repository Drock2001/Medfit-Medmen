import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medfit/Editprofile.dart';
import 'package:medfit/calorie.dart';
import 'package:medfit/discover.dart';
import 'package:medfit/main.dart';
import 'package:medfit/signincontroller.dart';
import 'package:medfit/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  String userId = " ";
  int created = 0;
  String age = " ";
  String gender = " ";
  String height = " ";
  String weight = " ";
  String bmi = " ";
  String pic= " ";
  String name= " ";
  int bronze;
  int silver;
  int gold;
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
      pic = variable.data()['profile_pic'];
      name = variable.data()['name'];
      age = variable.data()['age'];
      gender = variable.data()['gender'];
      weight = variable.data()['weight'];
      height = variable.data()['height'];
      bmi = variable.data()['bmi'];
      bronze = (double.parse(variable.data()['bronze'])).floor();
      silver = (double.parse(variable.data()['silver'])).floor();
      gold = (double.parse(variable.data()['gold'])).floor();
    });

  }

  Future<void> share() async {
    await FlutterShare.share(
        title: "Medfit Achievements of " + name,
        text: 'We are congratulating '+ name +' to sucessfully achieving: \n' + gold.toString() +' gold\n' + silver.toString() + ' silver\n' + bronze.toString() + ' bronze',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title'
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.black,
        shadowColor: Colors.green[800],
        actions: <Widget>[
          IconButton(icon: Icon(Icons.edit), onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Editprofile()));
          }),
        ],
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Center(child:
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 150,
                      height: 150,
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(pic),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  ),
                  Spacer(),
                ],
              ),
              Container(height: 20,),
              Row(
                children: <Widget>[
                  Spacer(),
                  Text("Name: " + name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),),
                  Spacer(),
                ],
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  Text("Age: " + age, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),),
                  Spacer(),
                ],
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  Text("Weight: " + weight + " kg", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),),
                  Spacer(),
                ],
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  Text("Height: " + height + " cm", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),),
                  Spacer(),
                ],
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  Text("BMI: " + bmi, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),),
                  Spacer(),
                ],
              ),
              Divider(color: Colors.transparent, thickness: 0.5,),

              Container(height: 20,),
              Row(
                children: <Widget>[
                  //Spacer(),
                  Container(width: 20,),
                  Center(
                    child: Text("Achievements: ",
                      style: TextStyle(fontSize: 30.0, color: Colors.white),),
                  ),
                  //Spacer(),
                ],
              ),
              Divider(color: Colors.transparent,),
              Row(
                children: <Widget>[
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.brown[400],
                    ),
                    height: 100,
                    width: 70,
                    child: Center(
                      child: Text(
                        bronze.toString(), style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white70,
                    ),
                    height: 100,
                    width: 70,
                    child: Center(
                      child: Text(
                        silver.toString(), style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.yellowAccent[700],
                    ),
                    height: 100,
                    width: 70,
                    child: Center(
                      child: Text(
                        gold.toString(), style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        onPressed: () {
          share();
        },
        child: Icon(Icons.share),
      ),
    );
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
                      style: TextStyle(color: Colors.green[800], fontSize: 22, fontWeight: FontWeight.bold),
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
            onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Discover())),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.calculate),
            title: Text('Calorie meter'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => Calorie())),
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