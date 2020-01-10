/*
 * @Description: 时间
 * @Author: MrLiuYS
 * @Date: 2020-01-11 00:18:18
 * @LastEditors  : MrLiuYS
 * @LastEditTime : 2020-01-11 00:20:52
 */
import 'package:flutter/foundation.dart';

class AnalogProvider with ChangeNotifier {
  DateTime _dateTime;

  DateTime get dateTime => _dateTime ?? DateTime.now();

  set dateTime(DateTime value) {
    _dateTime = value;
    notifyListeners();
  }
}
