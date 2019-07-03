///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЧислоВерсийВБазе = ЧислоВерсийВБазе();
	ТипХраненияВТомах = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске;
	
	РазмерВерсийВБазеВБайтах = РазмерВерсийВБазе();
	РазмерВерсийВБазе = РазмерВерсийВБазеВБайтах / 1048576;
	
	ДополнительныеПараметры = Новый Структура;
	
	ДополнительныеПараметры.Вставить(
		"ПриОткрытииХранитьФайлыВТомахНаДиске",
		РаботаСФайламиСлужебный.ХранениеФайловВТомахНаДиске());
	
	ДополнительныеПараметры.Вставить(
		"ПриОткрытииЕстьТомаХраненияФайлов",
		РаботаСФайлами.ЕстьТомаХраненияФайлов());
		
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.ДекорацияИконка.Видимость = Ложь;
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ДополнительныеПараметры.ПриОткрытииХранитьФайлыВТомахНаДиске Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не установлен тип хранения файлов ""В томах на диске""'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеПараметры.ПриОткрытииЕстьТомаХраненияФайлов Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Нет ни одного тома для размещения файлов'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПереносФайловВТома(Команда)
	
	СвойстваХраненияФайлов = СвойстваХраненияФайлов();
	
	Если СвойстваХраненияФайлов.ТипХраненияФайлов <> ТипХраненияВТомах Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не установлен тип хранения файлов ""В томах на диске""'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ СвойстваХраненияФайлов.ЕстьТомаХраненияФайлов Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нет ни одного тома для размещения файлов'"));
		Возврат;
	КонецЕсли;
	
	Если ЧислоВерсийВБазе = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нет ни одного файла в информационной базе'"));
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Выполнить перенос файлов в информационной базе в тома хранения файлов?
		|
		|Эта операция может занять продолжительное время.'");
	Обработчик = Новый ОписаниеОповещения("ВыполнитьПереносФайловВТомаЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьПереносФайловВТомаЗавершение(Ответ, ПараметрыВыполнения) Экспорт
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	МассивВерсий = ВерсииВБазе();
	НомерЦикла = 1;
	ЧислоПеренесенных = 0;
	
	ЧислоВерсийВПакете = 10;
	ПакетВерсий = Новый Массив;
	
	МассивФайловСОшибками = Новый Массив;
	ОбработкаПрервана = Ложь;
	
	Для Каждого ВерсияСтруктура Из МассивВерсий Цикл
		
		ПакетВерсий.Добавить(ВерсияСтруктура);
		
		Если ПакетВерсий.Количество() >= ЧислоВерсийВПакете Тогда
			ЧислоПеренесенныхВПакете = ПеренестиМассивВерсийВТом(ПакетВерсий, МассивФайловСОшибками);
			
			Если ЧислоПеренесенныхВПакете = 0 И ПакетВерсий.Количество() = ЧислоВерсийВПакете Тогда
				ОбработкаПрервана = Истина; // Весь пакет не смогли перенести - прекращаем операцию.
				Прервать;
			КонецЕсли;
			
			ЧислоПеренесенных = ЧислоПеренесенных + ЧислоПеренесенныхВПакете;
			ПакетВерсий.Очистить();
			
		КонецЕсли;
		
		НомерЦикла = НомерЦикла + 1;
	КонецЦикла;
	
	Если ПакетВерсий.Количество() <> 0 Тогда
		ЧислоПеренесенныхВПакете = ПеренестиМассивВерсийВТом(ПакетВерсий, МассивФайловСОшибками);
		
		Если ЧислоПеренесенныхВПакете = 0 Тогда
			ОбработкаПрервана = Истина; // Весь пакет не смогли перенести - прекращаем операцию.
		КонецЕсли;
		
		ЧислоПеренесенных = ЧислоПеренесенных + ЧислоПеренесенныхВПакете;
		ПакетВерсий.Очистить();
	КонецЕсли;
	
	ЧислоВерсийВБазе = ЧислоВерсийВБазе();
	РазмерВерсийВБазеВБайтах = РазмерВерсийВБазе();
	РазмерВерсийВБазе = РазмерВерсийВБазеВБайтах / 1048576;
	
	Если ЧислоПеренесенных <> 0 Тогда
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Завершен перенос файлов в тома.
			           |Перенесено файлов: %1'"),
			ЧислоПеренесенных);
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
	
	Если МассивФайловСОшибками.Количество() <> 0 Тогда
		
		Пояснение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Количество ошибок при переносе: %1'"),
			МассивФайловСОшибками.Количество());
			
		Если ОбработкаПрервана Тогда
			Пояснение = НСтр("ru = 'Не удалось перенести ни одного файла из пакета.
			                       |Перенос прерван.'");
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Пояснение", Пояснение);
		ПараметрыФормы.Вставить("МассивФайловСОшибками", МассивФайловСОшибками);
		
		ОткрытьФорму("Обработка.ПереносФайловВТома.Форма.ФормаОтчета", ПараметрыФормы);
		
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Функция РазмерВерсийВБазе()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(ВерсииФайлов.Размер), 0) КАК Размер
	|ИЗ
	|	Справочник.ВерсииФайлов КАК ВерсииФайлов
	|ГДЕ
	|	ВерсииФайлов.ТипХраненияФайла = Значение(Перечисление.ТипыХраненияФайлов.ВИнформационнойБазе)";
	
	Для Каждого ТипСправочника Из Метаданные.ОпределяемыеТипы.ПрисоединенныйФайл.Тип.Типы() Цикл
		ПолноеИмяСправочника = Метаданные.НайтиПоТипу(ТипСправочника).ПолноеИмя();
		Если ПолноеИмяСправочника <> "Справочник.Файлы" И ПолноеИмяСправочника <> "Справочник.ВерсииФайлов" Тогда
			Запрос.Текст = Запрос.Текст + 
			"
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ЕСТЬNULL(СУММА(ВерсииФайлов.Размер), 0) КАК Размер
			|ИЗ
			|	" + ПолноеИмяСправочника + " КАК ВерсииФайлов
			|ГДЕ
			|	ВерсииФайлов.ТипХраненияФайла = ЗНАЧЕНИЕ(Перечисление.ТипыХраненияФайлов.ВИнформационнойБазе)";
		КонецЕсли;
	КонецЦикла;
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Размер;
	
