import '../../../headers.dart';

class HomeController extends GetxController {
  Future<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    var data = FirestoreHelper.firestoreHelper.getProducts();
    update();
    return data;
  }

  Future<bool> addProduct({required ProductModel product}) async {
    if (product.id.isNotEmpty &&
        product.name.isNotEmpty &&
        product.price.isNotEmpty) {
      FirestoreHelper.firestoreHelper.addProduct(product: product);
      update();
      return true;
    } else {
      Get.snackbar("Error", "Please fill all the fields",
          backgroundColor: Colors.red);
      return false;
    }
  }

  bool updateProduct({required ProductModel product}) {
    if (product.id.isNotEmpty &&
        product.name.isNotEmpty &&
        product.price.isNotEmpty) {
      FirestoreHelper.firestoreHelper.updateProduct(product: product);
      update();
      return true;
    } else {
      Get.snackbar("Error", "Please fill all the fields",
          backgroundColor: Colors.red);
      return false;
    }
  }

  void deleteProduct({required String id}) {
    FirestoreHelper.firestoreHelper.deleteProduct(id: id);
    update();
  }
}
