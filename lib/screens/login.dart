import 'package:ticketlelo/constants/routeConstants.dart';
import 'package:ticketlelo/provider/loginProvider.dart';
import 'package:ticketlelo/screens/bottom_bar.dart';
import 'package:ticketlelo/screens/signup.dart';
import 'package:ticketlelo/screens/verify_view.dart';
import 'package:ticketlelo/services/auth/auth_service.dart';
import 'package:ticketlelo/utils/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/auth_exceptions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController=TextEditingController();
    _passwordController=TextEditingController();
    super.initState();
  }

  @override void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Column(
                  children: <Widget>[
                    SizedBox(height: 60.0),
                    Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                  ],
                ),
                Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color(0xFF526799).withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.email)),
                    ),

                    const SizedBox(height: 20),

                    Consumer<LoginProvider>(builder: (context,value,child)
                      {
                        return TextFormField(
                        controller:_passwordController ,
                        enabled: true,
                        decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none),
                      fillColor: const Color(0xFF526799).withOpacity(0.1),
                      filled: true,

                      prefixIcon: const Icon(Icons.password),
                          suffix: InkWell(

                            child:value.visibility?const Icon(Icons.visibility):const Icon(Icons.visibility_off),
                            onTap: (){
                              value.setVisibility(!(value.visibility));
                            },
                          )
                      ),
                      obscureText: (value.visibility)?false:true,
                      );
                      }

                    ),

                  ],
                ),
                Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),

                    child: ElevatedButton(
                      onPressed: () async {
                        try
                        {
                          await AuthService.Firebase().logIn(_emailController.text.toString(),_passwordController.text.toString());
                        }
                        on UserNotFoundAuthException
                        {
                          await showErrorDialog(context,"User not Found");
                        }
                        on
                        InvalidEmailAuthException
                        {
                          await showErrorDialog(context, "Invalid Email");
                        }
                        on NetworkRequestFailedAuthException
                        {
                          await showErrorDialog(context,"Network Problem Detected");
                        }
                        on GenericAuthException
                        {
                          await showErrorDialog(context, "Unknown Error");
                        }
                        catch(e)
                        {
                          await showErrorDialog(context, "Unknown Error");
                        }


                        final user=AuthService.Firebase().CurrentUser;
                        if(user!=null&& user.isEmailVerified)
                         {
                           Navigator.of(context).pushNamedAndRemoveUntil(bottomBarRoute,(route)=>false);

                         }
                        else if(user!=null&& !(user.isEmailVerified))
                         {
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => const VerifyEmailView()),
                           );
                         }

                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.indigoAccent,
                      ),
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignupPage()),
                          );
                        },
                        child: const Text("Signup", style: TextStyle(color: Color(0xFF526799)),)
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}