
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WhatsApp Clone',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          tabBarTheme: TabBarTheme(
            // 这将改变 TabBar 的指示器（下划线）颜色
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.teal,
                  width: 2.0,
                ),
              ),
            ),
            // 这将改变 TabBar 选中的标签文字颜色
            labelColor: Colors.teal,
            // 这将改变未选中的标签文字颜色
            unselectedLabelColor: Colors.grey,
          ),
        ),
        home: Home(),
      ),
    );

class Home extends StatelessWidget {
  void _doNothing() {}

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     leading: IconButton(
    //       icon: Icon(Icons.menu),
    //       onPressed: _doNothing,
    //     ),
    //     title: Text('Whatsapp'),
    //     actions: <Widget>[
    //       IconButton(
    //         icon: Icon(Icons.search),
    //         onPressed: _doNothing,
    //       ),
    //       IconButton(
    //         icon: Icon(Icons.message),
    //         onPressed: _doNothing,
    //       ),
    //       IconButton(
    //         icon: Icon(Icons.more_vert),
    //         onPressed: _doNothing,
    //       ),
    //     ],
    //   ),
    // );

    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: _doNothing,
          ),
          title: Text('whatsapp'),
          actions: <Widget>[
            IconButton(onPressed: _doNothing, icon: Icon(Icons.search)),
            IconButton(onPressed: _doNothing, icon: Icon(Icons.message)),
            IconButton(onPressed: _doNothing, icon: Icon(Icons.more_vert)),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'CALLS', icon: Icon(Icons.call)),
              Tab(text: 'CHATS', icon: Icon(Icons.chat)),
              Tab(text: 'CONTACTS', icon: Icon(Icons.contacts)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
                color: Colors.white, child: Center(child: Text('Call Tab'))),
            Container(
                color: Colors.white, child: Center(child: Text('Chats Tab'))),
            Container(
                color: Colors.white, child: Center(child: Text('Contact Tab'))),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _doNothing,
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(text: 'calls', icon: Icon(Icons.call)),
            Tab(text: 'chats', icon: Icon(Icons.chat)),
            Tab(text: 'contacts', icon: Icon(Icons.contacts)),
          ],
          labelColor: Colors.black,
        ),
      ),
    );

    // return DefaultTabController(
    //   length: 3,
    //   initialIndex: 1,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       // AppBar里面应该是TabBar，不是TabBarView
    //       bottom: TabBar(
    //         tabs: [
    //           Tab(text: 'CALLS', icon: Icon(Icons.call)),
    //           Tab(text: 'CHATS', icon: Icon(Icons.chat)),
    //           Tab(text: 'CONTACTS', icon: Icon(Icons.contacts)),
    //         ],
    //       ),
    //     ),
    //     // Scaffold的body属性应该定义TabBarView
    //     body: TabBarView(
    //       children: [
    //         Container(
    //             color: Colors.pink, child: Center(child: Text('Call Tab'))),
    //         Container(
    //             color: Colors.white, child: Center(child: Text('Chats Tab'))),
    //         Container(
    //             color: Colors.amber, child: Center(child: Text('Contact Tab'))),
    //       ],
    //     ),
    //   ),
    // );
  }
}
