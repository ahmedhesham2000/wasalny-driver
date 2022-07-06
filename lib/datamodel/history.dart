import 'package:firebase_database/firebase_database.dart';

class History{
  String? pickup;
  String? destination;
  String? fares;
  String? status;
  String? createdAt;
  String? paymentMethod;

  History({
    required this.pickup,
    required this.destination,
    required this.fares,
    required this.status,
    required this.createdAt,
    required this.paymentMethod,
  });

  History.fromSnapshot(DatabaseEvent event){
    pickup = (event.snapshot.value as Map)['pickup_address'];
    destination = (event.snapshot.value as Map)['destination_address'];
    fares = (event.snapshot.value as Map)['fares'].toString();
    createdAt = (event.snapshot.value as Map)['created_at'];
    status = (event.snapshot.value as Map)['status'];
    paymentMethod = (event.snapshot.value as Map)['payment_method'];
  }

}