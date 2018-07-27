import 'package:vsii_trader/common/uuid.dart';
import 'package:meta/meta.dart';
import 'package:vsii_trader/repository/orders/orders_index.dart';

@immutable
class Order {
  final String id;
  final String supplier;
  final String retailer;
  final String desciption;
  final int quanity;
  final double totalPrice;
  final String status;
  final String updatedDate;

  Order(
      {String id,
      String supplier,
      String retailer,
      String desciption = '',
      int quanity,
      double totalPrice,
      this.status = 'NEW',
      String updatedDate})
      : this.desciption = desciption ?? '',
        this.quanity = quanity ?? 0,
        this.supplier = supplier ?? 'IBM',
        this.retailer = retailer ?? 'VSII',
        this.totalPrice = totalPrice ?? 0.00,
        this.updatedDate =
            updatedDate ?? (new DateTime.now()).toString().split(' ')[0],
        this.id = id ?? Uuid().generateV4();

  Order copyWith(
      {String id,
      String supplier,
      String retailer,
      String desciption,
      int quanity,
      double totalPrice,
      String status,
      String updatedDate}) {
    return Order(
      id: id ?? this.id,
      supplier: supplier ?? this.supplier,
      retailer: retailer ?? this.retailer,
      desciption: desciption ?? this.desciption,
      quanity: quanity ?? this.quanity,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  @override
  int get hashCode =>
      supplier.hashCode ^
      retailer.hashCode ^
      desciption.hashCode ^
      status.hashCode ^
      updatedDate.hashCode ^
      id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order &&
          runtimeType == other.runtimeType &&
          supplier == other.supplier &&
          retailer == other.retailer &&
          desciption == other.desciption &&
          status == other.status &&
          updatedDate == other.updatedDate &&
          id == other.id;

  @override
  String toString() {
    return 'OrderEntity{supplier: $supplier, retailer: $retailer, desciption: $desciption, quanity: $quanity, totalPrice: $totalPrice, status: $status, updatedDate: $updatedDate, id: $id}';
  }

  OrderEntity toEntity() {
    return OrderEntity(id, supplier, retailer, desciption, quanity, totalPrice,
        status, updatedDate);
  }

  static Order fromEntity(OrderEntity entity) {
    return Order(
      id: entity.id ?? Uuid().generateV4(),
      supplier: entity.supplier ?? 'IBM',
      retailer: entity.retailer ?? 'VSII',
      desciption: entity.desciption ?? '',
      quanity: entity.quanity ?? 0,
      totalPrice: entity.totalPrice ?? 0.00,
      status: entity.status ?? 'New Request',
      updatedDate: entity.updatedDate ?? 'Stone age',
    );
  }
}
