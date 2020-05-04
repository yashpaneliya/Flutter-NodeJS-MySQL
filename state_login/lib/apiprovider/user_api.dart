import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:state_login/models/assignTask.dart';
import 'package:state_login/models/selftask.dart';
import 'package:state_login/models/users.dart';
import 'package:state_login/notifiers/auth_notifier.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';


var userId;

login(User user, AuthNotifier authNotifier) async {
  SharedPreferences pref=await SharedPreferences.getInstance();
  var response = await http.get('http://10.0.2.2:8000/users/auth/${user.mail}/${user.password}'); //calling the api to get id of user
  print('after get');
  if (response.statusCode == 200 && response.body != "no user found") {
    //true if user loggedin successfully
    print('true condition');
    userId = response.body.toString(); // storing the id to variable->userid
    print(response.body.toString());
    //st=Status.Authenticated;
    if (userId != null) {
      await pref.setString('userid', userId);
      print(pref.getString('userid'));
      print("Login : $userId");
      authNotifier.setUser(pref.getString('userid'));
    }
  }
}

Future signup(User user, AuthNotifier authNotifier) async {
  SharedPreferences pref=await SharedPreferences.getInstance();
  print(jsonEncode(user.toMap()));
  var random = Random.secure();
  int id=random.nextInt(10000000);
  var response = await http.post('http://10.0.2.2:8000/:users/input/$id',headers: <String,String>{'Content-Type':'application/json; charset=UTF-8'},body: jsonEncode(user.toMap())); //calling api to store data of new user

  if (response.statusCode == 200 && response.body == "user saved") {
    user.id=id;
    if (user.id != null) {
      pref.setString('userid', id.toString());
      authNotifier.setUser(pref.getString('userid'));
    }
    return true;
  }
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  SharedPreferences pref=await SharedPreferences.getInstance();
  final String user = pref.getString('userid');

  if (user != null) {
    print(user);
    authNotifier.setUser(user);
  }
}

signout(AuthNotifier authNotifier) async {
  userId = null;
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('userid', null);
  authNotifier.setUser(null);
}

getselftask(id)async
{
  var response = await http.get('http://10.0.2.2:8000/users/$id/selftasks');
  if(response.statusCode==200)
  {
    print(jsonDecode(response.body));
    return jsonDecode(response.body);
  }
  else{
    print('error with server');
  }
}

assignTaskToOther(Assigntask at)async{
  var map={
    "title":at.title,
    "desc":at.desc,
    "date":at.date,
    "status":at.status,
  };
  var response = await http.put('http://10.0.2.2:8000/users/${at.id}/assigntask/${at.tid}',headers: <String,String>{'Content-Type':'application/json; charset=UTF-8'},body: jsonEncode(map));
  print(response.body);
  if(response.statusCode==200)
  {
    return response.body;
  }
  else{
    return "error";
  }
}

assignSelfTask(Selftask st)async{
    print(st.toMap());
    var response=await http.put('http://10.0.2.2:8000/:users/${st.id}/assignselftask',headers: <String,String>{'Content-Type':'application/json; charset=UTF-8'},body: json.encode(st.toMap()));
    print(response.body);
    if(response.statusCode==200)
    {
      return response.body;   
    }
    else{
      return "error";
    }
  }

getAllAssignedTaskToMe(id)async{
  var response=await http.get('http://10.0.2.2:8000/users/$id/asstasks');
  if(response.statusCode==200)
  {
    return json.decode(response.body);
  }
  else{
    return 'error';
  }
}