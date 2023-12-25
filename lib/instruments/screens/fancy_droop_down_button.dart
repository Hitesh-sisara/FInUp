import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FancyDropdownButton extends StatelessWidget {
  const FancyDropdownButton({
    Key? key,
    required this.title,
    required this.items,
    this.value,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2(
        isExpanded: true,
        hint: Text(
          title,
          style: TextStyle(fontSize: 20.sp),
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          // borderRadius: BorderRadius.circular(8),
          // color: Colors.white,
          // border: Border.all(color: Colors.grey),
        ),
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 16),
                  ),
                ))
            .toList(),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
