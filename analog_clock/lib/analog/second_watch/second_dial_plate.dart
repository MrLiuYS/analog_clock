/*
 * @Description: 秒表盘
 * @Author: MrLiuYS
 * @Date: 2019-12-28 17:20:37
 * @LastEditors  : MrLiuYS
 * @LastEditTime : 2020-01-06 20:07:42
 */
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class SecondDialPlate extends CustomPainter {
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

  SecondDialPlate({
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

  List<String> numberTexts = ["15", "30", "45", "60"];

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

    for (var i = 0; i < numberTexts.length; i++) {
      canvas.rotate(deg2Rad(
          360 / numberTexts.length));

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

    // canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  //角度转弧度
  num deg2Rad(num deg) => deg * (math.pi / 180.0);
}

// class SecondDialPlate extends StatelessWidget {
//   const SecondDialPlate({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: CustomPaint(painter: SeconddialPlatePainter()),
//     );
//   }
// }

// class SeconddialPlatePainter extends CustomPainter {
//   //背景圆
//   Paint _bgCirclePaint = Paint()
//     ..style = PaintingStyle.fill
//     ..isAntiAlias = true
//     ..color = Colors.white;

//   //大外圆
//   Paint _bigCirclePaint = Paint()
//     ..style = PaintingStyle.stroke
//     ..isAntiAlias = true
//     ..color = Colors.black
//     ..strokeWidth = 2;

//   //粗刻度线
//   Paint _linePaint = Paint()
//     ..style = PaintingStyle.fill
//     ..isAntiAlias = true
//     ..color = Colors.black
//     ..strokeWidth = 1;

//   //圆心
//   Offset _centerOffset = Offset(0, 0);

//   //圆半径
//   double _bigRadius = 70;

//   final int lineHeight = 5;

//   //文字画笔
//   TextPainter _textPainter = new TextPainter(
//       textAlign: TextAlign.left, textDirection: TextDirection.ltr);

//   @override
//   void paint(Canvas canvas, Size size) {
//     print('_bigRadius: ${_bigRadius}');

//     // canvas.drawCircle(_centerOffset, _bigRadius, _bgCirclePaint);
//     //绘制大圆
//     canvas.drawCircle(_centerOffset, _bigRadius, _bigCirclePaint);
//     //绘制圆心
//     _bigCirclePaint.style = PaintingStyle.fill;
//     canvas.drawCircle(_centerOffset, _bigRadius / 20, _bigCirclePaint);
//     //绘制刻度,秒针转一圈需要跳60下,这里只画6点整的刻度线，但是由于每画一条刻度线之后，画布都会旋转60°(转为弧度2*pi/60)，所以画出60条刻度线
//     for (int i = 0; i < 60; i++) {
//       _linePaint.strokeWidth = i % 5 == 0 ? (i % 3 == 0 ? 1 : 1) : 1; //设置线的粗细
//       canvas.drawLine(Offset(0, _bigRadius - lineHeight), Offset(0, _bigRadius),
//           _linePaint);
//       canvas.rotate(math.pi / 30); //2*math.pi/60
//     }
//     //方法一:绘制数字,此处暂时没想到更好的方法,TextPainter的绘制间距老有问题,不好控制
//     /*  _textPaint[0].layout();
//     _textPaint[0].paint(canvas, new Offset(-12, -_bigRadius+20));
//     _textPaint[1].layout();
//     _textPaint[1].paint(canvas, new Offset(_bigRadius-30,-12));
//     _textPaint[2].layout();
//     _textPaint[2].paint(canvas, new Offset(-6,_bigRadius-40));
//     _textPaint[3].layout();
//     _textPaint[3].paint(canvas, new Offset(-_bigRadius+20,-12));*/

//     //方法二:绘制数字,

//     List<String> numberText = [
//       "15",
//       "30",
//       "45",
//       "60",
//     ];

//     for (int i = 0; i < 12; i++) {
//       canvas.save(); //与restore配合使用保存当前画布
//       canvas.translate(0.0, -_bigRadius + 10); //平移画布画点于时钟的12点位置，+30为了调整数字与刻度的间隔
//       _textPainter.text = TextSpan(
//           style: new TextStyle(color: Colors.black, fontSize: 8),
//           text: numberText[i]);
//       // canvas.rotate(-deg2Rad(30) * i); //保持画数字的时候竖直显示。
//       _textPainter.layout();
//       _textPainter.paint(
//           canvas, Offset(-_textPainter.width / 2, -_textPainter.height / 2));
//       canvas.restore(); //画布重置,恢复到控件中心
//       canvas.rotate(deg2Rad(30)); //画布旋转一个小时的刻度，把数字和刻度对应起来

//     }
//     //绘制指针,这个也好理解
//     int hours = DateTime.now().hour;
//     int minutes = DateTime.now().minute;
//     int seconds = DateTime.now().second;
//     print("时: ${hours} 分：${minutes} 秒: ${seconds}");
//     //时针角度//以下都是以12点为0°参照
//     //12小时转360°所以一小时30°
//     double hoursAngle =
//         (minutes / 60 + hours - 12) * math.pi / 6; //把分钟转小时之后*（2*pi/360*30）
//     //分针走过的角度,同理,一分钟6°
//     double minutesAngle =
//         (minutes + seconds / 60) * math.pi / 30; //(2*pi/360*6)
//     //秒针走过的角度,同理,一秒钟6°
//     double secondsAngle = seconds * math.pi / 30;
//     // //画时针
//     // _linePaint.strokeWidth = 4;
//     // canvas.rotate(hoursAngle);
//     // canvas.drawLine(Offset(0, 0), new Offset(0, -_bigRadius + 80), _linePaint);
//     // //画分针
//     // _linePaint.strokeWidth = 2;
//     // canvas.rotate(-hoursAngle); //先把之前画时针的角度还原。
//     // canvas.rotate(minutesAngle);
//     // canvas.drawLine(Offset(0, 0), new Offset(0, -_bigRadius + 60), _linePaint);
//     //画秒针
//     _linePaint.strokeWidth = 1;
//     canvas.rotate(-minutesAngle); //同理
//     canvas.rotate(secondsAngle);
//     canvas.drawLine(Offset(0, 0), new Offset(0, -_bigRadius + 30), _linePaint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     // TODO: implement shouldRepaint
//     return true;
//   }

//   //角度转弧度
//   num deg2Rad(num deg) => deg * (math.pi / 180.0);
// }
