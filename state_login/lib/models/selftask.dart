
class Selftask{
  String title;
  String desc;
  String date;
  String id;
  int status;

  Selftask();

  Selftask.fromMap(Map<dynamic, dynamic> data) {
    id = data['uid'];
    title=data['title'];
    desc = data['desc'];
    date = data['date'];
    status = data['status'];
  }

  Map<String, String> toMap(){
    return {
      "uid":"$id",
      "title" : "$title",
      "desc":"$desc",
      "date" : "$date",
      "status" : "$status",
    };
  }
}