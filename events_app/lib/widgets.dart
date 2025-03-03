import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'app_theme.dart';
import 'app_utils.dart';

extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get none => const BoxDecoration();
}

// extension ImageTypeExtension on String {
//   ImageType get imageType {
//     if (this.startsWith('http') || this.startsWith('https')) {
//       return ImageType.network;
//     } else if (this.startsWith('.svg')) {
//       return ImageType.svg;
//     } else if (this.startsWith('file://')) {
//       return ImageType.file;
//     } else {
//       return ImageType.png;
//     }
//   }
// }

// enum ImageType {
//   svg,
//   png,
//   network,
//   file,

//   unknown,
// }

enum BottomBarEnum {
  Iconhome,
  Iconsearchgray40001,
  Iconticket,
  Iconheartgray40001,
  Iconuser,
}

class BaseButton extends StatelessWidget {
  const BaseButton(
      {super.key,
      required this.text,
      this.onPressed,
      this.buttonStyle,
      this.buttonTextStyle,
      this.isDisabled,
      this.height,
      this.width,
      this.margin,
      this.alignment});
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? buttonStyle;
  final TextStyle? buttonTextStyle;
  final bool? isDisabled;
  final double? height;
  final double? width;
  final EdgeInsets? margin;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class CustomButtonStyles {
  static ButtonStyle get fillBlack => ElevatedButton.styleFrom(
        backgroundColor: appTheme.black900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );
  static ButtonStyle get fillGreenA => ElevatedButton.styleFrom(
        backgroundColor: appTheme.greenA400,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );
  static ButtonStyle get fillGreenA700 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.greenA700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );
  static ButtonStyle get fillWhite => ElevatedButton.styleFrom(
        backgroundColor: appTheme.whiteA700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );
  static ButtonStyle get none => ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
      elevation: WidgetStateProperty.all<double>(0),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
      side: WidgetStateProperty.all<BorderSide>(
        const BorderSide(color: Colors.transparent),
      ));
}

class CustomCheckboxButton extends StatelessWidget {
  CustomCheckboxButton(
      {super.key,
      required this.onChange,
      this.decoration,
      this.alignment,
      this.isRightCheck,
      this.iconSize,
      this.value,
      this.text,
      this.width,
      this.padding,
      this.textStyle,
      this.overflow,
      this.textAlignment,
      this.isExpandedText = false});
  final BoxDecoration? decoration;
  final Alignment? alignment;
  final bool? isRightCheck;
  final double? iconSize;
  bool? value;
  final Function(bool) onChange;
  final String? text;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final TextOverflow? overflow;
  final TextAlign? textAlignment;
  final bool isExpandedText;
  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildCheckBoxWidget)
        : buildCheckBoxWidget;
  }

  Widget get buildCheckBoxWidget => GestureDetector(
        onTap: () {
          value = !(value!);
          onChange(value!);
        },
        child: Container(
            decoration: decoration,
            width: width,
            padding: padding,
            child:
                (isRightCheck ?? false) ? rightSideCheckbox : leftSideCheckbox),
      );
  Widget get leftSideCheckbox => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          checkboxWidget,
          SizedBox(
            width: text != null && text!.isNotEmpty ? 8 : 0,
          ),
          isExpandedText ? Expanded(child: textWidget) : textWidget
        ],
      );
  Widget get rightSideCheckbox => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isExpandedText ? Expanded(child: textWidget) : textWidget,
          SizedBox(
            width: text != null && text!.isNotEmpty ? 8 : 0,
          ),
          checkboxWidget,
        ],
      );

  Widget get checkboxWidget => SizedBox(
      height: iconSize,
      width: iconSize,
      child: Checkbox(
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        value: value ?? false,
        checkColor: theme.colorScheme.primary,
        activeColor: appTheme.whiteA700,
        side: WidgetStateBorderSide.resolveWith(
          (states) => BorderSide(
            color: appTheme.whiteA700,
          ),
        ),
        onChanged: (value) {
          onChange(value!);
        },
      ));

  Widget get textWidget => Text(
        text ?? '',
        style: textStyle ?? theme.textTheme.titleMedium,
        overflow: overflow,
        textAlign: textAlignment ?? TextAlign.start,
      );
}

