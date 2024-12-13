import 'package:provider/provider.dart';
import 'package:ticketlelo/constants/routeConstants.dart';
import 'package:ticketlelo/provider/my_events_provider.dart';
import 'package:ticketlelo/services/auth/auth_service.dart';
import 'package:ticketlelo/services/cloud/cloud_event.dart';
import 'package:ticketlelo/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';
import 'package:ticketlelo/utils/my_events_list_view.dart';
class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {

  late FirebaseCloudStorage _cloudStorage;
  late AuthService _authService;


  @override
  void initState() {
    _authService=AuthService.Firebase();
    _cloudStorage=FirebaseCloudStorage();

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          title: Text('My Events'),
          actions: [
            IconButton(onPressed: (){
              Navigator.of(context).pushNamed(createEventScreenRoute);

            }, icon: const Icon(Icons.add))
          ],
        ),



      body: Consumer<MyEventsProvider>(builder:(context,value,child){
        return Column(
          children: [
            ButtonBar(alignment: MainAxisAlignment.start,
              children: [
                TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.white70),

                    ),
                    onPressed: (){
                      value.setFlag(true);
                    },
                    child:Text('Approved', style: TextStyle(color: value.approvedColor()),)),

                TextButton(
                    onPressed: (){
                      value.setFlag(false);
                    },
                    child:Text('Un-Approved', style: TextStyle(color: value.UnApprovedColor()))),
              ],
            ),
            if(value.approved)
            Flexible(
              child: StreamBuilder(stream: _cloudStorage.allEventsApproved(organizerId:_authService.CurrentUser!.id ) , builder: (context,AsyncSnapshot<Iterable<CloudEvent>> snapshot)
              {
                switch(snapshot.connectionState)
                {
                  case ConnectionState.none:
                    {
                      return const Center(child: Text('No Events Available'));
                    }
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                  case ConnectionState.values:
                  case ConnectionState.done:
                    {
                      if(snapshot.hasData) {
                        final data=snapshot.data;
                        return MyEventsListView(events: data!, onDeleteEvent: (CloudEvent event){
                          _cloudStorage.deleteEvent(eventId: event.eventId, organizer: _authService.CurrentUser!.id);
                        }, onTapEvent:(CloudEvent event){
                          Navigator.of(context).pushNamed(eventDetailsScreenRoute,arguments:event);

                        });
                      }

                      return Text('No Events');




                    }
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              }),
            ),
        if(value.approved==false)
        Flexible(
        child: StreamBuilder(stream: _cloudStorage.allEventsUnApproved(organizerId:_authService.CurrentUser!.id ) , builder: (context,AsyncSnapshot<Iterable<CloudEvent>> snapshot)
        {
        switch(snapshot.connectionState)
        {
        case ConnectionState.none:
        {
        return const Center(child: Text('No Events Available'));
        }
        case ConnectionState.waiting:
        case ConnectionState.active:
        case ConnectionState.values:
        case ConnectionState.done:
        {
        if(snapshot.hasData) {
        final data=snapshot.data;
        return MyEventsListView(events: data!, onDeleteEvent: (CloudEvent event){
        _cloudStorage.deleteEvent(eventId: event.eventId, organizer: _authService.CurrentUser!.id);
        }, onTapEvent:(CloudEvent event){
        Navigator.of(context).pushNamed(eventDetailsScreenRoute,arguments:event);
        });
        }
        return Text('No Events');
        }
        default:
        return const Center(child: CircularProgressIndicator());
        }
        }),
        ),

          ],
        );
      }

      ),
    );
  }
}
