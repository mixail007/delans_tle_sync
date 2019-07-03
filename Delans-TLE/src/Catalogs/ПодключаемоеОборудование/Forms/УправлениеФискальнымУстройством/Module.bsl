
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОперацияЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Доступность = Истина;
	
	ТекстСообщения = ?(РезультатВыполнения.Результат, НСтр("ru='Операция успешно завершена.'"), РезультатВыполнения.ОписаниеОшибки);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСмену(Команда)
	
	ОчиститьСообщения();
	
	ПоддерживаемыеТипыВО = Новый Массив();
	ПоддерживаемыеТипыВО.Добавить("ФискальныйРегистратор");
	ПоддерживаемыеТипыВО.Добавить("ПринтерЧеков");
	ПоддерживаемыеТипыВО.Добавить("ККТ");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьСменуПослеВыбораУстройства", ЭтотОбъект);
	МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(ОписаниеОповещения, ПоддерживаемыеТипыВО,
		НСтр("ru='Выберите фискальное устройство'"), 
		НСтр("ru='Фискальное устройство не подключено.'"), 
		НСтр("ru='Фискальное устройство не выбрано.'"), 
		Истина);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ОткрытьСменуПослеВыбораУстройства(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	Доступность = Ложь;
	
	ПараметрыОперации = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперации();
	Кассир = "";
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияКлиентСерверПереопределяемый.ОбработкаЗаполненияИмяКассира(Кассир, СтандартнаяОбработка); 
	ПараметрыОперации.Кассир = ?(Не СтандартнаяОбработка, Кассир, НСтр("ru='Администратор'")); 
	
	ДополнительныеПараметры = Новый Структура();
	Если МенеджерОборудованияКлиентПовтИсп.ИспользуетсяПодсистемыФискальныхУстройств() Тогда
		МодульКассовыеСменыКлиентПереопределяемый = МенеджерОборудованияКлиентПовтИсп.ОбщийМодуль("КассовыеСменыКлиентПереопределяемый");
		МодульКассовыеСменыКлиентПереопределяемый.УправлениеФУЗаполнитьДополнительныеПараметрыПередОткрытиемСмены(РезультатВыбора, ДополнительныеПараметры);
	КонецЕсли;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОперацияЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьОткрытиеСменыНаФискальномУстройстве(ОповещениеПриЗавершении, УникальныйИдентификатор, ПараметрыОперации, РезультатВыбора,, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСмену(Команда)
	
	ОчиститьСообщения();
	
	ПоддерживаемыеТипыВО = Новый Массив();
	ПоддерживаемыеТипыВО.Добавить("ФискальныйРегистратор");
	ПоддерживаемыеТипыВО.Добавить("ПринтерЧеков");
	ПоддерживаемыеТипыВО.Добавить("ККТ");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗакрытьСменуПослеВыбораУстройства", ЭтотОбъект);
	МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(ОписаниеОповещения, ПоддерживаемыеТипыВО,
		НСтр("ru='Выберите фискальное устройство'"), 
		НСтр("ru='Фискальное устройство не подключено.'"), 
		НСтр("ru='Фискальное устройство не выбрано.'"), 
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСменуПослеВыбораУстройства(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Доступность = Ложь;
	
	ПараметрыОперации = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперации();
	Кассир = "";
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияКлиентСерверПереопределяемый.ОбработкаЗаполненияИмяКассира(Кассир, СтандартнаяОбработка); 
	ПараметрыОперации.Кассир = ?(Не СтандартнаяОбработка, Кассир, НСтр("ru='Администратор'")); 
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОперацияЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьЗакрытиеСменыНаФискальномУстройстве(ОповещениеПриЗавершении, УникальныйИдентификатор, ПараметрыОперации, РезультатВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетОТекущемСостоянииРасчетов(Команда)
	
	ОчиститьСообщения();
	Доступность = Ложь;
	
	ПараметрыОперации = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперации();
	Кассир = "";
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияКлиентСерверПереопределяемый.ОбработкаЗаполненияИмяКассира(Кассир, СтандартнаяОбработка); 
	ПараметрыОперации.Кассир = ?(Не СтандартнаяОбработка, Кассир, НСтр("ru='Администратор'")); 
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОперацияЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьФормированиеОтчетаОТекущемСостоянииРасчетов(ОповещениеПриЗавершении, УникальныйИдентификатор, ПараметрыОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетБезГашения(Команда)
	
	ОчиститьСообщения();
	Доступность = Ложь;
	
	ПараметрыОперации = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперации();
	Кассир = "";
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияКлиентСерверПереопределяемый.ОбработкаЗаполненияИмяКассира(Кассир, СтандартнаяОбработка); 
	ПараметрыОперации.Кассир = ?(Не СтандартнаяОбработка, Кассир, НСтр("ru='Администратор'")); 
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОперацияЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьФормированиеОтчетаБезГашения(ОповещениеПриЗавершении, УникальныйИдентификатор, ПараметрыОперации);
	
КонецПроцедуры

#КонецОбласти

