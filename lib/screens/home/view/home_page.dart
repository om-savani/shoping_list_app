import '../../../headers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController updateNameController = TextEditingController();
  TextEditingController updatePriceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Shoping List"),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/cart');
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: controller.getProducts().asStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.docs;
              if (data.isNotEmpty) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return GetBuilder<HomeController>(builder: (context) {
                      return Card(
                        child: ListTile(
                          onLongPress: () {
                            var id = data[index]['id'];
                            updateNameController.text = data[index]['name'];
                            updatePriceController.text = data[index]['price'];
                            Get.defaultDialog(
                              title: "Add Product",
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
                                GetBuilder<HomeController>(builder: (context) {
                                  return ElevatedButton(
                                    onPressed: () async {
                                      String name = nameController.text.trim();
                                      var price = priceController.text.trim();
                                      bool res = controller.updateProduct(
                                          product: ProductModel(
                                              id: id,
                                              name: name,
                                              price: price));
                                      if (res) {
                                        updateNameController.clear();
                                        updatePriceController.clear();
                                        Get.snackbar(
                                            "Success", "Product Updated",
                                            backgroundColor: Colors.green);
                                        Get.close(1);
                                      }
                                    },
                                    child: const Text("Add"),
                                  );
                                }),
                              ],
                            );
                          },
                          title: Text(data[index]['name']),
                          subtitle: Text(data[index]['price']),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              controller.deleteProduct(id: data[index].id);
                            },
                          ),
                        ),
                      );
                    });
                  },
                );
              } else {
                return const Center(child: Text("No Data Found"));
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
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
              GetBuilder<HomeController>(builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    var id = idController.text.trim();
                    String name = nameController.text.trim();
                    var price = priceController.text.trim();
                    bool res = await controller.addProduct(
                        product:
                            ProductModel(id: id, name: name, price: price));
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
                );
              }),
            ],
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
