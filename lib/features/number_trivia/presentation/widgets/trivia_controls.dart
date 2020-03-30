import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/bloc/number_trivia_bloc.dart';

final TextEditingController controller = TextEditingController(); 
class TriviaControls extends StatelessWidget {
  
  String inputStr ;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children : [
        TextField(
          controller: controller,
          decoration : InputDecoration(
            border : OutlineInputBorder(),
            hintText :'Input a number',
          ),
          onSubmitted: (value){
            _dispatchConcrete(context);
            controller.clear();
          },
          keyboardType: TextInputType.number,
          onChanged : (value){
            inputStr = value ;
          }
        ),
        SizedBox(
          height: 10,
        ),
        Row(children: <Widget>[
          Expanded(child: RaisedButton(onPressed: (){
            _dispatchConcrete(context);
            controller.clear();
          },
          child: Text('Search'),
          textTheme: ButtonTextTheme.primary,
          color: Theme.of(context).accentColor,
          )),
          SizedBox(
          width: 10,
        ),
          Expanded(child: RaisedButton(onPressed:(){
            _dispatchRandom(context);
            controller.clear();
          },
          child: Text('Get Random trivia'),
          textTheme: ButtonTextTheme.normal,
          color: Colors.grey,
          ))
        ],)
      ]
    );
  }
  void _dispatchConcrete(BuildContext context) {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumberEvent(numberString :inputStr));
  }
   void _dispatchRandom(BuildContext context) {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumberEvent());
  }
}




