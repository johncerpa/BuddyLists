import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import 'package:movilfinalapp/services/lists_service.dart';
import '../locator.dart';

class HistoryViewModel extends BaseModel {
  final authService = locator<AuthService>();
  final authProvider = locator<AuthProvider>();
  final listsService = locator<ListsService>();

  get historyLists => listsService.historyLists;

  Future getHistoryLists() async {
    setState(ViewState.Busy);
    try {
      await listsService.getHistoryLists();
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
