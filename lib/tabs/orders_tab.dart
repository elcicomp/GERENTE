import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:et_gerente/blocs/orders_bloc.dart';
import 'package:et_gerente/widgets/order_tile.dart';
import 'package:flutter/material.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ordersBloc = BlocProvider.of<OrdersBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
          stream: _ordersBloc.outOrders,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                ),
              );
            else if (snapshot.data.length == 0)
              return Center(
                child: Text(
                  "Nenhum pedido encontrado!",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              );

            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return OrderTile(snapshot.data[index]);
                });
          }),
    );
  }
}
