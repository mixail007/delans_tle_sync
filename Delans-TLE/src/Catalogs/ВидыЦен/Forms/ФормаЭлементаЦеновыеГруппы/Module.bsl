
#Область СлужебныеОбработчики

&НаКлиенте
Процедура ЗаполнитьСтрокуСтандартнымЗначением(НоваяСтрока)
	
	Если НоваяСтрока = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ПустаяСтрока(НоваяСтрока.Формула) Тогда
		
		НоваяСтрока.Формула = ?(ЭтоРасчетПоФормуле, Объект.Формула,	Неопределено);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(НоваяСтрока.БазовыйВидЦен) Тогда
		
		НоваяСтрока.БазовыйВидЦен = ?(ЭтоРасчетПоФормуле, Неопределено,	Объект.БазовыйВидЦен);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(НоваяСтрока.Процент) Тогда
		
		НоваяСтрока.Процент = ?(ЭтоРасчетПоФормуле, Неопределено,	Объект.Процент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтрокиИдентичнойФормулой()
	
	МассивУдаляемыхСтрок = Новый Массив;
	
	Для каждого СтрокаТаблицы Из Объект.ЦеновыеГруппы Цикл
		
		Если ПустаяСтрока(СтрокаТаблицы.Формула)
			ИЛИ СокрЛП(ВРЕГ(Объект.Формула)) = СокрЛП(ВРЕГ(СтрокаТаблицы.Формула)) Тогда
			
			МассивУдаляемыхСтрок.Добавить(СтрокаТаблицы);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для каждого УдаляемаяСтрока Из МассивУдаляемыхСтрок Цикл
		
		Объект.ЦеновыеГруппы.Удалить(УдаляемаяСтрока);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
// Процедура открывает конструктор формулы
//
Процедура ОткрытьКонструкторФормулы(ТекущаяФормула)
	
	ПараметрыФормулы = Новый Структура("Ссылка, Формула", Объект.Ссылка, ТекущаяФормула);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КонструкторФормулЗавершение", ЭтотОбъект);
	ОткрытьФорму("Справочник.ВидыЦен.Форма.КонструкторФормул", ПараметрыФормулы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры // ОткрытьКонструкторФормулы()

&НаКлиенте
Процедура КонструкторФормулЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") 
		И Результат.Результат = КодВозвратаДиалога.Да Тогда
		
		ТекущиеДанныеСтроки = Элементы.ЦеновыеГруппы.ТекущиеДанные;
		Если ТекущиеДанныеСтроки = Неопределено Тогда
			
			Возврат;
			
		КонецЕсли;
		
		Модифицированность = Истина;
		Результат.Свойство("Формула", ТекущиеДанныеСтроки.Формула);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыбратьЦеновыеГруппы()
	
	Запрос = Новый Запрос("Выбрать Справочник.ЦеновыеГруппы.Ссылка Где НЕ Справочник.ЦеновыеГруппы.ПометкаУдаления");
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат ?(РезультатЗапроса.Пустой(), Новый Массив, РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецФункции

&НаСервере
Процедура ПроверитьПустыеЦеновыеГруппы(Ошибки)
	
	Если Объект.ЦеновыеГруппы.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТаблицаЦеновыхГрупп = Новый ТаблицаЗначений;
	ТаблицаЦеновыхГрупп.Колонки.Добавить("НомерСтроки",		Новый ОписаниеТипов("Число"));
	ТаблицаЦеновыхГрупп.Колонки.Добавить("ЦеноваяГруппа",	Новый ОписаниеТипов("СправочникСсылка.ЦеновыеГруппы"));
	
	Для Каждого СтрокаТЧ Из Объект.ЦеновыеГруппы Цикл
		
		ЗаполнитьЗначенияСвойств(ТаблицаЦеновыхГрупп.Добавить(), СтрокаТЧ);
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаЦеновыхГрупп", ТаблицаЦеновыхГрупп);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВременнаяТаблицаЦеновыеГруппы.НомерСтроки КАК НомерСтроки,
	|	ВременнаяТаблицаЦеновыеГруппы.ЦеноваяГруппа КАК ЦеноваяГруппа
	|ПОМЕСТИТЬ ВременнаяТаблицаЦеновыеГруппы
	|ИЗ
	|	&ТаблицаЦеновыхГрупп КАК ВременнаяТаблицаЦеновыеГруппы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаЦеновыеГруппы.НомерСтроки КАК НомерСтроки,
	|	ВременнаяТаблицаЦеновыеГруппы.ЦеноваяГруппа КАК ЦеноваяГруппа
	|ИЗ
	|	ВременнаяТаблицаЦеновыеГруппы КАК ВременнаяТаблицаЦеновыеГруппы
	|ГДЕ
	|	ВременнаяТаблицаЦеновыеГруппы.ЦеноваяГруппа = ЗНАЧЕНИЕ(Справочник.ЦеновыеГруппы.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекстОшибки = НСтр("ru='Необходимо заполнить ценовую группу в строке %1'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, Выборка.НомерСтроки);
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.ЦеновыеГруппы[%1].ЦеноваяГруппа", ТекстОшибки, "", Выборка.НомерСтроки - 1);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполнения(Ошибки, Отказ)
	
	Справочники.ВидыЦен.ПроверитьДублированиеЦеновыхГрупп(Ошибки, Объект.ЦеновыеГруппы.Выгрузить());
	ПроверитьПустыеЦеновыеГруппы(Ошибки);
	
	Если Ошибки <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ТипВидаЦен",		Объект.ТипВидаЦен);
	Параметры.Свойство("БазовыйВидЦен",		Объект.БазовыйВидЦен);
	Параметры.Свойство("Процент",			Объект.Процент);
	Параметры.Свойство("Формула",			Объект.Формула);
	Параметры.Свойство("Наименование",		Объект.Наименование);
	
	Объект.ЦеновыеГруппы.Загрузить(Параметры.ЦеновыеГруппы.Выгрузить());
	
	ЭтоРасчетПоФормуле = (Объект.ТипВидаЦен = Перечисления.ТипыВидовЦен.ДинамическийФормула);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Формула",						"Видимость", ЭтоРасчетПоФормуле);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЦеновыеГруппыФормула",			"Видимость", ЭтоРасчетПоФормуле);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "БазовыйВидЦен",					"Видимость", НЕ ЭтоРасчетПоФормуле);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Процент",						"Видимость", НЕ ЭтоРасчетПоФормуле);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЦеновыеГруппыБазовыйВидЦены",	"Видимость", НЕ ЭтоРасчетПоФормуле);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЦеновыеГруппыНаценка",			"Видимость", НЕ ЭтоРасчетПоФормуле);
	
	Заголовок = НСтр("ru ='Вид цен: '") + ?(ПустаяСтрока(Объект.Наименование), НСтр("ru ='<наименование не заполнено>'"), Объект.Наименование);
	
	РазрешеноИзменениеСправочника = УправлениеДоступом.ИзменениеРазрешено(Справочники.ВидыЦен.ПустаяСсылка());
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЦеновыеГруппыЗаполнить",		"Доступность", РазрешеноИзменениеСправочника);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЭтоРасчетПоФормуле Тогда
		
		УдалитьСтрокиИдентичнойФормулой();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ЗаписатьУточненияПоЦеновымГруппам(Команда)
	Перем ПараметрыЗакрытия, Ошибки;
	
	Отказ = Ложь;
	ОбработкаПроверкиЗаполнения(Ошибки, Отказ);
	
	Если Отказ = Ложь Тогда
		
		Если Модифицированность Тогда
			
			ПараметрыЗакрытия = Новый Структура;
			ПараметрыЗакрытия.Вставить("ЦеновыеГруппы", Объект.ЦеновыеГруппы);
			
		КонецЕсли;
		
		Закрыть(ПараметрыЗакрытия);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Объект.ЦеновыеГруппы.Очистить();
	
	МассивЦеновыхГрупп = ВыбратьЦеновыеГруппы();
	Для каждого ЭлементМассива Из МассивЦеновыхГрупп Цикл
		
		НоваяСтрока = Объект.ЦеновыеГруппы.Добавить();
		НоваяСтрока.ЦеноваяГруппа = ЭлементМассива;
		
		ЗаполнитьСтрокуСтандартнымЗначением(НоваяСтрока);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура ЦеновыеГруппыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	НоваяСтрока = Элементы.ЦеновыеГруппы.ТекущиеДанные;
	ЗаполнитьСтрокуСтандартнымЗначением(НоваяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦеновыеГруппыФормулаОткрытие(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанныеСтроки = Элементы.ЦеновыеГруппы.ТекущиеДанные;
	Если ТекущиеДанныеСтроки = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяФормула = ?(ПустаяСтрока(ТекущиеДанныеСтроки.Формула), Объект.Формула, ТекущиеДанныеСтроки.Формула);
	ОткрытьКонструкторФормулы(ТекущаяФормула);
	
КонецПроцедуры

#КонецОбласти
