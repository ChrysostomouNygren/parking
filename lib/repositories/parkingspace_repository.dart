import 'dart:io';
import 'dart:convert';
import '../models/parkingSpace.dart';

class ParkingSpaceRepository {
  List<ParkingSpace> _parkingSpaces = [];

  ParkingSpaceRepository() {
    _parkingSpaces = loadParkingSpacesFromFile();
  }

  void add(ParkingSpace parkingSpace) {
    _parkingSpaces.add(parkingSpace);
    saveParkingSpacesToFile(_parkingSpaces);
  }

  List<ParkingSpace> getAll() => _parkingSpaces;

  ParkingSpace? getById(String id) {
    try {
      return _parkingSpaces.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(ParkingSpace parkingSpace){
    var index = _parkingSpaces.indexWhere((p) => p.id == parkingSpace.id);
    if (index != -1) {
      _parkingSpaces[index] = parkingSpace;
      saveParkingSpacesToFile(_parkingSpaces);
    } 
  }

  void delete(String id) {
    _parkingSpaces.removeWhere((p) => p.id == id);
    saveParkingSpacesToFile(_parkingSpaces);
  }

  void saveParkingSpacesToFile(List<ParkingSpace> parkingSpaces) {
    final file = File('parkingSpaces.json');
    final jsonList = parkingSpaces.map((ps) => ps.toJson()).toList();
    file.writeAsStringSync(jsonEncode(jsonList));
  }

  List<ParkingSpace> loadParkingSpacesFromFile() {
    final file = File('parkingSpaces.json');
    if (!file.existsSync()) return [];
    final jsonList = jsonDecode(file.readAsStringSync());
    return jsonList.map((json) => ParkingSpace.fromJson(json)).toList();
  }
}