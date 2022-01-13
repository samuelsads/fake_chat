

final List<BotMessage> botMesssage =[
  BotMessage(id: 1, message: "Hello"),
  BotMessage(id: 2, message: "How are you today?"),
  BotMessage(id: 3, message: "What happend?"),
  BotMessage(id: 4, message: "Do you remember me?"),
  BotMessage(id: 5, message: "How old are you?"),
  BotMessage(id: 6, message: "Do you like watch Netflix?"),
  BotMessage(id: 7, message: "Do you like Tacos?"),
];

class BotMessage {
  int id;
  String message;
  

  BotMessage({required this.id, required this.message});
}