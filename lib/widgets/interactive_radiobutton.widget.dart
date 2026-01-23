import 'package:flutter/material.dart';

class InteractiveRadioButton extends StatelessWidget {
  const InteractiveRadioButton({
    super.key,
    required this.isSelected,
    required this.child,
    required this.onChanged,
  });

  final bool isSelected;
  final Widget child;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(true),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onChanged(true),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Opacity(
              opacity: isSelected ? 1.0 : 0.7,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
