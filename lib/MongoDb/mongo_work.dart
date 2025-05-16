import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static late DbCollection userCollection;
  static bool isConnected = false;
  static Object? dbError;

  ///Repeatedly try to connect to the MongoAtlas servers.
  ///On error encountered dbError Object is set to the value of the error.
  static Future<void> connect() async{
    const mongoConnUrl = "mongodb+srv://ishangh64:M6HMC~52pj@cluster0.f1b4s.mongodb.net/Project?retryWrites=true&w=majority&appName=Cluster0";
    const usrColl= "ProjectData";
    try{
      while(!isConnected){
        Db db = await Db.create(mongoConnUrl);
        await db.open();
        userCollection = db.collection(usrColl);
        isConnected = true;
      }
    }catch(e){
      dbError = e;
    }
  }

  ///Inserts  abstract [DbObject] into the database.
  static Future<void> insertToDb(DbObject data) async{
    try{
      var result = await userCollection.insertOne(data.toJson());
      if(result.isFailure){
        throw "Data insertion error.";
      }
    }catch(e){
      rethrow;
    }
  }

  ///Gets a single Bson object from database
  static Future<Map<String, dynamic>?> getFromDbOne(Map<String, dynamic> args) async{
    try{
      Map<String, dynamic>? result = await userCollection.findOne(args);
      return result;
    }catch(e){
      rethrow;
    }
  }

  ///Gets a List of Bson objects from database satisfying [selector] conditions
  static Future<List<Map<String, dynamic>>> getFromDb(dynamic selector) async{
    try{
      List<Map<String, dynamic>> result = await userCollection.find(selector).toList();
      return result;
    }catch(e){
      rethrow;
    }
  }

  static Future<void> replaceOneToDb(dynamic selector, dynamic update) async{
    try{
      var result = await userCollection.replaceOne(selector,update);
      if(result.isFailure){
        throw "Data modification error";
      }
    }catch(e){
      rethrow;
    }
  }
}

///An abstract class to represent all database objects
abstract class DbObject{

  ///turns the respective [DbObject] child object into format suitable for insertion into Db.
  Map<String, dynamic> toJson() => {};

}

///A class containing the information of a single user
///I know this is bad. The database was originally only supposed to store [Diseases].
///Accounts, posts, comments unfortunately had to be bodged together.
Account accountFromJson(String str) => Account.fromJson((json.decode(str)));
String accountToJson(Account data) => json.encode(data.toJson());

class Account extends DbObject{
  String? accountId;
  String? firstname;
  String? middlename;
  String? lastname;
  String? email;
  String? password;
  File? pfp;

  bool isnull;

  Account({
    this.accountId,
    this.firstname,
    this.middlename,
    this.lastname,
    this.email,
    this.password,
    this.pfp,
    this.isnull = true
  });

  factory Account.fromJson(Map<String, dynamic>? json) {
    if(json == null) return Account();
    ///to store as bindata in mongodb
    File? temp;
    try {
      if (json["pfp"] != null) {
        temp = File("${Directory.systemTemp.path}/${ObjectId()}");
        temp.writeAsBytesSync(base64Decode(json["pfp"]));
      }
    }catch(e){
      temp = null;
    }


  Account x = Account(
    accountId: json["accountId"],
    firstname: json["firstname"],
    middlename: json["middlename"],
    lastname: json["lastname"],
    email: json["email"],
    pfp: temp,
    password: json["password"],
    isnull: false
    );

    return x;
  }

  @override
  Map<String, dynamic> toJson() => {
    "accountId": accountId,
    "firstname": firstname,
    "middlename": middlename,
    "lastname": lastname,
    "email": email,
    "password": password,
    ///to read from bindata from mongodb
    "pfp": pfp == null
      ? null
      : base64Encode(pfp!.readAsBytesSync()),
  };

  String get userName {
    return [firstname, middlename, lastname].where((e) => e != null && e.isNotEmpty).join(" ");
  }

