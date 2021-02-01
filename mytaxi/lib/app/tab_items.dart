
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItems{addPost,MyPost,searchPost}

class TabItemData{

  final IconData icon;

  TabItemData(this.icon);

  static Map<TabItems,TabItemData> allTabs ={
    TabItems.addPost :TabItemData(Icons.directions_car),
    TabItems.MyPost: TabItemData(Icons.home),
    TabItems.searchPost: TabItemData(Icons.message_outlined),
  };
}