import 'package:flutter_practice13/core/models/tip_model.dart';
import 'package:flutter_practice13/core/storage/database_helper.dart';
import 'package:flutter_practice13/data/datasources/tips/tip_dto.dart';
import 'package:flutter_practice13/data/datasources/tips/tip_mapper.dart';
import 'package:uuid/uuid.dart';

class TipsLocalDataSource {
  final _uuid = const Uuid();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    final db = await _dbHelper.database;
    final count = await db.rawQuery('SELECT COUNT(*) as count FROM tips');
    final tipsCount = count.first['count'] as int;

    if (tipsCount == 0) {
      await _insertInitialTips(db);
    }

    _isInitialized = true;
  }

  Future<void> _insertInitialTips(db) async {
    final initialTips = [
      TipDto(
        id: _uuid.v4(),
        title: 'Как правильно проверить уровень масла',
        content: '''Проверка уровня масла - важная процедура для здоровья двигателя.

Шаги проверки:
1. Прогрейте двигатель до рабочей температуры
2. Заглушите двигатель и подождите 5-10 минут
3. Достаньте масляный щуп и протрите его
4. Вставьте щуп обратно до упора
5. Снова достаньте и проверьте уровень

Уровень должен быть между отметками MIN и MAX. Если ниже MIN - долейте масло той же марки.

Проверяйте уровень масла каждые 1000 км пробега.''',
        category: 'Обслуживание',
        publishDate: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/2917/2917995.png',
        likes: 42,
        isLiked: false,
      ),
      TipDto(
        id: _uuid.v4(),
        title: 'Когда менять тормозные колодки',
        content: '''Признаки износа тормозных колодок:

• Скрежет или визг при торможении
• Увеличенный тормозной путь
• Вибрация педали тормоза
• Сигнальная лампа на панели приборов

Рекомендации:
- Проверяйте толщину колодок каждые 10 000 км
- Минимальная толщина: 3 мм
- Меняйте колодки попарно (обе передние или обе задние)
- После замены обкатайте колодки 200-300 км

Средний срок службы: 30 000 - 70 000 км в зависимости от стиля вождения.''',
        category: 'Тормоза',
        publishDate: DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/3774/3774278.png',
        likes: 38,
        isLiked: false,
      ),
      TipDto(
        id: _uuid.v4(),
        title: 'Подготовка автомобиля к зиме',
        content: '''Чек-лист подготовки к зимнему сезону:

1. Шины
   - Установить зимнюю резину при температуре ниже +7°C
   - Проверить глубину протектора (мин. 4 мм)

2. Аккумулятор
   - Проверить заряд (должен быть не менее 12.5V)
   - Очистить клеммы от окисления

3. Жидкости
   - Заменить на зимнее масло
   - Залить незамерзающую жидкость
   - Проверить антифриз

4. Обогрев
   - Проверить работу печки
   - Протестировать обогрев заднего стекла

5. Дополнительно
   - Положить в багажник: скребок, щетку, трос, лопату''',
        category: 'Сезонное обслуживание',
        publishDate: DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/2583/2583788.png',
        likes: 67,
        isLiked: false,
      ),
      TipDto(
        id: _uuid.v4(),
        title: 'Экономия топлива: простые советы',
        content: '''10 способов снизить расход топлива:

1. Следите за давлением в шинах
   Недокачанные шины увеличивают расход на 3-5%

2. Избегайте резких ускорений
   Плавное вождение экономит до 20% топлива

3. Используйте круиз-контроль
   На трассе помогает поддерживать оптимальную скорость

4. Удалите лишний вес
   Каждые 50 кг увеличивают расход на 2%

5. Закрывайте окна на скорости
   Открытые окна создают сопротивление воздуха

6. Своевременное ТО
   Чистые фильтры и свежее масло = экономия

7. Планируйте маршрут
   Избегайте пробок и лишних километров

8. Выключайте кондиционер
   Когда он не нужен (расход +10-15%)

9. Не грейте двигатель долго
   1-2 минуты достаточно

10. Следите за аэродинамикой
    Снимайте багажник на крыше, когда не используете''',
        category: 'Экономия',
        publishDate: DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/2922/2922506.png',
        likes: 89,
        isLiked: false,
      ),
      TipDto(
        id: _uuid.v4(),
        title: 'Что проверить перед дальней поездкой',
        content: '''Чек-лист перед путешествием:

Технические проверки:
✓ Уровень всех жидкостей (масло, антифриз, тормозная, омыватель)
✓ Состояние и давление в шинах (включая запаску)
✓ Работа всех световых приборов
✓ Состояние щеток стеклоочистителя
✓ Заряд аккумулятора
✓ Тормозная система

Документы:
✓ Водительское удостоверение
✓ Свидетельство о регистрации
✓ Страховка (ОСАГО)
✓ Доверенность (если нужна)

В багажник:
✓ Запасное колесо и инструменты
✓ Аптечка, огнетушитель, знак аварийной остановки
✓ Трос, провода для прикуривания
✓ Фонарик, вода, еда
✓ Зарядка для телефона

Перед выездом:
✓ Спланируйте маршрут
✓ Проверьте прогноз погоды
✓ Отдохните, выспитесь
✓ Заправьте полный бак''',
        category: 'Путешествия',
        publishDate: DateTime.now().subtract(const Duration(days: 20)).toIso8601String(),
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/3845/3845874.png',
        likes: 56,
        isLiked: false,
      ),
    ];

    for (final tip in initialTips) {
      final json = tip.toJson();
      json['isLiked'] = tip.isLiked ? 1 : 0;
      await db.insert('tips', json);
    }
  }

  Future<List<TipModel>> getTips() async {
    await _ensureInitialized();
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tips',
      orderBy: 'publishDate DESC',
    );

    return maps.map((map) {
      final mapWithBool = Map<String, dynamic>.from(map);
      mapWithBool['isLiked'] = map['isLiked'] == 1;
      return TipDto.fromJson(mapWithBool).toModel();
    }).toList();
  }

  Future<TipModel> getTipById(String id) async {
    await _ensureInitialized();
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tips',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      throw Exception('Совет с id $id не найден');
    }

    final map = maps.first;
    final mapWithBool = Map<String, dynamic>.from(map);
    mapWithBool['isLiked'] = map['isLiked'] == 1;
    return TipDto.fromJson(mapWithBool).toModel();
  }

  Future<void> toggleLike(String id) async {
    await _ensureInitialized();
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'tips',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      throw Exception('Совет с id $id не найден');
    }

    final tip = maps.first;
    final isLiked = tip['isLiked'] == 1;
    final likes = tip['likes'] as int;

    await db.update(
      'tips',
      {
        'likes': isLiked ? likes - 1 : likes + 1,
        'isLiked': isLiked ? 0 : 1,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
