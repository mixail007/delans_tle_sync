#Область ОбработчикиКомандФормы

&НаСервере
Процедура ЗаполнитьПоПрограммеНаСервере()
	
	Объект.НачисленияБонусов.Очистить();
	
	Карты = РаботаСБонусами.ПолучитьКартыБонуснойПрограммы(Объект.БонуснаяПрограмма);
	
	Для Каждого Карта Из Карты Цикл
		
		НоваяСтрока = Объект.НачисленияБонусов.Добавить();
		НоваяСтрока.БонуснаяКарта = Карта;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПрограмме(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.БонуснаяПрограмма) Тогда
		ТекстСообщения = НСтр("ru = 'Укажите бонусную программу'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "БонуснаяПрограмма", "Объект.БонуснаяПрограмма");
		Возврат;
	КонецЕсли;
	
	Если Объект.НачисленияБонусов.Количество() = 0 Тогда
		ЗаполнитьПоПрограммеНаСервере();
	Иначе
		ВопросОПерезаполнении();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДатуНачисленияСгорания(Команда)
	
	ДатаСгорания = ТекущаяДата();
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьДатуНачисленияСгоранияЗавершение", ЭтотОбъект, Команда.Имя);
	
	ПоказатьВводДаты(ОписаниеОповещения, ДатаСгорания, НСтр("ru = 'Укажите дату'"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДатуНачисленияСгоранияЗавершение(Результат, ИмяКоманды) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаБонусов Из Объект.НачисленияБонусов Цикл
		
		Если ИмяКоманды = "УстановитьДатуНачисления" Тогда
			СтрокаБонусов.ДатаНачисления = Результат;
		ИначеЕсли ИмяКоманды = "УстановитьДатуСгорания" Тогда
			СтрокаБонусов.ДатаСгорания = Результат;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКоличествоБаллов(Команда)
	
	КоличествоБаллов = 0;
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьКоличествоБалловЗавершение", ЭтотОбъект);
	
	ПоказатьВводЧисла(ОписаниеОповещения, КоличествоБаллов, НСтр("ru = 'Введите количество баллов для начисления'"), 15, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКоличествоБалловЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаБонусов Из Объект.НачисленияБонусов Цикл
		
		СтрокаБонусов.Количество = Результат;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Объект.СлужебныйДокумент Тогда
		ТолькоПросмотр = Истина;
		Элементы.БонусыЗаполнитьПоПрограмме.Доступность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Обсуждения
	ОбсужденияКлиент.ОбработкаОповещения(ИмяСобытия, Параметр, Источник, ЭтотОбъект, Объект.Ссылка);
	// Конец Обсуждения
	
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриЧтенииНаСервере()

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "Проведение"+ РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	КонецЕсли;
	// СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обсуждения
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Модифицированность", Модифицированность);
	// Конец Обсуждения
	
КонецПроцедуры

#КонецОбласти

#Область СобытияЭлементовШапкиФормы

&НаКлиенте
Процедура БонуснаяПрограммаПриИзменении(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВопросОЗаполненииПоБонуснойПрограммеЗавершение", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Заполнить табличную часть картами бонусной программы?'");
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОЗаполненииПоБонуснойПрограммеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Если Объект.НачисленияБонусов.Количество() = 0 Тогда
			ЗаполнитьПоПрограммеНаСервере();
		Иначе
			ВопросОПерезаполнении();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВопросОПерезаполнении()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВопросОПерезаполненииЗавершение", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Табличная часть будет очищена. Продолжить?'");
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОПерезаполненииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ЗаполнитьПоПрограммеНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	
КонецПроцедуры

#КонецОбласти