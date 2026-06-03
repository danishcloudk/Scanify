import 'package:flutter/material.dart';
import '../../services/save_service.dart';
import '../../services/sharing_service.dart';

class ExportBottomSheet extends StatefulWidget {
  final List<String> imagePaths;
  final String? extractedText;
  final String defaultFilename;

  const ExportBottomSheet({
    super.key,
    required this.imagePaths,
    this.extractedText,
    required this.defaultFilename,
  });

  @override
  State<ExportBottomSheet> createState() => _ExportBottomSheetState();
}

class _ExportBottomSheetState extends State<ExportBottomSheet> {
  String _selectedFormat = 'PDF'; // PDF, JPEG, TXT
  final _saveService = SaveService();
  final _sharingService = SharingService();
  bool _isProcessing = false;

  void _handleSave() async {
    setState(() => _isProcessing = true);
    String? path;
    List<String>? paths;
    if (_selectedFormat == 'PDF') {
      path = await _saveService.saveAsPdf(widget.imagePaths, widget.defaultFilename);
    } else if (_selectedFormat == 'JPEG') {
      paths = await _saveService.saveAsJpeg(widget.imagePaths, widget.defaultFilename);
    } else if (_selectedFormat == 'TXT') {
      if (widget.extractedText != null && widget.extractedText!.isNotEmpty) {
        path = await _saveService.saveAsTxt(widget.extractedText!, widget.defaultFilename);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No text to save')),
          );
        }
      }
    }
    setState(() => _isProcessing = false);
    
    if (mounted) {
      if (path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved to $path')),
        );
      } else if (paths != null && paths.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved ${paths.length} image(s) to Downloads')),
        );
      }
      if (path != null || (paths != null && paths.isNotEmpty)) {
        Navigator.pop(context);
      }
    }
  }

  void _handleShare() async {
    setState(() => _isProcessing = true);
    String? path;
    List<String>? paths;
    if (_selectedFormat == 'PDF') {
      path = await _saveService.saveAsPdf(widget.imagePaths, widget.defaultFilename);
    } else if (_selectedFormat == 'JPEG') {
      paths = await _saveService.saveAsJpeg(widget.imagePaths, widget.defaultFilename);
    } else if (_selectedFormat == 'TXT') {
      if (widget.extractedText != null && widget.extractedText!.isNotEmpty) {
        path = await _saveService.saveAsTxt(widget.extractedText!, widget.defaultFilename);
      }
    }
    
    if (path != null) {
      await _sharingService.shareFile(path, widget.defaultFilename);
    } else if (paths != null && paths.isNotEmpty) {
      await _sharingService.shareFiles(paths, widget.defaultFilename);
    }
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF16213E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Export Options',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
            title: const Text('Save as PDF'),
            trailing: _selectedFormat == 'PDF'
                ? const Icon(Icons.check_circle, color: Color(0xFF00BFA5))
                : null,
            onTap: () => setState(() => _selectedFormat = 'PDF'),
          ),
          ListTile(
            leading: const Icon(Icons.image, color: Colors.blue),
            title: const Text('Save as JPEG'),
            trailing: _selectedFormat == 'JPEG'
                ? const Icon(Icons.check_circle, color: Color(0xFF00BFA5))
                : null,
            onTap: () => setState(() => _selectedFormat = 'JPEG'),
          ),
          ListTile(
            leading: const Icon(Icons.description, color: Colors.green),
            title: const Text('Save as .txt'),
            enabled: widget.extractedText != null && widget.extractedText!.isNotEmpty,
            trailing: _selectedFormat == 'TXT'
                ? const Icon(Icons.check_circle, color: Color(0xFF00BFA5))
                : null,
            onTap: () {
              if (widget.extractedText != null && widget.extractedText!.isNotEmpty) {
                setState(() => _selectedFormat = 'TXT');
              }
            },
          ),
          const Divider(color: Colors.white24, height: 32),
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: Color(0xFF00BFA5)),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _handleSave,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: const Text('Save to Downloads'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleShare,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BFA5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: const Text('Share Document'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
