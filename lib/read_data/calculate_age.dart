import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgeCalculator extends StatelessWidget {
  final String birthday;

  AgeCalculator({required this.birthday});

  String calculateAge(String birthDay) {
    DateTime currentDate = DateTime.now();
    var date = DateFormat('yyyy-MM-dd')
        .format(DateFormat('dd-MM-yyyy').parse(birthDay));
    DateTime bDate = DateTime.parse(date);
    int age = currentDate.year - bDate.year;
    String ageString = age.toString();
    return ageString;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(calculateAge(birthday)),
    );
  }
}
