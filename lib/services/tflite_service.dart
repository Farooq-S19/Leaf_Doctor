import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  static final TFLiteService _instance = TFLiteService._internal();
  factory TFLiteService() => _instance;
  TFLiteService._internal();

  Interpreter? _interpreter;
  static const int _inputSize = 224;
  static const int _numClasses = 10;
  static const double _minGreenPercentage = 20.0;
  static const double _lowConfidenceThreshold = 65.0; // Changed from 70 to 65
  
  static const List<String> diseaseClasses = [
    'Healthy', 'Bacterial Spot', 'Early Blight', 'Late Blight',
    'Leaf Mold', 'Septoria Leaf Spot', 'Spider Mites', 'Target Spot',
    'Tomato Mosaic Virus', 'Tomato Yellow Leaf Curl Virus',
  ];

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/model.tflite',
        options: InterpreterOptions()..threads = 4,
      );
      print('✅ Model loaded');
    } catch (e) {
      print('❌ Model load failed: $e');
      rethrow;
    }
  }

  // HSV Green detection
  double _calculateGreenPercentageHSV(img.Image image) {
    int greenCount = 0;
    int totalPixels = image.width * image.height;
    
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final p = image.getPixel(x, y);
        
        // Convert RGB to HSV
        double r = p.r / 255.0;
        double g = p.g / 255.0;
        double b = p.b / 255.0;
        
        double max = r > g ? (r > b ? r : b) : (g > b ? g : b);
        double min = r < g ? (r < b ? r : b) : (g < b ? g : b);
        double delta = max - min;
        
        // Calculate Hue
        double h = 0;
        if (delta > 0) {
          if (max == r) {
            h = 60 * (((g - b) / delta) % 6);
          } else if (max == g) {
            h = 60 * (((b - r) / delta) + 2);
          } else {
            h = 60 * (((r - g) / delta) + 4);
          }
        }
        if (h < 0) h += 360;
        
        // Calculate Saturation
        double s = (max == 0) ? 0 : (delta / max);
        
        // Calculate Value
        double v = max;
        
        // Convert to OpenCV HSV range
        int hValue = (h / 2).round();
        int sValue = (s * 255).round();
        int vValue = (v * 255).round();
        
        // Check if pixel is in green range
        if (hValue >= 25 && hValue <= 100 && 
            sValue >= 25 && vValue >= 25) {
          greenCount++;
        }
      }
    }
    
    return (greenCount / totalPixels) * 100;
  }

  Future<Map<String, dynamic>> predictImage(File imageFile) async {
    if (_interpreter == null) throw Exception('Model not loaded');

    try {
      final bytes = await imageFile.readAsBytes();
      final img.Image? originalImage = img.decodeImage(bytes);
      if (originalImage == null) throw Exception('Failed to decode image');
      
      // Check green percentage
      final greenPercent = _calculateGreenPercentageHSV(originalImage);
      print('🌿 Green area: ${greenPercent.toStringAsFixed(1)}%');
      
      if (greenPercent < _minGreenPercentage) {
        return {
          'diseaseName': 'No Leaf Detected',
          'confidence': 0.0,
          'isHealthy': false,
          'message': 'No leaf detected in the image. Please ensure the photo clearly shows a tomato leaf.',
          'greenPercentage': greenPercent,
        };
      }
      
      // Preprocess with [-1, 1] normalization
      final resized = img.copyResize(originalImage, width: _inputSize, height: _inputSize);
      
      final input = List.generate(1, (_) => List.generate(_inputSize, (y) => 
          List.generate(_inputSize, (x) {
            final p = resized.getPixel(x, y);
            return [
              (p.r / 127.5) - 1.0,
              (p.g / 127.5) - 1.0, 
              (p.b / 127.5) - 1.0
            ];
          })));
      
      // Run inference
      var output = List.filled(1 * _numClasses, 0.0).reshape([1, _numClasses]);
      _interpreter!.run(input, output);
      
      // Process results with softmax
      final logits = output[0];
      
      // Find max value
      double maxVal = logits[0];
      for (int i = 1; i < logits.length; i++) {
        if (logits[i] > maxVal) {
          maxVal = logits[i];
        }
      }
      
      // Calculate exp values and sum
      List<double> expValues = [];
      double sum = 0.0;
      for (int i = 0; i < logits.length; i++) {
        double val = exp(logits[i] - maxVal);
        expValues.add(val);
        sum += val;
      }
      
      // Calculate probabilities
      List<double> probs = [];
      for (int i = 0; i < expValues.length; i++) {
        probs.add(expValues[i] / sum);
      }
      
      // Find max probability
      int maxIdx = 0;
      double maxProb = probs[0];
      for (int i = 1; i < probs.length; i++) {
        if (probs[i] > maxProb) {
          maxProb = probs[i];
          maxIdx = i;
        }
      }
      
      double confidence = maxProb * 100;
      
      // NEW: If confidence < 65%, return unable to identify message
      if (confidence < _lowConfidenceThreshold) {
        return {
          'diseaseName': 'Unable to Identify',
          'confidence': confidence,
          'isHealthy': false,
          'greenPercentage': greenPercent,
          'message': 'Unable to confidently identify the disease from this image. Please consult a nearby plant diagnostic center or agricultural expert for accurate diagnosis.',
        };
      }
      
      // Prepare result for confident predictions
      Map<String, dynamic> result = {
        'diseaseName': diseaseClasses[maxIdx],
        'confidence': confidence,
        'isHealthy': maxIdx == 0,
        'greenPercentage': greenPercent,
      };
      
      return result;
      
    } catch (e) {
      print('❌ Analysis error: $e');
      return {
        'diseaseName': 'Analysis Error',
        'confidence': 0.0,
        'isHealthy': false,
        'message': 'Error during analysis: $e. Please try again.',
      };
    }
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}