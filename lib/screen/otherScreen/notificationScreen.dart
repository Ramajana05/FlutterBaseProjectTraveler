import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildFriendInvitations(),
          SizedBox(height: 20.0),
          _buildNewFollowers(),
          // Add more notification items here
        ],
      ),
    );
  }

  Widget _buildFriendInvitations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(2, (index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.person),
          ),
          title: Text('Friend Request'),
          subtitle: Text('John Doe sent you a friend request.'),
          trailing: ElevatedButton(
            onPressed: () {
              // Accept friend request logic
            },
            child: Text('Accept'),
          ),
        );
      }),
    );
  }

  Widget _buildNewFollowers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(5, (index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(Icons.person),
          ),
          title: Text('New Follower'),
          subtitle: Text('Jane Smith started following you.'),
        );
      }),
    );
  }
}
