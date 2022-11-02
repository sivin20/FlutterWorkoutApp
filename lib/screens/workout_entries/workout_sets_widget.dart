import 'package:flutter/material.dart';

class WorkoutSet extends StatefulWidget {
  int index;

  WorkoutSet({required this.index});

  @override
  State<WorkoutSet> createState() => _WorkoutSetState(index: index);
}

class _WorkoutSetState extends State<WorkoutSet> {
  String repValue = '5';
  String weightValue = '10';
  int index;

  _WorkoutSetState({required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Set ${index.toString()}:'),
        SizedBox(width: 10),
        //Sets
        DropdownButton<String>(
            value: repValue,
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
            elevation: 24,
            borderRadius: BorderRadius.circular(12),
            underline: Container(
              height: 2,
              color: Colors.blueAccent,
            ),
            items: List<String>.generate(21, (index) => "$index").map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                repValue = newValue!;
              });
            }),
        SizedBox(
          width: 10,
        ),
        Text('reps,'),
        SizedBox(
          width: 10,
        ),
        DropdownButton<String>(
            value: weightValue,
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
            elevation: 24,
            borderRadius: BorderRadius.circular(12),
            underline: Container(
              height: 2,
              color: Colors.blueAccent,
            ),
            items: List<String>.generate(301, (index) => "$index")
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                weightValue = newValue!;
              });
            }),
        SizedBox(
          width: 10,
        ),
        Text('kg'),
        Expanded(
            child: Align(
          alignment: Alignment.bottomRight,
          child: Icon(
            Icons.delete_sweep,
            color: Colors.red,
          ),
        )),
      ],
    );
  }
}
