import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/models/user.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import '../locator.dart';

class SignInViewModel extends BaseModel {
  final authService = locator<AuthService>();
  final authProvider = locator<AuthProvider>();

  User get user => authService.user;

  Future signIn(String email, String password) async {
    setState(ViewState.Busy);

    try {
      await authService.signIn(email, password);
      authProvider.setSignedIn();
    } catch (error) {
      throw error;
    }

    notifyListeners();
    setState(ViewState.Idle);
  }
}
