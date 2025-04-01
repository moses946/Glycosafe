// ignore_for_file: use_build_context_synchronously
import 'dart:math' as math;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:glycosafe_v1/components/bottomnav.dart';
import 'package:glycosafe_v1/components/endpoints.dart';
import 'package:glycosafe_v1/components/errorarlert.dart';
import 'package:glycosafe_v1/components/labeledImage.dart';
import 'package:glycosafe_v1/components/token_service.dart';
import 'package:glycosafe_v1/components/tutorial.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// import 'package:provider/provider.dart';

class CameraPage extends StatefulWidget {
  final CameraController cameraController;

  CameraPage({super.key, required this.cameraController});
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  File? _image;
  Uint8List? segmentedImageBytes;
  Uint8List? labeledImageBytes;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isVisible = false;
  List? foods;
  Map? rankings;
  List? recommendations;
  Map? status;
  Map? total_nutritional_facts;
  bool _flashOn = false;
  bool _isCameraInitialized = false;

  void _switchFlash() async {
    setState(() {
      _flashOn = !_flashOn;
    });
    if (_controller!.value.isInitialized) {
      print("controller initialized");
      print(_controller!.value.flashMode);

      if (_flashOn) {
        print("turn on torch");
        await _controller!.setFlashMode(FlashMode.torch);
      } else {
        print("turn off torch");
        await _controller!.setFlashMode(FlashMode.off);
      }
    }
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.cameraController;
    // _initializeCameras();
  }

  /// Function that initializes the camera on page load to show the camerapreview
  Future<void> _initializeCamera(CameraDescription camera) async {
    // Request camera permission
    try {
      var status = await Permission.camera.request();
      if (status.isGranted) {
        _controller = CameraController(
          camera,
          ResolutionPreset.high,
        );
        _initializeControllerFuture = _controller?.initialize();
        await _initializeControllerFuture;
        setState(() {
          _isCameraInitialized = true;
        });
      } else {
        print('Camera permission not granted');
      }
    } on Exception catch (e) {
      print("Error in initializing camera");
      print("$e");
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (!_isCameraInitialized) {
  //     _initializeCameras();
  //   }
  // }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _initializeCameras() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        await _initializeCamera(_cameras.first);
      }
    } catch (e) {
      print("Error in fetching cameras: $e");
    }
  }

