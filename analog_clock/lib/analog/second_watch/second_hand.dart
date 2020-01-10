/*
 * @Description: 秒针
 * @Author: MrLiuYS
 * @Date: 2020-01-06 20:13:46
 * @LastEditors  : MrLiuYS
 * @LastEditTime : 2020-01-11 00:27:28
 */
import 'package:analog_clock/util/analog_util.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SecondHand extends StatefulWidget {
  final DateTime dateTime;

  final double longSideSpacing;

  final double shortSideSpacing;

  final double sideWidth;

  final Color sideColor;

  final Color centerPointColor;

  final double centerRadius;

  SecondHand(
      {Key key,
      this.dateTime,
      this.longSideSpacing = 10,
      this.shortSideSpacing = 10,
      this.sideWidth = 1,
      this.sideColor = Colors.red,
      this.centerPointColor = Colors.red,
      this.centerRadius = 3})
      : super(key: key);

  @override
  _SecondHandState createState() => _SecondHandState();
}

class _SecondHandState extends State<SecondHand>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  double _second = 0;

  DateTime _dateTime;

  @override
  void initState() {
    super.initState();

    _dateTime = DateTime.now();

    _controller =
        AnimationController(vsync: this, duration: Duration(minutes: 1))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: SecondHandPainter(_dateTime,
                second: (_controller.value * 60 + _dateTime.second),
                longSideSpacing: widget.longSideSpacing,
                shortSideSpacing: widget.shortSideSpacing,
                sideColor: widget.sideColor,
                sideWidth: widget.sideWidth,
                centerPointColor: widget.centerPointColor,
                centerRadius: widget.centerRadius),
          );
        });
  }
}

class SecondHandPainter extends CustomPainter {
  final DateTime dateTime;

  final double second;

  final double longSideSpacing;

  final double shortSideSpacing;

  final double sideWidth;

  final Color sideColor;

  final Color centerPointColor;

  final double centerRadius;

  Paint _centerCirclePaint;

  Paint _secondPaint;

  SecondHandPainter(
    this.dateTime, {
    this.second,
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

    _secondPaint = Paint()
      ..color = sideColor
      ..strokeWidth = sideWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //圆心
    Offset _centerOffset = Offset(size.width / 2.0, size.height / 2.0);

    //半径
    double radius = min(size.width / 2.0, size.height / 2.0);

    double pSecond = second ?? dateTime.second;

    AnalogUtil.pointHand(canvas, _secondPaint, radius, pSecond, 60,
        shortSideSpacing, longSideSpacing, shortSideSpacing / 5,
        isDrawShadow: true);

    canvas.drawCircle(_centerOffset, centerRadius, _centerCirclePaint);

    canvas.save();

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
