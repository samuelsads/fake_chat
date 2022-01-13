import 'package:fake_chat/src/models/users.dart';
import 'package:fake_chat/src/pages/messages_page.dart';
import 'package:flutter/material.dart';
import 'package:locally/locally.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}


late RefreshController _refresh ;

class _ChatPageState extends State<ChatPage> {


@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    Locally locally = Locally(
          context: context,
          payload: 'test',
          pageRoute: MaterialPageRoute(builder: (context) => MessagesPage(index:0,pushNotification:true )),
          appIcon: 'mipmap/ic_launcher',
      );

      locally.show(title: "Chat with me", message: "Please chat with me");
    super.didChangeDependencies();
  }
  @override
  void initState() {
    _refresh= RefreshController(initialRefresh: false);
    super.initState();
  }
  @override
  void dispose() {
    _refresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: const UsersList(),
    );
  }
}

class UsersList extends StatelessWidget {
  const UsersList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


  
    return SmartRefresher(
      controller: _refresh,
      enablePullDown: true,
      onRefresh: _loadInformation,
      header: const WaterDropHeader(
        complete: Icon(Icons.check, color: Colors.green),
        waterDropColor: Colors.green,
      ),
      child: const _ListView(),
    );
  }
  
}


class _ListView extends StatelessWidget {
  const _ListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: bots.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) =>
            _Users(user: bots[index], index: index));
  }
}

class _Users extends StatelessWidget {
  const _Users({
    Key? key,
    required this.user,
    required this.index,
  }) : super(key: key);
  final User user;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag:user.uuid,
        child: CircleAvatar(
          backgroundColor: user.color,
          child: Text(user.name.substring(0, 2)),
        ),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: (user.status) ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(10)),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => MessagesPage(index: index))),
    );
  }
}

void _loadInformation() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refresh.refreshCompleted();
  }