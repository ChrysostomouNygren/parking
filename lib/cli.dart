import 'dart:io';

class Person {
  final String name;
  final String idNum;

  Person({required this.name, required this.idNum});
  
  factory Person.fromMap(Map<String, dynamic> map){
    return Person(name: map['name'], idNum: map['name']);
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'idNum': idNum,
    };
  }
}


void main(){
  stdout.writeln('type something');
  final input = stdin.readLineSync();
  stdout.writeln('you typed: $input');
}