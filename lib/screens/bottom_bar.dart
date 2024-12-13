import 'package:ticketlelo/constants/routeConstants.dart';
import 'package:ticketlelo/provider/navProvider.dart';
import 'package:ticketlelo/screens/home_screen.dart';
import 'package:ticketlelo/screens/my_events.dart';
import 'package:ticketlelo/screens/profile_screen.dart';
import 'package:ticketlelo/screens/tickets_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  static final List<Widget> _widgetOptions =<Widget>
  [

    const HomeScreen(),
    const MyEvents(),
    const TicketScreen(),
    const profile_screen(),

  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavProvider>(builder:(context,value,child){
      return Scaffold(
        body: _widgetOptions[value.ind],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10,

          onTap: value.onItemTapped,
          backgroundColor: Colors.black,
          showSelectedLabels: false,
          showUnselectedLabels: false,

          // edit selected and unselected colors please!
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "", backgroundColor: Colors.black),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: "",backgroundColor: Colors.black),
            BottomNavigationBarItem(icon: Icon(Icons.panorama_horizontal_select_sharp),  label:"", backgroundColor: Colors.black),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "", backgroundColor: Colors.black),

          ],
        ),

      );

    });




  }
}
