import 'package:flutter/material.dart';

class InteractiveCheckbox extends StatelessWidget {
  const InteractiveCheckbox({
    super.key,
    required this.isChecked,
    required this.child,
    required this.onChanged,
  });

  final bool isChecked;
  final Widget child;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: isChecked,
              onChanged: (value) => onChanged(value ?? false),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Opacity(
              opacity: isChecked ? 0.5 : 1.0,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
