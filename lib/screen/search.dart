import 'package:flutter/material.dart';
import 'package:simpleapp/components/appbar.dart';
//import 'package:simpleapp/components/appbar.dart';
// import 'package:simpleapp/components/background_grad.dart';
import 'package:simpleapp/components/bottomnav.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBarFb1(
        title: 'Flutter Bricks',
      ),
      body: Stack(
        children: [
          // Search Bar
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: SearchInput(
              textController: textController,
              hintText: 'Search here...',
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBarFb2(
        currentIndex: 1,
      ),
    );
  }
}

// Search Bar Component (Same as before)
class SearchInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;

  const SearchInput(
      {required this.textController, required this.hintText, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1),
          ),
        ],
      ),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_sharp, color: Color(0xff4338CA)),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
  }
}
