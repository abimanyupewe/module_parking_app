import 'package:flutter/material.dart';
import '../config/colors.dart';

/// Primary action button widget
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool isIconLeft;

  const PrimaryButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.borderRadius = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.textStyle,
    this.icon,
    this.isIconLeft = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: foregroundColor ?? AppColors.white,
          disabledBackgroundColor: AppColors.tertiary,
          disabledForegroundColor: AppColors.inactive,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
        ),
      );
    }

    if (icon != null) {
      if (isIconLeft) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon!,
            const SizedBox(width: 8),
            Text(
              label,
              style:
                  textStyle ??
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style:
                  textStyle ??
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            icon!,
          ],
        );
      }
    }

    return Text(
      label,
      style:
          textStyle ??
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}

/// Secondary action button widget (outline style)
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? borderColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool isIconLeft;

  const SecondaryButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.borderColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.borderRadius = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.textStyle,
    this.icon,
    this.isIconLeft = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor ?? AppColors.primary,
          side: BorderSide(color: borderColor ?? AppColors.primary, width: 1.5),
          disabledForegroundColor: AppColors.inactive,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : Text(
                label,
                style:
                    textStyle ??
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
