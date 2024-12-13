import 'package:ticketlelo/constants/routeConstants.dart';
import 'package:flutter/material.dart';
import 'package:ticketlelo/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
        actions: [
          PopupMenuButton(itemBuilder:(context)
          {
            return[ const PopupMenuItem<String>(
                value: "Login",
                child: Text("Login"),
            )];
          },
      onSelected: (value){
            if(value=="Login")
              {
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route)=>false);
              }
            AuthService.Firebase().logOut();

      },
    )
        ],
      ),
        body: Column(
          children: [
            const Text(" We have sent a Verification Email, Please Verify your Email Address and Login", textAlign: TextAlign.center),

            const Text("If you still have not recieved the Email, please  press the Button Below",textAlign: TextAlign.center,),
            TextButton(onPressed: () async
            {
              final user=AuthService.Firebase().CurrentUser;

              if(user!=null)
                {

                   AuthService.Firebase().sendEmailVerification();
                }
            }, child:
            const Text("Send Email Verification Link")),

            TextButton(onPressed: () async
            {
              AuthService.Firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(loginRoute,(route)=>false);
            }, child:
            const Text("Verified? Click Here to Re Login")),

          ],
        ),
    );


  }
}
