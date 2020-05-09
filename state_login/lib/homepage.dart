// import 'package:contacts_service/contacts_service.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:state_login/apiprovider/user_api.dart';
import 'package:state_login/contacts.dart';
import 'package:state_login/models/assignTask.dart';
import 'package:state_login/models/contactdetail.dart';
import 'package:state_login/models/selftask.dart';
import 'package:state_login/notifiers/auth_notifier.dart';
import 'package:state_login/pages/assignedToMetasklist.dart';
import 'package:state_login/pages/assignedtasklist.dart';
import 'package:state_login/pages/selftasklist.dart';

class Task extends StatefulWidget {
  final id;
  const Task({Key key, this.id}) : super(key: key);
  
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> with SingleTickerProviderStateMixin {

  var sckey=GlobalKey<ScaffoldState>();
  var selectedDate=DateTime.now();
  List<ContactDetail> contactdetaillist;  //contacts list

  PageController controller=PageController(viewportFraction: 0.9);
  int currentPage;
  List<Widget> pages;
  
  @override
  void initState() {
    super.initState();
    currentPage=0;
    pages=[SelfTaskList(id: widget.id,),AssignedToMeTask(id:widget.id),AssignedTask(id:widget.id)];
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier auth=Provider.of<AuthNotifier>(context);
    return Scaffold(
        key: sckey,
        backgroundColor: Colors.white,
        body: PageView.builder(
          itemCount: 3,
          controller: controller,
          onPageChanged: (value) {
            setState(() {
              currentPage=value;
              print(currentPage.toInt());
            });
          },
          pageSnapping: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context,position)=>SafeArea(
            child: Card(
              elevation:25.0,
              child: pages[position])
            )
        ),
        floatingActionButton: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: Color.fromRGBO(15, 228, 0, 1),
          textColor: Colors.white,
          onPressed: () { 
            openselftasksheet(context,widget.id);
           },
          child: Text('Add New Task'),
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
          elevation: 5.0,
          color: Colors.white,
          notchMargin: 35.0,
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
      );
  }

