import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fake_chat/src/models/bot.dart';
import 'package:fake_chat/src/services/burble_service.dart';
import 'package:fake_chat/src/widgets/burble_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

part 'chat_bloc_event.dart';
part 'chat_bloc_state.dart';

class ChatBlocBloc extends Bloc<ChatBlocEvent, ChatBlocState> {
  ChatBlocBloc() : super(ChatBlocState()) {
    on<ChatBlocInformationEvent>((event, emit) => emit(state.copyWith(
        messages: event.messages,
        hasData: event.hasData,
        isRead: event.isRead)));
  }

  Future<void> updateMessage(
      String message, int position, BuildContext context) async {
    List<BurbleMessage> data = [...state.messages ?? []];

    data[position].message = message;
    Provider.of<BurbleService>(context, listen: false).update = true;
    add(ChatBlocInformationEvent(messages: data));
  }

  Future<void> readMessages(AnimationController animation) async {
    add(const ChatBlocInformationEvent(isRead: true));

    Random rnd;
    int min = 0;
    int max = 7;
    rnd = Random();
    final r = min + rnd.nextInt(max - min);

    await Future.delayed(const Duration(milliseconds: 1500));
    List<BurbleMessage> data = [...state.messages ?? []];
    BurbleMessage burble = BurbleMessage(
        message: botMesssage[r].message,
        id: '2',
        animationController: animation,
        readMessage: false,
        date: DateFormat('hh:mm a').format(DateTime.now()));
    data.insert(0, burble);

    for (var element in data) {
      element.readMessage = true;
    }
    add(ChatBlocInformationEvent(messages: data, isRead: false));
    burble.animationController.forward();
  }

  Future<void> hasData(bool data) async {
    add(ChatBlocInformationEvent(hasData: data));
  }

  Future<void> addNewMessate(BurbleMessage burble) async {
    List<BurbleMessage> data = [...state.messages ?? []];

    data.insert(0, burble);
    add(ChatBlocInformationEvent(messages: data));
  }

  Future<void> dispose() async {
    List<BurbleMessage> data = [...state.messages ?? []];
    for (BurbleMessage message in data) {
      message.animationController
        ..stop()
        ..dispose();
    }
    add(const ChatBlocInformationEvent(
        messages: [], hasData: false, isRead: false));
  }
}
