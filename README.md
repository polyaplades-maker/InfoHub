# InfoHub — Flutter приложение

InfoHub — учебное приложение на Flutter. Оно получает реальные данные с API Ninjas:
- случайный интересный факт;
- каталог упражнений;
- поиск упражнения по названию;
- фильтр по группе мышц;
- фильтр по уровню сложности;
- экран подробной информации с инструкцией, оборудованием и рекомендациями по безопасности;
- обновление данных и обработка ошибок API.

## Использованные технологии

- Flutter / Dart
- Dio — HTTP-запросы
- ApiKeyInterceptor — добавление `X-Api-Key` в каждый запрос
- pretty_dio_logger — журнал запросов и ответов в консоли
- get_it — регистрация и получение зависимостей
- API Ninjas — внешний API

## 1. Получение API-ключа

1. Откройте https://api-ninjas.com/
2. Зарегистрируйтесь или войдите в аккаунт.
3. Получите API Key в личном кабинете.
4. Откройте `lib/core/di/service_locator.dart`.
5. Замените `PASTE_YOUR_API_KEY_HERE` на свой ключ.

Пример:
```dart
const String apiNinjasApiKey = 'ваш_ключ';
```

Не публикуйте настоящий API-ключ в открытом GitHub-репозитории.

## 2. Запуск проекта

Откройте папку проекта в VS Code, затем в терминале выполните:

```bash
flutter doctor
flutter pub get
flutter run
```

Для Android-эмулятора или телефона убедитесь, что включён интернет.

## 3. Структура проекта

```text
infohub_flutter/
  lib/
    main.dart
    core/
      di/
        service_locator.dart
      network/
        api_key_interceptor.dart
        dio_client.dart
    data/
      models/
        fact.dart
        exercise.dart
      repositories/
        info_repository.dart
    presentation/
      screens/
        home_screen.dart
        exercise_detail_screen.dart
  pubspec.yaml
  README.md
```

## 4. Как устроена работа с API

`DioClient` создаёт Dio с базовым адресом API Ninjas. Затем подключаются два interceptor:
- `ApiKeyInterceptor` добавляет заголовок `X-Api-Key`;
- `PrettyDioLogger` показывает информацию о запросах и ответах в консоли.

`InfoRepository` выполняет запросы `/facts` и `/exercises`, а также преобразует JSON в модели `Fact` и `Exercise`.

`service_locator.dart` регистрирует `DioClient` и `InfoRepository` через GetIt. Благодаря этому экран получает готовый репозиторий без создания сетевых объектов вручную.

## 5. Функциональность приложения

1. При запуске загружается случайный факт.
2. Загружаются упражнения для выбранной группы мышц.
3. Можно искать упражнения по названию.
4. Можно выбрать группу мышц и сложность.
5. При нажатии на упражнение открывается отдельный экран с подробностями.
6. Кнопка обновления повторно загружает данные.
7. При сетевой ошибке или проблеме с ключом показывается понятное сообщение и кнопка повтора.

## 6. Важное замечание

API Ninjas требует действительный API Key в заголовке `X-Api-Key`. Без личного ключа приложение запустится, но реальные запросы не пройдут авторизацию. Бесплатный доступ и лимиты зависят от условий аккаунта API Ninjas.

Документация:
- https://api-ninjas.com/api/facts
- https://api-ninjas.com/api/exercises
