import 'package:fake_chat/src/bloc/chat/chat_bloc_bloc.dart';
import 'package:fake_chat/src/pages/main_page.dart';
import 'package:fake_chat/src/services/burble_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main(){
runApp(MultiBlocProvider(
  providers: [
    BlocProvider(create: (context)=>ChatBlocBloc())
  ], child: FakeChat()));
}

class FakeChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BurbleService()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fake Chat',
        home: MainPage()
      ),
    );
  }
}