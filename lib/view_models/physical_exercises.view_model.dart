import 'dart:developer';

import 'package:artriapp/models/index.dart';
import 'package:artriapp/routes/index.dart';
import 'package:artriapp/services/index.dart';
import 'package:artriapp/utils/enums/index.dart';
import 'package:artriapp/utils/exercise_rules_config.dart';
import 'package:artriapp/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PhysicalExercisesViewModel extends ChangeNotifier {
  TrainingType? _currentTrainingType;
  ExerciseDifficulty? _currentDifficulty;
  List<ExerciseQueued> _queuedExercises = [];
  int? _currentExerciseIndex;
  List<ExerciseQueued> get exercises => _queuedExercises;
  ExerciseQueued? get currentExercise => _currentExerciseIndex == null
      ? null
      : _queuedExercises[_currentExerciseIndex ?? 0];

  final PhysicalExercisesService _physicalExercisesService;

  PhysicalExercisesViewModel(this._physicalExercisesService);

  int _currentStep = 0;

  final List<String> _categoriesOrder = [
    'mobilidade', 'aquecimento', 'braços', 'pernas', 'tronco', 'alongamento', 
  ];

  Map<String, List<Exercise>> _selectedExercisesByCategory = {
    'MOBILIDADE': [],
    'AQUECIMENTO': [],
    'BRAÇOS': [],
    'PERNAS': [],
    'TRONCO': [],
    'ALONGAMENTO': [],
  };

  List<Exercise> getSelectedExercisesForCurrentCategory() {
    return _selectedExercisesByCategory[getCurrentCategory()] ?? [];
  }

  int getCurrentStep(){
    return _currentStep;
  }

  String getCurrentCategory() {
    return _categoriesOrder[_currentStep].toUpperCase();
  }
  
  bool checkIfIsLastStep() {
    return _currentStep == _categoriesOrder.length - 1;
  }

  int getRequiredAmountForCurrentStep(String difficulty) {
    String categoryKey = getCurrentCategory(); 
    String keyForRules = categoryKey.toLowerCase();
    
    return ExerciseRulesConfig.rulesByDifficulty[difficulty]?[keyForRules] ?? 0;
  }

  Map<String, List<Exercise>> _avaibleCustomExercises = {};

  Map<String, List<Exercise>> getAvaibleCustomExercises(){
    return _avaibleCustomExercises;
  }

  Future<void> loadAvaibleCustomExercises() async {
    if(_currentDifficulty == null){
      log('Error: Dificuldade não selecionada para carregar exercícios personalizados');
    }
    _avaibleCustomExercises = await _physicalExercisesService.getCustomExercisesCategorized(_currentDifficulty!);
    _selectedExercisesByCategory.forEach((key, list) {
      list.clear();
    });
    _currentStep = 0;
    notifyListeners();
  }

  void toggleCustomExerciseSelection(Exercise exercise){
    final currentList = _selectedExercisesByCategory[getCurrentCategory()]!;

    if(currentList.contains(exercise)){
      currentList.remove(exercise);
    }else{
      currentList.add(exercise);
    }
    notifyListeners();
  }

  bool canProceedToNextStep(String difficulty) {
    final count = getSelectedExercisesForCurrentCategory().length;
    final required = getRequiredAmountForCurrentStep(difficulty);
    return count == required;
  }

  void prepareCustomWorkoutQueue() {
    final allSelected = _selectedExercisesByCategory.values.expand((list) => list).toList();
    _queuedExercises = _queueExercises(allSelected); 
  }

  void handleStartCustomExercises(BuildContext context, String difficulty){
    if(!canProceedToNextStep(difficulty)){
      log('Error: Não selecionou o número certo de exercícios');
      return;
    }

    if(!checkIfIsLastStep()){
      _currentStep++;
      notifyListeners();
    } 
  }

  void handleTrainingTypeSelection(TrainingType type, BuildContext context) {
    _currentTrainingType = type;

    context.go(_getRouteForTrainingType(type));
  }

  String _getRouteForTrainingType(TrainingType type) {
    switch (type) {
      case TrainingType.hands:
        return PhysicalExerciseRoutes.handExercises;
      case TrainingType.feet:
        return PhysicalExerciseRoutes.feetExercises;
      case TrainingType.custom:
        return PhysicalExerciseRoutes.customExercises;
      default:
        return PhysicalExerciseRoutes.customExercises;
    }
  }

  void handleDifficultySelection(
    ExerciseDifficulty difficulty,
    BuildContext context,
  ) async {
    _currentDifficulty = difficulty;

    if (_currentTrainingType == null) {
      log('Error: Training type not selected');
      return;
    }

    var currentPath = RouterHelper.getUriFromContext(context);

    if(_currentTrainingType == TrainingType.custom){
      context.go('$currentPath/${difficulty.toString()}/rules');
      return;
    }

    var exercises = await _physicalExercisesService.getExercisesFromTraining(
      _currentTrainingType!,
      _currentDifficulty!,
    );

    _queuedExercises = _queueExercises(exercises);

    context.go('$currentPath/${difficulty.toString()}');
  }

  List<ExerciseQueued> _queueExercises(List<Exercise> exercises) {
    var queue = exercises
        .map(
          (e) => ExerciseQueued(
            exercise: e,
            isFirst: exercises.indexOf(e) == 0,
            isLast: exercises.indexOf(e) == exercises.length - 1,
          ),
        )
        .toList();

    _currentExerciseIndex = 0;

    return queue;
  }

  void handleNextExercise(BuildContext context) {
    if (_currentExerciseIndex == null) {
      log('Error: No current exercise');
      return;
    }

    if (currentExercise!.isLast) {
      context.go(PhysicalExerciseRoutes.congratulations);
      return;
    }

    _currentExerciseIndex = _currentExerciseIndex! + 1;

    context.go(getExerciseRoute(context));
  }

  void handlePreviousExercise(BuildContext context) {
    if (_currentExerciseIndex == null) {
      log('Error: No current exercise');
      return;
    }

    if (currentExercise!.isFirst) {
      log('Info: Already at the first exercise');
      return;
    }

    _currentExerciseIndex = _currentExerciseIndex! - 1;

    context.go(getExerciseRoute(context));
  }

  void handleStartExercises(BuildContext context) {
    _currentExerciseIndex = 0;

    context.go(getExerciseRoute(context));
  }

  void handleCompleteExercise(BuildContext context) {
    if (_currentExerciseIndex == null) {
      log('Error: No current exercise');
      return;
    }

    currentExercise!.markAsCompleted();
    handleNextExercise(context);
  }

  String getExerciseRoute(BuildContext context) {
    var currentPath = RouterHelper.getUriFromContext(context);
    var currentPathSegments = currentPath.pathSegments;
    var hasCurrentExerciseId = int.tryParse(currentPathSegments.last) != null;
    var cleanedPath = currentPath.path;

    if (hasCurrentExerciseId) {
      cleanedPath =
          '/${currentPathSegments.sublist(0, currentPathSegments.length - 1).join('/')}';
    } else if (currentPathSegments.isNotEmpty && currentPathSegments.last == 'form') {
      cleanedPath =
          '/${currentPathSegments.sublist(0, currentPathSegments.length - 1).join('/')}';
    }

    return '$cleanedPath/${currentExercise!.id}';
  }
}
