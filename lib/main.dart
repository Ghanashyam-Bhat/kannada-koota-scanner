import 'package:rajyotsava/handle_data.dart';
import 'package:rajyotsava/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.qr_code_scanner,color: Colors.black,),
        title: Text('Kannada Koota Ticket Scanner',
          style: TextStyle(
          color: Colors.black, // Set your desired text color
          fontSize: 20, // Set the font size as needed
            fontWeight: FontWeight.bold, // Make the text bold
          // You can customize other text style properties here
        ),),
        backgroundColor: Colors.transparent, // Set a transparent background
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.yellow], // Specify your gradient colors
              begin: Alignment.topCenter, // Adjust the starting point of the gradient
              end: Alignment.bottomCenter, // Adjust the ending point of the gradient
            ),
          ),
        ),
        actions: <Widget>[

        ],
      ),
      body: Center(
        child: QRScanner()
      ),
    );
  }
}