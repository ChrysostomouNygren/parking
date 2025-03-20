import 'package:school/models/parkingSpace.dart';
import 'package:school/models/vehicle.dart';

class Parking {
  Vehicle vehicle;
  ParkingSpace parkingSpace;
  DateTime startTime;
  DateTime stopTime;

  Parking({
  required this.vehicle,
  required this.parkingSpace,
  required this.startTime,
  required this.stopTime
  });

  Map<String, dynamic> toJson() => {
    'vehicle': vehicle,
    'parkingspace': parkingSpace,
    'startTime': startTime.toIso8601String(),
    'stopTime': stopTime.toIso8601String(),
  };

  factory Parking.fromJson(Map<String, dynamic> json) => Parking(
    vehicle: Vehicle.fromJson(json['vehicle']), 
    parkingSpace: ParkingSpace.fromJson(json['parkingspace']), 
    startTime: DateTime.parse(json['startTime']), 
    stopTime: DateTime.parse(json['stopTime']),
    );
}