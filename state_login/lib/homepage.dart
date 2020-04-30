import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_login/apiprovider/user_api.dart';
import 'package:state_login/contacts.dart';
import 'package:state_login/models/assignTask.dart';
import 'package:state_login/models/contactdetail.dart';
import 'package:state_login/models/selftask.dart';
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
  
  List<ContactDetail> contactdetaillist;  //contacts list

  @override
  void initState() {
    super.initState();

    tc=TabController(length: 2,vsync:this);
    
    // contactdetaillist=refreshContacts();
    // print(contactdetaillist);
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
          onPressed: () { 
            openselftasksheet(context,widget.id);
           },
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
              Container(margin:EdgeInsets.only(right:10.0),child: IconButton(icon: Icon(Icons.account_circle), onPressed: (){openOtherTaskSheet(context, widget.id);}))
            ],
          ),
        ),
      ),
    );
  }

  void openselftasksheet(context,id){
    Selftask st=Selftask();
    st.id=id;
    st.status=0;
    final fkey=GlobalKey<FormState>();
    showModalBottomSheet(
      // isScrollControlled: true,
      context: context, 
      builder: (BuildContext bc){
        return Form(
          key: fkey,
          child: Column(children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Title'
              ),
              onChanged: (String val)=>st.title=val,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description'
              ),
              onChanged: (String val)=>st.desc=val,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Date'
              ),
              onChanged: (String val)=>st.date=val,
            ),
            RaisedButton(
              onPressed: ()async{
                if(fkey.currentState.validate())
                {
                  if(await assignSelfTask(st)=='selftask added'){
                    print('added');
                  }
                  else{
                    print('cant add task');
                  }
                  Navigator.pop(context);
                }
              },
            )
          ],),
        );
      });
  }

  void openOtherTaskSheet(context,id){
    var selectedContact;
    Assigntask at=Assigntask();
    at.id=id;
    at.status=0;
    final fkey=GlobalKey<FormState>();
    showModalBottomSheet(
      // isScrollControlled: true,
      context: context, 
      builder: (BuildContext bc){
        return Form(
          key: fkey,
          child: Column(children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Title'
              ),
              onChanged: (String val)=>at.title=val,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description'
              ),
              onChanged: (String val)=>at.desc=val,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Date'
              ),
              onChanged: (String val)=>at.date=val,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 80.0,
              child: FutureBuilder<List<ContactDetail>>(
                future: refreshContacts(),
                builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting)return Center(child: CircularProgressIndicator());
                  else if(snapshot.hasData){
                  return DropdownButton<String>(
                    hint: Text('Select'),
                    value: selectedContact,
                    onChanged: (value){
                      setState(() {
                        selectedContact=value;
                        at.tid=selectedContact;
                        print("at.tid: ${at.tid}");
                        print(selectedContact);
                      });
                    },
                    items: snapshot.data.map((e) {
                      print("snapshot.data.length ${snapshot.data.length}");
                      return DropdownMenuItem<String>(child: Text(e.name),value: e.id,);
                    }).toList(),
                  );}
                  else{
                    return Container();
                  }
                },
              ),
            ),
            RaisedButton(
              onPressed: ()async{
                // assignTaskToOther(at);
                if(fkey.currentState.validate())
                {
                  if(await assignTaskToOther(at)=='task added'){
                    print('added');
                  }
                  else{
                    print('cant add task');
                  }
                  Navigator.pop(context);
                }
              },
            )
          ],),
        );
      });
  }

}