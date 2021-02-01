import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytaxi/app/tab_items.dart';


class MyBottomNavBar extends StatelessWidget {
  final TabItems currentTab;
  final ValueChanged<TabItems> onSelectedTab;
  const MyBottomNavBar({Key key, this.currentTab, this.onSelectedTab, this.createTab, this.navigatorKeys}) : super(key: key);

  final Map<TabItems,Widget> createTab;
  final Map<TabItems,GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar:CupertinoTabBar(
        items: [
          _navItem(TabItems.addPost),
          _navItem(TabItems.MyPost),
          _navItem(TabItems.searchPost),
        ],
        backgroundColor: Colors.yellow,
        onTap: (index)=>onSelectedTab(TabItems.values[index]),
      ),
      tabBuilder: (context,index){
        final gosterilecekItem=TabItems.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[gosterilecekItem],
          builder: (context){
            return createTab[gosterilecekItem];
          },
        );
      },
    );
  }
  BottomNavigationBarItem _navItem(TabItems tabItems){
    final createTab= TabItemData.allTabs[tabItems];
    return  BottomNavigationBarItem(
      icon: Icon(createTab.icon,color: Colors.black,),
    );

  }
}
