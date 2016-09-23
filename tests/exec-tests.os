#Использовать logos
#Использовать asserts

Перем юТест;
Перем Лог;
Перем ТекстЛогФайлаПродукта;

Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт
	
	юТест = ЮнитТестирование;
	
	ВсеТесты = Новый Массив;
	
	ВсеТесты.Добавить("ТестДолжен_ПроверитьУспешныйТест");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапускТестовКаталога");
	
	Возврат ВсеТесты;
КонецФункции

Процедура ПередЗапускомТеста() Экспорт
    ТекстЛогФайлаПродукта = "";
	// ВключитьПоказОтладки();
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
    
КонецПроцедуры

Процедура ТестДолжен_ПроверитьУспешныйТест() Экспорт

    ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "simple.os");
    
    ЯВыполняюКомандуПродуктаCПередачейПараметров("-run", ПутьФайлаТеста);
КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапускТестовКаталога() Экспорт
    ЯВыполняюКомандуПродуктаCПередачейПараметров("-runall", КаталогТестовыхФикстур());
КонецПроцедуры

Процедура ВключитьПоказОтладки()
    Лог.УстановитьУровень(УровниЛога.Отладка);
КонецПроцедуры

Процедура ВыключитьПоказОтладки()
    Лог.УстановитьУровень(УровниЛога.Информация);
КонецПроцедуры

Процедура ЯВыполняюКомандуПродуктаCПередачейПараметров(Знач Команда, Знач ПараметрыКоманды)

	ОжидаемыйКодВозврата = 0;

	ПутьСтартера = ОбъединитьПути(КаталогИсходников(), "testrunner.os");
	ФайлСтартера = Новый Файл(ПутьСтартера);
	Ожидаем.Что(ФайлСтартера.Существует(), "Ожидаем, что скрипт-стартер <testrunner.os> существует, а его нет. "+ФайлСтартера.ПолноеИмя).Равно(Истина);

	// ПараметрыКоманды = СтрШаблон("%1 %2", БДД.ПолучитьИзКонтекста("ПараметрыКоманды"), ПараметрыКоманды);

	СтрокаКоманды = СтрШаблон("oscript -encoding=utf-8 %1 %2 %3", ПутьСтартера, Команда, ПараметрыКоманды);
	// Лог.Отладка("СтрокаКоманды %1", СтрокаКоманды);

	ТекстФайла = "";
	КодВозврата = ВыполнитьПроцесс(СтрокаКоманды, ТекстФайла);

	ТекстЛогФайлаПродукта = ТекстФайла;
	// Лог.Ошибка(ТекстФайла);

	Если КодВозврата <> ОжидаемыйКодВозврата или Лог.Уровень() <= УровниЛога.Отладка  Тогда
	// Если КодВозврата <> ОжидаемыйКодВозврата или Лог.Уровень() <= УровниЛога.Отладка ИЛИ СтрНайти(ПараметрыКоманды, "-verbose on") <> 0 Тогда
		ВывестиТекст(ТекстФайла);
		Ожидаем.Что(КодВозврата, "Код возврата в ЯВыполняюКомандуПродуктаCПередачейПараметров").Равно(ОжидаемыйКодВозврата);
	КонецЕсли;
КонецПроцедуры

Функция ВыполнитьПроцесс(Знач СтрокаВыполнения, ТекстВывода, Знач КодировкаПотока = Неопределено)
	Перем ПаузаОжиданияЧтенияБуфера;
	
	ПаузаОжиданияЧтенияБуфера = 10;
	МаксСчетчикЦикла = 100000;
	
	Если КодировкаПотока = Неопределено Тогда
		КодировкаПотока = КодировкаТекста.UTF8;
	КонецЕсли;
    Лог.Отладка("СтрокаКоманды %1", СтрокаВыполнения);

	Процесс = СоздатьПроцесс(СтрокаВыполнения, ТекущийКаталог(), Истина,Истина, КодировкаПотока);
    Процесс.Запустить();
	
	ТекстВывода = "";
	Счетчик = 0; 
	
	Пока Не Процесс.Завершен Цикл 
		Текст = Процесс.ПотокВывода.Прочитать();
		// Лог.Отладка("Цикл ПотокаВывода "+Текст);
		Если Текст = Неопределено ИЛИ ПустаяСтрока(Текст)  Тогда 
			Прервать;
		КонецЕсли;
		ТекстВывода = ТекстВывода + Текст;

		Счетчик = Счетчик + 1;
		Если Счетчик > МаксСчетчикЦикла Тогда 
			Прервать;
		КонецЕсли;
		
		sleep(ПаузаОжиданияЧтенияБуфера);		
	КонецЦикла;
	
	Процесс.ОжидатьЗавершения();
    
	Текст = Процесс.ПотокВывода.Прочитать();
	ТекстВывода = ТекстВывода + Текст;
	Лог.Отладка(ТекстВывода);

	Возврат Процесс.КодВозврата;
КонецФункции

Процедура ВывестиТекст(Знач Строка)

	Лог.Информация("");
	Лог.Информация("  ----------------    ----------------    ----------------  ");
	Лог.Информация( Строка );
	Лог.Информация("  ----------------    ----------------    ----------------  ");
	Лог.Информация("");

КонецПроцедуры

Функция КаталогТестовыхФикстур() Экспорт
	Возврат ОбъединитьПути(КаталогТестов(), "fixtures");
КонецФункции // КаталогИсходников()

Функция КаталогТестов() Экспорт
	Возврат ОбъединитьПути(КаталогИсходников(), "tests");
КонецФункции // КаталогИсходников()

Функция КаталогИсходников() Экспорт
	Возврат ОбъединитьПути(ТекущийСценарий().Каталог, "..");
КонецФункции // КаталогИсходников()

Лог = Логирование.ПолучитьЛог("1testrunner.tests");