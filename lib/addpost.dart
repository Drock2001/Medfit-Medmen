
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:medfit/postclass.dart';
import 'package:medfit/postservice.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final GlobalKey<FormState> formkey = new GlobalKey();
  final GlobalKey<FormState> keyloader = new GlobalKey();
  static File img;
  Post post = Post(0, " ", " ", " ", " ");
  File image = img;
  String uploadFileURL;
  GoogleSignIn googleSignIn = GoogleSignIn();
  String userId = " ";
  String name = " ";

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
        title: Text("Add Post"),
        backgroundColor: Colors.black,
        elevation: 0.0,
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
          child: Form(
              key: formkey,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelText: "Post Title",
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
                      ),
                      onSaved: (val) => post.title = val,
                      validator: (val){
                        if(val.isEmpty){
                          return "title field cant be empty";
                        }else if(val.length > 16){
                          return "title cannot have more than 16 characters ";
                        }
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        child: image == null ? RaisedButton(onPressed: (){chooseFile();},
                          child: Text('Choose Theme Image', style: TextStyle(fontSize: 18),),
                        ):Container(
                          child: AspectRatio(
                              aspectRatio: 5/3,
                              child: Image.file(image, width: 500, height: 300, fit: BoxFit.fill,)),
                        )
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 400,

                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        maxLines: 500,
                        decoration: InputDecoration(
                          hintText: "Post Body",
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        ),
                        onSaved: (val) => post.body = val,
                        validator: (val){
                          if(val.isEmpty){
                            return "body field cant be empty";
                          }
                        },
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        insertPost(context);

        //Navigator.pop(context);
//        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      },

        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.green,
        tooltip: "add a post",),
    );
  }

  void insertPost(context) async{
    final FormState form = formkey.currentState;
    if(form.validate()){
      form.save();
      form.reset();
      post.date = DateTime.now().millisecondsSinceEpoch;
      if(image != img) {
        print(post.date.toString() + '.jpg');
        final StorageReference firebaseStorage = FirebaseStorage.instance.ref()
            .child(post.date.toString() + '.jpg');
        final StorageUploadTask task = firebaseStorage.putFile(image);
        Dialogs.showLoadingDialog(context, keyloader);
        await task.onComplete;
        uploadFileURL = await firebaseStorage.getDownloadURL();
        post.author = name;
        print(uploadFileURL);
        if (uploadFileURL.isNotEmpty) {
          post.image = uploadFileURL;
        }

        Navigator.of(keyloader.currentContext,rootNavigator: true).pop();
      }
      PostService postService = PostService(post.toMap());
      postService.addPost();
      Navigator.pop(context);
    }
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((images) async{
      setState(() {
        image = images;
      });
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
                        Text("Please Wait....",style: TextStyle(color: Colors.green[800]),)
                      ]),
                    )
                  ]));
        });
  }
}