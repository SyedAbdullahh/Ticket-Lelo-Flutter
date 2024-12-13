import 'package:provider/provider.dart';
import 'package:ticketlelo/constants/routeConstants.dart';
import 'package:ticketlelo/provider/profile_provider.dart';
import 'package:ticketlelo/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class profile_screen extends StatefulWidget {

  const profile_screen({Key? key}) : super(key: key);

  @override
  State<profile_screen> createState() => _profile_screenState();
}

class _profile_screenState extends State<profile_screen> {

  late AuthService _authService;

  @override
  void initState() {
    _authService=AuthService.Firebase();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final user=_authService.CurrentUser;
    String userName='User';
    String n='s';

    if(user!.displayName!=null)
    {
      userName=user.displayName!.toString();

    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(

            width: double.infinity,
            child: Card(

              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Consumer<ProfileProvider>(builder:(context,value,child){
                      return Stack(
                        children:[


                          CircleAvatar(
                            radius: 35,
                            foregroundImage: value.imageFlag? value.dpFlag() ?
                            NetworkImage(_authService.CurrentUser!.photoUrl!)
                                : AssetImage('lib/assets/default_pfp.jpg') as ImageProvider:
                            FileImage(value.image!.absolute)  as ImageProvider,
                          ),
                          Positioned(child: IconButton(onPressed: ()async{
                            await value.getImageFromGallery();


                          }, icon: Icon(Icons.add_a_photo)),
                          top: 30,left: 30,)

                        ]
                      );
                    }
                    ),



                    Text('$userName', style: TextStyle(fontSize: 18.0),),

                    const SizedBox(height: 10.0),

                    Text('Email Address: '+user!.email,style: TextStyle()),


                    const SizedBox(height: 10.0),

                    InkWell(
                      onTap: (){
                        AuthService.Firebase().logOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(loginRoute,(route)=>false);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text('Log Out', style: TextStyle(fontSize: 16.0, color: Colors.white,),),
                      ),
                    ),

                    const SizedBox(height: 10.0),



                  ],
                ),
              ),
            ),
          ),


          //Circle Avatar

        ],
      ),
    );
  }
}