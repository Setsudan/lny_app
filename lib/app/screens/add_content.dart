import 'package:flutter/material.dart';
// pos
import 'package:geolocator/geolocator.dart';
import 'package:connectivity/connectivity.dart';
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

class AddContentScreen extends StatefulWidget {
  const AddContentScreen({Key? key}) : super(key: key);

  @override
  _AddContentScreenState createState() => _AddContentScreenState();
}

class _AddContentScreenState extends State<AddContentScreen> {
  double latitude = 0.0;
  double longitude = 0.0;
  String networkStatus = 'Offline';
  String networkType = 'None';
  bool isInFrance = false;
  int numberOfImages = 0;
  @override
  void initState() {
    _refreshData();
    super.initState();
  }

  // get the current number of images in the firebase storage
  Future<void> _getNumberOfImages() async {
    // images are stored in the firebase storage in the folder 'images'
    final ref = FirebaseStorage.instance.ref().child('images');
    // get the number of images in the folder
    final numberOfImages = await ref.listAll();
    setState(() {
      this.numberOfImages = numberOfImages.items.length;
    });
  }

  // get the location of the user
  _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  // get the network status of the user
  _getNetworkStatus() async {
    // get the network status
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      setState(() {
        networkStatus = 'Online';
        networkType = 'Mobile';
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      setState(() {
        networkStatus = 'Online';
        networkType = 'Wifi';
      });
    } else {
      // I am not connected to any network.
      setState(() {
        networkStatus = 'Offline';
        networkType = 'None';
      });
    }
  }

  // check if the user is in France
  _userIsInFrance() async {
    // get the location of the user
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // check if the user is in France
    if (position.latitude >= 41.0 &&
        position.latitude <= 51.0 &&
        position.longitude >= -5.0 &&
        position.longitude <= 10.0) {
      setState(() {
        isInFrance = true;
      });
    } else {
      setState(() {
        isInFrance = false;
      });
    }
  }

  // is allowed to send content
  _userCanSendContent() {
    // to be allowed to send content you have to either be in France or using wifi
    if (isInFrance || networkType == 'Wifi') {
      return true;
    } else {
      return false;
    }
  }

  // Firebase storage section
  bool loading = false;
  bool isSent = false;
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();
  final picker = ImagePicker();
  XFile? image;
  String? imageUrl;

  // get the image from the user
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickedFile;
    });
  }

  // upload the image to Firebase storage
  Future uploadImage() async {
    setState(() {
      loading = true;
    });
    // get the image
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickedFile;
    });
    // upload the image
    if (image != null) {
      var file = File(image!.path);
      var snapshot = await storageRef.child('images/${DateTime.now()}').putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        loading = false;
        isSent = true;
      });
    }
  }

  _refreshData() {
    setState(() {
      _getLocation();
      _getNetworkStatus();
      _userIsInFrance();
      _getNumberOfImages();
      loading = false;
      isSent = false;
    });
  }

  // if user isn't allowed to send content
  // we will store keep in a list the images that the user wants to send
  // and when the user is allowed to send content we will send all the images
  // that are in the list
  List<XFile> imagesToSend = [];
  // add the image to the list
  Future addImageToList() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagesToSend.add(pickedFile!);
    });
  }

  // send all the images in the list
  Future sendAllImages() async {
    setState(() {
      loading = true;
    });
    // upload the images
    for (var i = 0; i < imagesToSend.length; i++) {
      var file = File(imagesToSend[i].path);
      var snapshot = await storageRef.child('images/${DateTime.now()}').putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        loading = false;
        isSent = true;
      });
    }
  }

  // function for the onPressed of the send button
  // if the user is allowed to send content we will send the image
  // if the user isn't allowed to send content we will add the image to the list
  Future sendImage() async {
    if (_userCanSendContent()) {
      // check if the list of images to send is empty
      if (imagesToSend.isEmpty) {
        // if the list is empty we will send the image
        await uploadImage();
      } else {
        // if the list isn't empty we will send all the images in the list
        await sendAllImages();
        // then we will empty the list
        setState(() {
          imagesToSend = [];
        });
        // then we will allow the user to send a new image
        await uploadImage();
      }
    } else {
      addImageToList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 17, 17, 17),
        body: GestureDetector(
          onDoubleTap: () {
            // refresh the page
            _refreshData();
          },
          child: Center(
            child: Stack(
              children: [
                // A centered title and subtitle
                Positioned(
                  top: 100,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // first text is "Il y a x photos souvenirs" with the number being yellow
                          Text(
                            'Il y a $numberOfImages photos souvenirs',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Pour rappel vous les verrez sur le site, pour actualiser la page double tappez sur le texte',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(50, 50),
                              backgroundColor: const Color.fromARGB(255, 238, 238, 155),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onLongPress: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('This button is to add content'),
                                ),
                              );
                            },
                            onPressed: () {
                              sendImage();
                              _getNumberOfImages();
                            },
                            child: const Iconify(MaterialSymbols.add)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
