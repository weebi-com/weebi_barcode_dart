import 'dart:io';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;
import 'package:weebi_barcode_dart/weebi_barcode_dart.dart';
import 'test_helper.dart';

void main() {
  group('Call Rust FFI to decode a known barcode from a PNG/JPG image ', () {
    setUpAll(() async {
      // Initialize the SDK using the test helper
      await TestHelper.setupSDK();
    });

    test('qr.png', () async {
      final imagePath = path.join('qr.png');
      final imageFile = File(imagePath);
      expect(imageFile.existsSync(), isTrue, reason: 'Test image should exist');

      final imageBytes = await imageFile.readAsBytes();

      final results = await BarcodeDetector.processImage(
        format: ImageFormat.png,
        bytes: imageBytes,
      );

      expect(results, isNotNull, reason: 'Results should not be null');
      expect(results, hasLength(1), reason: 'Should find exactly one barcode');

      final barcode = results.first;
      expect(barcode.text, equals('http://en.m.wikipedia.org'),
          reason: 'Detected text should match');
      expect(barcode.format.toLowerCase(), equals('qr_code'),
          reason: 'Detected format should be QR_CODE');

      print('Successfully decoded barcode via Rust FFI:');
      print('  Text: ${barcode.text}');
      print('  Format: ${barcode.format}');
    });

  });
}
