import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideRequestInfo{
  late LatLng? pickup;
  late String? pickupAddress;


  late LatLng? destination;
  late String? destinationAddress;

  late String? paymentMethod;

  String? riderName;
  String? riderPhone;

  RideRequestInfo({
   required this.pickup,
   required this.pickupAddress,

   required this.destination,
   required this.destinationAddress,

    required this.paymentMethod,

    required this.riderName,
    required this.riderPhone,
});
}