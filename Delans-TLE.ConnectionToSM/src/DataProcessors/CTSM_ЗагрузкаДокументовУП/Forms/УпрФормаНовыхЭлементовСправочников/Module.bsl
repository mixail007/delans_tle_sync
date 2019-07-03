&НаКлиенте
Перем 
ИспользоватьОтбор, 		// признак использования отбора 
ВыделенноеЗначение;     // текущая строка таблицы словаря

// Процедура - обработчик события формы "ПриСозданииНаСервере"
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СоответствиеИД = Неопределено;
	ЭтаФорма.Параметры.Свойство("СоответствиеИД", СоответствиеИД);
	Если НЕ СоответствиеИД = Неопределено Тогда
		Для каждого ЭлемСоотв Из СоответствиеИД Цикл
			НовСтрока = Загруженные.Добавить();
			НовСтрока.ДокументИД = ЭлемСоотв.Ключ;
			НовСтрока.Документ = ЭлемСоотв.Значение;
		КонецЦикла;	
	КонецЕсли;

	
КонецПроцедуры

// Процедура - обработчик события формы "ПриОткрытии"
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПоказыватьНовыеЭлементыСправочникаПослеЗагрузкиДокумента = ВладелецФормы.ПоказыватьНовыеЭлементыСправочника;

	Для Каждого Элемент Из ВладелецФормы.НовыеЭлементыСправочников Цикл
		ЗаполнитьЗначенияСвойств(НовыеЭлементыСправочников.Добавить(), Элемент);
		ЗаполнитьЗначенияСвойств(НовыеЭлементыСправочниковИсходнаяТаблица.Добавить(), Элемент);
	КонецЦикла;
		
	ИспользоватьОтбор = Ложь;
	ОбновитьТаблицу();
	
КонецПроцедуры

// Процедура - обработчик события формы "ОбработкаОповещения"
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "УпрОсновнаяФормаБудетЗакрыта"  И ЭтаФорма.Открыта() Тогда
		
		ЭтаФорма.Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик команды формы "ОтборПоТекущемуЗначению"
//
&НаКлиенте
Процедура ОтборПоТекущемуЗначению(Команда)
	
	ИспользоватьОтбор = Истина;	
	ОбновитьТаблицу();
	
КонецПроцедуры

// Процедура - обработчик команды формы "ОтключитьОтбор"
//
&НаКлиенте
Процедура ОтключитьОтбор(Команда)
	
	ИспользоватьОтбор = Ложь;	
	ОбновитьТаблицу();	
	
КонецПроцедуры

// Процедура - обработчик события элемента  НовыеЭлементыСправочников "ПриАктивизацииЯчейки"
//
&НаКлиенте
Процедура НовыеЭлементыСправочниковПриАктивизацииЯчейки(Элемент)
	
	Если Элементы.НовыеЭлементыСправочников.ТекущаяСтрока <> Неопределено Тогда
		ТекущаяКолонкаИмя = СтрЗаменить(Элемент.ТекущийЭлемент.Имя, "НовыеЭлементыСправочников", "");
		ВыделенноеЗначение = Элемент.ТекущиеДанные[ТекущаяКолонкаИмя]; 	
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события элемента  ПоказыватьНовыеЭлементыСправочникаПослеЗагрузкиДокумента "ПриИзменении"
//
&НаКлиенте
Процедура ПоказыватьНовыеЭлементыСправочникаПослеЗагрузкиДокументаПриИзменении(Элемент)
	
	ВладелецФормы.ПоказыватьНовыеЭлементыСправочника = ПоказыватьНовыеЭлементыСправочникаПослеЗагрузкиДокумента;

КонецПроцедуры

// Процедура выполняет обновление таблицы  НовыеЭлементыСправочников,
//
&НаКлиенте
Процедура ОбновитьТаблицу() Экспорт;
	
	НовыеЭлементыСправочников.Очистить();
	
	Если ИспользоватьОтбор Тогда
		ИмяКолонки = СтрЗаменить(Элементы.НовыеЭлементыСправочников.ТекущийЭлемент.Имя, "НовыеЭлементыСправочников", "");
		ПараметрыОтбора = Новый Структура(ИмяКолонки, ВыделенноеЗначение);
		ТаблицаНовых = НовыеЭлементыСправочниковИсходнаяТаблица.НайтиСтроки(ПараметрыОтбора);
	Иначе
		ТаблицаНовых = НовыеЭлементыСправочниковИсходнаяТаблица;
	КонецЕсли;
	//Если Загруженные.Количество() = 0 Тогда
	Для каждого Элем Из ТаблицаНовых Цикл
		НовСтрока = НовыеЭлементыСправочников.Добавить();
		НовСтрока.ВидСправочника = Элем.ВидСправочника;
		НовСтрока.Ссылка = Элем.Ссылка;
		НовСтрока.Документ = Элем.Документ;
	КонецЦикла;	
	//Иначе
	//	Для каждого СтрокаЗагруженногоДокумента Из Загруженные Цикл
	//		СтрокиДокумента = ТаблицаНовых.НайтиСтроки(Новый Структура("Документ", СтрокаЗагруженногоДокумента.Документ));
	//		Для Каждого Строка Из СтрокиДокумента Цикл
	//			НовСтрока = НовыеЭлементыСправочников.Добавить();
	//			НовСтрока.ВидСправочника = Строка.ВидСправочника;
	//			НовСтрока.Ссылка = Строка.Ссылка;
	//			НовСтрока.Документ = Строка.Документ;
	//		КонецЦикла;
	//	КонецЦикла;	
	//КонецЕсли;

	НовыеЭлементыСправочников.Сортировать("ВидСправочника Возр, Документ Возр");
	
КонецПроцедуры

