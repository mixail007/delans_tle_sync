
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	РежимОтладки = ОбщегоНазначенияКлиентСервер.РежимОтладки();
	
	Элементы.Код.ТолькоПросмотр                        = Не РежимОтладки;
	Элементы.ТипОрганизации.ТолькоПросмотр             = Не РежимОтладки;
	Элементы.ТипОрганизации.ТолькоПросмотр             = Не РежимОтладки;
	Элементы.ИНН.ТолькоПросмотр                        = Не РежимОтладки;
	Элементы.КПП.ТолькоПросмотр                        = Не РежимОтладки;
	Элементы.НаименованиеПолное.ТолькоПросмотр         = Не РежимОтладки;
	Элементы.ИдентификаторОрганизацииТС.ТолькоПросмотр = Не РежимОтладки;
	Элементы.ФорматОбмена.ТолькоПросмотр               = Не РежимОтладки;
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораКонтрагента(
		Новый ОписаниеОповещения("ПриВыбореКонтрагента", ЭтотОбъект), ВыбранноеЗначение, ИсточникВыбора);
		
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораТорговогоОбъекта(
		Новый ОписаниеОповещения("ПриВыбореТорговогоОбъекта", ЭтотОбъект), ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораКонтрагента(
		Новый ОписаниеОповещения("ПриВыбореКонтрагента", ЭтотОбъект), НовыйОбъект, Источник);
		
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораТорговогоОбъекта(
		Новый ОписаниеОповещения("ПриВыбореТорговогоОбъекта", ЭтотОбъект), НовыйОбъект, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФормЕГАИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_КлассификаторОрганизацийЕГАИС", Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если (ЗначениеЗаполнено(Объект.Контрагент) Или ЗначениеЗаполнено(Объект.ТорговыйОбъект))
		И Объект.СоответствуетОрганизации Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КлассификаторОрганизацийЕГАИС.Ссылка         КАК Ссылка,
		|	КлассификаторОрганизацийЕГАИС.Контрагент     КАК Контрагент,
		|	КлассификаторОрганизацийЕГАИС.ТорговыйОбъект КАК ТорговыйОбъект
		|ИЗ
		|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
		|ГДЕ
		|	КлассификаторОрганизацийЕГАИС.Ссылка <> &Ссылка
		|	И КлассификаторОрганизацийЕГАИС.ТорговыйОбъект = &ТорговыйОбъект
		|	И КлассификаторОрганизацийЕГАИС.Контрагент = &Контрагент
		|");
		
		Запрос.УстановитьПараметр("Ссылка",         Объект.Ссылка);
		Запрос.УстановитьПараметр("ТорговыйОбъект", Объект.ТорговыйОбъект);
		Запрос.УстановитьПараметр("Контрагент",     Объект.Контрагент);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			
			ТекстСообщения = НСтр("ru = 'Организация ""%2"" и торговый объект ""%3"" уже сопоставлены с организацией ЕГАИС ""%1""'");
			
			ТекстСообщения = СтрШаблон(
				ТекстСообщения,
				Выборка.Ссылка, Выборка.Контрагент, Выборка.ТорговыйОбъект);
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,,
				"Контрагент", "Объект");
			
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СопоставитьПоИННКПП(Команда)
	
	ОчиститьСообщения();
	
	КонтрагентНайден = СопоставитьПоИННКППСервер();
	
	Если Не КонтрагентНайден Тогда
		Если ЕстьПравоСозданияКонтрагента Тогда
			ПоказатьВопрос(
				Новый ОписаниеОповещения("ПодтвердитьСоздатьНовогоКонтрагента", ЭтотОбъект),
				НСтр("ru='Контрагент с указанными ИНН и КПП не найден. Создать нового?'"),
				РежимДиалогаВопрос.ДаНет);
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Контрагент с указанными ИНН и КПП не найден.'"),,
			                                                  "ИНН",
			                                                  "Объект");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьАлкогольнуюПродукцию(Команда)
	
	ОчиститьСообщения();
	
	Если ПустаяСтрока(Объект.ИНН) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнен ИНН организации'"),, "Объект.ИНН");
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Операция",          ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросАлкогольнойПродукции"));
	ПараметрыФормы.Вставить("ИмяПараметра",      "ИНН");
	ПараметрыФормы.Вставить("ЗначениеПараметра", Объект.ИНН);
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормированиеИсходящегоЗапросаЕГАИС",
		ПараметрыФормы,
		ЭтотОбъект,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьОрганизациюПоКодуФСРАР(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Операция",         ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросДанныхОрганизации"));
	ПараметрыФормы.Вставить("ИмяПараметра",     "СИО");
	ПараметрыФормы.Вставить("ЗначениеПараметра", Объект.Код);
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормированиеИсходящегоЗапросаЕГАИС",
		ПараметрыФормы,
		ЭтотОбъект,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьИнформациюОбИспользуемомФорматеОбмена(Команда)
	
	ФорматОбмена = ИнтеграцияЕГАИСКлиентСервер.ФорматОбмена(Объект.ФорматОбмена);
	
	ИнтеграцияЕГАИСКлиент.ПодготовитьИнформациюОФорматеОбменаКПередаче(
		Новый ОписаниеОповещения("ПослеВыгрузкиИнформацииОбИспользуемомФорматеОбмена", ЭтотОбъект), Объект.Ссылка, ФорматОбмена,
		ЭтотОбъект.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипОрганизацииПриИзменении(Элемент)
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	ПриИзмененииИНН(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИННИППриИзменении(Элемент)
	
	ПриИзмененииИНН(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КПППриИзменении(Элемент)
	
	ТекстСообщения = "";
	Если Не ПустаяСтрока(Объект.КПП)
		И Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(Объект.КПП, ТекстСообщения) Тогда
		
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			ТекстСообщения,,
			"КПП");
			
	КонецЕсли;
	
	СоответствуетОрганизацииПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СоответствуетОрганизацииПриИзменении(Элемент)
	
	Если Объект.СоответствуетОрганизации Тогда
		Объект.Контрагент = СобственнаяОрганизацияЗначениеПоУмолчанию;
		Объект.ТорговыйОбъект = СобственныйТорговыйОбъектЗначениеПоУмолчанию;
	Иначе
		Объект.Контрагент = СторонняяОрганизацияЗначениеПоУмолчанию;
		Объект.ТорговыйОбъект = СтороннийТорговыйОбъектЗначениеПоУмолчанию;
	КонецЕсли;
	
	СоответствуетОрганизацииПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПриИзмененииРеквизитаСопоставленияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТорговыйОбъектПриИзменении(Элемент)
	
	ПриИзмененииРеквизитаСопоставленияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	КонтрагентПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СтороннийТорговыйОбъектПриИзменении(Элемент)
	
	СтороннийТорговыйОбъектПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ИНН",                     Объект.ИНН);
	Реквизиты.Вставить("КПП",                     Объект.КПП);
	Реквизиты.Вставить("Наименование",            Объект.НаименованиеПолное);
	Реквизиты.Вставить("СокращенноеНаименование", Объект.Наименование);
	Реквизиты.Вставить("ТорговыйОбъект",          Объект.ТорговыйОбъект);
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуВыбораКонтрагента(
		ЭтотОбъект,
		Реквизиты,
		Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентСоздание(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СоздатьНовогоКонтрагента();
	
КонецПроцедуры

&НаКлиенте
Процедура СтороннийТорговыйОбъектНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ИНН",                     Объект.ИНН);
	Реквизиты.Вставить("КПП",                     Объект.КПП);
	Реквизиты.Вставить("Наименование",            Объект.НаименованиеПолное);
	Реквизиты.Вставить("СокращенноеНаименование", Объект.Наименование);
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуВыбораТорговогоОбъекта(
		ЭтотОбъект,
		Реквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура СтороннийТорговыйОбъектСоздание(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ИНН",                     Объект.ИНН);
	Реквизиты.Вставить("КПП",                     Объект.КПП);
	Реквизиты.Вставить("Наименование",            Объект.НаименованиеПолное);
	Реквизиты.Вставить("СокращенноеНаименование", Объект.Наименование);
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуСозданияТорговогоОбъекта(
		ЭтотОбъект,
		Реквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматОбменаПриИзменении(Элемент)
	
	ОбновитьИнформациюОВыгруженномФорматеОбмена();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаПриИзменении(Элемент)
	
	Текст = Элемент.ТекстРедактирования;
	Если ПустаяСтрока(Текст) Тогда
		// Очистка данных, сбрасываем как представления, так и внутренние значения полей.
		Объект.ПредставлениеАдреса = "";
		Объект.ПочтовыйИндекс      = 0;
		Объект.КодРегиона          = 0;
		Объект.КодСтраны           = 0;
		КомментарийАдреса          = "";
		Объект.Адрес               = "";
		Возврат;
	КонецЕсли;
	
	// Формируем внутренние значения полей по тексту и параметрам формирования из
	// реквизита ВидКонтактнойИнформацииАдреса.
	Объект.ПредставлениеАдреса = Текст;
	
	Объект.Адрес = ЗначенияПолейКонтактнойИнформацииСервер(Текст, ВидКонтактнойИнформацииАдреса, КомментарийАдреса);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Если представление было изменено в поле и сразу нажата кнопка выбора, то необходимо 
	// привести данные в соответствие и сбросить внутренние поля для повторного разбора.
	Если Элемент.ТекстРедактирования <> Объект.ПредставлениеАдреса Тогда
		Объект.ПредставлениеАдреса = Элемент.ТекстРедактирования;
		Объект.Адрес               = "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Адрес) Тогда
		
		АдресXML = Объект.Адрес;
		
	Иначе
		
		Данные = Новый Структура;
		Данные.Вставить("КодСтраны",     Объект.КодСтраны);
		Данные.Вставить("КодРегиона",    Объект.КодРегиона);
		Данные.Вставить("Индекс",        Объект.ПочтовыйИндекс);
		Данные.Вставить("Представление", Объект.ПредставлениеАдреса);
		
		АдресXML = АдресXML(Данные);
		
	КонецЕсли;
	
	// Данные для редактирования
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ВидКонтактнойИнформацииАдреса);
	ПараметрыОткрытия.Вставить("ЗначенияПолей",           АдресXML);
	ПараметрыОткрытия.Вставить("Представление",           Объект.ПредставлениеАдреса);
	ПараметрыОткрытия.Вставить("Комментарий",             КомментарийАдреса);
	
	// Переопределямый заголовок формы, по умолчанию отобразятся данные по ВидКонтактнойИнформации.
	ПараметрыОткрытия.Вставить("Заголовок", НСтр("ru='Адрес'"));
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОчистка(Элемент, СтандартнаяОбработка)
	// Сбрасываем как представления, так и внутренние значения полей.
	Объект.ПредставлениеАдреса = "";
	Объект.ПочтовыйИндекс      = 0;
	Объект.КодРегиона          = 0;
	Объект.КодСтраны           = 0;
	КомментарийАдреса          = "";
	Объект.Адрес               = "";
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение)<>Тип("Структура") Тогда
		// Отказ от выбора, данные неизменны.
		Возврат;
	КонецЕсли;
	
	АдресВФорматеКЛАДР = АдресВФорматеКЛАДР(ВыбранноеЗначение.КонтактнаяИнформация);
	
	Если АдресВФорматеКЛАДР.Свойство("КодРегиона") Тогда
		Объект.КодРегиона = АдресВФорматеКЛАДР.КодРегиона;
	Иначе
		Объект.КодРегиона = Неопределено;
	КонецЕсли;
	
	Если АдресВФорматеКЛАДР.Свойство("КодСтраны") Тогда
		Объект.КодСтраны = АдресВФорматеКЛАДР.КодСтраны;
	Иначе
		Объект.КодСтраны = Неопределено;
	КонецЕсли;
	
	Если АдресВФорматеКЛАДР.Свойство("Индекс") Тогда
		Объект.ПочтовыйИндекс = АдресВФорматеКЛАДР.Индекс;
	Иначе
		Объект.ПочтовыйИндекс = Неопределено;
	КонецЕсли;
	
	Объект.Адрес = ВыбранноеЗначение.КонтактнаяИнформация;
	
	Объект.ПредставлениеАдреса = ВыбранноеЗначение.Представление;
	КомментарийАдреса          = ВыбранноеЗначение.Комментарий;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийАдресаПриИзменении(Элемент)
	ЗаполнитьКомментарийАдресаСервер();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция АдресXML(Данные)
	
	СтруктураАдреса = Новый Структура;
	
	Если ЗначениеЗаполнено(Данные.КодСтраны) Тогда
		СтруктураАдреса.Вставить("КодСтраны", Формат(Данные.КодСтраны, "ЧГ=0"));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Данные.КодСтраны) Тогда
		СтруктураАдреса.Вставить("КодРегиона", Формат(Данные.КодРегиона, "ЧГ=0"));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Данные.КодСтраны) Тогда
		СтруктураАдреса.Вставить("Индекс", Формат(Данные.Индекс, "ЧГ=0"));
	КонецЕсли;
	
	СтруктураАдреса.Вставить("Представление", Данные.Представление);
	
	Возврат УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(СтруктураАдреса, Данные.Представление, Перечисления.ТипыКонтактнойИнформации.Адрес);
	
КонецФункции

&НаСервере
Процедура ИнициализироватьПоляКонтактнойИнформации()
	
	// Реквизит формы, контролирующий работу с адресом.
	// Используемые поля аналогичны полям справочника ВидыКонтактнойИнформации.
	ВидКонтактнойИнформацииАдреса = Новый Структура;
	ВидКонтактнойИнформацииАдреса.Вставить("Тип", Перечисления.ТипыКонтактнойИнформации.Адрес);
	ВидКонтактнойИнформацииАдреса.Вставить("АдресТолькоРоссийский",        Ложь);
	ВидКонтактнойИнформацииАдреса.Вставить("ВключатьСтрануВПредставление", Ложь);
	ВидКонтактнойИнформацииАдреса.Вставить("СкрыватьНеактуальныеАдреса",   Ложь);
	
	// Считываем данные из полей адреса в реквизиты для редактирования.
	КомментарийАдреса = УправлениеКонтактнойИнформацией.КомментарийКонтактнойИнформации(Объект.Адрес);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКомментарийАдресаСервер()
	
	Если ПустаяСтрока(Объект.Адрес) Тогда
		// Необходимо инициализировать данные.
		Объект.Адрес = ЗначенияПолейКонтактнойИнформацииСервер(Объект.ПредставлениеАдреса, ВидКонтактнойИнформацииАдреса, КомментарийАдреса);
		Возврат;
	КонецЕсли;
	
	УправлениеКонтактнойИнформацией.УстановитьКомментарийКонтактнойИнформации(Объект.Адрес, КомментарийАдреса);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗначенияПолейКонтактнойИнформацииСервер(Знач Представление, Знач ВидКонтактнойИнформации, Знач Комментарий = Неопределено)
	
	// Создаем новый экземпляр по представлению.
	Результат = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Представление, ВидКонтактнойИнформации);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СоответствуетОрганизацииПриИзмененииСервер()
	
	Объект.СоответствуетОрганизации = Булево(СоответствуетОрганизации);
	
	Элементы.ГруппаСобственнаяОрганизация.Видимость = Объект.СоответствуетОрганизации;
	Элементы.ГруппаСторонняяОрганизация.Видимость = НЕ Объект.СоответствуетОрганизации;
	
	ПриИзмененииРеквизитаСопоставленияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СтороннийТорговыйОбъектПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.ТорговыйОбъект) Тогда
		Объект.Контрагент = ИнтеграцияЕГАИСПереопределяемый.КонтрагентТорговогоОбъекта(Объект.ТорговыйОбъект);
	Иначе
		Объект.Контрагент = СторонняяОрганизацияЗначениеПоУмолчанию;
	КонецЕсли;
	
	ПриИзмененииРеквизитаСопоставленияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Объект.ТорговыйОбъект = ИнтеграцияЕГАИСПереопределяемый.ТорговыйОбъектКонтрагента(Объект.Контрагент);
	КонецЕсли;
	
	ПриИзмененииРеквизитаСопоставленияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииИНН(ЭтоЮрЛицо)
	
	ТекстСообщения = "";
	Если Не ПустаяСтрока(Объект.ИНН)
		И Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Объект.ИНН, ЭтоЮрЛицо, ТекстСообщения) Тогда
		
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			ТекстСообщения,,
			"Объект.ИНН");
		
	КонецЕсли;
	
	СоответствуетОрганизацииПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСопоставлено()
	
	Объект.Сопоставлено = Справочники.КлассификаторОрганизацийЕГАИС.РассчитатьСопоставлено(
		Объект.ТорговыйОбъект,
		Объект.Контрагент,
		Объект.СоответствуетОрганизации);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Элементы.СопоставитьПоИННКПП.Доступность = (ЗначениеЗаполнено(Объект.ИНН) И Не Объект.Сопоставлено);
	Элементы.СопоставитьПоИНН.Доступность    = (ЗначениеЗаполнено(Объект.ИНН) И Не Объект.Сопоставлено);
	
	Элементы.ГруппаЮЛ.Видимость = (Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизацийЕГАИС.ЮридическоеЛицоРФ")
	                              ИЛИ Объект.ТипОрганизации.Пустая());
	
	Элементы.ГруппаИП.Видимость = (Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизацийЕГАИС.ИндивидуальныйПредпринимательРФ"));
	Элементы.ГруппаТС.Видимость = (Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизацийЕГАИС.КонтрагентТаможенногоСоюза"));
	
	Элементы.ВыгрузитьИнформациюОбИспользуемомФорматеОбмена.Видимость = СоответствуетОрганизации;
	Элементы.ИнформацияОВыгруженномФорматеОбмена.Видимость            = СоответствуетОрганизации;
	
	Элементы.ЗапроситьАлкогольнуюПродукцию.Видимость =
		Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизацийЕГАИС.ЮридическоеЛицоРФ")
		ИЛИ Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизацийЕГАИС.ИндивидуальныйПредпринимательРФ");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеСопоставления()
	
	ДанныеСопоставления = Неопределено;
	
	Если ЗначениеЗаполнено(Объект.Контрагент)
		И ПравоДоступа("Чтение", Объект.Контрагент.Метаданные()) Тогда
		
		ДанныеСопоставления = ИнтеграцияЕГАИСПереопределяемый.ИННКППСопоставленнойОрганизации(Объект.Контрагент, Объект.ТорговыйОбъект);
		
	КонецЕсли;
	
	Если ДанныеСопоставления <> Неопределено Тогда
		
		ИНН = ДанныеСопоставления.ИНН;
		КПП = ДанныеСопоставления.КПП;
		
		Элементы.ИННОрганизацииНеСоответствуетОрганизацииЕГАИС.Видимость = (ДанныеСопоставления.ИНН <> Объект.ИНН И Объект.СоответствуетОрганизации);
		Элементы.КППОрганизацииНеСоответствуетОрганизацииЕГАИС.Видимость = (ДанныеСопоставления.КПП <> Объект.КПП И Объект.СоответствуетОрганизации);
		Элементы.ИННКонтрагентаНеСоответствуетОрганизацииЕГАИС.Видимость = (ДанныеСопоставления.ИНН <> Объект.ИНН И НЕ Объект.СоответствуетОрганизации);
		Элементы.КППКонтрагентаНеСоответствуетОрганизацииЕГАИС.Видимость = (ДанныеСопоставления.КПП <> Объект.КПП И НЕ Объект.СоответствуетОрганизации);
		
	Иначе
		
		ИНН = "";
		КПП = "";
		
		Элементы.ИННОрганизацииНеСоответствуетОрганизацииЕГАИС.Видимость = Ложь;
		Элементы.КППОрганизацииНеСоответствуетОрганизацииЕГАИС.Видимость = Ложь;
		Элементы.ИННКонтрагентаНеСоответствуетОрганизацииЕГАИС.Видимость = Ложь;
		Элементы.КППКонтрагентаНеСоответствуетОрганизацииЕГАИС.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитаСопоставленияНаСервере()
	
	ЗаполнитьДанныеСопоставления();
	РассчитатьСопоставлено();
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	СоответствуетОрганизации = Объект.СоответствуетОрганизации;
	
	ИнтеграцияЕГАИСПереопределяемый.ЗначенияПоУмолчаниюНеСопоставленныхОбъектов(
		СобственнаяОрганизацияЗначениеПоУмолчанию,
		СобственныйТорговыйОбъектЗначениеПоУмолчанию,
		СторонняяОрганизацияЗначениеПоУмолчанию,
		СтороннийТорговыйОбъектЗначениеПоУмолчанию);
	
	МассивТиповСобственнаяОрганизация = Новый Массив;
	МассивТиповСобственнаяОрганизация.Добавить(ТипЗнч(СобственнаяОрганизацияЗначениеПоУмолчанию));
	Элементы.Организация.ОграничениеТипа = Новый ОписаниеТипов(МассивТиповСобственнаяОрганизация);
	
	МассивТиповСобственныйТорговыйОбъект = Новый Массив;
	МассивТиповСобственныйТорговыйОбъект.Добавить(ТипЗнч(СобственныйТорговыйОбъектЗначениеПоУмолчанию));
	Элементы.ТорговыйОбъект.ОграничениеТипа = Новый ОписаниеТипов(МассивТиповСобственныйТорговыйОбъект);
	
	МассивТиповСторонняяОрганизация = Новый Массив;
	МассивТиповСторонняяОрганизация.Добавить(ТипЗнч(СторонняяОрганизацияЗначениеПоУмолчанию));
	Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов(МассивТиповСторонняяОрганизация);
	
	МассивТиповСтороннийТорговыйОбъект = Новый Массив;
	МассивТиповСтороннийТорговыйОбъект.Добавить(ТипЗнч(СтороннийТорговыйОбъектЗначениеПоУмолчанию));
	Элементы.СтороннийТорговыйОбъект.ОграничениеТипа = Новый ОписаниеТипов(МассивТиповСтороннийТорговыйОбъект);
	
	Если СтороннийТорговыйОбъектЗначениеПоУмолчанию = Неопределено Тогда
		Элементы.СтороннийТорговыйОбъект.Видимость = Ложь;
	Иначе
		Элементы.СтороннийТорговыйОбъект.Видимость = ИнтеграцияЕГАИСПереопределяемый.ИспользоватьТорговыеОбъектыКонтрагентов();
	КонецЕсли;
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	ИнициализироватьПоляКонтактнойИнформации();
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	ЕстьПравоСозданияКонтрагента = ИнтеграцияЕГАИСПереопределяемый.ЕстьПравоСозданияКонтрагента();
	
	СоответствуетОрганизацииПриИзмененииСервер();
	
	ЗаполнитьДанныеСопоставления();
	
	ОбновитьИнформациюОВыгруженномФорматеОбмена();
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция АдресВФорматеКЛАДР(Данные)
	
	АдресВФорматеКЛАДР = РаботаСАдресами.СведенияОбАдресе(Данные);
	
	Возврат АдресВФорматеКЛАДР;
	
КонецФункции

#Область СопоставлениеПартнеров

&НаСервере
Функция СопоставитьПоИННКППСервер()
	
	Если Объект.СоответствуетОрганизации Тогда
		
		НайденнаяОрганизация = ИнтеграцияЕГАИСПереопределяемый.ОрганизацияПоИННКПП(Объект.ИНН, Объект.КПП);
		Если ЗначениеЗаполнено(НайденнаяОрганизация) Тогда
			Объект.Контрагент = НайденнаяОрганизация;
		КонецЕсли;
		
		ПриИзмененииРеквизитаСопоставленияНаСервере();
		
		Возврат Истина;
		
	Иначе
		
		СтруктураКонтрагентТорговыйОбъект = ИнтеграцияЕГАИСПереопределяемый.КонтрагентТорговыйОбъектПоИННКПП(Объект.ИНН, Объект.КПП);
		Если ЗначениеЗаполнено(СтруктураКонтрагентТорговыйОбъект) Тогда
			
			Объект.Контрагент     = СтруктураКонтрагентТорговыйОбъект.Контрагент;
			Объект.ТорговыйОбъект = СтруктураКонтрагентТорговыйОбъект.ТорговыйОбъект;
			
			ПриИзмененииРеквизитаСопоставленияНаСервере();
			
			Возврат Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура ПодтвердитьСоздатьНовогоКонтрагента(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		СоздатьНовогоКонтрагента();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовогоКонтрагента()
	
	ПараметрыСозданияКонтрагента = СобытияФормЕГАИСКлиентПереопределяемый.ПараметрыСозданияКонтрагента();
	ДанныеКонтрагента = СобытияФормЕГАИСКлиентПереопределяемый.ПараметрыСозданияКонтрагента();
	Для Каждого КлючИЗначение Из ПараметрыСозданияКонтрагента Цикл
		ДанныеКонтрагента[КлючИЗначение.Ключ] = Объект[КлючИЗначение.Значение];
	КонецЦикла;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуСозданияКонтрагента(ЭтотОбъект, ДанныеКонтрагента);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореКонтрагента(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	Объект.Контрагент = ВыбранноеЗначение;
	
	КонтрагентПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореТорговогоОбъекта(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	Объект.ТорговыйОбъект = ВыбранноеЗначение;
	
	СтороннийТорговыйОбъектПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыгрузкиИнформацииОбИспользуемомФорматеОбмена(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьИнформациюОВыгруженномФорматеОбмена();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюОВыгруженномФорматеОбмена()
	
	ФорматОбмена = ИнтеграцияЕГАИСКлиентСервер.ФорматОбмена(Объект.ФорматОбмена);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЕГАИСПрисоединенныеФайлы.ФорматОбмена КАК ФорматОбмена,
	|	ЕГАИСПрисоединенныеФайлы.ДатаМодификацииУниверсальная КАК ДатаМодификацииУниверсальная
	|ИЗ
	|	Справочник.ЕГАИСПрисоединенныеФайлы КАК ЕГАИСПрисоединенныеФайлы
	|ГДЕ
	|	ЕГАИСПрисоединенныеФайлы.Операция = &Операция
	|	И ЕГАИСПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЕГАИСПрисоединенныеФайлы.ДатаМодификацииУниверсальная УБЫВ");
	
	Запрос.УстановитьПараметр("Операция",      ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ИнформацияОФорматеОбмена"));
	Запрос.УстановитьПараметр("ВладелецФайла", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ДатаИзменения = Формат(
			Выборка.ДатаМодификацииУниверсальная, "ДЛФ=DD");
			
		Если Выборка.ФорматОбмена <> ФорматОбмена Тогда
			ЦветТекста = ЦветаСтиля.ЕГАИССтатусОбработкиОшибкаПередачи;
			ТекстСообщения = НСтр("ru = 'Требуется выгрузка'");
		Иначе
			ЦветТекста = Новый Цвет;
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Выгружено %1'"),
				ДатаИзменения)
		КонецЕсли;
		
		ИнформацияОВыгруженномФорматеОбмена = Новый ФорматированнаяСтрока(
			ТекстСообщения,,
			ЦветТекста);
		
	Иначе
		
		ИнформацияОВыгруженномФорматеОбмена = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Нет данных о выгрузке'"),,
			ЦветаСтиля.ЕГАИССтатусОбработкиОшибкаПередачи);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
