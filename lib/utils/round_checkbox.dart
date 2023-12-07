import 'package:flutter/material.dart';

class RoundedCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?)? onChanged;
  final Color activeColor;

  const RoundedCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: value ? activeColor : Colors.transparent,
        border: Border.all(
          color: value ? activeColor : const Color(0xFF656565),
          width: 2.0,
        ),
      ),
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: Colors.transparent,
        ),
        child: Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.transparent,
          checkColor: Colors.white,
        ),
      ),
    );
  }
}
