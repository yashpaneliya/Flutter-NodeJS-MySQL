// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:state_login/userrepo.dart';


// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController _email=TextEditingController();
//   TextEditingController _password=TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   final _key = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     final user=Provider.of<UserRepo>(context);
//     return Scaffold(
//       key:_key,
//       appBar: AppBar(title: Text('Login'),),
//       body: Form(
//         key:formKey,
//         child: Column(children: [
//           Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextFormField(
//                   controller: _email,
//                   validator: (value) =>
//                       (value.isEmpty) ? "Please Enter Username" : null,
//                   decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.email),
//                       labelText: "Email",
//                       border: OutlineInputBorder()),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextFormField(
//                   controller: _password,
//                   validator: (value) =>
//                       (value.isEmpty) ? "Please Enter Password" : null,
//                   decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.lock),
//                       labelText: "Password",
//                       border: OutlineInputBorder()),
//                 ),
//               ),
//               (user.status==Status.Authenticating)?Center(child:CircularProgressIndicator())
//               :Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Material(
//                         elevation: 5.0,
//                         borderRadius: BorderRadius.circular(30.0),
//                         color: Colors.red,
//                         child: MaterialButton(  //login button
//                           onPressed: () async {
//                             if (formKey.currentState.validate()) {
//                               //calling the function to login
//                               if ((await user.signIn(
//                                   _email.text, _password.text)) == false)
//                                 {_key.currentState.showSnackBar(SnackBar(
//                                   content: Text("Something is wrong"),
//                                 ));
//                                 }
//                             }
//                             print(user.st);
                            
//                           },
//                           child: Text(
//                             "Sign In",
//                         ),
//                       ),
//                     )),
//                     SizedBox(height: 100.0,),
//                     FlatButton(  //signup button
//                         onPressed: (){
//                           print(user.st);
//                           user.st=Status.signupauthenticating;
//                           print(user.st);
//                         },
//                         child: Text('Sign Up'),
//                       ),
//         ],),
//       )
//     );
//   }
// }