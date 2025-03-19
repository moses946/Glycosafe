import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraProvider with ChangeNotifier {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription> _cameras = [];

  CameraProvider() {
    setController();
  }

  CameraController get cameraController {
    return _cameraController!;
  }

  Future<void> setController() async {
    _cameraController = await _initializeCamera();
  }

  Future<CameraController> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      PermissionStatus status = await Permission.camera.request();

      if (status.isGranted) {
        _cameraController =
            CameraController(_cameras.first, ResolutionPreset.high);
        _initializeControllerFuture = _cameraController?.initialize();
        await _initializeControllerFuture;

        return _cameraController!;
      } else {
        throw Exception("Camera Not initialized");
      }
    } on Exception catch (e) {
      throw e;
    }
  }
}
