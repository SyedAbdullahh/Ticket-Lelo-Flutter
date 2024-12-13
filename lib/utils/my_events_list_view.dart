import 'package:flutter/material.dart';
import 'package:ticketlelo/services/cloud/cloud_event.dart';
import 'dart:developer' as developer;
import 'package:ticketlelo/utils/two_options_dialog.dart';

//defining a structure/func header for our callback functions

typedef EventCallback= void Function(CloudEvent);

class MyEventsListView extends StatelessWidget {
  final Iterable<CloudEvent> events;
  final EventCallback onDeleteEvent;
  final EventCallback onTapEvent;
  const MyEventsListView({super.key, required this.events, required this.onDeleteEvent, required this.onTapEvent});

  @override
  Widget build(BuildContext context) {
    try{
      return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context,index){
            final currEvent= events.elementAt(index);
            return ListTile(
              onTap: (){
                onTapEvent(currEvent);
              },

              title: Text(
                currEvent.eventName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async{
                  //action here
                  final flag=await TwoOptionsDialog(
                      context,
                      'Delete event',
                      'Are you sure you want to delete this event?',
                      'Delete',
                      'Cancel');
                  if(flag)
                  {
                    //delete krde bhai
                    onDeleteEvent(currEvent);
                  }
                },
              ),

            );

          }
      );
    }
    catch(e)
    {
      developer.log(e.toString());
      return const Text('');
    }

  }
}
