import 'dart:io';

class Person {
  final String name;
  //make it so the idNum must be 10 characters
  final String idNum;

  Person({required this.name, required this.idNum});
}

class Vehicle {
  final String regNum;
  //car, bike, truck, lorry etc
  final String vehicleType;
  final Person owner;

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

class ParkingRepo implements Repository<Parking> {
  final List<Parking> _parkings = [];

  @override
  void add(Parking parking) => _parkings.add(parking);

  @override
  List<Parking> getAll() => _parkings;

  @override
  Parking getById(String id) => _parkings.firstWhere((p) => p.vehicle.regNum == id);

  @override
  void update(Parking parking){
    var index = _parkings.indexWhere((p) => p.vehicle.regNum == parking.vehicle.regNum);
    if (index != -1) _parkings[index] = parking;
  }
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
print('6. Exit');

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
    if (vehicle != null && parkingSpace != null){
      parkingRepo.add(Parking(vehicle: vehicle, parkingSpace: parkingSpace, startTime: DateTime.now(), stopTime: DateTime.now().add(Duration(hours: hours))));
    } else {
      print('Vehicle and/or parkingspot was not found');
    }
    break;

  case '5':
    for (var p in parkingRepo.getAll()){
      print('${p.vehicle.regNum} is parked at ${p.parkingSpace.address} from ${p.startTime} to ${p.stopTime}');
    }
    break;
  case '6':
    return;
  default:
    print('Invalid choice');
}

}
}