КонецФункции

&НаСервере
Функция ЧислоВерсийВБазе()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	РегистрСведений.ДвоичныеДанныеФайлов КАК ДвоичныеДанныеФайлов";
	Запрос.УстановитьПараметр("ТипХраненияФайла", Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Количество;
	
КонецФункции

&НаСервере
Функция ВерсииВБазе()
	
	МассивВерсий = Новый Массив;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВерсииФайлов.Ссылка КАК Ссылка,
		|	ВерсииФайлов.Наименование КАК ПолноеНаименование,
		|	ВерсииФайлов.Размер КАК Размер
		|ИЗ
		|	Справочник.ВерсииФайлов КАК ВерсииФайлов
		|ГДЕ
		|	ВерсииФайлов.ТипХраненияФайла = ЗНАЧЕНИЕ(Перечисление.ТипыХраненияФайлов.ВИнформационнойБазе)
		|";
	
	Для Каждого ТипСправочника Из Метаданные.ОпределяемыеТипы.ПрисоединенныйФайл.Тип.Типы() Цикл
		ПолноеИмяСправочника = Метаданные.НайтиПоТипу(ТипСправочника).ПолноеИмя();
		Если ПолноеИмяСправочника <> "Справочник.Файлы" И ПолноеИмяСправочника <> "Справочник.ВерсииФайлов" Тогда
			Запрос.Текст = Запрос.Текст + 
			"
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ВерсииФайлов.Ссылка КАК Ссылка,
			|	ВерсииФайлов.Наименование КАК ПолноеНаименование,
			|	ВерсииФайлов.Размер КАК Размер
			|ИЗ
			|	" + ПолноеИмяСправочника + " КАК ВерсииФайлов
			|ГДЕ
			|	ВерсииФайлов.ТипХраненияФайла = ЗНАЧЕНИЕ(Перечисление.ТипыХраненияФайлов.ВИнформационнойБазе)";
		КонецЕсли;
	КонецЦикла;
	
	Результат = Запрос.Выполнить();
	ТаблицаВыгрузки = Результат.Выгрузить();
	
	Для Каждого Строка Из ТаблицаВыгрузки Цикл
		ВерсияСтруктура = Новый Структура("Ссылка, Текст, Размер", 
			Строка.Ссылка, Строка.ПолноеНаименование, Строка.Размер);
		МассивВерсий.Добавить(ВерсияСтруктура);
	КонецЦикла;
	
	Возврат МассивВерсий;
	
КонецФункции

&НаСервереБезКонтекста
Функция СвойстваХраненияФайлов()
	
	СвойстваХраненияФайлов = Новый Структура;
	
	СвойстваХраненияФайлов.Вставить(
		"ТипХраненияФайлов", РаботаСФайламиСлужебный.ТипХраненияФайлов());
	
	СвойстваХраненияФайлов.Вставить(
		"ЕстьТомаХраненияФайлов", РаботаСФайлами.ЕстьТомаХраненияФайлов());
	
	Возврат СвойстваХраненияФайлов;
	
КонецФункции

&НаСервере
Функция ПеренестиМассивВерсийВТом(ПакетВерсий, МассивФайловСОшибками)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЧислоОбработанных = 0;
	МаксимальныйРазмерФайла = РаботаСФайлами.МаксимальныйРазмерФайла();
	
	Для Каждого ВерсияСтруктура Из ПакетВерсий Цикл
		
		Если ПеренестиВерсиюВТом(ВерсияСтруктура, МаксимальныйРазмерФайла, МассивФайловСОшибками) Тогда
			ЧислоОбработанных = ЧислоОбработанных + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЧислоОбработанных;
	
КонецФункции

&НаСервере
Функция ПеренестиВерсиюВТом(ВерсияСтруктура, МаксимальныйРазмерФайла, МассивФайловСОшибками)
	
	КодВозврата = Истина;
	
	ВерсияСсылка = ВерсияСтруктура.Ссылка;
	Если ТипЗнч(ВерсияСсылка) = Тип("СправочникСсылка.ВерсииФайлов") Тогда
		ФайлСсылка = ВерсияСсылка.Владелец;
	Иначе
		ФайлСсылка = ВерсияСсылка;
	КонецЕсли;
	Размер = ВерсияСтруктура.Размер;
	ИмяДляЖурнала = "";
	
	Если Размер > МаксимальныйРазмерФайла Тогда
		
		ИмяДляЖурнала = ВерсияСтруктура.Текст;
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Файлы.Ошибка переноса файла в том'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,, ФайлСсылка,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'При переносе в том файла
				           |""%1""
				           |возникла ошибка:
				           |""Размер превышает максимальный"".'"),
				ИмяДляЖурнала));
		
		Возврат Ложь; // ничего не сообщаем 
	КонецЕсли;
	
	ИмяДляЖурнала = ВерсияСтруктура.Текст;
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Файлы.Начат перенос файла в том'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,, ФайлСсылка,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Начат перенос в том файла
			           |""%1"".'"),
			ИмяДляЖурнала));
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(ФайлСсылка);
	Исключение
		Возврат Ложь; // ничего не сообщаем 
	КонецПопытки;
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(ВерсияСсылка);
	Исключение
		РазблокироватьДанныеДляРедактирования(ФайлСсылка);
		Возврат Ложь; // ничего не сообщаем 
	КонецПопытки;
	
	ТипХраненияФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВерсияСсылка, "ТипХраненияФайла");
	Если ТипХраненияФайла <> Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда // Файл уже в томе.
		РазблокироватьДанныеДляРедактирования(ФайлСсылка);
		РазблокироватьДанныеДляРедактирования(ВерсияСсылка);
		Возврат Ложь;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		БлокировкаВерсии = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаВерсии.Добавить(Метаданные.НайтиПоТипу(ТипЗнч(ВерсияСсылка)).ПолноеИмя());
		ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", ВерсияСсылка);
		БлокировкаВерсии.Заблокировать();
		
		ВерсияОбъект = ВерсияСсылка.ПолучитьОбъект();
		ХранилищеФайла = РаботаСФайлами.ХранилищеФайлаИзИнформационнойБазы(ВерсияСсылка);
		Если ТипЗнч(ВерсияОбъект) = Тип("СправочникОбъект.ВерсииФайлов") Тогда
			СведенияОФайле = РаботаСФайламиСлужебный.ДобавитьФайлВТом(ХранилищеФайла.Получить(), ВерсияОбъект.ДатаМодификацииУниверсальная, 
				ВерсияОбъект.ПолноеНаименование, ВерсияОбъект.Расширение, ВерсияОбъект.НомерВерсии, ФайлСсылка.Зашифрован, 
				// Чтобы все файлы не попали в одну папку за сегодняшний день - подставляем дату создания файла.
				ВерсияОбъект.ДатаМодификацииУниверсальная);
		Иначе
			СведенияОФайле = РаботаСФайламиСлужебный.ДобавитьФайлВТом(ХранилищеФайла.Получить(), ВерсияОбъект.ДатаМодификацииУниверсальная, 
				ВерсияОбъект.Наименование, ВерсияОбъект.Расширение, , ФайлСсылка.Зашифрован, 
				// Чтобы все файлы не попали в одну папку за сегодняшний день - подставляем дату создания файла.
				ВерсияОбъект.ДатаМодификацииУниверсальная);
		КонецЕсли;
			
		ВерсияОбъект.Том = СведенияОФайле.Том;
		ВерсияОбъект.ПутьКФайлу = СведенияОФайле.ПутьКФайлу;
		ВерсияОбъект.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске;
		ВерсияОбъект.ФайлХранилище = Новый ХранилищеЗначения("");
		// Чтобы прошла запись ранее подписанного объекта.
		ВерсияОбъект.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина);
		ВерсияОбъект.Записать();
		
		БлокировкаОбъекта = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаОбъекта.Добавить(Метаданные.НайтиПоТипу(ТипЗнч(ФайлСсылка)).ПолноеИмя());
		ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", ФайлСсылка);
		БлокировкаОбъекта.Заблокировать();
		
		ФайлОбъект = ФайлСсылка.ПолучитьОбъект();
		// Чтобы прошла запись ранее подписанного объекта.
		ФайлОбъект.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина);
		ФайлОбъект.Записать(); // Для переноса полей версии в файл.
		
		РаботаСФайламиСлужебный.УдалитьЗаписьИзРегистраДвоичныеДанныеФайлов(ВерсияСсылка);
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Файлы.Завершен перенос файла в том'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация,, ФайлСсылка,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Завершен перенос в том файла
				           |""%1"".'"), ИмяДляЖурнала));
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		СтруктураОшибки = Новый Структура;
		СтруктураОшибки.Вставить("ИмяФайла", ИмяДляЖурнала);
		СтруктураОшибки.Вставить("Ошибка",   КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		СтруктураОшибки.Вставить("Версия",   ВерсияСсылка);
		
		МассивФайловСОшибками.Добавить(СтруктураОшибки);
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Файлы.Ошибка переноса файла в том'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,, ФайлСсылка,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'При переносе в том файла
				           |""%1""
				           |возникла ошибка:
				           |""%2"".'"),
				ИмяДляЖурнала,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке)));
				
		КодВозврата = Ложь;
		
	КонецПопытки;
	
	РазблокироватьДанныеДляРедактирования(ФайлСсылка);
	РазблокироватьДанныеДляРедактирования(ВерсияСсылка);
	
	Возврат КодВозврата;
	
КонецФункции

#КонецОбласти
