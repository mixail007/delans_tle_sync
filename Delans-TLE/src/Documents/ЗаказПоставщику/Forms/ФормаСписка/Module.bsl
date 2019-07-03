
#Область ПеременныеФормы

&НаКлиенте
Перем ДанныеВыбораСостояния;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеОтмененногоЗаказа(
		Список.КомпоновщикНастроек.Настройки.УсловноеОформление
	);
	
	УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ОтборОплата.СписокВыбора.Добавить("Без оплаты", "Без оплаты");
	Элементы.ОтборОплата.СписокВыбора.Добавить("Оплачен частично", "Оплачен частично");
	Элементы.ОтборОплата.СписокВыбора.Добавить("Оплачен полностью", "Оплачен полностью");
	
	Элементы.ОтборОтгрузка.СписокВыбора.Добавить("Без отгрузки", "Без отгрузки");
	Элементы.ОтборОтгрузка.СписокВыбора.Добавить("Отгружен частично", "Отгружен частично");
	Элементы.ОтборОтгрузка.СписокВыбора.Добавить("Отгружен полностью", "Отгружен полностью");
	
	СостоянияЗаказов.ЗаполнитьСписокВыбораЗавершенияЗаказа(Элементы.ОтборЗавершениеЗаказа.СписокВыбора);
	ЭтотОбъект.ТребуетсяОбновитьДанныеВыбораСостояния = Истина;
	
	// Актуальная дата сеанса.
	Список.Параметры.УстановитьЗначениеПараметра("АкутальнаяДатаСеанса", НачалоДня(ТекущаяДатаСеанса()));
	
	УстановитьОтборТекущиеДела();
	КонтекстноеОткрытие = Параметры.Свойство("ТекущиеДела");
	
	Если Не КонтекстноеОткрытие Тогда
		//УНФ.ОтборыСписка
		РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
		//Конец УНФ.ОтборыСписка
	КонецЕсли;
	
	ОбновитьКомандыИзмененияСостояний();
	
	// Установим формат для текущей даты: ДФ=Ч:мм
	УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(Список);
	УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(СписокЗаказыПокупателей);
	
	// ИнтернетПоддержкаПользователей.Новости
	ОбработкаНовостей.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтотОбъект,
		"УНФ.Документ.ЗаказПоставщику",
		"ФормаСписка",
		Неопределено,
		НСтр("ru='Новости: Заказы поставщикам'"),
		Ложь,
		Новый Структура("ПолучатьНовостиНаСервере, ХранитьМассивНовостейТолькоНаСервере", Истина, Истина),
		"ПриОткрытии"
	);
	// Конец ИнтернетПоддержкаПользователей.Новости
	
	// ЭДО
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ГруппаКомандыЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(ПараметрыПриСозданииНаСервере);
	// Конец ЭДО
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	УправлениеНебольшойФирмойСервер.УстановитьОтображаниеПодменюПечати(Элементы.ПодменюПечать);
	
	// УНФ.ПанельКонтактнойИнформации
	КонтактнаяИнформацияПанельУНФ.ПриСозданииНаСервере(ЭтотОбъект, "КонтактнаяИнформация", "СписокКонтекстноеМеню");
	// Конец УНФ.ПанельКонтактнойИнформации
	
	// МобильныйКлиент
	РаботаСОтборами.УстановитьЗаголовокПравойПанелиМобильныйКлиент(ЭтотОбъект,,, "ОтборКонтрагент,ОтборСостояние,ОтборЗавершениеЗаказа,ОтборОплата,ОтборОтгрузка,ОтборОтветственный,ОтборОрганизация");
	// Конец МобильныйКлиент	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.Новости
	
	// ЭДО
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭДО
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не КонтекстноеОткрытие И НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ЗаказПоставщику" Тогда
		Элементы.СписокЗаказыПокупателей.Обновить();
	КонецЕсли;
	
	Если ИмяСобытия = "ОповещениеОбОплатеЗаказа"
	 ИЛИ ИмяСобытия = "ОповещениеОбИзмененииДолга" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_СостоянияЗаказовПоставщикам" Тогда
		УстановитьУсловноеОформлениеИОбновитьКомандыИзмененияСостояний();
		ЭтотОбъект.ТребуетсяОбновитьДанныеВыбораСостояния = Истина;
	КонецЕсли;
	
	// ЭДО
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭДО
	
	// УНФ.ПанельКонтактнойИнформации
	Если КонтактнаяИнформацияПанельУНФКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьПанельКонтактнойИнформацииСервер();
	КонецЕсли;
	// Конец УНФ.ПанельКонтактнойИнформации
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	ЗаполнениеОбъектовУНФКлиент.ПоказатьВыборШаблонаДляСозданияДокументаИзСписка(
	"Документ.ЗаказПоставщику",
	Список.КомпоновщикНастроек.Настройки.Отбор.Элементы,
	Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаказПоставщику(Команда)

	МассивЗаказов = Элементы.СписокЗаказыПокупателей.ВыделенныеСтроки;
	
	Если МассивЗаказов.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = ПроверитьКлючевыеРеквизитыЗаказов(МассивЗаказов);
	Если СтруктураДанных.СформироватьНесколькоЗаказов Тогда
		
		ТекстСообщения = НСтр("ru = 'Заказы отличаются данными (%ПредставлениеДанных%) шапки документов! Сформировать несколько заказов поставщику?'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредставлениеДанных%", СтруктураДанных.ПредставлениеДанных);
		Ответ = Неопределено;
		
		ПоказатьВопрос(Новый ОписаниеОповещения("СоздатьЗаказПоставщикуЗавершение", ЭтотОбъект, Новый Структура("МассивЗаказов", МассивЗаказов)), ТекстСообщения, РежимДиалогаВопрос.ДаНет, 0);
		
	Иначе
		
		СтруктураЗаполнения = Новый Структура();
		СтруктураЗаполнения.Вставить("МассивЗаказовПокупателей", МассивЗаказов);
		ОткрытьФорму("Документ.ЗаказПоставщику.ФормаОбъекта", Новый Структура("Основание", СтруктураЗаполнения));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаказПоставщикуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	МассивЗаказов = ДополнительныеПараметры.МассивЗаказов;
	
	Ответ = Результат;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		МассивЗаказовПоставщику = СформироватьЗаказыПоставщикуИЗаписать(МассивЗаказов);
		Текст = НСтр("ru='Создание:'");
		Для каждого СтрокаЗаказПоставщику Из МассивЗаказовПоставщику Цикл
			
			ПоказатьОповещениеПользователя(Текст, ПолучитьНавигационнуюСсылку(СтрокаЗаказПоставщику), СтрокаЗаказПоставщику, БиблиотекаКартинок.Информация32);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если ТипЗнч(Элемент.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		
		КонтрагентАктивнойСтроки = ?(Элемент.ТекущиеДанные = Неопределено, Неопределено, Элемент.ТекущиеДанные.Контрагент);
		Если КонтрагентАктивнойСтроки <> ТекущийКонтрагент Тогда
		
			ТекущийКонтрагент = КонтрагентАктивнойСтроки;
			ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиСписка", 0.2, Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Контрагент", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура ОтборОперацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("ВидОперации", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СостояниеЗаказа", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЭтотОбъект.ТребуетсяОбновитьДанныеВыбораСостояния Тогда
		ДанныеВыбораСостояния = ПолучитьДанныеВыбора(Тип("СправочникСсылка.СостоянияЗаказовПоставщикам"), ПараметрыПолученияДанных);
		ЭтотОбъект.ТребуетсяОбновитьДанныеВыбораСостояния = Ложь;
	КонецЕсли;
	
	ДанныеВыбора = ДанныеВыбораСостояния;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборЗавершениеЗаказаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка(
		"ВариантЗавершения",
		Элемент.Родитель.Имя,
		ПредопределенноеЗначение("Перечисление.ВариантыЗавершенияЗаказа." + ВыбранноеЗначение),
		Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение).Представление
	);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОплатаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СтатусОплаты", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтгрузкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	Если ВыбранноеЗначение = "Отгружен полностью" Тогда
		СтатусОтгрузки = 0;
	ИначеЕсли ВыбранноеЗначение = "Отгружен частично" Тогда
		СтатусОтгрузки = 1;
	ИначеЕсли ВыбранноеЗначение = "Без отгрузки" Тогда
		СтатусОтгрузки = 2;
	Иначе
		возврат;
	КонецЕсли;	
	
	УстановитьМеткуИОтборСписка("СтатусОтгрузки", Элемент.Родитель.Имя, СтатусОтгрузки, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;

	УстановитьМеткуИОтборСписка("Ответственный", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиСписка()
	
	ОбновитьПанельКонтактнойИнформацииСервер();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборТекущиеДела()
	
	Если НЕ Параметры.Свойство("ТекущиеДела") Тогда
		Возврат;
	КонецЕсли;
	
	АвтоЗаголовок = Ложь;
	Заголовок = НСтр("ru='Заказы поставщикам'");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Проведен", Истина);
	
	УстановитьМеткуИОтборСписка(
		"ВариантЗавершения",
		Элементы.ОтборЗавершениеЗаказа.Родитель.Имя,
		ПредопределенноеЗначение("Перечисление.ВариантыЗавершенияЗаказа.ПустаяСсылка"), // В текущих делах все заказы Не завершенные
		Элементы.ОтборЗавершениеЗаказа.СписокВыбора.НайтиПоЗначению("ПустаяСсылка").Представление
	);
	
	РаботаСОтборами.ПрикрепитьМеткиОтбораИзМассива(ЭтотОбъект, "Ответственный", "ГруппаОтборОтветственный", УправлениеНебольшойФирмойСервер.ПолучитьСотрудниковПользователя());
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, "Ответственный");
	
	Если Параметры.Свойство("ПросроченоВыполнение") Тогда
		
		Заголовок = Заголовок + ": " + НСтр("ru='просрочено выполнение'");
		Список.УстановитьОбязательноеИспользование("ПросроченоВыполнение", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПросроченоВыполнение", Истина);
		
	ИначеЕсли Параметры.Свойство("ПросроченаОплата") Тогда
		
		Заголовок = Заголовок + ": " + НСтр("ru='просрочена оплата'");
		Список.УстановитьОбязательноеИспользование("ПросроченаОплата", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПросроченаОплата", Истина);
		
	ИначеЕсли Параметры.Свойство("НаСегодня") Тогда
		
		Заголовок = Заголовок + ": " + НСтр("ru='на сегодня'");
		Список.УстановитьОбязательноеИспользование("НаСегодня", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "НаСегодня", Истина);
		
	ИначеЕсли Параметры.Свойство("ВРаботе") Тогда
		
		Заголовок = Заголовок + ": " + НСтр("ru='в работе'");
		
	КонецЕсли;
	
	ПредставлениеПериода = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(ОтборПериод);
	РаботаСОтборами.ОбновитьЭлементыМеток(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеПоЦветамСостоянийСервер()
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеПоЦветамСостояний(
		Список.КомпоновщикНастроек.Настройки.УсловноеОформление,
		Метаданные.Справочники.СостоянияЗаказовПоставщикам.ПолноеИмя()
	);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеИОбновитьКомандыИзмененияСостояний()
	
	УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	ОбновитьКомандыИзмененияСостояний();
	
КонецПроцедуры

// Функция проверяет отличие ключевых реквизитов.
//
&НаСервере
Функция ПроверитьКлючевыеРеквизитыЗаказов(МассивЗаказов)
	
	СтруктураДанных = Новый Структура();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Организация) КАК КоличествоОрганизация
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ЗаказПокупателяШапка
	|ГДЕ
	|	ЗаказПокупателяШапка.Ссылка В(&МассивЗаказов)
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Организация) > 1";
	
	Запрос.УстановитьПараметр("МассивЗаказов", МассивЗаказов);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		СтруктураДанных.Вставить("СформироватьНесколькоЗаказов", Ложь);
		СтруктураДанных.Вставить("ПредставлениеДанных", "");
	Иначе
		СтруктураДанных.Вставить("СформироватьНесколькоЗаказов", Истина);
		ПредставлениеДанных = "";
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.КоличествоОрганизация > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "", ", ") + "Организация";
			КонецЕсли;
			
		КонецЦикла;
		
		СтруктураДанных.Вставить("ПредставлениеДанных", ПредставлениеДанных);
		
	КонецЕсли;
	
	Возврат СтруктураДанных;
	
КонецФункции

// Функция вызывает обработку заполнения документа по основанию.
//
&НаСервере
Функция СформироватьЗаказыПоставщикуИЗаписать(МассивЗаказов)
	
	МассивЗНП = Новый Массив();
	Для каждого СтрокаЗаказПокупателя Из МассивЗаказов Цикл
		
		НовыйДокументЗНП = Документы.ЗаказПоставщику.СоздатьДокумент();
		НовыйДокументЗНП.Дата = ТекущаяДата();
		НовыйДокументЗНП.Заполнить(СтрокаЗаказПокупателя);
		НовыйДокументЗНП.Записать();
		МассивЗНП.Добавить(НовыйДокументЗНП.Ссылка);
		
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
	Возврат МассивЗНП;
	
КонецФункции

#КонецОбласти

#Область ЗамерыПроизводительности

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "СозданиеФормы" + РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ОткрытиеФормы" + РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	
КонецПроцедуры

#КонецОбласти

#Область МеткиОтборов

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_")+1);
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
		
КонецПроцедуры

#КонецОбласти

#Область ПанельКонтактнойИнформации

// УНФ.ПанельКонтактнойИнформации
&НаСервере
Процедура ОбновитьПанельКонтактнойИнформацииСервер()
	
	КонтактнаяИнформацияПанельУНФ.ОбновитьДанныеПанели(ЭтотОбъект, ТекущийКонтрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииВыбор(ЭтотОбъект, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(Элемент)
	
	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыполнитьКоманду(Команда)
	
	КонтактнаяИнформацияПанельУНФКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, ТекущийКонтрагент);
	
КонецПроцедуры
// Конец УНФ.ПанельКонтактнойИнформации

#КонецОбласти

#Область ИзменениеСостоянийЗаказов

&НаСервере
Процедура ОбновитьКомандыИзмененияСостояний()
	
	УдаляемыеЭлементы = Новый Массив;
	УдаляемыеКоманды = Новый Массив;
	
	Если Элементы.СписокКонтекстноеМенюУстановитьСостояние.ПодчиненныеЭлементы.Количество()<> 0 Тогда
		Для ИндексГруппы = 0 По Элементы.СписокКонтекстноеМенюУстановитьСостояние.ПодчиненныеЭлементы.Количество() - 1 Цикл
			
			Если Элементы.СписокКонтекстноеМенюУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы].Имя = "УстановитьСостояниеЗавершен"
				ИЛИ Элементы.СписокКонтекстноеМенюУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы].Имя = "УстановитьСостояниеЗавершенУспешно"
				ИЛИ Элементы.СписокКонтекстноеМенюУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы].Имя = "УстановитьСостояниеОтменен" Тогда
				Продолжить;
			КонецЕсли;
			УдаляемыеЭлементы.Добавить(Элементы.СписокКонтекстноеМенюУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы]);
			
		КонецЦикла;
		
		Если Элементы.ФормаУстановитьСостояние.ПодчиненныеЭлементы.Количество() <> 0 Тогда
			Для ИндексГруппы = 0 По Элементы.ФормаУстановитьСостояние.ПодчиненныеЭлементы.Количество() - 1 Цикл
				Если Элементы.ФормаУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы].Имя = "УстановитьСостояниеЗавершенФорма"
					ИЛИ Элементы.ФормаУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы].Имя = "УстановитьСостояниеЗавершенУспешноФорма"
					ИЛИ Элементы.ФормаУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы].Имя = "УстановитьСостояниеОтмененФорма" Тогда
					Продолжить;
				КонецЕсли;
				УдаляемыеЭлементы.Добавить(Элементы.ФормаУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы]);
			КонецЦикла;
		КонецЕсли;
		
		Для Каждого УдаляемыйЭлемент Из УдаляемыеЭлементы Цикл
			Элементы.Удалить(УдаляемыйЭлемент);
		КонецЦикла;
		
	КонецЕсли;
	
	СостоянияЗаказовПоставщикам.Очистить();
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияЗаказовПоставщикам.Ссылка КАК Ссылка,
	|	СостоянияЗаказовПоставщикам.Наименование КАК Наименование
	|ИЗ
	|	Справочник.СостоянияЗаказовПоставщикам КАК СостоянияЗаказовПоставщикам
	|ГДЕ
	|	СостоянияЗаказовПоставщикам.ПометкаУдаления = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	СостоянияЗаказовПоставщикам.РеквизитДопУпорядочивания";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	НомерСостояния = 1;
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Ссылка = Справочники.СостоянияЗаказовПоставщикам.Завершен Тогда
			Продолжить;
		КонецЕсли;
		
		СостояниеВТаблице = СостоянияЗаказовПоставщикам.НайтиСтроки(Новый Структура("Состояние", Выборка.Ссылка));
		
		Если СостояниеВТаблице.Количество() = 0 Тогда
			НовоеСостояние = СостоянияЗаказовПоставщикам.Добавить();
			НовоеСостояние.Состояние = Выборка.Ссылка;
		Иначе 
			НовоеСостояние = СостояниеВТаблице[0];
		КонецЕсли;
		
		КнопкаУстановитьСостояниеЗаказаФорма = Элементы.Добавить("Состояние_" + Строка(СостоянияЗаказовПоставщикам.Индекс(НовоеСостояние))+ "_Форма", Тип("КнопкаФормы"),Элементы.ФормаУстановитьСостояние);
		КнопкаУстановитьСостояниеЗаказаФорма.ТолькоВоВсехДействиях = Истина;
		КнопкаУстановитьСостояниеЗаказаФорма.Заголовок = Строка(НомерСостояния)+". "+ Строка(Выборка.Ссылка);
		
		КнопкаУстановитьСостояниеЗаказаСписок = Элементы.Добавить("Состояние_" + Строка(СостоянияЗаказовПоставщикам.Индекс(НовоеСостояние)), Тип("КнопкаФормы"),Элементы.СписокКонтекстноеМенюУстановитьСостояние);
		КнопкаУстановитьСостояниеЗаказаСписок.Заголовок = Строка(НомерСостояния)+". "+ Строка(Выборка.Ссылка);
		
		НазваниеКоманды = "Состояние_" + Строка(СостоянияЗаказовПоставщикам.Индекс(НовоеСостояние));
		Если Команды.Найти(НазваниеКоманды) <> Неопределено Тогда
			КомандаУстановитьСостояниеЗаказа = Команды[НазваниеКоманды];
		Иначе
			КомандаУстановитьСостояниеЗаказа = Команды.Добавить(НазваниеКоманды);
		КонецЕсли;
		
		КомандаУстановитьСостояниеЗаказа.Действие = "УстановитьСостояниеЗаказа";
		КомандаУстановитьСостояниеЗаказа.Заголовок = Строка(Выборка.Ссылка);
		
		КнопкаУстановитьСостояниеЗаказаСписок.ИмяКоманды = КомандаУстановитьСостояниеЗаказа.Имя;
		КнопкаУстановитьСостояниеЗаказаФорма.ИмяКоманды = КомандаУстановитьСостояниеЗаказа.Имя;

		НомерСостояния = НомерСостояния + 1;
	КонецЦикла;
	
	Элементы.Переместить(Элементы["УстановитьСостояниеЗавершен"],Элементы["СписокКонтекстноеМенюУстановитьСостояние"]);
	Элементы.Переместить(Элементы["УстановитьСостояниеЗавершенФорма"],Элементы["ФормаУстановитьСостояние"]);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСостояниеЗаказа(Команда)
	
	Заказы = Элементы.Список.ВыделенныеСтроки;
	
	Если Тип(Заказы) <> Тип("Массив") Или Заказы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКоманды = Команда.Имя;
		
	Если Заказы.Количество() = 1 Тогда
		УстановитьСостояниеЗаказаСервер(ИмяКоманды, Заказы);
		
		Если Заказы.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(НСтр("ru='Изменение:'"),
			ПолучитьНавигационнуюСсылку(Заказы[0]),
			СтрШаблон(НСтр("ru='%1'"),Строка(Заказы[0])),
			БиблиотекаКартинок.Информация32);
		Элементы.Список.Обновить();
		Оповестить("ИзменениеСостояния_ЗаказПоставщику",Заказы);
		Возврат;
	КонецЕсли;
	
	
	Состояние(НСтр("ru='Изменение состояния'"), 49);	
	УстановитьСостояниеЗаказаСервер(ИмяКоманды, Заказы);
	Состояние(НСтр("ru='Изменение состояния'"), 100);
	
	Элементы.Список.Обновить();
	Оповестить("ИзменениеСостояния_ЗаказПоставщику",Заказы);
	
	ПоказатьОповещениеПользователя(СтрШаблон(НСтр("ru='Изменение (%1)'"),
		КоличествоИзмененныхЗаказов),,
		НСтр("ru='Заказы поставщику'"),БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеЗаказаСервер(ИмяКоманды, Заказы, ВариантЗавершения = Неопределено)
	
	Если ИмяКоманды = "СостояниеЗавершенУспешно" Тогда
		СсылкаНаСостояние = Справочники.СостоянияЗаказовПоставщикам.Завершен;
		ВариантЗавершения = Перечисления.ВариантыЗавершенияЗаказа.Успешно;
	ИначеЕсли ИмяКоманды = "СостояниеОтменен" Тогда
		СсылкаНаСостояние =  Справочники.СостоянияЗаказовПоставщикам.Завершен;
		ВариантЗавершения = Перечисления.ВариантыЗавершенияЗаказа.Отменен;
	Иначе
		ИндексСостояния = Число(Сред(ИмяКоманды,11,СтрДлина(ИмяКоманды)));
		СсылкаНаСостояние = СостоянияЗаказовПоставщикам[ИндексСостояния].Состояние;
	КонецЕсли;
		
	КоличествоИзмененныхЗаказов = 0;
	НеизмененныеЗаказы = Новый Массив;
	
	Для Каждого Заказ Из Заказы Цикл
		
		Если Заказ.СостояниеЗаказа = СсылкаНаСостояние И СсылкаНаСостояние <> Справочники.СостоянияЗаказовПоставщикам.Завершен Тогда
			НеизмененныеЗаказы.Добавить(Заказ);
			Продолжить;
		КонецЕсли;
		
		Если Заказ.СостояниеЗаказа = СсылкаНаСостояние И СсылкаНаСостояние = Справочники.СостоянияЗаказовПоставщикам.Завершен
			И (ЗначениеЗаполнено(Заказ.ВариантЗавершения) И Заказ.ВариантЗавершения = ВариантЗавершения) Тогда
			НеизмененныеЗаказы.Добавить(Заказ);
			Продолжить;
		КонецЕсли;
		
		Попытка
			Документы.ЗаказПоставщику.ИзменитьСостояниеЗаказа(Заказ, СсылкаНаСостояние, ВариантЗавершения);
		Исключение
			
			ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), Заказ);
			НеизмененныеЗаказы.Добавить(Заказ);
			Продолжить;
			
		КонецПопытки;
		
		КоличествоИзмененныхЗаказов = КоличествоИзмененныхЗаказов + 1;
		
	КонецЦикла;
		
	Для Каждого НеизмененныйЗаказ Из НеизмененныеЗаказы Цикл
		ИндексЗаказа = Заказы.Найти(НеизмененныйЗаказ);
		Если ИндексЗаказа = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Заказы.Удалить(ИндексЗаказа);
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// ИнтернетПоддержкаПользователей.Новости
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, "ПриОткрытии");
	
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.Новости

// ЭДО
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры
// Конец ЭДО

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

#КонецОбласти
