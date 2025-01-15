import 'package:dongjue_application/helpers/context.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

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

  final OverlayModel overlayModel = OverlayModel();

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

  bool poped = false;

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      _barcode = barcodes.barcodes.firstOrNull;
      if (!poped) {
        poped = true;
        Navigator.of(context).pop(_barcode);
      }
    }
  }

  void createScanedBoxByScan(BarcodeCapture barcodes) {
    if (mounted) {
      if(barcodes.barcodes.isEmpty){
        showSnackBar(context, '没有扫描到任何内容');
        return;
      }
      overlayModel.addBarCodes(barcodes.barcodes);
      mobileScannerController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => overlayModel),
      ],
      child: Scaffold(
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
            // //覆盖层(Overlay)
            // Consumer<OverlayModel>(
            //   builder: (context, model, child) {
            //     return Stack(
            //       children: model._barCodes.map((barCode) {
            //         return Positioned(
            //           left: barCode.corners[0].dx,
            //           top: barCode.corners[0].dy,
            //           width: barCode.corners[2].dx - barCode.corners[0].dx,
            //           height: barCode.corners[2].dy - barCode.corners[0].dy,
            //           child: GestureDetector(
            //             onTap: () {
            //               // 处理点击事件
            //             },
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 border: Border.all(color: Colors.green, width: 2),
            //               ),
            //             ),
            //           ),
            //         );
            //       }).toList(),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class OverlayModel extends ChangeNotifier {
  final List<Barcode> _barCodes = [];

  void addBarCode(Barcode barCode) {
    _barCodes.add(barCode);
    notifyListeners();
  }

  void addBarCodes(List<Barcode> barCodes) {
    _barCodes.addAll(barCodes);
    notifyListeners();
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
