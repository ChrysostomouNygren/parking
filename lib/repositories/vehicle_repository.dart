import 'dart:io';
import 'dart:convert';
import '../models/vehicle.dart';

class VehicleRepository{
  List<Vehicle> _vehicles = [];

  VehicleRepository() {
    _vehicles = loadVehiclesFromFile();
  }

  void add(Vehicle vehicle) {
    _vehicles.add(vehicle);
    saveVehiclesToFile(_vehicles);
    }


  List<Vehicle> getAll() => loadVehiclesFromFile();

  Vehicle? getById(String id) {
    try {
      return _vehicles.firstWhere((p) => p.regNum == id);
    } catch (e) {
      return null;
    }
  }

  void update(Vehicle vehicle){
    var index = _vehicles.indexWhere((v) => v.regNum == vehicle.regNum);
    if (index != -1) {
      _vehicles[index] = vehicle;
      saveVehiclesToFile(_vehicles);
    }
  }

  void delete(String id) {
    _vehicles.removeWhere((v) => v.regNum == id);
    saveVehiclesToFile(_vehicles);
  } 

  void saveVehiclesToFile(List<Vehicle> vehicles) {
    final file = File('vehicles.json');
    final jsonList = vehicles.map((v) => v.toJson()).toList();
    file.writeAsStringSync(jsonEncode(jsonList));
  }

  List<Vehicle> loadVehiclesFromFile() {
    final file = File('vehicles.json');
    if (!file.existsSync()) return [];
    final jsonList = jsonDecode(file.readAsStringSync()) as List;
    return jsonList.map((json) => Vehicle.fromJson(json)).toList();
  }
}