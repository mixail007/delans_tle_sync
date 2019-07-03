#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Установка исключительной блокировки текущего набора записей регистратора.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.РазмещениеЗаказов.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияРазмещениеЗаказовИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияРазмещениеЗаказовИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияРазмещениеЗаказовИзменение Тогда
		
		// Если временная таблица "ДвиженияРазмещениеЗаказовИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияРазмещениеЗаказовПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РазмещениеЗаказов.НомерСтроки КАК НомерСтроки,
		|	РазмещениеЗаказов.Организация КАК Организация,
		|	РазмещениеЗаказов.ЗаказПокупателя КАК ЗаказПокупателя,
		|	РазмещениеЗаказов.Номенклатура КАК Номенклатура,
		|	РазмещениеЗаказов.Характеристика КАК Характеристика,
		|	РазмещениеЗаказов.ИсточникОбеспечения КАК ИсточникОбеспечения,
		|	ВЫБОР
		|		КОГДА РазмещениеЗаказов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РазмещениеЗаказов.Количество
		|		ИНАЧЕ -РазмещениеЗаказов.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияРазмещениеЗаказовПередЗаписью
		|ИЗ
		|	РегистрНакопления.РазмещениеЗаказов КАК РазмещениеЗаказов
		|ГДЕ
		|	РазмещениеЗаказов.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияРазмещениеЗаказовИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблцу "ДвиженияРазмещениеЗаказовПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияРазмещениеЗаказовИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияРазмещениеЗаказовИзменение.Организация КАК Организация,
		|	ДвиженияРазмещениеЗаказовИзменение.ЗаказПокупателя КАК ЗаказПокупателя,
		|	ДвиженияРазмещениеЗаказовИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияРазмещениеЗаказовИзменение.Характеристика КАК Характеристика,
		|	ДвиженияРазмещениеЗаказовИзменение.ИсточникОбеспечения КАК ИсточникОбеспечения,
		|	ДвиженияРазмещениеЗаказовИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияРазмещениеЗаказовПередЗаписью
		|ИЗ
		|	ДвиженияРазмещениеЗаказовИзменение КАК ДвиженияРазмещениеЗаказовИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РазмещениеЗаказов.НомерСтроки,
		|	РазмещениеЗаказов.Организация,
		|	РазмещениеЗаказов.ЗаказПокупателя,
		|	РазмещениеЗаказов.Номенклатура,
		|	РазмещениеЗаказов.Характеристика,
		|	РазмещениеЗаказов.ИсточникОбеспечения,
		|	ВЫБОР
		|		КОГДА РазмещениеЗаказов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РазмещениеЗаказов.Количество
		|		ИНАЧЕ -РазмещениеЗаказов.Количество
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.РазмещениеЗаказов КАК РазмещениеЗаказов
		|ГДЕ
		|	РазмещениеЗаказов.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияРазмещениеЗаказовИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияРазмещениеЗаказовИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияРазмещениеЗаказовИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияРазмещениеЗаказовИзменение");
	
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ПриЗаписи набора записей.
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу "ДвиженияРазмещениеЗаказовИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияРазмещениеЗаказовИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияРазмещениеЗаказовИзменение.Организация КАК Организация,
	|	ДвиженияРазмещениеЗаказовИзменение.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ДвиженияРазмещениеЗаказовИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияРазмещениеЗаказовИзменение.Характеристика КАК Характеристика,
	|	ДвиженияРазмещениеЗаказовИзменение.ИсточникОбеспечения КАК ИсточникОбеспечения,
	|	СУММА(ДвиженияРазмещениеЗаказовИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияРазмещениеЗаказовИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияРазмещениеЗаказовИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияРазмещениеЗаказовИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияРазмещениеЗаказовПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияРазмещениеЗаказовПередЗаписью.Организация КАК Организация,
	|		ДвиженияРазмещениеЗаказовПередЗаписью.ЗаказПокупателя КАК ЗаказПокупателя,
	|		ДвиженияРазмещениеЗаказовПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияРазмещениеЗаказовПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияРазмещениеЗаказовПередЗаписью.ИсточникОбеспечения КАК ИсточникОбеспечения,
	|		ДвиженияРазмещениеЗаказовПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияРазмещениеЗаказовПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи
	|	ИЗ
	|		ДвиженияРазмещениеЗаказовПередЗаписью КАК ДвиженияРазмещениеЗаказовПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияРазмещениеЗаказовПриЗаписи.НомерСтроки,
	|		ДвиженияРазмещениеЗаказовПриЗаписи.Организация,
	|		ДвиженияРазмещениеЗаказовПриЗаписи.ЗаказПокупателя,
	|		ДвиженияРазмещениеЗаказовПриЗаписи.Номенклатура,
	|		ДвиженияРазмещениеЗаказовПриЗаписи.Характеристика,
	|		ДвиженияРазмещениеЗаказовПриЗаписи.ИсточникОбеспечения,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияРазмещениеЗаказовПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияРазмещениеЗаказовПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияРазмещениеЗаказовПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияРазмещениеЗаказовПриЗаписи.Количество
	|	ИЗ
	|		РегистрНакопления.РазмещениеЗаказов КАК ДвиженияРазмещениеЗаказовПриЗаписи
	|	ГДЕ
	|		ДвиженияРазмещениеЗаказовПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияРазмещениеЗаказовИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияРазмещениеЗаказовИзменение.Организация,
	|	ДвиженияРазмещениеЗаказовИзменение.ЗаказПокупателя,
	|	ДвиженияРазмещениеЗаказовИзменение.Номенклатура,
	|	ДвиженияРазмещениеЗаказовИзменение.Характеристика,
	|	ДвиженияРазмещениеЗаказовИзменение.ИсточникОбеспечения
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияРазмещениеЗаказовИзменение.КоличествоИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ЗаказПокупателя,
	|	Номенклатура,
	|	Характеристика,
	|	ИсточникОбеспечения");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияРазмещениеЗаказовИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияРазмещениеЗаказовИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияРазмещениеЗаказовПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияРазмещениеЗаказовПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#КонецЕсли