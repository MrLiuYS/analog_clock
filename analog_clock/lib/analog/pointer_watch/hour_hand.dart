/*
 * @Description: 时针
 * @Author: MrLiuYS
 * @Date: 2020-01-08 21:28:34
 * @LastEditors  : MrLiuYS
 * @LastEditTime : 2020-01-08 21:33:02
 */

import 'package:analog_clock/util/analog_util.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class HourHand extends StatefulWidget {
  final DateTime dateTime;

  final double longSideSpacing;

  final double shortSideSpacing;

  final double sideWidth;

  final Color sideColor;

  final Color centerPointColor;

  final double centerRadius;

  HourHand(
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
  _HourHandState createState() => _HourHandState();
}

class _HourHandState extends State<HourHand> {
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
      painter: HourHandPainter(widget.dateTime,
          longSideSpacing: widget.longSideSpacing,
          shortSideSpacing: widget.shortSideSpacing,
          sideColor: widget.sideColor,
          sideWidth: widget.sideWidth,
          centerPointColor: widget.centerPointColor,
          centerRadius: widget.centerRadius),
    );
  }
}

class HourHandPainter extends CustomPainter {
  final DateTime dateTime;

  final double longSideSpacing;

  final double shortSideSpacing;

  final double sideWidth;

  final Color sideColor;

  final Color centerPointColor;

  final double centerRadius;

  Paint _centerCirclePaint;

  Paint _calendarPaint;

  HourHandPainter(
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

    //+1 是因为表盘是从 * 开始算的
    double hour = dateTime.hour.toDouble() ;

    hour = hour + dateTime.minute / 60;

    Path path = Path()
      ..moveTo(
          radius -
              math.cos(AnalogUtil.deg2Rad(360.0 / 12 * hour - 90)) *
                  (shortSideSpacing),
          radius -
              math.sin(AnalogUtil.deg2Rad(360.0 / 12 * hour - 90)) *
                  (shortSideSpacing));
    path.lineTo(
        radius -
            math.cos(AnalogUtil.deg2Rad(360.0 / 12 * (hour) - 45)) *
                (shortSideSpacing / 3),
        radius -
            math.sin(AnalogUtil.deg2Rad(360.0 / 12 * (hour) - 45)) *
                (shortSideSpacing / 3));

    path.lineTo(
        radius +
            math.cos(AnalogUtil.deg2Rad(360.0 / 12 * hour - 90)) *
                (radius - longSideSpacing),
        radius +
            math.sin(AnalogUtil.deg2Rad(360.0 / 12 * hour - 90)) *
                (radius - longSideSpacing));

    path.lineTo(
        radius -
            math.cos(AnalogUtil.deg2Rad(360 / 12 * (hour) - 135)) *
                (shortSideSpacing / 3),
        radius -
            math.sin(AnalogUtil.deg2Rad(360 / 12 * (hour) - 135)) *
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
