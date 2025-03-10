import 'package:school/models/person.dart';

class Vehicle {
  String regNum;
  String vehicleType;
  Person owner;

  Vehicle({required this.regNum, required this.vehicleType, required this.owner});

  Map<String, dynamic> toJson() => {'regNum' : regNum, 'vehicleType': vehicleType, 'owner': owner};

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
  regNum: json['regNum'] ?? json['id'],
  vehicleType: json['vehicleType'], 
  owner: json['owner']);
}