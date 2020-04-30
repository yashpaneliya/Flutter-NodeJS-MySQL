
class Assigntask{
  String id;
  String title;
  String desc;
  String date;
  String tid;
  int status=0;

  Assigntask();

  Assigntask.fromMap(Map<dynamic, dynamic> data) {
    id = data['uid'];
    title=data['title'];
    desc = data['desc'];
    date = data['date'];
    tid = data["tid"];
    status = data['status'];
  }

  Map<String, String> toMap(){
    return {
      "id":"$id",
      "title" : "$title",
      "desc":"$desc",
      "date" : "$date",
      "tid" : "$tid",
      "status" : "$status",
    };
  }
}