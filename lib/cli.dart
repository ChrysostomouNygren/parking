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

abstract class Repository<T> {
  void add(T item);
  List<T> getAll();
  T? getById(String id);
  void update(T item);
}

class PersonRepo implements Repository<Person> {
  final List<Person> _persons = [];
  @override
  void add(Person person) => _persons.add(person);

  @override
  List<Person> getAll() => _persons;

  @override
  Person getById(String id) => _persons.firstWhere((p) => p.idNum == id);

  @override
  void update(Person person) {
    var index = _persons.indexWhere((p) => p.idNum == person.idNum);
    if (index != -1) _persons[index] = person;
  }
}

class VehicleRepo implements Repository<Vehicle> {
  final List<Vehicle> _vehicles = [];

  @override
  void add(Vehicle vehicle) => _vehicles.add(vehicle);

  @override
  List<Vehicle> getAll() => _vehicles;

  @override
  Vehicle getById(String id) => _vehicles.firstWhere((v) => v.regNum == id);

  @override
  void update(Vehicle vehicle){
    var index = _vehicles.indexWhere((v) => v.regNum == vehicle.regNum);
    if (index != -1) _vehicles[index] = vehicle;
  }
}

class ParkingSpaceRepo implements Repository<ParkingSpace> {
  final List<ParkingSpace> _parkingSpaces = [];

  @override
  void add(ParkingSpace parkingSpace) => _parkingSpaces.add(parkingSpace);

  @override
  List<ParkingSpace> getAll() => _parkingSpaces;

  @override
  ParkingSpace getById(String id) => _parkingSpaces.firstWhere((p) => p.id == id);

  @override
  void update(ParkingSpace parkingSpace){
    var index = _parkingSpaces.indexWhere((p) => p.id == parkingSpace.id);
    if (index != -1) _parkingSpaces[index] = parkingSpace;
  }
}

void main(){
  stdout.writeln('type something');
  final input = stdin.readLineSync();
  stdout.writeln('you typed: $input');
}