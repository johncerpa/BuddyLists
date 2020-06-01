import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import 'package:movilfinalapp/services/products_service.dart';
import 'package:movilfinalapp/shared/constants.dart';
import '../locator.dart';

class HomeViewModel extends BaseModel {
  final AuthService authService = locator<AuthService>();
  final AuthProvider authProvider = locator<AuthProvider>();
  final ProductService productService = locator<ProductService>();

  final selectedProducts = List<SelectedProduct>();

  addProductToCart(SelectedProduct selectedProduct) {
    if (selectedProduct != null) {
      selectedProducts.add(selectedProduct);
    }
    notifyListeners();
  }

  postList() async {
    productService.postList(selectedProducts);
  }

  Future logout() async {
    setState(ViewState.Busy);
    await authService.signOut();
    authProvider.logout();
    setState(ViewState.Idle);
  }
}
