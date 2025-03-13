import 'dart:io';
import 'dart:convert';
import '../models/parking.dart';

class ParkingRepository {
  List<Parking> _parkings = [];

  ParkingRepository() {
    _parkings = loadParkingsfromFile();
  }

  void add(Parking parking) {
    _parkings.add(parking);
    saveParkingToFile(_parkings);
    }

  List<Parking> getAll() => loadParkingsfromFile();

  Parking? getById(String id) {
    try {
      return _parkings.firstWhere((p) => p.vehicle.regNum == id);
    } catch (e) {
      return null;
    }
  }

  void update(Parking parking){
    var index = _parkings.indexWhere((p) => p.vehicle.regNum == parking.vehicle.regNum);
    if (index != -1){
       _parkings[index] = parking;
       saveParkingToFile(_parkings);
       }
  }

  void delete(String id) {
    _parkings.removeWhere((p) => p.vehicle.regNum == id);
    saveParkingToFile(_parkings);
  } 

  void saveParkingToFile(List<Parking> parkings) {
    final file = File('parkings.json');
    final jsonList = parkings.map((p) => p.toJson()).toList();
    file.writeAsStringSync(jsonEncode(jsonList));
  }

  List<Parking> loadParkingsfromFile() {
    final file = File('parkings.json');
    if (!file.existsSync()) return [];
    final jsonList = jsonDecode(file.readAsStringSync()) as List;
    return jsonList.map((json) => Parking.fromJson(json)).toList();
  }
}