  Widget get profileImage => pfp==null
      ?const Icon(Icons.person,size: 40,)
      :Image.file(pfp!, height: 40,);

  static String _hashPassword(String pw) => sha256.convert(utf8.encode(pw)).toString();

  ///inserts a [Account] with the given information into the database
  static Future<void> insertAccount(String? firstName, String? middleName, String? lastName, String emailAddress, String password, File? img) async{
    Account check = Account.fromJson(await MongoDatabase.getFromDbOne({"email": emailAddress, "password": _hashPassword(password)}));
    if(check.isnull){
      var id_ = ObjectId().toJson();
      final data = Account(accountId: id_, firstname: firstName,middlename: middleName, lastname: lastName, email: emailAddress,password: _hashPassword(password), pfp: img);
      try{
        await MongoDatabase.insertToDb(data);
        }catch(e){
        rethrow;
     }
    }
    else{
      throw "This account already exists!";
    
    }
  }

  static Future<void> modifyAccount(Account a) async{
    try {
      if (a.accountId == null) throw "Account doesnt exist";
      if(a.password == null) throw "Pw is null";
      a.password = _hashPassword(a.password!);
      Account check = await retreiveAccountoi(a.accountId!);
      if (check.isnull) return;
      await MongoDatabase.replaceOneToDb(
          where.eq('accountId', a.accountId), a.toJson());
    }catch(e){
      rethrow;
    }
  }

  ///retreives a [Account] with the given [emailAddress] and [password]
  static Future<Account> retreiveAccountep(String emailAddress, String password) async{
    Account val = Account();
    try{
      val = Account.fromJson(await MongoDatabase.getFromDbOne({"email": emailAddress, "password": _hashPassword(password)}));
    }catch(e){
      rethrow;
    }
    return val;
  }

  ///retreives a [Account] with the given [accountId]
  static Future<Account> retreiveAccountoi(String accountId) async{
    Account val = Account();
    try{
      val = Account.fromJson(await MongoDatabase.getFromDbOne({"accountId": accountId}));
    }catch(e){
      rethrow;
    }
    return val;
  }

}

Post postFromJson(String str) => Post.fromJson(json.decode(str));
String postToJson(Post data) => json.encode(data.toJson());

///An object containing the information of a single post
class Post extends DbObject{
  String? postId;
  String? accountId;
  String? pdescription;
  String? ptitle;
  File? pimg;

  bool isnull;


  Post({
    this.postId,
    this.accountId,
    this.pdescription,
    this.ptitle,
    this.pimg,
    this.isnull = true
  });

  factory Post.fromJson(Map<String, dynamic>? json){
    Post x = Post();

    if(json != null){
      File? temp;
      if(json["pimg"]!=null){
        temp = File("${Directory.systemTemp.path}/${ObjectId()}");
        temp.writeAsBytes(base64Decode(json["pimg"]));
      }
      x = Post(
      postId: json["postId"],
      accountId: json["accountId"],
      pdescription: json["pdescription"],
      ptitle: json["ptitle"],
      pimg: temp,
      isnull: false
      );
    }
    return x;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String,dynamic> json = {
    "postId": postId,
    "accountId": accountId,
    "pdescription": pdescription,
    "ptitle": ptitle,
    "pimg": pimg==null?null:base64Encode((pimg?.readAsBytesSync())!),
    };
    return json;
  }

  Widget? get postImage => pimg==null
      ? null
      :Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Image.file(pimg!),
        ),
      );

  ///insert a [Post] with the given information into the database
  static Future<void> insertPost(String? accountid, String description, String title, File? image) async{
    var piid = ObjectId().toJson();
    final data = Post(postId: piid, accountId: accountid,pdescription: description, ptitle: title, pimg: image);
    try{
      await MongoDatabase.insertToDb(data);
    }catch(e){
      rethrow;
    }
  }

  ///returns a list of 5 random [Post]s
  static Future<List<Post>> retreivePostList() async{
    List<Map<String, dynamic>> val =[];
    List<Post> result = [];

    try{
      val = await MongoDatabase.getFromDb(where.exists('ptitle').limit(5));
    }catch(e){
      rethrow;
    }

    for(Map<String, dynamic> element in val){
      result.add(Post.fromJson(element));
    }

    return result;
  }

}

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));
String commentToJson(Comment data) => json.encode(data.toJson());

