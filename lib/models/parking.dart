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
    'startTime': startTime,
    'stopTime': stopTime,
  };

  factory Parking.fromJson(Map<String, dynamic> json) => Parking(
    vehicle: json['vehicle'], 
    parkingSpace: json['parkingspace'], 
    startTime: json['startTime'], 
    stopTime: json['stopTime'],
    );
}