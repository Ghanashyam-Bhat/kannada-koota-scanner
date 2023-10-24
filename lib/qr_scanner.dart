import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rajyotsava/handle_data.dart';
class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
        _startScanning();
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _startScanning() {
    if (controller != null) {
      controller!.resumeCamera();
    }
  }

  void _stopScanning() {
    if (controller != null) {
      controller!.pauseCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red, // Red border color
                  width: 4, // Border width
                ),
              ),
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
        print(scanData.code);
        print(scanData.format);
        if (scanData != null) {
          var qrData = scanData.code?.split("-");
          print(qrData);
          if (qrData != null && qrData.length == 3 && qrData[0] == "KK" && qrData[1] == "ATTENDEE_PASS") {
            final String hashValFromQr = qrData[2];
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HandleData(hashVal: hashValFromQr,controller: this.controller,)),
            );
            _stopScanning(); // Stop scanning when routed
          }
        }


      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
