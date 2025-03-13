import 'dart:convert';
import 'package:school/models/person.dart';
import 'package:school/repositories/person_repository.dart';
import 'package:school/repositories/vehicle_repository.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;

final personRepo = PersonRepository();
final vehicleRepo = VehicleRepository();

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
});


void main() async {

 var handler = const Pipeline().addMiddleware(logRequests()).addHandler(router.call);
  var server = await io.serve(handler, 'localhost', 8080);
  print('Server is running on http://${server.address.host}:${server.port}');
}