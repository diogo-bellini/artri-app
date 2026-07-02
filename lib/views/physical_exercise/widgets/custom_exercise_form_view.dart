import 'package:artriapp/utils/app_colors.dart';
import 'package:artriapp/utils/app_gradients.dart';
import 'package:artriapp/view_models/index.dart';
import 'package:artriapp/views/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomExerciseFormView extends StatefulWidget {
  final String difficulty;
  const CustomExerciseFormView({super.key, required this.difficulty});

  @override
  State<CustomExerciseFormView> createState() => _CustomExerciseFormViewState();
}

class _CustomExerciseFormViewState extends State<CustomExerciseFormView>{
  bool orientationsOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PhysicalExercisesViewModel>().loadAvaibleCustomExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhysicalExercisesViewModel>(
      builder: (context, viewModel, child) {
        final allExercises = viewModel.getAvaibleCustomExercises();
        final exercises = allExercises[viewModel.getCurrentCategory()] ?? [];
        
        if (exercises.isEmpty) {
          return Center(child: Text('Nenhum exercício encontrado para ${viewModel.getCurrentCategory()}'));
        }
        return Column(
          children: [
            const SizedBox(height: 16),
                Text(
                  'Selecione ${viewModel.getRequiredAmountForCurrentStep(widget.difficulty)} exercícios de ${viewModel.getCurrentCategory()} das opções abaixo:',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 24),
                
                Expanded(
                  child: ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      final isSelected = viewModel.getSelectedExercisesForCurrentCategory().contains(exercise);
                      
                      return CheckboxListTile(
                        title: Text(exercise.name),
                        value: isSelected,
                        activeColor: AppColors.darkGreen,
                        onChanged: (_) => viewModel.toggleCustomExerciseSelection(exercise),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 16),
                
                CustomSolidButton(
                  text: viewModel.checkIfIsLastStep() ? 'COMEÇAR' : 'PRÓXIMO',
                  onPressed: () {
                    if(!viewModel.checkIfIsLastStep()){
                      viewModel.handleStartCustomExercises(context, widget.difficulty);
                    } else {
                      if(orientationsOpen){
                        viewModel.prepareCustomWorkoutQueue();
                        viewModel.handleStartExercises(context);
                      } else {
                        setState(() {
                          orientationsOpen = true;
                        });
                        showDialog(
                          context: context,
                          builder: (context) => OrientationsDialog(),
                        );
                      }
                    }
                  },
                  gradientColors: AppGradients.greenGradient,
                  textStyle: GoogleFonts.montserrat(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}