import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

class SaveService {
  Future<String?> saveAsPdf(List<String> imagePaths, String filename) async {
    try {
      final pdf = pw.Document();
      
      for (String path in imagePaths) {
        final imageFile = File(path);
        final imageProvider = pw.MemoryImage(imageFile.readAsBytesSync());

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(imageProvider, fit: pw.BoxFit.contain),
              );
            },
          ),
        );
      }

      final downloadDir = Directory('/storage/emulated/0/Download');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }
      
      final file = File('${downloadDir.path}/$filename.pdf');
      await file.writeAsBytes(await pdf.save());
      return file.path;
    } catch (e) {
      print('Error saving PDF: $e');
      return null;
    }
  }

  Future<List<String>?> saveAsJpeg(List<String> imagePaths, String filename) async {
    try {
      final downloadDir = Directory('/storage/emulated/0/Download');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }
      
      List<String> savedPaths = [];
      for (int i = 0; i < imagePaths.length; i++) {
        final sourceFile = File(imagePaths[i]);
        final destFilename = imagePaths.length == 1 ? '$filename.jpg' : '${filename}_${i + 1}.jpg';
        final destFile = File('${downloadDir.path}/$destFilename');
        await sourceFile.copy(destFile.path);
        savedPaths.add(destFile.path);
      }
      return savedPaths;
    } catch (e) {
      print('Error saving JPEG: $e');
      return null;
    }
  }

  Future<String?> saveAsTxt(String text, String filename) async {
    try {
      final downloadDir = Directory('/storage/emulated/0/Download');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }
      final file = File('${downloadDir.path}/$filename.txt');
      await file.writeAsString(text);
      return file.path;
    } catch (e) {
      print('Error saving TXT: $e');
      return null;
    }
  }
}
