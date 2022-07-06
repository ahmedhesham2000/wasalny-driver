import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:wasalny_driver/brand_colors.dart';
import 'package:wasalny_driver/datamodel/ridereqestinfo.dart';
import 'package:wasalny_driver/globalvariables.dart';
import 'package:wasalny_driver/helpers/helpermethods.dart';
import 'package:wasalny_driver/screens/newtripscreen.dart';
import 'package:wasalny_driver/widgets/BrandDivider.dart';
import 'package:wasalny_driver/widgets/ProgressDialog.dart';
import 'package:wasalny_driver/widgets/TaxiOutlineButton.dart';
import 'package:wasalny_driver/widgets/taxibutton.dart';

class NotificationDialog extends StatelessWidget{
  final RideRequestInfo rideRequestInfo;
  const NotificationDialog ({required this.rideRequestInfo});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),

        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30,),

            Image.asset('assets/images/taxi.png',width: 100,),

            SizedBox(height: 16,),

            Text('NEW TRIP REQUEST',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            SizedBox(height: 30,),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/pickicon.png'),

                      SizedBox(width: 18,),


                      Expanded(
                        child: Container(
                            child: Text(rideRequestInfo.pickupAddress!,style: TextStyle(fontSize: 18),)
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/desticon.png'),
                      SizedBox(width: 18,),

                      Expanded(
                        child: Container(
                            child: Text(rideRequestInfo.destinationAddress!,style: TextStyle(fontSize: 18),)
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),

            SizedBox(height: 20,),

            BranDivider(),

            SizedBox(height: 8,),

            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: TaxiOutlineButton(
                        title: 'DECLINE',
                        color: BrandColors.colorPrimary,
                        onPressed: () async{
                          assetsAudioPlayer.stop();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: 10,),

                  Expanded(
                    child: Container(
                      child: TaxiButton(
                        title: 'ACCEPT',
                        color: BrandColors.colorYellow,
                        onPressed: () async{
                          assetsAudioPlayer.stop();
                          checkAvailability(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkAvailability(context){
    showDialog(context: context,
        builder: (BuildContext context)=>ProgressDialog(status: 'Accepting request'),
        barrierDismissible: false
    );

    DatabaseReference newRideRef=FirebaseDatabase.instance.ref().child('drivers/${currentFireBaseUser.currentUser!.uid}/newtrip');
    String? thisRideID;
    newRideRef.once().then((DatabaseEvent event){

      Navigator.pop(context);
      Navigator.pop(context);
      if(event.snapshot.value !=null){
        thisRideID=event.snapshot.value.toString();
      }
      else {
        Toast.show("Ride not found1111111", duration: Toast.lengthShort, gravity:  Toast.bottom);      }
      if(thisRideID == rideID ){
          newRideRef.set('accept');
          HelperMethods.disableHomTabLocation();
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>NewTripPage(rideRequestInfo: rideRequestInfo,))
          );
      }
      else if(thisRideID=='cancelled'){
        Toast.show("Ride has been cancelled", duration: 5, gravity:  Toast.top,backgroundColor: Colors.blueAccent); }
      else if(thisRideID=='timeout'){
        Toast.show("Ride has timed out", duration: 5, gravity:  Toast.center,backgroundColor: Colors.blueAccent);      }
      else{
        Toast.show("Ride not found 22222", duration: Toast.lengthShort, gravity:  Toast.bottom);
      }
    });
  }
}