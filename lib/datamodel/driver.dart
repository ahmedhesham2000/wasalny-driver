import 'package:firebase_database/firebase_database.dart';
import 'package:wasalny_driver/globalVariables.dart';

class Driver{
  late String? fullName;
  late String? email;
  late String? phone;
  late String? id;
  Driver({
    required this.email,
    required this.fullName,
    required this.phone,
    required this.id,
});

}