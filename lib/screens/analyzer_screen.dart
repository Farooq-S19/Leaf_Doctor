import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/tflite_service.dart';  // Changed from yolo_tflite_service to tflite_service
import '../core/constants.dart';
import 'analysis_result_screen.dart';

class AnalyzerScreen extends StatefulWidget {
  const AnalyzerScreen({super.key});

  @override
  State<AnalyzerScreen> createState() => _AnalyzerScreenState();
}

class _AnalyzerScreenState extends State<AnalyzerScreen>
    with SingleTickerProviderStateMixin {
  File? _selectedImage;
  bool _isProcessing = false;
  bool _isModelLoading = true;
  String? _modelError;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  final ImagePicker _picker = ImagePicker();
  final TFLiteService _tfliteService = TFLiteService(); // Changed to TFLiteService

  @override
  void initState() {
    super.initState();
    _initializeModel(); // Changed from _initializeModels to _initializeModel
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeModel() async { // Changed method name
    setState(() {
      _isModelLoading = true;
      _modelError = null;
    });
    
    try {
      await _tfliteService.loadModel(); // Changed from loadModels to loadModel
    } catch (e) {
      setState(() {
        _modelError = 'Failed to load AI model: $e';
      });
    } finally {
      setState(() {
        _isModelLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _tfliteService.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
    
    final photosStatus = await Permission.photos.status;
    if (!photosStatus.isGranted) {
      await Permission.photos.request();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    await _checkPermissions();
    
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 90,
      );
      
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        
        // Auto-analyze after image selection
        await _analyzeImage();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: AppColors.lightDanger,
          ),
        );
      }
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null || _isModelLoading) return;
    
    setState(() {
      _isProcessing = true;
    });
    
    try {
      // Get prediction from the model
      final result = await _tfliteService.predictImage(_selectedImage!);
      
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalysisResultScreen(
              imageFile: _selectedImage!,
              predictionResult: result,
            ),
          ),
        ).then((_) {
          if (mounted) {
            setState(() {
              _selectedImage = null;
              _isProcessing = false;
            });
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analysis failed: $e'),
            backgroundColor: AppColors.lightDanger,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0x1A000000),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Choose Image Source",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildSourceButton(
                    icon: LucideIcons.camera,
                    label: "Camera",
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSourceButton(
                    icon: LucideIcons.image,
                    label: "Gallery",
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          "Leaf Scanner",
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Center(
                  child: _isModelLoading
                      ? _buildLoadingIndicator()
                      : _modelError != null
                          ? _buildErrorWidget()
                          : _buildScannerInterface(),
                ),
              ),
            ],
          ),
          
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Analyzing Leaf...",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        "AI model is processing",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScannerInterface() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColors.emerald.withOpacity(0.5),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.emerald.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(27),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Icon(
                        LucideIcons.leaf,
                        size: 80,
                        color: AppColors.emerald.withOpacity(0.3),
                      ),
                    ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Main heading - Changed to "Scan Leaf"
          Text(
            _selectedImage == null
                ? "Scan Leaf"
                : "Ready to Analyze",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextPrimary,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Caption text - Added as requested
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Capture or upload a clear image of a single tomato leaf on a plain background for accurate disease detection. Ensure the leaf is fully visible and not blurry for better detection results.",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedImage != null) ...[
                _buildActionButton(
                  icon: LucideIcons.refreshCw,
                  label: "Retake",
                  onTap: () {
                    setState(() => _selectedImage = null);
                  },
                ),
                const SizedBox(width: 20),
              ],
              
              _buildScanButton(),
              
              if (_selectedImage == null) ...[
                const SizedBox(width: 20),
                _buildActionButton(
                  icon: LucideIcons.image,
                  label: "Gallery",
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScanButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _selectedImage != null
            ? _analyzeImage
            : () => _pickImage(ImageSource.camera),
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.emerald,
                AppColors.emerald.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.emerald.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _selectedImage != null ? LucideIcons.scanLine : LucideIcons.camera,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                _selectedImage != null ? "ANALYZE" : "TAKE PHOTO",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.lightSurface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0x1A000000)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.lightTextSecondary),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.lightTextSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        const SizedBox(height: 20),
        Text(
          "Loading AI Model...",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Disease detection model",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(LucideIcons.alertTriangle, size: 60, color: AppColors.lightDanger),
        const SizedBox(height: 20),
        Text(
          "Model Loading Failed",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            _modelError ?? "Unknown error",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.lightTextSecondary,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _initializeModel,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.emerald,
            foregroundColor: Colors.white,
          ),
          child: const Text("Retry"),
        ),
      ],
    );
  }
}