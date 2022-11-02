import 'package:auth_app/screens/workout_entries/workout.dart';
import 'package:flutter/material.dart';

class CreatePushEntryPage extends StatelessWidget {
  const CreatePushEntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new Push entry'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: WorkOutWidget(),
              padding: EdgeInsets.all(12.0),
              alignment: Alignment.center,
            ),
            Container(child: WorkOutWidget(), padding: EdgeInsets.all(12.0)),
          ],
        ),
      ),
    );
  }
}
