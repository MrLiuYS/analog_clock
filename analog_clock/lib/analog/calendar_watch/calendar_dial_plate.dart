/*
 * @Description: 月历指针表
 * @Author: MrLiuYS
 * @Date: 2019-12-28 22:36:12
 * @LastEditors  : MrLiuYS
 * @LastEditTime : 2019-12-28 23:24:12
 */
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class CalendarDialPlate extends StatelessWidget {
  const CalendarDialPlate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(painter: CalendarPlatePainter()),
    );
  }
}


// class CalendarDialPlate extends StatefulWidget {
//   CalendarDialPlate({Key key}) : super(key: key);

//   @override
//   _CalendarDialPlateState createState() => _CalendarDialPlateState();
// }

// class _CalendarDialPlateState extends State<CalendarDialPlate> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: CustomPaint(painter: CalendarPlatePainter()),
//     );
//   }
// }

class CalendarPlatePainter extends CustomPainter {
  //背景圆
  Paint _bgCirclePaint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = Colors.white;

  //大外圆
  Paint _bigCirclePaint = Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..color = Colors.blue
    ..strokeWidth = 2;

  //粗刻度线
  Paint _linePaint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = Colors.black
    ..strokeWidth = 1;

  //圆心
  Offset _centerOffset = Offset(0, 0);

  //圆半径
  double _bigRadius = 30;

  final int lineHeight = 5;

  //文字画笔
  TextPainter _textPainter = new TextPainter(
      textAlign: TextAlign.left, textDirection: TextDirection.ltr);

  @override
  void paint(Canvas canvas, Size size) {
    print('_bigRadius: ${_bigRadius}');

    // canvas.drawCircle(_centerOffset, _bigRadius, _bgCirclePaint);
    //绘制大圆
    canvas.drawCircle(_centerOffset, _bigRadius, _bigCirclePaint);
    // //绘制圆心
    _bigCirclePaint.style = PaintingStyle.fill;
    canvas.drawCircle(_centerOffset, _bigRadius / 20, _bigCirclePaint);
    // //绘制刻度,秒针转一圈需要跳60下,这里只画6点整的刻度线，但是由于每画一条刻度线之后，画布都会旋转60°(转为弧度2*pi/60)，所以画出60条刻度线
    // for (int i = 0; i < 60; i++) {
    //   _linePaint.strokeWidth = i % 5 == 0 ? (i % 3 == 0 ? 1 : 1) : 1; //设置线的粗细
    //   canvas.drawLine(Offset(0, _bigRadius - lineHeight), Offset(0, _bigRadius),
    //       _linePaint);
    //   canvas.rotate(math.pi / 30); //2*math.pi/60
    // }
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
      "15",
      "30",
      "45",
      "60",
    ];

    // for (int i = 0; i < 12; i++) {
    //   canvas.save(); //与restore配合使用保存当前画布
    //   canvas.translate(0.0, -_bigRadius + 10); //平移画布画点于时钟的12点位置，+30为了调整数字与刻度的间隔
    //   _textPainter.text = TextSpan(
    //       style: new TextStyle(color: Colors.black, fontSize: 8),
    //       text: numberText[i]);
    //   // canvas.rotate(-deg2Rad(30) * i); //保持画数字的时候竖直显示。
    //   _textPainter.layout();
    //   _textPainter.paint(
    //       canvas, Offset(-_textPainter.width / 2, -_textPainter.height / 2));
    //   canvas.restore(); //画布重置,恢复到控件中心
    //   canvas.rotate(deg2Rad(30)); //画布旋转一个小时的刻度，把数字和刻度对应起来

    // }
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
    // //画时针
    // _linePaint.strokeWidth = 4;
    // canvas.rotate(hoursAngle);
    // canvas.drawLine(Offset(0, 0), new Offset(0, -_bigRadius + 80), _linePaint);
    // //画分针
    // _linePaint.strokeWidth = 2;
    // canvas.rotate(-hoursAngle); //先把之前画时针的角度还原。
    // canvas.rotate(minutesAngle);
    // canvas.drawLine(Offset(0, 0), new Offset(0, -_bigRadius + 60), _linePaint);
    // //画秒针
    // _linePaint.strokeWidth = 1;
    // canvas.rotate(-minutesAngle); //同理
    // canvas.rotate(secondsAngle);
    // canvas.drawLine(Offset(0, 0), new Offset(0, -_bigRadius + 30), _linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  //角度转弧度
  num deg2Rad(num deg) => deg * (math.pi / 180.0);
}
