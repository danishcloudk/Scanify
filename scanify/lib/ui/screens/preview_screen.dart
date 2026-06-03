import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/scan_model.dart';
import '../../controllers/app_controller.dart';
import '../widgets/export_bottom_sheet.dart';

class PreviewScreen extends StatefulWidget {
  final ScanModel? scan;
  final List<String>? tempImagePaths;

  const PreviewScreen({super.key, this.scan, this.tempImagePaths})
      : assert(scan != null || tempImagePaths != null);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _textController;
  bool _isExtracting = false;
  String? _extractedText;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _textController = TextEditingController();

    if (widget.scan != null) {
      _isSaved = true;
      _extractedText = widget.scan!.extractedText;
      _textController.text = _extractedText ?? '';
    } else {
      _extractTextFromTemp();
    }
  }

  Future<void> _extractTextFromTemp() async {
    setState(() => _isExtracting = true);
    final controller = Provider.of<AppController>(context, listen: false);
    final buffer = StringBuffer();
    for (String path in widget.tempImagePaths!) {
      final text = await controller.extractText(path);
      if (text != null && text.trim().isNotEmpty) {
        buffer.writeln(text.trim());
        if (widget.tempImagePaths!.length > 1) {
          buffer.writeln('\n---\n');
        }
      }
    }
    final fullText = buffer.toString().trim();
    setState(() {
      _extractedText = fullText.isEmpty ? null : fullText;
      _textController.text = _extractedText ?? '';
      _isExtracting = false;
    });
  }

  void _handleSave() async {
    if (_isSaved) return;
    
    final controller = Provider.of<AppController>(context, listen: false);
    await controller.saveScanResult(widget.tempImagePaths!, _textController.text);
    setState(() => _isSaved = true);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Scan saved to history')),
      );
    }
  }

  void _showExportOptions() {
    if (!_isSaved && widget.tempImagePaths != null) {
      _handleSave();
    }
    
    final imagePaths = widget.scan?.imagePaths ?? widget.tempImagePaths!;
    final text = _textController.text;
    final filename = widget.scan?.title ?? 'Scan_${DateTime.now().millisecondsSinceEpoch}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExportBottomSheet(
        imagePaths: imagePaths,
        extractedText: text,
        defaultFilename: filename,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagePaths = widget.scan?.imagePaths ?? widget.tempImagePaths!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Preview', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (!_isSaved && widget.tempImagePaths != null) {
               _handleSave();
            }
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: PageView.builder(
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                    child: Image.file(
                      File(imagePaths[index]),
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
          
          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF00BFA5),
            labelColor: const Color(0xFF00BFA5),
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Image'),
              Tab(text: 'Extracted Text'),
            ],
          ),
          
          Expanded(
            flex: 4,
            child: TabBarView(
              controller: _tabController,
              children: [
                const Center(
                  child: Text(
                    'Pinch to zoom image above',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                
                Container(
                  color: const Color(0xFF16213E),
                  padding: const EdgeInsets.all(16),
                  child: _isExtracting
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFF00BFA5)))
                      : TextField(
                          controller: _textController,
                          maxLines: null,
                          expands: true,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'No text extracted',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                ),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.copy,
                  label: 'Copy',
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: _textController.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Text copied to clipboard')),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.select_all,
                  label: 'Select All',
                  onTap: () {
                    _tabController.animateTo(1);
                  },
                ),
                _ActionButton(
                  icon: Icons.edit,
                  label: 'Edit',
                  onTap: () {
                    _tabController.animateTo(1);
                  },
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _showExportOptions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFA5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: const Text(
                  'Export',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF00BFA5)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
