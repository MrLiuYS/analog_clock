/*
 * @Description: 表盘(pointer dial plate)
 * @Author: MrLiuYS
 * @Date: 2019-12-28 11:16:13
 * @LastEditors  : MrLiuYS
 * @LastEditTime : 2019-12-30 16:11:54
 */

import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'dart:ui';

class PointerDialPlate extends StatefulWidget {
  PointerDialPlate({Key key}) : super(key: key);

  @override
  _PointerDialPlateState createState() => _PointerDialPlateState();
}

class _PointerDialPlateState extends State<PointerDialPlate> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: CustomTimeClock());
    //   return CustomPaint(
    //     painter: CustomTimeClock(),
    //     // painter: ClockPainter(
    //     //     numberColor: Colors.black,
    //     //     handColor: Colors.green,
    //     //     borderColor: Colors.black,
    //     //     radius: 150.0),
    //     size: Size(150.0 * 2, 150.0 * 2),
    //   );
  }
}

class CustomTimeClock extends CustomPainter {
  //大外圆
  Paint _bigCirclePaint = Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..color = Colors.black
    ..strokeWidth = 4;

  //粗刻度线
  Paint _linePaint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = Colors.black
    ..strokeWidth = 1;

  //圆心
  Offset _centerOffset = Offset(0, 0);

  //圆半径
  double _bigRadius = 150;

  final int lineHeight = 7;



  //文字画笔
  TextPainter _textPainter = new TextPainter(
      textAlign: TextAlign.left, textDirection: TextDirection.ltr);