class CustomDropDown extends StatelessWidget {
  const CustomDropDown(
      {super.key,
      this.alignment,
      this.width,
      this.boxDecoration,
      this.focusNode,
      this.icon,
      this.iconSize,
      this.autofocus = false,
      this.textStyle,
      this.hintText,
      this.hintStyle,
      this.items,
      this.prefix,
      this.prefixConstraints,
      this.contentPadding,
      this.borderDecoration,
      this.fillColor,
      this.filled = false,
      this.validator,
      this.onChanged});

  final Alignment? alignment;

  final double? width;

  final BoxDecoration? boxDecoration;

  final FocusNode? focusNode;

  final Widget? icon;

  final double? iconSize;

  final bool? autofocus;

  final TextStyle? textStyle;

  final String? hintText;

  final TextStyle? hintStyle;

  final List<String>? items;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment ?? Alignment.center, child: dropDownwidget)
        : dropDownwidget;
  }

  Widget get dropDownwidget => Container(
        width: width ?? double.maxFinite,
        decoration: boxDecoration,
        child: DropdownButtonFormField(
          focusNode: focusNode,
          icon: icon,
          iconSize: iconSize ?? 24,
          autofocus: autofocus!,
          isExpanded: true,
          style: textStyle ?? CustomTextStyles.titleMediumGray900,
          hint: Text(
            hintText ?? "",
            style: hintStyle ?? CustomTextStyles.titleMediumGray900,
            overflow: TextOverflow.ellipsis,
          ),
          items: items?.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: hintStyle ?? CustomTextStyles.titleMediumGray900,
              ),
            );
          }).toList(),
          decoration: decoration,
          validator: validator,
          onChanged: (value) {
            onChanged!(value.toString());
          },
        ),
      );

  InputDecoration get decoration => InputDecoration(
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        isDense: true,
        contentPadding: contentPadding ?? EdgeInsets.all(8.h),
        fillColor: fillColor,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.h),
              borderSide: BorderSide(
                color: appTheme.gray600,
                width: 1,
              ),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.h),
              borderSide: BorderSide(
                color: appTheme.gray600,
                width: 1,
              ),
            ),
        focusedBorder: (borderDecoration ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.h),
                ))
            .copyWith(
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1,
          ),
        ),
      );
}

class CustomElevatedButton extends BaseButton {
  const CustomElevatedButton(
      {super.key, 
      this.decoration,
      this.leftIcon,
      this.rightIcon,
      super.margin,
      super.onPressed,
      super.buttonStyle,
      super.alignment,
      super.buttonTextStyle,
      super.isDisabled,
      super.height,
      super.width,
      required super.text});

  final BoxDecoration? decoration;

  final Widget? leftIcon;

  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildElevatedButtonWidget)
        : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
        height: height ?? 60.h,
        width: width ?? double.maxFinite,
        margin: margin,
        decoration: decoration,
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: isDisabled ?? false ? null : onPressed ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftIcon ?? const SizedBox.shrink(),
              Text(
                text,
                style: buttonTextStyle ??
                    CustomTextStyles.titleMediumWhiteA700Medium,
              ),
              rightIcon ?? const SizedBox.shrink()
            ],
          ),
        ),
      );
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      this.alignment,
      this.height,
      this.width,
      this.decoration,
      this.padding,
      this.onTap,
      this.child});

  final Alignment? alignment;

  final double? height;

  final double? width;

  final BoxDecoration? decoration;

  final EdgeInsetsGeometry? padding;

  final VoidCallback? onTap;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center, child: iconButtonWidget)
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: DecoratedBox(
          decoration: decoration ??
              BoxDecoration(
                color: appTheme.whiteA700,
                borderRadius: BorderRadius.circular(16.h),
                boxShadow: [
                  BoxShadow(
                    color: appTheme.blueGray1003f,
                    spreadRadius: 2.h,
                    blurRadius: 2.h,
                    offset: const Offset(
                      2,
                      3,
                    ),
                  )
                ],
              ),
          child: IconButton(
            padding: padding ?? EdgeInsets.zero,
            onPressed: onTap,
            icon: child ?? Container(),
          ),
        ),
      );
}

class CustomImageView extends StatelessWidget {
  const CustomImageView({super.key, 
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/image_not_found.png',
  });

  final String? imagePath;


