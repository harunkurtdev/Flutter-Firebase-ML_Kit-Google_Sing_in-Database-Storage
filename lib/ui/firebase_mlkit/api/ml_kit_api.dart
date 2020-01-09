import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart'
    show kTransparentImage;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';


class ML_Kit_Api {
  final File imageFile;
  String result = '';
  String _mlResult = '<no result>';

  ML_Kit_Api({this.imageFile});

  Future<String> textOcr() async {
        String _text;
    
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(this.imageFile);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    final String text = visionText.text;
    _text=text;
    
    result += 'Detected ${visionText.blocks.length} text blocks.\n';
    for (TextBlock block in visionText.blocks) {
      final Rect boundingBox = block.boundingBox;
      final List<Offset> cornerPoints = block.cornerPoints; 
      final String text = block.text;//block block alır
      final List<RecognizedLanguage> languages = block.recognizedLanguages;//dili alır
      _text += block.text;//yazılarımızı text içerisine dolduruyoruz
    }
    return _text; 
  }

  Future<String> faceDetect() async {
    
    String result = '';
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(this.imageFile);
    final options = FaceDetectorOptions(
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
    );
    final FaceDetector faceDetector =
        FirebaseVision.instance.faceDetector(options);
    final List<Face> faces = await faceDetector.processImage(visionImage);
    result += 'Detected ${faces.length} faces.\n';
    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;
      // Head is rotated to the right rotY degrees
      final double rotY = face.headEulerAngleY;
      // Head is tilted sideways rotZ degrees
      final double rotZ = face.headEulerAngleZ;
      result += '\n# Face:\n '
          'bbox=$boundingBox\n '
          'rotY=$rotY\n '
          'rotZ=$rotZ\n ';
      // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
      // eyes, cheeks, and nose available):
      final FaceLandmark leftEar = face.getLandmark(FaceLandmarkType.leftEar);
      if (leftEar != null) {
        final Offset leftEarPos = leftEar.position;
        result += 'leftEarPos=$leftEarPos\n ';
      }
      // If classification was enabled with FaceDetectorOptions:
      if (face.smilingProbability != null) {
        final double smileProb = face.smilingProbability;
        result += 'smileProb=${smileProb.toStringAsFixed(3)}\n ';
      }
      // If face tracking was enabled with FaceDetectorOptions:
      if (face.trackingId != null) {
        final int id = face.trackingId;
        result += 'id=$id\n ';
      }
    }
    
    return result;
    
  }


}