import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../state/bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';
class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          centerTitle: true,
          title: Text('Number Trivia'),
        ),
      body: BlocProvider(
        create:(_)=> sl<NumberTriviaBloc>(),
        child: SingleChildScrollView(child: buildBody(context)),
        
        )
    );
  }

 Widget buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            BlocBuilder<NumberTriviaBloc ,NumberTriviaState>(
            builder: (BuildContext context,NumberTriviaState state){
              if(state is Empty) {
                return  MessageDisplay(message :'start searching');
              }else if (state is Error){
                return MessageDisplay(message: state.errorMessage);
              }else if (state is Loading) {
                return LoadingIndicator();
              }else if (state is Loaded){
                return TriviaDisplay(trivia : state.trivia);
              }
              
            },),
            SizedBox(
              height: 20,
            ),
            TriviaControls()
          ],
        ),
      ),
    );
  }
}
