import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasalny_driver/brand_colors.dart';
import 'package:wasalny_driver/dataprovider.dart';
import 'package:wasalny_driver/screens/historypage.dart';
import 'package:wasalny_driver/widgets/BrandDivider.dart';

class EarningsTab extends StatelessWidget {
  const EarningsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: BrandColors.colorYellow,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                Text(' Total Earnings',style: TextStyle(color: Colors.white),),
                Text('\$${Provider.of<AppData>(context).earnings}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 40))
              ],
            ),
          ),
        ),
        TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> HistoryPage()));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:30,vertical: 18 ),
              child: Row(
                children: [
                  Image.asset('assets/images/taxi.png',width: 70,),

                  SizedBox(width: 26,),

                  Text('Trips',style: TextStyle(fontSize: 16,color:Colors.black),),
                  Expanded(child: Container(child: Text(Provider.of<AppData>(context).tripCount.toString(), textAlign: TextAlign.end, style: TextStyle(fontSize: 18,color: Colors.black),))),

                ],
              ),
            )
        ),
        BranDivider(),
      ],
    );
  }
}
