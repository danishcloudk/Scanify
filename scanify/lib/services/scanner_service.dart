import 'package:flutter/foundation.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

class ScannerService {
  Future<List<String>?> scanDocument({bool useGallery = false}) async {
    try {
      final documentScanner = DocumentScanner(
        options: DocumentScannerOptions(
          documentFormats: {DocumentFormat.jpeg},
          mode: ScannerMode.full,
          pageLimit: 10, // Increased limit for multi-page scans
          isGalleryImport: useGallery,
        ),
      );
      
      final result = await documentScanner.scanDocument();
      documentScanner.close();
      return result.images;
    } catch (e) {
      debugPrint('Error scanning document: $e');
      return null;
    }
  }
}
