import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// icons
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
// url launcher
import 'package:url_launcher/url_launcher.dart';
// connectivity_plus
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // password input field
  String password = '';
  // website url
  final Uri _url = Uri.parse('https://lny-gallery.web.app/');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0x00111111),
        body: // this will be seperated into two sections, the top one text, the secon one a group of images
            SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(-1, -1),
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // open website
                        _launchUrl();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: const CircleBorder(),
                      ),
                      child: Iconify(
                        // website icon
                        MaterialSymbols.web,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, -0.9),
                  child: Text(
                    'LNY',
                    style: GoogleFonts.montserrat(
                      fontSize: 128,
                      // primary color
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Align(
                  // just under the above text
                  alignment: const Alignment(0, -0.45),
                  child: SizedBox(
                    height: 150,
                    // width is 80% of the screen
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'L\'app de la famille pour la famille !',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 248, 248, 248),
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                // Images
                Align(
                    // this one will be 100px height and 100px width, 22px left and 350px down
                    alignment: const Alignment(-1, -0.2),
                    child: GestureDetector(
                      onTap: () {
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
                                child: Image.asset('assets/img/1.jpg'),
                              ),
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/img/1.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )),
                Align(
                    // this one will be 100px height and 100px width, 22px left and 350px down
                    alignment: const Alignment(-1, 0.5),
                    child: GestureDetector(
                      onTap: () {
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
                                child: Image.asset('assets/img/3.jpg'),
                              ),
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/img/3.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )),
                Align(
                    // this one will be 100px height and 100px width, 22px left and 350px down
                    alignment: const Alignment(1, 0.05),
                    child: GestureDetector(
                      onTap: () {
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
                                child: Image.asset('assets/img/2.jpg'),
                              ),
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/img/2.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )),
                Align(
                    // this one will be 100px height and 100px width, 22px left and 350px down
                    alignment: const Alignment(1, 0.8),
                    child: GestureDetector(
                      onTap: () {
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
                                child: Image.asset('assets/img/4.jpeg'),
                              ),
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/img/4.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )),
                // Button to go to the next page
                Align(
                  alignment: const Alignment(0, 0.9),
                  child: SizedBox(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // primary of colorscheme
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // go to add_content.dart
                        Navigator.pushNamed(context, '/gallery');
                      },
                      onLongPress: () {
                        // prompt for password using a dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Password'),
                              content: TextField(
                                obscureText: true,
                                onChanged: (String value) {
                                  password = value;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // check if password is correct
                                    if (password == 'paradise') {
                                      // go to add_content.dart
                                      Navigator.pushNamed(context, '/admin');
                                    } else {
                                      // show error message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Wrong password'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: // Iconify arrow
                          Iconify(
                        MaterialSymbols.arrow_forward,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
