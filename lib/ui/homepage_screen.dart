import 'package:bestplayer/ui/chat/chat.dart';
import 'package:bestplayer/ui/home/home.dart';
import 'package:bestplayer/ui/order/order.dart';
import 'package:bestplayer/ui/profile/profile.dart';
import 'package:flutter/material.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  int _currentIndex = 0;

  final tabs = [
    HomeScreen(),
    ChatScreen(),
    OrderScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: (_currentIndex == 0) ? Color(0xFFD94555) : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_outlined,
              color: (_currentIndex == 1) ? Color(0xFFD94555) : Colors.grey,
            ),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment_outlined,
              color: (_currentIndex == 2) ? Color(0xFFD94555) : Colors.grey,
            ),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: (_currentIndex == 3) ? Color(0xFFD94555) : Colors.grey,
            ),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Color(0xFFD94555),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: tabs[_currentIndex],
    );
  }
}
