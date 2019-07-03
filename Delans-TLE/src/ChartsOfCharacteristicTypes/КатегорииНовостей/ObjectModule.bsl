///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// В идентификаторе (Код) допустимы только английские символы, подчеркивания, минус и числа.
	РазрешенныеСимволы = ОбработкаНовостейКлиентСервер.РазрешенныеДляИдентификацииСимволы();
	СписокЗапрещенныхСимволов = ИнтернетПоддержкаПользователей.ПроверитьСтрокуНаЗапрещенныеСимволы(
		СокрЛП(Код),
		РазрешенныеСимволы);

	Если СписокЗапрещенныхСимволов.Количество() > 0 Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "Код";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='В идентификаторе присутствуют запрещенные символы: %1.
				|Разрешено использовать цифры, английские буквы, подчеркивание и минус.'"),
			СписокЗапрещенныхСимволов);
		Сообщение.Сообщить();
	КонецЕсли;

	// Запретить сохранять смешанные типы, т.е. ТипЗначения - составной.
	Если ТипЗначения.Типы().Количество() > 1 Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "ТипЗначения";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Текст = НСтр("ru='Составные типы не поддерживаются. Выберите только один тип значения.'");
		Сообщение.Сообщить();
	КонецЕсли;

	// Запретить сохранять пустые типы, т.е. ТипЗначения - пустой.
	Если ТипЗначения.Типы().Количество() = 0 Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "ТипЗначения";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Текст = НСтр("ru='Пустые типы не поддерживаются. Выберите один любой тип значения.'");
		Сообщение.Сообщить();
	КонецЕсли;

	// Возможно, что заполнен реквизит ТипЗначенияВспомогательный, но не заполнен ТипЗначения - исправить.
	Если ТипЗначения.Типы().Количество() = 0 Тогда
		Если ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Булево Тогда
			ТипЗначения = Новый ОписаниеТипов("Булево");
		ИначеЕсли ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Дата Тогда
			ТипЗначения = Новый ОписаниеТипов("Дата");
		ИначеЕсли ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Строка Тогда
			ТипЗначения = Новый ОписаниеТипов("Строка");
		ИначеЕсли ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Число Тогда
			ТипЗначения = Новый ОписаниеТипов("Число");
		ИначеЕсли ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.СправочникСсылка_ЗначенияКатегорийНовостей Тогда
			ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ЗначенияКатегорийНовостей");
		ИначеЕсли ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.СправочникСсылка_ИнтервалыВерсийПродукта Тогда
			ТипЗначения = Новый ОписаниеТипов("Строка");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Код          = СокрЛП(Код);
	Наименование = СокрЛП(Наименование);

	Если ЗагруженоССервера = Истина Тогда
		// Нельзя пометить на удаление категорию, загруженную с сервера.
		Если (ПометкаУдаления = Истина)
				И (Ссылка.ПометкаУдаления = Ложь) Тогда
			ТекстСообщения = НСтр("ru='Нельзя помечать на удаление категории, загруженные автоматически с сервера новостей.'");
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = ТекстСообщения;
			Сообщение.УстановитьДанные(Ссылка);
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли