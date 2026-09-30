import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Shows the hidden letter as a full-screen dialog with a soft fade+scale
/// entrance. Triggered by a long-press somewhere in the UI.
void showLoveLetter(BuildContext context, String letterText) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Fechar carta',
    barrierColor: Colors.black.withOpacity(0.75),
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, _, __) => _LoveLetterView(text: letterText),
    transitionBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
      return Opacity(
        opacity: animation.value.clamp(0.0, 1.0).toDouble(),
        child: Transform.scale(scale: 0.85 + 0.15 * curved.value, child: child),
      );
    },
  );
}

class _LoveLetterView extends StatelessWidget {
  final String text;
  const _LoveLetterView({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          constraints: const BoxConstraints(maxHeight: 520),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.pink.withOpacity(0.4), width: 1.5),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 30, offset: const Offset(0, 12))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite, color: AppColors.pink, size: 32),
              const SizedBox(height: 14),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    text.trim(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, height: 1.6, color: AppColors.text),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'toque para fechar',
                style: TextStyle(fontSize: 11, color: AppColors.textDim.withOpacity(0.8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
