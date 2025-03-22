import 'package:flutter/services.dart';

class MethodChannelService {
  static const MethodChannel _platform = MethodChannel('seek.qrapp/channel');

  Future<Map<String, dynamic>?> getScannedData() async {
    try {
      final Map<dynamic, dynamic>? result = await _platform.invokeMapMethod(
        "getScannedData",
      );
      print("📌 Datos recibidos desde iOS: $result");
      return result
          ?.cast<String, dynamic>(); // ✅ Convertir a un Map<String, dynamic>
    } on PlatformException catch (e) {
      print("⚠️ Error en MethodChannel: ${e.message}");
      return null;
    }
  }
}
