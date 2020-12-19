

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController=TextEditingController();

  final amountController=TextEditingController();

  DateTime _selectedDate;


  void SubmitData(){
  
    final enteredTitle= this.titleController.text;
    final enteredAmount=double.parse(this.amountController.text);
    if(enteredAmount ==null)return;
    if(enteredTitle.isEmpty || enteredAmount <=0 || _selectedDate==null) return;

    this.widget.addTransaction(
      enteredTitle,enteredAmount,_selectedDate
        );

  }
  
  void _presentDatePicker(){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate){
        if(pickedDate==null){
          return;
        }

        setState(() {

          _selectedDate=pickedDate;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom+10
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(decoration: InputDecoration(
                  labelText: 'Title'
              ),
                controller: titleController,

              ),
              TextField(decoration: InputDecoration(
                  labelText: 'Amount'
              ),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_)=>SubmitData(),

              ),
              Row(
                children: [
                  Expanded(child: Text(_selectedDate ==null
                      ? 'No Date Chosen!'
                      : DateFormat.yMd().format(_selectedDate))),
                  FlatButton(
                    child: Text(
                      'Choses Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    onPressed:this._presentDatePicker,
                  ),
                ],
              ),
              RaisedButton(

                onPressed: this.SubmitData,
                child: Text(
                  'Add Transaction',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.button.color
                  ),
                ),

                color: Theme.of(context).primaryColor,

              )
            ],
          ),
        ),
      ),
    );
  }
}
