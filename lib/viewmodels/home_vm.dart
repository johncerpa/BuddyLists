import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import 'package:movilfinalapp/services/lists_service.dart';
import 'package:movilfinalapp/shared/constants.dart';
import '../locator.dart';

class HomeViewModel extends BaseModel {
  final authService = locator<AuthService>();
  final authProvider = locator<AuthProvider>();
  final listsService = locator<ListsService>();

  List<SelectedProduct> get selectedProducts => listsService.userList;

  addProductToCart(SelectedProduct selectedProduct) {
    if (selectedProduct != null) {
      listsService.userList.add(selectedProduct);
    }
    notifyListeners();
  }

  removeProduct(int position) {
    listsService.userList.removeAt(position);
    notifyListeners();
  }

  postList() async {
    try {
      await listsService.postList();
    } catch (error) {
      throw error;
    }
  }

  Future logout() async {
    setState(ViewState.Busy);
    await authService.signOut();
    authProvider.logout();
    setState(ViewState.Idle);
  }
}
