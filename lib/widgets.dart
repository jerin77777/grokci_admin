import 'package:flutter/material.dart';
import 'types.dart';


class SmallButton extends StatelessWidget {
  const SmallButton({super.key, required this.label, required this.onPress});
  final String label;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0),
        minimumSize: Size(30, 30),
      ),
      onPressed: () {
        onPress();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 13),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Pallet.primary),
        child: Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.white),
        ),
      ),
    );
  }
}


class TextBox extends StatefulWidget {
  const TextBox(
      {super.key,
      this.controller,
      this.maxLines,
      this.onType,
      this.onEnter,
      this.hintText,
      this.focus,
      this.radius,
      this.errorText,
      this.type,
      this.isPassword = false,
      this.enabled = true});
  final TextEditingController? controller;
  final int? maxLines;
  final Function(String)? onType;
  final Function(String)? onEnter;
  final String? hintText;
  final FocusNode? focus;
  final double? radius;
  final bool isPassword;
  final bool enabled;
  final String? errorText;
  final String? type;
  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  bool hasError = false;
  @override
  void initState() {
    if (widget.errorText != null) {
      hasError = true;
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: (widget.enabled) ? Pallet.inner1 : Pallet.inner1.withOpacity(0.5),
            borderRadius: BorderRadius.circular(widget.radius ?? 5),
            border: Border.all(color: (hasError) ? Colors.red : Colors.transparent),
          ),
          child: TextField(
              readOnly: !widget.enabled,
              obscureText: widget.isPassword,
              focusNode: widget.focus,
              onSubmitted: widget.onEnter,
              onChanged: (value) {
                hasError = false;
                if (widget.type == "time" &&
                    !RegExp(r'^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(value) &&
                    value.isNotEmpty) {
                  hasError = true;
                }
                if (widget.type == "double" && !RegExp(r'^\d*\.?\d*$').hasMatch(value) && value.isNotEmpty) {
                  hasError = true;
                }
                if (widget.type == "int" && !RegExp(r'^[0-9]+$').hasMatch(value) && value.isNotEmpty) {
                  hasError = true;
                }
                setState(() {});

                if (widget.onType != null) {
                  widget.onType!(value);
                }
              },
              controller: widget.controller,
              style: const TextStyle(fontSize: 12),
              maxLines: widget.maxLines ?? 1,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(fontSize: 12, color: Pallet.font3),
                isDense: true,
                border: InputBorder.none,
              )),
        ),
        if (widget.errorText != null)
          Text(
            widget.errorText!,
            style: TextStyle(fontSize: 10, color: Colors.red),
          )
      ],
    );
  }
}
