import 'package:provider/provider.dart';
import 'package:ticketlelo/constants/routeConstants.dart';
import 'package:ticketlelo/provider/event_card_provider.dart';
import 'package:ticketlelo/services/cloud/cloud_event.dart';
import 'package:ticketlelo/services/payment/payment_service.dart';
import 'package:ticketlelo/utils/app_layout.dart';
import 'package:ticketlelo/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

class EventCard extends StatefulWidget {
  CloudEvent event;

  EventCard({super.key,required this.event });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late DateFormat formatter;
  late PaymentService _paymentService;
  Styles _styles=Styles();
  static const platform = MethodChannel('com.payment_app/performPayment');

  @override void initState() {
    _paymentService=PaymentService();
    formatter=DateFormat('dd MMM, yyyy HH:mm a');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed(eventDetailsScreenRoute,arguments: widget.event);


      },
      child: SizedBox(


        child: Container(
          decoration: BoxDecoration(
              boxShadow:[
                BoxShadow(
                  color: Color.fromRGBO(149, 157, 165, 0.2),
                  blurRadius: 24,
                  spreadRadius: 0,
                  offset: Offset(
                    0,
                    8,
                  ),
                ),]),
          margin: EdgeInsets.only(top:10, bottom: 10),
          child: Consumer<EventCardProvider>(builder:(context,value,child){
            value.setEvent(widget.event);
            return Column(

              children: [


                // this following container is blue part of ticket
                Container(

                  decoration: const BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(21.0), topRight: Radius.circular(21.0))
                  ),


                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(value.eventPosterURL()),
                      Row(
                        children: [
                          Expanded(child: Text(value.eventName(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19), textAlign: TextAlign.left,)),
                        ],
                      ),
                      Text(value.eventCity(), style: Styles.headlineStyle3.copyWith(color: Colors.black)),
                      Row(
                        children: [
                          Icon(Icons.location_on),
                          Expanded(child: Text(value.eventLocation(),textAlign: TextAlign.start, style: Styles.headlineStyle4.copyWith(color: Colors.black))),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text("Starting: "+value.StartDate(), style: TextStyle(color: Colors.black))),
                        ],
                      ),
                      Row(
                        children: [
                          value.isFree()?
                          Expanded(child: Text("Free Entry", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))):
                          Expanded(child: Text("Ticket Price: "+value.eventPrice()+" PKR", style: TextStyle(color: Colors.black,))),
                        ],
                      ),
                    ],
                  ),
                ),
                //following container is '----' part

                Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent,


                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(21.0), bottomRight: Radius.circular(21.0)),

                    ),
                    child:(value.isFree())?
                    Center(child: Text('Get Free Ticket', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)):Center(child: Text('Buy Ticket', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))
                ),


              ],
            );
          }),
          ),
        ),

      );
  }
}
