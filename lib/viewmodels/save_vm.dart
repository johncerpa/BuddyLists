import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/locator.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import 'package:movilfinalapp/services/lists_service.dart';

class SaveViewModel extends BaseModel {
  final listsService = locator<ListsService>();
  final authService = locator<AuthService>();
  final authProvider = locator<AuthProvider>();

  finishLists() async {
    setState(ViewState.Busy);
    try {
      await listsService.finishLists();
    } catch (error) {}
    setState(ViewState.Idle);
  }

  Future logout() async {
    setState(ViewState.Busy);
    await authService.signOut();
    authProvider.logout();
    setState(ViewState.Idle);
  }
}
