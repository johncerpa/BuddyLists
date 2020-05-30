import 'package:get_it/get_it.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import 'package:movilfinalapp/viewmodels/signin_vm.dart';
import 'package:movilfinalapp/viewmodels/signup_vm.dart';

GetIt locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => AuthProvider());
  locator.registerFactory(() => SignInViewModel());
  locator.registerFactory(() => SignUpViewModel());
}
