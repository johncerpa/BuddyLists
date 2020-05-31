import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/models/user.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import '../locator.dart';

class HomeViewModel extends BaseModel {
  final AuthService authService = locator<AuthService>();
  final AuthProvider authProvider = locator<AuthProvider>();

  Future logout() async {
    setState(ViewState.Busy);
    await authService.signOut();
    authProvider.logout();
    setState(ViewState.Idle);
  }
}
