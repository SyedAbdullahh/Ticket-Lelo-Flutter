import 'package:flutter/cupertino.dart';

class NavProvider with ChangeNotifier
{
  int indd=0;
  int get ind=>indd;

  void onItemTapped(int i)
  {
    indd=i;
    notifyListeners();
  }

}