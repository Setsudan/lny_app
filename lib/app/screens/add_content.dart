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

class AddContent extends StatefulWidget {
  const AddContent({Key? key}) : super(key: key);

  @override
  _AddContentState createState() => _AddContentState();
}

class _AddContentState extends State<AddContent> {
  double latitude = 0.0;
  double longitude = 0.0;
  String networkStatus = 'Offline';
  String networkType = 'None';
  bool isInFrance = false;

  @override
  void initState() {
    _getLocation();
    _getNetworkStatus();
    _userIsInFrance();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 17, 17, 17),
        body: GestureDetector(
          onDoubleTap: () {
            Navigator.pushNamed(context, '/home');
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
                            'Il y a 0 photos souvenirs',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Send your content to the server',
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
                // a button on the bottom of the screen to send the content
                _userCanSendContent()
                    ? Positioned(
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
                                    // TODO: send the content to the server
                                    uploadImage();
                                  },
                                  child: const Iconify(MaterialSymbols.add)),
                            ],
                          ),
                        ),
                      )
                    : // don't show the button if the user is not allowed to send content
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
                                  onPressed: () {
                                    // tell the user that he can't send content
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('You can\'t send content'),
                                          content: const Text(
                                              'You can only send content if you are in France or using wifi'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Iconify(MaterialSymbols.add)),
                              Text(
                                'You are not allowed to send content',
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
              ],
            ),
          ),
        ));
  }
}
