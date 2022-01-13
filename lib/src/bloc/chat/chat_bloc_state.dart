part of 'chat_bloc_bloc.dart';

class ChatBlocState extends Equatable {
  
  final List<BurbleMessage>? messages;
  final bool? hasData;
  final bool? isRead;

  const ChatBlocState({messages, this.hasData, this.isRead}): messages =messages ??const  [];

  ChatBlocState copyWith({
    List<BurbleMessage>? messages,
    bool?hasData,
    bool? isRead,
  })=>ChatBlocState(
    messages:messages??this.messages,
    hasData: hasData??this.hasData,
    isRead: isRead??this.isRead,
  );
  @override
  List<Object?> get props => [this.messages, this.hasData, this.isRead];
}


