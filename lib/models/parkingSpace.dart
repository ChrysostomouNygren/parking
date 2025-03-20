class ParkingSpace {
  String id;
  String address;
  double pricePerH;

  ParkingSpace({required this.id, required this.address, required this.pricePerH});
  Map<String, dynamic> toJson() => {'id': id, 'address': address, 'pricePerH': pricePerH};

  factory ParkingSpace.fromJson(Map<String, dynamic> json) => ParkingSpace(
    id: json['id'], 
    address: json['address'], 
    pricePerH: (json['pricePerH'] as num).toDouble());
}