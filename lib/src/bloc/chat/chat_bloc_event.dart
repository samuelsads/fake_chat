part of 'chat_bloc_bloc.dart';

abstract class ChatBlocEvent extends Equatable {
  const ChatBlocEvent();

  @override
  List<Object> get props => [];
}

class ChatBlocInformationEvent extends ChatBlocEvent{
  final List<BurbleMessage>? messages;
  final bool? hasData;
  final bool? isRead;

  const ChatBlocInformationEvent({this.messages, this.hasData, this.isRead});
}
