import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_login/apiprovider/user_api.dart';
import 'package:state_login/contacts.dart';
import 'package:state_login/notifiers/auth_notifier.dart';

class Task extends StatefulWidget {
  final id;
  const Task({Key key, this.id}) : super(key: key);
  
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> with SingleTickerProviderStateMixin {
  TabController tc;
  bool show=false;
  var sckey=GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    tc=TabController(length: 2,vsync:this);
    refreshContacts();
  }
  @override
  Widget build(BuildContext context) {
    AuthNotifier auth=Provider.of<AuthNotifier>(context);
    return DefaultTabController(
      length: 2,
          child: Scaffold(
            key: sckey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: ()=>signout(auth),
            )
          ],
          backgroundColor: Colors.purple,
          elevation: 0,
          title: Text('Finish It'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Self Task',icon: Icon(Icons.calendar_today),),
              Tab(text: 'Assigned Task',icon: Icon(Icons.playlist_add_check))
          ],),
        ),
        body: TabBarView(
          children: [
          FutureBuilder(
            future: getselftask(widget.id),
            builder: (context, snapshot) {
              return (snapshot.connectionState==ConnectionState.waiting)
              ?Center(child: CircularProgressIndicator())
              : (snapshot.data.length==0)?Text('No data available')
                :ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(snapshot.data.elementAt(index)["title"]),
                          Text(snapshot.data.elementAt(index)["date"],style: TextStyle(color:Colors.grey),)
                        ],
                      ),
                      subtitle: Text(snapshot.data.elementAt(index)["desc"]),
                    );
                  });
            },
          ),
          FutureBuilder(
            future: getselftask(widget.id),
            builder: (context, snapshot) {
              return (snapshot.connectionState==ConnectionState.waiting)
              ?Center(child: CircularProgressIndicator())
              : (snapshot.data.length==0)?Text('No data available')
                :ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      title: Text(snapshot.data.elementAt(index)["title"]),
                    );
                  });
            },
          ),
        ],),
        floatingActionButton: FloatingActionButton(
          onPressed: () {  },
          child: Icon(Icons.add_alarm),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('Yash Paneliya'), 
                accountEmail: Text('yash@gmail.com'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(margin:EdgeInsets.only(left:10.0),child: IconButton(icon: Icon(Icons.menu), 
              onPressed: (){
                setState(() {
                  sckey.currentState.openDrawer();
              });})),
              Container(margin:EdgeInsets.only(right:10.0),child: IconButton(icon: Icon(Icons.account_circle), onPressed: (){}))
            ],
          ),
        ),
      ),
    );
  }


}