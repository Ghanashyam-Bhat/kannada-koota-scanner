import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void _startScanning(controller) {
  if (controller != null) {
    controller!.resumeCamera();
  }
}

class HandleData extends StatelessWidget {
  final String? hashVal;
  final  controller;
  const HandleData({Key? key, this.hashVal,this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
        _startScanning(controller);
        return true;
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Colors.red, // Set the app bar color to red
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            _startScanning(controller);
          },
        ),
      ),
      backgroundColor: Colors.yellow, // Set the background color to yellow

      body: FutureBuilder(
        future: fetchData(hashVal),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'NO DATA FOUND or ERROR OCCURED',
                style: TextStyle(fontSize: 16, color: Colors.red), // Set text color to red
              ),
            );
          } else if (snapshot.hasData) {
            final attendeeData = snapshot.data as Map<String, dynamic>;

            final name = attendeeData['name'];
            final id = attendeeData['id'];
            final phone = attendeeData['phone'];
            final email = attendeeData['email'];
            final verified = attendeeData['verified'];
            final isVip = attendeeData['isVip'];

            final List<Widget> tiles = [
              ListTile(
                title: Text('Name', style: TextStyle(fontSize: 20)), // Customize text font and size
                subtitle: Text(
                  name,
                  style: TextStyle(fontSize: 18, color: Colors.red), // Set text color to red
                ),
              ),
              ListTile(
                title: Text('ID', style: TextStyle(fontSize: 20)),
                subtitle: Text(
                  id,
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
              ListTile(
                title: Text('Phone', style: TextStyle(fontSize: 20)),
                subtitle: Text(
                  phone,
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
              ListTile(
                title: Text('Email', style: TextStyle(fontSize: 20)),
                subtitle: Text(
                  email,
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              )
            ];

            if (isVip) {
              tiles.add(
                ListTile(
                  title: Text('VIP Pass', style: TextStyle(fontSize: 20, color: Colors.black))
                ),
              );
            }

            if (!verified) {
              tiles.add(
                  ElevatedButton(
                    onPressed: () {
                      // Handle authentication logic here
                      // You can use showDialog to show an authentication form
                      updateData(hashVal, context, controller);
                    },
                    child: Text(
                      'Authenticate',
                      style: TextStyle(color: Colors
                          .white), // Set button text color to yellow
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(30),
                      primary: Colors.green, // Set button color to red
                    ),
                  ));
            }
          if (verified) {
            tiles.add(
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('User is already authenticated'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('GO TO SCANNER',
                                  style: TextStyle(color: Colors.red)),
                              // Set button text color to red
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                _startScanning(controller);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('User Authenticated',
                      style: TextStyle(color: Colors.white)),
                  // Set button text color to yellow
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(30),
                    primary: Colors.red, // Set button color to red
                  ),
                ));
          }

            return ListView(
              padding: EdgeInsets.all(16.0),
              children:tiles
            );
          } else {
            return Center(
              child: Text('No data available', style: TextStyle(color: Colors.red),), // Set text color to red
            );
          }
        },
      ),
    )
    );
  }
}

Future<Map<String, dynamic>> fetchData(docId) async {
  final DocumentSnapshot attendeeData = await FirebaseFirestore.instance.collection("attendees").doc(docId).get();
  return attendeeData.data() as Map<String, dynamic>;
}

Future<void> updateData(String? docId, BuildContext context,QRViewController controller) async {
  try {
    await FirebaseFirestore.instance.collection("attendees").doc(docId).update({
      "verified": true,
    });
    Navigator.of(context).pop();
    _startScanning(controller);
  } catch (error) {
    print("Error pushing the data: $error");
  }
}
