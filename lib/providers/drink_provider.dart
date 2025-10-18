import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../services/cocktail_service.dart';

/// Provider responsável por gerenciar o estado dos drinks
class DrinkProvider extends ChangeNotifier {
  final CocktailService _service = CocktailService();

  // Lista de drinks carregados
  List<Drink> _drinks = [];
  List<Drink> get drinks => _drinks;

  // Estados de carregamento e erro
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Controle de paginação por letra
  int _currentLetterIndex = 0;
  final List<String> _alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');

  // Controle de busca
  bool _isSearching = false;
  bool get isSearching => _isSearching;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  /// Carrega drinks iniciais (letra 'a')
  Future<void> loadInitialDrinks() async {
    _currentLetterIndex = 0;
    _drinks = [];
    _isSearching = false;
    _searchQuery = '';
    await _loadDrinksByLetter();
  }

  /// Carrega drinks da próxima letra (paginação)
  Future<void> loadNextPage() async {
    if (_isSearching) return; // Não paginar durante busca

    if (_currentLetterIndex < _alphabet.length - 1) {
      _currentLetterIndex++;
      await _loadDrinksByLetter();
    }
  }

  /// Carrega drinks por letra atual
  Future<void> _loadDrinksByLetter() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final letter = _alphabet[_currentLetterIndex];
      final newDrinks = await _service.searchByLetter(letter);
      _drinks.addAll(newDrinks);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Busca drinks por nome
  Future<void> searchDrinks(String query) async {
    _searchQuery = query.trim();

    // Se a busca estiver vazia, volta para o modo de listagem por letra
    if (_searchQuery.isEmpty) {
      _isSearching = false;
      await loadInitialDrinks();
      return;
    }

    _isSearching = true;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _service.searchByName(_searchQuery);
      _drinks = results;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Limpa a busca e volta para a lista inicial
  void clearSearch() {
    _searchQuery = '';
    _isSearching = false;
    loadInitialDrinks();
  }

  /// Tenta novamente após erro
  Future<void> retry() async {
    if (_isSearching && _searchQuery.isNotEmpty) {
      await searchDrinks(_searchQuery);
    } else {
      await loadInitialDrinks();
    }
  }
}
