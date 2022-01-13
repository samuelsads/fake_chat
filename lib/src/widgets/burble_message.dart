import 'package:fake_chat/src/services/burble_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BurbleMessage extends StatelessWidget {
  BurbleMessage(
      {Key? key,
      required this.message,
      required this.id,
      required this.animationController,
      required this.readMessage,
      required this.date,
      this.position,
      this.icon, 
      this.existIcon=false})
      : super(key: key);

  String message;
  final String id;
  final AnimationController animationController;
  bool readMessage = false;
  final String date;
  int? position;
  IconData? icon;
  bool existIcon;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      child: FadeTransition(
        opacity: animationController,
        child: Container(
          child:
              (id == '1') ? _myMessage(context) : _yourMessage(context, position ?? 0, icon,existIcon),
        ),
      ),
    );
  }

  Widget _myMessage(BuildContext context) {
    Provider.of<BurbleService>(context);
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4, left: 50, right: 4),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 50),
              child: Text(message,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.black,
                  )),
            ),
            Container(
              alignment: Alignment.bottomRight,
              width: 65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  Container(
                      padding: const EdgeInsets.only(right: 2),
                      child: Text(
                        date,
                        style: const TextStyle(fontSize: 9),
                      )),
                  FaIcon(FontAwesomeIcons.checkDouble,
                      size: 9,
                      color: (readMessage) ? Colors.blue : Colors.black)
                ],
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: const Color(0xffD3F8C2),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _yourMessage(BuildContext context, int index, IconData? icon, bool existIcon) {
    
    return Stack(
      children: [_yourMessageBody(), _yourMessageIcon(context, index, icon, existIcon)],
    );
  }

  Align _yourMessageBody() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4, left: 4, right: 50),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 40),
              child: Text(message,
                  style: const TextStyle(
                    color: Colors.black54,
                  )),
            ),
            SizedBox(
              width: 60,
              child: Text(
                date,
                textAlign: TextAlign.right,
                style:const  TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _yourMessageIcon(BuildContext context, int index, IconData? icon, bool existIcon) {
    Provider.of<BurbleService>(context);
    if (existIcon) {
      return Positioned(
        bottom: 0,
        left: 5,
        child: FaIcon(
          icon,
          size: 13,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
