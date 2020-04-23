import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:server_demo/numbers.dart';
import 'package:server_demo/selftask.dart';
import 'asstask.dart';

List<dynamic> tasks;

Future<List<dynamic>> getData()async
{
    tasks=[];
    var response=await http.get('http://10.0.2.2:8000/users/1/selftasks');
    if(response.statusCode==200)
    {
      tasks=(json.decode(response.body));
      return tasks;
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
    getData();
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
        Container(
          color: Colors.blue,
          child: IconButton(
            onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>addself()));
          },icon: Icon(Icons.add),),
        ),
        Container(
          color: Colors.blue,
          margin:EdgeInsets.all(10.0),child: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Asstask()));
        },icon: Icon(Icons.send),))
      ],),
      appBar: AppBar(
        leading: Container(),
        title: Text('Self Tasks'),
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
                  itemCount: tasks.length,
                  itemBuilder:(_,index){
                    return ListTile( 
                      title: Text('${snapshot.data.elementAt(index)['title']}',style: TextStyle(fontSize: 20.0),),
                      subtitle: Text('${snapshot.data.elementAt(index)['desc']} Dealine: ${snapshot.data.elementAt(index)['date']}',style: TextStyle(fontSize: 15.0),),
                    );
                  } );
              }
            },
          ),
    );
  }
}