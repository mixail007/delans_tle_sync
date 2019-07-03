///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики операций

// Соответствует операции DeliverMessages.
Функция ДоставитьСообщения(КодОтправителя, ПотокХранилище)
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Получаем ссылку на отправителя.
	Отправитель = ПланыОбмена.ОбменСообщениями.НайтиПоКоду(КодОтправителя);
	
	Если Отправитель.Пустая() Тогда
		
		ВызватьИсключение НСтр("ru = 'Заданы неправильные настройки подключения к конечной точке.'");
		
	КонецЕсли;
	
	ЗагруженныеСообщения = Неопределено;
	ДанныеПрочитаныЧастично = Ложь;
	
	// Загружаем сообщения в информационную базу.
	ОбменСообщениямиВнутренний.СериализоватьДанныеИзПотока(
		Отправитель,
		ПотокХранилище.Получить(),
		ЗагруженныеСообщения,
		ДанныеПрочитаныЧастично);
	
	// Обрабатываем очередь сообщений.
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		ОбменСообщениямиВнутренний.ОбработатьОчередьСообщенийСистемы(ЗагруженныеСообщения);
		
	Иначе
		
		ПараметрыПроцедуры = Новый Структура;
		ПараметрыПроцедуры.Вставить("ЗагруженныеСообщения", ЗагруженныеСообщения);
		
		ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
		ПараметрыВыполнения.ЗапуститьВФоне = Истина;
		
		ДлительныеОперации.ВыполнитьВФоне(
			"ОбменСообщениямиВнутренний.ОбработатьОчередьСообщенийСистемыВФоне",
			ПараметрыПроцедуры,
			ПараметрыВыполнения);
		
	КонецЕсли;
	
	Если ДанныеПрочитаныЧастично Тогда
		
		ВызватьИсключение НСтр("ru = 'Произошла ошибка при доставке быстрых сообщений - некоторые сообщения
                                |не были доставлены из-за установленных блокировок областей данных.
                                |
                                |Эти сообщения будут обработаны в рамках очереди обработки сообщений системы.'");
		
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Соответствует операции DeliverMessages.
Функция ПолучитьПараметрыИнформационнойБазы(НаименованиеЭтойКонечнойТочки)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПустаяСтрока(ОбменСообщениямиВнутренний.КодЭтогоУзла()) Тогда
		
		ЭтотУзелОбъект = ОбменСообщениямиВнутренний.ЭтотУзел().ПолучитьОбъект();
		ЭтотУзелОбъект.Код = Строка(Новый УникальныйИдентификатор());
		ЭтотУзелОбъект.Наименование = ?(ПустаяСтрока(НаименованиеЭтойКонечнойТочки),
									ОбменСообщениямиВнутренний.НаименованиеЭтогоУзлаПоУмолчанию(),
									НаименованиеЭтойКонечнойТочки);
		ЭтотУзелОбъект.Записать();
		
	ИначеЕсли ПустаяСтрока(ОбменСообщениямиВнутренний.НаименованиеЭтогоУзла()) Тогда
		
		ЭтотУзелОбъект = ОбменСообщениямиВнутренний.ЭтотУзел().ПолучитьОбъект();
		ЭтотУзелОбъект.Наименование = ?(ПустаяСтрока(НаименованиеЭтойКонечнойТочки),
									ОбменСообщениямиВнутренний.НаименованиеЭтогоУзлаПоУмолчанию(),
									НаименованиеЭтойКонечнойТочки);
		ЭтотУзелОбъект.Записать();
		
	КонецЕсли;
	
	ПараметрыЭтойТочки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОбменСообщениямиВнутренний.ЭтотУзел(), "Код, Наименование");
	
	Результат = Новый Структура;
	Результат.Вставить("Код",          ПараметрыЭтойТочки.Код);
	Результат.Вставить("Наименование", ПараметрыЭтойТочки.Наименование);
	
	Возврат ЗначениеВСтрокуВнутр(Результат);
КонецФункции

// Соответствует операции ConnectEndPoint.
Функция ПодключитьКонечнуюТочку(Код, Наименование, НастройкиПодключенияПолучателяСтрокой)
	
	Отказ = Ложь;
	
	ОбменСообщениямиВнутренний.ВыполнитьПодключениеКонечнойТочкиНаСторонеПолучателя(Отказ, Код, Наименование, ЗначениеИзСтрокиВнутр(НастройкиПодключенияПолучателяСтрокой));
	
	Возврат Не Отказ;
КонецФункции

// Соответствует операции UpdateConnectionSettings.
Функция ОбновитьНастройкиПодключения(Код, НастройкиПодключенияСтрокой)
	
	НастройкиПодключения = ЗначениеИзСтрокиВнутр(НастройкиПодключенияСтрокой);
	
	УстановитьПривилегированныйРежим(Истина);
	
	КонечнаяТочка = ПланыОбмена.ОбменСообщениями.НайтиПоКоду(Код);
	Если КонечнаяТочка.Пустая() Тогда
		ВызватьИсключение НСтр("ru = 'Заданы неправильные настройки подключения к конечной точке.'");
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		// Обновляем настройки подключения.
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("КонечнаяТочка", КонечнаяТочка);
		
		СтруктураЗаписи.Вставить("АдресВебСервиса", НастройкиПодключения.WSURLВебСервиса);
		СтруктураЗаписи.Вставить("ИмяПользователя", НастройкиПодключения.WSИмяПользователя);
		СтруктураЗаписи.Вставить("Пароль",          НастройкиПодключения.WSПароль);
		СтруктураЗаписи.Вставить("ЗапомнитьПароль", Истина);
		
		// добавляем запись в РС
		РегистрыСведений.НастройкиТранспортаОбменаСообщениями.ОбновитьЗапись(СтруктураЗаписи);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат "";
	
КонецФункции

// Соответствует операции SetLeadingEndPoint.
Функция УстановитьВедущуюКонечнуюТочку(КодЭтойКонечнойТочки, КодВедущейКонечнойТочки)
	
	ОбменСообщениямиВнутренний.УстановитьВедущуюКонечнуюТочкуНаСторонеПолучателя(КодЭтойКонечнойТочки, КодВедущейКонечнойТочки);
	
	Возврат "";
	
КонецФункции

// Соответствует операции TestConnectionRecipient.
Функция ПроверитьПодключениеНаСторонеПолучателя(НастройкиПодключенияСтрокой, КодОтправителя)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтрокаСообщенияОбОшибке = "";
	
	WSПрокси = ОбменСообщениямиВнутренний.ПолучитьWSПрокси(ЗначениеИзСтрокиВнутр(НастройкиПодключенияСтрокой), СтрокаСообщенияОбОшибке);
	
	Если WSПрокси = Неопределено Тогда
		ВызватьИсключение СтрокаСообщенияОбОшибке;
	КонецЕсли;
	
	WSПрокси.TestConnectionSender(КодОтправителя);
	
	Возврат "";
	
КонецФункции

// Соответствует операции TestConnectionSender.
Функция ПроверитьПодключениеНаСторонеОтправителя(КодОтправителя)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбменСообщениямиВнутренний.КодЭтогоУзла() <> КодОтправителя Тогда
		
		ВызватьИсключение НСтр("ru = 'Настройки подключения базы получателя указывают на другого отправителя.'");
		
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

#КонецОбласти
