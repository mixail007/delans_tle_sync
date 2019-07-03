#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Печатная форма запросов на сверку с ПФР.
//
Функция ПечатнаяФорма(Сверка) Экспорт
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	// получаем бланк отчета из макета
	Если Сверка.ВидУслуги = Перечисления.ВидыУслугПриИОС.СверкаФИОиСНИЛС Тогда
		Бланк = ПолучитьМакет("СверкаФИОиСНИЛС");
		ЗаполнитьСверкуФИОиСНИЛС(Сверка, ТабДокумент, Бланк);
	Иначе
		Бланк = ПолучитьМакет("СправкаОСостоянииРасчетов");
		ЗаполнитьСправкаОСостоянииРасчетов(Сверка, ТабДокумент, Бланк);
	КонецЕсли;
	
	ТабДокумент.МасштабПечати = 100;
	Возврат ТабДокумент;
	
КонецФункции

Процедура ПерезаполнитьЗначениеРеквизитаНаДату() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗапросНаИнформационноеОбслуживаниеСтрахователя.Ссылка
	|ИЗ
	|	Документ.ЗапросНаИнформационноеОбслуживаниеСтрахователя КАК ЗапросНаИнформационноеОбслуживаниеСтрахователя
	|ГДЕ
	|	ЗапросНаИнформационноеОбслуживаниеСтрахователя.НаДату = ДАТАВРЕМЯ(1, 1, 1)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СверкаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СверкаОбъект.НаДату = СверкаОбъект.Дата;
		СверкаОбъект.ОбменДанными.Загрузка = Истина;
		СверкаОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСверкуФИОиСНИЛС(Сверка, ТабДокумент, Бланк)
	
	СведенияОбОрганизации = ПолучитьСведенияОбОрганизации(Сверка.Организация);
	
	// Шапка
	Шапка = Бланк.ПолучитьОбласть("Шапка");
	ЗаполнитьШапку(Сверка, ТабДокумент, Шапка, СведенияОбОрганизации);
	
	// Табличная часть.
	ЗаполнитьТабличнуюЧасть(Сверка, ТабДокумент, Бланк);
	
	// Подвал
	Подвал = Бланк.ПолучитьОбласть("Подвал");
	ЗаполнитьДатуСверки(Сверка, ТабДокумент, Бланк, Подвал);
	ЗаполнитьФИОРуководителя(Сверка, ТабДокумент, Бланк, Подвал, СведенияОбОрганизации.ФИОРук);
	
	ТабДокумент.Вывести(Подвал);
	ЗаполнитьПодпись(Сверка, ТабДокумент);
	
КонецПроцедуры

Функция ПолучитьСведенияОбОрганизации(Организация)

	СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация);
	ЭтоЮрЛицо = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЭтоЮрЛицо(Организация);
	Если НЕ ЭтоЮрЛицо Тогда
		ИПИспользуетТрудНаемныхРаботников = РегламентированнаяОтчетность.ИПИспользуетТрудНаемныхРаботников(Организация);  
		Если НЕ ИПИспользуетТрудНаемныхРаботников Тогда
			СведенияПФР = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, , "РегНомПФРЗаСебя");
			СведенияОбОрганизации.Вставить("РегНомПФР", СведенияПФР.РегНомПФРЗаСебя); 
		КонецЕсли;
	КонецЕсли;
	
	Возврат СведенияОбОрганизации;

КонецФункции

Процедура ЗаполнитьСправкаОСостоянииРасчетов(Сверка, ТабДокумент, Бланк)
	
	СведенияОбОрганизации = ПолучитьСведенияОбОрганизации(Сверка.Организация);
	
	// Шапка
	Шапка = Бланк.ПолучитьОбласть("Шапка");
	Шапка.Параметры["НаДату"] = Формат(Сверка.НаДату, "ДЛФ=D");
	ЗаполнитьШапку(Сверка, ТабДокумент, Шапка, СведенияОбОрганизации);
	
	// Подвал
	Подвал = Бланк.ПолучитьОбласть("Подвал");
	ЗаполнитьДатуСверки(Сверка, ТабДокумент, Бланк, Подвал);
	ЗаполнитьФИОРуководителя(Сверка, ТабДокумент, Бланк, Подвал, СведенияОбОрганизации.ФИОРук);
	
	ТабДокумент.Вывести(Подвал);
	ЗаполнитьПодпись(Сверка, ТабДокумент);
	
КонецПроцедуры

