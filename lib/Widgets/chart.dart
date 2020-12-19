
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/transaction.dart';
import 'chart_bar.dart';


class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);



  List<Map<String,Object>> get groupedTransactionalValue{
    return List.generate(7,(index){
      final weekDay = DateTime.now().subtract(Duration(days:index),);
      var totalSum=0.0;
      for(var i=0;i<recentTransactions.length;i++){
        if(recentTransactions[i].date.day==weekDay.day
            && recentTransactions[i].date.month==weekDay.month
            && recentTransactions[i].date.year==weekDay.year){
          totalSum+=recentTransactions[i].amount;

              }
          }
              print(DateFormat.E().format(weekDay));
      print(totalSum);
      return {
      'day':DateFormat.E().format(weekDay).substring(0,1),
      'amount':totalSum,
      };
    });
  }
  double get maxSpending{
    return groupedTransactionalValue.fold(0.0, (sum, item){
      return sum+item['amount'];
    });
  }
  @override
  Widget build(BuildContext context) {
    print(groupedTransactionalValue);
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Card(
        elevation:6,
        margin:EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionalValue.map((data){
//          return Text('${data['day']} : ${data['amount']} ');
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    data['day'],
                    data['amount'],
                    maxSpending == 0.0? 0.0 : (data['amount'] as double)/maxSpending),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

