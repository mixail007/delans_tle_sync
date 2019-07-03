
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Ответственный",    Ответственный,    СтруктураБыстрогоОтбора);
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "ОрганизацияЕГАИС", ОрганизацииЕГАИС, СтруктураБыстрогоОтбора);
	
	ИнтеграцияЕГАИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект, "Отбор");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	НастройкиОрганизацияЕГАИС = ИнтеграцияЕГАИСКлиентСервер.СтруктураПоискаПоляДляЗагрузкиИзНастроек(
		"ОрганизацииЕГАИС",
		Настройки);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "ОрганизацияЕГАИС",
	                                                                       ОрганизацииЕГАИС,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       НастройкиОрганизацияЕГАИС);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "Ответственный",
	                                                                       Ответственный,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);
	
	Настройки.Удалить("Ответственный");
	Настройки.Удалить("ОрганизацииЕГАИС");
	
	ИнтеграцияЕГАИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект, "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ВозвратИзРегистра2ЕГАИС" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И ТипЗнч(Параметр.Ссылка) = Тип("ДокументСсылка.ВозвратИзРегистра2ЕГАИС") Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусЕГАИСВФормахДокументов)) Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Ответственный",
	                                                                        Ответственный,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

#Область ОтборПоОрганизацииЕГАИС

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСПриИзменении(Элемент)
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ОрганизацииЕГАИС, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, Неопределено, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры


&НаКлиенте
Процедура ОтборОрганизацияЕГАИСПриИзменении(Элемент)
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ОрганизацияЕГАИС, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, Неопределено, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

#КонецОбласти