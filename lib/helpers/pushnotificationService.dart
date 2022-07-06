import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:wasalny_driver/datamodel/ridereqestinfo.dart';
import 'package:wasalny_driver/globalvariables.dart';
import 'package:wasalny_driver/widgets/ProgressDialog.dart';
import 'package:wasalny_driver/widgets/notificationDialog.dart';

class PushNotificationService{
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  Future getToken() async{

    String? token=await fcm.getToken();
    print('token: $token');

    DatabaseReference tokenRef=FirebaseDatabase.instance.ref().child('drivers/${userId}/token');
    tokenRef.set(token);

    fcm.subscribeToTopic('alldrivers');
    fcm.subscribeToTopic('allusers');


  }
  void fetchRideInfo(String rideID,context)async{
    //show please wait dialog
    showDialog(context: context,
        builder: (BuildContext context)=>ProgressDialog(status: 'Fetching details'),
        barrierDismissible: false
    );

    DatabaseReference rideRef=FirebaseDatabase.instance.ref();
    rideRef.once().then((DatabaseEvent event) async {
      Navigator.pop(context);
      if(event.snapshot.value != null){

        assetsAudioPlayer.open(
          Audio('assets/sounds/alert.mp3'));
        assetsAudioPlayer.play();

        final pickupLat = await rideRef.child('rideRequest/$rideID/location/latitude').get();
        final pickupLong =await rideRef.child('rideRequest/$rideID/location/longitude').get();
        final pickupAddress=await rideRef.child('rideRequest/$rideID/pickup_address').get();

        final destinationLat=await rideRef.child('rideRequest/$rideID/destination/latitude').get();
        final destinationLong=await rideRef.child('rideRequest/$rideID/destination/longitude').get();
        final destinationAddress=await rideRef.child('rideRequest/$rideID/destination_address').get();

        final paymentMethod= await rideRef.child('rideRequest/$rideID/payment_method').get();

        final riderName= await rideRef.child('rideRequest/$rideID/rider_name').get();
        final riderPhone= await rideRef.child('rideRequest/$rideID/rider_phone').get();


        // RideRequestInfo rideRequestInfo=RideRequestInfo(pickupLat:pickupLat.value.toString(), pickupLong: pickupLong.value.toString(), pickupAddress: pickupAddress.value.toString(),
        //     destinationLat:destinationLat.value.toString(), destinationLong:destinationLong.value.toString(), destinationAddress: destinationAddress.value.toString(),
        //     paymentMethod: paymentMethod.value.toString());
        RideRequestInfo rideRequestInfo=RideRequestInfo(pickup:LatLng(double.parse(pickupLat.value.toString()),double.parse(pickupLong.value.toString())),
            pickupAddress: pickupAddress.value.toString(),
            destination: LatLng(double.parse(destinationLat.value.toString()),double.parse(destinationLong.value.toString())),
            destinationAddress: destinationAddress.value.toString(),
            paymentMethod: paymentMethod.value.toString(),
            riderName:riderName.value.toString(),
            riderPhone: riderPhone.value.toString(),

        );
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context)=>NotificationDialog(rideRequestInfo: rideRequestInfo),
        );
      }
    });
  }
}