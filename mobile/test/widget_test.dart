import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:renodesign/core/theme/app_theme.dart';
import 'package:renodesign/features/catalog/models/style_model.dart';
import 'package:renodesign/features/transformation/models/transformation_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RenoDesign Unit & Domain Tests', () {
    test('StyleModel parses JSON correctly', () {
      final json = {
        'id': 1,
        'name': 'Modern Luxury',
        'description': 'High-end interior with marble and bronze accents.',
        'image': 'https://example.com/style.jpg',
        'promptInstructions': 'luxury modern interior',
        'active': true,
      };

      final style = StyleModel.fromJson(json);
      expect(style.id, 1);
      expect(style.name, 'Modern Luxury');
      expect(style.active, true);
    });

    test('TransformationModel parses JSON and calculates status correctly', () {
      final json = {
        'id': 42,
        'userId': 1,
        'originalImageUrl': 'https://example.com/original.jpg',
        'generatedImageUrl': 'https://example.com/generated.jpg',
        'roomType': 'Living Room',
        'style': 'Scandinavian',
        'status': 'COMPLETED',
      };

      final transformation = TransformationModel.fromJson(json);
      expect(transformation.id, 42);
      expect(transformation.roomType, 'Living Room');
      expect(transformation.isCompleted, true);
      expect(transformation.isProcessing, false);
      expect(transformation.isFailed, false);
    });

    test('AppTheme darkTheme builds without errors', () {
      final theme = AppTheme.darkTheme;
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, isNotNull);
      expect(theme.primaryColor, isNotNull);
    });
  });
}
