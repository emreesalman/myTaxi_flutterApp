import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytaxi/UI/addpost.dart';
import 'package:mytaxi/UI/dm.dart';
import 'package:mytaxi/UI/homepage_tab.dart';
import 'package:mytaxi/UI/my_posts.dart';
import 'package:mytaxi/UI/searchpost.dart';
import 'package:mytaxi/app/custom_bottom_navbar.dart';
import 'package:mytaxi/app/tab_items.dart';




class homePageView extends StatefulWidget {
  @override
  _homePageViewState createState() => _homePageViewState();

}

class _homePageViewState extends State<homePageView> {

  TabItems _currentTab;

  Map<TabItems,GlobalKey<NavigatorState>> navigatorKeys ={
    TabItems.addPost:GlobalKey<NavigatorState>(),
    TabItems.MyPost:GlobalKey<NavigatorState>(),
    TabItems.searchPost:GlobalKey<NavigatorState>(),
  };

  Map<TabItems, Widget>allPages (){
    return {
        TabItems.addPost: addPostView(),
        TabItems.MyPost:MyPosts(),
        TabItems.searchPost: searchPostView(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyBottomNavBar(navigatorKeys: navigatorKeys,createTab: allPages(),currentTab: _currentTab,
        onSelectedTab: (secilenTab){
        if(secilenTab==_currentTab){
          navigatorKeys[secilenTab].currentState.popUntil((route) => route.isFirst);
        }
        else{
          setState(() {
            _currentTab=secilenTab;
          });
        }
      },
      ),
    );
  }
}

