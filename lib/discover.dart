import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:medfit/Profile.dart';
import 'package:medfit/addpost.dart';
import 'package:medfit/calorie.dart';
import 'package:medfit/main.dart';
import 'package:medfit/postclass.dart';
import 'package:medfit/postservice.dart';
import 'package:medfit/signincontroller.dart';
import 'package:medfit/task.dart';
import 'package:medfit/viewPost.dart';
import 'package:timeago/timeago.dart' as timeago;

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String nodeName = "posts";
  List<Post> postsList = <Post>[];

  @override
  void initState() {
    _database.reference().child(nodeName).onChildAdded.listen(_childAdded);
    _database.reference().child(nodeName).onChildRemoved.listen(_childRemoves);
    _database.reference().child(nodeName).onChildChanged.listen(_childChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
        appBar: AppBar(
          title: Text("Discover"),
          backgroundColor: Colors.black,
          shadowColor: Colors.green[800],
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
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
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: postsList.isEmpty,
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                Visibility(
                  visible: postsList.isNotEmpty,
                  child: Flexible(
                      child: FirebaseAnimatedList(
                          query: _database.reference().child('posts'),
                          itemBuilder: (_, DataSnapshot snap,
                              Animation<double> animation, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: ListTile(
                                  title: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PostView(postsList[index])));
                                    },
                                    title: Text(
                                      postsList[index].title,
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      "by: " + postsList[index].author,
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.black),
                                    ),
                                    trailing: Text(
                                      timeago.format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              postsList[index].date)),
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.grey),
                                    ),
                                  ),
                                  subtitle: Column(
                                    children: <Widget>[
                                      Container(
                                        child: AspectRatio(
                                            aspectRatio: 5 / 3,
                                            child:
                                            (postsList[index].image != " ")
                                                ? Image.network(
                                              postsList[index].image,
                                              fit: BoxFit.fill,
                                              width: 500,
                                              height: 300,
                                            )
                                                : Image.asset(
                                              'images/na.jpg',
                                              fit: BoxFit.fill,
                                              width: 500,
                                              height: 300,
                                            )),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              RaisedButton.icon(onPressed: () {}, icon: Icon(Icons.thumb_up, color: Colors.green[800] ), label: Text("Like") ,color: Colors.white,),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              RaisedButton.icon(onPressed: () {}, icon: Icon(Icons.comment, color: Colors.green[800] ), label: Text("Comment") ,color: Colors.white,),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              RaisedButton.icon(onPressed: () {}, icon: Icon(Icons.share, color: Colors.green[800] ), label: Text("Share") ,color: Colors.white,),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green[700],
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddPost()));
          },
          child: Icon(Icons.add),
        ),
    );
  }
  _childAdded(Event event) {
    setState(() {
      postsList.add(Post.fromSnapshot(event.snapshot));
    });
  }

  void _childRemoves(Event event) {
    var deletedPost = postsList.singleWhere((post) {
      return post.key == event.snapshot.key;
    });

    setState(() {
      postsList.removeAt(postsList.indexOf(deletedPost));
    });
  }

  void _childChanged(Event event) {
    var changedPost = postsList.singleWhere((post) {
      return post.key == event.snapshot.key;
    });

    setState(() {
      postsList[postsList.indexOf(changedPost)] =
          Post.fromSnapshot(event.snapshot);
    });
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
            onTap: () => {},
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