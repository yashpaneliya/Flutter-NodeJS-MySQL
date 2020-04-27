import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

enum Status {Unintialized,Authenticated,Authenticating,Unauthenticated,signupauthenticating,signedup,notsignedup}

class UserRepo with ChangeNotifier{
var userid;
  var auth;
  Status st=Status.Unintialized; //initial status

  Status get status=>st;
  get id=>userid;

//constructor
  UserRepo(){
    print('before $userid');
    onAuthStateChanged(userid);
    print('after$userid');
  }

  //function to login a user.                        
  Future<bool> signIn(String uname,String password) async {
    try{
      print('inside signIn');
      st=Status.Authenticating;
      notifyListeners();
      var response=await http.get('http://10.0.2.2:8000/users/auth/'+uname+'/'+password); //calling the api to get id of user
      print('after get');
      if(response.statusCode==200 && response.body!="no user found")
      {
        //true if user loggedin successfully
        print('true condition');
        userid=response.body.toString(); // storing the id to variable->userid
        print(response.body.toString());
        st=Status.Authenticated;
        notifyListeners();
        return true;
      }
      else
      {
        st=Status.Unauthenticated;
        notifyListeners();
        print('false condition');
        return false;
      }
    }catch(e){
      print(e);
    }
  }

//logout function
  Future signOut()async{
    userid=null;
    st=Status.Unauthenticated;
    notifyListeners();
  }

//this function is passed in UserRepo() constructor to check whether a user already loggedin or not at 
//starting of the app. See at starting of class in this file
  Future<void> onAuthStateChanged(var id)async{
    print('inside onauth');
    if(id==null){
      userid=null;
      print('null');
      st=Status.Unauthenticated;
    }
    else{
      print('notnull');
      userid=id;
      print('$id $userid');
      st=Status.Authenticated;
    }
    notifyListeners();
  } 

//function to register a new user
  Future<bool> signup(String id,String name,String mail,String phone, String password)async{
    st=Status.signupauthenticating;
    notifyListeners();
    try{
      var map={
        "id":id,
        "username":name,
        "lastname":name,
        "mail":mail,
        "number":phone,
        "password":password
      };
      print(map);
      print(jsonEncode(map));
      var response=await http.post('http://10.0.2.2:8000/users/input/$id',body: jsonEncode(map));//calling api to store data of new user
      if(response.statusCode==200 && response.body=="user saved"){
        //true if user registered successfully
        userid=id;
        st=Status.signedup;
        notifyListeners();
        return true;
      }
      else{
        st=Status.notsignedup;
        notifyListeners();
        return false;
      }
    }
    catch(e){
      print(e);
    }
  }
}