import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  Barcode? _barcode;
  MobileScannerController mobileScannerController = MobileScannerController(
    facing: CameraFacing.front,
  );

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        '扫点什么吧',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
        Navigator.pop(context, _barcode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('条码扫描')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          RotatedBox(
            quarterTurns: 1,
            child: MobileScanner(
              controller: mobileScannerController,
              onDetect: _handleBarcode,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FacingChangeButton(
                    controller: mobileScannerController,
                  ),
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FacingChangeButton extends StatelessWidget {
  final MobileScannerController controller;

  const FacingChangeButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (BuildContext context, MobileScannerState state, Widget? child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        final int? availableCameras = state.availableCameras;

        if (availableCameras != null && availableCameras < 2) {
          return const SizedBox.shrink();
        }

        final Widget icon;

        switch (state.cameraDirection) {
          case CameraFacing.front:
            icon = const Icon(Icons.camera_front);
          case CameraFacing.back:
            icon = const Icon(Icons.camera_rear);
        }

        return IconButton(
          icon: icon,
          color: Colors.white,
          onPressed: () async {
            await controller.switchCamera();
          },
        );
      },
    );
  }
}
