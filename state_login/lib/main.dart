import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:state_login/apiprovider/user_api.dart';
import 'package:state_login/homepage.dart';
import 'package:state_login/pages/login_2.dart';
import 'models/users.dart';
import 'notifiers/auth_notifier.dart';

// void main()=>runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => UserRepo(),
//       child: Consumer(
//         builder: (context,UserRepo user,_){
//           //switch case to display UI Pages according to states
//           switch(user.status){
//             case Status.Unintialized:
//               return Splash();
//             case Status.Unauthenticated:
//             case Status.Authenticating:
//               return LoginPage();
//             case Status.signupauthenticating:
//             case Status.notsignedup:
//               return SignUpPage();
//             case Status.signedup:
//               return Task(id: user.id,);
//             case Status.Authenticated:
//               return Task(id: user.id);
//           }
//         } 
//       ),
//     );
//   }
// }



void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          // builder: (context) => AuthNotifier(),
          create: (BuildContext context) {
            return AuthNotifier();
          },
        ),
        // ChangeNotifierProvider(
        //   builder: (context) => BookNotifier(),
        //   create : (BuildContext context){
        //     return BookNotifier();
        //   },
        // )
      ],
      child: TaskApp(),
    ));
}

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(     
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
            appBarTheme: AppBarTheme(
              brightness: Brightness.light,
              elevation: 5,
              color: ThemeData.light().canvasColor,
            )
        ),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          return notifier.user != null ? Task(id: notifier.user,) : Login();
        },
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

// class Task extends StatelessWidget {
//   final id;

//   const Task({Key key, this.id}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     AuthNotifier auth=Provider.of<AuthNotifier>(context);
//     return Scaffold(
//       appBar: AppBar(title: Text('Tasks'),),
//       body: Column(
//         children: <Widget>[
//           Center(child:Text('$id')),
//           RaisedButton(onPressed: () => signout(auth),)
//         ],
//       ),
//     );
//   }
// }