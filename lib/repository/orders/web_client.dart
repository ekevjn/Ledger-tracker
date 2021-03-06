import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vsii_trader/repository/orders/order_entity.dart';
import 'package:vsii_trader/models/order.dart';
import 'package:vsii_trader/common/router.dart';
import 'package:vsii_trader/common/notification.dart';

class WebClient {
  const WebClient();

  Future<List<OrderEntity>> fetchOrders() async {
    final response = await http.get(Router.ORDER_ENDPOINT);
    List<OrderEntity> rs = new List<OrderEntity>();
    if (response.statusCode == 200) {
      for (Object order in json.decode(response.body)) {
        rs.add(OrderEntity.fromJson(order));
      }
      // If server returns an OK response, parse the JSON
      return rs;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load order');
    }
  }

  Future<bool> postOrders(List<OrderEntity> orders) async {
    return Future.value(true);
  }

  Future<bool> sendInvoice(
      int amount, String orderRs, String supplierRs) async {
    Map jsonData = {
      "\u{0024}class": "com.vsii.trd.ordertracker.SendInvoice",
      "newAmount": amount,
      "newCurrency": "USD",
      "newPaymentMethod": "BANK_TRANSFER",
      "newUpdatedDate": (new DateTime.now()).toString().split(' ')[0],
      "newOrder": orderRs,
      "supplier": supplierRs,
      "timestamp": (new DateTime.now()).toString()
    };
    HttpClientResponse response =
        await RouterClient.request(Router.SEND_INVOICE_PATH, jsonData);
    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to send invoice');
    }
  }

  Future<bool> receiveInvoice(
      int amount, String orderRs, String retailerRs) async {
    Map jsonData = {
      "\u{0024}class": "com.vsii.trd.ordertracker.ReceiveInvoice",
      "newUpdatedDate": (new DateTime.now()).toString().split(' ')[0],
      "newOrder": orderRs,
      "retailer": retailerRs,
      "timestamp": (new DateTime.now()).toString()
    };
    HttpClientResponse response =
        await RouterClient.request(Router.RECEIVE_INVOICE_PATH, jsonData);
    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to receive invoice');
    }
  }

  Future<bool> sendPayment(
      int amount, String orderRs, String retailerRs) async {
    Map jsonData = {
      "\u{0024}class": "com.vsii.trd.ordertracker.SendPayment",
      "newUpdatedDate": (new DateTime.now()).toString().split(' ')[0],
      "newOrder": orderRs,
      "retailer": retailerRs,
      "timestamp": (new DateTime.now()).toString()
    };
    HttpClientResponse response =
        await RouterClient.request(Router.SEND_PAYMENT_PATH, jsonData);
    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to send payment');
    }
  }

  Future<bool> receivePayment(
      int amount, String orderRs, String supplierRs) async {
    Map jsonData = {
      "\u{0024}class": "com.vsii.trd.ordertracker.ReceivePayment",
      "newUpdatedDate": (new DateTime.now()).toString().split(' ')[0],
      "newOrder": orderRs,
      "supplier": supplierRs,
      "timestamp": (new DateTime.now()).toString()
    };
    HttpClientResponse response =
        await RouterClient.request(Router.RECEIVE_PAYMENT_PATH, jsonData);
    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to receive payment');
    }
  }

  Future<bool> closeOrder(int amount, String orderRs, String retailerRs) async {
    Map jsonData = {
      "\u{0024}class": "com.vsii.trd.ordertracker.CloseOrder",
      "newUpdatedDate": (new DateTime.now()).toString().split(' ')[0],
      "newOrder": orderRs,
      "retailer": retailerRs,
      "timestamp": (new DateTime.now()).toString()
    };
    HttpClientResponse response =
        await RouterClient.request(Router.CLOSE_ORDER_PATH, jsonData);
    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to send invoice');
    }
  }

  Future<bool> postOrder(Order order) async {
    Map jsonData = {
      "\u{0024}class": order.orderClass,
      "orderId": order.id,
      "product": order.desciption,
      "status": order.status,
      "quantity": order.quantity,
      "unitType": order.unitType,
      "amount": order.totalPrice.round(),
      "currency": order.currency,
      "paymentMethod": order.paymentMethod,
      "startedDate": order.startedDate,
      "lastUpdatedDate": order.updatedDate,
      "retailer": order.retailer,
      "supplier": order.supplier
    };

    HttpClientResponse response =
        await RouterClient.request(Router.ORDER_PATH, jsonData);
    await response.transform(utf8.decoder /*5*/).forEach(print);
//    final Response = await http.post(Router.ORDER_ENDPOINT,
////        headers: <String, String>{},
//        body: json.encode({
//          "\u{0024}class": order.orderClass,
//          "orderId": order.id,
//          "product": order.desciption,
//          "status": order.status,
//          "quantity": order.quantity,
//          "unitType": order.unitType,
//          "amount": order.totalPrice.round(),
//          "currency": order.currency,
//          "paymentMethod": order.paymentMethod,
//          "startedDate": order.startedDate,
//          "lastUpdatedDate": order.updatedDate,
//          "retailer": order.retailer,
//          "supplier": order.supplier
//        }));
    if (response.statusCode == 200) {
//      Notification.showNotification();
      return Future.value(true);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to save order');
    }
  }
}
