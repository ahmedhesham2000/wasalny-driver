import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasalny_driver/brand_colors.dart';
import 'package:wasalny_driver/datamodel/ridereqestinfo.dart';
import 'package:wasalny_driver/globalvariables.dart';
import 'package:wasalny_driver/helpers/helpermethods.dart';
import 'package:wasalny_driver/helpers/mapkithelper.dart';
import 'package:wasalny_driver/widgets/ProgressDialog.dart';
import 'package:wasalny_driver/widgets/collectPaymentDialog.dart';
import 'package:wasalny_driver/widgets/taxibutton.dart';

class NewTripPage extends StatefulWidget {
  final RideRequestInfo rideRequestInfo;
  NewTripPage({required this.rideRequestInfo});
  @override
  State<NewTripPage> createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {
  late GoogleMapController rideMapController;
  Completer<GoogleMapController> _controller = Completer();
  double mapPaddingBottom=0;

  Set<Marker> _markers=Set<Marker>();
  Set<Circle> _circles=Set<Circle>();
  Set<Polyline> _polyLines=Set<Polyline>();

  List<LatLng> polylineCoordinates=[];
  PolylinePoints polylinePoints=PolylinePoints();

  var geoLocator=Geolocator();
  var locationOptions=LocationSettings(accuracy:LocationAccuracy.bestForNavigation);

  BitmapDescriptor? movingMarketIcon;

  Position? myPosition;
  String status='accepted';

  String durationString='';

  bool isRequestingDirection=false;

  String buttonTitle='ARRIVED';

  Color buttonColor=BrandColors.colorYellow;

  Timer? timer;
  int durationCounter=0;

  void createMarker(){
    if(movingMarketIcon == null){
      ImageConfiguration imageConfiguration =createLocalImageConfiguration(context,size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration,'assets/images/car_android.png').then((icon){
        setState(() {
          movingMarketIcon =icon;
        });
      });

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    acceptTrip();
  }

  @override
  Widget build(BuildContext context) {
    createMarker();
    return Scaffold(
      body: Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(bottom: mapPaddingBottom),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          circles: _circles,
          polylines: _polyLines,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            rideMapController=controller;

            setState(() {
              mapPaddingBottom=(Platform.isIOS)?255:260;
            });

            var currentLatLng=LatLng(currentPosition.latitude,currentPosition.longitude);
            var pickupLatLng=widget.rideRequestInfo.pickup;
            await getDirection(currentLatLng,pickupLatLng!);

            getLocationUpdate();
          },
          initialCameraPosition: googlePlex,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  )
                )
              ]
            ),
            height: (Platform.isIOS)?280:255,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(durationString,style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: BrandColors.colorAccentPurple,
                    ),
                    ),
                    SizedBox(height: 5,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.rideRequestInfo.riderName!,
                          style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.call),
                        ),

                      ],
                    ),

                    SizedBox(height: 25,),

                    Row(
                      children: [
                        Image.asset('assets/images/pickicon.png'),
                        SizedBox(width: 18,),

                        Expanded(
                            child: Container(
                              child: Text(
                                widget.rideRequestInfo.pickupAddress!,
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 18
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                        )
                      ],
                    ),

                    SizedBox(height: 15,),


                    Row(
                      children: [
                        Image.asset('assets/images/desticon.png'),
                        SizedBox(width: 18,),

                        Expanded(
                            child: Container(
                              child: Text(
                                widget.rideRequestInfo.destinationAddress!,
                                style: TextStyle(
                                    fontSize: 18
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                        )
                      ],
                    ),
                    SizedBox(height: 25,),

                    TaxiButton(
                      title: buttonTitle,
                      color: buttonColor,
                      onPressed: ()async {
                        if (status == 'accepted') {

                          status = 'arrived';
                          rideRef!.child('status').set('arrived');


                          setState(() {
                            buttonTitle = 'START TRIP';
                            buttonColor = BrandColors.colorAccentPurple;
                          });

                          HelperMethods.showProgressDialog(context);
                          await getDirection(widget.rideRequestInfo.pickup!,widget.rideRequestInfo.destination!);

                          Navigator.pop(context);
                        }
                        else if(status == 'arrived'){
                          status='onTrip';
                          rideRef!.child('status').set('onTrip');


                          setState(() {

                            buttonTitle='END TRIP';
                            buttonColor=Colors.red;

                          });
                          startTimer();
                        }
                        else if(status=='onTrip'){
                          endTrip();
                        }
                      },

                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
      ),
    );
  }

  void acceptTrip(){
   String rideId=rideID;
   rideRef=FirebaseDatabase.instance.ref().child('rideRequest/$rideId');

   rideRef!.child('status').set('accepted');
   rideRef!.child('driver_name').set(currentDriverInfo!.fullName);
   rideRef!.child('driver_phone').set(currentDriverInfo!.phone);
   rideRef!.child('driver_id').set(currentDriverInfo!.id);

   Map locationMap={
     'latitude':currentPosition.latitude.toString(),
     'longitude':currentPosition.longitude.toString(),
   };
   
   rideRef!.child('driver_location').set(locationMap);

   DatabaseReference historyRef=FirebaseDatabase.instance.ref().child('drivers/${currentFireBaseUser.currentUser!.uid}/history/$rideId');
   historyRef.set(true);

  }

  void getLocationUpdate(){

    LatLng oldPosition=LatLng(0, 0);

    ridePositionStream=Geolocator.getPositionStream(locationSettings: locationOptions).listen((Position position){
      myPosition=position;
      currentPosition=position;
      LatLng pos=LatLng(position.latitude,position.longitude);

      double rotation=MapKitHelper.getMarkerRotation(oldPosition.latitude,oldPosition.longitude, pos.latitude,pos.longitude);

      Marker movingMarker=Marker(
          markerId: MarkerId('moving'),
          position: pos,
          icon: movingMarketIcon!,
          rotation: rotation,
          infoWindow: InfoWindow(title:'Current Location' )
      );

      setState(() {
        CameraPosition cp = new CameraPosition(target: pos,zoom: 17);
        rideMapController.animateCamera(CameraUpdate.newCameraPosition(cp));
        _markers.removeWhere( (marker) => marker.markerId.value=='moving' );
        _markers.add(movingMarker);
      });

      oldPosition=pos;

      updateTripDetails();

      Map locationMap={
        'latitude':myPosition!.latitude.toString(),
        'longitude':myPosition!.longitude.toString(),
      };

      rideRef!.child('driver_location').set(locationMap);

    });
  }

  void updateTripDetails()async{

    if(!isRequestingDirection){
      isRequestingDirection=true;

      if(myPosition == null){
        return;
      }

      var positionLatLng=LatLng(myPosition!.latitude, myPosition!.longitude);
      LatLng destinationLatLng;

      if(status=='accepted'){
        destinationLatLng = widget.rideRequestInfo.pickup!;

      }else{
        destinationLatLng=widget.rideRequestInfo.destination!;
      }
      var directionDetails= await HelperMethods.getDirectionDetails(positionLatLng,destinationLatLng);
      //print('sheeeeeesh ${directionDetails!.durationText}');

      if(directionDetails != null){

        setState(() {
          durationString=directionDetails.durationText;
        });
      }
    }
     isRequestingDirection=false;
  }

  Future<void> getDirection(LatLng pickupLatLng,LatLng destinationLatLng)async{

    showDialog(context: context, builder: (BuildContext context)=>ProgressDialog(status: 'please wait....'));

    var thisDetails=await HelperMethods.getDirectionDetails(pickupLatLng, destinationLatLng);


    Navigator.pop(context);


    PolylinePoints polylinePoints=PolylinePoints();
    List<PointLatLng> results=polylinePoints.decodePolyline(thisDetails!.encodingPoints);

    polylineCoordinates.clear();
    if(results.isNotEmpty){
      //loop through all pointLatLng points and convert them
      //to list of LatLng required by polyLines
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude,point.longitude));
      });


    }
    _polyLines.clear();
    setState(() {
      Polyline polyLine=Polyline(
        polylineId: PolylineId('polyid'),
        color: Colors.black,
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polyLines.add(polyLine);

    });

    //make polyline to fit in the map

    LatLngBounds bounds;

    if(pickupLatLng.latitude>destinationLatLng.latitude&& pickupLatLng.longitude>destinationLatLng.longitude){
      bounds=LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    }
    else if(pickupLatLng.longitude>destinationLatLng.longitude){
      bounds =LatLngBounds(
          southwest: LatLng(pickupLatLng.latitude,destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude,pickupLatLng.longitude)
      );
    }
    else if(pickupLatLng.latitude>destinationLatLng.latitude){

      bounds =LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude,pickupLatLng.longitude),
          northeast: LatLng(pickupLatLng.latitude,destinationLatLng.longitude)
      );

    }
    else{
      bounds =LatLngBounds(
        southwest: pickupLatLng,
        northeast: destinationLatLng,
      );
    }
    rideMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker=Marker(
      markerId: MarkerId('pickup'),
      position: pickupLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    Marker destinationMarker=Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );
    setState(() {
      _markers.add(pickupMarker);
      _markers.add(destinationMarker);
    });

    Circle pickupCircle=Circle(
        circleId: CircleId('pickup'),
        strokeColor: Colors.green,
        strokeWidth: 3,
        radius: 12,
        center: pickupLatLng,
        fillColor: Colors.green
    );
    Circle destinationCircle=Circle(
        circleId: CircleId('destination'),
        strokeColor: Colors.blueAccent,
        strokeWidth: 3,
        radius: 12,
        center: pickupLatLng,
        fillColor: Colors.blueAccent
    );
    setState(() {
      _circles.add(pickupCircle);
      _circles.add(destinationCircle);
    });
  }

  void startTimer(){
    const interval=Duration(seconds: 1);
    timer=Timer.periodic(
        interval,
            (timer) {
          durationCounter++;
            });

  }

  void endTrip()async{
       timer!.cancel();

       HelperMethods.showProgressDialog(context);
       var currentLatLng=LatLng(myPosition!.latitude,myPosition!.longitude);
       
       Navigator.pop(context);
       
       var directionDetails=await HelperMethods.getDirectionDetails(widget.rideRequestInfo.pickup!, currentLatLng);
       
       
       int fares=HelperMethods.estimateFair(directionDetails!, durationCounter);
       
       rideRef!.child('fares').set(fares.toString());
       
       rideRef!.child('status').set('ended');

       ridePositionStream!.cancel();

       showDialog(
         barrierDismissible: false,
           context: context,
           builder: (BuildContext context)=>CollectPayment(
               paymentMethod: widget.rideRequestInfo.paymentMethod!,
               fares: fares,
           )
       );
       topUpEarnings(fares);

  }

  void topUpEarnings(int fares){
    DatabaseReference earningsRef=FirebaseDatabase.instance.ref('drivers/${currentFireBaseUser.currentUser!.uid}/earnings');
    earningsRef.once().then((DatabaseEvent databaseEvent){
      if(databaseEvent.snapshot.value != null){
        print('a7a');
        double oldEarnings=double.parse(databaseEvent.snapshot.value.toString());

        double adjustedEarnings=(fares.toDouble()*0.85)+oldEarnings;

        earningsRef.set(adjustedEarnings.toStringAsFixed(2));

      }
      else {
        double adjustedEarnings=(fares.toDouble()*0.85);
        earningsRef.set(adjustedEarnings.toStringAsFixed(2));


      }
    });
  }

}
