import '../../../headers.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static FirestoreHelper firestoreHelper = FirestoreHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addProduct({required ProductModel product}) {
    firestore.collection("products").add(product.toMap());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    var data = firestore.collection('products').get();
    return data;
  }

  void updateProduct({required ProductModel product}) {
    firestore.collection("products").doc(product.id).update(product.toMap());
  }

  void deleteProduct({required String id}) {
    firestore.collection("products").doc(id).delete();
  }
}
