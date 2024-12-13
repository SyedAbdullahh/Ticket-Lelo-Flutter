import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketlelo/services/cloud/cloud_ticket.dart';
import 'package:ticketlelo/utils/app_styles.dart';
class TicketDetails extends StatefulWidget {
  const TicketDetails({super.key});

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  late DateFormat formatter;

  @override
  void initState() {
    formatter=DateFormat('dd MMM, yyyy HH:mm a');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ticket = ModalRoute.of(context)!.settings.arguments as CloudTicket ;

    String location=ticket.eventVenue+", "+ticket.eventCity;
    String StartDT=formatter.format(ticket.ticketStartDT);
    String EndDT=formatter.format(ticket.ticketEndDT);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Ticket'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10,right: 10),
          child: Column(
            children: [
              //---------------------card-------------------------------
              Container(
              
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (ticket.ticketStartDT.isBefore(DateTime.now()))?
                                  Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text('Old Event',style: TextStyle(fontWeight: FontWeight.bold),),):
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text('Upcoming Event',style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),


                                  Text("Ticket ID:"+ticket.ticketID),
                                  Text("Event:"+ticket.eventName),
                                  Row(
                                    children: [
                                      Text("Ticket Number:"),
                                      Card(
                                        color: Colors.indigoAccent,
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(" "+ticket.ticketNumber.toString()+" ",style: TextStyle(color: Colors.white),),
                                        ),
                                      )
                                    ],
                                  ),
        
                                  Divider(),
                                  Text("Ticket Holder Details:"),
                                  Text("Name:"+ticket.userName),
                                  Text("User ID:"+ticket.userID),
                                  Divider(),
                                  Text('Venue & Timings'),
                                  
                                  Text("Venue: "+location),
                                  Text("Starting: "+StartDT),
                                  Text("Ending: "+EndDT),
                                  Divider(),
                                  Text("Payment Details:"),
                                  (ticket.isFree())?
                                  Card(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Free Registeration',style: TextStyle(color: Colors.white),),
                                  ),color: Colors.green,):
                                  Card(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Paid '+ticket.price.toString()+" PKR",style: TextStyle(color: Colors.white),),
                                  ),color: Colors.indigoAccent,),
                                                      
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

        
        
        
        
                  ],
                ),
              )
        
        
            ],
          ),
        ),
      ),

    );
  }
}
