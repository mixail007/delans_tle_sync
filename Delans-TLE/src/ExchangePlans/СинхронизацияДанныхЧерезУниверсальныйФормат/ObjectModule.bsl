#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
		
		ИспользоватьОтборПоОрганизациям = Ложь;
		РежимВыгрузкиСправочников       = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		РежимВыгрузкиПриНеобходимости   = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		
	Иначе
		
		РежимВыгрузкиПриНеобходимости    = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		
		Если ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" Тогда
			РежимВыгрузкиСправочников    = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		Иначе
			РежимВыгрузкиСправочников    = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
	ИначеЕсли ПравилаОтправкиДокументов = "ИнтерактивнаяСинхронизация" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
	Иначе
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов <> "АвтоматическаяСинхронизация" Тогда
		ИспользоватьОтборПоВидамДокументов = Ложь;
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов = "ИнтерактивнаяСинхронизация" Тогда
		РучнойОбмен = Истина;
	Иначе
		РучнойОбмен = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьОтборПоОрганизациям И Организации.Количество() <> 0 Тогда
		Организации.Очистить();
	ИначеЕсли Организации.Количество() = 0 И ИспользоватьОтборПоОрганизациям Тогда
		ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьОтборПоВидамДокументов И ВидыДокументов.Количество() <> 0 Тогда
		ВидыДокументов.Очистить();
	ИначеЕсли ВидыДокументов.Количество() = 0 И ИспользоватьОтборПоВидамДокументов Тогда
		ИспользоватьОтборПоВидамДокументов = Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ОбобщенныйСклад) Тогда
		ОбобщенныйСклад = Справочники.СтруктурныеЕдиницы.ОсновнойСклад;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВерсияФорматаОбмена) Тогда
		ВерсияФорматаОбмена = "1.6";
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Попытка
		ОбменДаннымиXDTOСервер.ПропускатьОбъектыСОшибкамиПроверкиПоСхеме(Ссылка, ПропускатьНекорректныеОбъектыПриВыгрузке);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ПолучитьФункциональнуюОпцию("РазрешитьСкладыВТабличныхЧастях") Тогда
		РеквизитОбобщенныйСклад = ПроверяемыеРеквизиты.Найти("ОбобщенныйСклад");
		Если РеквизитОбобщенныйСклад <> Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(РеквизитОбобщенныйСклад);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьОбъект(ДанныеЗаполнения);
	
КонецПроцедуры


#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОбъект(ДанныеЗаполнения)
	
	Если Не ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	
	// настройка отборов
	ДатаНачалаВыгрузкиДокументов = НачалоГода(ТекущаяДата());
	ИспользоватьОтборПоОрганизациям = Ложь;
	ИспользоватьОтборПоВидамДокументов = Ложь;
	РучнойОбмен = Ложь;
	АвтоматическиЗачитыватьАвансы = Ложь;
	ОбобщенныйСклад = Справочники.СтруктурныеЕдиницы.ОсновнойСклад;
	ПропускатьНекорректныеОбъектыПриВыгрузке = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
