import 'package:flutter/material.dart';

class MyEventsProvider with ChangeNotifier
{
  bool _approved=true;
  bool get approved=>_approved;

  Color approvedColor()
  {
    if(_approved==true)
     {
        return Colors.indigoAccent;
     }
    else
     {
       return Colors.grey;
     }
  }


  Color UnApprovedColor()
  {
    if(_approved==true)
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
    _approved=flag;
     notifyListeners();
  }

}