import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client_provider.dart';
import '../data/transformation_repository.dart';
import '../models/transformation_model.dart';

final transformationRepositoryProvider = Provider<TransformationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TransformationRepository(apiClient);
});

class TransformationWorkflowState {
  final File? selectedImage;
  final String roomType;
  final String? selectedStyle;
  final String? selectedWallMaterial;
  final String? selectedFloorMaterial;
  final String lighting;
  final String customPrompt;

  // Execution state
  final bool isSubmitting;
  final double uploadProgress;
  final TransformationModel? currentTransformation;
  final String statusMessage;
  final String? error;

  const TransformationWorkflowState({
    this.selectedImage,
    this.roomType = 'Living Room',
    this.selectedStyle,
    this.selectedWallMaterial,
    this.selectedFloorMaterial,
    this.lighting = 'Natural Sunlight & Warm Concealed LED',
    this.customPrompt = '',
    this.isSubmitting = false,
    this.uploadProgress = 0.0,
    this.currentTransformation,
    this.statusMessage = '',
    this.error,
  });

  TransformationWorkflowState copyWith({
    File? selectedImage,
    bool clearSelectedImage = false,
    String? roomType,
    String? selectedStyle,
    String? selectedWallMaterial,
    String? selectedFloorMaterial,
    String? lighting,
    String? customPrompt,
    bool? isSubmitting,
    double? uploadProgress,
    TransformationModel? currentTransformation,
    String? statusMessage,
    String? error,
    bool clearError = false,
  }) {
    return TransformationWorkflowState(
      selectedImage: clearSelectedImage ? null : (selectedImage ?? this.selectedImage),
      roomType: roomType ?? this.roomType,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      selectedWallMaterial: selectedWallMaterial ?? this.selectedWallMaterial,
      selectedFloorMaterial: selectedFloorMaterial ?? this.selectedFloorMaterial,
      lighting: lighting ?? this.lighting,
      customPrompt: customPrompt ?? this.customPrompt,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      currentTransformation: currentTransformation ?? this.currentTransformation,
      statusMessage: statusMessage ?? this.statusMessage,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class TransformationNotifier extends StateNotifier<TransformationWorkflowState> {
  final TransformationRepository _repository;
  Timer? _pollingTimer;

  TransformationNotifier(this._repository)
      : super(const TransformationWorkflowState());

  void setImage(File file) {
    state = state.copyWith(selectedImage: file, error: null);
  }

  void setRoomType(String roomType) {
    state = state.copyWith(roomType: roomType);
  }

  void setStyle(String style) {
    state = state.copyWith(selectedStyle: style);
  }

  void setWallMaterial(String? material) {
    state = state.copyWith(selectedWallMaterial: material);
  }

  void setFloorMaterial(String? material) {
    state = state.copyWith(selectedFloorMaterial: material);
  }

  void setLighting(String lighting) {
    state = state.copyWith(lighting: lighting);
  }

  void setCustomPrompt(String prompt) {
    state = state.copyWith(customPrompt: prompt);
  }

  void reset() {
    _pollingTimer?.cancel();
    state = const TransformationWorkflowState();
  }

  Future<TransformationModel?> submitTransformation() async {
    if (state.selectedImage == null) {
      state = state.copyWith(error: 'Please capture or select a room photo first.');
      return null;
    }
    if (state.selectedStyle == null) {
      state = state.copyWith(error: 'Please choose an interior design style.');
      return null;
    }

    state = state.copyWith(
      isSubmitting: true,
      uploadProgress: 0.1,
      statusMessage: 'Uploading room photograph...',
      clearError: true,
    );

    try {
      final initial = await _repository.createTransformation(
        imageFile: state.selectedImage!,
        roomType: state.roomType,
        style: state.selectedStyle!,
        wallMaterial: state.selectedWallMaterial,
        floorMaterial: state.selectedFloorMaterial,
        lighting: state.lighting,
        customPrompt: state.customPrompt,
        onProgress: (sent, total) {
          if (total > 0) {
            state = state.copyWith(
              uploadProgress: (sent / total).clamp(0.0, 0.95),
            );
          }
        },
      );

      state = state.copyWith(
        currentTransformation: initial,
        statusMessage: 'Analyzing room geometry and materials...',
      );

      if (initial.isCompleted) {
        state = state.copyWith(
          isSubmitting: false,
          statusMessage: 'Transformation complete!',
        );
        return initial;
      }

      // Start asynchronous polling
      final completer = Completer<TransformationModel?>();
      int pollAttempts = 0;

      _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        pollAttempts++;
        try {
          final updated = await _repository.getTransformation(initial.id);
          state = state.copyWith(currentTransformation: updated);

          if (pollAttempts == 1) {
            state = state.copyWith(
              uploadProgress: 0.96,
              statusMessage: 'Applying architectural styles & textures...',
            );
          } else if (pollAttempts == 2) {
            state = state.copyWith(
              uploadProgress: 0.97,
              statusMessage: 'Rendering photorealistic lighting & reflections...',
            );
          } else if (pollAttempts >= 3) {
            state = state.copyWith(
              uploadProgress: 0.98,
              statusMessage: 'Finalizing high-end interior details...',
            );
          }

          if (updated.isCompleted) {
            timer.cancel();
            state = state.copyWith(
              isSubmitting: false,
              statusMessage: 'Ready!',
            );
            completer.complete(updated);
          } else if (updated.isFailed) {
            timer.cancel();
            state = state.copyWith(
              isSubmitting: false,
              uploadProgress: 0.0,
              error: updated.errorMessage ?? 'AI generation failed. Please try again.',
              clearError: false,
            );
            completer.complete(null);
          } else if (pollAttempts > 40) {
            // Timeout after 2 minutes
            timer.cancel();
            state = state.copyWith(
              isSubmitting: false,
              error: 'Transformation timed out. Please check back shortly.',
            );
            completer.complete(null);
          }
        } catch (e) {
          // Continue polling on transient network hiccup
        }
      });

      return await completer.future;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return null;
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}

final transformationWorkflowProvider =
    StateNotifierProvider<TransformationNotifier, TransformationWorkflowState>((ref) {
  final repository = ref.watch(transformationRepositoryProvider);
  return TransformationNotifier(repository);
});

final myTransformationsProvider = FutureProvider<List<TransformationModel>>((ref) async {
  final repo = ref.watch(transformationRepositoryProvider);
  return await repo.getMyTransformations();
});
