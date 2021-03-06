import 'dart:async';
import 'dart:core';

import 'package:meta/meta.dart';
import 'package:vsii_trader/repository/orders/order_entity.dart';
import 'package:vsii_trader/models/order.dart';
import 'package:vsii_trader/models/user.dart';
import 'package:vsii_trader/repository/orders/orders_repository.dart';
import 'package:vsii_trader/repository/orders/file_storage.dart';
import 'package:vsii_trader/repository/orders/web_client.dart';

/// A class that glues together our local file storage and web client. It has a
/// clear responsibility: Load Orders and Persist orders.
class OrdersRepositoryFlutter implements OrdersRepository {
  final FileStorage fileStorage;
  final WebClient webClient;

  const OrdersRepositoryFlutter({
    this.fileStorage,
    this.webClient = const WebClient(),
  });

  /// Loads orders first from a Web Client. If they don't exist or encounter an
  /// error, it attempts to load the Orders from File storage. If they don't exist
  /// or encounter an error, it return null
  @override
  Future<List<OrderEntity>> loadOrders() async {
    try {
      final orders = await webClient.fetchOrders();
      fileStorage.saveOrders(orders);
      return orders;
    } catch (e) {
      return await fileStorage.loadOrders();
    }
  }

  // Persists orders to local disk and the web
  @override
  Future saveOrders(List<OrderEntity> orders) {
    return Future.wait<dynamic>([
      fileStorage.saveOrders(orders),
      webClient.postOrders(orders),
    ]);
  }

  @override
  Future sendInvoice(Order order, User user, int amount) {
    return Future.wait<dynamic>([
      webClient.sendInvoice(
          amount,
          'resource:' + order.orderClass + '#' + order.id,
          'resource:' + user.userClass + '#' + user.email),
    ]);
  }

  @override
  Future receiveInvoice(Order order, User user) {
    return Future.wait<dynamic>([
      webClient.receiveInvoice(
          int.parse(order.totalPrice.round().toString()),
          'resource:' + order.orderClass + '#' + order.id,
          'resource:' + user.userClass + '#' + user.email),
    ]);
  }

  @override
  Future sendPayment(Order order, User user) {
    return Future.wait<dynamic>([
      webClient.sendPayment(
          int.parse(order.totalPrice.round().toString()),
          'resource:' + order.orderClass + '#' + order.id,
          'resource:' + user.userClass + '#' + user.email),
    ]);
  }

  @override
  Future receivePayment(Order order, User user) {
    return Future.wait<dynamic>([
      webClient.receivePayment(
          int.parse(order.totalPrice.round().toString()),
          'resource:' + order.orderClass + '#' + order.id,
          'resource:' + user.userClass + '#' + user.email),
    ]);
  }

  @override
  Future closeOrder(Order order, User user) {
    return Future.wait<dynamic>([
      webClient.closeOrder(
          int.parse(order.totalPrice.round().toString()),
          'resource:' + order.orderClass + '#' + order.id,
          'resource:' + user.userClass + '#' + user.email),
    ]);
  }

  @override
  Future saveOrder(Order order) {
    return Future.wait<dynamic>([
      webClient.postOrder(order),
    ]);
  }
}
