import '../core/method_channel_service.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final MethodChannelService _methodChannelService = MethodChannelService();
  String? message;
  String? scannedData;

  Future<void> fetchScannedData() async {
    final data = await _methodChannelService.getScannedData();
    if (data != null) {
      message = data["message"];
      scannedData = data["scannedData"];
      print(
        "📌 Actualizando estado en HomeViewModel: $message | QR: $scannedData",
      );
      notifyListeners();
    }
  }
}
