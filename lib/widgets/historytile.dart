import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasalny_driver/brand_colors.dart';
import 'package:wasalny_driver/datamodel/history.dart';
import 'package:wasalny_driver/dataprovider.dart';
import 'package:wasalny_driver/helpers/helpermethods.dart';

class HistoryTile extends StatelessWidget {

  final History history;
  HistoryTile({required this.history});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: <Widget>[

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Container(
                child: Row(
                  children: <Widget>[

                    Image.asset('assets/images/pickicon.png', height: 16, width: 16,),
                    SizedBox(width: 18,),
                    Expanded(child: Container(child: Text(history.pickup!, overflow: TextOverflow.fade, style: TextStyle(fontSize: 18),))),
                    SizedBox(width: 5,),

                    Text('\$ ${Provider.of<AppData>(context).earnings}', style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 16, color: BrandColors.colorPrimary),),
                  ],
                ),
              ),

              SizedBox(height: 8,),

              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset('assets/images/desticon.png', height: 16, width: 16,),
                  SizedBox(width: 18,),

                  Text(history.destination!, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18),),


                ],
              ),

              SizedBox(height: 15,),

              Text(HelperMethods.formatMyDate(history.createdAt!), style: TextStyle(color: BrandColors.colorTextLight),),
            ],
          ),


        ],
      ),
    );
  }
}