  @override
  void paint(Canvas canvas, Size size) {
    print('_bigRadius: ${_bigRadius}');
    //绘制大圆
    canvas.drawCircle(_centerOffset, _bigRadius, _bigCirclePaint);
    //绘制圆心
    _bigCirclePaint.style = PaintingStyle.fill;
    canvas.drawCircle(_centerOffset, _bigRadius / 20, _bigCirclePaint);
    //绘制刻度,秒针转一圈需要跳60下,这里只画6点整的刻度线，但是由于每画一条刻度线之后，画布都会旋转60°(转为弧度2*pi/60)，所以画出60条刻度线
    for (int i = 0; i < 60; i++) {
      _linePaint.strokeWidth = i % 5 == 0 ? (i % 3 == 0 ? 2 : 2) : 1; //设置线的粗细
      canvas.drawLine(Offset(0, _bigRadius - lineHeight), Offset(0, _bigRadius),
          _linePaint);
      canvas.rotate(math.pi / 30); //2*math.pi/60
    }
    //方法一:绘制数字,此处暂时没想到更好的方法,TextPainter的绘制间距老有问题,不好控制
    /*  _textPaint[0].layout();
    _textPaint[0].paint(canvas, new Offset(-12, -_bigRadius+20));
    _textPaint[1].layout();
    _textPaint[1].paint(canvas, new Offset(_bigRadius-30,-12));
    _textPaint[2].layout();
    _textPaint[2].paint(canvas, new Offset(-6,_bigRadius-40));
    _textPaint[3].layout();
    _textPaint[3].paint(canvas, new Offset(-_bigRadius+20,-12));*/

    //方法二:绘制数字,

        List<String> numberText = [
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
      ];

    for (int i = 0; i < 12; i++) {
      canvas.save(); //与restore配合使用保存当前画布
      canvas.translate(0.0, -_bigRadius + 18); //平移画布画点于时钟的12点位置，+30为了调整数字与刻度的间隔
      _textPainter.text = TextSpan(
          style: new TextStyle(color: Colors.black, fontSize: 16),
          text: numberText[i]);
      // canvas.rotate(-deg2Rad(30) * i); //保持画数字的时候竖直显示。
      _textPainter.layout();
      _textPainter.paint(
          canvas, Offset(-_textPainter.width / 2, -_textPainter.height / 2));
      canvas.restore(); //画布重置,恢复到控件中心
      canvas.rotate(deg2Rad(30)); //画布旋转一个小时的刻度，把数字和刻度对应起来
    }
    //绘制指针,这个也好理解
    int hours = DateTime.now().hour;
    int minutes = DateTime.now().minute;
    int seconds = DateTime.now().second;
    print("时: ${hours} 分：${minutes} 秒: ${seconds}");
    //时针角度//以下都是以12点为0°参照
    //12小时转360°所以一小时30°
    double hoursAngle =
        (minutes / 60 + hours - 12) * math.pi / 6; //把分钟转小时之后*（2*pi/360*30）
    //分针走过的角度,同理,一分钟6°
    double minutesAngle =
        (minutes + seconds / 60) * math.pi / 30; //(2*pi/360*6)
    //秒针走过的角度,同理,一秒钟6°
    double secondsAngle = seconds * math.pi / 30;
    //画时针
    _linePaint.strokeWidth = 4;
    canvas.rotate(hoursAngle);
    canvas.drawLine(Offset(0, 0), new Offset(0, -_bigRadius + 80), _linePaint);
    //画分针
    _linePaint.strokeWidth = 2;
    canvas.rotate(-hoursAngle); //先把之前画时针的角度还原。
    canvas.rotate(minutesAngle);
    canvas.drawLine(Offset(0, 0), new Offset(0, -_bigRadius + 60), _linePaint);
    //画秒针
    _linePaint.strokeWidth = 1;
    canvas.rotate(-minutesAngle); //同理
    canvas.rotate(secondsAngle);
    canvas.drawLine(Offset(0, 0), new Offset(0, -_bigRadius + 30), _linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }


  //角度转弧度
  num deg2Rad(num deg) => deg * (math.pi / 180.0);
}

// class ClockPainter extends CustomPainter {
//   final Color handColor;
//   final Color numberColor;
//   final Color borderColor;
//   final double radius;
//   List<Offset> secondsOffset = [];
//   List<Offset> secondsInnerOffset = [];
//   // final DateTime datetime;
//   TextPainter textPainter;
//   double angle;
//   double borderWidth;

//   ClockPainter(
//       {this.radius = 150.0,
//       this.handColor = Colors.black,
//       this.numberColor = Colors.black,
//       this.borderColor = Colors.black}) {
//     borderWidth = radius / 15;
//     final secondDistance = radius - borderWidth * 2;
//     //init seconds offset

//     int innerOffsetdis = 25;
//     for (var i = 0; i < 60; i++) {
//       Offset offset = Offset(
//           cos(degToRad(6 * i - 90)) * secondDistance + radius,
//           sin(degToRad(6 * i - 90)) * secondDistance + radius);
//       secondsOffset.add(offset);

//       if(i % 5 == 0){
//         innerOffsetdis = 27;
//       }else {
//         innerOffsetdis = 25;
//       }

