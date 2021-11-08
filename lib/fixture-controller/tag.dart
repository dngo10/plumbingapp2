class Tag{
  double amount = 0;
  String name = "";
  String num = "";

  void fromMap(Map<String, dynamic> map){
    amount = map["amount"];
    name = map["name"];
    num = map["num"];
  }
}