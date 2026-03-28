import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants.dart';
import '../widgets/glass_card.dart';
import '../models/scan_model.dart';
import '../models/disease_model.dart';
import '../data/disease_data.dart';
import '../services/storage_service.dart';

class GalleryScreen extends StatefulWidget {
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<ScanResult> scans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScans();
  }

  Future<void> _loadScans() async {
    setState(() => _isLoading = true);
    try {
      final loadedScans = await StorageService().getScans();
      // Sort by date (newest first)
      loadedScans.sort((a, b) => b.date.compareTo(a.date));
      setState(() {
        scans = loadedScans;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading scans: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteScan(String id) async {
    try {
      await StorageService().deleteScan(id);
      await _loadScans(); // Reload the list
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scan deleted'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting scan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _clearAllScans() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Scans'),
        content: Text('Are you sure you want to delete all scans?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete All'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await StorageService().clearAllScans();
        await _loadScans();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('All scans cleared'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error clearing scans: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<DiseaseModel?> _findDisease(String healthStatus) async {
    try {
      return diseases.firstWhere(
        (d) => d.name.contains(healthStatus) || healthStatus.contains(d.name),
      );
    } catch (e) {
      return null;
    }
  }

  void _showScanDetails(BuildContext context, ScanResult scan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            // Image preview
            Container(
              height: 250,
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: FileImage(File(scan.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scan.healthStatus,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppColors.lightTextSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            scan.date,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Icon(
                            Icons.verified,
                            size: 16,
                            color: scan.confidence > 90 
                                ? Colors.green 
                                : scan.confidence > 70 
                                    ? Colors.orange 
                                    : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${scan.confidence.toStringAsFixed(1)}% confidence",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: scan.confidence > 90 
                                  ? Colors.green 
                                  : scan.confidence > 70 
                                      ? Colors.orange 
                                      : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Find disease info
                      FutureBuilder<DiseaseModel?>(
                        future: _findDisease(scan.healthStatus),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          
                          if (!snapshot.hasData || snapshot.data == null) {
                            return Center(
                              child: Text(
                                "No additional information available",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: AppColors.lightTextSecondary,
                                ),
                              ),
                            );
                          }
                          
                          final disease = snapshot.data!;
                          final typeColor = getTypeColor(disease.type);
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Type badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: typeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: typeColor.withOpacity(0.3)),
                                ),
                                child: Text(
                                  disease.type,
                                  style: TextStyle(
                                    color: typeColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              Text(
                                "Description",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                disease.description,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: AppColors.lightTextSecondary,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              Text(
                                "Treatment",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                disease.treatment,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: AppColors.lightTextSecondary,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              Text(
                                "Prevention Tips",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...disease.preventionTips.map((tip) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      LucideIcons.check,
                                      size: 16,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        tip,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          color: AppColors.lightTextSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
          "Scan Archives",
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(LucideIcons.refreshCw, color: AppColors.lightTextPrimary),
            onPressed: _loadScans,
            tooltip: 'Refresh',
          ),
          if (scans.isNotEmpty)
            IconButton(
              icon: Icon(LucideIcons.trash2, color: Colors.red),
              onPressed: _clearAllScans,
              tooltip: 'Clear all',
            ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Loading scans...",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            )
          : scans.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadScans,
                  color: AppColors.emerald,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: scans.length,
                    itemBuilder: (context, index) {
                      final scan = scans[index];
                      return _buildScanCard(scan, index);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.archive,
              size: 100,
              color: AppColors.lightTextSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              "No scans yet",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Start scanning to see your results here",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/analyzer');
              },
              icon: const Icon(LucideIcons.camera),
              label: const Text("Start Scanning"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emerald,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanCard(ScanResult scan, int index) {
    final typeColor = scan.healthStatus.contains('Healthy')
        ? Colors.green
        : scan.healthStatus.contains('Late') || scan.healthStatus.contains('Yellow')
            ? Colors.red
            : scan.healthStatus.contains('Early') || scan.healthStatus.contains('Spot')
                ? Colors.orange
                : Colors.blue;

    return Dismissible(
      key: Key(scan.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete Scan'),
            content: Text('Are you sure you want to delete this scan?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => _deleteScan(scan.id),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GlassCard(
          onTap: () {
            _showScanDetails(context, scan);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Image preview
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(File(scan.imagePath)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Scan info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scan.healthStatus,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.calendar,
                            size: 12,
                            color: AppColors.lightTextSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            scan.date,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            LucideIcons.barChart,
                            size: 12,
                            color: AppColors.lightTextSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${scan.confidence.toStringAsFixed(1)}%",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: scan.confidence > 90 
                                  ? Colors.green 
                                  : scan.confidence > 70 
                                      ? Colors.orange 
                                      : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Confidence indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${scan.confidence.toStringAsFixed(0)}%",
                    style: GoogleFonts.plusJakartaSans(
                      color: typeColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(
      duration: 400.ms,
      delay: (index * 100).ms,
    ).slideX(begin: 0.2, end: 0);
  }
}