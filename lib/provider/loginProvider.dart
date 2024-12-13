import 'package:flutter/foundation.dart';

class LoginProvider with ChangeNotifier
{
  bool _visibility=false;

  bool get visibility =>_visibility;

  void setVisibility(bool flag)
  {
    _visibility=flag;
    notifyListeners();
  }
}