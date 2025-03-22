import 'package:flutter/material.dart';
import '../viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Module")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(viewModel.message ?? "Presiona el botón"),
            SizedBox(height: 10),
            Text(
              viewModel.scannedData ?? "Esperando QR...",
            ), // ✅ Ahora se muestra el QR escaneado
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await viewModel.fetchScannedData();
              },
              child: const Text("Obtener datos de iOS"),
            ),
          ],
        ),
      ),
    );
  }
}
