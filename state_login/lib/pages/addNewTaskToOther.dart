import 'package:flutter/material.dart';
import 'package:state_login/apiprovider/user_api.dart';
import 'package:state_login/contacts.dart';
import 'package:state_login/models/assignTask.dart';
import 'package:state_login/models/contactdetail.dart';

class AddNewTaskForOther extends StatefulWidget {
  final id;

  const AddNewTaskForOther({Key key, this.id}) : super(key: key);
  @override
  _AddNewTaskForOtherState createState() => _AddNewTaskForOtherState();
}

class _AddNewTaskForOtherState extends State<AddNewTaskForOther> {
  var selectedContact;
  Assigntask at = Assigntask();
  var selectedDate = DateTime.now();
  final fkey = GlobalKey<FormState>();

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
  void initState() {
    // TODO: implement initState
    super.initState();
    at.id = widget.id;
    at.status = 0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Form(
        key: fkey,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'New Task',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.outlined_flag,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.black,
                ),
                onPressed: () async {
                  if (fkey.currentState.validate()) {
                    if (await assignTaskToOther(at) == 'task added') {
                      print('added');
                      setState(() {
                        print('added');
                      });
                    } else {
                      print('cant add task');
                    }
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
          body: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                child: TextFormField(
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                      border: InputBorder.none),
                  onChanged: (String val) => at.title = val,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                  child: InkWell(
                    onTap: () async {
                      final DateTime picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2015, 8),
                          lastDate: DateTime(2101));
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                          at.date = selectedDate.toString();
                        });
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          '$selectedDate',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Icon(Icons.date_range)
                      ],
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                child: FutureBuilder<List<ContactDetail>>(
                  future: refreshContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    else if (snapshot.hasData) {
                      return DropdownButton<String>(
                        hint: Text('Select People'),
                        value: selectedContact,
                        underline: Container(),
                        onChanged: (value) {
                          setState(() {
                            selectedContact = value;
                            at.tid = selectedContact;
                            print("at.tid: ${at.tid}");
                            print(selectedContact);
                          });
                        },
                        items: snapshot.data.map((e) {
                          print("snapshot.data.length ${snapshot.data.length}");
                          return DropdownMenuItem<String>(
                            child: Text(e.name),
                            value: e.id,
                          );
                        }).toList(),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText: 'Description',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 20.0)),
                  onChanged: (String val) => at.desc = val,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
