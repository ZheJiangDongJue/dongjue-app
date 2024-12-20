import 'package:flutter/material.dart';

typedef ComboBoxDisplayTextGetter = String Function(dynamic item);
typedef ComboBoxValueGetter = dynamic Function(dynamic item);

class MyCombobox extends StatefulWidget {
  final List<MyComboBoxItem> items;
  const MyCombobox({super.key, required this.items});

  @override
  State<MyCombobox> createState() => _MyComboboxState();
}

class _MyComboboxState extends State<MyCombobox> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: '选择一个选项',
      ),
      value: selectedValue,
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue!;
        });
      },
      items: widget.items.map<DropdownMenuItem<String>>((MyComboBoxItem item) {
        return DropdownMenuItem<String>(
          value: item.value,
          child: Text(item.text),
        );
      }).toList(),
    );
  }
}

class MyComboBoxItem<T> extends StatelessWidget {
  final String text;
  final T value;
  const MyComboBoxItem({super.key, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
