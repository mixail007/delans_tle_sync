#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец")
		И ЗначениеЗаполнено(Параметры.Отбор.Владелец)
		И НЕ Параметры.Отбор.Владелец.ИспользоватьПартии Тогда
		
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Для номенклатуры не ведется учет по партиям!'");
		Сообщение.Сообщить();
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
	Если Не Параметры.Отбор.Свойство("Недействителен") Тогда
		Параметры.Отбор.Вставить("Недействителен", Ложь);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПолученияДанныхВыбора()

#КонецОбласти

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Функция ПредставлениеПартии(ЗначенияРеквизитов) Экспорт
	
	Представление = "";
	
	ЧастиПредставления = Новый Массив;
	
	Если ЗначениеЗаполнено(ЗначенияРеквизитов.ДатаПроизводства) Тогда
		ЧастиПредставления.Добавить(НСтр("ru = 'от %ДатаПроизводства%'"));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗначенияРеквизитов.ГоденДо) Тогда
		ЧастиПредставления.Добавить(НСтр("ru = 'до %ГоденДо%'"));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗначенияРеквизитов.ЗаписьСкладскогоЖурналаВЕТИС) Тогда
		ЧастиПредставления.Добавить(НСтр("ru = '%ЗаписьСкладскогоЖурналаВЕТИС%'"));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗначенияРеквизитов.ПроизводительВЕТИС) Тогда
		ЧастиПредставления.Добавить(НСтр("ru = '%ПроизводительВЕТИС%'"));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗначенияРеквизитов.ИдентификаторПартииВЕТИС) Тогда
		ЧастиПредставления.Добавить(НСтр("ru = '%ИдентификаторПартииВЕТИС%'"));
	КонецЕсли;
	
	Если ЧастиПредставления.Количество() = 0 Тогда
		ЧастиПредставления.Добавить(НСтр("ru = '<Сгенерирована автоматически>'"));
	КонецЕсли;
	
	Представление = СтрСоединить(ЧастиПредставления, " ");	
	Представление = СтрЗаменить(Представление, "%ГоденДо%", Формат(ЗначенияРеквизитов.ГоденДо, "ДФ=dd.MM.yyyy"));
	Представление = СтрЗаменить(Представление, "%ДатаПроизводства%", Формат(ЗначенияРеквизитов.ДатаПроизводства, "ДФ=dd.MM.yyyy"));
	Представление = СтрЗаменить(Представление, "%ЗаписьСкладскогоЖурналаВЕТИС%", ЗначенияРеквизитов.ЗаписьСкладскогоЖурналаВЕТИС);
	Представление = СтрЗаменить(Представление, "%ПроизводительВЕТИС%", ЗначенияРеквизитов.ПроизводительВЕТИС);
	Представление = СтрЗаменить(Представление, "%ИдентификаторПартииВЕТИС%", ЗначенияРеквизитов.ИдентификаторПартииВЕТИС);
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти

#КонецЕсли
