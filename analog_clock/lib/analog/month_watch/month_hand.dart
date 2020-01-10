/*
 * @Description: 月历指针
 * @Author: MrLiuYS
 * @Date: 2020-01-07 22:21:38
 * @LastEditors  : MrLiuYS
 * @LastEditTime : 2020-01-11 00:30:24
 */

import 'package:analog_clock/util/analog_util.dart';
import 'package:flutter/material.dart';
import 'dart:math';

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
      this.sideColor = Colors.green,
      this.centerPointColor = Colors.green,
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
    double radius = min(size.width / 2.0, size.height / 2.0);

    //+1 是因为表盘是从 * 开始算的
    double day = dateTime.day.toDouble() + 1;

    day = day + dateTime.hour / 24.0;

    AnalogUtil.pointHand(
      canvas,
      _calendarPaint,
      radius,
      day,
      32,
      shortSideSpacing,
      longSideSpacing,
      shortSideSpacing / 5,
      isDrawShadow: true,
    );

    canvas.drawCircle(_centerOffset, centerRadius, _centerCirclePaint);

    canvas.save();

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
