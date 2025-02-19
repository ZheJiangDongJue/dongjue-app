import 'package:dongjue_application/controls/selector.dart';
import 'package:dongjue_application/controls/text_button_like.dart';
import 'package:flutter/material.dart';

typedef ItemWidgetBuilder = Widget Function(dynamic item);
typedef ItemTextGetterDelegate = String Function(dynamic item);

class ItemSelectorButton extends StatefulWidget {
  ItemSelectorButton({
    super.key,
    this.text = '',
    required this.items,
    required this.itemWidgetBuilder,
    required this.onSelected,
    required this.itemTextGetter,
    this.pageTitle = '选择',
    this.border,
  });

  String text;
  List<dynamic> items;
  ItemWidgetBuilder itemWidgetBuilder;
  Function onSelected;
  ItemTextGetterDelegate itemTextGetter;
  final String pageTitle;
  Border? border;

  @override
  State<ItemSelectorButton> createState() => _ItemSelectorButtonState();

  static Widget noneBorder({
    Key? key,
    void Function()? onTap,
    void Function(String)? onChanged,
    TextEditingController? controller,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class _ItemSelectorButtonState extends State<ItemSelectorButton> {
  SelectorPage? selectorPage;

  @override
  void initState() {
    super.initState();

    selectorPage = SelectorPage(
      title: widget.pageTitle,
      items: widget.items.map((item) {
        return SelectorItem(
          value: item,
          child: widget.itemWidgetBuilder.call(item),
        );
      }).toList(),
      check: (item, str) {
        if (item is Map) {
          for (var element in item.values) {
            if (element is String) {
              if (element.contains(str)) {
                return true;
              }
            }
          }
        }
        return false;
      },
      onTap: (item, index) {
        Navigator.pop(context, item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    selectorPage?.items = widget.items.map((item) {
      return SelectorItem(
        value: item,
        child: widget.itemWidgetBuilder.call(item),
      );
    }).toList();
    return TextButtonLike(
      text: widget.text,
      border: widget.border,
      onPressed: () async {
        var item = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => selectorPage!,
          ),
        );

        widget.onSelected.call(item);
        if (item != null) {
          setState(() {
            widget.text = widget.itemTextGetter.call(item);
          });
        }
      },
    );
  }
}
