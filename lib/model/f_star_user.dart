import 'package:flutter/material.dart';

class FStarUser {
  final int id;
  final String appVersion;
  final int buildNumber;
  final String androidId;
  final String androidVersion;
  final String brand;
  final String device;
  final String model;
  final String product;
  final String platform;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const FStarUser({
    @required this.id,
    @required this.appVersion,
    @required this.buildNumber,
    @required this.androidId,
    @required this.androidVersion,
    @required this.brand,
    @required this.device,
    @required this.model,
    @required this.product,
    @required this.platform,
  });

  FStarUser copyWith({
    int id,
    String appVersion,
    int buildNumber,
    String androidId,
    String androidVersion,
    String brand,
    String device,
    String model,
    String product,
    String platform,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (appVersion == null || identical(appVersion, this.appVersion)) &&
        (buildNumber == null || identical(buildNumber, this.buildNumber)) &&
        (androidId == null || identical(androidId, this.androidId)) &&
        (androidVersion == null ||
            identical(androidVersion, this.androidVersion)) &&
        (brand == null || identical(brand, this.brand)) &&
        (device == null || identical(device, this.device)) &&
        (model == null || identical(model, this.model)) &&
        (product == null || identical(product, this.product)) &&
        (platform == null || identical(platform, this.platform))) {
      return this;
    }

    return new FStarUser(
      id: id ?? this.id,
      appVersion: appVersion ?? this.appVersion,
      buildNumber: buildNumber ?? this.buildNumber,
      androidId: androidId ?? this.androidId,
      androidVersion: androidVersion ?? this.androidVersion,
      brand: brand ?? this.brand,
      device: device ?? this.device,
      model: model ?? this.model,
      product: product ?? this.product,
      platform: platform ?? this.platform,
    );
  }

  @override
  String toString() {
    return 'FStarUser{id: $id, appVersion: $appVersion, buildNumber: $buildNumber, androidId: $androidId, androidVersion: $androidVersion, brand: $brand, device: $device, model: $model, product: $product, platform: $platform}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FStarUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          appVersion == other.appVersion &&
          buildNumber == other.buildNumber &&
          androidId == other.androidId &&
          androidVersion == other.androidVersion &&
          brand == other.brand &&
          device == other.device &&
          model == other.model &&
          product == other.product &&
          platform == other.platform);

  @override
  int get hashCode =>
      id.hashCode ^
      appVersion.hashCode ^
      buildNumber.hashCode ^
      androidId.hashCode ^
      androidVersion.hashCode ^
      brand.hashCode ^
      device.hashCode ^
      model.hashCode ^
      product.hashCode ^
      platform.hashCode;

  factory FStarUser.fromMap(Map<String, dynamic> map) {
    return new FStarUser(
      id: map['id'] as int,
      appVersion: map['appVersion'] as String,
      buildNumber: map['buildNumber'] as int,
      androidId: map['androidId'] as String,
      androidVersion: map['androidVersion'] as String,
      brand: map['brand'] as String,
      device: map['device'] as String,
      model: map['model'] as String,
      product: map['product'] as String,
      platform: map['platform'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'appVersion': this.appVersion,
      'buildNumber': this.buildNumber,
      'androidId': this.androidId,
      'androidVersion': this.androidVersion,
      'brand': this.brand,
      'device': this.device,
      'model': this.model,
      'product': this.product,
      'platform': this.platform,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
