import 'package:provider/provider.dart';
import 'package:ticketlelo/exceptions/cloud_storage_exceptions.dart';
import 'package:ticketlelo/provider/my_tickets_provider.dart';
import 'package:ticketlelo/screens/ticket_card.dart';
import 'package:ticketlelo/screens/view_history_tickets.dart';
import 'package:ticketlelo/services/auth/auth_service.dart';
import 'package:ticketlelo/services/cloud/cloud_event.dart';
import 'package:ticketlelo/services/cloud/cloud_ticket.dart';
import 'package:ticketlelo/services/cloud/firebase_cloud_storage.dart';
import 'package:ticketlelo/utils/app_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'view_upcoming_tickets.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late FirebaseCloudStorage _cloudStorage;
  late AuthService _authService;


  List<Widget> cloudTicketsToCards(Iterable<CloudTicket> tickets) {
    return tickets.map((ticket) => TicketCard(ticket: ticket,full_width: true,)).toList();
  }

  @override void initState() {
    _cloudStorage=FirebaseCloudStorage();
    _authService=AuthService.Firebase();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(

        title:Text(
          "Your Tickets",style: TextStyle(fontSize: 25),
        ),
      ),

        body: Consumer<MyTicketsProvider>(builder:(context,value,child){
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
        child:Text('Upcoming', style: TextStyle(color: value.upcomingColor()),)),

        TextButton(
        onPressed: (){
        value.setFlag(false);
        },
        child:Text('Past Tickets', style: TextStyle(color: value.historyColor()))),
        ],
        ),
        if(value.upcoming)
        Flexible(
        child: StreamBuilder(stream: _cloudStorage.allTicketsUpcoming(_authService.CurrentUser!.id) , builder: (context,AsyncSnapshot<Iterable<CloudTicket>> snapshot)
        {
        switch(snapshot.connectionState)
        {
        case ConnectionState.none:
        {
        return const Center(child: Text('No Tickets Available'));
        }
        case ConnectionState.waiting:
        case ConnectionState.active:
        case ConnectionState.values:
        case ConnectionState.done:
        {
        if(snapshot.hasData) {
        final data=snapshot.data;
        final list=cloudTicketsToCards(data!);
        return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: list),
        ),
        );
        }
        return Text('No Tickets Available');
        }
        default:
        return const Center(child: CircularProgressIndicator());
        }
        }),
        ),
        if(value.upcoming==false)
        Flexible(
        child: StreamBuilder(stream: _cloudStorage.allTicketsHistory(_authService.CurrentUser!.id) , builder: (context,AsyncSnapshot<Iterable<CloudTicket>> snapshot)
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
        final list=cloudTicketsToCards(data!);
        return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: list),
        ),
        );
        }
        return const Text('No Tickets Available');
        }
        default:
        return const Center(child: CircularProgressIndicator());
        }
        }),
        ),

        ],
        );
        }









                  )

    );
  }
}
