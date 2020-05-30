import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/models/user.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import '../locator.dart';

class SignUpViewModel extends BaseModel {
  final AuthService authService = locator<AuthService>();
  final AuthProvider authProvider = locator<AuthProvider>();

  User get user => authService.user;

  Future signUp(String email, String password) async {
    setState(ViewState.Busy);

    try {
      await authService.signUp(email, password);

      bool rememberMe = false;
      authProvider.setSignedIn(rememberMe);
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
