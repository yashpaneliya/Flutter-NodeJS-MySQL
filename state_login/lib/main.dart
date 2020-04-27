import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_login/login.dart';
import 'package:state_login/signup.dart';
import 'package:state_login/userrepo.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserRepo(),
      child: Consumer(
        builder: (context,UserRepo user,_){
          //switch case to display UI Pages according to states
          switch(user.status){
            case Status.Unintialized:
              return Splash();
            case Status.Unauthenticated:
            case Status.Authenticating:
              return LoginPage();
            case Status.signupauthenticating:
            case Status.notsignedup:
              return SignUpPage();
            case Status.signedup:
              return Task(id: user.id,);
            case Status.Authenticated:
              return Task(id: user.id);
          }
        } 
      ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Splash Screen"),
      ),
    );
  }
}

class Task extends StatelessWidget {
  final id;

  const Task({Key key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasks'),),
      body: Column(
        children: <Widget>[
          Center(child:Text('$id')),
          RaisedButton(onPressed: () => Provider.of<UserRepo>(context,listen: false).signOut(),)
        ],
      ),
    );
  }
}