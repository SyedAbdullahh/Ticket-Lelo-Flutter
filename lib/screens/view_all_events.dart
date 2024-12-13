import 'package:ticketlelo/screens/event_card.dart';
import 'package:ticketlelo/utils/app_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class view_all_events extends StatelessWidget {
  const view_all_events({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Styles.bgcolor,
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  //Gap(40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              IconButton(
                                  onPressed: (){

                                    Navigator.pop(context);



                              },
                                  icon: const Icon(Icons.arrow_back)
                              ),
                              Text(
                                  "Upcoming Events",style: Styles.headlineStyle1
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage(
                                  "../../assets/images/img_1.png",
                                ),
                                fit: BoxFit.fitHeight
                            )
                        ),
                      ),
                    ],
                  ),
                  //Gap(25),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFF4F6FD)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                    child: const Row(
                      children: [


                        Expanded(
                          // flex:13,
                            child: SearchBar())


                      ],
                    ),
                  ),
                  //const Gap(40),

                ],

              ),
            ),
            //const Gap(15),
            const SingleChildScrollView(
              dragStartBehavior: DragStartBehavior.start,

              //scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 20),

              child:Column(
                children: [
                  //EventView(),
                  //const Gap(10),
                  //EventView(),


                ],
              ),
            )


          ],
        )

    );
  }
}
