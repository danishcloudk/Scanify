import 'package:flutter/foundation.dart';
import '../models/scan_model.dart';
import '../services/scanner_service.dart';
import '../services/ocr_service.dart';
import '../services/weather_service.dart';
import '../services/history_service.dart';
import '../services/permissions_service.dart';

class AppController extends ChangeNotifier {
  final _scannerService = ScannerService();
  final _ocrService = OcrService();
  final _weatherService = WeatherService();
  final _historyService = HistoryService();
  final _permissionsService = PermissionsService();

  List<ScanModel> _scans = [];
  List<ScanModel> get scans => _scans;

  Map<String, dynamic>? _weatherData;
  Map<String, dynamic>? get weatherData => _weatherData;
  bool _isLoadingWeather = false;
  bool get isLoadingWeather => _isLoadingWeather;

  AppController() {
    _initWeather();
    _loadHistory();
  }

  Future<void> _initWeather() async {
    _isLoadingWeather = true;
    notifyListeners();

    bool locationGranted = await _permissionsService.requestLocationPermission();
    if (locationGranted) {
      _weatherData = await _weatherService.fetchWeather();
    }
    
    _isLoadingWeather = false;
    notifyListeners();
  }
  
  String getWeatherConditionStr() {
    if (_weatherData == null) return 'Unknown';
    return _weatherService.getWeatherCondition(_weatherData!['weathercode']);
  }

  Future<void> _loadHistory() async {
    _scans = await _historyService.getHistory();
    // Sort descending by timestamp
    _scans.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  Future<List<String>?> scanDocument({bool useGallery = false}) async {
    bool cameraGranted = await _permissionsService.requestCameraPermission();
    if (!cameraGranted) return null;
    
    return await _scannerService.scanDocument(useGallery: useGallery);
  }

  Future<String?> extractText(String imagePath) async {
    return await _ocrService.extractText(imagePath);
  }

  Future<void> saveScanResult(List<String> imagePaths, String? extractedText) async {
    final newScan = ScanModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Scan ${DateTime.now().toIso8601String().split('T').first}',
      imagePaths: imagePaths,
      extractedText: extractedText,
      timestamp: DateTime.now(),
    );
    
    await _historyService.saveScan(newScan);
    await _loadHistory();
  }

  Future<void> deleteScan(String id) async {
    await _historyService.deleteScan(id);
    await _loadHistory();
  }
  
  Future<void> clearAllScans() async {
    await _historyService.clearHistory();
    await _loadHistory();
  }

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }
}
