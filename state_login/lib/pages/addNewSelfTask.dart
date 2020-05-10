import 'package:flutter/material.dart';
import 'package:state_login/apiprovider/user_api.dart';
import 'package:state_login/models/selftask.dart';

class AddNewSelfTask extends StatefulWidget {
  final id;

  const AddNewSelfTask({Key key, this.id}) : super(key: key);
  @override
  _AddNewSelfTaskState createState() => _AddNewSelfTaskState();
}

class _AddNewSelfTaskState extends State<AddNewSelfTask> {

    Selftask st=Selftask();
    var date=DateTime.now();
    final fkey=GlobalKey<FormState>();
    var selectedDate=DateTime.now();
    
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    st.id=widget.id;
    st.status=0;
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
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
        // return ;
      },
      child: Form(
        key: fkey,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.black,),onPressed: (){
              Navigator.pop(context);
            },),
            title: Text('New Task',style: TextStyle(color: Colors.black,),),
            actions: [
              IconButton(
                icon: Icon(Icons.outlined_flag,color: Colors.black,),
                onPressed: (){},
              ),
              IconButton(
                icon: Icon(Icons.check,color: Colors.black,),
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
              )
            ],
          ),
          body: ListView(
                  children: [
                  Container(
                    margin: EdgeInsets.only(left:15.0,right: 15.0,top:5.0),
                    child: TextFormField(
                      style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                        hintStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0),
                        
                      ),
                      onChanged: (String val)=>st.title=val,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left:15.0,right: 15.0,top:10.0),
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
                          Text('$selectedDate',style: TextStyle(fontSize:20.0),),
                          Icon(Icons.date_range)
                        ],
                      ),
                    )
                  ),
                  Container(
                    margin: EdgeInsets.only(left:15.0,right: 15.0,top:5.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        hintStyle: TextStyle(fontSize: 20.0,),
                        border: InputBorder.none
                      ),
                      onChanged: (String val)=>st.desc=val,
                    ),
                  ),
                  
                  // Container(
                  //   margin: EdgeInsets.only(top:10.0,left:15.0),
                  //   child: Text('Priority',style: TextStyle(fontSize:17.0,color:Colors.grey),),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     Container(
                  //       margin: EdgeInsets.only(top:10.0),
                  //       width: MediaQuery.of(context).size.width*0.35,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(20.0),
                  //         boxShadow: [
                  //           BoxShadow(offset: Offset(0, 4.5),blurRadius: 7.0,color: Colors.red.shade200.withOpacity(0.4))
                  //         ]
                  //       ),
                  //       child: RaisedButton(
                  //         color: Colors.white,
                  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  //         child: Text('High',style: TextStyle(color: Colors.grey),),
                  //         onPressed: (){}),
                  //     ),
                  //     Container(
                  //       margin: EdgeInsets.only(top:10.0),
                  //       width: MediaQuery.of(context).size.width*0.35,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(20.0),
                  //         boxShadow: [
                  //           BoxShadow(offset: Offset(0, 4.5),blurRadius: 7.0,color: Colors.green.shade200.withOpacity(0.4))
                  //         ]
                  //       ),
                  //       child: RaisedButton(
                  //         color: Colors.white,
                  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  //         child: Text('Low',style: TextStyle(color: Colors.grey),),
                  //         onPressed: (){}),
                  //     ),
                  // ],),
                  // Center(
                  //   child: Container(
                  //       margin: EdgeInsets.only(top:10.0),
                  //       width: MediaQuery.of(context).size.width*0.35,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(20.0),
                  //         boxShadow: [
                  //           BoxShadow(offset: Offset(0, 4.5),blurRadius: 7.0,color: Colors.yellow.shade200.withOpacity(0.4))
                  //         ]
                  //       ),
                  //       child: RaisedButton(
                  //         color: Colors.white,
                  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  //         child: Text('Medium',style: TextStyle(color: Colors.grey),),
                  //         onPressed: (){}),
                  //     ),
                  // ),
                  // Center(
                  //   child: Container(
                  //     margin: EdgeInsets.only(top:20.0),              
                  //     decoration: BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       color: Colors.green,
                  //     ),
                  //     child: IconButton(
                  //       color: Colors.white,
                  //       icon: Icon(Icons.check),
                  //       onPressed: ()async{
                  //         if(fkey.currentState.validate())
                  //         {
                  //           if(await assignSelfTask(st)=='selftask added'){
                  //             print('added');
                  //             setState(() {
                  //               print('added');
                  //             });
                  //           }
                  //           else{
                  //             print('cant add task');
                  //           }
                  //           Navigator.pop(context);
                  //         }
                  //       },
                  //     ),
                  //   ),
                  // )
                ],),
          ),
        )
    );
  }
}