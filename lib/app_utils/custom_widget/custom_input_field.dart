import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final TextInputAction textInputAction;
  final String? hintText;
  final bool enabled;
  final Function(String)? onChanged;
  final Function()? onTap;
  final TextInputType keyboardType;
  final int maxLines;
  final double? height;
  final double? width;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;


  const CustomInputField({
    Key? key,
    this.controller,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.center,
    this.textInputAction = TextInputAction.done,
    this.hintText,
    this.enabled = true,
    this.onChanged,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.height,
    this.width,
    this.validator,
    this.inputFormatters,
  }) : super(key: key);

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText; // Set initial obscureText state
  }

  @override
  Widget build(BuildContext context) {
    // double fileHeight = RHelperFunctions.buttonHeight(context);
    // double fieldWidth = RHelperFunctions.buttonWidth(context);
    return Center(
      child: SizedBox(
        // height: fileHeight,
        // width: fieldWidth,
        child: TextFormField(
          controller: widget.controller,
          textAlign: widget.textAlign,
          textInputAction: widget.textInputAction,
          textAlignVertical: widget.textAlignVertical,
          obscureText: _obscureText, // Use the state variable
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters ?? [],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon:
                widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
            suffixIcon: widget.suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? widget.suffixIcon
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            // floatingLabelBehavior: FloatingLabelBehavior.never,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
