import 'dart:async';

import 'package:analog_clock/analog/pointer_watch/hour_hand.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

import 'analog/calendar_watch/calendar_dial_plate.dart';
import 'analog/calendar_watch/calendar_hand.dart';
import 'analog/month_watch/month_dial_plate.dart';
import 'analog/month_watch/month_hand.dart';
import 'analog/pointer_watch/minute_hand.dart';
import 'analog/pointer_watch/pointer_dial_plate.dart';
import 'analog/second_watch/second_dial_plate.dart';
import 'analog/second_watch/second_hand.dart';

class Demo extends StatefulWidget {
  Demo({Key key}) : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  Timer timer;
  DateTime datetime;

  @override
  void initState() {
    super.initState();

    datetime = DateTime.now();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        datetime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // timer.cancel();
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
          left: 40,
          bottom: 70,
          child: Container(
            height: 90,
            width: 90,
            color: Colors.transparent,
            child: CalendarHand(
                dateTime: datetime,
                sideColor: Colors.blue,
                centerRadius: 3,
                centerPointColor: Colors.blue),
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
              painter: SecondDialPlate(
                bigCircleStrokeWidth: 2,
                bgColor: Colors.white,
                numberTextsFontSize: 10,
              ),
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
            child: SecondHand(
              dateTime: datetime,
              centerPointColor: Colors.red,
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
              painter: MonthDialPlate(
                bgColor: Colors.white,
                numberTextsFontSize: 10,
                bigCircleStrokeWidth: 2,
              ),
            ),
          ),
        ),
        Positioned(
          // left: 50,
          top: 30,
          // bottom: 0,
          child: Container(
            height: 100,
            width: 100,
            color: Colors.transparent,
            child: MonthHand(
                dateTime: datetime,
                sideColor: Colors.green,
                centerRadius: 3,
                centerPointColor: Colors.green),
          ),
        ),
        Container(
          height: 300,
          width: 300,
          child: HourHand(
            dateTime: datetime,
            longSideSpacing: 70,
            shortSideSpacing: 20,
            centerRadius: 10,
            sideColor: Colors.grey[850],//Color(0xFF4285F4),
            centerPointColor: Colors.grey[850],//Color(0xFF4285F4),
          ),
        ),
        Container(
          height: 300,
          width: 300,
          child: MinuteHand(
            dateTime: datetime,
            longSideSpacing: 20,
            shortSideSpacing: 20,
            sideColor: Colors.grey[850],//Color(0xFF4285F4),
            // sideColor: Colors.blue[900],
            centerRadius: 6,
            centerPointColor: Colors.grey[700],//Color(0xFF8AB4F8),
          ),
        ),
      ],
    ));
  }
}

class CustomClock extends CustomPainter {
  final List<String> numberTexts;

  final Color bgColor;

  /// 外边圆宽度,默认4
  final double bigCircleStrokeWidth;

  /// 外边圆颜色,默认黑色
  final Color bigCircleColor;

  /// 刻度线宽度
  final double tickMarksStrokeWidth;

  /// 刻度线长度
  final double tickMarksStrokeLength;

  /// 刻度线颜色
  final Color tickMarksColor;

  /// 文字颜色
  final Color numberTextsColor;

  /// 文字字体
  final double numberTextsFontSize;

  /// 显示秒针
  final bool showSecond;

  /// 显示分钟
  final bool showMinute;

  /// 显示时针
  final bool showHour;

  ///文字画笔
  TextPainter _textPainter;

  ///大外圆
  Paint _bigCirclePaint;

  ///粗刻度线
  Paint _linePaint;

