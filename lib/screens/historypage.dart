import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasalny_driver/brand_colors.dart';
import 'package:wasalny_driver/dataprovider.dart';
import 'package:wasalny_driver/widgets/BrandDivider.dart';
import 'package:wasalny_driver/widgets/historytile.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip History'),
        backgroundColor: BrandColors.colorYellow,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return HistoryTile(
            history: Provider.of<AppData>(context).tripHistory[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) => BranDivider(),
        itemCount: Provider.of<AppData>(context).tripHistory.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap:  true,
      ),
    );
  }
}