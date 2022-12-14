import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
// connectivity_plus
import 'package:connectivity_plus/connectivity_plus.dart';

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

  // check if the device is connected to the internet
  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  bool loading = false;
  bool isSent = false;
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();
  _uploadImage(String path) async {
    // images are stored in the firebase storage in the folder 'images'
    final ref = FirebaseStorage.instance.ref().child('images');
    // upload the new image
    await ref.child('image$numberOfImages').putFile(File(path));
    // refresh the page
    setState(() {
      images.add(path);
    });
  }

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
    // check if the user is connected to wifi
    checkInternet().then((value) {
      if (value) {
        // if the user is connected to wifi, upload the image
        _uploadImage(image!.path);
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'No internet connection',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              content: Text(
                'Please connect to wifi to upload the image',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            );
          },
        );
      }
    });
  }

  _handleCamera() async {
    // get the image from the camera
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    // check if the user is connected to wifi
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      // if the user is connected to wifi, upload the image
      _uploadImage(image!.path);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'No internet connection',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            content: Text(
              'Please connect to wifi to upload the image',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
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
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Iconify(
            MaterialSymbols.add,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: const Color(0xff111111),
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
                  return GestureDetector(
                    onLongPress: () {
                      // open the image in a full screen // Open image on full screen
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
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // ask for confirmation
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Are you sure you want to delete this image?',
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
                                                  // delete the image from the firebase storage
                                                  storage.refFromURL(images[index]).delete();
                                                  // refresh the page
                                                  setState(() {
                                                    images.removeAt(index);
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Yes',
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
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'No',
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
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  icon: Iconify(
                                    MaterialSymbols.delete_outline,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    storage.refFromURL(images[index]).getDownloadURL().then((value) {
                                      // put the url in the clipboard
                                      Clipboard.setData(ClipboardData(text: value));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Copied to clipboard'),
                                        ),
                                      );
                                    });
                                  },
                                  // change bg so the icon is visible
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  icon: Iconify(
                                    MaterialSymbols.download,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
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
