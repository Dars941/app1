import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Joystick extends StatefulWidget {
  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  DatabaseReference _ref = FirebaseDatabase.instance.reference();

  double joystickX = 0.0;
  double joystickY = 0.0;

  void updateDb(String direction) {
    _ref.child('joystick').set(direction);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onJoystickPanStart,
      onPanUpdate: _onJoystickPanUpdate,
      onPanEnd: _onJoystickPanEnd,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment(joystickX, joystickY),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 60,
                height: 2,
                color: Colors.blue,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 2,
                height: 60,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onJoystickPanStart(DragStartDetails details) {
    _updateJoystickPosition(details.localPosition);
  }

  void _onJoystickPanUpdate(DragUpdateDetails details) {
    _updateJoystickPosition(details.localPosition);
  }

  void _onJoystickPanEnd(DragEndDetails details) {
    _updateJoystickPosition(Offset(0, 0));
  }

  void _updateJoystickPosition(Offset position) {
    double dx = position.dx / (100 / 2); // Divide by half of container's width
    double dy = position.dy / (100 / 2); // Divide by half of container's height

    // Clamp joystick position
    dx = dx.clamp(-1.0, 1.0);
    dy = dy.clamp(-1.0, 1.0);

    setState(() {
      joystickX = dx;
      joystickY = dy;
    });

    // Print movement direction
    if (dx > 0.4) {
      print('Move Right');
      updateDb('Right');
    } else if (dx < -0.4) {
      print('Move Left');
      updateDb('Left');
    } else if (dy > 0.4) {
      print('Move Down');
      updateDb('Down');
    } else if (dy < -0.4) {
      print('Move Up');
      updateDb('Up');
    }

    // Update Firebase Realtime Database
    _ref.child('joystick').update({
      // 'x': joystickX,
      // 'y': joystickY,
    });
  }
}
