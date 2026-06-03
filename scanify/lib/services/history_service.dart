import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_model.dart';

class HistoryService {
  static const String _key = 'scan_history';

  Future<List<ScanModel>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_key);
    if (jsonList == null) return [];
    
    return jsonList.map((jsonStr) => ScanModel.fromJson(jsonStr)).toList();
  }

  Future<void> saveScan(ScanModel scan) async {
    final prefs = await SharedPreferences.getInstance();
    final List<ScanModel> history = await getHistory();
    history.add(scan);
    
    final List<String> jsonList = history.map((e) => e.toJson()).toList();
    await prefs.setStringList(_key, jsonList);
  }

  Future<void> deleteScan(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<ScanModel> history = await getHistory();
    history.removeWhere((scan) => scan.id == id);
    
    final List<String> jsonList = history.map((e) => e.toJson()).toList();
    await prefs.setStringList(_key, jsonList);
  }
  
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
