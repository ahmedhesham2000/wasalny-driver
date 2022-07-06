import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wasalny_driver/datamodel/directiondetails.dart';
import 'package:wasalny_driver/datamodel/driver.dart';
import 'package:wasalny_driver/datamodel/history.dart';
import 'package:wasalny_driver/dataprovider.dart';
import 'package:wasalny_driver/globalvariables.dart';
import 'package:wasalny_driver/helpers/requesthelper.dart';
import 'package:wasalny_driver/widgets/ProgressDialog.dart';

class HelperMethods{
  //
  // static void getCurrentUserInfo()async{
  //   currentFireBaseUser= FirebaseAuth.instance;
  //  // var userUid=currentFireBaseUser?.currentUser!.uid;
  //   var userUid=currentFireBaseUser.currentUser?.uid;
  //   final userRef=FirebaseDatabase.instance.ref();
  //
  //   final fullNameSnap= await userRef.child('user/$userUid/fullName').get();
  //   final emailSnap= await userRef.child('user/$userUid/email').get();
  //   final phoneSnap= await userRef.child('user/$userUid/phone').get();
  //   final idSnap= await userRef.child('user/$userUid').get();
  //   users =Driver(email: emailSnap.value.toString(), fullName: fullNameSnap.value.toString(), phone: phoneSnap.value.toString(), id: idSnap.value.toString() );
  //
  //
  //   userRef.once().then((DatabaseEvent databaseEvent){
  //     if(databaseEvent.snapshot != null){
  //       print('sheeeeeeeeeeeeeeesh ${users!.fullName}');
  //     }
  //   });
  // }

  static Future<DirectionDetails?> getDirectionDetails(LatLng startPosition,LatLng endPosition)async{
   String url='https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';
   //print('sheeeeeeeeeeeeeeeeeeesh $url');
   var response = await RequestHelper.getRequest(url);
   //var duration=response['routes'][0]['legs'][0]['duration']['text'];

   if(response=='failed'){
     return null;
   }
   
   DirectionDetails directionDetails=DirectionDetails(
       distanceText: response['routes'][0]['legs'][0]['distance']['text'] as String,
       durationValue: response['routes'][0]['legs'][0]['distance']['value'],

       durationText: response['routes'][0]['legs'][0]['duration']['text'] as String,
       distanceValue: response['routes'][0]['legs'][0]['duration']['value'],

       encodingPoints: response['routes'][0]['overview_polyline']['points'],
   );
   //print("duration 2222 ${directionDetails.durationText}");
   return directionDetails;
  }

  static int estimateFair(DirectionDetails details,int durationValue){
    // km=0.7
    // time minute=0.5
    // base fare =3
    double baseFare=3;
    double distanceFare=(details.distanceValue/1000)*0.3;
    double timeFare=(durationValue/60)*0.2;

    double totalFare=baseFare+timeFare+distanceFare;

    return totalFare.truncate();
  }

  static double generateRandomNumber(int max){

    var randomGenerator=Random();
    int radInt=randomGenerator.nextInt(max);

    return radInt.toDouble();
  }

  static void disableHomTabLocation(){
    homeTabPositionStream!.pause();
    Geofire.removeLocation(currentFireBaseUser.currentUser!.uid);
  }

  static void enableHomeTabLocationUpdates(){
    homeTabPositionStream!.resume();
    Geofire.setLocation(currentFireBaseUser.currentUser!.uid, currentPosition.latitude, currentPosition.longitude);
  }

  static void showProgressDialog(context){
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context)=>ProgressDialog(status: 'please wait....')
    );
  }

  static void getHistoryInfo(context){
    DatabaseReference earningRef = FirebaseDatabase.instance.ref().child('drivers/${currentFireBaseUser.currentUser!.uid}/earnings');
    earningRef.once().then((DatabaseEvent event){
      if(event.snapshot.value != null){
        String earnings = event.snapshot.value.toString();
        Provider.of<AppData>(context,listen: false).updateEarnings(earnings);
      }
    });
    DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('drivers/${currentFireBaseUser.currentUser!.uid}/history');

    historyRef.once().then((DatabaseEvent event) {

      if(event.snapshot.value != null){

        Map values = event.snapshot.value as Map;
        int tripCount = values.length;

        // update trip count to data provider
        Provider.of<AppData>(context, listen: false).updateTripCount(tripCount);

        List<String> tripHistoryKeys = [];
        values.forEach((key, value) {tripHistoryKeys.add(key);});

        // update trip keys to data provider
        Provider.of<AppData>(context, listen: false).updateTripKeys(tripHistoryKeys);

        getHistoryData(context);

      }
    });
  }
  static void getHistoryData(context){

    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for(String key in keys){
      DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('rideRequest/$key');

      historyRef.once().then((DatabaseEvent event) {
        if(event.snapshot.value != null){

          var history = History.fromSnapshot(event);
          Provider.of<AppData>(context, listen: false).updateTripHistory(history);

          print(history.destination);
        }
      });
    }

  }
  static String formatMyDate(String datestring){

    DateTime thisDate = DateTime.parse(datestring);
    //String formattedDate = '${DateFormat.MMMd().format(thisDate)}, ${DateFormat.y().format(thisDate)} - ${DateFormat.jm().format(thisDate)}';

    return 'formattedDate';
  }

}