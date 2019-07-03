#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(СлужбаДоставки) И НЕ ЗначениеЗаполнено(Курьер)  Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ЭтоДоставкаСобственнымиСилами() Тогда
		ИсключитьРеквизитИзПроверки("СпособОтгрузки", ПроверяемыеРеквизиты);
		ИсключитьРеквизитИзПроверки("Склад", ПроверяемыеРеквизиты);
		ИсключитьРеквизитИзПроверки("АдресОтправки", ПроверяемыеРеквизиты);
	ИначеЕсли ЭтоЗаборКурьеромСлужбыДоставки() Тогда 
		ИсключитьРеквизитИзПроверки("Курьер", ПроверяемыеРеквизиты);
	ИначеЕсли ЭтоСамопривозНаСкладСлужбыДоставки() Тогда 
		ИсключитьРеквизитИзПроверки("Склад", ПроверяемыеРеквизиты);
		ИсключитьРеквизитИзПроверки("АдресОтправки", ПроверяемыеРеквизиты);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если Заказы.Количество()=0 Тогда
		ОбщегоНазначения.СообщитьПользователю(
		НСтр("ru = 'Укажите отгружаемые заказы'"),
		Ссылка,
		"Заказы",,
		Отказ);
	КонецЕсли; 
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	ОбновитьДанныеЗаказов(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
КонецПроцедуры
 
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ОбновитьДанныеЗаказов(Отказ, Ложь);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Заказы.Количество()>0 
		И НЕ Документы.МаршрутныйЛист.ПроверитьДоступностьЗаказов(ЭтотОбъект) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Недостаточно прав для изменения документа'"),,,, Отказ);
		Возврат;
	КонецЕсли; 	
	
	Если НЕ ЭтоНовый() Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	МаршрутныйЛистЗаказы.Заказ КАК Заказ
		|ИЗ
		|	Документ.МаршрутныйЛист.Заказы КАК МаршрутныйЛистЗаказы
		|ГДЕ
		|	МаршрутныйЛистЗаказы.Ссылка = &Ссылка";
		МассивЗаказов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Заказ");
	Иначе
		МассивЗаказов = Новый Массив;
	КонецЕсли; 
	
	ДополнительныеСвойства.Вставить("ЗаказыДоИзменения", МассивЗаказов);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	Если ДополнительныеСвойства.Свойство("ЗаказыДоИзменения") Тогда
		ЗаказыДоИзменения = ДополнительныеСвойства.ЗаказыДоИзменения;
		Если НЕ ТипЗнч(ЗаказыДоИзменения)=Тип("Массив") Тогда
			ЗаказыДоИзменения = Новый Массив;
		КонецЕсли; 
	Иначе
		ЗаказыДоИзменения = Новый Массив;
	КонецЕсли;
	
	ОбсужденияЗаказов = Новый Соответствие;
	Для каждого СтрокаТабличнойЧасти Из Заказы Цикл
		Если ЗаказыДоИзменения.Найти(СтрокаТабличнойЧасти.Заказ)=Неопределено Тогда
			Сообщение = "";
			Префикс = НСтр("ru = 'Использован в: '")+ОбсужденияСервер.HTMLСсылка(Ссылка);
			ОбсужденияСервер.ДобавитьСообщениеОбИзмененииРеквизита(Сообщение, Префикс);
			ОбсужденияЗаказов.Вставить(СтрокаТабличнойЧасти.Заказ, Сообщение);
		КонецЕсли; 
	КонецЦикла;
	ДополнительныеСвойства.Вставить("ОбсужденияЗаказов", ОбсужденияЗаказов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоДоставкаСобственнымиСилами()
	
	Возврат СлужбаДоставки = Справочники.СлужбыДоставки.ДоставкаСобственнымиСилами;
	
КонецФункции

Функция ЭтоЗаборКурьеромСлужбыДоставки()
	
	Возврат СпособОтгрузки = Перечисления.СпособыОтгрузки.ПередатьКурьеруЕдиногоСклада
	Или СпособОтгрузки = Перечисления.СпособыОтгрузки.ПередатьКурьеруСлужбыДоставки;
	
КонецФункции

Функция ЭтоСамопривозНаСкладСлужбыДоставки()
	
	Возврат СпособОтгрузки = Перечисления.СпособыОтгрузки.СамостоятельноПривезтиНаЕдиныйСклад
	Или СпособОтгрузки = Перечисления.СпособыОтгрузки.СамостоятельноПривезтиНаСкладСлужбыДоставки;
	
КонецФункции

Процедура ОбновитьДанныеЗаказов(Отказ, Проведение = Истина)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ОбсужденияЗаказов = Неопределено;
	ДополнительныеСвойства.Свойство("ОбсужденияЗаказов", ОбсужденияЗаказов);
	Если ТипЗнч(ОбсужденияЗаказов)<>Тип("Соответствие") Тогда
		ОбсужденияЗаказов = Новый Соответствие;
	КонецЕсли; 
	
	НесколькоВидовЗаказов = ПолучитьФункциональнуюОпцию("ИспользоватьВидыЗаказовПокупателей");

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаЗаказов", Заказы.Выгрузить(, "Заказ"));
	Запрос.УстановитьПараметр("СлужбаДоставки", СлужбаДоставки);
	Запрос.УстановитьПараметр("Курьер", Курьер);
	Запрос.УстановитьПараметр("Проведен", Проведение);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫРАЗИТЬ(ТаблицаЗаказов.Заказ КАК Документ.ЗаказПокупателя) КАК Заказ
	|ПОМЕСТИТЬ ТаблицаЗаказов
	|ИЗ
	|	&ТаблицаЗаказов КАК ТаблицаЗаказов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаЗаказов.Заказ КАК Заказ,
	|	ВЫБОР
	|		КОГДА &Проведен
	|			ТОГДА ТаблицаЗаказов.Заказ.ВидЗаказа.СостояниеОтгружен
	|		КОГДА НЕ &Проведен
	|			ТОГДА ТаблицаЗаказов.Заказ.ВидЗаказа.СостояниеОжидаетОтгрузки
	|	КОНЕЦ КАК НовоеСостояние,
	|	ВЫБОР
	|		КОГДА &Проведен
	|					И ТаблицаЗаказов.Заказ.СостояниеЗаказа = ТаблицаЗаказов.Заказ.ВидЗаказа.СостояниеОжидаетОтгрузки
	|				ИЛИ НЕ &Проведен
	|					И ТаблицаЗаказов.Заказ.СостояниеЗаказа = ТаблицаЗаказов.Заказ.ВидЗаказа.СостояниеОтгружен
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОбновитьСостояние,
	|	ВЫБОР
	|		КОГДА ТаблицаЗаказов.Заказ.СлужбаДоставки <> &СлужбаДоставки
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОбновитьСлужбуДоставки,
	|	ВЫБОР
	|		КОГДА ТаблицаЗаказов.Заказ.Курьер <> &Курьер
	|				И &Курьер <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОбновитьКурьера
	|ПОМЕСТИТЬ Действия
	|ИЗ
	|	ТаблицаЗаказов КАК ТаблицаЗаказов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаЗаказов.Заказ КАК Заказ,
	|	МаршрутныйЛистЗаказы.Ссылка КАК МаршрутныйЛист
	|ИЗ
	|	ТаблицаЗаказов КАК ТаблицаЗаказов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛист.Заказы КАК МаршрутныйЛистЗаказы
	|		ПО ТаблицаЗаказов.Заказ = МаршрутныйЛистЗаказы.Заказ
	|			И (МаршрутныйЛистЗаказы.Ссылка <> &Ссылка)
	|			И (МаршрутныйЛистЗаказы.Ссылка.Проведен)
	|ГДЕ
	|	НЕ МаршрутныйЛистЗаказы.Ссылка ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Действия.Заказ КАК Заказ,
	|	Действия.НовоеСостояние КАК НовоеСостояние,
	|	Действия.ОбновитьСостояние КАК ОбновитьСостояние,
	|	Действия.ОбновитьСлужбуДоставки КАК ОбновитьСлужбуДоставки,
	|	Действия.ОбновитьКурьера КАК ОбновитьКурьера
	|ИЗ
	|	Действия КАК Действия
	|ГДЕ
	|	(Действия.ОбновитьСлужбуДоставки
	|			ИЛИ Действия.ОбновитьКурьера
	|			ИЛИ Действия.ОбновитьСостояние)";
	Результат = Запрос.ВыполнитьПакет();
	Ошибки = Результат[2].Выбрать();
	Если НЕ Ошибки.Количество()=0 Тогда
		Пока Ошибки.Следующий() Цикл
			ОбщегоНазначения.СообщитьПользователю(
			СтрШаблон(НСтр("ru = '%1 уже отгружен документом %2'"), Ошибки.Заказ, Ошибки.МаршрутныйЛист),
			Ошибки.МаршрутныйЛист,
			"Заказы", ,
			Отказ);
		КонецЦикла; 
		Возврат;
	КонецЕсли; 
	Выборка = Результат[3].Выбрать();
	ВыведенныеВидыЗаказов = Новый Массив;
	Пока Выборка.Следующий() Цикл
		ЗаказОбъект = Выборка.Заказ.ПолучитьОбъект();
		Сообщение = ОбсужденияЗаказов.Получить(Выборка.Заказ);
		// Состояние заказа
		Если Выборка.ОбновитьСостояние Тогда
			Если НЕ ЗначениеЗаполнено(Выборка.НовоеСостояние) Тогда
				// Не настроены состояния заказов
				Если НесколькоВидовЗаказов Тогда
					Если ВыведенныеВидыЗаказов.Найти(ЗаказОбъект.ВидЗаказа)=Неопределено Тогда
						ОбщегоНазначения.СообщитьПользователю(
						СтрШаблон(НСтр("ru = 'Не задано состояние %1 заказа для вида %2'"),
						?(Проведение, НСтр("ru = 'отгрузки'"), НСтр("ru = 'ожидания отгрузки'")),
						ЗаказОбъект.ВидЗаказа),
						ЗаказОбъект.ВидЗаказа,
						?(Проведение, "СостояниеОтгружен", "СостояниеОжидаетОтгрузки"),,
						Отказ);
						ВыведенныеВидыЗаказов.Добавить(ЗаказОбъект.ВидЗаказа);
					КонецЕсли; 
				Иначе
					Если ВыведенныеВидыЗаказов.Найти(Справочники.ВидыЗаказовПокупателей.Основной)=Неопределено Тогда
						ОбщегоНазначения.СообщитьПользователю(
						СтрШаблон(НСтр("ru = 'Не задано состояние %1 заказа'"),
						?(Проведение, НСтр("ru = 'отгрузки'"), НСтр("ru = 'ожидания отгрузки'"))),
						Справочники.ВидыЗаказовПокупателей.Основной,
						?(Проведение, "СостояниеОтгружен", "СостояниеОжидаетОтгрузки"),,
						Отказ);
						ВыведенныеВидыЗаказов.Добавить(Справочники.ВидыЗаказовПокупателей.Основной);
					КонецЕсли; 
				КонецЕсли; 
			Иначе
				Префикс = НСтр("ru = 'Состояние: '");
				ТекстИзменений = ОбсужденияСервер.ДобавитьСообщениеОбИзмененииРеквизита(ЗаказОбъект.СостояниеЗаказа, Выборка.НовоеСостояние);
				ОбсужденияСервер.ДобавитьОписаниеИзменений(Сообщение, ТекстИзменений, Префикс+": ");
				ЗаказОбъект.СостояниеЗаказа = Выборка.НовоеСостояние;
			КонецЕсли;
		КонецЕсли;
		// Служба доставки
		Если Выборка.ОбновитьСлужбуДоставки Тогда
			Префикс = НСтр("ru = 'Служба доставки: '");
			ТекстИзменений = ОбсужденияСервер.ДобавитьСообщениеОбИзмененииРеквизита(ЗаказОбъект.СлужбаДоставки, СлужбаДоставки);
			ОбсужденияСервер.ДобавитьОписаниеИзменений(Сообщение, ТекстИзменений, Префикс+": ");
			ЗаказОбъект.СлужбаДоставки = СлужбаДоставки;
		КонецЕсли;
		// Курьер
		Если Выборка.ОбновитьКурьера Тогда
			Префикс = НСтр("ru = 'Курьер: '");
			ТекстИзменений = ОбсужденияСервер.ДобавитьСообщениеОбИзмененииРеквизита(ЗаказОбъект.Курьер, Курьер);
			ОбсужденияСервер.ДобавитьОписаниеИзменений(Сообщение, ТекстИзменений, Префикс+": ");
			ЗаказОбъект.Курьер = Курьер;
		КонецЕсли;
		Если ЗначениеЗаполнено(Сообщение) Тогда
			ОбсужденияСервер.ДобавитьСообщение(
			Сообщение, 
			Выборка.Заказ,
			, 
			Истина);
			ЗаказОбъект.ДополнительныеСвойства.Вставить("ОбсуждениеЗаписано", Истина);
		КонецЕсли; 
		Попытка
			ЗаказОбъект.Записать(?(ЗаказОбъект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
		Исключение
		    Отказ = Истина;
		КонецПопытки; 
	КонецЦикла; 
	
КонецПроцедуры

Процедура ИсключитьРеквизитИзПроверки(ИмяРеквизита, ПроверяемыеРеквизиты)
	
	Индекс = ПроверяемыеРеквизиты.Найти(ИмяРеквизита);
	Если Индекс<>Неопределено Тогда
		ПроверяемыеРеквизиты.Удалить(Индекс)
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 

#КонецЕсли