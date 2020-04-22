import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
List<dynamic> mails=[];
Future<List<dynamic>> getmails()async
{
  mails=[];
    var response=await http.get('http://10.0.2.2:8000/mails');
    if(response.statusCode==200)
    {
      mails=(json.decode(response.body));
      // print(users);
      return mails;
    }
    else{
      print('cant fetch data');
    }
}
class Emails extends StatefulWidget {
  @override
  _EmailsState createState() => _EmailsState();
}

class _EmailsState extends State<Emails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Numbers'),
      ),
      body: FutureBuilder(
            future: getmails(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting)
              {
                return Center(child: CircularProgressIndicator(),);
              }
              else
              {
                return ListView.builder(
                  itemCount: mails.length,
                  itemBuilder:(_,index){
                    return Column(
                      children: <Widget>[
                        Text('${snapshot.data.elementAt(index)['email']}',style: TextStyle(fontSize: 30.0)),
                      ],
                    );
                  } );
              }
            },
          ),
    );
  }
}