////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК КАНАЛОВ СООБЩЕНИЙ ДЛЯ ВЕРСИИ 2.1.2.1 ИНТЕРФЕЙСА СООБЩЕНИЙ
//  УПРАВЛЕНИЯ АДМИНИСТРИРОВАНИЕМ ОБМЕНА ДАННЫМИ
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен версии интерфейса сообщений.
//
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/ExchangeAdministration/Manage";
	
КонецФункции

// Возвращает версию интерфейса сообщений, обслуживаемую обработчиком.
//
Функция Версия() Экспорт
	
	Возврат "2.1.2.1";
	
КонецФункции

// Возвращает базовый тип для сообщений версии.
//
Функция БазовыйТип() Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипТело();
	
КонецФункции

// Выполняет обработку входящих сообщений модели сервиса
//
// Параметры:
//  Сообщение - ОбъектXDTO, входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями, узел плана обмена, соответствующий отправителю сообщения
//  СообщениеОбработано - булево, флаг успешной обработки сообщения. Значение данного параметра необходимо
//    установить равным Истина в том случае, если сообщение было успешно прочитано в данном обработчике.
//
Процедура ОбработатьСообщениеМоделиСервиса(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
	СообщениеОбработано = Истина;
	
	Словарь = СообщенияАдминистрированиеОбменаДаннымиУправлениеИнтерфейс;
	ТипСообщения = Сообщение.Body.Тип();
	
	Если ТипСообщения = Словарь.СообщениеПодключитьКорреспондента(Пакет()) Тогда
		ПодключитьКорреспондента(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУстановитьНастройкиТранспорта(Пакет()) Тогда
		УстановитьНастройкиТранспорта(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУдалитьНастройкуСинхронизации(Пакет()) Тогда
		УдалитьНастройкуСинхронизации(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеВыполнитьСинхронизацию(Пакет()) Тогда
		ВыполнитьСинхронизацию(Сообщение, Отправитель);
	Иначе
		СообщениеОбработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПодключитьКорреспондента(Сообщение, Отправитель)
	
	Тело = Сообщение.Body;
	
	// Проверяем эту конечную точку
	ЭтаКонечнаяТочка = ПланыОбмена.ОбменСообщениями.НайтиПоКоду(Тело.SenderId);
	
	Если ЭтаКонечнаяТочка.Пустая()
		ИЛИ ЭтаКонечнаяТочка <> ОбменСообщениямиВнутренний.ЭтотУзел() Тогда
		
		// Отправляем сообщение в менеджер сервиса об ошибке
		ПредставлениеОшибки = НСтр("ru = 'Конечная точка не соответствует ожидаемой. Код ожидаемой конечной точки %1. Код текущей конечной точки %2.'");
		ПредставлениеОшибки = СтрШаблон(ПредставлениеОшибки,
			Тело.SenderId,
			ОбменСообщениямиВнутренний.КодЭтогоУзла());
		
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииПодключениеКорреспондента(),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		
		ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаПодключенияКорреспондента());
		ОтветноеСообщение.Body.RecipientId      = Тело.RecipientId;
		ОтветноеСообщение.Body.SenderId         = Тело.SenderId;
		ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
		
		НачатьТранзакцию();
		СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель);
		ЗафиксироватьТранзакцию();
		Возврат;
	КонецЕсли;
	
	// Проверяем то, что корреспондент уже был подключен ранее
	Корреспондент = ПланыОбмена.ОбменСообщениями.НайтиПоКоду(Тело.RecipientId);
	
	Если Корреспондент.Пустая() Тогда // Подключаем конечную точку корреспондента
		
		Отказ = Ложь;
		ПодключенныйКорреспондент = Неопределено;
		
		НастройкиПодключенияОтправителя = ТехнологияСервисаИнтеграцияСБСП.СтруктураПараметровWS();
		НастройкиПодключенияОтправителя.WSURLВебСервиса = Тело.RecipientURL;
		НастройкиПодключенияОтправителя.WSИмяПользователя = Тело.RecipientUser;
		НастройкиПодключенияОтправителя.WSПароль = Тело.RecipientPassword;
		
		НастройкиПодключенияПолучателя = ТехнологияСервисаИнтеграцияСБСП.СтруктураПараметровWS();
		НастройкиПодключенияПолучателя.WSURLВебСервиса = Тело.SenderURL;
		НастройкиПодключенияПолучателя.WSИмяПользователя = Тело.SenderUser;
		НастройкиПодключенияПолучателя.WSПароль = Тело.SenderPassword;
		
		ОбменСообщениями.ПодключитьКонечнуюТочку(
									Отказ,
									НастройкиПодключенияОтправителя,
									НастройкиПодключенияПолучателя,
									ПодключенныйКорреспондент,
									Тело.RecipientName,
									Тело.SenderName);
		
		Если Отказ Тогда // Отправляем сообщение в менеджер сервиса об ошибке
			
			ПредставлениеОшибки = НСтр("ru = 'Ошибка подключения конечной точки корреспондента обмена. Код конечной точки корреспондента обмена %1.'");
			ПредставлениеОшибки = СтрШаблон(ПредставлениеОшибки,
				Тело.RecipientId);
			
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииПодключениеКорреспондента(),
				УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			
			ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
				СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаПодключенияКорреспондента());
			ОтветноеСообщение.Body.RecipientId      = Тело.RecipientId;
			ОтветноеСообщение.Body.SenderId         = Тело.SenderId;
			ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
			
			НачатьТранзакцию();
			СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель);
			ЗафиксироватьТранзакцию();
			Возврат;
		КонецЕсли;
		
		ПодключенныйКорреспондентКод = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПодключенныйКорреспондент, "Код");
		
		Если ПодключенныйКорреспондентКод <> Тело.RecipientId Тогда
			
			// Подключили не того корреспондента обмена.
			// Отправляем сообщение в менеджер сервиса об ошибке.
			ПредставлениеОшибки = НСтр("ru = 'Ошибка при подключении конечной точки корреспондента обмена.
				|Настройки подключения веб-сервиса не соответствуют ожидаемым.
				|Код ожидаемой конечной точки корреспондента обмена %1.
				|Код подключенной конечной точки корреспондента обмена %2.'");
			ПредставлениеОшибки = СтрШаблон(ПредставлениеОшибки,
				Тело.RecipientId,
				ПодключенныйКорреспондентКод);
			
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииПодключениеКорреспондента(),
				УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			
			ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
				СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаПодключенияКорреспондента());
			ОтветноеСообщение.Body.RecipientId      = Тело.RecipientId;
			ОтветноеСообщение.Body.SenderId         = Тело.SenderId;
			ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
			
			НачатьТранзакцию();
			СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель);
			ЗафиксироватьТранзакцию();
			Возврат;
		КонецЕсли;
		
		КорреспондентОбъект = ПодключенныйКорреспондент.ПолучитьОбъект();
		КорреспондентОбъект.Заблокирована = Истина;
		КорреспондентОбъект.Записать();
		
	Иначе // Обновляем настройки подключения этой конечной точки и корреспондента
		
		Отказ = Ложь;
		
		НастройкиПодключенияОтправителя = ТехнологияСервисаИнтеграцияСБСП.СтруктураПараметровWS();
		НастройкиПодключенияОтправителя.WSURLВебСервиса = Тело.RecipientURL;
		НастройкиПодключенияОтправителя.WSИмяПользователя = Тело.RecipientUser;
		НастройкиПодключенияОтправителя.WSПароль = Тело.RecipientPassword;
		
		НастройкиПодключенияПолучателя = ТехнологияСервисаИнтеграцияСБСП.СтруктураПараметровWS();
		НастройкиПодключенияПолучателя.WSURLВебСервиса = Тело.SenderURL;
		НастройкиПодключенияПолучателя.WSИмяПользователя = Тело.SenderUser;
		НастройкиПодключенияПолучателя.WSПароль = Тело.SenderPassword;
		
		ОбменСообщениями.ОбновитьНастройкиПодключенияКонечнойТочки(
									Отказ,
									Корреспондент,
									НастройкиПодключенияОтправителя,
									НастройкиПодключенияПолучателя);
		
		Если Отказ Тогда // Отправляем сообщение в менеджер сервиса об ошибке
			
			ПредставлениеОшибки = НСтр("ru = 'Ошибка обновления параметров подключения этой конечной точки и конечной точки корреспондента обмена.
				|Код этой конечной токи %1
				|Код конечной точки корреспондента обмена %2'");
			ПредставлениеОшибки = СтрШаблон(ПредставлениеОшибки,
				ОбменСообщениямиВнутренний.КодЭтогоУзла(),
				Тело.RecipientId);
			
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииПодключениеКорреспондента(),
				УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			
			ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
				СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаПодключенияКорреспондента());
			ОтветноеСообщение.Body.RecipientId      = Тело.RecipientId;
			ОтветноеСообщение.Body.SenderId         = Тело.SenderId;
			ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
			
			НачатьТранзакцию();
			СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель);
			ЗафиксироватьТранзакцию();
			Возврат;
		КонецЕсли;
		
		КорреспондентОбъект = Корреспондент.ПолучитьОбъект();
		КорреспондентОбъект.Заблокирована = Истина;
		КорреспондентОбъект.Записать();
		
	КонецЕсли;
	
	// Отправляем сообщение в менеджер сервиса об успешном выполнении операции
	НачатьТранзакцию();
	ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
		СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс.СообщениеКорреспондентУспешноПодключен());
	ОтветноеСообщение.Body.RecipientId = Тело.RecipientId;
	ОтветноеСообщение.Body.SenderId    = Тело.SenderId;
	СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель);
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура УстановитьНастройкиТранспорта(Сообщение, Отправитель)
	
	Тело = Сообщение.Body;
	
	Корреспондент = ПланыОбмена.ОбменСообщениями.НайтиПоКоду(Тело.RecipientId);
	
	Если Корреспондент.Пустая() Тогда
		СтрокаСообщения = НСтр("ru = 'Не найдена конечная точка корреспондента с кодом ""%1"".'");
		СтрокаСообщения = СтрШаблон(СтрокаСообщения, Тело.RecipientId);
		ВызватьИсключение СтрокаСообщения;
	КонецЕсли;
	
	ОбменДаннымиСервер.УстановитьКоличествоЭлементовВТранзакцииЗагрузкиДанных(Тело.ImportTransactionQuantity);
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("КонечнаяТочкаКорреспондента", Корреспондент);
	
	СтруктураЗаписи.Вставить("FILEКаталогОбменаИнформацией",       Тело.FILE_ExchangeFolder);
	СтруктураЗаписи.Вставить("FILEСжиматьФайлИсходящегоСообщения", Тело.FILE_CompressExchangeMessage);
	
	СтруктураЗаписи.Вставить("FTPСжиматьФайлИсходящегоСообщения",                  Тело.FTP_CompressExchangeMessage);
	СтруктураЗаписи.Вставить("FTPСоединениеМаксимальныйДопустимыйРазмерСообщения", Тело.FTP_MaxExchangeMessageSize);
	СтруктураЗаписи.Вставить("FTPСоединениеПассивноеСоединение",                   Тело.FTP_PassiveMode);
	СтруктураЗаписи.Вставить("FTPСоединениеПользователь",                          Тело.FTP_User);
	СтруктураЗаписи.Вставить("FTPСоединениеПорт",                                  Тело.FTP_Port);
	СтруктураЗаписи.Вставить("FTPСоединениеПуть",                                  Тело.FTP_ExchangeFolder);
	
	СтруктураЗаписи.Вставить("ВидТранспортаСообщенийОбменаПоУмолчанию",      Перечисления.ВидыТранспортаСообщенийОбмена[Тело.ExchangeTransport]);
	
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Корреспондент, Тело.FTP_Password, "FTPСоединениеПарольОбластейДанных");
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Корреспондент, Тело.ExchangeMessagePassword, "ПарольАрхиваСообщенияОбменаОбластейДанных");
	УстановитьПривилегированныйРежим(Ложь);
	
	РегистрыСведений.НастройкиТранспортаОбменаОбластейДанных.ОбновитьЗапись(СтруктураЗаписи);
	
КонецПроцедуры

Процедура УдалитьНастройкуСинхронизации(Сообщение, Отправитель)
	
	Тело = Сообщение.Body;
	ОбменДаннымиВМоделиСервиса.УдалитьНастройкуСинхронизации(Тело.ExchangePlan, Формат(Тело.CorrespondentZone, "ЧЦ=7; ЧВН=; ЧГ=0"));
	
КонецПроцедуры

Процедура ВыполнитьСинхронизацию(Сообщение, Отправитель)
	
	СценарийОбменаДанными = СериализаторXDTO.ПрочитатьXDTO(Сообщение.Body.Scenario);
	
	Если СценарийОбменаДанными.Количество() > 0 Тогда
		
		// Запускаем выполнение сценария
		ОбменДаннымиВМоделиСервиса.ВыполнитьДействиеСценарияОбменаДаннымиВПервойИнформационнойБазе(0, СценарийОбменаДанными);
		
	КонецЕсли;
	
КонецПроцедуры

Функция СобытиеЖурналаРегистрацииПодключениеКорреспондента()
	
	Возврат НСтр("ru = 'Обмен данными.Подключение корреспондента обмена'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти
