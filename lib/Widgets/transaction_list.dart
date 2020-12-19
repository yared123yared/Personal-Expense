import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/transaction.dart';

class TransactionList extends StatelessWidget {
  final Function deleteTx;
    List<Transaction> _transactions=[];
  TransactionList(this._transactions,this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx,constraint){
    return Container(
      height: MediaQuery.of(context).size.height
      *0.6,

      child: _transactions.isEmpty? Column(
        children: [
          Text('No transactions added yet!',style:Theme.of(context).textTheme.headline6,),
          SizedBox(height: 10,),
          Container(
            height: constraint.maxHeight*0.6,
              child: Image.asset('assets/images/waiting.png',fit: BoxFit.cover,)),
        ],
      ) 
          :ListView.builder(
        itemBuilder: (ctx,index){

          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8,horizontal: 5),

            child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: CircleAvatar(
                    radius: 30,
                    child: FittedBox(
                     child:Text('\$${_transactions[index].amount}')),
                    ),
                  ),

              title: Text(_transactions[index].title,
              style: Theme.of(context).textTheme.headline6,),
              subtitle: Text(DateFormat.yMMMd().format(_transactions[index].date)),
              trailing: MediaQuery.of(context).size.width > 450 ? FlatButton.icon(
                textColor:Theme.of(context).errorColor,
                icon: Icon(Icons.delete),
                onPressed:  ()=>deleteTx(_transactions[index].id),
                label:Text("Delete"),


              ): IconButton(
                icon: Icon(Icons.delete,color: Theme.of(context).errorColor,),
                onPressed: ()=>deleteTx(_transactions[index].id)


              ),
            ),

          );

        },
        itemCount: _transactions.length,




      ),
    );});
  }
}
