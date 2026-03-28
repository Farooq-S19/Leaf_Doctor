class DiseaseModel {
  final String name;
  final String description;   // About
  final String treatment;     // Cure
  final String image;         // Asset path
  final String type;          // Disease severity: Dangerous, Moderate, Mild, Healthy
  final String scientificName; // Scientific name
  final List<String> symptoms; // List of symptoms
  final List<String> preventionTips; // Prevention tips

  DiseaseModel({
    required this.name,
    required this.description,
    required this.treatment,
    required this.image,
    required this.type,
    required this.scientificName,
    required this.symptoms,
    required this.preventionTips,
  });

  // Get short description (first 100 chars)
  String get shortDescription {
    if (description.length <= 100) return description;
    return '${description.substring(0, 97)}...';
  }
}