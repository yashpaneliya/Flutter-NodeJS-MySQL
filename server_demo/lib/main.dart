import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:server_demo/emails.dart';
import 'package:server_demo/names.dart';
import 'package:server_demo/numbers.dart';
import 'package:server_demo/users.dart';
List<dynamic> users=[];
Future<List<dynamic>> getData()async
{
  users=[];
    var response=await http.get('http://10.0.2.2:8000/users');
    if(response.statusCode==200)
    {
      users=(json.decode(response.body));
      // print(users);
      return users;
    }
    else{
      print('cant fetch data');
    }
}

void main(){
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Container(margin:EdgeInsets.all(10.0),child: FloatingActionButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Numbers()));
        },child: Icon(Icons.phone),)),
        IconButton(
          color: Colors.blue,
          onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Names()));
        },icon: Icon(Icons.account_box),),
        Container(margin:EdgeInsets.all(10.0),child: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Emails()));
        },icon: Icon(Icons.mail),))
      ],),
      appBar: AppBar(
        title: Text('demo api'),
      ),
          body: FutureBuilder(
            future: getData(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting)
              {
                return Center(child: CircularProgressIndicator(),);
              }
              else
              {
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder:(_,index){
                    return Column(
                      children: <Widget>[
                        Text('${snapshot.data.elementAt(index)['id']}',style: TextStyle(fontSize: 30.0),),
                      ],
                    );
                  } );
              }
            },
          ),
    );
  }
}