  void openselftasksheet(context,id){
    Selftask st=Selftask();
    st.id=id;
    st.status=0;
    var date=DateTime.now();
    final fkey=GlobalKey<FormState>();
    showModalBottomSheet(
       shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0))
      ),
      context: context, 
      builder: (BuildContext bc){
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Form(
            key: fkey,
            child:  ListView(
                children: [
                Container(
                  margin: EdgeInsets.only(left:15.0,right: 15.0,top:5.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Title'
                    ),
                    onChanged: (String val)=>st.title=val,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left:15.0,right: 15.0,top:5.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Description'
                    ),
                    onChanged: (String val)=>st.desc=val,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left:15.0,right: 15.0,top:15.0),
                  child:InkWell(
                    onTap: ()async{
                        final DateTime picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101));
                        if (picked != null && picked != selectedDate)
                        {    setState(() {
                            selectedDate = picked;
                            st.date=selectedDate.toString();
                          });
                        }
                    },
                    child: Row(
                      children: <Widget>[
                        Text('$selectedDate',style: TextStyle(fontSize:15.0),),
                        Icon(Icons.date_range)
                      ],
                    ),
                  )
                ),
                Container(
                  margin: EdgeInsets.only(top:10.0,left:15.0),
                  child: Text('Priority',style: TextStyle(fontSize:17.0,color:Colors.grey),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top:10.0),
                      width: MediaQuery.of(context).size.width*0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(offset: Offset(0, 4.5),blurRadius: 7.0,color: Colors.red.shade200.withOpacity(0.4))
                        ]
                      ),
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                        child: Text('High',style: TextStyle(color: Colors.grey),),
                        onPressed: (){}),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:10.0),
                      width: MediaQuery.of(context).size.width*0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(offset: Offset(0, 4.5),blurRadius: 7.0,color: Colors.green.shade200.withOpacity(0.4))
                        ]
                      ),
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                        child: Text('Low',style: TextStyle(color: Colors.grey),),
                        onPressed: (){}),
                    ),
                ],),
                Center(
                  child: Container(
                      margin: EdgeInsets.only(top:10.0),
                      width: MediaQuery.of(context).size.width*0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(offset: Offset(0, 4.5),blurRadius: 7.0,color: Colors.yellow.shade200.withOpacity(0.4))
                        ]
                      ),
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                        child: Text('Medium',style: TextStyle(color: Colors.grey),),
                        onPressed: (){}),
                    ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top:20.0),              
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.check),
                      onPressed: ()async{
                        if(fkey.currentState.validate())
                        {
                          if(await assignSelfTask(st)=='selftask added'){
                            print('added');
                            setState(() {
                              print('added');
                            });
                          }
                          else{
                            print('cant add task');
                          }
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                )
              ],)
          );
          },
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
      isScrollControlled: true,
      context: context, 
      builder: (BuildContext bc){
        return Form(
          key: fkey,
          child: Column(
            children: [
              SizedBox(height: 30.0,),
            Container(
                margin: EdgeInsets.only(left:15.0,right: 15.0,top:5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Title'
                  ),
                  onChanged: (String val)=>at.title=val,
                ),
              ),
            Container(
                margin: EdgeInsets.only(left:15.0,right: 15.0,top:5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Description'
                  ),
                  onChanged: (String val)=>at.desc=val,
                ),
              ),
            Container(
                  margin: EdgeInsets.only(left:15.0,right: 15.0,top:15.0),
                  child:InkWell(
                    onTap: ()async{
                        final DateTime picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101));
                        if (picked != null && picked != selectedDate)
                        {    setState(() {
                            selectedDate = picked;
                            at.date=selectedDate.toString();
                          });
                        }
                    },
                    child: Row(
                      children: <Widget>[
                        Text('$selectedDate',style: TextStyle(fontSize:15.0),),
                        Icon(Icons.date_range)
                      ],
                    ),
                  )
                ),
            Container(
              margin: EdgeInsets.only(left:15.0,right: 15.0,top:5.0),
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              child: FutureBuilder<List<ContactDetail>>(
                future: refreshContacts(),
                builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting)return Center(child: CircularProgressIndicator());
                  else if(snapshot.hasData){
                  return DropdownButton<String>(
                    hint: Text('Select People'),
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
            Container(
                margin: EdgeInsets.only(top:10.0,left:15.0),
                child: Text('Priority',style: TextStyle(fontSize:17.0,color:Colors.grey),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.only(top:10.0),
                    width: MediaQuery.of(context).size.width*0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(offset: Offset(0, 4.5),blurRadius: 7.0,color: Colors.red.shade200.withOpacity(0.4))
                      ]
                    ),
                    child: RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      child: Text('High',style: TextStyle(color: Colors.grey),),
                      onPressed: (){}),
                  ),
                  Container(
                    margin: EdgeInsets.only(top:10.0),
                    width: MediaQuery.of(context).size.width*0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(offset: Offset(0, 4.5),blurRadius: 7.0,color: Colors.green.shade200.withOpacity(0.4))
                      ]
                    ),
                    child: RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      child: Text('Low',style: TextStyle(color: Colors.grey),),
                      onPressed: (){}),
                  ),
              ],),
              Center(
                child: Container(
                    margin: EdgeInsets.only(top:10.0),
                    width: MediaQuery.of(context).size.width*0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(offset: Offset(0, 4.5),blurRadius: 7.0,color: Colors.yellow.shade200.withOpacity(0.4))
                      ]
                    ),
                    child: RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      child: Text('Medium',style: TextStyle(color: Colors.grey),),
                      onPressed: (){}),
                  ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top:20.0),              
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.check),
                    onPressed: ()async{
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
                  ),
                ),
              )
          ],),
        );
      });
  }

}