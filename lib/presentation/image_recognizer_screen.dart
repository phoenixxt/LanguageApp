import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';


class ImageRecognizerScreen extends StatefulWidget {

	@override
	State createState() {
		return _ImageRecognizerState();
	}
}

class _ImageRecognizerState extends State<ImageRecognizerScreen> {

	bool _isLoading = true;
	File _image;
	String _type = "";

	@override
	void initState() {
		super.initState();
		loadAssets().then((value) {
			setState(() => {
				_isLoading = false
			});
		});
	}

	@override
	Widget build(BuildContext context) {
		if (_isLoading) {
			return Center(
					child: CircularProgressIndicator()
			);
		} else {
			return Column(
				children: <Widget>[
					Container(height: 200, width: 200,),
					_image == null ? GestureDetector(child: Text("Select image"), onTap: getImage) : Image.file(_image),
					Text(_type)
				],
			);
		}
	}

	Future getImage() async {
		var image = await ImagePicker.pickImage(source: ImageSource.gallery);
		var recognitions = await Tflite.runModelOnImage(
				path: image.path,
				imageMean: 0.0,
				imageStd: 255.0,
				numResults: 2,
				threshold: 0.2,
				asynch: true
		);
		print(recognitions);
		setState(() {
			_image = image;
			_type = recognitions.first.toString();
		});
	}
}

Future loadAssets() async {
	return await Tflite.loadModel(
			model: "assets/mobilenet_v1_1.0_224.tflite",
			labels: "assets/mobilenet_v1_1.0_224.txt",
			numThreads: 1 // defaults to 1
	);
}