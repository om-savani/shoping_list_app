import '../../../headers.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});
  HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Cart"),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: controller.fetchCartItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProductModel> cartItems = snapshot.data!;
            if (cartItems.isEmpty)
              return Center(child: const Text("Cart is empty"));
            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                var product = cartItems[index];
                return Card(
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text(product.price),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await controller.removeCartItem(product.id);
                        Get.snackbar(
                            "Removed", "${product.name} removed from cart",
                            backgroundColor: Colors.red);
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
