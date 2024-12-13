import 'package:intl/intl.dart';
import 'package:ticketlelo/constants/routeConstants.dart';
import 'package:ticketlelo/services/cloud/cloud_event.dart';
import 'package:ticketlelo/services/cloud/cloud_ticket.dart';
import 'package:ticketlelo/utils/app_layout.dart';
import 'package:ticketlelo/utils/app_styles.dart';
import 'package:flutter/material.dart';
String buyerName = "John Doe"; // Example: Replace with actual data retrieved from DB
class TicketCard extends StatelessWidget {

  CloudTicket ticket;
  bool full_width;
  TicketCard({
    Key? key,
    required this.ticket,
    required this.full_width,
  }) : super(key: key);




  @override
  Widget build(BuildContext context) {
    DateFormat formatterDate=DateFormat('dd-MMM');
    DateFormat formatterTime=DateFormat('HH:mm a');
    String StartDate=formatterDate.format(ticket.ticketStartDT).toString();
    String startTime=formatterTime.format(ticket.ticketStartDT).toString();


    final size=AppLayout.getSize(context);
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed(ticketDetailsScreenRoute,arguments: ticket);
      },
      child: SizedBox(

        width:(full_width)? double.infinity:size.width*0.85,

        child: Container(
          margin: EdgeInsets.only(bottom: 8.0),
          decoration: const BoxDecoration(color: Color(0xFF526799),
          borderRadius: BorderRadius.all(Radius.circular(21.0)),

          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,

            children: [
              // this following container is blue part of ticket
              Container(
                decoration: const BoxDecoration(
                  color: Colors.indigoAccent,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(21.0), topRight: Radius.circular(21.0))
                ),

                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ticket.eventName,
                        maxLines: 1,
                        style: Styles.headlineStyle3.copyWith(color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                Row(
                      children: [
                        Expanded(child: Text(ticket.userName, style: Styles.headlineStyle4.copyWith(color: Colors.white))),
                      ],
                    )
                  ],
                ),
              ),
              //following container is '----' part
              Container(
                color: Styles.orangeColor,
                child:
                Row(
                  children: [
                    const SizedBox(
                      height: 20,
                      width: 10,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))

                        ),
                      )

                    ),
                    Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints){
                          return Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max ,
                            children: List.generate((constraints.constrainWidth()/15).floor(), (index) => const SizedBox(
                              width: 5,
                              height: 1,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                              )
                            ))
                            ,
                          );
                        },
                      )
                    )
                    ),
                    const SizedBox(
                        height: 20,
                        width: 10,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color:Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                          ),
                        )

                    ),



                  ],
                ),


              ),
              Container(
                decoration: BoxDecoration(
                  color: Styles.orangeColor,

                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(21.0), bottomRight: Radius.circular(21.0)),

                ),
                  padding: const EdgeInsets.only(left: 16.0, top:10.0, right: 16.0, bottom: 16.0),

                  child:Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(StartDate, style: Styles.headlineStyle3.copyWith(color: Colors.white)),
                              //const Gap(5),
                              Text("Date", style: Styles.headlineStyle4.copyWith(color: Colors.white)),



                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(startTime, style: Styles.headlineStyle3.copyWith(color: Colors.white)),
                              Text("Starting Time", style: Styles.headlineStyle4.copyWith(color: Colors.white)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ticket.ticketNumber.toString(), style: Styles.headlineStyle3.copyWith(color: Colors.white)),
                              //const Gap(5),
                              Text("Number", style: Styles.headlineStyle4.copyWith(color: Colors.white)),



                            ],
                          ),
                        ],
                      )
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
