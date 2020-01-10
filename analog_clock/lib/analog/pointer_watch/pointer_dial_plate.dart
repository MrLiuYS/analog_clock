/*
 * @Description: 表盘(pointer dial plate)
 * @Author: MrLiuYS
 * @Date: 2019-12-28 11:16:13
 * @LastEditors  : MrLiuYS
 * @LastEditTime : 2020-01-11 00:14:57
 */

import 'package:analog_clock/util/analog_config.dart';
import 'package:analog_clock/util/analog_util.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'dart:ui';

class PointerDialPlate extends CustomPainter {
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

  ///文字画笔
  TextPainter _textPainter;

  ///大外圆
  Paint _bigCirclePaint;

  ///粗刻度线
  Paint _linePaint;

  PointerDialPlate({
    this.bgColor = Colors.transparent,
    this.bigCircleStrokeWidth = 4,
    this.bigCircleColor = Colors.black,
    this.tickMarksStrokeWidth = 1,
    this.tickMarksStrokeLength = 4,
    this.tickMarksColor = Colors.black,
    this.numberTextsColor = Colors.black,
    this.numberTextsFontSize = 16,
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

  List<String> numberTexts = AnalogConfig.hourNumberTexts;

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
          math.cos(AnalogUtil.deg2Rad(6 * i - 90)) * secondDistance + radius,
          math.sin(AnalogUtil.deg2Rad(6 * i - 90)) * secondDistance + radius);

      Offset innerOffset = Offset(
          math.cos(AnalogUtil.deg2Rad(6 * i - 90)) * radius + radius,
          math.sin(AnalogUtil.deg2Rad(6 * i - 90)) * radius + radius);

      _linePaint.strokeWidth = i % 5 == 0 ? 2 : 1; //设置线的粗细
      canvas.drawLine(offset, innerOffset, _linePaint);
    }
    canvas.save();
    canvas.translate(radius, radius);

    AnalogUtil.drawDialPlateText(
      canvas,
      numberTexts,
      radius,
      0.0,
      -radius + bigCircleStrokeWidth * 5,
      _textPainter,
      numberTextsColor,
      numberTextsFontSize,
    );

    canvas.restore();

    //绘制圆心
    canvas.drawCircle(_centerOffset, 1, _bigCirclePaint);

    // canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