  final double? height;

  final double? width;

  final Color? color;

  final BoxFit? fit;

  final String placeHolder;

  final Alignment? alignment;

  final VoidCallback? onTap;

  final EdgeInsetsGeometry? margin;

  final BorderRadius? radius;

  final BoxBorder? border;
  
 

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment!, child: _buildWidget())
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(onTap: onTap, child: _buildCircleImage()),
    );
  }

  //build the image with border radius

  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  //build the image with border and border radius style

  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
   
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          );
  }
}

class CustomOutlinedButton extends BaseButton {
  const CustomOutlinedButton(
      {super.key,
      this.decoration,
      this.leftIcon,
      this.rightIcon,
      this.label,
      super.onPressed,
      super.buttonStyle,
      super.buttonTextStyle,
      super.isDisabled,
      super.alignment,
      super.height,
      super.width,
      super.margin,
      required super.text});

  final BoxDecoration? decoration;

  final Widget? leftIcon;

  final Widget? rightIcon;

  final Widget? label;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildOutlinedButtonWidget)
        : buildOutlinedButtonWidget;
  }

  Widget get buildOutlinedButtonWidget => Container(
        height: height ?? 60.h,
        width: width ?? double.maxFinite,
        margin: margin,
        decoration: decoration,
        child: OutlinedButton(
          style: buttonStyle,
          onPressed: isDisabled ?? false ? null : onPressed ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftIcon ?? const SizedBox.shrink(),
              Text(
                text,
                style: buttonTextStyle ??
                    CustomTextStyles.titleMediumWhiteA700Medium,
              ),
              rightIcon ?? const SizedBox.shrink()
            ],
          ),
        ),
      );
}

// ignore_for_file: must_be_immutable

class CustomRadioButton extends StatelessWidget {
  CustomRadioButton(
      {super.key,
      required this.onChange,
      this.decoration,
      this.alignment,
      this.isRightCheck,
      this.iconSize,
      this.value,
      this.groupValue,
      this.text,
      this.width,
      this.padding,
      this.textStyle,
      this.overflow,
      this.textAlignment,
      this.gradient,
      this.backgroundColor,
      this.isExpandedText = false});

  final BoxDecoration? decoration;

  final Alignment? alignment;

  final bool? isRightCheck;

  final double? iconSize;

  String? value;

  final String? groupValue;

  final Function(String) onChange;

  final String? text;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final TextStyle? textStyle;

  final TextOverflow? overflow;

  final TextAlign? textAlignment;

  final Gradient? gradient;

  final Color? backgroundColor;

  final bool isExpandedText;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildRadioButtonWidget)
        : buildRadioButtonWidget;
  }

  bool get isGradient => gradient != null;

  BoxDecoration get gradientDecoration => BoxDecoration(gradient: gradient);

  Widget get buildRadioButtonWidget => GestureDetector(
        onTap: () {
          onChange(value!);
        },
        // decoration: decoration,
        child: Container(
          width: width,
          padding: padding,
          child: (isRightCheck ?? false)
              ? rightSideRadioButton
              : leftSideRadioButton,
        ),
      );

  Widget get leftSideRadioButton => Row(
        children: [
          radioButtonWidget,
          SizedBox(
            width: text != null && text!.isNotEmpty ? 8 : 0,
          ),
          isExpandedText ? Expanded(child: textWidget) : textWidget
        ],
      );

  Widget get rightSideRadioButton => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isExpandedText ? Expanded(child: textWidget) : textWidget,
          SizedBox(
            width: text != null && text!.isNotEmpty ? 8 : 0,
          ),
          radioButtonWidget
        ],
      );

  Widget get textWidget => Text(
        text ?? "",
        textAlign: textAlignment ?? TextAlign.start,
        overflow: overflow,
        style: textStyle,
      );

  Widget get radioButtonWidget => SizedBox(
      height: iconSize,
      width: iconSize,
      child: Radio<String>(
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
        value: value ?? "",
        groupValue: groupValue,
        onChanged: (value) {
          onChange(value!);
        },
      ));

  BoxDecoration get radioButtonDecoration =>
      BoxDecoration(color: backgroundColor);
}

class CustomSearchView extends StatelessWidget {
  const CustomSearchView(
      {super.key,
      this.alignment,
      this.width,
      this.boxDecoration,
      this.scrollPadding,
      this.controller,
      this.focusNode,
      this.autofocus = false,
      this.textStyle,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.hintStyle,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.contentPadding,
      this.borderDecoration,
      this.fillColor,
      this.filled = false,
      this.validator,
      this.onChanged});

  final Alignment? alignment;

  final double? width;

  final BoxDecoration? boxDecoration;

  final TextEditingController? scrollPadding;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: searchViewWidget(context))
        : searchViewWidget(context);
  }

  Widget searchViewWidget(BuildContext context) => Container(
        width: width ?? double.maxFinite,
        decoration: boxDecoration,
        child: TextFormField(
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
          focusNode: focusNode,
          onTapOutside: (event) {
            if (focusNode != null) {
              focusNode?.unfocus();
            } else {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          autofocus: autofocus!,
          style: textStyle ?? CustomTextStyles.bodyLargeGray400,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
          onChanged: (String value) {
            onChanged?.call(value);
          },
        ),
      );
  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? CustomTextStyles.bodyLargeGray400,
        prefixIcon: Padding(
          padding: EdgeInsets.all(
            5.h,
          ),
          child: Icon(
            Icons.arrow_back,
            color: Colors.grey.shade600,
            size: 24.h,
          ),
        ),
        prefixIconConstraints: prefixConstraints ??
            BoxConstraints(
              maxHeight: 34.h,
            ),
        suffixIcon: suffix ??
            Container(
              margin: EdgeInsets.only(
                right: 16.h,
                top: 8.h,
                bottom: 8.h,
              ),
              width: 16.h,
              child: Icon(Icons.search, color: appTheme.gray600, size: 24.h),
            ),
        suffixIconConstraints: suffixConstraints ??
            BoxConstraints(
              maxHeight: 34.h,
            ),
        isDense: true,
        contentPadding: contentPadding ??
            EdgeInsets.only(
              left: 6.h,
              top: 6.h,
              bottom: 6.h,
            ),
        fillColor: fillColor,
        filled: filled,
        border: borderDecoration ??
            UnderlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.gray200,
              ),
            ),
        enabledBorder: borderDecoration ??
            UnderlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.gray200,
              ),
            ),
        focusedBorder: (borderDecoration ?? const UnderlineInputBorder()).copyWith(
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1,
          ),
        ),
      );
}

class CustomSwitch extends StatelessWidget {
  CustomSwitch(
      {super.key,
      required this.onChange,
      this.alignment,
      this.value,
      this.width,
      this.height,
      this.margin});

  final Alignment? alignment;

  bool? value;

  final Function(bool) onChange;

  final double? width;

  final double? height;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        margin: margin,
        child: alignment != null
            ? Align(
                alignment: alignment ?? Alignment.center, child: switchWidget)
            : switchWidget);
  }

  Widget get switchWidget => FlutterSwitch(
        value: value ?? false,
        height: 20.h,
        width: 34.h,
        toggleSize: 18,
        borderRadius: 10.h,
        activeColor: appTheme.green500,
        activeToggleColor: appTheme.whiteA700,
        inactiveColor: appTheme.gray300,
        inactiveToggleColor: appTheme.whiteA700,
        onToggle: (value) {
          onChange(value);
        },
      );
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      this.alignment,
      this.width,
      this.boxDecoration,
      this.scrollPadding,
      this.controller,
      this.focusNode,
      this.autofocus = false,
      this.textStyle,
      this.obscureText = false,
      this.readOnly = false,
      this.onTap,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.hintStyle,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.contentPadding,
      this.borderDecoration,
      this.fillColor,
      this.filled = false,
      this.validator});

  final Alignment? alignment;

  final double? width;

  final BoxDecoration? boxDecoration;
  final TextEditingController? scrollPadding;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final bool? obscureText;

  final bool? readOnly;

  final VoidCallback? onTap;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;
  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: textFormFieldWidget(context))
        : textFormFieldWidget(context);
  }

  Widget textFormFieldWidget(BuildContext context) => Container(
        width: width ?? double.maxFinite,
        decoration: boxDecoration,
        child: TextFormField(
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
          focusNode: focusNode,
          onTapOutside: (event) {
            if (focusNode != null) {
              focusNode?.unfocus();
            } else {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          autofocus: autofocus!,
          style: textStyle ?? theme.textTheme.bodyMedium,
          obscureText: obscureText!,
          readOnly: readOnly!,
          onTap: () {
            onTap?.call();
          },
          textInputAction: textInputAction,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
        ),
      );

  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? theme.textTheme.bodyMedium,
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        isDense: true,
        contentPadding:
            contentPadding ?? EdgeInsets.fromLTRB(6.h, 30.h, 6.h, 6.h),
        fillColor: fillColor,
        filled: filled,
        border: borderDecoration ??
            UnderlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.gray100,
              ),
            ),
        enabledBorder: borderDecoration ??
            UnderlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.gray100,
              ),
            ),
        focusedBorder: (borderDecoration ?? const UnderlineInputBorder()).copyWith(
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1,
          ),
        ),
      );
}

