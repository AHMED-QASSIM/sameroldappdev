import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'dart:io' show Platform;

abstract class ValidatorRule {
  final String? errorMessage;

  @mustCallSuper
  const ValidatorRule([this.errorMessage]);

  String? isValid(String? value);

  abstract final Map<String, String> defaultMessage;

  String? get getMessage => this.errorMessage ?? defaultMessage[Get.locale!.languageCode];
}
