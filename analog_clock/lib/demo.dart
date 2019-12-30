import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class Demo extends StatelessWidget {
  const Demo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: 300,
          width: 300,
          color: Colors.white,
          child: CustomPaint(painter: CustomClock()),
        ),
        Positioned(
          left: 40,
          bottom: 40,
          child: Container(
            height: 100,
            width: 100,
            color: Colors.transparent,
            child: CustomPaint(painter: CustomClock(
               numberTexts: [
                  "1",
                  "2",
                  "3",
                  "4",
                  "5",
                  "6",
                  "7",
                  "8",
                  "9",
                  "10",
                  "11",
                  "12"
                ],
                bgColor: Colors.white,
                numberTextsFontSize: 10,
                bigCircleStrokeWidth: 2,
            )),
          ),
        ),
        Positioned(
          right: 35,
          bottom: 35,
          // bottom: 0,
          child: Container(
            height: 140,
            width: 140,
            color: Colors.transparent,
            child: CustomPaint(
              painter: CustomClock(
                numberTexts: [
                  "",
                  "",
                  "15",
                  "",
                  "",
                  "30",
                  "",
                  "",
                  "45",
                  "",
                  "",
                  "60"
                ],
                bgColor: Colors.white,
                numberTextsFontSize: 10,
                bigCircleStrokeWidth: 2,
              ),
            ),
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

  final double numberTextsFontSize;

  //文字画笔
  TextPainter _textPainter;
  //大外圆
  Paint _bigCirclePaint;

  //粗刻度线
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

    // List<String> numberText = [
    //   "Ⅰ",
    //   "Ⅱ",
    //   "Ⅲ",
    //   "Ⅳ",
    //   "Ⅴ",
    //   "Ⅵ",
    //   "Ⅶ",
    //   "Ⅷ",
    //   "Ⅸ",
    //   "Ⅹ",
    //   "XI",
    //   "XII"
    // ];
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
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  //角度转弧度
  num deg2Rad(num deg) => deg * (math.pi / 180.0);
}
