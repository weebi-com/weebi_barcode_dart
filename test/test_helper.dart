import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:weebi_barcode_dart/weebi_barcode_dart.dart';

/// Test helper utilities for barcode SDK testing
/// 
/// Model Attribution:
/// These tests use the YOLO barcode detection model from:
/// Source: https://huggingface.co/weebi/weebi_barcode_detector/blob/main/best.rten
/// License: AGPL-3.0 (Ultralytics)
/// SHA256: 48fc65ec220954859f147c85bc7422abd590d62648429d490ef61a08b973a10f
class TestHelper {
  static bool _isInitialized = false;
  static String? _modelPath;
  
  static const String _modelFileName = 'best.rten';

  /// Initialize the SDK for testing
  /// This will search for the model in local directories
  static Future<void> initializeForTesting() async {
    if (_isInitialized) {
      return; // Already initialized
    }

    print('🧪 Test: Setting up barcode SDK');
    print('📖 Model source: https://huggingface.co/weebi/weebi_barcode_detector/blob/main/best.rten');
    print('⚖️  License: AGPL-3.0 (Ultralytics)');

    // Try different possible model locations
    final possiblePaths = [
      // 1. Test assets directory (preferred for CI/isolated testing)
      path.join('test', 'assets', 'best.rten'),
      
      // 2. Relative to dart_barcode directory
      path.join('..', 'rust-barcode-lib', 'models', 'best.rten'),
      
      // 3. From current working directory
      path.join('rust-barcode-lib', 'models', 'best.rten'),
      
      // 4. Direct file name (if in PATH or current dir)
      'best.rten',
    ];

    String? foundPath;
    for (final testPath in possiblePaths) {
      if (File(testPath).existsSync()) {
        foundPath = testPath;
        final fileSize = File(testPath).lengthSync();
        print('✅ Found model at: $testPath (${(fileSize / 1024 / 1024).toStringAsFixed(1)} MB)');
        break;
      }
    }

    if (foundPath == null) {
      fail('Model file not found. Tried the following paths:\n'
           '${possiblePaths.map((p) => '  - $p').join('\n')}\n\n'
           'To fix this:\n'
           '1. Copy best.rten to test/assets/ directory\n'
           '2. Ensure the model exists in rust-barcode-lib/models/\n'
           '3. Model source: https://huggingface.co/weebi/weebi_barcode_detector/blob/main/best.rten');
    }

    final initialized = await BarcodeDetector.initialize(foundPath);
    if (!initialized) {
      fail('Failed to initialize barcode SDK with model: $foundPath');
    }

    _isInitialized = true;
    _modelPath = foundPath;
    print('✅ Test: SDK initialized successfully');
  }

  /// Get the current model path used for testing
  static String? get modelPath => _modelPath;

  /// Check if the SDK is initialized for testing
  static bool get isInitialized => _isInitialized;

  /// Reset the initialization state (useful for test isolation)
  static void reset() {
    _isInitialized = false;
    _modelPath = null;
  }

  /// Setup function to be called in setUpAll() for test groups
  static Future<void> setupSDK() async {
    await initializeForTesting();
  }
} 