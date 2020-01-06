/*
 * @Description: 周历,日历框
 * @Author: MrLiuYS
 * @Date: 2019-12-28 22:24:28
 * @LastEditors  : MrLiuYS
 * @LastEditTime : 2020-01-06 20:41:11
 */
import 'package:analog_clock/util/analog_util.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'dart:ui';

class WeekDialPlate extends CustomPainter {
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

  WeekDialPlate({
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

  List<String> numberTexts = [
    "•",
    "1",
    "•",
    "3",
    "•",
    "5",
    "•",
    "7",
    "•",
    "9",
    "•",
    "11",
    "•",
    "13",
    "•",
    "15",
    "•",
    "17",
    "•",
    "19",
    "•",
    "21",
    "•",
    "23",
    "•",
    "25",
    "•",
    "27",
    "•",
    "29",
    "•",
    "31",
    
  ];

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
    for (int i = 0; i < numberTexts.length; i++) {
      Offset offset = Offset(
          math.cos(AnalogUtil.deg2Rad(360 / numberTexts.length * i - 90)) *
                  secondDistance +
              radius,
          math.sin(AnalogUtil.deg2Rad(360 / numberTexts.length * i - 90)) *
                  secondDistance +
              radius);

      Offset innerOffset = Offset(
          math.cos(AnalogUtil.deg2Rad(360 / numberTexts.length * i - 90)) * radius +
              radius,
          math.sin(AnalogUtil.deg2Rad(360 / numberTexts.length * i - 90)) * radius +
              radius);

      _linePaint.strokeWidth = i % 2 == 0 ? 2 : 1; //设置线的粗细
      canvas.drawLine(offset, innerOffset, _linePaint);
    }
    canvas.save();
    canvas.translate(radius, radius);

    for (var i = 0; i < numberTexts.length; i++) {
      canvas.rotate(AnalogUtil.deg2Rad(
          360 / numberTexts.length)); // deg2Rad(360 / numberTexts.length * i )

      String numberStr = numberTexts[i];

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

    canvas.restore();

    //绘制圆心
    canvas.drawCircle(_centerOffset, 1, _bigCirclePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  
  
}
