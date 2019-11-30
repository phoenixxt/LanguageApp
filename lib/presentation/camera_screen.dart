import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';
import 'package:video_player/video_player.dart';

import 'image_recognizer_screen.dart';

class CameraExampleHome extends StatefulWidget {
	@override
	_CameraExampleHomeState createState() {
		return _CameraExampleHomeState();
	}
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
	switch (direction) {
		case CameraLensDirection.back:
			return Icons.camera_rear;
		case CameraLensDirection.front:
			return Icons.camera_front;
		case CameraLensDirection.external:
			return Icons.camera;
	}
	throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
		print('Error: $code\nError Message: $message');

class _CameraExampleHomeState extends State<CameraExampleHome>
		with WidgetsBindingObserver {
	CameraController controller;

	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addObserver(this);
		WidgetsFlutterBinding.ensureInitialized();
		loadAssets().then((_) => availableCameras())
				.then((cameras) => onNewCameraSelected(cameras.first))
				.then((_) => _recognize());
	}

	@override
	void dispose() {
		WidgetsBinding.instance.removeObserver(this);
		super.dispose();
	}

	@override
	void didChangeAppLifecycleState(AppLifecycleState state) {
		// App state changed before we got the chance to initialize.
		if (controller == null || !controller.value.isInitialized) {
			return;
		}
		if (state == AppLifecycleState.inactive) {
			controller?.dispose();
		} else if (state == AppLifecycleState.resumed) {
			if (controller != null) {
				onNewCameraSelected(controller.description);
			}
		}
	}

	final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			key: _scaffoldKey,
			appBar: AppBar(
				title: const Text('Camera example'),
			),
			body: Column(
				children: <Widget>[
					Expanded(
						child: Container(
							child: Padding(
								padding: const EdgeInsets.all(1.0),
								child: Center(
									child: _cameraPreviewWidget(),
								),
							),
							decoration: BoxDecoration(
								color: Colors.black,
								border: Border.all(
									color: controller != null && controller.value.isRecordingVideo
											? Colors.redAccent
											: Colors.grey,
									width: 3.0,
								),
							),
						),
					),
					_captureControlRowWidget(),
				],
			),
		);
	}

	bool isDetecting = false;

	_recognize() {
		controller.startImageStream((image) {
			if (!isDetecting) {
				isDetecting = true;

				int startTime = new DateTime.now().millisecondsSinceEpoch;

				Tflite.runModelOnFrame(
					bytesList: image.planes.map((plane) {
						return plane.bytes;
					}).toList(),
					imageHeight: image.height,
					imageWidth: image.width,
					imageMean: 127.5,   // defaults to 127.5
					imageStd: 127.5,    // defaults to 127.5
					rotation: 90,       // defaults to 90, Android only
					numResults: 2,      // defaults to 5
					threshold: 0.2,
				).then((recognitions) {
					int endTime = new DateTime.now().millisecondsSinceEpoch;
					print("Detection took ${endTime - startTime}");
					print(recognitions);
					isDetecting = false;
				});
			}
		});
	}

	Widget _cameraPreviewWidget() {
		if (controller == null || !controller.value.isInitialized) {
			return const Text(
				'Tap a camera',
				style: TextStyle(
					color: Colors.white,
					fontSize: 24.0,
					fontWeight: FontWeight.w900,
				),
			);
		} else {
			return AspectRatio(
				aspectRatio: controller.value.aspectRatio,
				child: CameraPreview(controller),
			);
		}
	}

	/// Display the control bar with buttons to take pictures and record videos.
	Widget _captureControlRowWidget() {
		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceEvenly,
			mainAxisSize: MainAxisSize.max,
			children: <Widget>[
				IconButton(
					icon: const Icon(Icons.camera_alt),
					color: Colors.blue,
					onPressed: controller != null &&
							controller.value.isInitialized &&
							!controller.value.isRecordingVideo
							? onTakePictureButtonPressed
							: null,
				),
			],
		);
	}

	String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

	void showInSnackBar(String message) {
		_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
	}

	void onNewCameraSelected(CameraDescription cameraDescription) async {
		if (controller != null) {
			await controller.dispose();
		}
		controller = CameraController(
			cameraDescription,
			ResolutionPreset.medium,
			enableAudio: false,
		);

		// If the controller is updated then update the UI.
		controller.addListener(() {
			if (mounted) setState(() {});
			if (controller.value.hasError) {
				showInSnackBar('Camera error ${controller.value.errorDescription}');
			}
		});

		try {
			await controller.initialize();
		} on CameraException catch (e) {
			_showCameraException(e);
		}

		if (mounted) {
			setState(() {});
		}
	}

	void onTakePictureButtonPressed() {
		takePicture().then((value) => {});
	}

	Future<String> takePicture() async {
		if (!controller.value.isInitialized) {
			showInSnackBar('Error: select a camera first.');
			return null;
		}
		final Directory extDir = await getApplicationDocumentsDirectory();
		final String dirPath = '${extDir.path}/Pictures/flutter_test';
		await Directory(dirPath).create(recursive: true);
		final String filePath = '$dirPath/${timestamp()}.jpg';

		if (controller.value.isTakingPicture) {
			// A capture is already pending, do nothing.
			return null;
		}

		try {
			await controller.takePicture(filePath);
		} on CameraException catch (e) {
			_showCameraException(e);
			return null;
		}
		return filePath;
	}

	void _showCameraException(CameraException e) {
		logError(e.code, e.description);
		showInSnackBar('Error: ${e.code}\n${e.description}');
	}
}

class CameraApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			home: CameraExampleHome(),
		);
	}
}
