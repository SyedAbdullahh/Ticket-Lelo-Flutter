import 'package:provider/provider.dart';
import 'package:ticketlelo/provider/home_screen_provider.dart';
import 'package:ticketlelo/screens/event_card.dart';
import 'package:ticketlelo/screens/view_all_events.dart';
import 'package:ticketlelo/services/cloud/cloud_event.dart';
import 'package:ticketlelo/services/cloud/firebase_cloud_storage.dart';
import 'package:ticketlelo/utils/app_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseCloudStorage _cloudStorage;
  late TextEditingController _searchController;

  @override void initState() {
    _cloudStorage=FirebaseCloudStorage();
    _searchController=TextEditingController();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    String s="User";
    return Scaffold(
      appBar: AppBar(
        title: Text('TicketLelo'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
              //padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Consumer<HomeScreenProvider>(builder:(context,value,child){
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFF4F6FD)
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                              child:TextFormField(
                                controller: _searchController,

                                decoration: const InputDecoration(
                                  border: null,
                                  filled: true,
                                  fillColor: Colors.white,
                                  focusColor: Colors.indigoAccent,
                                  hintText: 'Search',
                                  prefixIcon: Icon(Icons.search),
                                ),
                                onChanged: value.Search,
                              )),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Upcoming Events ", style: Styles.headlineStyle2,),
                        InkWell(
                            onTap: (){
                              // Within the `FirstRoute` widget
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const view_all_events()),
                              );
                            },

                            child: Text("View all", style: Styles.textStyle.copyWith(color: Styles.primaryColor),)

                        )
                      ],
                    ),
                    StreamBuilder(stream:_cloudStorage.allEventsUniversalUpcoming() , builder: (context,AsyncSnapshot<Iterable<CloudEvent>> snapshot)
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
                              if(value.searchFlag(_searchController.text))
                               {
                                 final list=value.cloudEventsToWidgetsFiltered(data!);
                                 return Container(
                                   child: Column(children: list),
                                 );
                               }
                              else
                               {

                                 final list=value.cloudEventsToWidgets(data!);
                                 return Container(
                                   child: Column(children: list),
                                 );
                               }

                            }
                            return Text("No events Available");


                          }
                        case ConnectionState.none:
                          {
                            return Text('No event Available');
                          }
                        default:
                          {
                            return Center(child:CircularProgressIndicator());
                          }
                      }

                    }),
                  ],

                );
              }

              ),
            ),
      ),
          //const Gap(15),

    );
  }
}
