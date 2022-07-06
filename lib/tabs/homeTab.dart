import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasalny_driver/brand_colors.dart';
import 'package:wasalny_driver/datamodel/driver.dart';
import 'package:wasalny_driver/globalvariables.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wasalny_driver/helpers/helpermethods.dart';
import 'package:wasalny_driver/helpers/pushnotificationService.dart';
import 'package:wasalny_driver/widgets/AvailabilityButton.dart';
import 'package:wasalny_driver/widgets/confirmSheet.dart';
import 'package:wasalny_driver/widgets/notificationDialog.dart';

class HomeTab extends StatefulWidget {

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String availabilityTitle='GO ONLINE';
  Color availabilityColor=BrandColors.colorYellow;

  bool isAvailable=false;

  bool isSwitched = false;
  late GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  late Geolocator geoLocator=Geolocator();
  //String rideID='-N29AILqOP-BkdNEhOgp';


  var locationOptions=LocationSettings(accuracy:LocationAccuracy.bestForNavigation,distanceFilter: 4 );

  void getCurrentPosition()async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(pos));

    //var address=HelperMethods.findCordinateAddress(position,context);
  }


  void getCurrentDriverInfo()async {

    currentFireBaseUser= FirebaseAuth.instance;
    // var userUid=currentFireBaseUser?.currentUser!.uid;
    //DatabaseReference driverRef=FirebaseDatabase.instance.ref().child('drivers/${userId}');
    var driverUid=currentFireBaseUser.currentUser?.uid;
    final driverRef=FirebaseDatabase.instance.ref();

    final fullNameSnap= await driverRef.child('drivers/$driverUid/fullName').get();
    final emailSnap= await driverRef.child('drivers/$driverUid/email').get();
    final phoneSnap= await driverRef.child('drivers/$driverUid/phone').get();
    final idSnap= await driverRef.child('drivers/$driverUid').get();

    driver=Driver(email: emailSnap.value.toString(), fullName: fullNameSnap.value.toString(), phone: phoneSnap.value.toString(), id: driverUid.toString());
    driverRef.once().then((DatabaseEvent databaseEvent){
      if(databaseEvent.snapshot.value != null){
        print('sheeeeeeeeeeeeeeeeeesh ${driver!.fullName}');
        currentDriverInfo=driver;
      }
    });

    PushNotificationService pushNotificationService=PushNotificationService();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.data}');
      }

      rideID =message.data['ride_id'];
      print('ride ID = $rideID');
      pushNotificationService.fetchRideInfo(rideID,context);

    });



   // pushNotificationService.getDriverInfo();
    pushNotificationService.getToken();
    HelperMethods.getHistoryInfo(context);
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentDriverInfo();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 100),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: googlePlex,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
            mapController = controller;

            getCurrentPosition();
          },
        ),
        Container(
          height: 80,
          width: double.infinity,
          color: Colors.white,
        ),
        Positioned(
          top: 30,
          left: 0,
          right: 0,

          child: Padding(
            padding:  EdgeInsets.only( left: 10),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AvailabilityButton(
                  title: availabilityTitle,
                  color: availabilityColor,
                  onPressed: (){
                    showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (BuildContext context) => ConfirmSheet(
                        title: (!isAvailable) ? 'GO ONLINE' : 'GO OFFLINE',
                        subTitle: (!isAvailable) ? 'You are about to become available to receive trip requests': 'You will stop receiving new trip requests',

                        onPressed: (){

                          if(!isAvailable){
                            GoOnline();
                            getLocationUpdate();
                            Navigator.pop(context);

                            setState(() {
                              availabilityColor = BrandColors.colorGreen;
                              availabilityTitle = 'GO OFFLINE';
                              isAvailable = true;
                            });

                          }
                          else{
                            GoOffline();
                            Navigator.pop(context);
                            setState(() {
                              availabilityColor = BrandColors.colorYellow;
                              availabilityTitle = 'GO ONLINE';
                              isAvailable = false;
                            });
                          }

                        },
                      ),
                    );
                  },
                ),
              ],
            ),

          ),
        )
      ],

    );


  }
  void GoOnline(){
    //currentFireBaseUser=FirebaseAuth.instance;

    Geofire.initialize('driversAvailable');
    Geofire.setLocation(userId, currentPosition.latitude, currentPosition.longitude);

    tripRequestRef=FirebaseDatabase.instance.ref().child('drivers/${userId}/newtrip');

    tripRequestRef.set('waiting');

    // tripRequestRef.onValue.listen(
    //         (event) {
    // });
  }
  void GoOffline(){
    Geofire.removeLocation(currentFireBaseUser.currentUser!.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef!=null;
  }


  void getLocationUpdate(){


    homeTabPositionStream=Geolocator.getPositionStream(locationSettings: locationOptions).listen((Position position) {
      currentPosition =position;

      if(isAvailable){
        Geofire.setLocation(userId, position.latitude, position.longitude);
      }

      LatLng pos=LatLng(position.latitude, position.latitude);
      mapController.animateCamera(CameraUpdate.newLatLng(pos));

    });

  }
}
