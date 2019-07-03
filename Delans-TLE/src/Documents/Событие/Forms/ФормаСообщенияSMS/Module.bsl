
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Документы.Событие.ПроверитьВозможностьВводаПоЛиду(Объект, Параметры.ЗначенияЗаполнения, Отказ);
	КонецЕсли;
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Строка"));
	Элементы.ПолучателиКонтакт.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов, Новый КвалификаторыСтроки(100));
	Элементы.Тема.ОграничениеТипа 			   = Новый ОписаниеТипов(МассивТипов, Новый КвалификаторыСтроки(200));
	
	ПровайдерSMS = Константы.ПровайдерSMS.Получить();
	НастройкиSMSВыполнены = ОтправкаSMS.НастройкаОтправкиSMSВыполнена();
	ДоступноПравоНастройкиSMS = Пользователи.ЭтоПолноправныйПользователь();
	ОсталосьСимволов = СформироватьНадписьКоличествоСимволов(ОтправлятьВТранслите, Объект.Содержание);
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗаполнитьНовоеСообщениеПоУмолчанию();
		ОбработатьПереданныеПараметры(Параметры, Отказ);
	КонецЕсли;
	
	ОбязательноЗаполнятьИсточникSMS = 
		РегистрыСведений.ОбязательностьЗаполненияРеквизитов.ОбязательностьЗаполненияРеквизита("SMS", "ИсточникПривлечения");
	Если ОбязательноЗаполнятьИсточникSMS Тогда
		Элементы.ИсточникПривлечения.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;

	// История темы для автоподбора
	ЗагрузитьИсториюТемСтрокой();
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = УправлениеСвойствамиПереопределяемый.ЗаполнитьДополнительныеПараметры(Объект, "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	//Мобильный клиент
	НастроитьФормуМобильныйКлиент();
	//Конец Мобильный клиент

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТипЗнч(ТекущийОбъект.Тема) = Тип("Строка") Тогда
	// Сохрание тем в истории для автоподбора
		
		ЭлементИстории = ИсторияТемСтрокой.НайтиПоЗначению(СокрЛП(ТекущийОбъект.Тема));
		Если ЭлементИстории <> Неопределено Тогда
			ИсторияТемСтрокой.Удалить(ЭлементИстории);
		КонецЕсли;
		ИсторияТемСтрокой.Вставить(0, СокрЛП(ТекущийОбъект.Тема));
		
		Пока ИсторияТемСтрокой.Количество() > 30 Цикл
			ИсторияТемСтрокой.Удалить(ИсторияТемСтрокой.Количество() - 1);
		КонецЦикла;
		
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("СписокВыбораТемыСобытия", "", ИсторияТемСтрокой.ВыгрузитьЗначения());
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// Обсуждения
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Модифицированность",Модифицированность);
	// Конец Обсуждения
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Заголовок = "";
	АвтоЗаголовок = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьЗаполнениеОбязательныхРеквизитов(Отказ);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	//Обсуждения
	ОбсужденияСервер.ПослеЗаписиНаСервере(ТекущийОбъект);	
	// Конец Обсуждения

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТемаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	Если ТипЗнч(Объект.Тема) = Тип("СправочникСсылка.ТемыСобытий") И ЗначениеЗаполнено(Объект.Тема) Тогда
		ПараметрыФормы.Вставить("ТекущаяСтрока", Объект.Тема);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ТемыСобытий.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ТемаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Модифицированность = Истина;
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Объект.Тема = ВыбранноеЗначение;
		ЗаполнитьСодержаниеСобытия(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТемаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если Ожидание <> 0 И НЕ ПустаяСтрока(Текст) Тогда
		
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = ПолучитьСписокВыбораТемы(Текст, ИсторияТемСтрокой);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьВТранслитеПриИзменении(Элемент)
	
	ОсталосьСимволов = СформироватьНадписьКоличествоСимволов(ОтправлятьВТранслите, Объект.Содержание);
	
КонецПроцедуры

&НаКлиенте
Процедура СодержаниеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ОсталосьСимволов = СформироватьНадписьКоличествоСимволов(ОтправлятьВТранслите, Текст);
	Объект.Содержание = Текст;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПолучатели

&НаКлиенте
Процедура ПолучателиКонтактНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипКИ", "Телефон");
	Если ЗначениеЗаполнено(Элементы.Получатели.ТекущиеДанные.Контакт) Тогда
		Контакт = Объект.Участники.НайтиПоИдентификатору(Элементы.Получатели.ТекущаяСтрока).Контакт;
		Если ТипЗнч(Контакт) = Тип("СправочникСсылка.Контрагенты") Тогда
			ПараметрыФормы.Вставить("ТекущийКонтрагент", Контакт);
		КонецЕсли;
	КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолучателиКонтактВыборЗавершение", ЭтаФорма);
	ОткрытьФорму("ОбщаяФорма.ФормаАдреснойКниги", ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиКонтактОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Модифицированность = Истина;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Контрагенты") Или ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
	// Выбор осуществлен механизмом автоподбора
		
		Объект.Участники.НайтиПоИдентификатору(Элементы.Получатели.ТекущаяСтрока).Контакт = ВыбранноеЗначение;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиКонтактАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если Ожидание <> 0 И НЕ ПустаяСтрока(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = ПолучитьСписокВыбораКонтактов(Текст);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отправить(Команда)
	
	ОчиститьСообщения();
	
	ЕстьОшибки = Ложь;
	Если Объект.Участники.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Список получателей не заполнен.'"),
			,
			"Объект.Участники",
			,
			ЕстьОшибки);
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.Содержание) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Поле ""Содержание"" не заполнено.'"),
			,
			"Объект.Содержание",
			,
			ЕстьОшибки);
	КонецЕсли;
	
	ПроверитьИПреобразоватьНомераПолучателей(ЕстьОшибки);
	Если ЕстьОшибки Тогда
		Возврат;
	КонецЕсли;
	
	Если НастройкиSMSВыполнены Тогда
		ОтправкаSMSНастройкиВыполнены();
	Иначе
		Если ДоступноПравоНастройкиSMS Тогда
			ОткрытьФорму("ОбщаяФорма.НастройкаОтправкиSMS",,ЭтаФорма,,,,Новый ОписаниеОповещения("ОтправкаSMSПроверкаНастроек", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
			ТекстСообщения = НСтр("ru = 'Для отправки SMS требуется настройка параметров отправки.
				|Для выполнения настроек обратитесь к администратору.'");
			ПоказатьПредупреждение(, ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусыДоставки(Команда)
	
	ОбновитьСтатусыДоставкиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСодержание(Команда)
	
	Если ЗначениеЗаполнено(Объект.Тема) Тогда
		ЗаполнитьСодержаниеСобытия(Объект.Тема);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	
	ТипыПредметов = Новый Массив;
	ТипыПредметов.Добавить(Тип("ДокументСсылка.АктВыполненныхРабот"));
	ТипыПредметов.Добавить(Тип("ДокументСсылка.ЗаданиеНаРаботу"));
	ТипыПредметов.Добавить(Тип("ДокументСсылка.ЗаказНаПроизводство"));
	ТипыПредметов.Добавить(Тип("ДокументСсылка.ЗаказПокупателя"));
	ТипыПредметов.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
	ТипыПредметов.Добавить(Тип("ДокументСсылка.ПриемИПередачаВРемонт"));
	ТипыПредметов.Добавить(Тип("ДокументСсылка.Событие"));
	ТипыПредметов.Добавить(Тип("ДокументСсылка.СчетНаОплату"));
	
	Если ТипыПредметов.Найти(ТипЗнч(Объект.ДокументОснование)) = Неопределено Тогда
		
		Если Объект.Участники.Количество() = 0 Тогда
			
			ОткрытьВыборШаблонаПоПредмету();
			
		ИначеЕсли Объект.Участники.Количество() = 1
			И (ТипЗнч(Объект.Участники[0].Контакт) = Тип("СправочникСсылка.Контрагенты")
				Или ТипЗнч(Объект.Участники[0].Контакт) = Тип("СправочникСсылка.КонтактныеЛица")) Тогда
			
			ОткрытьВыборШаблонаПоПредмету(Объект.Участники[0].Контакт);
			
		Иначе
			СписокПредметов = Новый СписокЗначений;
			Для Каждого Участник Из Объект.Участники Цикл
				Если ТипЗнч(Участник.Контакт) = Тип("СправочникСсылка.Контрагенты")
					Или ТипЗнч(Участник.Контакт) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
					
					СписокПредметов.Добавить(Участник.Контакт);
				КонецЕсли;
			КонецЦикла;
			
			ОткрытьВыборПредметаШаблона(СписокПредметов);
			
		КонецЕсли;
		
	Иначе
		
		ОткрытьВыборШаблонаПоПредмету(Объект.ДокументОснование);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьНовоеСообщениеПоУмолчанию()
	
	АвтоЗаголовок = Ложь;
	Заголовок = "Событие: " + Объект.ТипСобытия + " (создание)";
	
	Объект.НачалоСобытия = '00010101';
	Объект.ОкончаниеСобытия = '00010101';
	Объект.ИмяОтправителяSMS = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиSMS", "ИмяОтправителяSMS", "");
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаполнениеОбязательныхРеквизитов(Отказ)
	
	ОбязательныеДляЗаполненияРеквизиты = РегистрыСведений.ОбязательностьЗаполненияРеквизитов.ОбязательныеДляЗаполненияРеквизитыОбъекта("SMS");
	
	Для Каждого Реквизит Из ОбязательныеДляЗаполненияРеквизиты Цикл
				
		Если ЗначениеЗаполнено(Объект[Реквизит]) Тогда
			Продолжить;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Заполнение", 
			"Источник привлечения"),,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Объект[%1]", Реквизит),,
			Отказ);
			
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОбработатьПереданныеПараметры(Параметры, Отказ)
	
	Если НЕ ПустаяСтрока(Параметры.Текст) Тогда
		
		Объект.Содержание = Параметры.Текст;
		
	КонецЕсли;
	
	Если Параметры.Получатели <> Неопределено Тогда
		
		Если ТипЗнч(Параметры.Получатели) = Тип("Строка") И НЕ ПустаяСтрока(Параметры.Получатели) Тогда
			
			НоваяСтрока = Объект.Участники.Добавить();
			НоваяСтрока.КакСвязаться = Параметры.Кому;
			
		ИначеЕсли ТипЗнч(Параметры.Получатели) = Тип("СписокЗначений") Тогда
			
			Для Каждого ЭлементСписка Из Параметры.Получатели Цикл
				НоваяСтрока = Объект.Участники.Добавить();
				НоваяСтрока.Контакт = ЭлементСписка.Представление;
				НоваяСтрока.КакСвязаться  = ЭлементСписка.Значение;
			КонецЦикла;
			
		ИначеЕсли ТипЗнч(Параметры.Получатели) = Тип("Массив") Тогда
			
			Для Каждого ЭлементМассива Из Параметры.Получатели Цикл
				
				НоваяСтрока = Объект.Участники.Добавить();
				Если ЭлементМассива.Свойство("ИсточникКонтактнойИнформации") И ЗначениеЗаполнено(ЭлементМассива.ИсточникКонтактнойИнформации) Тогда
					НоваяСтрока.Контакт = ЭлементМассива.ИсточникКонтактнойИнформации;
				КонецЕсли;
				НоваяСтрока.КакСвязаться = ЭлементМассива.Телефон;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ОтправлятьВТранслите") Тогда
		ОтправлятьВТранслите = Параметры.ОтправлятьВТранслите;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьНадписьКоличествоСимволов(ОтправлятьВТранслите, знач ТекстСообщения)
	
	СимволовВСообщении = ?(ОтправлятьВТранслите, 140, 66);
	ЧислоСимволов = СтрДлина(ТекстСообщения);
	КоличествоСообщений   = Цел(ЧислоСимволов / СимволовВСообщении) + 1;
	ОсталосьСимволов      = СимволовВСообщении - ЧислоСимволов % СимволовВСообщении;
	ШаблонТекстаСообщения = НСтр("ru = 'Сообщение - %1, осталось символов - %2'");
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстаСообщения, КоличествоСообщений, ОсталосьСимволов);
	
КонецФункции

&НаСервере
Процедура ПроверитьИПреобразоватьНомераПолучателей(Отказ)
	
	Для Каждого Получатель Из Объект.Участники Цикл
		
		Если ПустаяСтрока(Получатель.КакСвязаться) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Поле ""Номер телефона"" не заполнено.'"),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Участники", Получатель.НомерСтроки, "КакСвязаться"),
				,
				Отказ);
			Продолжить;
		КонецЕсли;
		
		Если СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Получатель.КакСвязаться, ";", Истина).Количество() > 1 Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Должен быть указан только один номер телефона.'"),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Участники", Получатель.НомерСтроки, "КакСвязаться"),
				,
				Отказ);
			Продолжить;
		КонецЕсли;
		
		РезультатПроверки = УправлениеНебольшойФирмойКлиентСервер.ПреобразоватьНомерДляОтправкиSMS(Получатель.КакСвязаться);
		Если РезультатПроверки.НомерКорректен Тогда
			Получатель.НомерДляОтправки = РезультатПроверки.НомерОтправки;
		Иначе
			ОбщегоНазначения.СообщитьПользователю(
				РезультатПроверки.СообщениеОбОшибке,
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Участники", Получатель.НомерСтроки, "КакСвязаться"),
				,
				Отказ);
			Продолжить;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправкаSMSПроверкаНастроек(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	НастройкиSMSВыполнены = НастройкиSMSВыполненыСервер(ПровайдерSMS);
	Если НастройкиSMSВыполнены Тогда
		ОтправкаSMSНастройкиВыполнены();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкиSMSВыполненыСервер(ПровайдерSMS)
	
	ПровайдерSMS = Константы.ПровайдерSMS.Получить();
	Возврат ОтправкаSMS.НастройкаОтправкиSMSВыполнена();
	
КонецФункции

&НаКлиенте
Процедура ОтправкаSMSНастройкиВыполнены()
	
	ОписаниеОшибки = ВыполнитьОтправкуSMS();
	
	Если ПустаяСтрока(ОписаниеОшибки) Тогда
		Объект.Состояние = ПредопределенноеЗначение("Справочник.СостоянияСобытий.Завершено");
		Объект.Дата = ОбщегоНазначенияКлиент.ДатаСеанса();
		Объект.НачалоСобытия = Объект.Дата;
		Объект.ОкончаниеСобытия = Объект.Дата;
		Записать();
		ПоказатьОповещениеПользователя(НСтр("ru = 'SMS успешно отправлено'"), ПолучитьНавигационнуюСсылку(Объект.Ссылка), Строка(Объект.Ссылка), БиблиотекаКартинок.Информация32);
		Закрыть();
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(ОписаниеОшибки,,"Объект");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьОтправкуSMS()
	
	МассивНомеров     = Объект.Участники.Выгрузить(,"НомерДляОтправки").ВыгрузитьКолонку("НомерДляОтправки");
	РезультатОтправки = ОтправкаSMS.ОтправитьSMS(МассивНомеров, Объект.Содержание, Объект.ИмяОтправителяSMS, ОтправлятьВТранслите);
	
	Для Каждого ОтправленноеСообщение Из РезультатОтправки.ОтправленныеСообщения Цикл
		Для Каждого НайденнаяСтрока Из Объект.Участники.НайтиСтроки(Новый Структура("НомерДляОтправки", ОтправленноеСообщение.НомерПолучателя)) Цикл
			НайденнаяСтрока.ИдентификаторСообщения = ОтправленноеСообщение.ИдентификаторСообщения;
			НайденнаяСтрока.СтатусДоставки         = Перечисления.СостоянияСообщенияSMS.Исходящее;
		КонецЦикла;
	КонецЦикла;
	
	Возврат РезультатОтправки.ОписаниеОшибки;
	
КонецФункции

&НаСервере
Процедура ОбновитьСтатусыДоставкиНаСервере()
	
	Для Каждого Получатель Из Объект.Участники Цикл
		
		СтатусДоставки = ОтправкаSMS.СтатусДоставки(Получатель.ИдентификаторСообщения);
		Получатель.СтатусДоставки = УправлениеНебольшойФирмойВзаимодействия.СопоставитьСтатусДоставкиSMS(СтатусДоставки);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиКонтактВыборЗавершение(АдресВХранилище, ДополнительныеПараметры) Экспорт
	
	Если ЭтоАдресВременногоХранилища(АдресВХранилище) Тогда
		
		ЗаблокироватьДанныеФормыДляРедактирования();
		Модифицированность = Истина;
		ЗаполнитьКонтактыПоАдреснойКниге(АдресВХранилище)
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКонтактыПоАдреснойКниге(АдресВХранилище)
	
	ТаблицаАдресатов = ПолучитьИзВременногоХранилища(АдресВХранилище);
	ОбработкаТекущейСтроки = Истина;
	Для Каждого ПодобраннаяСтрока Из ТаблицаАдресатов Цикл
		
		Если ОбработкаТекущейСтроки Тогда
			СтрокаУчастники = Объект.Участники.НайтиПоИдентификатору(Элементы.Получатели.ТекущаяСтрока);
			ОбработкаТекущейСтроки = Ложь;
		Иначе
			СтрокаУчастники = Объект.Участники.Добавить();
		КонецЕсли;
		
		СтрокаУчастники.Контакт = ПодобраннаяСтрока.Контакт;
		СтрокаУчастники.КакСвязаться = ПодобраннаяСтрока.КакСвязаться;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокВыбораКонтактов(знач СтрокаПоиска)
	
	ДанныеВыбораКонтактов = Новый СписокЗначений;
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("Отбор", Новый Структура("ПометкаУдаления", Ложь));
	ПараметрыВыбора.Вставить("СтрокаПоиска", СтрокаПоиска);
	
	ДанныеВыбораКонтрагентов = Справочники.Контрагенты.ПолучитьДанныеВыбора(ПараметрыВыбора);
	
	Для Каждого ЭлементСписка Из ДанныеВыбораКонтрагентов Цикл
		ДанныеВыбораКонтактов.Добавить(ЭлементСписка.Значение, Новый ФорматированнаяСтрока(ЭлементСписка.Представление, " (контрагент)"));
	КонецЦикла;
	
	ДанныеВыбораКонтактныхЛиц = Справочники.КонтактныеЛица.ПолучитьДанныеВыбора(ПараметрыВыбора);
	
	Для Каждого ЭлементСписка Из ДанныеВыбораКонтактныхЛиц Цикл
		ДанныеВыбораКонтактов.Добавить(ЭлементСписка.Значение, Новый ФорматированнаяСтрока(ЭлементСписка.Представление, " (контактное лицо)"));
	КонецЦикла;
	
	Возврат ДанныеВыбораКонтактов;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСписокВыбораТемы(знач СтрокаПоиска, знач ИсторияТемСтрокой)
	
	СписокВыбораТемы = Новый СписокЗначений;
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("Отбор", Новый Структура("ПометкаУдаления", Ложь));
	ПараметрыВыбора.Вставить("СтрокаПоиска", СтрокаПоиска);
	ПараметрыВыбора.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
	
	ДанныеВыбораТемы = Справочники.ТемыСобытий.ПолучитьДанныеВыбора(ПараметрыВыбора);
	
	Для Каждого ЭлементСписка Из ДанныеВыбораТемы Цикл
		СписокВыбораТемы.Добавить(ЭлементСписка.Значение, Новый ФорматированнаяСтрока(ЭлементСписка.Представление, " (тема события)"));
	КонецЦикла;
	
	Для Каждого ЭлементИстории Из ИсторияТемСтрокой Цикл
		Если Лев(ЭлементИстории.Значение, СтрДлина(СтрокаПоиска)) = СтрокаПоиска Тогда
			СписокВыбораТемы.Добавить(ЭлементИстории.Значение, 
				Новый ФорматированнаяСтрока(Новый ФорматированнаяСтрока(СтрокаПоиска,Новый Шрифт(,,Истина),WebЦвета.Зеленый), Сред(ЭлементИстории.Значение, СтрДлина(СтрокаПоиска)+1)));
		КонецЕсли;
	КонецЦикла;
	
	Возврат СписокВыбораТемы;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьИсториюТемСтрокой()
	
	СписокВыбораТемы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("СписокВыбораТемыСобытия", "");
	Если СписокВыбораТемы <> Неопределено Тогда
		ИсторияТемСтрокой.ЗагрузитьЗначения(СписокВыбораТемы);
	КонецЕсли;
	
КонецПроцедуры // ЗагрузитьСписокВыбораТемыСобытия()

&НаКлиенте
Процедура ЗаполнитьСодержаниеСобытия(ТемаСобытия)
	
	Если ТипЗнч(ТемаСобытия) <> Тип("СправочникСсылка.ТемыСобытий") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Объект.Содержание) Тогда
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьСодержаниеСобытияЗавершение", ЭтотОбъект, Новый Структура("ТемаСобытия", ТемаСобытия)),
			НСтр("ru = 'Перезаполнить содержание по выбранной теме?'"), РежимДиалогаВопрос.ДаНет, 0);
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьСодержаниеСобытияФрагмент(ТемаСобытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСодержаниеСобытияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСодержаниеСобытияФрагмент(ДополнительныеПараметры.ТемаСобытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСодержаниеСобытияФрагмент(Знач ТемаСобытия)
	
	Объект.Содержание = ПолучитьСодержаниеТемы(ТемаСобытия);
	
КонецПроцедуры 

&НаСервереБезКонтекста
Функция ПолучитьСодержаниеТемы(ТемаСобытия)
	
	Возврат ТемаСобытия.Содержание;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПисьмоПоШаблону(ДанныеСообщения)
	
	Если ТипЗнч(ДанныеСообщения.Получатель) = Тип("Массив") И ДанныеСообщения.Получатель.Количество() > 0 Тогда
		Объект.Участники.Очистить();
		Для Каждого Получатель Из ДанныеСообщения.Получатель Цикл
			Участник = Объект.Участники.Добавить();
			Участник.Контакт = ?(ЗначениеЗаполнено(Получатель.ИсточникКонтактнойИнформации), Получатель.ИсточникКонтактнойИнформации, Получатель.Представление);
			Участник.КакСвязаться = Получатель.НомерТелефона;
		КонецЦикла;
	КонецЕсли;
	
	Объект.Тема = ДанныеСообщения.Тема;
	Объект.Содержание = ДанныеСообщения.Текст;
	Если ДанныеСообщения.ДополнительныеПараметры.Свойство("ПеревестиВТранслит") Тогда
		ЭтотОбъект.ОтправлятьВТранслите = ДанныеСообщения.ДополнительныеПараметры.ПеревестиВТранслит;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВыборШаблонаПоПредмету(ПредметШаблона = Неопределено)
	
	Если Не ЕстьДоступныеШаблоны(ПредметШаблона) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Нет доступных шаблонов. Добавить новые шаблоны можно в списке шаблонов: CRM — Шаблоны писем, SMS'"));
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПоШаблонуПослеВыбораШаблона", ЭтотОбъект);
	ШаблоныСообщенийКлиент.ПодготовитьСообщениеПоШаблону(ПредметШаблона, "СообщениеSMS", ОписаниеОповещения,, Новый Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблонуПослеВыбораШаблона(ДанныеСообщения, ДополнительныеПараметры) Экспорт
	
	Если ДанныеСообщения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПисьмоПоШаблону(ДанныеСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВыборПредметаШаблона(СписокПредметов)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПоШаблонуПослеВыбораПредмета", ЭтотОбъект);
	СписокПредметов.Вставить(0, "Общий", НСтр("ru='<Общие шаблоны>'"));
	
	СписокПредметов.ПоказатьВыборЭлемента(ОписаниеОповещения, НСтр("ru='Выбор предмета шаблона'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблонуПослеВыбораПредмета(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныйЭлемент.Значение = "Общий" Тогда
		ОткрытьВыборШаблонаПоПредмету();
	Иначе
		ОткрытьВыборШаблонаПоПредмету(ВыбранныйЭлемент.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьДоступныеШаблоны(ПредметШаблона)
	Возврат ШаблоныСообщенийПереопределяемый.ЕстьДоступныеШаблоны(Ложь, ПредметШаблона);
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область НастройкаВидимостьЭлементовФормы

// Процедура выполняет настройку элементов формы для корректного отображения в мобильном клиенте
//
&НаСервере
Процедура НастроитьФормуМобильныйКлиент()
	
	Если НЕ ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПанельПравая", "ОтображатьЗаголовок", Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДобавитьПолучателя", "Видимость", Истина);	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры // ОбновитьЭлементыДополнительныхРеквизитов()

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
