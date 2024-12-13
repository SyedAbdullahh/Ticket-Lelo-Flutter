import 'package:ticketlelo/screens/event_card.dart';
import 'package:ticketlelo/screens/ticket_card.dart';
import 'package:ticketlelo/services/auth/auth_service.dart';
import 'package:ticketlelo/services/cloud/cloud_ticket.dart';
import 'package:ticketlelo/services/cloud/firebase_cloud_storage.dart';
import 'package:ticketlelo/utils/app_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ViewHistoryTickets extends StatefulWidget {
  const ViewHistoryTickets({super.key});

  @override
  State<ViewHistoryTickets> createState() => _ViewHistoryTicketsState();
}

class _ViewHistoryTicketsState extends State<ViewHistoryTickets> {

  late FirebaseCloudStorage _cloudStorage;
  late AuthService _authService;


  List<Widget> cloudTicketsToCards(Iterable<CloudTicket> tickets) {
    return tickets.map((ticket) => Container(margin: EdgeInsets.only(bottom: 10,top: 10),
        child: TicketCard(ticket: ticket,full_width: true,))).toList();
  }

  @override void initState() {
    _cloudStorage = FirebaseCloudStorage();
    _authService = AuthService.Firebase();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tickets History'),
      ),
        body: SingleChildScrollView(
              dragStartBehavior: DragStartBehavior.start,

              scrollDirection: Axis.vertical,
              padding: EdgeInsets.only(left: 20),

              child:StreamBuilder(stream:_cloudStorage.allTicketsHistory(_authService.CurrentUser!.id!) , builder: (context,AsyncSnapshot<Iterable<CloudTicket>> snapshot)
              {
                switch(snapshot.connectionState)
                {
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                  case ConnectionState.done:
                  case ConnectionState.values:
                    {
                      if(snapshot.hasData)
                      {
                        final data=snapshot.data;
                        final list=cloudTicketsToCards(data!);
                        return Container(
                          child: Column(children: list),
                        );
                      }
                      return Text("No Tickets Available");


                    }
                  case ConnectionState.none:
                    {
                      return Text('No Tickets Available');
                    }
                  default:
                    {
                      return Center(child:CircularProgressIndicator());
                    }
                }


              } ),
            ),




    );
  }
}



