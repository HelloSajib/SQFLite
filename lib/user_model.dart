import 'dart:convert';

class User {
  final int phone;
  final String name;
  final String position;

  const User({
    required this.phone,
    required this.name,
    required this.position
  });

  factory User.fromRawJson(String jsonString)=> User.fromJson(json.decode(jsonString));

  String toRawJson()=> jsonEncode(toJson());

  factory User.fromJson(Map<String,dynamic> json)=> User(
      phone: json["phone"],
      name: json["name"],
      position: json["position"]
  );

  Map<String,dynamic> toJson()=>{
    "phone": phone,
    "name": name,
    "position": position
  };

}