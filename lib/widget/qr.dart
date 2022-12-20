/*
 * QR.Flutter
 * Copyright (c) 2019 the QR.Flutter authors.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Qr extends StatelessWidget {
  const Qr({
    super.key,
    required this.documentID,
    required this.title,
  });
  final documentID;
  final title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.9),
      appBar: AppBar(
        title: const Text('Message QR Generator'),
      ),
      body: Center(
        // color: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title.toString()),
            Container(
              width: MediaQuery.of(context).size.width * .7,
              child: QrImage(
                data: documentID,
                version: QrVersions.auto,
                backgroundColor: Colors.white,
                size: 320,
                gapless: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
