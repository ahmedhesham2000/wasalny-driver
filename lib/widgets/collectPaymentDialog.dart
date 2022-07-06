import 'package:flutter/material.dart';
import 'package:wasalny_driver/brand_colors.dart';
import 'package:wasalny_driver/helpers/helpermethods.dart';
import 'package:wasalny_driver/widgets/BrandDivider.dart';
import 'package:wasalny_driver/widgets/taxibutton.dart';

class CollectPayment extends StatelessWidget {
  final String paymentMethod;
  final int fares;

  CollectPayment({required this.paymentMethod,required this.fares});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            SizedBox(height: 20,),

            Text('${paymentMethod.toUpperCase()} PAYMENT'),

            SizedBox(height: 20,),

            BranDivider(),

            SizedBox(height: 16.0,),

            Text('\$$fares', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),),

            SizedBox(height: 16,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Amount above is the total fares to be charged to the rider', textAlign: TextAlign.center,),
            ),

            SizedBox(height: 30,),

            Container(
              width: 230,
              child: TaxiButton(
                title: (paymentMethod == 'card') ? 'COLLECT CASH' : 'CONFIRM',
                color: BrandColors.colorYellow,
                onPressed: (){

                  Navigator.pop(context);
                  Navigator.pop(context);

                  HelperMethods.enableHomeTabLocationUpdates();

                },
              ),
            ),

            SizedBox(height: 40,)
          ],
        )
      ),
    );
  }
}