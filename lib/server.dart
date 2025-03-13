import 'dart:convert';
import 'package:school/models/parking.dart';
import 'package:school/models/parkingSpace.dart';
import 'package:school/models/person.dart';
import 'package:school/models/vehicle.dart';
import 'package:school/repositories/parking_repository.dart';
import 'package:school/repositories/parkingspace_repository.dart';
import 'package:school/repositories/person_repository.dart';
import 'package:school/repositories/vehicle_repository.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;

final personRepo = PersonRepository();
final vehicleRepo = VehicleRepository();
final parkingSpaceRepo = ParkingSpaceRepository();
final parkingRepo = ParkingRepository();

final router = shelf_router.Router()
//Persons
..get('/persons', (Request request) {
  var persons = personRepo.getAll().map((p) => p.toJson()).toList();
  return Response.ok(jsonEncode(persons), headers: {'Content-Type': 'application/json'});
})
..post('/persons', (Request request) async {
var body = await request.readAsString();
var data = jsonDecode(body);
personRepo.add(Person(name: data['name'], idNum: data['idNum']));
return Response.ok(jsonEncode({'message': 'Person added'}), headers: {'Content-Type': 'application/json'});
})
..get('/persons/<id>', (Request request, String id) {
  var person = personRepo.getById(id);
  if (person == null) {
    return Response.notFound(jsonEncode({'error': 'Person not found'}), headers: {'Content-Type': 'application/json'});
  }
  return Response.ok(jsonEncode(person.toJson()), headers: {'Content-Type': 'application/json'});
})
..put('/persons/<id>', (Request request, String id) async {
  var existingPerson = personRepo.getById(id);
  if (existingPerson == null){
    return Response.notFound(jsonEncode({'error': 'Person not found'}), headers: {'Content-Type': 'application/json'});
  }

  var body = await request.readAsString();
  var data = jsonDecode(body);
  var updatedPerson = Person(name: data['name'], idNum: id);
  personRepo.update(updatedPerson);

  return Response.ok(jsonEncode({'message': 'Person updated'}), headers: {'Content-Type': 'application/json'});
})
..delete('/persons/<id>', (Request request, String id) {
  var existingPerson = personRepo.getById(id);
  if (existingPerson == null){
    return Response.notFound(jsonEncode({'error': 'Person not found'}), headers: {'Content-Type': 'application/json'});
  }

  personRepo.delete(id);
  return Response.ok(jsonEncode({'message': 'Person removed'}), headers: {'Content-Type': 'application/json'});
})
//Vehicles
..get('/vehicles', (Request request) {
  var vehicles = vehicleRepo.getAll().map((v) => v.toJson()).toList();
  return Response.ok(jsonEncode(vehicles), headers: {'Content-Type': 'application/json'});
})
..post('/vehicles', (Request request) async {
var body = await request.readAsString();
var data = jsonDecode(body);
vehicleRepo.add(Vehicle(regNum: data['regNum'], vehicleType: data['vehicleType'], owner: data['owner']));
return Response.ok(jsonEncode({'message': 'Vehicle added'}), headers: {'Content-Type': 'application/json'});
})
..get('/vehicles/<id>', (Request request, String id) {
  var vehicle = vehicleRepo.getById(id);
  if (vehicle == null) {
    return Response.notFound(jsonEncode({'error': 'Vehicle not found'}), headers: {'Content-Type': 'application/json'});
  }
  return Response.ok(jsonEncode(vehicle.toJson()), headers: {'Content-Type': 'application/json'});
})
..put('/vehicles/<id>', (Request request, String id) async {
  var existingVehicle = vehicleRepo.getById(id);
  if (existingVehicle == null){
    return Response.notFound(jsonEncode({'error': 'Vehicle not found'}), headers: {'Content-Type': 'application/json'});
  }
//is the id the same as regNum? investigate!
  var body = await request.readAsString();
  var data = jsonDecode(body);
  var updatedVehicle = Vehicle(regNum: data['regNum'], vehicleType: data['vehicleType'], owner: data['owner']);
  vehicleRepo.update(updatedVehicle);

  return Response.ok(jsonEncode({'message': 'Vehicle updated'}), headers: {'Content-Type': 'application/json'});
})
..delete('/vehicles/<id>', (Request request, String id) {
  var existingVehicle = vehicleRepo.getById(id);
  if (existingVehicle == null){
    return Response.notFound(jsonEncode({'error': 'Vehicle not found'}), headers: {'Content-Type': 'application/json'});
  }

  vehicleRepo.delete(id);
  return Response.ok(jsonEncode({'message': 'Vehicle removed'}), headers: {'Content-Type': 'application/json'});
})
//ParkingSpaces
..get('/parkingspaces', (Request request) {
  var parkiongSpaces = parkingSpaceRepo.getAll().map((p) => p.toJson()).toList();
  return Response.ok(jsonEncode(parkiongSpaces), headers: {'Content-Type': 'application/json'});
})
..post('/parkingspaces', (Request request) async {
var body = await request.readAsString();
var data = jsonDecode(body);
parkingSpaceRepo.add(ParkingSpace(id: data['id'], address: data['address'], pricePerH: data['pricePerH']));
return Response.ok(jsonEncode({'message': 'Parking space added'}), headers: {'Content-Type': 'application/json'});
})
..get('/parkingspaces/<id>', (Request request, String id) {
  var parkingSpace = parkingSpaceRepo.getById(id);
  if (parkingSpace == null) {
    return Response.notFound(jsonEncode({'error': 'Parking space not found, are you lost?'}), headers: {'Content-Type': 'application/json'});
  }
  return Response.ok(jsonEncode(parkingSpace.toJson()), headers: {'Content-Type': 'application/json'});
})
..put('/parkingspaces/<id>', (Request request, String id) async {
  var existingParkingSpace = parkingSpaceRepo.getById(id);
  if (existingParkingSpace == null){
    return Response.notFound(jsonEncode({'error': 'Parking space not found'}), headers: {'Content-Type': 'application/json'});
  }

  var body = await request.readAsString();
  var data = jsonDecode(body);
  var updatedParkingSpace = ParkingSpace(id: id, address: data['address'], pricePerH: data['pricePerH']);
  parkingSpaceRepo.update(updatedParkingSpace);

  return Response.ok(jsonEncode({'message': 'Parking space updated'}), headers: {'Content-Type': 'application/json'});
})
..delete('/parkingspaces/<id>', (Request request, String id) {
  var existingParkingSpace = parkingSpaceRepo.getById(id);
  if (existingParkingSpace == null){
    return Response.notFound(jsonEncode({'error': 'Parking space not found'}), headers: {'Content-Type': 'application/json'});
  }

  parkingSpaceRepo.delete(id);
  return Response.ok(jsonEncode({'message': 'Parking space removed'}), headers: {'Content-Type': 'application/json'});
})
// Parkings
..get('/parkings', (Request request) {
  var parkings = parkingRepo.getAll().map((p) => p.toJson()).toList();
  return Response.ok(jsonEncode(parkings), headers: {'Content-Type': 'application/json'});
})
..post('/parkings', (Request request) async {
var body = await request.readAsString();
var data = jsonDecode(body);
parkingRepo.add(Parking(vehicle: data['vehicle'], parkingSpace: data['parkingSpace'], startTime: data['startTime'], stopTime: data['stopTime']));
return Response.ok(jsonEncode({'message': 'Parking added'}), headers: {'Content-Type': 'application/json'});
})
..get('/parkings/<id>', (Request request, String id) {
  var parking = parkingRepo.getById(id);
  if (parking == null) {
    return Response.notFound(jsonEncode({'error': 'Parking not found'}), headers: {'Content-Type': 'application/json'});
  }
  return Response.ok(jsonEncode(parking.toJson()), headers: {'Content-Type': 'application/json'});
})
..put('/parkings/<id>', (Request request, String id) async {
  var existingParking = parkingRepo.getById(id);
  if (existingParking == null){
    return Response.notFound(jsonEncode({'error': 'Parking not found'}), headers: {'Content-Type': 'application/json'});
  }

  var body = await request.readAsString();
  var data = jsonDecode(body);
  var updatedParking = Parking(vehicle: data['vehicle'], parkingSpace: data['parkingSpace'], startTime: data['startTime'], stopTime: data['stopTime']);
  parkingRepo.update(updatedParking);

  return Response.ok(jsonEncode({'message': 'Parking updated'}), headers: {'Content-Type': 'application/json'});
})
..delete('/parkings/<id>', (Request request, String id) {
  var existingParking = parkingRepo.getById(id);
  if (existingParking == null){
    return Response.notFound(jsonEncode({'error': 'Parking not found'}), headers: {'Content-Type': 'application/json'});
  }

  personRepo.delete(id);
  return Response.ok(jsonEncode({'message': 'Parking removed'}), headers: {'Content-Type': 'application/json'});
});


void main() async {

 var handler = const Pipeline().addMiddleware(logRequests()).addHandler(router.call);
  var server = await io.serve(handler, 'localhost', 8080);
  print('Server is running on http://${server.address.host}:${server.port}');
}