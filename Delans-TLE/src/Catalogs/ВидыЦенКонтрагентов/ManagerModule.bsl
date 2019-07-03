#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ОБРАБОТЧИКИ

// Функция получает вид цен контрагента по умолчанию
//
Функция ВидЦенКонтрагентаПоУмолчанию(Контрагент) Экспорт
	ДоговорПоУмолчанию = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(Контрагент);
	Возврат ?(ЗначениеЗаполнено(Контрагент) И ЗначениеЗаполнено(ДоговорПоУмолчанию),
				ДоговорПоУмолчанию.ВидЦенКонтрагента,
				Неопределено);
	
КонецФункции //СоздатьОбновитьВидЦенКонтрагентаПоУмолчанию()

// Функция находит любой первый вид цен указанного контрагента
//
Функция НайтиЛюбойПервыйВидЦенКонтрагента(Контрагент) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Запрос = Новый Запрос("Выбрать ПЕРВЫЕ 1 * Из Справочник.ВидыЦенКонтрагентов КАК ВидыЦенКонтрагентов Где ВидыЦенКонтрагентов.Владелец = &Контрагент");
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат ?(Выборка.Следующий(), Выборка.Ссылка, Неопределено);
	
КонецФункции //НайтиЛюбойПервыйВидЦенКонтрагента()

// Функция создает вид цен указанного контрагента
//
Функция СоздатьВидЦенКонтрагента(Контрагент, ВалютаРасчетов) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Контрагент)
		ИЛИ НЕ ЗначениеЗаполнено(ВалютаРасчетов) Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	СтруктураЗаполнения = Новый Структура("Наименование, Владелец, ВалютаЦены, ЦенаВключаетНДС, Комментарий", 
		Лев("Цены для " + Контрагент.Наименование, 50),
		Контрагент,
		ВалютаРасчетов,
		Истина,
		"Регистрирует входящие цены. Создан автоматически.");
		
	НовыйВидЦенКонтрагентов = Справочники.ВидыЦенКонтрагентов.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НовыйВидЦенКонтрагентов, СтруктураЗаполнения);
	
	ЦенообразованиеФормулыСервер.СформироватьНовыйИдентификаторВидаЦен(НовыйВидЦенКонтрагентов.ИдентификаторФормул, НовыйВидЦенКонтрагентов.Наименование);
	
	НовыйВидЦенКонтрагентов.Записать();
	
	Возврат НовыйВидЦенКонтрагентов.Ссылка;
	
КонецФункции // СоздатьВидЦенКонтрагента()

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли