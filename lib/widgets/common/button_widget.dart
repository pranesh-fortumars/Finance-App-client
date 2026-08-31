import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;

  const ButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textStyle = _getTextStyle(theme);

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == ButtonVariant.primary
                    ? Colors.white
                    : theme.primaryColor,
              ),
            ),
          )
        else if (icon != null)
          Icon(icon, size: _getIconSize())
        else
          const SizedBox.shrink(),
        if ((isLoading || icon != null) && text.isNotEmpty)
          const SizedBox(width: 8),
        if (text.isNotEmpty) Text(text, style: textStyle),
      ],
    );

    if (variant == ButtonVariant.primary) {
      return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getModernButtonStyle(theme),
          child: buttonChild,
        ),
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getModernButtonStyle(theme),
          child: buttonChild,
        ),
      );
    }
  }

  ButtonStyle _getModernButtonStyle(ThemeData theme) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return theme.colorScheme.surfaceContainerHighest;
        }
        if (variant == ButtonVariant.primary) {
          // Modern gradient colors for primary buttons
          return const Color(0xFF667EEA); // Modern blue-purple
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return theme.colorScheme.onSurface.withValues(alpha: 0.4);
        }
        if (variant == ButtonVariant.primary) {
          return Colors.white;
        }
        return const Color(0xFF667EEA); // Modern blue-purple for outline
      }),
      padding: WidgetStateProperty.all(_getPadding()),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (variant == ButtonVariant.primary) {
          return states.contains(WidgetState.pressed) ? 2 : 6;
        }
        return 0;
      }),
      shadowColor: WidgetStateProperty.all(
        const Color(0xFF667EEA).withValues(alpha: 0.4), // Modern shadow
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // More rounded corners
          side: variant == ButtonVariant.outline
              ? const BorderSide(color: Color(0xFF667EEA), width: 2)
              : BorderSide.none,
        ),
      ),
    );
  }

  TextStyle _getTextStyle(ThemeData theme) {
    switch (size) {
      case ButtonSize.small:
        return theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ) ??
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
      case ButtonSize.medium:
        return theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ) ??
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
      case ButtonSize.large:
        return theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ) ??
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }
}

enum ButtonVariant { primary, outline }

enum ButtonSize { small, medium, large }
