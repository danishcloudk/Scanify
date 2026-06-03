import 'dart:convert';

class ScanModel {
  final String id;
  final String title;
  final List<String> imagePaths;
  final String? extractedText;
  final DateTime timestamp;

  ScanModel({
    required this.id,
    required this.title,
    required this.imagePaths,
    this.extractedText,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imagePaths': imagePaths,
      'extractedText': extractedText,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory ScanModel.fromMap(Map<String, dynamic> map) {
    return ScanModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      imagePaths: map['imagePaths'] != null 
          ? List<String>.from(map['imagePaths']) 
          : (map['imagePath'] != null ? [map['imagePath']] : []),
      extractedText: map['extractedText'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScanModel.fromJson(String source) => ScanModel.fromMap(json.decode(source));
}