class AppbarLeadingImage extends StatelessWidget {
  const AppbarLeadingImage(
      {super.key,
      this.height,
      this.imagePath,
      this.width,
      this.onTap,
      this.margin});

  final double? height;

  final double? width;

  final String? imagePath;

  final Function? onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          onTap?.call();
        },
        child: Icon(
          Icons.arrow_back,
          color: appTheme.gray600,
          size: 24.h,
        ),
        // child: CustomImageView(
        //   // imagePath: imagePath!,
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: appTheme.gray600,
        //     size: 24.h,
        //   ),
        //   height: height ?? 18.h,
        //   width: width ?? 18.h,
        //   fit: BoxFit.contain,
        // ),
      ),
    );
  }
}

class AppbarSubtitle extends StatelessWidget {
  const AppbarSubtitle({super.key, required this.text, this.onTap, this.margin});

  final String text;

  final Function? onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Text(
          text,
          style: CustomTextStyles.bodySmallGray600_1.copyWith(
            color: appTheme.gray600,
          ),
        ),
      ),
    );
  }
}

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({super.key, required this.text, this.onTap, this.margin});

  final String text;

  final Function? onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Text(
          text,
          style: CustomTextStyles.titleLargeWhiteA700.copyWith(
            color: appTheme.whiteA700,
          ),
        ),
      ),
    );
  }
}

class AppbarTitleDropdown extends StatelessWidget {
  const AppbarTitleDropdown(
      {super.key,
      required this.hintText,
      required this.items,
      required this.onTap,
      this.margin});

  final String? hintText;

  final List<String> items;

  final Function(String) onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: CustomDropDown(
        width: 110.h,
        icon: Container(
        
          margin: EdgeInsets.only(left: 4.h),
          child: Icon(
            Icons.arrow_drop_down,
            color: appTheme.gray900,
            size: 24.h,
          ),
          // child: CustomImageView(
          //   // imagePath: ImageConstant.imgArrowdownGray900,
          //   icon: Icon(
          //     Icons.arrow_drop_down,
          //     color: appTheme.gray900,
          //     size: 18.h,
          //   ),
          //   height: 18.h,
          //   width: 18.h,
          //   fit: BoxFit.contain,
          // ),
        ),
        iconSize: 18.h,
        hintText: "Barcelona",
        items: items,
        contentPadding: EdgeInsets.only(
          left: 12.h,
          top: 2.h,
          bottom: 2.h,
        ),
      ),
    );
  }
}

class AppbarTitleImage extends StatelessWidget {
  const AppbarTitleImage(
      {super.key,
      this.height,
      this.width,
      this.imagePath,
      this.onTap,
      this.margin});

  final double? height;

  final double? width;

  final String? imagePath;

  final Function? onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          onTap?.call();
        },
        child: Icon(
          Icons.arrow_back,
          color: appTheme.gray600,
          size: 24.h,
        ),
        // child: CustomImageView(
        //   // imagePath: imagePath!,
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: appTheme.gray600,
        //     size: 24.h,
        //   ),
        //   height: height ?? 18.h,
        //   width: width ?? 18.h,
        //   fit: BoxFit.contain,
        // ),
      ),
    );
  }
}

class AppbarTrailingImage extends StatelessWidget {
  const AppbarTrailingImage(
      {super.key,
      this.imagePath,
      this.height,
      this.width,
      this.onTap,
      this.margin});

  final double? height;

