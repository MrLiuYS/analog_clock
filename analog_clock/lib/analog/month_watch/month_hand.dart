/*
 * @Description: 月历指针
 * @Author: MrLiuYS
 * @Date: 2020-01-07 22:21:38
 * @LastEditors  : MrLiuYS
 * @LastEditTime : 2020-01-07 22:49:46
 */

import 'package:analog_clock/util/analog_util.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class MonthHand extends StatefulWidget {
  final DateTime dateTime;

  final double longSideSpacing;

  final double shortSideSpacing;

  final double sideWidth;

  final Color sideColor;

  final Color centerPointColor;

  final double centerRadius;

  MonthHand(
      {Key key,
      this.dateTime,
      this.longSideSpacing = 10,
      this.shortSideSpacing = 10,
      this.sideWidth = 1,
      this.sideColor = Colors.black,
      this.centerPointColor = Colors.black,
      this.centerRadius = 3})
      : super(key: key);

  @override
  _MonthHandState createState() => _MonthHandState();
}

class _MonthHandState extends State<MonthHand> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MonthHandPainter(widget.dateTime,
          longSideSpacing: widget.longSideSpacing,
          shortSideSpacing: widget.shortSideSpacing,
          sideColor: widget.sideColor,
          sideWidth: widget.sideWidth,
          centerPointColor: widget.centerPointColor,
          centerRadius: widget.centerRadius),
    );
  }
}

class MonthHandPainter extends CustomPainter {
  final DateTime dateTime;

  final double longSideSpacing;

  final double shortSideSpacing;

  final double sideWidth;

  final Color sideColor;

  final Color centerPointColor;

  final double centerRadius;

  Paint _centerCirclePaint;

  Paint _calendarPaint;

  MonthHandPainter(
    this.dateTime, {
    this.longSideSpacing,
    this.shortSideSpacing,
    this.sideWidth,
    this.sideColor,
    this.centerPointColor,
    this.centerRadius,
  }) {
    _centerCirclePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = centerPointColor;

    _calendarPaint = Paint()
      ..color = sideColor
      ..strokeWidth = sideWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //圆心
    Offset _centerOffset = Offset(size.width / 2.0, size.height / 2.0);

    //半径
    double radius = math.min(size.width / 2.0, size.height / 2.0);

    // double month = dateTime.month.toDouble();

    print("今天是${dateTime.day} : ${dateTime.hour}");

    //+1 是因为表盘是从 * 开始算的
    double day = dateTime.day.toDouble() + 1;

    day = day + dateTime.hour / 24.0;

    Path path = Path()
      ..moveTo(
          radius -
              math.cos(AnalogUtil.deg2Rad(360.0 / 32 * day - 90)) *
                  (shortSideSpacing),
          radius -
              math.sin(AnalogUtil.deg2Rad(360.0 / 32 * day - 90)) *
                  (shortSideSpacing));
    path.lineTo(
        radius -
            math.cos(AnalogUtil.deg2Rad(360.0 / 32 * (day) - 45)) *
                (shortSideSpacing / 3),
        radius -
            math.sin(AnalogUtil.deg2Rad(360.0 / 32 * (day) - 45)) *
                (shortSideSpacing / 3));

    path.lineTo(
        radius +
            math.cos(AnalogUtil.deg2Rad(360.0 / 32 * day - 90)) *
                (radius - longSideSpacing),
        radius +
            math.sin(AnalogUtil.deg2Rad(360.0 / 32 * day - 90)) *
                (radius - longSideSpacing));

    path.lineTo(
        radius -
            math.cos(AnalogUtil.deg2Rad(360 / 32 * (day) - 135)) *
                (shortSideSpacing / 3),
        radius -
            math.sin(AnalogUtil.deg2Rad(360 / 32 * (day) - 135)) *
                (shortSideSpacing / 3));

    canvas.drawShadow(path, Colors.white, 2, true);
    canvas.drawPath(path, _calendarPaint);

    canvas.drawCircle(_centerOffset, centerRadius, _centerCirclePaint);

    canvas.save();

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
