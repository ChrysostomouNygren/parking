import 'dart:io';
import 'dart:convert';
import '../models/person.dart';

class PersonRepository {
  List<Person> _persons = [];

  PersonRepository() {
    _persons = loadPersonsFromFile();
  }

  void add(Person person) {
    _persons.add(person);
    savePersonsToFile(_persons);
  }

  List<Person> getAll() => loadPersonsFromFile();

  Person? getById(String id) {
    try {
      return _persons.firstWhere((p) => p.idNum == id);
    } catch (e) {
      return null;
    }
  }

  void update(Person person) {
    var index = _persons.indexWhere((p) => p.idNum == person.idNum);
    if (index != -1) {
      _persons[index] = person;
      savePersonsToFile(_persons);
      }
  }

  void delete(String id) {
    _persons.removeWhere((p) => p.idNum == id);
    savePersonsToFile(_persons);
  }

  void savePersonsToFile(List<Person> persons) {
    final file = File('persons.json');
    final jsonList = persons.map((p) => p.toJson()).toList();
    file.writeAsStringSync(jsonEncode(jsonList));
  }

  List<Person> loadPersonsFromFile() {
    final file = File('persons.json');
    if (!file.existsSync()) return [];
    final jsonList = jsonDecode(file.readAsStringSync()) as List;
    return jsonList.map((json) => Person.fromJson(json)).toList();
  }
}