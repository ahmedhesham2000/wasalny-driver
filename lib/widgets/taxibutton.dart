import 'package:flutter/material.dart';
import 'package:wasalny_driver/brand_colors.dart';


import 'package:flutter/material.dart';
import 'package:wasalny_driver/brand_colors.dart';


class TaxiButton extends StatelessWidget {

  final String title;
  final Color color;
  var onPressed;

  TaxiButton({required this.title,required this.onPressed,required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(25)
            ),
          ),
          backgroundColor: MaterialStateProperty.all(color),

      ),

      child: Container(
        height: 50,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold',color: Colors.black),
          ),
        ),
      ),
    );
  }
}
// class TaxiButton extends StatelessWidget {
//   final String title;
//   final Color color;
//    var onPressed;
//   TaxiButton({required this.title, required this.color, required this.onPressed});
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: onPressed, child: Text(title),
//       style: ButtonStyle(
//           foregroundColor: MaterialStateProperty.all(color)
//       ),
//     );
//   }
// }
