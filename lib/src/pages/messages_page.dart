import 'dart:io';

import 'package:fake_chat/src/bloc/chat/chat_bloc_bloc.dart';
import 'package:fake_chat/src/models/users.dart';
import 'package:fake_chat/src/services/burble_service.dart';
import 'package:fake_chat/src/utils/popup_menu_button.dart';
import 'package:fake_chat/src/widgets/burble_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:locally/locally.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
   MessagesPage(
      {Key? key, required this.index, this.pushNotification = false})
      : super(key: key);

  final int index;
  bool pushNotification;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

late TextEditingController _inputBoxChatController;
late FocusNode _focus;
int indexUpdate = 0;
bool updateMessage = false;
late ChatBlocBloc blocDispose;
late Locally locally; 

class _MessagesPageState extends State<MessagesPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    blocDispose = BlocProvider.of<ChatBlocBloc>(context);
    _inputBoxChatController = TextEditingController();
    locally = Locally(
        context: context,
        payload: 'test',
        pageRoute: MaterialPageRoute(
            builder: (context) =>
                MessagesPage(index: 0, pushNotification: true)),
        appIcon: 'mipmap/ic_launcher',
      );
    _focus = FocusNode();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _inputBoxChatController.dispose();
    _focus.dispose();
    blocDispose.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      locally.show(title: "I miss you", message: "Please chat with me :(");
      setState(() {
        
      });
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    bool pushNotification = widget.pushNotification;
    final bloc = BlocProvider.of<ChatBlocBloc>(context);
    if (pushNotification) {
      BurbleMessage burble = _ManualChatBotMessage(
          "Thank for chating with me, this message is for push notification :)");
      bloc.addNewMessate(burble);
      burble.animationController.forward();

      pushNotification = false;
    }

    User user = bots[widget.index];
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: _titleAppBar(context, user),
        ),
        body: _body());
  }

  BurbleMessage _ManualChatBotMessage(String message) {
    return BurbleMessage(
        message: message,
        id: '2',
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        ),
        readMessage: false,
        date: DateFormat('hh:mm a').format(DateTime.now()));
  }

  Row _titleAppBar(BuildContext context, User user) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        Container(
          margin: const EdgeInsets.only(right: 5),
          child: Hero(
            tag: user.uuid,
            child: CircleAvatar(
                backgroundColor: user.color,
                child: Text(user.name.substring(0, 2))),
          ),
        ),
        SizedBox(
          width: 100,
          child: Column(
            children: [
              SizedBox(
                  width: 200,
                  child: Text(
                    user.name,
                    textAlign: TextAlign.left,
                  )),
              BlocBuilder<ChatBlocBloc, ChatBlocState>(
                  builder: (context, state) {
                final isRead = state.isRead ?? false;
                return SizedBox(
                    width: 200,
                    child: Text((isRead) ? 'Writing...' : 'Online',
                        style: const TextStyle(fontSize: 15)));
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _body() {
    return BlocBuilder<ChatBlocBloc, ChatBlocState>(builder: (context, state) {
      final data = state.messages ?? [];
      return Column(
        children: [
          Flexible(
              child: ListView.builder(
                  itemCount: data.length,
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final provider = Provider.of<BurbleService>(context);
                    if (data[index].id == "2") {
                      return _PopupMenuButton(provider, index, data);
                    } else {
                      return GestureDetector(
                          onTap: () {
                            indexUpdate = index;
                            updateMessage = true;
                            _inputBoxChatController.text = data[index].message;
                          },
                          child: data[index]);
                    }
                  })),
          const Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            child: _inputBoxChat(),
          )
        ],
      );
    });
  }

  PopupMenuButton<dynamic> _PopupMenuButton(
      BurbleService provider, int index, List<BurbleMessage> data) {
    return PopupMenuButton(
        tooltip: "Press the message to react",
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        itemBuilder: (context) => [
              PopupMenuWidget(
                height: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        icon: const FaIcon(FontAwesomeIcons.thumbsUp),
                        onPressed: () {
                          data[index].icon = FontAwesomeIcons.thumbsUp;
                          data[index].existIcon = true;
                          provider.update = true;
                          Navigator.pop(context, 'add');
                        }),
                    IconButton(
                        icon: const FaIcon(FontAwesomeIcons.grinSquintTears),
                        onPressed: () {
                          data[index].icon = FontAwesomeIcons.grinSquintTears;
                          data[index].existIcon = true;
                          provider.update = true;
                          Navigator.pop(context, 'remove');
                        }),
                    IconButton(
                        icon: const FaIcon(FontAwesomeIcons.surprise),
                        onPressed: () {
                          data[index].existIcon = true;
                          data[index].icon = FontAwesomeIcons.surprise;
                          provider.update = true;
                          Navigator.pop(context, 'remove');
                        }),
                    IconButton(
                        icon: const FaIcon(FontAwesomeIcons.sadTear),
                        onPressed: () {
                          data[index].existIcon = true;
                          data[index].icon = FontAwesomeIcons.sadTear;
                          provider.update = true;
                          Navigator.pop(context, 'remove');
                        }),
                    IconButton(
                        icon: const FaIcon(FontAwesomeIcons.angry),
                        onPressed: () {
                          data[index].existIcon = true;
                          data[index].icon = FontAwesomeIcons.angry;
                          provider.update = true;
                          Navigator.pop(context, 'remove');
                        }),
                  ],
                ),
              ),
            ],
        child: data[index]);
  }

  Widget _inputBoxChat() {
    final bloc = BlocProvider.of<ChatBlocBloc>(context);
    final hasData = bloc.state.hasData;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _inputBoxChatController,
                onSubmitted: _handleSubmit,
                onChanged: (message) {
                  if (message.trim().isNotEmpty) {
                    bloc.hasData(true);
                  } else {
                    bloc.hasData(true);
                  }
                },
                decoration:
                    const InputDecoration.collapsed(hintText: 'Send message'),
                focusNode: _focus,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: (Platform.isIOS)
                  ? CupertinoButton(
                      child: const Text('Send'),
                      onPressed: ((hasData ?? false))
                          ? () =>
                              _handleSubmit(_inputBoxChatController.text.trim())
                          : null)
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                          data: const IconThemeData(color: Colors.blue),
                          child: IconButton(
                              onPressed: ((hasData ?? false))
                                  ? () => _handleSubmit(
                                      _inputBoxChatController.text.trim())
                                  : null,
                              icon: const Icon(
                                Icons.send,
                              )))),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String message) async {
    final bloc = BlocProvider.of<ChatBlocBloc>(context);

    if (updateMessage) {
      _inputBoxChatController.clear();
      _focus.requestFocus();

      bloc.updateMessage(message, indexUpdate, context);
      updateMessage = false;
      indexUpdate = 0;
    } else {
      if (message.trim().isNotEmpty) {
        _inputBoxChatController.clear();
        _focus.requestFocus();
        BurbleMessage burble = BurbleMessage(
            message: message,
            id: '1',
            animationController: AnimationController(
              vsync: this,
              duration: Duration(milliseconds: 500),
            ),
            readMessage: false,
            date: DateFormat('hh:mm a').format(DateTime.now()));

        bloc.addNewMessate(burble);
        bloc.hasData(false);
        bloc.readMessages(AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1500),
        ));
        burble.animationController.forward();
      }
    }
  }
}
