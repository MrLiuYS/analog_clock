/*
 * @Description: 工具类
 * @Author: MrLiuYS
 * @Date: 2020-01-06 20:36:25
 * @LastEditors  : MrLiuYS
 * @LastEditTime : 2020-01-11 00:12:18
 */
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class AnalogUtil {
  ///角度转弧度
  static num deg2Rad(num deg) => deg * (pi / 180.0);

  /// 绘制表盘的文字
  static void drawDialPlateText(
    Canvas canvas,
    List<String> numberTexts,
    num radius,
    double translateX,
    double translateY,
    TextPainter textPainter,
    Color textColor,
    double fontSize,
  ) {
    for (var i = 0; i < numberTexts.length; i++) {
      canvas.rotate(AnalogUtil.deg2Rad(360 / numberTexts.length));

      String numberStr = numberTexts[i];

      canvas.save();
      canvas.translate(translateX, translateY);
      textPainter.text = TextSpan(
          style: new TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
          text: numberStr);

      textPainter.layout();
      textPainter.paint(canvas,
          new Offset(-(textPainter.width / 2), -(textPainter.height / 2)));
      canvas.restore();
    }
  }

  /// 绘制指针
  static void pointHand(
      Canvas canvas,
      Paint paint,
      num radius,
      num handValue,
      num averageNum,
      num shortSideSpacing,
      num longSideSpacing,
      num otherSideSpacing,
      {bool isDrawShadow = false}) {
    Path path = Path()
      ..moveTo(
          radius -
              math.cos(
                      AnalogUtil.deg2Rad(360.0 / averageNum * handValue - 90)) *
                  (shortSideSpacing),
          radius -
              math.sin(
                      AnalogUtil.deg2Rad(360.0 / averageNum * handValue - 90)) *
                  (shortSideSpacing));
    path.lineTo(
        radius -
            math.cos(
                    AnalogUtil.deg2Rad(360.0 / averageNum * (handValue) - 45)) *
                otherSideSpacing,
        radius -
            math.sin(
                    AnalogUtil.deg2Rad(360.0 / averageNum * (handValue) - 45)) *
                otherSideSpacing);

    path.lineTo(
        radius +
            math.cos(AnalogUtil.deg2Rad(360.0 / averageNum * handValue - 90)) *
                (radius - longSideSpacing),
        radius +
            math.sin(AnalogUtil.deg2Rad(360.0 / averageNum * handValue - 90)) *
                (radius - longSideSpacing));

    path.lineTo(
        radius -
            math.cos(AnalogUtil.deg2Rad(360 / averageNum * (handValue) - 135)) *
                otherSideSpacing,
        radius -
            math.sin(AnalogUtil.deg2Rad(360 / averageNum * (handValue) - 135)) *
                otherSideSpacing);

    if (isDrawShadow) {
      canvas.drawShadow(path, Colors.white, 2, true);
    }

    canvas.drawPath(path, paint);
  }
}
