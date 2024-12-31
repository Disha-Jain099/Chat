import 'package:flutter/material.dart';
class MyDateUtil{
  static String getFormattedTime({required BuildContext context, required String time}){
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  //get last message time
static String getLastMessageTime({required BuildContext context,required String time}){
    final DateTime send = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if(now.day == send.day && now.month == send.month && now.year == send.year){
      return TimeOfDay.fromDateTime(send).format(context);

    }
    return '${send.day} ${_getMonth(send)}';
}
//get month
static String _getMonth(DateTime date){
    switch(date.month){
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'May';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';


    }
    return 'NA';
}
static String getLastActiveTime({required BuildContext context,required String lastActive}){
    final int i = int.tryParse(lastActive)?? -1;
    //if time is not available
  if(i== -1) return 'Last seen not available';
  DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
  DateTime now = DateTime.now();
  String formattedTime = TimeOfDay.fromDateTime(time).format(context);
  if(time.day == now.day &&
  time.month == now.month &&
  time.year == now.year){
    return 'Last seen today at $formattedTime';

  }
  if((now.difference(time).inHours/24).round()== 1){
    return 'Last seen yesterday at $formattedTime';
  }
  String month = _getMonth(time);
  return 'Last seen on ${time.day} $month on $formattedTime';
}
}