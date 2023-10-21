// ignore_for_file: must_be_immutable

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_database/models/products.dart';
import 'package:flutter_firebase_database/providers/provider.dart';
import 'package:flutter_firebase_database/screens/product_screen.dart';
import 'package:flutter_firebase_database/services/cloud_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});
  final textController = TextEditingController();
  CloudService cloudService = CloudService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    final imgPath = ref.watch(imagePathProvider.notifier);
    final imgName = ref.watch(imageNameProvider.notifier);

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
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductScreen(
                          product: data[index],
                        ),
                      ),
                    );
                  },
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
              return Builder(builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) => Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (imgName.state.isNotEmpty) Text(imgName.state),
                        OutlinedButton(
                            onPressed: () async {
                              final result =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: ['jpg', 'png', 'jpeg'],
                              );

                              if (result != null) {
                                imgPath.update(
                                    (state) => result.files.single.path!);
                                imgName.update(
                                    (state) => result.files.single.name);
                                setState(() {});
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No image selected'),
                                  ),
                                );
                              }
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
                          onPressed: () {
                            if (textController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter product name'),
                                ),
                              );
                              Navigator.pop(context);
                            } else {
                              addProduct(ref,
                                  imgPath: imgPath.state,
                                  imgName: imgName.state);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Add Product'),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void addProduct(WidgetRef ref, {String imgPath = '', String imgName = ''}) {
    ref.read(productServiceProvider.notifier).addProduct(
          Products(
            name: textController.text,
            imgPath: imgName,
          ),
        );
    cloudService.uploadFile(imgName, imgPath);

    textController.clear();
  }
}
