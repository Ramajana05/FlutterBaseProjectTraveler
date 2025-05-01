import 'package:flutter/material.dart';
import '../../design/topNavBarDecoration.dart';
import '../../color/appColors.dart';

class TopNavBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final IconData? trailingIcon1;
  final VoidCallback? trailingOnPressed1;
  final IconData? trailingIcon2;
  final VoidCallback? trailingOnPressed2;
  final Widget? trailingWidget1;
  final Widget? trailingWidget2;

  const TopNavBar({
    Key? key,
    required this.title,
    this.trailingIcon1,
    this.trailingOnPressed1,
    this.trailingIcon2,
    this.trailingOnPressed2,
    this.trailingWidget1,
    this.trailingWidget2,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  _TopNavBarState createState() => _TopNavBarState();
}

class _TopNavBarState extends State<TopNavBar>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;

    final Color iconColor = brightness == Brightness.dark
        ? const Color.fromARGB(255, 255, 255, 255)
        : const Color.fromARGB(255, 0, 0, 0);

    return SafeArea(
      child: AppBar(
        title: Text(
          widget.title,
          style: topNavBarDecoration.getTitleTextStyle().copyWith(fontSize: 25),
        ),
        centerTitle: false,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            decoration: topNavBarDecoration.getBoxDecoration(),
            height: 0.0,
          ),
        ),
        leading: null,
        automaticallyImplyLeading: false,
        actions: [
          if (widget.trailingIcon1 != null || widget.trailingWidget1 != null)
            IconButton(
              icon: widget.trailingIcon1 != null
                  ? Icon(
                      widget.trailingIcon1,
                      size: 25,
                      color: iconColor,
                    )
                  : widget.trailingWidget1 ?? Container(),
              onPressed: widget.trailingOnPressed1,
            ),
          if (widget.trailingIcon2 != null || widget.trailingWidget2 != null)
            IconButton(
              icon: widget.trailingIcon2 != null
                  ? Icon(
                      widget.trailingIcon2,
                      size: 25,
                      color: iconColor,
                    )
                  : widget.trailingWidget2 ?? Container(),
              onPressed: widget.trailingOnPressed2,
            ),
        ],
      ),
    );
  }
}