  final double? width;

  final String? imagePath;

  final Function? onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          onTap?.call();
        },
        child: Icon(
          Icons.arrow_back,
          color: appTheme.gray600,
          size: 24.h,
        ),
        // child: CustomImageView(
        //   // imagePath: imagePath!,
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: appTheme.gray600,
        //     size: 24.h,
        //   ),
        //   height: height ?? 18.h,
        //   width: width ?? 18.h,
        //   fit: BoxFit.contain,
        // ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      this.height,
      this.shape,
      this.leadingWidth,
      this.leading,
      this.title,
      this.centerTitle,
      this.actions});

  final double? height;

  final ShapeBorder? shape;

  final double? leadingWidth;

  final Widget? leading;

  final Widget? title;

  final bool? centerTitle;

  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      shape: shape,
      toolbarHeight: height ?? 28.h,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
        SizeUtils.width,
        height ?? 28.h,
      );
}

class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({super.key, this.onChanged});

  Function(BottomBarEnum)? onChanged;
  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      // icon: ImageConstant.imgIconHome,
      icon: Icon(
        Icons.home_outlined,
        color: appTheme.gray40001,
        size: 4.h,
      ),
      activeIcon: Icon(
        Icons.home_outlined,
        color: appTheme.blueGray900,
        size: 4.h,
      ),
      type: BottomBarEnum.Iconhome,
    ),
    BottomMenuModel(
      // icon: ImageConstant.imgIconSearchGray40001,
      icon: Icon(
        Icons.search_outlined,
        color: appTheme.gray40001,
        size: 4.h,
      ),
      activeIcon: Icon(
        Icons.search_outlined,
        color: appTheme.blueGray900,
        size: 4.h,
      ),
      type: BottomBarEnum.Iconsearchgray40001,
    ),
    BottomMenuModel(
      // icon: ImageConstant.imgIconTicket,
      icon: Icon(
        Icons.local_activity_outlined,
        color: appTheme.gray40001,
        size: 4.h,
      ),
      activeIcon: Icon(
        Icons.local_activity_outlined,
        color: appTheme.blueGray900,
        size: 4.h,
      ),
      type: BottomBarEnum.Iconticket,
    ),
    BottomMenuModel(
      // icon: ImageConstant.imgIconHeartGray40001,
      icon: Icon(
        Icons.favorite_border_outlined,
        color: appTheme.gray40001,
        size: 4.h,
      ),
      activeIcon: Icon(
        Icons.favorite_border_outlined,
        color: appTheme.blueGray900,
        size: 4.h,
      ),
      type: BottomBarEnum.Iconheartgray40001,
    ),
    BottomMenuModel(
      // icon: ImageConstant.imgIconUser,
      icon: Icon(
        Icons.person_outline,
        color: appTheme.gray40001,
        size: 4.h,
      ),
      activeIcon: Icon(
        Icons.person_outline,
        color: appTheme.blueGray900,
        size: 4.h,
      ),
      type: BottomBarEnum.Iconuser,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.gray100,
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          return BottomNavigationBarItem(
            // icon: CustomImageView(
            //   // imagePath: bottomMenuList[index].icon,
            //   icon: bottomMenuList[index].icon,
            //   height: 24.h,
            //   width: 26.h,
            //   color: appTheme.gray40001,
            // ),
            icon: bottomMenuList[index].icon,
            // activeIcon: CustomImageView(
            //   // imagePath: bottomMenuList[index].activeIcon,
            //   icon: bottomMenuList[index].icon,
            //   height: 26.h,
            //   width: 26.h,
            //   color: appTheme.blueGray900,
            // ),
            activeIcon: bottomMenuList[index].activeIcon,
            label: '',
          );
        }),
        onTap: (index) {
          selectedIndex = index;

          widget.onChanged?.call(bottomMenuList[index].type);

          setState(() {});
        },
      ),
    );
  }
}

class BottomMenuModel {
  BottomMenuModel(
      { required this.icon, required this.activeIcon, required this.type});

  Icon icon;

  Icon activeIcon;

  BottomBarEnum type;
}

// class DefaultWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Color(0xffffffff),
//       padding: EdgeInsets.all(10),
//       child: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Please replace the respective Widget here',
//               style: TextStyle(
//                 fontSize: 18,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
