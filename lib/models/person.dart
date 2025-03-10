class Person {
  String name;
  String idNum;

  Person({required this.name, required this.idNum});

  Map<String, dynamic> toJson() => {'name': name, 'idNum': idNum};

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    name: json['name'],
    idNum: json['id'] ?? json['idNum'],
  );
}