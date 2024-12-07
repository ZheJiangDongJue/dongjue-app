import 'package:flutter/material.dart';

class ProcessAssemblyFlowBill extends StatefulWidget {
  const ProcessAssemblyFlowBill({super.key});

  @override
  State<ProcessAssemblyFlowBill> createState() =>
      _ProcessAssemblyFlowBillState();
}

class _ProcessAssemblyFlowBillState extends State<ProcessAssemblyFlowBill> {
  // List<>

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('组装流程卡'),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      color: Colors.blue,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Builder(
                            builder: (context) {
                              return Stack(children: []);
                            },
                          ))),
                  Expanded(
                      child: Container(
                    color: Colors.red,
                  ))
                ]),
          );
        }));
  }
}

class ControlPositionInfo {
  final double x;
  final double y;
  final double maxWidth;
  final double maxHeight;

  ControlPositionInfo(this.x, this.y, this.maxWidth, this.maxHeight);
}

class TitleControlInfo extends ControlPositionInfo {
  final String title;

  TitleControlInfo(
      this.title, super.x, super.y, super.maxWidth, super.maxHeight);
}

class TextBoxInfo extends TitleControlInfo {
  final String text;

  TextBoxInfo(this.text, super.title, super.x, super.y, super.maxWidth,
      super.maxHeight);
}

class ButtonInfo extends ControlPositionInfo {
  final bool isEnable;
  final Function? onPressed;

  ButtonInfo(this.isEnable, this.onPressed, super.x, super.y, super.maxWidth,
      super.maxHeight);
}

abstract class IComboBoxInfo {
  List get g_items;
  set g_items(List value);

  get g_selectedItem;
  set g_selectedItem(dynamic value);

  OnChangedDynamicDelegate? get g_onChanged;
  set g_onChanged(OnChangedDynamicDelegate? value);
}

typedef OnChangedDynamicDelegate = void Function(
    dynamic oldValue, dynamic newValue, int oldIndex, int newIndex);
typedef OnChangedDelegate<T> = void Function(
    T oldValue, T newValue, int oldIndex, int newIndex);

class ComboBoxInfo<T> extends ControlPositionInfo implements IComboBoxInfo {
  List<T> items;
  T? selectedItem;
  OnChangedDelegate? onChanged;
  final int selectedIndex;

  ComboBoxInfo(this.items, this.selectedItem, this.onChanged,
      this.selectedIndex, super.x, super.y, super.maxWidth, super.maxHeight);

  @override
  List get g_items => items;

  @override
  set g_items(List value) {
    items = value as List<T>;
  }

  @override
  T? get g_selectedItem => selectedItem;

  @override
  set g_selectedItem(dynamic value) {
    selectedItem = value as T;
  }

  @override
  OnChangedDelegate? get g_onChanged => onChanged;

  @override
  set g_onChanged(OnChangedDynamicDelegate? value) {
    onChanged = value;
  }
}

class MyControl extends StatelessWidget {
  const MyControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: ConstrainedBox(
        constraints: BoxConstraints(),
        child: Container(
          color: Colors.red,
          child: const Text('Hello World'),
        ),
      ),
    );
  }
}
