import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import 'package:movilfinalapp/services/lists_service.dart';
import '../locator.dart';

class FriendsViewModel extends BaseModel {
  final AuthService authService = locator<AuthService>();
  final AuthProvider authProvider = locator<AuthProvider>();
  final ListsService listsService = locator<ListsService>();

  dynamic get lists => listsService.lists;

  Future getLists() async {
    setState(ViewState.Busy);
    try {
      await listsService.getLists();
      notifyListeners();
    } catch (error) {
      throw error;
    }
    setState(ViewState.Idle);
  }

  Future logout() async {
    setState(ViewState.Busy);
    await authService.signOut();
    authProvider.logout();
    setState(ViewState.Idle);
  }
}
