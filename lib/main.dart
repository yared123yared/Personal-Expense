import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './Widgets/transaction_list.dart';
import './Widgets/new_transaction.dart';
import './Models/transaction.dart';
import './Widgets/chart.dart';
import 'package:intl/intl.dart';
void main(){
//  WidgetsFlutterBinding.ensureInitialized();
//  SystemChrome.setPreferredOrientations([
//    DeviceOrientation.portraitUp,
//    DeviceOrientation.portraitDown
//  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expense',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor:Colors.red,
        fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            button:TextStyle(
              color: Colors.white
            ),
          ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold
            )
          )
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showCart=false;
  final List<Transaction> transactions=[
    Transaction(
        id: 't1',
        title: 'New Shoes',
        amount: 69.99,
        date: DateTime.now()
    ),
    Transaction(
        id: 't2',
        title: 'New Cloths',
        amount: 49.99,
        date: DateTime.now()
    ),
    Transaction(
        id: 't3',
        title: 'New pant',
        amount: 69.99,
        date: DateTime.now()
    )

  ];

 void startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(
        context: ctx,
        builder: (_){
          return NewTransaction(this._addTransaction);
        });
 }

  void _addTransaction(String txTitle,double txAmount,DateTime chosenDate){
    final txList=Transaction(
        title: txTitle,
        amount: txAmount,
        id: DateTime.now().toString(),
        date: chosenDate
    );

    setState(() {
      this.transactions.add(txList);
    });
    Navigator.of(context).pop();
  }

  List<Transaction> get _recentTransactions{
   return transactions.where((tx){
     return tx.date.isAfter(DateTime.now().subtract(Duration(days:7)));
   }).toList();
  }

  void _deleteTransaction(String id){
   setState(() {
     transactions.removeWhere((element) => element.id==id);
   });
  }



  @override
  Widget build(BuildContext context) {
   final isLandscape=MediaQuery.of(context).orientation==Orientation.landscape;
   final appBar= AppBar(
     title: Text('Personal Expense'),
     actions: [
       IconButton(
         icon:Icon(Icons.add),
         onPressed: ()=>this.startAddNewTransaction(context),
       )
     ],


   );
   final txList=Container(
       height: (MediaQuery.of(context).size.height -
           appBar.preferredSize.height
           -MediaQuery.of(context).padding.top)* 0.7,

       child: TransactionList(this.transactions,this._deleteTransaction));
   final txChart=Container(
     width: double.infinity,
     height: (MediaQuery.of(context).size.height -
         appBar.preferredSize.height
         - MediaQuery.of(context).padding.top)* 0.3,
     child: Card(

       child: Chart(this._recentTransactions),
     ));
    return Scaffold(
      appBar:appBar,
      body: SingleChildScrollView(
        child: Column(
//        mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if(isLandscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text('Show Cart'),
              Switch(value: this._showCart, onChanged: (val){
              setState(() {
                this._showCart=val;
              });
              }),
            ],),
            if(!isLandscape)txChart,
            if(!isLandscape) txList,
            if(isLandscape) this._showCart? Container(
    width: double.infinity,
    height: (MediaQuery.of(context).size.height -
    appBar.preferredSize.height
    - MediaQuery.of(context).padding.top)* 0.7,
    child: Card(

    child: Chart(this._recentTransactions),
    )):txList




          ],
        ),
      ),
        floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,
        floatingActionButton:FloatingActionButton(
              child: Icon(Icons.add),
          onPressed:  ()=>this.startAddNewTransaction(context),
        ),
    );

  }
}
