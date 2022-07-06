import 'package:flutter/material.dart';
import 'package:wasalny_driver/brand_colors.dart';
import 'package:wasalny_driver/widgets/TaxiOutlineButton.dart';
import 'package:wasalny_driver/widgets/taxibutton.dart';

class ConfirmSheet extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function onPressed;


  ConfirmSheet({
    required this.title,
    required this.subTitle,
    required this.onPressed
});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0, // soften the shadow
            spreadRadius: 0.5, //extend the shadow
            offset: Offset(
              0.7, // Move to right 10  horizontally
              0.7, // Move to bottom 10 Vertically
            ),
          ),
        ],
      ),
      height: 220,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 18),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Text(
                title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: BrandColors.colorText),
            ),
            SizedBox(height: 15,),

            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: BrandColors.colorTextLight),
            ),
            SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    child: TaxiOutlineButton(
                        title: 'BACK',
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        color: Colors.green
                    ),
                  ),
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: Container(
                    child: TaxiButton(
                        title: 'CONFIRM',
                        onPressed:onPressed,
                        color:(title=='GO ONLINE')?BrandColors.colorYellow:
                            Colors.red
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

