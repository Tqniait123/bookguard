import 'package:flutter/material.dart';
import 'package:granth_flutter/main.dart';

import '../../../models/book_mark_module.dart';

class BookmarkColorPicker extends StatefulWidget {
  final String selectedColor;
  final Function(String) onColorSelected;

  const BookmarkColorPicker({
    Key? key,
    required this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  State<BookmarkColorPicker> createState() => _BookmarkColorPickerState();
}

class _BookmarkColorPickerState extends State<BookmarkColorPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          language!.selectBookmarkColor,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: BookmarkColors.colors.entries.map((entry) {
            final colorKey = entry.key;
            final color = entry.value;
            final isSelected = widget.selectedColor == colorKey;

            return GestureDetector(
              onTap: () {
                widget.onColorSelected(colorKey);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ] : null,
                ),
                child: isSelected
                    ? Icon(
                  Icons.check,
                  color: _getContrastColor(color),
                  size: 20,
                )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getContrastColor(Color color) {
    // حساب اللون المتباين للنص على الخلفية الملونة
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}