import 'dart:io';

//repositories
import 'package:school/repositories/parking_repository.dart';
import 'package:school/repositories/parkingspace_repository.dart';
import 'package:school/repositories/person_repository.dart';
import 'package:school/repositories/vehicle_repository.dart';

//models
import 'package:school/models/person.dart';
import 'package:school/models/vehicle.dart';
import 'package:school/models/parkingSpace.dart';
import 'package:school/models/parking.dart';

void main(){
var personRepo = PersonRepository();
var vehicleRepo = VehicleRepository();
var parkingSpaceRepo = ParkingSpaceRepository();
var parkingRepo = ParkingRepository();

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