  /// Function handles taking a picture and is called by clicking the take picture widget
  /// It initializes the CameraController and saves the captured image to the variable _image
  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final XFile? picture = await _controller?.takePicture();
      if (picture != null) {
        setState(() {
          _image = File(picture.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(ErrorSnackBar(content: "Error Taking Picture"));
    }
  }

  /// This function sends the image captured to an api view
  /// It has a custom loading toast EasyLoading that will also show status of upload i.e Success or Faliure
  /// First Get tokens needed for authentication and parse them,
  /// Add image to request body and send the request
  /// If request is successful, the api returns a segmented image that is saved to the variable segmentedImageBytes and _isImageOkay is called
  Future<void> _sendImageToApi(BuildContext context) async {
    if (_image != null) {
      EasyLoading.show(status: "Sending...");
      try {
        var tokens = await TokenService().getTokens();
        var accessToken = Jwt.parseJwt(tokens[0]!);
        var request =
            http.MultipartRequest('POST', Uri.parse(Endpoints().upload));
        request.files
            .add(await http.MultipartFile.fromPath('image', _image!.path));
        request.headers["Authorization"] = "Bearer ${tokens[0]!}";
        request.fields.addAll({"user_id": accessToken["user_id"].toString()});
        var response = await request.send();

        if (response.statusCode == 200 || response.statusCode == 201) {
          EasyLoading.dismiss();
          EasyLoading.showSuccess("Successfully Segmented");

          // Check if the response contains an image
          if (response.headers['content-type'] == 'image/jpeg' ||
              response.headers['content-type'] == 'image/jpg' ||
              response.headers['content-type'] == 'image/png') {
            ByteStream newImageStream = response.stream;
            Uint8List bytes = await newImageStream.toBytes();

            setState(() {
              segmentedImageBytes = bytes;
            });

            // Call _isImageOkay after 30 seconds
            Future.delayed(const Duration(milliseconds: 2000), () {
              _isImageOkay(context);
            });
          } else {
            EasyLoading.dismiss();
            EasyLoading.showError("Error");
            _resetImage();
            ScaffoldMessenger.of(context).showSnackBar(
                ErrorSnackBar(content: "API did not return an image"));
          }
        } else {
          EasyLoading.dismiss();
          EasyLoading.showError("Error");
          print("Error api!!!!!");
          _resetImage();
          ScaffoldMessenger.of(context)
              .showSnackBar(ErrorSnackBar(content: "Internal Server Error"));
        }
      } on http.ClientException {
        EasyLoading.dismiss();
        EasyLoading.showError("Error");
        ScaffoldMessenger.of(context)
            .showSnackBar(ErrorSnackBar(content: "Network error"));
      } on IOException {
        EasyLoading.dismiss();
        EasyLoading.showError("Error");
        ScaffoldMessenger.of(context)
            .showSnackBar(ErrorSnackBar(content: "IO error"));
      } catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showError("Error");
        print("This is the error");
        ScaffoldMessenger.of(context)
            .showSnackBar(ErrorSnackBar(content: "Unknown error"));
      }
    } else {
      print('No image selected');
    }
  }

  /// Resets the _image variable to null to return to camerapreview
  Future<void> _resetImage() async {
    setState(() {
      segmentedImageBytes = null;
      _image = null;
      _isVisible = false;
    });
  }

  Future<void> _imagePicker() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } on Exception {
      // TODO
      ScaffoldMessenger.of(context)
          .showSnackBar(ErrorSnackBar(content: "Error opening gallery"));
    }
  }

  /// Function that sends confirmation to server that segments are okay allowing for labeling and recommendation
  Future<void> _awaitLabeledImage() async {
    try {
      EasyLoading.show(status: "Processing Meal");
      var tokens = await TokenService().getTokens();
      var accessToken = Jwt.parseJwt(tokens[0]!);
      final request = http.Request("post", Uri.parse(Endpoints().confirm));

      request.headers["Content-Type"] = 'application/json; charset=UTF-8';
      request.body = jsonEncode(
          {'confirm': true, 'user_id': accessToken["user_id"].toString()});

      var streamedresponse = await request.send();
      var response = await http.Response.fromStream(streamedresponse);

      if (streamedresponse.statusCode >= 200 ||
          streamedresponse.statusCode < 300) {
        ///Get recommendations as Json

        var json = jsonDecode(response.body);
        setState(() {
          foods = json["detail"]["foods"];
          rankings = json["detail"]['rankings'];
          recommendations = json["detail"]['recommendation'];
          status = json["detail"]['status'];
          total_nutritional_facts = json["detail"]['total_nutritional_facts'];
        });

        EasyLoading.dismiss();
        EasyLoading.showSuccess("Meal Analyzed");
        setState(() {
          //_isVisible toggles pages from the takePicture page to recommendations page
          _isVisible = true;
        });
      }
    } on Exception {
      EasyLoading.dismiss();
      EasyLoading.showError("Error");
      ScaffoldMessenger.of(context)
          .showSnackBar(ErrorSnackBar(content: "Internal Server Error"));
    }
  }

  /// Functions that tells the server to discard the segmented image as it is not okay
  Future<void> _discardImage() async {
    try {
      var tokens = await TokenService().getTokens();
      var accessToken = Jwt.parseJwt(tokens[0]!);
      final request = http.Request("post", Uri.parse(Endpoints().confirm));

      request.headers["Content-Type"] = 'application/json; charset=UTF-8';
      request.body = jsonEncode(
          {'confirm': false, 'user_id': accessToken["user_id"].toString()});

      var response = await request.send();

      if (response.statusCode >= 200 || response.statusCode < 300) {
        _resetImage();
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(ErrorSnackBar(content: "Internal Server Error"));
      _resetImage();
    }
  }

  /// Dialogue box that asks if the segmented food is okay
  Future<void> _isImageOkay(BuildContext context) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) => AlertDialog.adaptive(
              backgroundColor: Colors.black,
              title: const Text(
                "Image Segments Confirmation",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Are the image segments okay?",
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _awaitLabeledImage();
                    },
                    child: const Text("Yes",
                        style: TextStyle(color: Colors.orange))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _discardImage();
                    },
                    child: const Text('Take another photo',
                        style: TextStyle(color: Colors.orange))),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!_controller!.value.isInitialized || _controller == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _camera(context),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _cameraActionButtons(BuildContext context) {
    return _isVisible
        ? Container()
        : _image != null
            ?
            // Row containing send image and reset buttons
            Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                        splashColor: const Color.fromARGB(110, 0, 0, 0),
                        radius: 100,
                        borderRadius: BorderRadius.circular(30),
                        onTap: _resetImage,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          constraints: BoxConstraints(maxWidth: 50),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: const Icon(
                            Icons.undo,
                            color: Color.fromARGB(255, 255, 132, 0),
                            size: 30.0,
                          ),
                        )),
                    InkWell(
                        radius: 100,
                        splashColor: const Color.fromARGB(110, 0, 0, 0),
                        borderRadius: BorderRadius.circular(30),
                        onTap: () async {
                          await _sendImageToApi(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          constraints: BoxConstraints(maxWidth: 50),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: const Icon(
                            Icons.ios_share,
                            color: Color.fromARGB(255, 255, 132, 0),
                            size: 30.0,
                          ),
                        ))
                  ],
                ),
              )
            : _cameraCapture();
  }

  Widget _camera(contex) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: MediaQuery.of(context).size.height,
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: Container(
                child: _isVisible
                    ? LabeledImageWidget(
                        status: status!,
                        total_nutritional_facts: total_nutritional_facts!,
                        rankings: rankings!,
                        recommendations: recommendations!,
                        foods: foods!,
                        image: _image!,
                        aspectratio: _controller!.value.aspectRatio,
                        width: MediaQuery.of(context).size.width)
                    : segmentedImageBytes != null
                        ? Image.memory(
                            segmentedImageBytes!,
                            fit: BoxFit.cover,
                          )
                        : _image != null
                            ? Image.file(
                                fit: BoxFit.cover,
                                File(_image!.path),
                              )
                            : _cameraPreview(contex),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 200, // Height for the camera buttons area
            padding:
                const EdgeInsets.only(bottom: 65), // Offset from the bottom
            child: _cameraActionButtons(context),
          ),
        ),
        const Align(alignment: Alignment.bottomCenter, child: BottomNav())
      ],
    );
  }

  // Widget _imageDisplay() {
  //   var width = MediaQuery.of(context).size.width;
  //   return
  // }
  Widget _cameraPreview(contex) {
    return Stack(
      children: [
        Positioned.fill(child: CameraPreview(_controller!)),
        Positioned.fill(
          child: CustomPaint(
            painter: RoundedCornerBoundingBoxPainter(),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 200, // Height for the camera buttons area
            padding:
                const EdgeInsets.only(bottom: 65), // Offset from the bottom
            child: _cameraActionButtons(context),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: InkWell(
            child: Container(
              margin: const EdgeInsets.all(40.0),
              padding: EdgeInsets.all(5),
              constraints: BoxConstraints(maxWidth: 50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.4),
              ),
              child: Icon(
                size: 30,
                Icons.info,
                color: Color.fromARGB(255, 181, 181, 181),
              ),
            ),
            onTap: () {
              showBottomSheet(
                  showDragHandle: true,
                  enableDrag: true,
                  backgroundColor: Colors.black,
                  context: contex,
                  builder: (contex) => Tutorials());
            },
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
              child: Container(
                margin: const EdgeInsets.all(40.0),
                padding: EdgeInsets.all(5),
                constraints: BoxConstraints(maxWidth: 50),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.4),
                ),
                child: Icon(
                  size: 30,
                  _flashOn ? Icons.flash_on_outlined : Icons.flash_off_outlined,
                  color: Color.fromARGB(255, 181, 181, 181),
                ),
              ),
              onTap: _switchFlash),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: _image == null
              ? InkWell(
                  onTap: _imagePicker,
                  child: Container(
                    margin: const EdgeInsets.only(left: 40.0, bottom: 110),
                    padding: EdgeInsets.all(5),
                    constraints: BoxConstraints(maxWidth: 70),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.4),
                    ), // Offset from the bottom

                    child: Icon(
                      Icons.photo,
                      color: Color.fromARGB(255, 181, 181, 181),
                      size: 35.0,
                    ),
                  ),
                )
              : Container(),
        ),
        const Align(alignment: Alignment.bottomCenter, child: BottomNav())
      ],
    );
  }

  Widget _cameraCapture() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          _takePicture();
        },
        child: ClipOval(
          child: Container(
            // margin:
            //     EdgeInsets.only(right: (MediaQuery.of(context).size.width / 2)),
            width: 70.0, // Adjust the size as needed
            height: 70.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white54,
              border: Border.all(
                  color: Colors.white, width: 4.0), // Outer circle border
            ),
            // Inner circle border
          ),
        ),
      ),
    );
  }
}

class RoundedCornerBoundingBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.15,
      size.width * 0.8,
      size.height * 0.5,
    );

    const cornerRadius = 25.0;

    // Draw top-left corner
    final topLeftArc = Rect.fromCircle(
        center: rect.topLeft + const Offset(cornerRadius, cornerRadius),
        radius: cornerRadius);
    canvas.drawArc(topLeftArc, math.pi, math.pi / 2, false, paint);

    // Draw top-right corner
    final topRightArc = Rect.fromCircle(
        center: rect.topRight + const Offset(-cornerRadius, cornerRadius),
        radius: cornerRadius);
    canvas.drawArc(topRightArc, -math.pi / 2, math.pi / 2, false, paint);

    // Draw bottom-left corner
    final bottomLeftArc = Rect.fromCircle(
        center: rect.bottomLeft + const Offset(cornerRadius, -cornerRadius),
        radius: cornerRadius);
    canvas.drawArc(bottomLeftArc, math.pi, -math.pi / 2, false, paint);

    // Draw bottom-right corner
    final bottomRightArc = Rect.fromCircle(
        center: rect.bottomRight + const Offset(-cornerRadius, -cornerRadius),
        radius: cornerRadius);
    canvas.drawArc(bottomRightArc, 0, math.pi / 2, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
