import '../../color/appColors.dart';
import '../../widget/searchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';

class FollowerAndFriendsScreen extends StatefulWidget {
  final int index;

  FollowerAndFriendsScreen({int trans_index = 0}) : index = trans_index;

  @override
  _FollowerAndFriendsScreenState createState() =>
      _FollowerAndFriendsScreenState();
}

class _FollowerAndFriendsScreenState extends State<FollowerAndFriendsScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _currentIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Friends and Followers'),
          bottom: TabBar(
            tabs: [Tab(text: 'Friends'), Tab(text: 'Followers')],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        body: TabBarView(children: [FriendsList(), FollowerList()]),
      ),
    );
  }
}

class FriendsList extends StatefulWidget {
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        SearchBarWidget(
          controller: TextEditingController(),
          onSearch: (query) {
            print('Search query: $query');
          },
          showQrIcon: false,
        ),
        Expanded(
          child: ListView(
            children: [
              FriendListItem(
                username: 'John Doe',
                profileImageUrl: 'https://example.com/profile.jpg',
                onPressed: () {
                  // Handle follow/unfollow logic here
                },
                location: 'Köln',
              ),
              FriendListItem(
                username: 'Jane Smith',
                profileImageUrl: 'https://example.com/profile.jpg',
                onPressed: () {
                  // Handle follow/unfollow logic here
                },
                location: 'Ludwigsburg',
              ),
              // Add more friend list items as needed
            ],
          ),
        ),
      ],
    );
  }
}

class FriendListItem extends StatelessWidget {
  final String username;
  final String profileImageUrl;
  final String location;
  final VoidCallback onPressed;

  FriendListItem({
    required this.username,
    required this.profileImageUrl,
    required this.location,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(profileImageUrl)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(username),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, size: 16),
              SizedBox(width: 4),
              Text(location),
            ],
          ),
        ],
      ),
      trailing: ElevatedButton(onPressed: onPressed, child: Text('Add')),
    );
  }
}

class FollowerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        SearchBarWidget(
          controller: TextEditingController(),
          onSearch: (query) {
            print('Search query: $query');
          },
          showQrIcon: false,
        ),
        Expanded(
          child: ListView(
            children: [
              FollowerListItem(
                username: 'John Doe',
                profileImageUrl: 'https://example.com/profile.jpg',
                onPressed: () {},
                location: 'Köln',
              ),
              FollowerListItem(
                username: 'Jane Smith',
                profileImageUrl: 'https://example.com/profile.jpg',
                onPressed: () {},
                location: 'Ludwigsburg',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FollowerListItem extends StatelessWidget {
  final String username;
  final String profileImageUrl;
  final String location;
  final VoidCallback onPressed;

  FollowerListItem({
    required this.username,
    required this.profileImageUrl,
    required this.location,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(profileImageUrl)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(username),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, size: 16),
              SizedBox(width: 4),
              Text(location),
            ],
          ),
        ],
      ),
      trailing: ElevatedButton(onPressed: onPressed, child: Text('Remove')),
    );
  }
}
