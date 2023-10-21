import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_database/models/products.dart';
import 'package:flutter_firebase_database/providers/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
        ),
        body: products.when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(data[index].id!),
                  child: ListTile(
                    title: Text(data[index].name!),
                    trailing: IconButton(
                      icon: Icon(data[index].purchased!
                          ? Icons.check_box
                          : Icons.check_box_outline_blank),
                      onPressed: () {
                        ref.read(productServiceProvider.notifier).updateProduct(
                              data[index].id!,
                              data[index].copyWith(
                                purchased: !data[index].purchased!,
                              ),
                            );
                      },
                    ),
                  ),
                  onDismissed: (direction) {
                    ref.read(productServiceProvider.notifier).deleteProduct(
                          data[index].id!,
                        );
                  },
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            ref
                                .read(productServiceProvider.notifier)
                                .addProduct(
                                  Products(
                                    name: textController.text,
                                  ),
                                );
                            textController.clear();

                            Navigator.pop(context);
                          },
                          child: const Text('Upload Image')),
                      TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();

                          if (result != null) {
                            ref
                                .read(productServiceProvider.notifier)
                                .addProduct(
                                  Products(
                                    name: textController.text,
                                    imgPath: result.files.single.path,
                                  ),
                                );
                            textController.clear();

                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Add Product'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ));
  }

  void addProduct(WidgetRef ref) {
    ref.read(productServiceProvider.notifier).addProduct(
          Products(
            name: textController.text,
          ),
        );
    textController.clear();
  }
}
