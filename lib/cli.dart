import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';

class Person {
  String name;
  final String idNum;

  Person({required this.name, required this.idNum});
  Map<String, dynamic> toJson() => {'name' : name, 'idNum' : idNum};
}

class Vehicle {
  final String regNum;
  //car, bike, truck, lorry etc
  String vehicleType;
  Person owner;

  Vehicle({required this.regNum, required this.vehicleType, required this.owner});
}

class ParkingSpace {
  String id;
  String address;
  double pricePerH;

  ParkingSpace({required this.id, required this.address, required this.pricePerH});
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
  Person? getById(String id) {
    try {
      return _persons.firstWhere((p) => p.idNum == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void update(Person person) {
    var index = _persons.indexWhere((p) => p.idNum == person.idNum);
    if (index != -1) _persons[index] = person;
  }

  void delete(String id) => _persons.removeWhere((p) => p.idNum == id);
}
final personRepo = PersonRepo();
Future<Response> _handleRequest(Request request) async {
  //GET
  if (request.url.path == 'persons' && request.method == 'GET') {
    return Response.ok(jsonEncode(personRepo.getAll()), headers: {'Content-Type' : 'applications/json'});
  }
  //POST
  if (request.url.path == 'persons' && request.method == 'POST') {
    var body = await request.readAsString();
    var data = jsonDecode(body);
    var person = Person(name: data['name'], idNum: data['idNum']);
    personRepo.add(person);
    return Response.ok(jsonEncode({'message': 'Person added'}), headers: {'Content-Type': 'application/json'});
  }
  return Response.notFound('Not found');
}

class VehicleRepo implements Repository<Vehicle> {
  final List<Vehicle> _vehicles = [];

  @override
  void add(Vehicle vehicle) => _vehicles.add(vehicle);

  @override
  List<Vehicle> getAll() => _vehicles;

  @override
  Vehicle? getById(String id) {
    try {
      return _vehicles.firstWhere((p) => p.regNum == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void update(Vehicle vehicle){
    var index = _vehicles.indexWhere((v) => v.regNum == vehicle.regNum);
    if (index != -1) _vehicles[index] = vehicle;
  }

  void delete(String id) => _vehicles.removeWhere((v) => v.regNum == id);
}

class ParkingSpaceRepo implements Repository<ParkingSpace> {
  final List<ParkingSpace> _parkingSpaces = [];

  @override
  void add(ParkingSpace parkingSpace) => _parkingSpaces.add(parkingSpace);

  @override
  List<ParkingSpace> getAll() => _parkingSpaces;

  @override
  //ParkingSpace getById(String id) => _parkingSpaces.firstWhere((p) => p.id == id);
  ParkingSpace? getById(String id) {
    try {
      return _parkingSpaces.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void update(ParkingSpace parkingSpace){
    var index = _parkingSpaces.indexWhere((p) => p.id == parkingSpace.id);
    if (index != -1) _parkingSpaces[index] = parkingSpace;
  }

  @override
  void delete(String id) => _parkingSpaces.removeWhere((p) => p.id == id);
}

class ParkingRepo implements Repository<Parking> {
  final List<Parking> _parkings = [];

  @override
  void add(Parking parking) => _parkings.add(parking);

  @override
  List<Parking> getAll() => _parkings;

  @override
  Parking? getById(String id) {
    try {
      return _parkings.firstWhere((p) => p.vehicle.regNum == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void update(Parking parking){
    var index = _parkings.indexWhere((p) => p.vehicle.regNum == parking.vehicle.regNum);
    if (index != -1) _parkings[index] = parking;
  }

  void delete(String id) => _parkings.removeWhere((p) => p.vehicle.regNum == id);
}

void main(){
var personRepo = PersonRepo();
var vehicleRepo = VehicleRepo();
var parkingSpaceRepo = ParkingSpaceRepo();
var parkingRepo = ParkingRepo();

while(true){


print('Choose operation:');
print('1. Add person');
print('2. Add vehicle');
print('3. Add parking spot');
print('4. Start parking');
print('5. List all parkings');
print('6. Update person');
print('7. Update vehicle');
print('8. Remove person');
print('9. Remove vehicle');
print('10. Remove parking');
print('11. Exit');

var choice = stdin.readLineSync();

switch (choice) {
  case '1':
    print('Add name:');
    String name = stdin.readLineSync()!;
    print('Add person number:');
    String id = stdin.readLineSync()!;
    personRepo.add(Person(name: name, idNum: id));
    break;
  case '2':
    print('Add registration number:');
    String regNum = stdin.readLineSync()!;
    print('Add vehicle type:');
    String vehicleType = stdin.readLineSync()!;
    print('Add owners person number');
    String owenerId = stdin.readLineSync()!;

    var owner = personRepo.getById(owenerId);
    if (owner != null){
      vehicleRepo.add(Vehicle(regNum: regNum, vehicleType: vehicleType, owner: owner));
    } else {
      print('Owner not found');
    }
    break;
  case '3':
    print('Add parking space ID:');
    String id = stdin.readLineSync()!;
    print('Add address:');
    String address = stdin.readLineSync()!;
    print('Add price per hour:');
    double pricePerH = double.parse(stdin.readLineSync()!);

    parkingSpaceRepo.add(ParkingSpace(id: id, address: address, pricePerH: pricePerH));
    break;
  case '4':
    print('Vehicles registration number:');
    String regNum = stdin.readLineSync()!;
    print('Parkingspace ID:');
    String spaceId = stdin.readLineSync()!;
    print('Amount of hours to use the parkingspot:');
    int hours = int.parse(stdin.readLineSync()!);


    var vehicle = vehicleRepo.getById(regNum);
    var parkingSpace = parkingSpaceRepo.getById(spaceId);
    parkingRepo.add(Parking(vehicle: vehicle!, parkingSpace: parkingSpace!, startTime: DateTime.now(), stopTime: DateTime.now().add(Duration(hours: hours))));
      break;

  case '5':
    for (var p in parkingRepo.getAll()){
      print('${p.vehicle.regNum} is parked at ${p.parkingSpace.address} from ${p.startTime} to ${p.stopTime}');
    }
    break;

  case '6':
    print('ID number of the person to update:');
    String id = stdin.readLineSync()!;
    var person = personRepo.getById(id);
    if (person != null){
      print('Add new name:');
      String newName = stdin.readLineSync()!;
      person.name = newName;
      personRepo.update(person);
      print('Person updated successfully');
    } else {
      print('Person not found, try again');
    }
    break;
  case '7':
    print('Registration number of the vehicle to update:');
    String regNum = stdin.readLineSync()!;
    var vehicle = vehicleRepo.getById(regNum);
    if (vehicle != null){
     print('New vehicle type:');
     String newType = stdin.readLineSync()!;
     vehicle.vehicleType = newType;
     vehicleRepo.update(vehicle);
    } else {
      print('Vehicle was not found.');
    }
  case '8':
    print('Personal number for the person to remove:');
    String id = stdin.readLineSync()!;
    var person = personRepo.getById(id);

    if (person != null){
      personRepo.delete(id);
      print('Person removed successfully.');
    } else {
      print('Person not found');
    }
    break;
  case '9':
    print('Registration number for the vehicle to remove:');
    String regNum = stdin.readLineSync()!;
    var vehicle = vehicleRepo.getById(regNum);

    if (vehicle != null){
      vehicleRepo.delete(regNum);
      print('Vehicle removed successfully');
    } else {
      print('Vehicle not found');
    }
    break;
  case '10':
    print('Registration number for the vehicle to remove from parking:');
    String regNum = stdin.readLineSync()!;
    var parking = parkingRepo.getById(regNum);
    if (parking != null){
      parkingRepo.delete(regNum);
      print('Parking terminated');
    } else {
      print('Parking not found');
    }
    break;
  case '11':
    return;
  default:
    print('Invalid choice');
}

}
}