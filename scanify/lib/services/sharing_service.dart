import 'package:share_plus/share_plus.dart';

class SharingService {
  Future<void> shareFile(String filePath, String title) async {
    await Share.shareXFiles([XFile(filePath)], text: title);
  }

  Future<void> shareFiles(List<String> filePaths, String title) async {
    final xFiles = filePaths.map((p) => XFile(p)).toList();
    await Share.shareXFiles(xFiles, text: title);
  }
  
  Future<void> shareText(String text, String title) async {
    await Share.share(text, subject: title);
  }
}
