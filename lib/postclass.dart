import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
class Post{

  static const KEY = "key";
  static const DATE = "date";
  static const TITLE = "title";
  static const AUTHOR = "author";
  static const BODY = "body";
  static const IMAGE = "image";

  int date;
  String key;
  String title;
  String body;
  String author;
  String image;

  Post(this.date, this.title, this.author, this.body, this.image);

//  String get key  => _key;
//  String get date  => _date;
//  String get title  => _title;
//  String get body  => _body;


  Post.fromSnapshot(DataSnapshot snap):
        this.key = snap.key,
        this.body = snap.value[BODY],
        this.date = snap.value[DATE],
        this.author = snap.value[AUTHOR],
        this.title = snap.value[TITLE],
        this.image = snap.value[IMAGE];



  Map toMap(){
    return {BODY: body, TITLE: title, AUTHOR:author, DATE: date,IMAGE: image, KEY: key};
  }
}