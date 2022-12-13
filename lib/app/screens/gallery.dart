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

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
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
    }
    setState(() {
      numberOfImages = list.items.length;
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

  _handleCamera() async {
    // get the image from the camera
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
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
            // open a dialog to choose between opening the gallery or the camera
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'Choose an option',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Open the gallery
                      TextButton(
                        onPressed: () {
                          _addImage();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Gallery',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      // Open the camera
                      TextButton(
                        onPressed: () {
                          _handleCamera();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Camera',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          tooltip: 'Add Image',
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Iconify(
            MaterialSymbols.add,
            color: Theme.of(context).colorScheme.onPrimary,
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
                    fontSize: 20, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      // Open image on full screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
                            floatingActionButton: FloatingActionButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              tooltip: 'Close',
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Iconify(
                                MaterialSymbols.close,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.onPrimary,
                            body: Center(
                              child: Image.network(images[index]),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
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
                        ],
                      ),
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
