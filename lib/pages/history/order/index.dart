import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/style.dart';

import '../../../blocs/recycle_order_cubit.dart';
import '../../../components/order/order_list_item.dart';
import '../../../models/recycle_models.dart';

class RecycleOrderHistoryPage extends StatelessWidget {
  const RecycleOrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecycleOrderCubit()..listOrders(),
      child: Scaffold(
        backgroundColor: mainPurple,
        appBar: AppBar(
          backgroundColor: mainPurple,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            tr("order.pickup_history"),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: BlocBuilder<RecycleOrderCubit, RecycleOrderState>(
          builder: (context, state) {
            if (state is RecycleOrderListLoaded) {

              return _buildOrderList(state.orders);
            } else if (state is RecycleOrderError) {
              return _buildError(state.message);
            } else {
              return _buildLoading();
            }
          },
        ),
      ),
    );
  }

  Widget _buildOrderList(List<RecycleOrderListItem> historyList) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.zero,
        ),

        child: historyList.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    tr("order.no_orders_found"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),

                padding: EdgeInsets.zero,
                itemCount: historyList.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  color: mainPurple,
                ),
                itemBuilder: (context, index) {
                  return OrderListItem(historyList[index]);
                },
              ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              tr("error_occurred"),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}