import 'package:firebase_core/firebase_core.dart';
import 'package:ticketlelo/constants/routeConstants.dart';
import 'package:ticketlelo/provider/create_event_provider.dart';
import 'package:ticketlelo/provider/event_card_provider.dart';
import 'package:ticketlelo/provider/home_screen_provider.dart';
import 'package:ticketlelo/provider/loginProvider.dart';
import 'package:ticketlelo/provider/my_events_provider.dart';
import 'package:ticketlelo/provider/my_tickets_provider.dart';
import 'package:ticketlelo/provider/navProvider.dart';
import 'package:ticketlelo/provider/profile_provider.dart';
import 'package:ticketlelo/screens/bottom_bar.dart';
import 'package:ticketlelo/screens/create_event.dart';
import 'package:ticketlelo/screens/event_details.dart';
import 'package:ticketlelo/screens/login.dart';
import 'package:ticketlelo/screens/signup.dart';
import 'package:ticketlelo/screens/ticket_details.dart';
import 'package:ticketlelo/screens/verify_view.dart';
import 'package:ticketlelo/screens/view_history_tickets.dart';
import 'package:ticketlelo/screens/view_upcoming_tickets.dart';
import 'package:ticketlelo/services/auth/auth_service.dart';
import 'package:ticketlelo/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>LoginProvider()),
        ChangeNotifierProvider(create: (_)=>NavProvider()),
        ChangeNotifierProvider(create: (_)=>CreateEventProvider()),
        ChangeNotifierProvider(create: (_)=>FreePaidProvider()),
        ChangeNotifierProvider(create: (_)=>EventCardProvider()),
        ChangeNotifierProvider(create: (_)=>ProfileProvider()),
        ChangeNotifierProvider(create: (_)=>HomeScreenProvider()),
        ChangeNotifierProvider(create: (_)=>MyEventsProvider()),
        ChangeNotifierProvider(create: (_)=>MyTicketsProvider()),
      ],

    child: Builder(builder:(BuildContext context)
        {
        return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ticket Lelo',
        theme: ThemeData(

        primaryColor: primary,
        useMaterial3: true,
        ),
        routes: {
        loginRoute:(context)=>const LoginPage(),
        signUpRoute:(context)=>const SignupPage(),
        verifyRoute:(context)=>const VerifyEmailView(),
        bottomBarRoute:(context)=>BottomBar(),
        createEventScreenRoute:(context)=> const CreateEventScreen(),
        eventDetailsScreenRoute:(context)=>EventDetails(),
        ticketDetailsScreenRoute:(context)=>TicketDetails(),
         ticketsHistoryScreenRoute:(context)=>ViewHistoryTickets(),
         upcomingTicketsScreenRoute:(context)=>ViewUpcomingTickets(),

        },
        home: const HomePage(),
        );
        }
    )
    );
  }

}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.Firebase().initialize(),
        builder: (context,snapshot)
        {
          switch(snapshot.connectionState)
          {
            case ConnectionState.done:
              {
                final user=AuthService.Firebase().CurrentUser;

                if(user!=null)
                {
                  if(user.isEmailVerified)
                  {
                    // Main Screen
                    return const BottomBar();
                  }
                  else
                  {
                    return const VerifyEmailView();
                  }

                }
                else
                {
                  return const LoginPage();
                }

              }
            case ConnectionState.none:
              {
                return const Center(child: CircularProgressIndicator());
              }
            default:
              {
                return const Center(child: CircularProgressIndicator());

              }

          }

        }

    );
  }
}