Процедура ЗаполнитьШапку(Сверка, ТабДокумент, Шапка, СведенияОбОрганизации)
	
	// Шапка
	Шапка.Параметры["КодПФР"] = Сверка.Получатель.Код;
	Шапка.Параметры["РегНомерПФР"] = СведенияОбОрганизации.РегНомПФР;
	
	ЭтоЮрЛицо = РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Сверка.Организация);

	Если ЭтоЮрЛицо Тогда
		Наименование = СокрЛП(СведенияОбОрганизации.НаимЮЛПол);
	Иначе
		
		ФИОИП = ФИОИндивидуальногоПредпринимателя(Сверка.Организация);
		Если ФИОИП = Неопределено Тогда
			Наименование = "";
		Иначе
			Наименование =
				СокрЛП(ФИОИП.Фамилия) + " " + 
				СокрЛП(ФИОИП.Имя) + " " +
				СокрЛП(ФИОИП.Отчество);
		КонецЕсли;
			
	КонецЕсли;
	
	Шапка.Параметры["Наименование"] = Наименование;
	
	ТабДокумент.Вывести(Шапка);
	
КонецПроцедуры

Функция ФИОИндивидуальногоПредпринимателя(Организация) Экспорт
	
	Руководитель 		= ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.Руководитель(Организация);
	ДанныеИсполнителя 	= ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.ПолучитьДанныеИсполнителя(Руководитель, Организация);
	
	Если ТипЗнч(ДанныеИсполнителя) = Тип("Структура")
		И ДанныеИсполнителя.Свойство("ФИО") Тогда
		Возврат ДанныеИсполнителя.ФИО;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции


Процедура ЗаполнитьТабличнуюЧасть(Сверка, ТабДокумент, Бланк)
	
	ЗастрахованныеЛица = Бланк.ПолучитьОбласть("ЗастрахованныеЛица");
	Для каждого ЗастрахованноеЛицо Из Сверка.ЗастрахованныеЛица Цикл
		
		ФИОЗастрахованногоЛица = 
			ЗастрахованноеЛицо.Фамилия + " " +
			ЗастрахованноеЛицо.Имя + " " +
			ЗастрахованноеЛицо.Отчество;
			
		ЗастрахованныеЛица.Параметры["ФИО"]   = ФИОЗастрахованногоЛица;
		ЗастрахованныеЛица.Параметры["СНИЛС"] = ЗастрахованноеЛицо.СтраховойНомер;
		
		ТабДокумент.Вывести(ЗастрахованныеЛица);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьФИОРуководителя(Сверка, ТабДокумент, Бланк, Область, ФИОРук)
	
	ФИОПодписанта = РегламентированнаяОтчетность.РазложитьФИО(ФИОРук);

	ФИО = Новый Структура();
	ФИО.Вставить("Фамилия", 	СокрЛП(ФИОПодписанта.Фамилия));
	ФИО.Вставить("Имя", 		СокрЛП(ФИОПодписанта.Имя));
	ФИО.Вставить("Отчество", 	СокрЛП(ФИОПодписанта.Отчество));
		
	Подписант = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ФИО);
	
	Область.Параметры["Руководитель"] = Подписант;
	
КонецПроцедуры

Процедура ЗаполнитьДатуСверки(Сверка, ТабДокумент, Бланк, Область)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЦиклОбмена = ДокументооборотСКОВызовСервера.ПолучитьПоследнийЦиклОбмена(Сверка);
	
	КонтекстЭДОСервер 	= ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	СообщенияЦикла		= КонтекстЭДОСервер.ПолучитьСообщенияЦиклаОбмена(ЦиклОбмена);
	СтрЗапросыПФР 		= СообщенияЦикла.НайтиСтроки(Новый Структура("Тип", Перечисления.ТипыТранспортныхСообщений.ПервичноеСообщениеСодержащееЗапросПФР));
	
	Если СтрЗапросыПФР.Количество() = 0 Тогда
		Область.Параметры["Дата"] = Формат(ТекущаяДатаСеанса(), "ДЛФ=D");
	Иначе
		Область.Параметры["Дата"] = Формат(СтрЗапросыПФР[0].ДатаТранспорта, "ДЛФ=DD");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПодпись(Сверка, ТабДокумент)
	
	ТипыСообщений = Новый Массив;
	ТипыСообщений.Добавить(Перечисления.ТипыТранспортныхСообщений.ПервичноеСообщениеСодержащееЗапросПФР);
	ТипыСообщений.Добавить(Перечисления.ТипыТранспортныхСообщений.ОтветНаЗапросПФР);
	ТипыСообщений.Добавить(Перечисления.ТипыТранспортныхСообщений.ОтветНаЗапросКвитанцияПФР);
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ДобавитьШтампПодписиПодДокументом(
		Сверка,
		ТипыСообщений,
		ТабДокумент,
		2,
		Ложь); 

КонецПроцедуры
	
#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	// инициализируем контекст ЭДО - модуль обработки
	ТекстСообщения = "";
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДО = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	КонтекстЭДО.ОбработкаПолученияФормы("Документ", "ЗапросНаИнформационноеОбслуживаниеСтрахователя", ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти