import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ticketlelo/services/auth/auth_service.dart';
import 'package:ticketlelo/services/cloud/cloud_event.dart';
import 'package:ticketlelo/services/cloud/firebase_cloud_storage.dart';
import 'package:ticketlelo/services/payment/payment_service.dart';
class EventDetails extends StatefulWidget {
  EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {

  late DateFormat formatter;
  late PaymentService _paymentService;
  late FirebaseCloudStorage _cloudStorage;
  late AuthService _authService;
  @override
  void initState() {
    formatter=DateFormat('dd MMM, yyyy HH:mm a');
    _cloudStorage=FirebaseCloudStorage();
    _authService=AuthService.Firebase();
    _paymentService=PaymentService();
    super.initState();
  }
  
  bool isOrganizer( String organizerId)
  {
    if(organizerId==_authService.CurrentUser!.id)
     {
       return true;
     } 
    else
     {
       return false;
     } 
  }

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as CloudEvent ;
    double maxInternalWidth = MediaQuery.sizeOf(context).width-20;
    String location="${event.eventLocation}, ${event.eventCity}";


    return Scaffold(
      appBar: AppBar(
        title: Text(event.eventName),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:  EdgeInsets.only(left: 10,right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(event.eventPosterURL),

              Container(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text("By: "+event.organizerUserName,style: TextStyle(color:Colors.indigoAccent, fontWeight: FontWeight.w400),)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text("Category: "+event.eventCategory,style: TextStyle(color:Colors.indigoAccent, fontWeight: FontWeight.w400),)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        Expanded(child: Text(location)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.date_range_outlined),
                        Text("Starts On: "+formatter.format(event.start_dt)),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(Icons.date_range),
                        Text("Ends On: "+formatter.format(event.start_dt)),
                      ],
                    ),
                    Text("Description:", style: TextStyle(color: Colors.indigoAccent,fontWeight: FontWeight.bold),),

                    Row(
                      children: [
                        Expanded(child: Text(event.eventDescription,)),
                      ],
                    ),





                  ],
                ),
              ),

              (event.isFree())?
              const Text("Free Registration",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),):
              Text("Ticket Price: "+event.eventPrice.toString()+"PKR", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),),

              (isOrganizer(event.organizerId))?
              Column(
                children: [
                  Text("Current Participants:${event.curr_participants}/${event.max_participants}", style: TextStyle(color:Colors.indigoAccent, fontWeight: FontWeight.bold),),
                ],
              ) :Container(
                margin: const EdgeInsets.all(16),
                width:double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent, // background color
                      foregroundColor: Colors.white,//text color

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                  ),
                  onPressed: ()async {
                    if(event.isFree())
                    {
                      //free
                      final ticket=await _cloudStorage.createTicket(event.eventId, _authService.CurrentUser!.id, _authService.CurrentUser!.displayName!, event.curr_participants+1, event.eventName, event.eventPosterURL, event.start_dt, event.end_dt, event.eventLocation, event.eventCity, event.eventPrice);
                      if(ticket!=null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ticket Generated'),
                          duration: Durations.extralong4,

                        ));
                        //
                        //Fluttertoast.showToast(msg: 'Ticket Generated', gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_LONG);

                      }

                    }
                    else {
                      //paid
                      bool result = await _paymentService.pay(event.eventPrice, event.eventName+" ticket purchase");
                      if (result) {
                        final ticket = await _cloudStorage.createTicket(
                            event.eventId,
                            _authService.CurrentUser!.id,
                            _authService.CurrentUser!.displayName!,
                            event.curr_participants + 1,
                            event.eventName,
                            event.eventPosterURL,
                            event.start_dt,
                            event.end_dt,
                            event.eventLocation,
                            event.eventCity,
                            event.eventPrice);
                        if (ticket != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ticket Generated'),
                                duration: Durations.extralong4,

                              ));
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ticket Could not be Generated'), duration: Durations.extralong4));
                        }
                      }
                    }

                  },
                  child: (event.isFree())?const Text('Register Free Ticket'): const Text('Buy Ticket'),
                ),
              ),


            ],
          ),
        ),
      ),

    );
  }
}
