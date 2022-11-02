import 'package:auth_app/screens/workout_entries/workout_sets_widget.dart';
import 'package:flutter/material.dart';

class WorkOutWidget extends StatefulWidget {
  const WorkOutWidget({Key? key}) : super(key: key);

  @override
  State<WorkOutWidget> createState() => _WorkOutWidgetState();
}

class _WorkOutWidgetState extends State<WorkOutWidget> {
  String exerciseTypeValue = 'Dumbell Bench';
  TextEditingController setController = TextEditingController();

  List<Widget> _setList = [];

  void _addWorkoutSet() {
    setState(() {
      _setList.add(
        WorkoutSet(index: _setList.length + 1),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Exercise',
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(
              width: 20,
            ),
            //Exercise
            DropdownButton<String>(
                value: exerciseTypeValue,
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
                elevation: 24,
                borderRadius: BorderRadius.circular(12),
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
                items: <String>['Dumbell Bench', 'Barbell Bench']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    exerciseTypeValue = newValue!;
                  });
                }),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: _setList.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  setState(() {
                    _setList.removeAt(index);
                  });
                },
                child: _setList[index],
                background: Container(
                  color: Colors.red,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              );
            }),
        ElevatedButton(
          onPressed: _addWorkoutSet,
          child: Text('add new set'),
        ),
      ],
    );
  }
}