///An object representing a comment
class Comment extends DbObject{
  String? commentId;
  String? postId;
  String? accountId;
  String? cdescription;
  bool isnull;

  Comment({
    this.commentId,
    this.postId,
    this.accountId,
    this.cdescription,
    this.isnull = true,
  });

  factory Comment.fromJson(Map<String, dynamic>? json) { 
    Comment c = Comment();
    if(json != null){
      Comment(
        commentId: json["commentId"],
        postId: json["postId"],
        accountId: json["accountId"],
        cdescription: json["cdescription"],
        isnull: false
      );
    }
    return c;
  }

  @override
  Map<String, dynamic> toJson() => {
    "commentId": commentId,
    "postId": postId,
    "accountId": accountId,
    "cdescription": cdescription,
  };

  ///inserts a [Comment] into the database
  static Future<void> insertComment( String id_, String piid, String desc) async{
    var ciid = ObjectId().toJson();
    final data = Comment(commentId: ciid, accountId: id_, postId: piid,cdescription: desc);
    try{
      MongoDatabase.insertToDb(data);
    }catch(e){
      rethrow;
    }
  }

  static Future<List<Comment>> retreiveCommentap(String accountId, String postId) async{
    List<Comment> val = [];
    try{
      var x = await MongoDatabase.getFromDb({"accountId": accountId, "postId": postId});
      for(var y in x){
        val.add(Comment.fromJson(y));
      }
    }catch(e){
      rethrow;
    }
    return val;
  }

}

Disease diseaseFromJson(String str) => Disease.fromJson(json.decode(str));
String diseaseToJson(Disease data) => json.encode(data.toJson());
class Disease extends DbObject {
  String? dname;
  int? jsonId;
  String? ddescription;
  File? dimg;
  String? soln;
  bool isnull;

  @override
  String toString() {
    return "$dname";
  }
  
  Disease({
    this.dname,
    this.jsonId,
    this.ddescription,
    this.dimg,
    this.soln,
    this.isnull= true,
  });

  factory Disease.fromJson(Map<String, dynamic>? json) {
    Disease d = Disease();
    File? temp;

    if(json != null){
      if(json["dimg"]!=null){
        temp = File("${Directory.systemTemp.path}/${ObjectId()}");
        temp.writeAsBytes(base64Decode(json["dimg"]));
      }
      d =  Disease(
        dname: json["dname"],
        jsonId: json["jsonId"],
        ddescription: json["ddescription"],
        dimg: temp,
        soln: json["soln"],
        isnull: false
      );
    }
    return d;
  }

  @override
  Map<String, dynamic> toJson() => {
    "dname": dname,
    "jsonId": jsonId,
    "ddescription": ddescription,
    "dimg": dimg==null?null:base64Encode((dimg?.readAsBytesSync())!),
    "soln": soln
  };

  @override
  bool operator ==(Object other) => other is Disease && other.dname == dname;

  @override
  int get hashCode => dname.hashCode;

  Widget? get diseaseImage => dimg==null
      ? null
      :Image.file(dimg!, height: 40,);

  static Future<Disease> retreiveDisease(int jsonId) async{
    Disease val = Disease();
    try{
      val = Disease.fromJson(await MongoDatabase.getFromDbOne({"jsonId": jsonId}));
      return val;
    }catch(e){
      rethrow;
    }
  }

  static Future<void> enterNewDisease(Disease d) async{
    try{
      MongoDatabase.insertToDb(d);
    }catch(e){
      rethrow;
    }
  }

}