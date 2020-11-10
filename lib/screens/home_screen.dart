import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:et_gerente/blocs/orders_bloc.dart';
import 'package:et_gerente/blocs/user_bloc.dart';
import 'package:et_gerente/tabs/orders_tab.dart';
import 'package:et_gerente/tabs/products_tab.dart';
import 'package:et_gerente/tabs/users_tab.dart';
import 'package:et_gerente/widgets/cotacao_atual.dart';
import 'package:et_gerente/widgets/edit_category_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _page = 0;

  UserBloc _userBloc;
  OrdersBloc _ordersBloc;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _userBloc = UserBloc();
    _ordersBloc = OrdersBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.indigo,
              primaryColor: Colors.white,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: TextStyle(color: Colors.white54))),
          child: BottomNavigationBar(
              currentIndex: _page,
              onTap: (p) {
                _pageController.animateToPage(p,
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), title: Text("Clientes")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart), title: Text("Pedidos")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list), title: Text("Produtos"))
                // BottomNavigationBarItem(
                //     icon: Icon(Icons.monetization_on, color: Colors.amberAccent,), title: Text("\$"))
              ]),
        ),
        body: SafeArea(
          child: BlocProvider<UserBloc>(
            bloc: _userBloc,
            child: BlocProvider<OrdersBloc>(
              bloc: _ordersBloc,
              child: PageView(
                controller: _pageController,
                onPageChanged: (p) {
                  setState(() {
                    _page = p;
                  });
                },
                children: <Widget>[
                  UsersTab(),
                  OrdersTab(),
                  ProductsTab(),
//                  CotacaoAtual(),
                ],
              ),
            ),
          ),
        ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating(){
    switch(_page){
      case 0:
        return FloatingActionButton(
          child: Icon(Icons.monetization_on, color: Colors.amberAccent,),
          backgroundColor: Colors.transparent,
          onPressed: (){
            showDialog(context: context,
                builder: (context) => CotacaoAtual()
            );
          },
        );


      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.blueAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(Icons.arrow_downward, color: Colors.blueAccent,),
                backgroundColor: Colors.white,
                label: "Concluídos Abaixo",
                labelStyle: TextStyle(fontSize: 14),
                onTap: (){
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
                }
            ),
            SpeedDialChild(
              child: Icon(Icons.arrow_upward, color: Colors.blueAccent,),
              backgroundColor: Colors.white,
              label: "Concluídos Acima",
              labelStyle: TextStyle(fontSize: 14),
              onTap: (){
                _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
              }
            )
          ],
        );

      case 2:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
          onPressed: (){
            showDialog(context: context,
            builder: (context) => EditCategoryDialog()
            );
          },
        );
   }
  }
}
