import 'package:ticketlelo/services/auth/auth_user.dart';
class AuthService implements AuthProvider
{
  final AuthProvider provider;
  const AuthService(this.provider);
  factory AuthService.Firebase()=>AuthService(FirebaseAuthProvider());

  @override
  AuthUser? get CurrentUser=> provider.CurrentUser;
  @override
  Future<AuthUser> createUser(String email, String Password,String displayName)=>provider.createUser(email, Password,displayName);


  @override
  Future<AuthUser> logIn(String email, String Password) => provider.logIn(email, Password);


  @override
  Future<void> logOut()=>provider.logOut();



  @override
  Future<void> sendEmailVerification()=>provider.sendEmailVerification();

  @override
  Future<void> initialize()=>provider.initialize();

  @override
  void print_user()=>provider.print_user();

  @override
  Future<void> updateProfilePicture(String url) async{await provider.updateProfilePicture(url);}

}