import 'dart:convert';
import 'package:school/cli.dart';
import 'package:school/models/person.dart';
import 'package:school/repositories/person_repository.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;

final personRepo = PersonRepository();

final router = shelf_router.Router()
..get('/persons', (Request request) {
  var persons = personRepo.getAll().map((p) => p.toJson()).toList();
  return Response.ok(jsonEncode(persons), headers: {'Content-Type': 'application/json'});
})
..post('/persons', (Request request) async {
var body = await request.readAsString();
var data = jsonDecode(body);
personRepo.add(Person(name: data['name'], idNum: data['idNum']));
return Response.ok(jsonEncode({'message': 'Person added'}), headers: {'Content-Type': 'application/json'});
});

void main() async {

 var handler = const Pipeline().addMiddleware(logRequests()).addHandler(router.call);
  var server = await io.serve(handler, 'localhost', 8080);
  print('Server is running on http://${server.address.host}:${server.port}');
}