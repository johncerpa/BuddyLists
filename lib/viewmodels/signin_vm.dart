import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/models/user.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import '../locator.dart';

class SignInViewModel extends BaseModel {
  final AuthService authService = locator<AuthService>();
  final AuthProvider authProvider = locator<AuthProvider>();

  User get user => authService.user;

  Future signIn(String email, String password, bool remember) async {
    setState(ViewState.Busy);

    try {
      await authService.signIn(email, password);
      authProvider.setSignedIn(remember);
    } catch (error) {
      throw error;
    }

    notifyListeners();
    setState(ViewState.Idle);
  }

  setToIdle() {
    notifyListeners();
    setState(ViewState.Idle);
  }
}
