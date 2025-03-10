import 'package:school/models/parkingSpace.dart';
import 'package:school/models/vehicle.dart';

class Parking {
  Vehicle vehicle;
  Parkingspace parkingspace;
  DateTime startTime;
  DateTime stopTime;

  Parking({
  required this.vehicle,
  required this.parkingspace,
  required this.startTime,
  required this.stopTime
  });

  Map<String, dynamic> toJson() => {
    'vehicle': vehicle,
    'parkingspace': parkingspace,
    'startTime': startTime,
    'stopTime': stopTime,
  };

  factory Parking.fromJson(Map<String, dynamic> json) => Parking(
    vehicle: json['vehicle'], 
    parkingspace: json['parkingspace'], 
    startTime: json['startTime'], 
    stopTime: json['stopTime'],
    );
}