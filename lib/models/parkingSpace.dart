import 'package:school/cli.dart';

class Parkingspace {
  String id;
  String address;
  double pricePerH;

  Parkingspace({required this.id, required this.address, required this.pricePerH});
  Map<String, dynamic> toJson() => {'id': id, 'address': address, 'pricePerH': pricePerH};

  factory Parkingspace.fromJson(Map<String, dynamic> json) => Parkingspace(
    id: json['id'], 
    address: json['address'], 
    pricePerH: json['pricePerH']);
}