      // Offset innerOffset = Offset(
      //     radius + cos(degToRad(360 / 60 * i - 90)) * (radius - innerOffsetdis),
      //     radius + sin(degToRad(360 / 60 * i - 90)) * (radius - innerOffsetdis));

//       secondsInnerOffset.add(innerOffset);
//     }

//     textPainter = new TextPainter(
//       textAlign: TextAlign.center,
//       textDirection: TextDirection.rtl,
//     );
//     angle = degToRad(360 / 60);
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     final scale = radius / 150;

//     //draw border
//     final borderPaint = Paint()
//       ..color = borderColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = borderWidth;
//     canvas.drawCircle(
//         Offset(radius, radius), radius - borderWidth / 2, borderPaint);

//     //draw second point
//     final secondPPaint = Paint()
//       ..strokeWidth = 2 * scale
//       ..color = numberColor;

//     final secondWidePPaint = Paint()
//       ..strokeWidth = 4 * scale
//       ..color = numberColor;

//     if (secondsOffset.length > 0) {
//       for (var i = 0; i < secondsOffset.length; i++) {
//         Offset offset = secondsOffset[i];
//         Offset innerOffset = secondsInnerOffset[i];

//         // if (i % 5 == 0) {
//         //   canvas.drawLine(offset, innerOffset, secondWidePPaint);
//         // }else {
//           canvas.drawLine(offset, innerOffset, secondPPaint);
//         // }

//       }

//       // canvas.drawPoints(PointMode.points, secondsOffset, secondPPaint);

//       canvas.save();
//       canvas.translate(radius, radius);

//       List<Offset> bigger = [];

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

//       // List<String> numberText = ["1","2","3","4","5","6","7","8","9","10","11","12"];

//       for (var i = 0; i < secondsOffset.length; i++) {
//         String numberStr = numberText[((i ~/ 5) == 0 ? 12 : (i ~/ 5)) - 1];
//         if (i % 5 == 0) {
//           bigger.add(secondsOffset[i]);

//           //draw number
//           canvas.save();
//           canvas.translate(0.0, -radius + borderWidth * 4);
//           textPainter.text = new TextSpan(
//             text: "$numberStr",
//             style: TextStyle(
//               color: numberColor,
//               // fontFamily: 'Times New Roman',
//               fontSize: 17.0 * scale,
//             ),
//           );

//           //helps make the text painted vertically

//           // canvas.rotate(-angle * i);

//           textPainter.layout();
//           textPainter.paint(canvas,
//               new Offset(-(textPainter.width / 2), -(textPainter.height / 2)));
//           canvas.restore();
//         }
//         canvas.rotate(angle);
//       }
//       canvas.restore();

//       final biggerPaint = Paint()
//         ..strokeWidth = 5 * scale
//         ..color = numberColor;

//       // canvas.drawPoints(PointMode.points, bigger, biggerPaint);
//     }

//     // final hour = datetime.hour;
//     // final minute = datetime.minute;
//     // final second = datetime.second;

//     // draw hour hand
//     // Offset hourHand1 = Offset(
//     //     radius - cos(degToRad(360 / 12 * hour - 90)) * (radius * 0.2),
//     //     radius - sin(degToRad(360 / 12 * hour - 90)) * (radius * 0.2));
//     // Offset hourHand2 = Offset(
//     //     radius + cos(degToRad(360 / 12 * hour - 90)) * (radius * 0.5),
//     //     radius + sin(degToRad(360 / 12 * hour - 90)) * (radius * 0.5));
//     // final hourPaint = Paint()
//     //   ..color = handColor
//     //   ..strokeWidth = 8 * scale;
//     // canvas.drawLine(hourHand1, hourHand2, hourPaint);

//     // draw minute hand
//     // Offset minuteHand1 = Offset(
//     //     radius - cos(degToRad(360 / 60 * minute - 90)) * (radius * 0.3),
//     //     radius - sin(degToRad(360 / 60 * minute - 90)) * (radius * 0.3));
//     // Offset minuteHand2 = Offset(
//     //     radius +
//     //         cos(degToRad(360 / 60 * minute - 90)) * (radius - borderWidth * 3),
//     //     radius +
//     //         sin(degToRad(360 / 60 * minute - 90)) * (radius - borderWidth * 3));
//     // final minutePaint = Paint()
//     //   ..color = handColor
//     //   ..strokeWidth = 3 * scale;
//     // canvas.drawLine(minuteHand1, minuteHand2, minutePaint);

//     // draw second hand
//     // Offset secondHand1 = Offset(
//     //     radius - cos(degToRad(360 / 60 * second - 90)) * (radius * 0.3),
//     //     radius - sin(degToRad(360 / 60 * second - 90)) * (radius * 0.3));
//     // Offset secondHand2 = Offset(
//     //     radius +
//     //         cos(degToRad(360 / 60 * second - 90)) * (radius - borderWidth * 3),
//     //     radius +
//     //         sin(degToRad(360 / 60 * second - 90)) * (radius - borderWidth * 3));
//     // final secondPaint = Paint()
//     //   ..color = handColor
//     //   ..strokeWidth = 1 * scale;
//     // canvas.drawLine(secondHand1, secondHand2, secondPaint);

//     final centerPaint = Paint()
//       ..strokeWidth = 2 * scale
//       ..style = PaintingStyle.stroke
//       ..color = Colors.yellow;
//     canvas.drawCircle(Offset(radius, radius), 4 * scale, centerPaint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }

// num degToRad(num deg) => deg * (pi / 180.0);

// num radToDeg(num rad) => rad * (180.0 / pi);
