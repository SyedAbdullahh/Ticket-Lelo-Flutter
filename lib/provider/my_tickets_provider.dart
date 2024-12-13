import 'package:flutter/material.dart';

class MyTicketsProvider with ChangeNotifier
{
  bool _upcoming=true;
  bool get upcoming=>_upcoming;

  Color upcomingColor()
  {
    if(_upcoming==true)
    {
      return Colors.indigoAccent;
    }
    else
    {
      return Colors.grey;
    }
  }


  Color historyColor()
  {
    if(_upcoming==true)
    {
      return Colors.grey;

    }
    else
    {
      return Colors.indigoAccent;
    }
  }

  void setFlag(bool flag)
  {
    _upcoming=flag;
    notifyListeners();
  }

}