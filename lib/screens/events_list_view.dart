import 'package:ticketlelo/services/cloud/cloud_event.dart';
import 'package:flutter/material.dart';
class EventsListView extends StatefulWidget {
  final Iterable<CloudEvent> events;
  EventsListView({super.key,  required this.events});

  @override
  State<EventsListView> createState() => _EventsListViewState();
}

class _EventsListViewState extends State<EventsListView> {
  @override
  Widget build(BuildContext context) {
    return Text("");

  }
}
