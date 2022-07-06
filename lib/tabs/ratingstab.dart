import 'package:flutter/material.dart';
import 'package:wasalny_driver/brand_colors.dart';
import 'package:wasalny_driver/widgets/BrandDivider.dart';

class RatingsTab extends StatelessWidget {
  const RatingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Feedbacks'),
        backgroundColor: BrandColors.colorYellow,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body:
        Padding(
          padding: const EdgeInsets.only(left: 20.0,top: 20),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good driver',style: TextStyle(
                fontSize: 20,
              ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 10,),
              BranDivider(),
              SizedBox(height: 10,),
              // Text('Trustworthy',style: TextStyle(
              //   fontSize: 20,
              // ),
              //   textAlign: TextAlign.start,
              // ),
              //
              // SizedBox(height: 10,),
              // BranDivider(),
            ],
          ),
        )
      // ListView.separated(
      //   padding: EdgeInsets.all(0),
      //   itemBuilder: (context,index) {
      //     return HistoryTile(
      //       history: Provider.of<AppData>(context).tripHistory[index],
      //     );
      //   },
      //   separatorBuilder: (BuildContext context, int index) => BranDivider(),
      //   itemCount: Provider.of<AppData>(context).tripHistory.length,
      //   physics: ClampingScrollPhysics(),
      //   shrinkWrap:  true,
      // ),
    );
  }
}
