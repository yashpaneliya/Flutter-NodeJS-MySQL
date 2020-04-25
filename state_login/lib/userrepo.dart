import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

enum Status {Unintialized,Authenticated,Authenticating,Unauthenticated}


class UserRepo with ChangeNotifier{
var userid;
  var auth;
  Status st=Status.Unintialized;

  Status get status=>st;
  get id=>userid;

  UserRepo(){
    print('before $userid');
    onAuthStateChanged(userid);
    print('after$userid');
  }
                                                                   
  Future<bool> signIn(String uname,String password) async {
    try{
      print('inside signIn');
      st=Status.Authenticating;
      notifyListeners();
      var response=await http.get('http://10.0.2.2:8000/users/auth/'+uname+'/'+password);
      print('after get');
      if(response.statusCode==200 && response.body!="no user found")
      {
        print('true condition');
        userid=response.body.toString();
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

  Future signOut()async{
    userid=null;
    st=Status.Unauthenticated;
    notifyListeners();
  }

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
}