import 'package:flutter/material.dart';
import '../config/colors.dart';

/// Custom search bar widget
class CustomSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final IconData prefixIcon;
  final bool autofocus;
  final Color? backgroundColor;

  const CustomSearchBar({
    Key? key,
    this.hintText = 'Cari...',
    required this.onChanged,
    this.onClear,
    this.controller,
    this.prefixIcon = Icons.search,
    this.autofocus = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.tertiary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.tertiary),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        autofocus: widget.autofocus,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: AppColors.inactive),
          prefixIcon: Icon(widget.prefixIcon, color: AppColors.inactive),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.inactive),
                  onPressed: () {
                    _controller.clear();
                    widget.onClear?.call();
                    widget.onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

/// Filter chip widget untuk filtering
class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final Color? unselectedColor;

  const CustomFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
    this.unselectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? AppColors.primary)
              : (unselectedColor ?? AppColors.tertiary),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.tertiary,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.inactive,
          ),
        ),
      ),
    );
  }
}
