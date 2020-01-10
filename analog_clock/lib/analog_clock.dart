import 'dart:async';

import 'package:analog_clock/analog/pointer_watch/hour_hand.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'analog/calendar_watch/calendar_dial_plate.dart';
import 'analog/calendar_watch/calendar_hand.dart';
import 'analog/month_watch/month_dial_plate.dart';
import 'analog/month_watch/month_hand.dart';
import 'analog/pointer_watch/minute_hand.dart';
import 'analog/pointer_watch/pointer_dial_plate.dart';
import 'analog/second_watch/second_dial_plate.dart';
import 'analog/second_watch/second_hand.dart';
import 'analog_provider.dart';

class AnalogClock extends StatefulWidget {
  AnalogClock({Key key}) : super(key: key);

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  Timer _timer;

  AnalogProvider _analogProvider;

  @override
  void initState() {
    super.initState();

    _analogProvider = AnalogProvider();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _analogProvider.dateTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _analogProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnalogProvider>.value(
      value: _analogProvider,
      child: Consumer<AnalogProvider>(builder: (context, analogProvider, _) {
        return watchWidget(context, analogProvider, _);
      }),
    );
  }

  Widget watchWidget(BuildContext context, AnalogProvider value, Widget child) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: 300,
            width: 300,
            color: Colors.white,
            child: CustomPaint(painter: PointerDialPlate()),
          ),
          Positioned(
            left: 40,
            bottom: 70,
            child: Container(
              height: 90,
              width: 90,
              color: Colors.transparent,
              child: CustomPaint(
                  painter: CalendarDialPlate(
                bgColor: Colors.white,
                numberTextsFontSize: 10,
                bigCircleStrokeWidth: 2,
              )),
            ),
          ),
          Positioned(
            right: 40,
            bottom: 40,
            // bottom: 0,
            child: Container(
              height: 110,
              width: 110,
              color: Colors.transparent,
              child: CustomPaint(
                painter: SecondDialPlate(),
              ),
            ),
          ),
          Positioned(
            top: 30,
            child: Container(
              height: 100,
              width: 100,
              color: Colors.transparent,
              child: CustomPaint(
                painter: MonthDialPlate(),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: 40,
            // bottom: 0,
            child: Container(
              height: 110,
              width: 110,
              color: Colors.transparent,
              child: SecondHand(dateTime: _analogProvider.dateTime),
            ),
          ),
          Positioned(
            left: 40,
            bottom: 70,
            child: Container(
              height: 90,
              width: 90,
              color: Colors.transparent,
              child: CalendarHand(dateTime: _analogProvider.dateTime),
            ),
          ),
          Positioned(
            top: 30,
            child: Container(
              height: 100,
              width: 100,
              color: Colors.transparent,
              child: MonthHand(dateTime: _analogProvider.dateTime),
            ),
          ),
          Container(
            height: 300,
            width: 300,
            child: HourHand(
              dateTime: _analogProvider.dateTime,
              sideColor: Colors.grey[850],
              centerPointColor: Colors.grey[850],
            ),
          ),
          Container(
            height: 300,
            width: 300,
            child: MinuteHand(
              dateTime: _analogProvider.dateTime,
              sideColor: Colors.grey[850],
              centerPointColor: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
