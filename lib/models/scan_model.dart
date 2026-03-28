class ScanResult {
  final String id;
  final String plantName;
  final String healthStatus;
  final double confidence;
  final String date;
  final String imagePath; // Add this to store image path

  ScanResult({
    required this.id,
    required this.plantName,
    required this.healthStatus,
    required this.confidence,
    required this.date,
    required this.imagePath,
  });

  // Convert to Map for storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'plantName': plantName,
    'healthStatus': healthStatus,
    'confidence': confidence,
    'date': date,
    'imagePath': imagePath,
  };

  // Create from Map
  factory ScanResult.fromJson(Map<String, dynamic> json) => ScanResult(
    id: json['id'],
    plantName: json['plantName'],
    healthStatus: json['healthStatus'],
    confidence: json['confidence'],
    date: json['date'],
    imagePath: json['imagePath'],
  );
}