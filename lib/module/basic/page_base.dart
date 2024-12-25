import 'dart:async';

import 'package:dongjue_application/controls/clickable_text_field.dart';
import 'package:dongjue_application/controls/combobox.dart';
import 'package:dongjue_application/extensions/date_time.dart';
import 'package:dongjue_application/orm/enums.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

abstract class PageBase extends StatefulWidget {
  const PageBase({super.key});

  bool canEdit(DocumentStatus state) {
    return state == DocumentStatus.unapproved;
  }
}

extension PageBaseExtension on PageBase {}

class ControlPositionInfo {
  final double x;
  final double y;
  final double? width;
  final double minWidth;
  final double minHeight;
  final double maxWidth;
  final double maxHeight;

  ControlPositionInfo({this.x = 0, this.y = 0, this.width, this.minWidth = 0.0, this.minHeight = 0.0, this.maxWidth = double.infinity, this.maxHeight = double.infinity});
}

class TitleControlInfo extends ControlPositionInfo {
  final String title;

  TitleControlInfo({this.title = '', super.x, super.y, super.width, super.minWidth, super.minHeight, super.maxWidth, super.maxHeight});
}

class TextBoxInfo extends TitleControlInfo {
  final TextEditingController controller;
  bool readOnly;
  Function? onChanged;

  TextBoxInfo(
      {super.title,
      super.x,
      super.y,
      super.width,
      super.minWidth,
      super.minHeight,
      super.maxWidth,
      super.maxHeight,
      required this.controller,
      this.readOnly = false,
      this.onChanged});
}

class ButtonInfo extends ControlPositionInfo {
  final String content;
  final bool isEnable;
  final Function? onPressed;

  ButtonInfo({this.isEnable = true, this.onPressed, super.x, super.y, super.width, super.minWidth, super.minHeight, super.maxWidth, super.maxHeight, this.content = ''});
}

class DateTimePickerInfo extends TitleControlInfo {
  DateTime? value;
  Function? onChanged;

  DateTimePickerInfo({this.value, this.onChanged, super.title, super.x, super.y, super.width, super.minWidth, super.minHeight, super.maxWidth, super.maxHeight});
}

abstract class IComboBoxInfo {
  List<MyComboBoxItem> get g_items;
  set g_items(List value);

  get g_selectedItem;
  set g_selectedItem(dynamic value);

  OnChangedDynamicDelegate? get g_onChanged;
  set g_onChanged(OnChangedDynamicDelegate? value);

  ComboBoxDisplayTextGetter get g_displayTextGetter;
  set g_displayTextGetter(ComboBoxDisplayTextGetter value);

  ComboBoxValueGetter get g_valueGetter;
  set g_valueGetter(ComboBoxValueGetter value);
}

typedef OnChangedDynamicDelegate = void Function(dynamic oldValue, dynamic newValue, int oldIndex, int newIndex);
typedef OnChangedDelegate<T> = void Function(T oldValue, T newValue, int oldIndex, int newIndex);

class ComboBoxInfo<T> extends ControlPositionInfo implements IComboBoxInfo {
  List<MyComboBoxItem> items;
  T? selectedItem;
  OnChangedDelegate? onChanged;
  final int selectedIndex;
  ComboBoxDisplayTextGetter displayTextGetter;
  ComboBoxValueGetter valueGetter;

  ComboBoxInfo(
      {required this.displayTextGetter,
      required this.valueGetter,
      required this.items,
      this.selectedItem,
      this.onChanged,
      this.selectedIndex = -1,
      super.x,
      super.y,
      super.width,
      super.minWidth,
      super.minHeight,
      super.maxWidth,
      super.maxHeight});

  @override
  List<MyComboBoxItem> get g_items => items;

  @override
  set g_items(List value) {
    items = value as List<MyComboBoxItem>;
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

  @override
  ComboBoxDisplayTextGetter get g_displayTextGetter => displayTextGetter;

  @override
  set g_displayTextGetter(ComboBoxDisplayTextGetter value) {
    displayTextGetter = value as ComboBoxDisplayTextGetter;
  }

  @override
  ComboBoxValueGetter get g_valueGetter => valueGetter;

  @override
  set g_valueGetter(ComboBoxValueGetter value) {
    valueGetter = value as ComboBoxValueGetter;
  }
}

extension TextBoxInfoExtension on TextBoxInfo {
  TextField CreateControl(TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: const InputDecoration(
        // contentPadding: EdgeInsets.zero, // 移除所有 padding
        contentPadding: EdgeInsets.only(left: 4, right: 4),
        // border: InputBorder.none, // 移除边框
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        isDense: true, // 减少 TextField 的高度
      ),
      onChanged: (value) {
        onChanged?.call(value);
      },
    );
  }
}

class MyControl extends StatelessWidget {
  final ControlPositionInfo controlPositionInfo;

  const MyControl({super.key, required this.controlPositionInfo});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        var mainContent = Builder(builder: (context) {
          if (controlPositionInfo is TextBoxInfo) {
            var info = controlPositionInfo as TextBoxInfo;
            return info.CreateControl(info.controller);
          } else if (controlPositionInfo is ButtonInfo) {
            var info = controlPositionInfo as ButtonInfo;
            return ElevatedButton(
              onPressed: () {
                print("按钮按下");
              },
              child: Text(info.content),
            );
          } else if (controlPositionInfo is DateTimePickerInfo) {
            var info = controlPositionInfo as DateTimePickerInfo;
            info.value = DateTime.now().dateOnly;
            var textEditingController = TextEditingController(text: info.value?.formatDate());
            return ClickableTextField(
              controller: textEditingController,
              onTap: () async {
                var result = await showDateTimePickerDialog(context);
                if (result != null) {
                  info.value = result;
                  textEditingController.text = info.value!.formatDate();
                  info.onChanged?.call(info.value!);
                }
              },
            );
          } else if (controlPositionInfo is IComboBoxInfo) {
            var info = controlPositionInfo as IComboBoxInfo;
            return MyCombobox(
              items: info.g_items,
            );
          }

          return Container();
        });
        if (controlPositionInfo is TitleControlInfo) {
          var info = controlPositionInfo as TitleControlInfo;
          return Flex(
            direction: Axis.horizontal,
            children: [
              Text(
                info.title,
              ),
              Expanded(child: mainContent),
            ],
          );
          // return mainContent;
        } else {
          return mainContent;
        }
      },
    );
  }
}

/// 日期时间选择器
Future<DateTime?> showDateTimePickerDialog(BuildContext context) async {
  DateTime? value;
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('日期时间选择'),
        content: SizedBox(
            width: 300,
            height: 300,
            child: SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.single,
              onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                value = dateRangePickerSelectionChangedArgs.value;
              },
            )),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                value,
              );
            },
            child: const Text('确定'),
          ),
        ],
      );
    },
  );
}
