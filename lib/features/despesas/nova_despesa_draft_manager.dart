// lib/features/despesas/nova_despesa_draft_manager.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Gerenciador de rascunhos em disco e recuperação de fotos perdidas pelo ciclo de vida do Android
abstract class NovaDespesaDraftManager {
  static const String _keyViagemId = 'despesa_draft_viagem_id';
  static const String _keyCategoria = 'despesa_draft_categoria';
  static const String _keyValor = 'despesa_draft_valor';
  static const String _keyLocal = 'despesa_draft_local';
  static const String _keyDescricao = 'despesa_draft_descricao';
  static const String _keyLitros = 'despesa_draft_litros';
  static const String _keyKm = 'despesa_draft_km';
  static const String _keyCombustivel = 'despesa_draft_combustivel';

  // Salva os campos preenchidos antes de abrir a câmera externa
  static Future<void> salvar({
    required String viagemId,
    required String? categoria,
    required double valorTotal,
    required String local,
    required String descricao,
    required String litros,
    required String km,
    required String combustivel,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyViagemId, viagemId);
      if (categoria != null) {
        await prefs.setString(_keyCategoria, categoria);
      }
      await prefs.setDouble(_keyValor, valorTotal);
      await prefs.setString(_keyLocal, local);
      await prefs.setString(_keyDescricao, descricao);
      await prefs.setString(_keyLitros, litros);
      await prefs.setString(_keyKm, km);
      await prefs.setString(_keyCombustivel, combustivel);
    } catch (e) {
      debugPrint('[NovaDespesaDraftManager] Erro ao salvar rascunho: $e');
    }
  }

  // Limpa todos os dados temporários do rascunho após salvar ou cancelar
  static Future<void> limpar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const chaves = [
        _keyViagemId,
        _keyCategoria,
        _keyValor,
        _keyLocal,
        _keyDescricao,
        _keyLitros,
        _keyKm,
        _keyCombustivel,
      ];
      for (final chave in chaves) {
        await prefs.remove(chave);
      }
    } catch (e) {
      debugPrint('[NovaDespesaDraftManager] Erro ao limpar rascunho: $e');
    }
  }

  // Recupera imagem capturada caso o sistema operacional tenha finalizado a Activity
  static Future<File?> recuperarFotoPerdida() async {
    try {
      final picker = ImagePicker();
      final LostDataResponse response = await picker.retrieveLostData();
      if (!response.isEmpty && response.file != null) {
        return File(response.file!.path);
      }
    } catch (e) {
      debugPrint('[NovaDespesaDraftManager] Erro ao recuperar foto perdida: $e');
    }
    return null;
  }
}
