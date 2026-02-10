import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/presentation/widgets/containers/custom_container.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  const CustomDropdownButton({
    super.key,
    required this.items,
    required this.hint,
    this.onChanged,
    this.value,
    this.error,
    this.backgroundColor,
    required this.itemBuilder,
  });
  final List<T> items;
  final String hint;
  final ValueChanged<T?>? onChanged;
  final T? value;
  final String? error;
  final Color? backgroundColor;
  final Widget Function(T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: backgroundColor,
      withBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              border: error != null ? Border.all(color: context.error) : null,
              borderRadius: BorderRadius.circular(Constants.borderRadius),
            ),
            child: DropdownButton<T>(
              isExpanded: true,
              value: value,
              underline: Container(),
              onChanged: onChanged,
              hint: Text(hint),
              items: items
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item,
                      child: itemBuilder(item),
                    ),
                  )
                  .toList(),
            ),
          ),
          if (error != null)
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                error!,
                style: TextStyle(color: context.error, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}
