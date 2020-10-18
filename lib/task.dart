import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medfit/Addtask.dart';
import 'package:medfit/Profile.dart';
import 'package:medfit/calorie.dart';
import 'package:medfit/cycling.dart';
import 'package:medfit/discover.dart';
import 'package:medfit/main.dart';
import 'package:medfit/running.dart';
import 'package:medfit/signincontroller.dart';
import 'package:medfit/swimming.dart';
import 'package:medfit/walking.dart';

class Task extends StatefulWidget {
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Tasks"),
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
              Spacer(),
              Row(
                children: <Widget>[
                  Spacer(),
                  Container(
                    height: 220,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      onTap: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => Walking()));
                      },
                      subtitle: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.directions_walk,
                          size: 120,
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Walking", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 220,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: ListTile(

                      onTap: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => Running()));
                      },
                      subtitle: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.directions_run,
                          size: 120,
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Running", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
              Container(
                height: 50,
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  Container(
                    height: 220,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: ListTile(

                      onTap: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => Cycling()));
                      },
                      subtitle: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          FontAwesomeIcons.bicycle,
                          size: 100,
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Cycling", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 220,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: ListTile(

                      onTap: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => Swimming()));
                      },
                      subtitle: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          FontAwesomeIcons.swimmer,
                          size: 100,
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text("Swimming", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Addtask()));
        },
        child: Icon(Icons.add),
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
                      style: TextStyle(color: Colors.cyan[800], fontSize: 22, fontWeight: FontWeight.bold),
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
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => Calorie())),
          ),
          ListTile(
            leading: Icon(Icons.work),
            title: Text('Task'),
            onTap: () => {},
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
