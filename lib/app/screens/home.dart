import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// icons
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

// for now we just show a text widget telling us if we are connected to firebase or not

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // password to access the admin page
  final String password = 'ILoveEthan';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0x00111111),
        body: // this will be seperated into two sections, the top one text, the secon one a group of images
            SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0, -0.9),
                  child: Text(
                    'LNY',
                    style: GoogleFonts.montserrat(
                      fontSize: 128,
                      color: const Color.fromARGB(255, 238, 238, 155),
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
                      'L\'app de la famille version admin pcq why not Ethan',
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
                    )),
                Align(
                    // this one will be 100px height and 100px width, 22px left and 350px down
                    alignment: const Alignment(-1, 0.5),
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
                    )),
                Align(
                    // this one will be 100px height and 100px width, 22px left and 350px down
                    alignment: const Alignment(1, 0.05),
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
                    )),
                Align(
                    // this one will be 100px height and 100px width, 22px left and 350px down
                    alignment: const Alignment(1, 0.8),
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
                    )),
                // Button to go to the next page
                Align(
                  alignment: const Alignment(0, 0.9),
                  child: SizedBox(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 238, 238, 155),
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
                              content: const TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // if the password is correct, go to the admin page
                                    if (password == 'ILoveEthan') {
                                      Navigator.pushNamed(context, '/admin');
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
                          const Iconify(
                        MaterialSymbols.arrow_forward,
                        color: Color.fromARGB(255, 0, 0, 0),
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
