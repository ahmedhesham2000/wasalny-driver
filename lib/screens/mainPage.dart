import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:wasalny_driver/brand_colors.dart';
import 'package:wasalny_driver/tabs/earingstab.dart';
import 'package:wasalny_driver/tabs/homeTab.dart';
import 'package:wasalny_driver/tabs/profiletab.dart';
import 'package:wasalny_driver/tabs/ratingstab.dart';
import 'package:wasalny_driver/widgets/taxibutton.dart';

class MainPage extends StatefulWidget {
  static const String routName='mainPage';
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>with SingleTickerProviderStateMixin {

  late TabController tabController;

  int selectedIndex=0;
  void onItemClick(int index){
    setState(() {
      selectedIndex=index;
      tabController.index=selectedIndex;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController=TabController(length: 4, vsync: this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            HomeTab(),
            EarningsTab(),
            RatingsTab(),
            ProfileTab(),
          ],
        ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
            label: 'Earnings',
          ),
           BottomNavigationBarItem(
              icon: Icon(Icons.star),
            label: 'Ratings',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
            label: 'Profile',

          ),
        ],
        unselectedItemColor: BrandColors.colorIcon,
        selectedItemColor: BrandColors.colorOrange,
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        selectedLabelStyle:TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        onTap: onItemClick,
      ),
    );
  }
}
