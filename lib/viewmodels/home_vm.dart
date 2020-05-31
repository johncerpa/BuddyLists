import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import 'package:movilfinalapp/shared/constants.dart';
import '../locator.dart';

class HomeViewModel extends BaseModel {
  final AuthService authService = locator<AuthService>();
  final AuthProvider authProvider = locator<AuthProvider>();

  final selectedProducts = List<SelectedProduct>();

  addProductToCart(SelectedProduct selectedProduct) {
    selectedProducts.add(selectedProduct);
    notifyListeners();
  }

  Future logout() async {
    setState(ViewState.Busy);
    await authService.signOut();
    authProvider.logout();
    setState(ViewState.Idle);
  }
}
