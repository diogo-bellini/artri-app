import 'package:artriapp/utils/exercise_rules_config.dart';
import 'package:artriapp/utils/helpers/index.dart';
import 'package:artriapp/utils/index.dart';
import 'package:artriapp/views/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomExerciseRuleView extends StatelessWidget{
  final String difficulty;

  const CustomExerciseRuleView({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Vamos começar a montar sua rotina de exercícios personalizada de hoje! Clique para escolher os exercícios indicados abaixo:',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              color: AppColors.darkGreen,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 32,),
          
          _buildRulesList(difficulty),

          Spacer(),

          CustomSolidButton(
            text: 'Começar'.toUpperCase(),
            onPressed: () {
              var currentPath = RouterHelper.getUriFromContext(context).path;
              var formPath = currentPath.replaceAll('/rules', '/form');
              context.go(formPath);
            },
            gradientColors: AppGradients.greenGradient,
            textStyle: GoogleFonts.montserrat(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 32,),
        ],
      ),
    );
  }

  Widget _buildRulesList(String difficulty) {
    int mob = ExerciseRulesConfig.rulesByDifficulty[difficulty]?['mobilidade'] ?? 0; 
    int aque = ExerciseRulesConfig.rulesByDifficulty[difficulty]?['aquecimento'] ?? 0;
    int braco = ExerciseRulesConfig.rulesByDifficulty[difficulty]?['braços'] ?? 0;
    int perna = ExerciseRulesConfig.rulesByDifficulty[difficulty]?['pernas'] ?? 0;
    int tronco = ExerciseRulesConfig.rulesByDifficulty[difficulty]?['tronco'] ?? 0;
    int along = ExerciseRulesConfig.rulesByDifficulty[difficulty]?['alongamento'] ?? 0;

    return Column(
      children: [
      _buildRuleItem('Escolha $mob exercícios de', 'mobilidade'),
      _buildRuleItem('Escolha $aque exercícios de', 'aquecimento'),
      _buildRuleItem('Escolha $braco exercícios para os', 'braços'),
      _buildRuleItem('Escolha $perna exercícios para as', 'pernas'),
      _buildRuleItem('Escolha $tronco exercícios para o', 'tronco'),
      _buildRuleItem('Escolha $along exercícios de', 'alongamento'),
      ]
    );
  }

  Widget _buildRuleItem(String topText, String bottomText, {String assetPath = 'assets/images/edit-3-svgrepo-com.svg'}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        children: [
          SvgPicture.asset(
            assetPath,
            width: 28,
            height: 28,
            colorFilter: const ColorFilter.mode(Color(0xFF000000), BlendMode.srcIn),
          ),

          SizedBox(width: 16,),
          
          Column(
            children: [
              Text(
                topText,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: AppColors.darkGreen,
                ),
              ),
              Text(
                bottomText,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen,
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}