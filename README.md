# Weebi Barcode Dart

Core barcode detection library using embedded YOLO neural network. Provides low-level FFI interface to Rust-based barcode detection with support for multiple image formats and high accuracy detection.

## Features

- 🎯 **YOLO-based Detection**: High-accuracy barcode detection using embedded neural network
- 🖼️ **Multiple Image Formats**: Support for PNG, JPEG, YUV420, BGRA8888, and generic YUV
- 🚀 **Super-Resolution**: Optional image enhancement for better detection accuracy
- 🏗️ **Cross-Platform**: Windows, macOS, Linux, Android, and iOS support
- 💻 **Pure Dart**: Framework-agnostic, can be used in any Dart/Flutter project
- 🔧 **Low-Level FFI**: Direct interface to native Rust library for maximum performance

## Installation

Add this to your package's `pubspec.yaml`:

```yaml
dependencies:
  weebi_barcode_dart: ^1.0.0
```

## Quick Start

```dart
import 'package:weebi_barcode_dart/weebi_barcode_dart.dart';
import 'dart:io';
import 'dart:typed_data';

void main() async {
  // Initialize the SDK with your model file
  bool initialized = await BarcodeDetector.initialize('assets/best.rten');
  if (!initialized) {
    print('Failed to initialize barcode detector');
    return;
  }

  // Read an image file
  final imageFile = File('barcode_image.jpg');
  final imageBytes = await imageFile.readAsBytes();

  // Process the image
  try {
    final results = await BarcodeDetector.processImage(
      format: ImageFormat.jpeg,
      bytes: imageBytes,
    );

    for (final result in results) {
      print('Found ${result.format}: ${result.text}');
      if (result.bounds != null) {
        print('Location: ${result.bounds}');
      }
    }
  } catch (e) {
    print('Error processing image: $e');
  }
}
```

## Advanced Usage

### YUV420 Processing (Camera Integration)

For camera applications, you can process YUV420 data directly for better performance:

```dart
final results = await BarcodeDetector.processYuv420Image(
  yPlane: yPlaneData,
  uPlane: uPlaneData,
  vPlane: vPlaneData,
  width: imageWidth,
  height: imageHeight,
  uvRowStride: uvRowStride,
  uvPixelStride: uvPixelStride,
  useSuperResolution: true,
);
```

### Image Format Support

The library supports multiple image formats:

```dart
// PNG images
await BarcodeDetector.processImage(
  format: ImageFormat.png,
  bytes: pngBytes,
);

// JPEG images  
await BarcodeDetector.processImage(
  format: ImageFormat.jpeg,
  bytes: jpegBytes,
);

// BGRA8888 format (with dimensions)
await BarcodeDetector.processImage(
  format: ImageFormat.bgra8888,
  bytes: bgra8888Bytes,
  width: imageWidth,
  height: imageHeight,
  bytesPerRow: bytesPerRow,
);
```

## Platform Setup

### Windows
```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/best.rten
    - windows/rust_barcode_lib.dll
```

### Android
```yaml
# pubspec.yaml  
flutter:
  assets:
    - assets/best.rten
    - android/jniLibs/
```

### iOS/macOS
```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/best.rten
    - ios/lib_rust_barcode_lib.dylib  # iOS
    - macos/lib_rust_barcode_lib.dylib  # macOS
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For issues and questions:
- 📝 [GitHub Issues](https://github.com/weebi-com/weebi_barcode_dart/issues)
- 📧 Contact: [support@weebi.com](mailto:support@weebi.com)
