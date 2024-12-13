import 'package:ticketlelo/constants/routeConstants.dart';
import 'package:ticketlelo/exceptions/auth_exceptions.dart';
import 'package:ticketlelo/screens/login.dart';
import 'package:ticketlelo/services/auth/auth_service.dart';
import 'package:ticketlelo/utils/show_error_dialog.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final TextEditingController _userNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _password1Controller;
  late final TextEditingController _password2Controller;
  @override
  void initState() {
    // TODO: implement initState
    _userNameController=TextEditingController();
    _emailController=TextEditingController();
    _password1Controller=TextEditingController();
    _password2Controller=TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userNameController.dispose();
    _emailController.dispose();
    _password1Controller.dispose();
    _password2Controller.dispose();
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
                Column(
                  children: <Widget>[
                    const SizedBox(height: 60.0),
                    const Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create your account",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _userNameController,
                      decoration: InputDecoration(
                          hintText: "Username",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color(0xFF526799).withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.person)),
                    ),

                    const SizedBox(height: 20),

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

                    TextFormField(
                      controller: _password1Controller,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: const Color(0xFF526799).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                      ),
                      obscureText: true,
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _password2Controller,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: const Color(0xFF526799).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
                Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),

                    child: ElevatedButton(
                      onPressed: () async {
                        if(_password1Controller.text.toString()!=_password2Controller.text.toString())
                         {
                           await showErrorDialog(context,"Passwords Don't Match");
                         }
                        else
                          {
                            try{
                              await AuthService.Firebase().createUser(_emailController.text,_password1Controller.text, _userNameController.text);
                              final user=AuthService.Firebase().CurrentUser;
                              if(user!=null)
                               {
                                 await AuthService.Firebase().sendEmailVerification();
                               }
                              Navigator.pushNamed(context,verifyRoute);

                            }
                            on WeakPasswordAuthException
                            {
                              await showErrorDialog(context, "Weak Password");
                            }
                            on EmailAlreadyInUseAuthException
                            {
                              await showErrorDialog(context, "Email is Already in Use");
                            }
                            on InvalidEmailAuthException
                            {
                              await showErrorDialog(context,"Invalid Email");
                            }
                            on NetworkRequestFailedAuthException
                            {
                              await showErrorDialog(context,"Network Problem Detected");
                            }
                            on GenericAuthException
                            {
                              await showErrorDialog(context, "Unknown Error");
                            }



                          }

                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.indigoAccent,
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )
                ),

               /* const Center(child: Text("Or")),

                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Color(0xFF526799),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const SizedBox(width: 18),

                        const Text("Sign In with Google",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF526799),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    TextButton(
                        onPressed: () {
                          // Within the `FirstRoute` widget
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },

                        child: const Text("Login", style: TextStyle(color:Color(0xFF526799)),)
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