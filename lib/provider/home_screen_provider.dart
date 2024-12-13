import 'package:flutter/material.dart';
import 'package:ticketlelo/screens/event_card.dart';
import 'package:ticketlelo/services/cloud/cloud_event.dart';
import 'dart:developer' as developer;

class HomeScreenProvider with ChangeNotifier
{
  bool _searchFlag=false;
  String _searchToken='';
  bool  searchFlag(String controllerToken)
  {
    if(_searchToken==''||controllerToken=='')
     {
       _searchToken='';
       _searchFlag=false;
     }
    return _searchFlag;
  }

  void Search(String token)
  {
    if(token!='')
      {
        _searchToken=token;
        _searchFlag=true;
        notifyListeners();
      }
    else
     {
       _searchToken=token;
       _searchFlag=false;
       notifyListeners();
     }

  }

  List<Widget> cloudEventsToWidgetsFiltered(Iterable<CloudEvent> events) {
    final filteredEvents = events.where((event) =>
        event.eventName.toLowerCase().contains(_searchToken.toLowerCase())
    );
    return filteredEvents.map((event) => EventCard(event: event)).toList();
  }

  List<Widget> cloudEventsToWidgets(Iterable<CloudEvent> events) {
    return events.map((event) => EventCard(event: event)).toList();
  }




}