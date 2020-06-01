import 'package:get_it/get_it.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import 'package:movilfinalapp/services/lists_service.dart';
import 'package:movilfinalapp/viewmodels/friends_vm.dart';
import 'package:movilfinalapp/viewmodels/home_vm.dart';
import 'package:movilfinalapp/viewmodels/signin_vm.dart';
import 'package:movilfinalapp/viewmodels/signup_vm.dart';

GetIt locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => AuthProvider());
  locator.registerLazySingleton(() => ListsService());
  locator.registerFactory(() => SignInViewModel());
  locator.registerFactory(() => SignUpViewModel());
  locator.registerFactory(() => HomeViewModel());
  locator.registerFactory(() => FriendsViewModel());
}
