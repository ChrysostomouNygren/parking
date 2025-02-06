import 'dart:io';

class Person {
  final String name;
  final String idNum;

  Person({required this.name, required this.idNum});
}

class Vehicle {
  final String regNum;
  final String vehicleType;
  final Person owner;

  Vehicle({required this.regNum, required this.vehicleType, required this.owner});
}

class ParkingSpace {
  String id;
  String adress;
  double pricePerH;

  ParkingSpace({required this.id, required this.adress, required this.pricePerH});
}

class Parking {
Vehicle vehicle;
ParkingSpace parkingSpace;
DateTime startTime;
DateTime stopTime;

Parking({
  required this.vehicle,
  required this.parkingSpace,
  required this.startTime,
  required this.stopTime,
});
}

void main(){
  stdout.writeln('type something');
  final input = stdin.readLineSync();
  stdout.writeln('you typed: $input');
}