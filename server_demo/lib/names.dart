import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
List<dynamic> names=[];
Future<List<dynamic>> getnames()async
{
  names=[];
    var response=await http.get('http://10.0.2.2:8000/names');
    if(response.statusCode==200)
    {
      names=(json.decode(response.body));
      return names;
    }
    else{
      print('cant fetch data');
    }
}
class Names extends StatefulWidget {
  @override
  _NamesState createState() => _NamesState();
}

class _NamesState extends State<Names> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Numbers'),
      ),
      body: FutureBuilder(
            future: getnames(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting)
              {
                return Center(child: CircularProgressIndicator(),);
              }
              else
              {
                return ListView.builder(
                  itemCount: names.length,
                  itemBuilder:(_,index){
                    return Column(
                      children: <Widget>[
                        Text('${snapshot.data.elementAt(index)['username']}',style: TextStyle(fontSize: 30.0)),
                      ],
                    );
                  } );
              }
            },
          ),
    );
  }
}