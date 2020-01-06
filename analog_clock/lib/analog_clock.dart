import 'package:flutter/material.dart';

import 'analog/calendar_watch/calendar_dial_plate.dart';
import 'analog/pointer_watch/pointer_dial_plate.dart';
import 'analog/second_watch/second_dial_plate.dart';

class AnalogClock extends StatefulWidget {
  AnalogClock({Key key}) : super(key: key);

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(100, 100, 100, 100),
      width: 300,
      height: 300,
      child: Stack(
        // alignment: Alignment.center,
        // fit: StackFit.expand,
        // overflow: Overflow.visible,
        children: <Widget>[
          // PointerDialPlate(),
          // Center(
          //   child: PointerDialPlate(),
          // ),
          // SecondDialPlate(),
          // CalendarDialPlate(),
          // Positioned(
          //   // top: 50,
          //   // left: 50,
          //   child: Container(
          //     width: 100,
          //     height: 100,
          //     // color: Colors.green,
          //     child: CalendarDialPlate(),
          //   ),
          // ),

          // Positioned(
          //   // bottom: 10.0,
          //   // top: 150,
          //   // right: 150.0,
          //   child: SecondDialPlate(),
          //   // child: SecondDialPlate(),
          // ),
          Positioned(
            top: 30.0,
            child: Text("I am Jack"),
          ),
        ],
      ),
    );
    // return Container(
    //   child: PointerDialPlate(),

    // );
  }
}
