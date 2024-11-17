import 'package:flutter/material.dart';

class KelontongTabs extends StatefulWidget {
  final List<String> categories;
  final Function(String) onCategorySelected;

  const KelontongTabs({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  _KelontongTabsState createState() => _KelontongTabsState();
}

class _KelontongTabsState extends State<KelontongTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.categories.length, vsync: this);

    // Listener untuk mendeteksi perubahan tab
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onCategorySelected(widget.categories[_tabController.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TabBar
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: widget.categories
              .map((category) => Tab(
                    text: category,
                  ))
              .toList(),
        ),
      ],
    );
  }
}
