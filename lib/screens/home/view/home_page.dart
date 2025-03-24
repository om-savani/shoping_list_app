import '../../../headers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController updateNameController = TextEditingController();
  final TextEditingController updatePriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Shopping List"),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/cart'),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: controller.getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No Data Found"));
            }

            var data = snapshot.data!.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var productData = data[index].data();
                String productId = data[index].id;

                return Card(
                  child: ListTile(
                    title: Text(productData['name']),
                    subtitle: Text(productData['price']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            controller.addToCart(ProductModel(
                              id: productId,
                              name: productData['name'],
                              price: productData['price'],
                            ));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            controller.deleteProduct(id: productId);
                          },
                        ),
                      ],
                    ),
                    onLongPress: () {
                      updateNameController.text = productData['name'];
                      updatePriceController.text = productData['price'];

                      Get.defaultDialog(
                        title: "Update Product",
                        content: Column(
                          children: [
                            TextFormField(
                              controller: updateNameController,
                              decoration: const InputDecoration(
                                hintText: "Product Name",
                                border: OutlineInputBorder(),
                                labelText: "Product Name",
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: updatePriceController,
                              decoration: const InputDecoration(
                                hintText: "Product Price",
                                border: OutlineInputBorder(),
                                labelText: "Product Price",
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              String name = updateNameController.text.trim();
                              String price = updatePriceController.text.trim();

                              bool updated = controller.updateProduct(
                                product: ProductModel(
                                  id: productId,
                                  name: name,
                                  price: price,
                                ),
                              );

                              if (updated) {
                                Get.snackbar("Success", "Product Updated",
                                    backgroundColor: Colors.green);
                                Get.close(1);
                              }
                            },
                            child: const Text("Update"),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.defaultDialog(
            title: "Add Product",
            content: Column(
              children: [
                TextFormField(
                  controller: idController,
                  decoration: const InputDecoration(
                    hintText: "Product Id",
                    border: OutlineInputBorder(),
                    labelText: "Product Id",
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Product Name",
                    border: OutlineInputBorder(),
                    labelText: "Product Name",
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    hintText: "Product Price",
                    border: OutlineInputBorder(),
                    labelText: "Product Price",
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  var id = idController.text.trim();
                  String name = nameController.text.trim();
                  String price = priceController.text.trim();

                  bool res = await controller.addProduct(
                    product: ProductModel(id: id, name: name, price: price),
                  );

                  if (res) {
                    idController.clear();
                    nameController.clear();
                    priceController.clear();
                    Get.snackbar("Success", "Product Added",
                        backgroundColor: Colors.green);
                    Get.close(1);
                  }
                },
                child: const Text("Add"),
              ),
            ],
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
