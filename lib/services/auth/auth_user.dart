import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticketlelo/exceptions/auth_exceptions.dart';
import 'dart:developer' as developer;

@immutable
class AuthUser
{
  //immutable means that internals are not gonna change after initialization
  final String id;
  final bool isEmailVerified;
  final String email;
  final String? displayName;
  final String? photoUrl;

  const AuthUser({ required this.isEmailVerified, required this.email, required this.id, required this.displayName, required this.photoUrl});


  //Factory Constructor- 'fromFirebase' is name of this factory constructor
  factory AuthUser.fromFirebase(User? user) {
    if (user != null) {
      return AuthUser(isEmailVerified: user.emailVerified, email: user.email!, id:user.uid, displayName:user.displayName, photoUrl: user.photoURL);
    } else {
      // Handle case when user is null
      throw ArgumentError('User must not be null');
    }
  }
}

abstract class AuthProvider
{
  AuthUser? get CurrentUser;
  Future<void> initialize();
  Future<AuthUser> logIn(String email,String Password);
  Future<AuthUser> createUser(String email,String Password, String displayName);
  Future<void> logOut();
  Future<void> updateProfilePicture(String url);
  Future<void> sendEmailVerification();
  void print_user();
}

class FirebaseAuthProvider implements AuthProvider
{
  @override
  AuthUser? get CurrentUser
  {
    final user=FirebaseAuth.instance.currentUser;

    if(user!=null)
    {
      developer.log('got user from db');
      return AuthUser.fromFirebase(user);
    }
    else
    {
      return null;
    }
  }

  @override
  Future<AuthUser> createUser (String email, String Password, String displayName)
  async {
    try
    {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: Password);
      final fbUser=FirebaseAuth.instance.currentUser;
      if(fbUser!=null)
       {
         fbUser.updateDisplayName(displayName);
       }
      else
       {
         developer.log('Could not set Display Name');
       }

      developer.log('all set before current user');

      final user=CurrentUser;
      if(user!=null)
      {
        developer.log('user is not null');
        return user;
      }
      else
      {
      throw UserNotLoggedInException();
      }

    } on FirebaseAuthException
    catch(e)
    {

      if(e.code=='user-not-found'|| e.code=='invalid-credential')
      {
        throw UserNotFoundAuthException();
      }
      else if(e.code=='invalid-email')
      {
        throw InvalidEmailAuthException();
      }
      else if(e.code=='network-request-failed')
      {
        throw NetworkRequestFailedAuthException();
      }
      else if(e.code=='weak-password')
      {
        throw WeakPasswordAuthException();
      }
      else if(e.code=='email-already-in-use')
      {
        throw EmailAlreadyInUseAuthException();
      }
      else
      {
        developer.log('Caught this Exception Creating User${e.code}');
        throw GenericAuthException();
      }
    }
    catch(e)
    {
      developer.log('Caught this Exception Creating User$e');
    throw GenericAuthException();
    }

  }

  @override
  Future<AuthUser> logIn(String email, String Password)
  async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: Password);
      final user=CurrentUser;
      if(user!=null)
      {
        return user;
      }
      else
      {
        throw UserNotLoggedInException();
      }

    } on FirebaseAuthException
    catch(e)
    {
      if(e.code=='user-not-found'|| e.code=='invalid-credential')
      {
        throw UserNotFoundAuthException();
      }
      else if(e.code=='invalid-email')
      {
        throw InvalidEmailAuthException();
      }
      else if(e.code=='network-request-failed')
      {
        throw NetworkRequestFailedAuthException();
      }
      else
      {
        throw GenericAuthException();
      }

    }
    catch(_)
    {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user=FirebaseAuth.instance.currentUser;
    if(user!=null)
     {
       await FirebaseAuth.instance.signOut();
     }
    else
     {
       throw UserNotLoggedInException();
     }
  }

  @override
  Future<void> sendEmailVerification()
  async
  {
    final user = FirebaseAuth.instance.currentUser;
    print(user);
    if(user!=null)
    {
      await user.sendEmailVerification();
    }
    else
      {
        throw UserNotLoggedInException();
      }

  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp();

  }

  @override
  void print_user() {
    final user=FirebaseAuth.instance.currentUser;
    print(user);
  }

  @override
  Future<void> updateProfilePicture(String url) async {

    final user=FirebaseAuth.instance.currentUser;
    if(user!=null)
     {
       await user!.updatePhotoURL(url);
     }


  }

}




