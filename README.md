# DrinkFinder

DrinkFinder é um aplicativo Flutter moderno para explorar e buscar drinks usando a API pública TheCocktailDB.

## Funcionalidades

- Tela inicial (Splash Screen) com logo animada
- Lista paginada de drinks vindos da API (por letra)
- Busca remota de drinks pelo nome
- Tela de detalhes com informações completas do drink
- Indicadores de carregamento e mensagens de erro amigáveis
- Botão "Tentar novamente" em caso de erro
- Tema claro/escuro, seguindo o sistema e com alternância manual
- Gerência de estado com Provider
- Design limpo e moderno com Material 3
- Cards com cantos arredondados e animação Hero

## Estrutura do Projeto

```
lib/
  main.dart                # Entrada do app
  models/                  # Modelos de dados (Drink, Ingredient)
  services/                # Serviço para requisições HTTP
  providers/               # Providers para estado de drinks e tema
  pages/                   # Telas (Splash, Home, Details)
  widgets/                 # Componentes reutilizáveis (DrinkCard, SearchBar)
```

## Como rodar

1. Instale o Flutter SDK: https://docs.flutter.dev/get-started/install
2. Clone este repositório
3. Instale as dependências:
   ```
   flutter pub get
   ```
4. Execute o app:
   ```
   flutter run
   ```

## API utilizada
- [TheCocktailDB](https://www.thecocktaildb.com/api.php)

## Exemplos de endpoints
- Buscar drinks por letra: `https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a`
- Buscar drinks por nome: `https://www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita`

## 📱 Capturas de tela

<p align="center">
  <img src="https://github.com/user-attachments/assets/42e8f00c-4d80-455a-975c-b519d8c3acf7" width="220" alt="Tela inicial" />
  <img src="https://github.com/user-attachments/assets/8541ae8e-aed8-4236-89dd-423b49cd7049" width="220" alt="Lista de drinks" />
  <img src="https://github.com/user-attachments/assets/5ccdc584-b32b-4ce8-8cef-0c9002a1e0b7" width="220" alt="Detalhes do drink" />
  <img src="https://github.com/user-attachments/assets/ff75a73e-37a5-4ab1-9828-e28258841a80" width="220" alt="Modo escuro" />
</p>

# Vídeo

https://youtu.be/Me8iBN9oslA




