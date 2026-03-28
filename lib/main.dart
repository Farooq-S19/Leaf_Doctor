import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'screens/splash_screen.dart';  // ← ADD THIS IMPORT
import 'screens/home_screen.dart';
import 'screens/about_app_screen.dart';
import 'screens/diseases_screen.dart';
import 'screens/analyzer_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/analysis_result_screen.dart';
import 'screens/disease_detail_screen.dart';
import 'models/disease_model.dart';
import 'core/constants.dart';

void main() => runApp(const LeafDoctorApp());

class LeafDoctorApp extends StatelessWidget {
  const LeafDoctorApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LeafDoctor AI',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.emerald,
        scaffoldBackgroundColor: AppColors.lightBg,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.lightTextPrimary,
          titleTextStyle: TextStyle(
            color: AppColors.lightTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        colorScheme: ColorScheme.light(
          primary: AppColors.emerald,
          secondary: AppColors.emerald,
          surface: AppColors.lightSurface,
          background: AppColors.lightBg,
          error: AppColors.lightDanger,
        ),
      ),
      // ← CHANGE THIS - Use SplashScreen instead of HomeScreen
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),  // ← ADD home route
        '/about': (context) => AboutAppScreen(),
        '/diseases': (context) => DiseasesScreen(),
        '/analyzer': (context) => AnalyzerScreen(),
        '/gallery': (context) => GalleryScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/disease-detail') {
          final disease = settings.arguments as DiseaseModel;
          return MaterialPageRoute(
            builder: (context) => DiseaseDetailScreen(disease: disease),
          );
        }
        if (settings.name == '/result') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => AnalysisResultScreen(
              imageFile: args['imageFile'],
              predictionResult: args['predictionResult'],
            ),
          );
        }
        return null;
      },
    );
  }
}