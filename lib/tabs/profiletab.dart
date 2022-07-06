import 'package:flutter/material.dart';
import 'package:wasalny_driver/brand_colors.dart';
import 'package:wasalny_driver/globalvariables.dart';
import 'package:wasalny_driver/widgets/BrandDivider.dart';
import 'package:wasalny_driver/widgets/taxibutton.dart';

class ProfileTab extends StatelessWidget {

  String? UserName =driver?.fullName;
  String? phone =driver?.phone;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: BrandColors.colorYellow,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 100),
            child: Column(
              children: [
                Text('${UserName!}',style: TextStyle(color: Colors.white,fontSize: 25),),
                SizedBox(height: 10,),
                Text(phone!,style: TextStyle(color: Colors.white,fontSize: 20),),
              ],
            ),
          ),
        ),
        SizedBox(height: 360,),
        TaxiButton(title: 'Logout', onPressed: (){}, color:Colors.red)

      ],
    );
  }
}
