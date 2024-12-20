import 'package:flutter/material.dart';

typedef SelectorItemOnTapDelegate<T> = void Function(T item, int index);
typedef CheckDelegate<T> = bool Function(T item, String str);

class SelectorPage extends StatefulWidget {
  SelectorPage(
      {super.key, required this.items, this.onChanged, this.check, this.onTap,required this.title});
  final String title;
  List<SelectorItem> items;
  Function? onChanged;
  CheckDelegate? check;

  SelectorItemOnTapDelegate? onTap;

  @override
  State<SelectorPage> createState() => _SelectorPageState();
}

class _SelectorPageState extends State<SelectorPage> {
  TextEditingController searchInputController = TextEditingController();
  List<SelectorItem> filtedItems = [];

  @override
  void initState() {
    super.initState();
    filtedItems = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), //标题
      ),
      body: Column(
        children: [
          Stack(children: [
            //Stack是一个层叠布局,要说理解起来,从上到下的代码就是一条条的桌布,你会从上到下一条一条盖在桌子上,最后一张桌布会盖住所有的桌布,所以最后一张桌布的代码会写在最下面
            TextField(
              controller: searchInputController,
              decoration: const InputDecoration(
                hintText: '请输入搜索内容',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Positioned(
                right: 0,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        filtedItems = widget.items.where((item) {
                          return widget.check?.call(
                                  item.value, searchInputController.text) ??
                              true;
                        }).toList();
                      });
                    },
                    icon: const Icon(Icons.filter_alt)))
          ]),
          Expanded(
            child: ListView.builder(
              itemCount: filtedItems.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    widget.onTap?.call(filtedItems[index].value, index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: filtedItems[index].child,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SelectorItem<T> extends StatelessWidget {
  const SelectorItem({super.key, required this.value, required this.child});

  final T value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
