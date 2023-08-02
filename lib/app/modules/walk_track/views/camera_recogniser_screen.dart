import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../controllers/camera_classifier.dart';
import '../views/camera_view.dart';
import 'package:get/get.dart';
import '../controllers/walk_track_controller.dart';

const _labelsFileName = 'assets/ai_model/labels.txt';
const _modelFileName = 'assets/ai_model/model.tflite';

class CameraRecogniser extends StatefulWidget {
  CameraRecogniser({Key? key});

  @override
  State<CameraRecogniser> createState() => _CameraRecogniserState();
}

enum _ResultStatus {
  notStarted,
  notFound,
  found,
}

class _CameraRecogniserState extends State<CameraRecogniser> {
  bool _isAnalyzing = false;
  final picker = ImagePicker();
  File? _selectedImageFile;
  // Result
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  String _plantLabel = ''; // Name of Error Message
  double _accuracy = 0.0;

  late Classifier _classifier;

  @override
  void initState() {
    super.initState();
    _loadClassifier();
  }

  Future<void> _loadClassifier() async {
    debugPrint(
      'Start loading of Classifier with '
      'labels at $_labelsFileName, '
      'model at $_modelFileName',
    );

    final classifier = await Classifier.loadWith(
      labelsFileName: _labelsFileName,
      modelFileName: _modelFileName,
    );
    _classifier = classifier!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: _buildTitle(),
          ),
          const SizedBox(height: 20),
          _buildPhotolView(),
          const SizedBox(height: 10),
          _buildResultView(),
          const Spacer(flex: 5),
          _buildPickPhotoButton(
            title: 'Take a photo',
            source: ImageSource.camera,
          ),
          _buildPickPhotoButton(
            title: 'Pick from gallery',
            source: ImageSource.gallery,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildPhotolView() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        CameraView(file: _selectedImageFile),
        _buildAnalyzingText(),
      ],
    );
  }

  Widget _buildAnalyzingText() {
    if (!_isAnalyzing) {
      return const SizedBox.shrink();
    }
    return const Text('Analyzing...');
  }

  Widget _buildTitle() {
    return const Text(
      '사진을 찍어 봉사를 인증해주세요!!',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xffFF5E5E),
        fontSize: 50,
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.none,
      ),
    );
  }

  Widget _buildPickPhotoButton({
    required ImageSource source,
    required String title,
  }) {
    return TextButton(
      onPressed: () => _onPickPhoto(source),
      child: Container(
        width: 300,
        height: 50,
        color: Color(0xffFF5E5E),
        child: Center(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white))),
      ),
    );
  }

  void _setAnalyzing(bool flag) {
    setState(() {
      _isAnalyzing = flag;
    });
  }

  void _onPickPhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) {
      return;
    }

    final imageFile = File(pickedFile.path);
    setState(() {
      _selectedImageFile = imageFile;
    });

    _analyzeImage(imageFile);
  }

  void _analyzeImage(File image) {
    _setAnalyzing(true);

    final imageInput = img.decodeImage(image.readAsBytesSync())!;

    final resultCategory = _classifier.predict(imageInput);

    final result = resultCategory.score >= 0.6
        ? _ResultStatus.found
        : _ResultStatus.notFound;
    final plantLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    _setAnalyzing(false);

    setState(() {
      _resultStatus = result;
      _plantLabel = plantLabel;
      _accuracy = accuracy;
    });
  }

  Widget _buildResultView() {
    var title = '';
    var _walkTrackController=WalkTrackController();
    var _targetWalk=_walkTrackController.targetWalk.name;
    if(_targetWalk=='도시락 배달 봉사')
      _targetWalk='dosirak';
    else if(_targetWalk=='유기견 산책')
      _targetWalk='dog';
    else
      _targetWalk='';
    if (_resultStatus == _ResultStatus.found&&_targetWalk==_plantLabel) {
      title = '인증에 성공했습니다!';
      Get.back();
    } else if (_resultStatus == _ResultStatus.notFound) {
      title = 'Fail to recognise';
    }
    else {
      title = '';
    }

    //
    // var accuracyLabel = '';
    // if (_resultStatus == _ResultStatus.found) {
    //   accuracyLabel = 'Accuracy: ${(_accuracy * 100).toStringAsFixed(2)}%';
    // }

    return SafeArea(
      child: Column(
        children: [
          Text(title,
              style: TextStyle(decoration: TextDecoration.none, fontSize: 18)),
          const SizedBox(height: 10) //, Text(accuracyLabel)
        ],
      ),
    );
  }
}
