// lib/core/database/local_database.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/viagem_collection.dart';
import '../../models/despesa_collection.dart';

// Classe responsável pela inicialização e isolamento do banco de dados local IsarDB por motorista
class LocalDatabase {
  static Isar? _isar;

  static Isar get isar {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }
    if (Isar.instanceNames.isNotEmpty) {
      _isar = Isar.getInstance();
      if (_isar != null && _isar!.isOpen) return _isar!;
    }
    throw StateError('LocalDatabase não inicializado. Chame LocalDatabase.init() primeiro.');
  }

  static String _sanitizeInstanceName(String? userId) {
    if (userId == null || userId.trim().isEmpty) {
      return 'default';
    }
    final clean = userId.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    return 'user_$clean';
  }

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('lastUserId');

    if (userId == null || userId.isEmpty) {
      final userStr = prefs.getString('currentUser');
      if (userStr != null) {
        try {
          final userMap = jsonDecode(userStr);
          userId = (userMap['_id'] ?? userMap['id'])?.toString();
        } catch (_) {}
      }
    }

    await openForUser(userId);
  }

  static Future<void> openForUser(String? userId) async {
    final instanceName = _sanitizeInstanceName(userId);

    // Se já estiver aberto com este nome, reutiliza
    if (_isar != null && _isar!.isOpen && _isar!.name == instanceName) {
      return;
    }

    final existingInstance = Isar.getInstance(instanceName);
    if (existingInstance != null && existingInstance.isOpen) {
      _isar = existingInstance;
      debugPrint('[LocalDatabase] Instância Isar "$instanceName" reutilizada.');
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final openedIsar = await Isar.open(
      [ViagemCollectionSchema, DespesaCollectionSchema],
      directory: dir.path,
      name: instanceName,
      inspector: true,
    );

    _isar = openedIsar;
    debugPrint('[LocalDatabase] Instância Isar "$instanceName" aberta com sucesso.');
  }
}
