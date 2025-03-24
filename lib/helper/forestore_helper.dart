import '../../../headers.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static final FirestoreHelper instance = FirestoreHelper._();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addProduct({required ProductModel product}) {
    firestore
        .collection("products")
        .doc(product.id)
        .set(product.toMap(), SetOptions(merge: true));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    return firestore.collection('products').snapshots();
  }

  void updateProduct({required ProductModel product}) {
    firestore.collection("products").doc(product.id).update(product.toMap());
  }

  void deleteProduct({required String id}) {
    firestore.collection("products").doc(id).delete();
  }
}
