import '../../color/appcolors.dart';
import 'package:flutter/material.dart';
import '../color/appColors.dart';

class TabBarWidget extends StatefulWidget {
  final List<String> tabTexts;
  final Color labelColor;
  final Color indicatorColor;
  final Color unselectedLabelColor;
  final TextStyle labelStyle;
  final Function(int) onTabSelected;

  const TabBarWidget({
    Key? key,
    required this.tabTexts,
    this.labelColor = Colors.black26,
    this.unselectedLabelColor = Colors.black26,
    this.indicatorColor = Colors.black,
    this.labelStyle = const TextStyle(fontWeight: FontWeight.bold),
    required this.onTabSelected,
  }) : super(key: key);

  @override
  _TabBarWidgetState createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabTexts.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onTabSelected(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showTabMessage(int tabIndex) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tab ${tabIndex + 1} pressed'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Material(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(),
        child: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: widget.indicatorColor, width: 2.0),
            ),
          ),
          unselectedLabelColor: widget.unselectedLabelColor,
          labelPadding: EdgeInsets.symmetric(
            horizontal: screenWidth / (4 * widget.tabTexts.length),
          ),
          tabs: List.generate(
            widget.tabTexts.length,
            (index) => GestureDetector(
              onTap: () {
                widget.onTabSelected(index);
                _tabController.index = index;
              },
              child: Tab(
                child: Text(
                  widget.tabTexts[index],
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
