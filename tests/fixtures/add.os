Перем юТест;

Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт

    юТест = ЮнитТестирование;

    юТест.ДобавитьТест("ТестДолжен_ПроверитьСложение", Новый Структура("А,Б,Результат", 2, 2, 4));
    юТест.ДобавитьТест("ТестДолжен_ПроверитьСложение", Новый Структура("А,Б,Результат", 2, 3, 5));

КонецФункции

Процедура ТестДолжен_ПроверитьСложение(Параметры) Экспорт

    ПолученныйРезультат = Сложить(Параметры.А, Параметры.Б);
     юТест.ПроверитьРавенство(Параметры.Результат, ПолученныйРезультат);

КонецПроцедуры

Функция Сложить(а, б)
    Возврат а + б;
КонецФункции