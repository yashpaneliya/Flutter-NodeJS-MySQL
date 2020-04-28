// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:state_login/userrepo.dart';

// class SignUpPage extends StatefulWidget {
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {

//   TextEditingController t1=TextEditingController();
//   TextEditingController t2=TextEditingController();
//   TextEditingController t3=TextEditingController();
//   TextEditingController t4=TextEditingController();
//   TextEditingController t5=TextEditingController();

//   final formkey=GlobalKey<FormState>();
//   final _key=GlobalKey<ScaffoldState>();
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserRepo>(context);
//     return Scaffold(
//       key: _key,
//       appBar: AppBar(
//         title: Text('Sign up'),
//       ),
//       body: Form(
//         key: formkey,
//         child: Column(
//           children: [
//             TextFormField(
//               controller: t1,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: 'ID'),
//             ),
//             TextFormField(
//               controller: t2,
//               decoration: InputDecoration(labelText: 'NAME'),
//             ),
//             TextFormField(
//               controller: t3,
//               keyboardType: TextInputType.emailAddress,
//               decoration: InputDecoration(labelText: 'MAIL'),
//             ),
//             TextFormField(
//               controller: t4,
//               keyboardType: TextInputType.phone,
//               decoration: InputDecoration(labelText: 'PHONE'),
//             ),
//             TextFormField(
//               controller: t5,
//               keyboardType: TextInputType.visiblePassword,
//               decoration: InputDecoration(labelText: 'PASSWORD'),
//             ),

//             (user.status==Status.signupauthenticating)?CircularProgressIndicator() 
//             : RaisedButton(
//               onPressed: ()async{
//                 if (formkey.currentState.validate()) 
//                 {
//                   //calling the function to signup
//                    if ((await user.signup(
//                     t1.text, t2.text,t3.text,t4.text,t5.text)) == false)
//                     {_key.currentState.showSnackBar(SnackBar(
//                       content: Text("Something is wrong"),
//                       ));
//                     }
//                 }
//                 user.st=Status.signedup; //status changing
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }