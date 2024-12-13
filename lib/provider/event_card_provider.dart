import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:ticketlelo/services/cloud/cloud_event.dart';

class EventCardProvider with ChangeNotifier
{
  late CloudEvent _event;
  DateFormat formatter=DateFormat('dd MMM, yyyy HH:mm a');
  void setEvent(CloudEvent event)
  {
    _event=event;
  }
  bool isFree()
  {
    return _event.isFree();
  }

  String eventPrice()
  {
    return _event.eventPrice.toString();
  }

  String eventName() {
    return _event.eventName;
  }

  String eventCity()
  {
    return _event.eventCity;
  }

  String eventLocation()
  {
    return _event.eventLocation;
  }

  String eventCategory()
  {
    return _event.eventCategory;
  }

  String eventDescription()
  {
    return _event.eventDescription;
  }
  String eventPosterURL()
  {
    return _event.eventPosterURL;
  }

  String eventOrganizer()
  {
    return _event.organizerUserName;
  }

  String StartDate()
  {
    return formatter.format(_event.start_dt);
  }

  String EndDate()
  {
    return formatter.format(_event.end_dt);
  }


}