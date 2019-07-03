///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Получение обновлений программы".
// ОбщийМодуль.ПолучениеОбновленийПрограммыКлиентСервер.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ЭтоКодВозвратаОграниченияСистемныхПолитик(КодВозврата) Экспорт
	
	Возврат (КодВозврата = 1625 Или КодВозврата = 1643 Или КодВозврата = 1644);
	
КонецФункции

Функция Это64РазрядноеПриложение() Экспорт
	
	СистИнфо = Новый СистемнаяИнформация;
	Возврат (СистИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64
		Или СистИнфо.ТипПлатформы = ТипПлатформы.Linux_x86_64
		Или СистИнфо.ТипПлатформы = ТипПлатформы.MacOS_x86_64);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Каталоги для работы с обновлениями.

#Если Не ВебКлиент Тогда

Функция КаталогУстановкиПлатформы1СПредприятие(НомерВерсии) Экспорт
	
	КаталогProgramData = СистемныйКаталог(35);
	
	ПутьКонфигурационногоФайла = КаталогProgramData + "1C\1CEStart\1CEStart.cfg";
	ОписательФайла = Новый Файл(ПутьКонфигурационногоФайла);
	Если НЕ ОписательФайла.Существует() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// Чтение каталогов установки и поиск каталогов установки платформы
	ЧтениеТекста = Новый ЧтениеТекста(ПутьКонфигурационногоФайла);
	ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
	Пока ПрочитаннаяСтрока <> Неопределено Цикл
		Если ВРег(Лев(ПрочитаннаяСтрока, 17)) = "INSTALLEDLOCATION" Тогда
			ПутьКаталогаУстановки = Сред(ПрочитаннаяСтрока, 19);
			Если НЕ ПустаяСтрока(ПутьКаталогаУстановки) Тогда
				ПутьКаталогаВерсииПлатформы = ПутьКаталогаУстановки
					+ ?(Прав(ПутьКаталогаУстановки, 1) = "\", "", "\")
					+ НомерВерсии + "\bin\";
				ОписательФайла = Новый Файл(ПутьКаталогаВерсииПлатформы);
				Если ОписательФайла.Существует() Тогда
					ЧтениеТекста.Закрыть();
					Возврат ПутьКаталогаВерсииПлатформы;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
	КонецЦикла;
	
	ЧтениеТекста.Закрыть();
	
	Возврат Неопределено;
	
КонецФункции

Функция КаталогДляРаботыСОбновлениямиПлатформы() Экспорт
	
	КаталогAppData = СистемныйКаталог(28);
	ПутьКаталога = КаталогAppData + ?(Прав(КаталогAppData, 1) = "\", "", "\")
		+ "1C\1Cv8PlatformUpdate";
	
	ОписательФайла = Новый Файл(ПутьКаталога);
	Если НЕ ОписательФайла.Существует() Тогда
		СоздатьКаталог(ПутьКаталога);
	КонецЕсли;
	
	Возврат ПутьКаталога + "\";
	
КонецФункции

Функция КаталогДляРаботыСОбновлениямиКонфигурации()
	
	КаталогAppData = СистемныйКаталог(28);
	ПутьКаталога = КаталогAppData + ?(Прав(КаталогAppData, 1) = "\", "", "\")
		+ "1C\1Cv8ConfigUpdate";
	
	ОписательФайла = Новый Файл(ПутьКаталога);
	Если Не ОписательФайла.Существует() Тогда
		СоздатьКаталог(ПутьКаталога);
	КонецЕсли;
	
	Возврат ПутьКаталога + "\";
	
КонецФункции

Функция КаталогДляРаботыСИсправлениями()
	
	КаталогAppData = СистемныйКаталог(28);
	ПутьКаталога = КаталогAppData + ?(Прав(КаталогAppData, 1) = "\", "", "\")
		+ "1C\1Cv8ConfigUpdate\Patches";
	
	ОписательФайла = Новый Файл(ПутьКаталога);
	Если Не ОписательФайла.Существует() Тогда
		СоздатьКаталог(ПутьКаталога);
	КонецЕсли;
	
	Возврат ПутьКаталога + "\";
	
КонецФункции

Функция КаталогШаблонов()
	
	ИмяКаталога = СистемныйКаталог(26);
	КаталогПоУмолчанию = ИмяКаталога + "1C\1Cv8\tmplts\";
	ИмяФайла = ИмяКаталога + "1C\1CEStart\1CEStart.cfg";
	Если Не ФайлСуществует(ИмяФайла) Тогда
		Возврат КаталогПоУмолчанию;
	КонецЕсли;
	
	Текст = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF16);
	Стр = "";
	Пока Стр <> Неопределено Цикл
		
		Стр = Текст.ПрочитатьСтроку();
		Если Стр = Неопределено Тогда
			Прервать;
		КонецЕсли;
		
		Если СтрНайти(ВРег(Стр), ВРег("ConfigurationTemplatesLocation")) = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ПозицияРазделителя = СтрНайти(Стр, "=");
		Если ПозицияРазделителя = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НайденныйКаталог = Сред(Стр, ПозицияРазделителя + 1);
		Если Прав(НайденныйКаталог, 1) <> "\" Тогда
			НайденныйКаталог = НайденныйКаталог + "\";
		КонецЕсли;
		
		Возврат ?(ФайлСуществует(НайденныйКаталог), НайденныйКаталог, КаталогПоУмолчанию);
		
	КонецЦикла;
	
	Возврат КаталогПоУмолчанию;

КонецФункции

Функция ФайлСуществует(ПутьФайла, ЭтоКаталог = Неопределено, Размер = Неопределено) Экспорт
	
	Описатель = Новый Файл(ПутьФайла);
	Если Не Описатель.Существует() Тогда
		Возврат Ложь;
	ИначеЕсли ЭтоКаталог = Неопределено Тогда
		Возврат (Размер = Неопределено Или Описатель.ЭтоКаталог() Или Описатель.Размер() = Размер);
	Иначе
		Возврат (Описатель.ЭтоКаталог() = ЭтоКаталог
			И (ЭтоКаталог Или Размер = Неопределено Или Описатель.Размер() = Размер));
	КонецЕсли;
	
КонецФункции

Функция СистемныйКаталог(Идентификатор)
	
	App = Новый COMОбъект("Shell.Application");
	Folder = App.Namespace(Идентификатор);
	Результат = Folder.Self.Path;
	Возврат ?(Прав(Результат, 1) = "\", Результат, Результат + "\");
	
КонецФункции

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// Реализация контекста получения и установки обновлений программы.

#Если Не ВебКлиент Тогда

Функция НовыйКонтекстПолученияИУстановкиОбновлений(Параметры) Экспорт
	
	ОписаниеФайловОбновлений = Параметры.ОписаниеФайловОбновлений;
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяОшибки"         , "");
	Результат.Вставить("Сообщение"         , "");
	Результат.Вставить("ИнформацияОбОшибке", "");
	Результат.Вставить("Завершено"         , Ложь);
	Результат.Вставить("ВерсияПлатформы"   , ОписаниеФайловОбновлений.ВерсияПлатформы);
	
	Результат.Вставить("Прогресс", 0);
	Если Параметры.ОбновитьКонфигурацию Тогда
		Результат.Вставить("ОбновленияКонфигурации", ОписаниеФайловОбновлений.ОбновленияКонфигурации);
		Результат.Вставить("КоличествоОбновленийКонфигурации", Результат.ОбновленияКонфигурации.Количество());
	Иначе
		Результат.Вставить("ОбновленияКонфигурации", Новый Массив);
		Результат.Вставить("КоличествоОбновленийКонфигурации", 0);
	КонецЕсли;
	
	Если Параметры.УстановитьИсправления Тогда
		Результат.Вставить("Исправления"          , ОписаниеФайловОбновлений.Исправления);
		Результат.Вставить("ОтозванныеИсправления", ОписаниеФайловОбновлений.ОтозванныеИсправления);
	Иначе
		Результат.Вставить("Исправления"          , Новый Массив);
		Результат.Вставить("ОтозванныеИсправления", Новый Массив);
	КонецЕсли;
	
	Результат.Вставить("ИсправленияУстановлены", Ложь);
	
	КоличествоФайлов = 0;
	ОбъемФайлов      = 0;
	Если Не Параметры.ОбновитьПлатформу Или ПустаяСтрока(Результат.ВерсияПлатформы) Тогда
		Результат.Вставить("ОбновитьПлатформу", Ложь);
	Иначе
		Результат.Вставить("ОбновитьПлатформу", Истина);
		КоличествоФайлов = КоличествоФайлов + 1;
		ОбъемФайлов      = ОбъемФайлов + ОписаниеФайловОбновлений.РазмерОбновленияПлатформы;
	КонецЕсли;
	
	Если Результат.ОбновленияКонфигурации.Количество() > 0 Тогда
		
		Результат.Вставить("ВременныйКаталогОбновленийКонфигурации",
			КаталогДляРаботыСОбновлениямиКонфигурации());
		Результат.Вставить("КаталогИндексаФайлов",
			Результат.ВременныйКаталогОбновленийКонфигурации + "FileIndex\");
		Результат.Вставить("КаталогШаблонов", КаталогШаблонов());
		
		Для Каждого ТекОбновление Из Результат.ОбновленияКонфигурации Цикл
			
			КоличествоФайлов = КоличествоФайлов + 1;
			ОбъемФайлов      = ОбъемФайлов + ТекОбновление.РазмерФайла;
			ТекОбновление.Вставить("Получено"          , Ложь);
			ТекОбновление.Вставить("КаталогДистрибутива",
				Результат.КаталогШаблонов + СтрЗаменить(ТекОбновление.ПодкаталогШаблонов, "_", "."));
			ТекОбновление.Вставить("КаталогCFUФайлаВКаталогеДистрибутивов",
				ТекОбновление.КаталогДистрибутива + ТекОбновление.ПодкаталогCfu);
			ТекОбновление.Вставить("ПолноеИмяCFUФайлаВКаталогеДистрибутивов",
				ТекОбновление.КаталогДистрибутива + ТекОбновление.ОтносительныйПутьCFUФайла);
			ТекОбновление.Вставить("ИмяИндексногоФайла",
				СтрЗаменить(ТекОбновление.ПодкаталогШаблонов, "\", "_") + "_"
					+ СтрЗаменить(СтрЗаменить(ТекОбновление.ОтносительныйПутьCFUФайла, "\", "_"), ".", "_")
					+ ".txt");
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Параметры.УстановитьИсправления Тогда
		Результат.Вставить("КаталогДляРаботыСИсправлениями", КаталогДляРаботыСИсправлениями());
		// Удалить файлы исправлений, которые были созданы более 90 дней назад.
		УдалитьУстаревшиеФайлы(
			Результат.КаталогДляРаботыСИсправлениями,
			ТекущаяДата() - 7776000); // 7776000 = 60 * 60 * 24 * 90.
	КонецЕсли;
	
	КоличествоФайлов = КоличествоФайлов + Результат.Исправления.Количество();
	Для Каждого ТекИсправление Из Результат.Исправления Цикл
		ОбъемФайлов = ОбъемФайлов + ТекИсправление.Размер;
		ТекИсправление.Вставить("ИмяПолученногоФайла",
			Результат.КаталогДляРаботыСИсправлениями + ТекИсправление.Имя
				+ СтрЗаменить(
					СтрЗаменить(
						СтрЗаменить(
							ТекИсправление.КонтрольнаяСумма,
							"=",
							"_e_"),
						"/",
						"_s_"),
					"+",
					"_p_")
				+ ".zip");
		ТекИсправление.Вставить("Получено", ФайлСуществует(ТекИсправление.ИмяПолученногоФайла, Ложь, ТекИсправление.Размер));
	КонецЦикла;
	
	Результат.Вставить("ОбновлениеПлатформыУстановлено", Ложь);
	Результат.Вставить("КаталогДистрибутиваПлатформы"  , "");
	Результат.Вставить("URLФайлаОбновленияПлатформы"   , ОписаниеФайловОбновлений.URLФайлаОбновленияПлатформы);
	Результат.Вставить("РазмерОбновленияПлатформы"     , ОписаниеФайловОбновлений.РазмерОбновленияПлатформы);
	Результат.Вставить("УстановкаПлатформыОтменена"    , 0);
	Результат.Вставить("КодВозвратаПрограммыУстановки" , 0);
	
	Результат.Вставить("КоличествоФайлов"       , КоличествоФайлов);
	Результат.Вставить("ОбъемФайлов"            , ОбъемФайлов);
	Результат.Вставить("ФайлыОбновленияПолучены", Ложь);
	Результат.Вставить("ТекущееДействие",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Подготовка к получению обновления...'"),
			КоличествоФайлов));
	
	Возврат Результат;
	
КонецФункции

Процедура УдалитьУстаревшиеФайлы(Каталог, ДатаАктуальности)
	
	ФайлыВКаталоге = НайтиФайлы(Каталог);
	ФайловПроверено  = 0;
	ФайловОбработано = 0;
	ИменаФайловСОшибкамиУдаления = Новый Массив;
	ОписаниеОшибкиУдаления = "";
	Для Каждого ТекФайл Из ФайлыВКаталоге Цикл
		
		ФайловПроверено = ФайловПроверено + 1;
		Если ТекФайл.ПолучитьВремяИзменения() < ДатаАктуальности Тогда
			
			Попытка
				УдалитьФайлы(ТекФайл.ПолноеИмя);
			Исключение
				ИменаФайловСОшибкамиУдаления.Добавить(ТекФайл.ПолноеИмя);
				Если ПустаяСтрока(ОписаниеОшибкиУдаления) Тогда
					ОписаниеОшибкиУдаления = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				КонецЕсли;
			КонецПопытки;
			
			ФайловОбработано = ФайловОбработано + 1;
			
		КонецЕсли;
		
		Если ФайловОбработано >= 100 Или ФайловПроверено >= 1000 Тогда
			// Выполняется попытка удаления файлов порциями.
			// Не удаленные файлы будут обработаны при следующем обновлении.
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИменаФайловСОшибкамиУдаления.Количество() > 0 Тогда
		ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось удалить устаревшие файлы исправлений (патчей):
					|%1
					|%2'"),
				СтрСоединить(ИменаФайловСОшибкамиУдаления, Символы.ПС),
				ОписаниеОшибкиУдаления));
	КонецЕсли;
	
КонецПроцедуры

Функция ОбновлениеКонфигурацииПолучено(Обновление, Контекст) Экспорт
	
	Если Обновление.Получено Тогда
		
		Возврат Истина;
		
	ИначеЕсли Не ФайлСуществует(Обновление.ПолноеИмяCFUФайлаВКаталогеДистрибутивов, Ложь)
		Или ПустаяСтрока(Обновление.КонтрольнаяСумма) Тогда
		
		Возврат Ложь;
		
	Иначе
		
		// Проверка контрольных сумм.
		#Если Не ТонкийКлиент Тогда
		
		Хеширование = Новый ХешированиеДанных(ХешФункция.MD5);
		Хеширование.ДобавитьФайл(Обновление.ПолноеИмяCFUФайлаВКаталогеДистрибутивов);
		Попытка
			Если Обновление.КонтрольнаяСумма <> Base64Строка(Хеширование.ХешСумма) Тогда
				Возврат Ложь;
			Иначе
				Обновление.Получено = Истина;
				Возврат Истина;
			КонецЕсли;
		Исключение
			ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат Ложь;
		КонецПопытки;
		
		#Иначе
		
		Попытка
			
			ПолноеИмяИндексногоФайла = Контекст.КаталогИндексаФайлов + Обновление.ИмяИндексногоФайла;
			Если Не ФайлСуществует(ПолноеИмяИндексногоФайла, Ложь) Тогда
				Возврат ложь;
			КонецЕсли;
			
			ЧтениеТекста = Новый ЧтениеТекста(ПолноеИмяИндексногоФайла);
			ТекСтрока = ЧтениеТекста.ПрочитатьСтроку();
			Если ТекСтрока = Неопределено Тогда
				Возврат Ложь;
			ИначеЕсли ТекСтрока <> Обновление.ПолноеИмяCFUФайлаВКаталогеДистрибутивов Тогда
				Возврат Ложь;
			КонецЕсли;
			
			ТекСтрока = ЧтениеТекста.ПрочитатьСтроку();
			Если ТекСтрока = Неопределено Тогда
				Возврат Ложь;
			ИначеЕсли ТекСтрока <> Обновление.КонтрольнаяСумма Тогда
				Возврат Ложь;
			КонецЕсли;
			
			ОписательФайлаОбновления = Новый Файл(Обновление.ПолноеИмяCFUФайлаВКаталогеДистрибутивов);
			ТекСтрока = ЧтениеТекста.ПрочитатьСтроку();
			Если ТекСтрока = Неопределено Тогда
				Возврат Ложь;
			ИначеЕсли ТекСтрока <> Строка(ОписательФайлаОбновления.Размер()) Тогда
				Возврат Ложь;
			КонецЕсли;
			
			ТекСтрока = ЧтениеТекста.ПрочитатьСтроку();
			Если ТекСтрока = Неопределено Тогда
				Возврат Ложь;
			ИначеЕсли ТекСтрока <> Строка(ОписательФайлаОбновления.ПолучитьУниверсальноеВремяИзменения()) Тогда
				Возврат Ложь;
			КонецЕсли;
			
			ЧтениеТекста.Закрыть();
			Обновление.Получено = Истина;
			Возврат Истина;
			
		Исключение
			ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат Ложь;
		КонецПопытки;
		
		#КонецЕсли
		
	КонецЕсли;
	
КонецФункции

Процедура СоздатьКаталогиДляПолученияОбновления(Обновление, Контекст) Экспорт
	
	ВременныйКаталогОбновленийКонфигурации = Контекст.ВременныйКаталогОбновленийКонфигурации;
	Попытка
		СоздатьКаталог(ВременныйКаталогОбновленийКонфигурации);
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		СообщениеЖурнала =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при создании каталога для сохранения дистрибутива конфигурации (%1).'"),
				ВременныйКаталогОбновленийКонфигурации)
			+ Символы.ПС
			+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
		
		Контекст.ИмяОшибки = "ОшибкаВзаимодействияСФайловойСистемой";
		Контекст.ИнформацияОбОшибке = СообщениеЖурнала;
		Контекст.Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось создать каталог %1 для сохранения дистрибутива конфигурации. %2'"),
			ВременныйКаталогОбновленийКонфигурации,
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		Возврат;
		
	КонецПопытки;
	
	КаталогИндексаФайлов = Контекст.КаталогИндексаФайлов;
	Попытка
		СоздатьКаталог(КаталогИндексаФайлов);
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		СообщениеЖурнала =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при создании каталога (%1).'"),
				КаталогИндексаФайлов)
			+ Символы.ПС
			+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
		
		Контекст.ИмяОшибки = "ОшибкаВзаимодействияСФайловойСистемой";
		Контекст.ИнформацияОбОшибке = СообщениеЖурнала;
		Контекст.Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось создать каталог %1. %2'"),
			КаталогИндексаФайлов,
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		Возврат;
		
	КонецПопытки;
	
	// Создание каталога дистрибутива.
	Если Обновление.ФорматФайлаОбновления <> "zip" Тогда
		
		// Только cfu-файл.
		Попытка
			СоздатьКаталог(Обновление.КаталогCFUФайлаВКаталогеДистрибутивов);
		Исключение
			
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			СообщениеЖурнала =
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка при создании каталога дистрибутива конфигурации (%1).'"),
					Обновление.КаталогCFUФайлаВКаталогеДистрибутивов)
				+ Символы.ПС
				+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
			ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
			
			Контекст.ИмяОшибки = "ОшибкаВзаимодействияСФайловойСистемой";
			Контекст.ИнформацияОбОшибке = СообщениеЖурнала;
			Контекст.Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось создать каталог %1 для сохранения дистрибутива конфигурации. %2'"),
				Обновление.КаталогДистрибутива,
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
			Возврат;
			
		КонецПопытки;
		
		Обновление.Вставить("ИмяПолученногоФайла", Обновление.ПолноеИмяCFUФайлаВКаталогеДистрибутивов);
		
	Иначе
		
		Попытка
			СоздатьКаталог(Обновление.КаталогДистрибутива);
		Исключение
			
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			СообщениеЖурнала =
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка при создании каталога дистрибутива конфигурации (%1).'"),
					Обновление.КаталогДистрибутива)
				+ Символы.ПС
				+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
			ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
			
			Контекст.ИмяОшибки = "ОшибкаВзаимодействияСФайловойСистемой";
			Контекст.ИнформацияОбОшибке = СообщениеЖурнала;
			Контекст.Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось создать каталог %1 для сохранения дистрибутива конфигурации. %2'"),
				Обновление.КаталогДистрибутива,
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
			Возврат;
			
		КонецПопытки;
		
		Обновление.Вставить("ИмяПолученногоФайла",
			ВременныйКаталогОбновленийКонфигурации
				+ СтрЗаменить(Обновление.ПодкаталогШаблонов, "\", "_")
				+ "1cv8.zip");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗавершитьПолучениеОбновления(Обновление, Контекст) Экспорт
	
	// Извлечение дистрибутива.
	Если Обновление.ФорматФайлаОбновления = "zip" Тогда
		
		// Извлечение из архива.
		Попытка
			ЧтениеZIP = Новый ЧтениеZipФайла(Обновление.ИмяПолученногоФайла);
			ЧтениеZIP.ИзвлечьВсе(Обновление.КаталогДистрибутива,
				РежимВосстановленияПутейФайловZIP.Восстанавливать);
		Исключение
			
			СообщениеЖурнала =
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка при извлечении файлов архива (%1) в каталог %2.'"),
					Обновление.ИмяПолученногоФайла,
					Обновление.КаталогДистрибутива)
				+ Символы.ПС
				+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
			
			Контекст.ИмяОшибки          = "ОшибкаИзвлеченияДанныхИзФайла";
			Контекст.ИнформацияОбОшибке = СообщениеЖурнала;
			Контекст.Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось извлечь файлы дистрибутива. %1'"),
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
			
		КонецПопытки;
		
		ЧтениеZIP.Закрыть();
		
		// Проверка существования cfu-файла в полученном дистрибутиве.
		Если Не ФайлСуществует(Обновление.ПолноеИмяCFUФайлаВКаталогеДистрибутивов, Ложь) Тогда
			
			Контекст.ИмяОшибки          = "ОшибкаДистрибутиваКонфигурации";
			Контекст.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Некорректный файл дистрибутива %1. Отсутствует файл обновления конфигурации %2.'"),
				Обновление.URLФайлаОбновления,
				Обновление.ОтносительныйПутьCFUФайла);
			ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(Контекст.ИнформацияОбОшибке);
			Контекст.Сообщение = НСтр("ru = 'Дистрибутив не содержит файл обновления конфигурации.'");
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Обновление.ФорматФайлаОбновления = "zip" Тогда
		Попытка
			УдалитьФайлы(Обновление.ИмяПолученногоФайла);
		Исключение
			ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЕсли;
	
	
	// Запись индексного файла.
	Попытка
		
		ПолноеИмяИндексногоФайла = Контекст.КаталогИндексаФайлов + Обновление.ИмяИндексногоФайла;
		ОписательФайлаОбновления = Новый Файл(Обновление.ПолноеИмяCFUФайлаВКаталогеДистрибутивов);
		
		ЗаписьТекста = Новый ЗаписьТекста(ПолноеИмяИндексногоФайла);
		ЗаписьТекста.ЗаписатьСтроку(Обновление.ПолноеИмяCFUФайлаВКаталогеДистрибутивов);
		ЗаписьТекста.ЗаписатьСтроку(Обновление.КонтрольнаяСумма);
		ЗаписьТекста.ЗаписатьСтроку(Строка(ОписательФайлаОбновления.Размер()));
		ЗаписьТекста.ЗаписатьСтроку(Строка(ОписательФайлаОбновления.ПолучитьУниверсальноеВремяИзменения()));
		ЗаписьТекста.Закрыть();
		
	Исключение
		ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// Прочие служебные процедуры и функции

Функция ИмяСобытияЖурналаРегистрации(КодОсновногоЯзыка) Экспорт
	
	Возврат НСтр("ru = 'Получение обновлений программы'", КодОсновногоЯзыка);
	
КонецФункции

#КонецОбласти