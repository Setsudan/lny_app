import 'package:flutter/material.dart';
// Fonts
import 'package:google_fonts/google_fonts.dart';
// Icons
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
// Firebase
import 'package:firebase_storage/firebase_storage.dart';
// Image Picker
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// This page is similar to the add_content.dart page
// however, it is used to edit the images in the firebase storage
// we can add, delete, edit and download the images

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int numberOfImages = 0;
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    _getImages();
  }

  bool loading = false;
  bool isSent = false;
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();
  _getImages() async {
    // all images are in the images folder
    final folder = storageRef.child('images');
    // get the list of images
    final list = await folder.listAll();
    // get the url of each image
    for (var i = 0; i < list.items.length; i++) {
      final url = await list.items[i].getDownloadURL();
      setState(() {
        images.add(url);
      });
      print(url);
    }
    setState(() {
      numberOfImages = list.items.length;
    });
  }

  _deleteImage(int index) async {
    // images are stored in the firebase storage in the folder 'images'
    final ref = FirebaseStorage.instance.ref().child('images');
    // delete the image
    await ref.child('image$index').delete();
    // refresh the page
    setState(() {
      images.removeAt(index);
    });
  }

  _replaceImage(int index) async {
    // get the image from the gallery
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // images are stored in the firebase storage in the folder 'images'
    final ref = FirebaseStorage.instance.ref().child('images');
    // delete the image
    await ref.child('image$index').delete();
    // upload the new image
    await ref.child('image$index').putFile(File(image!.path));
    // refresh the page
    setState(() {
      images.removeAt(index);
    });
  }

  _addImage() async {
    // get the image from the gallery
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // images are stored in the firebase storage in the folder 'images'
    final ref = FirebaseStorage.instance.ref().child('images');
    // upload the new image
    await ref.child('image$numberOfImages').putFile(File(image!.path));
    // refresh the page
    setState(() {
      images.add(image.path);
    });
  }

  // We will display the number of images on top of the screen
  // then display each image in a list
  // we will change the size to fit a square
  // a button on bottom right corner of the image to choose to delete or replace the image
  // and a button on bottom right of the screen to add a new image

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addImage();
          },
          backgroundColor: const Color.fromARGB(255, 238, 238, 155),
          child: const Iconify(
            MaterialSymbols.add,
            color: Color.fromARGB(255, 17, 17, 17),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 17, 17, 17),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Number of images: $numberOfImages',
                style: GoogleFonts.montserrat(
                    fontSize: 20, fontWeight: FontWeight.w800, color: const Color.fromARGB(255, 255, 239, 239)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        // round corner image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            images[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _deleteImage(index);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.white,
                                  ),
                                ),
                                icon: const Iconify(
                                  MaterialSymbols.delete_outline,
                                  color: Color.fromARGB(255, 17, 17, 17),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _replaceImage(index);
                                },
                                // change bg so the icon is visible
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.white,
                                  ),
                                ),
                                icon: const Iconify(
                                  MaterialSymbols.edit,
                                  color: Color.fromARGB(255, 17, 17, 17),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Floating action button to add a new image
          ],
        ),
      ),
    );
  }
}