  CustomClock({
    this.bgColor = Colors.transparent,
    this.numberTexts = const [
      "Ⅰ",
      "Ⅱ",
      "Ⅲ",
      "Ⅳ",
      "Ⅴ",
      "Ⅵ",
      "Ⅶ",
      "Ⅷ",
      "Ⅸ",
      "Ⅹ",
      "XI",
      "XII"
    ],
    this.bigCircleStrokeWidth = 4,
    this.bigCircleColor = Colors.black,
    this.tickMarksStrokeWidth = 1,
    this.tickMarksStrokeLength = 4,
    this.tickMarksColor = Colors.black,
    this.numberTextsColor = Colors.black,
    this.numberTextsFontSize = 16,
    this.showSecond = false,
    this.showMinute = false,
    this.showHour = false,
  }) {
    _textPainter = new TextPainter(
        textAlign: TextAlign.left, textDirection: TextDirection.ltr);

    _bigCirclePaint = Paint()
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..color = bigCircleColor
      ..strokeWidth = bigCircleStrokeWidth;

    _linePaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = tickMarksColor
      ..strokeWidth = tickMarksStrokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //圆心
    Offset _centerOffset = Offset(size.width / 2.0, size.height / 2.0);

    //半径
    double radius = math.min(size.width / 2.0, size.height / 2.0);

    //刻度线的长度
    double secondDistance =
        radius - bigCircleStrokeWidth - tickMarksStrokeLength;

    //绘制背景色
    canvas.drawCircle(
        _centerOffset,
        (size.width - bigCircleStrokeWidth) / 2,
        Paint()
          ..style = PaintingStyle.fill
          ..isAntiAlias = true
          ..color = bgColor);

    //绘制大圆
    canvas.drawCircle(_centerOffset, (size.width - bigCircleStrokeWidth) / 2,
        _bigCirclePaint);

    //绘制刻度
    for (int i = 0; i < 60; i++) {
      Offset offset = Offset(
          math.cos(deg2Rad(6 * i - 90)) * secondDistance + radius,
          math.sin(deg2Rad(6 * i - 90)) * secondDistance + radius);

      Offset innerOffset = Offset(
          math.cos(deg2Rad(6 * i - 90)) * radius + radius,
          math.sin(deg2Rad(6 * i - 90)) * radius + radius);

      _linePaint.strokeWidth = i % 5 == 0 ? 2 : 1; //设置线的粗细
      canvas.drawLine(offset, innerOffset, _linePaint);
    }
    canvas.save();
    canvas.translate(radius, radius);

    for (var i = 0; i < 60; i++) {
      String numberStr = numberTexts[((i ~/ 5) == 0 ? 12 : (i ~/ 5)) - 1];
      if (i % 5 == 0) {
        canvas.save();
        canvas.translate(0.0, -radius + bigCircleStrokeWidth * 5);
        _textPainter.text = TextSpan(
            style: new TextStyle(
              color: numberTextsColor,
              fontSize: numberTextsFontSize,
            ),
            text: numberStr);

        _textPainter.layout();
        _textPainter.paint(canvas,
            new Offset(-(_textPainter.width / 2), -(_textPainter.height / 2)));
        canvas.restore();
      }
      canvas.rotate(deg2Rad(360 / 60));
    }

    canvas.restore();

    // draw second hand

    //绘制圆心
    // canvas.drawCircle(_centerOffset, 6, _bigCirclePaint);

    DateTime dateTime = DateTime.now();

    if (showHour) {
      final hourPaint = Paint()
        ..color = Colors.grey[850]
        ..strokeWidth = 8;
      int hour = dateTime.hour;

      Path path = Path()
        ..moveTo(radius - math.cos(deg2Rad(360 / 12 * hour - 90)) * (20),
            radius - math.sin(deg2Rad(360 / 12 * hour - 90)) * (20));
      path.lineTo(radius - math.cos(deg2Rad(360 / 12 * (hour) - 45)) * (7),
          radius - math.sin(deg2Rad(360 / 12 * (hour) - 45)) * (7));

      path.lineTo(
          radius + math.cos(deg2Rad(360 / 12 * hour - 90)) * (radius * 0.5),
          radius + math.sin(deg2Rad(360 / 12 * hour - 90)) * (radius * 0.5));

      path.lineTo(radius - math.cos(deg2Rad(360 / 12 * (hour) - 135)) * (7),
          radius - math.sin(deg2Rad(360 / 12 * (hour) - 135)) * (7));

      canvas.drawShadow(path, Colors.white, 2, true);
      canvas.drawPath(path, hourPaint);
    }

    if (showMinute) {
      final minutePaint = Paint()
        ..color = Colors.grey[700]
        ..strokeWidth = 3;

      int minute = dateTime.minute;

      Path path = Path()
        ..moveTo(radius - math.cos(deg2Rad(360 / 60 * minute - 90)) * (20),
            radius - math.sin(deg2Rad(360 / 60 * minute - 90)) * (20));
      path.lineTo(radius - math.cos(deg2Rad(360 / 60 * (minute) - 45)) * (5),
          radius - math.sin(deg2Rad(360 / 60 * (minute) - 45)) * (5));

      path.lineTo(
          radius + math.cos(deg2Rad(360 / 60 * minute - 90)) * (radius * 0.7),
          radius + math.sin(deg2Rad(360 / 60 * minute - 90)) * (radius * 0.7));

      path.lineTo(radius - math.cos(deg2Rad(360 / 60 * (minute) - 135)) * (5),
          radius - math.sin(deg2Rad(360 / 60 * (minute) - 135)) * (5));

      canvas.drawShadow(path, Colors.black, 2, true);
      canvas.drawPath(path, minutePaint);
    }

    if (showSecond) {
      int second = dateTime.second;

      Offset secondHand1 = Offset(
          radius - math.cos(deg2Rad(360 / 60 * second - 90)) * (radius * 0.1),
          radius - math.sin(deg2Rad(360 / 60 * second - 90)) * (radius * 0.1));
      Offset secondHand2 = Offset(
          radius +
              math.cos(deg2Rad(360 / 60 * second - 90)) *
                  (radius - bigCircleStrokeWidth * 8),
          radius +
              math.sin(deg2Rad(360 / 60 * second - 90)) *
                  (radius - bigCircleStrokeWidth * 8));
      final secondPaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 1;
      canvas.drawLine(secondHand1, secondHand2, secondPaint);
    }

    //绘制圆心
    canvas.drawCircle(_centerOffset, 1, _bigCirclePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  //角度转弧度
  num deg2Rad(num deg) => deg * (math.pi / 180.0);
}
