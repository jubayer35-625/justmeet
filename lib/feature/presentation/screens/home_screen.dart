import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_entity.dart';
import '../cubit/auth/auth_dart_cubit.dart';
import '../pages/calls_page.dart';
import '../pages/camera_page.dart';
import '../pages/chat_page.dart';
import '../pages/status_page.dart';
import '../widgets/custom_tab_bar.dart';
import '../widgets/theme/style.dart';



class HomeScreen extends StatefulWidget {
  final UserEntity userInfo;

  const HomeScreen({required Key? key, required this.userInfo}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var x;
  bool _isSearch = false;
  int _currentPageIndex = 1;
  PageController _pageViewController = PageController(initialPage: 1);
  List<Widget> get _pages => [
    const CameraPage(),
    ChatPage(userInfo: widget.userInfo, key: null,),
    const StatusPage(),
    const CallsPage(),
  ];

  _buildSearch() {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(top: 25),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(.3),
            spreadRadius: 1,
            offset: const Offset(0.0, 0.50))
      ]),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search...",
          prefixIcon: InkWell(
            onTap: () {
              //TODO:
              setState(() {
                _isSearch = false;
              });
            },
            child: const Icon(Icons.arrow_back),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentPageIndex !=0?AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: _isSearch == false ? primaryColor : Colors.transparent,
        title: _isSearch == false
            ? const Text("WhatsApp Clone")
            : const SizedBox(
          height: 0.0,
          width: 0.0,
        ),
        flexibleSpace: _isSearch == false
            ? SizedBox(
          height: 0.0,
          width: 0.0,
        )
            : _buildSearch(),
        actions: <Widget>[
          InkWell(
              onTap: () {
                setState(() {
                  _isSearch = true;
                });
              },
              child: const Icon(Icons.search)),
          const SizedBox(
            width: 5,
          ),
          InkWell(onTap: (){
            BlocProvider.of<AuthCubit>(context).loggedOut();
          },child: const Icon(Icons.more_vert))
        ],
      ):null,
      body: Column(
        children: <Widget>[
          //TODO:CustomTabBar
          _isSearch == false
              ? _currentPageIndex != 0
              ? CustomTabBar(index: _currentPageIndex, key: null,)
              : Container(height: 0.0, width: 0.0,)
              : Container(
            height: 0.0,
            width: 0.0,
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: const Icon(Icons.more_vert),
              isDense: true,
              onChanged:  Onchange,
              isExpanded: false,
              items: [
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: _pages.length,
              controller: _pageViewController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (_, index) {
                return _pages[index];
              },
            ),
          )
        ],
      ),
    );
  }
  Onchange(value){
    x="halo";
  }
}