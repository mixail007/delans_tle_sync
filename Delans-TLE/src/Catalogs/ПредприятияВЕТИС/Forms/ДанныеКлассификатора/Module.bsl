#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбработататьПереданныеПараметры(Отказ);
	УправлениеЭлементамиФормы();
	
	СобытияФормВЕТИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнформацияСостояниеЗагрузкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьПредприятие" Тогда
		
		ПоказатьЗначение(, Предприятие);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	ЗагрузитьПредприятие();
	
	Если ЗначениеЗаполнено(Предприятие) Тогда
		
		ТекстЗаголовка = НСтр("ru = 'Загрузка из классификатора'");
		
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Выполнена загрузка предприятия %1.'"), Предприятие);
		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
		
		ПараметрыЗаписи = Новый Структура;
		Оповестить(
			"Запись_ПредприятияВЕТИС",
			ПараметрыЗаписи,
			Предприятие);
		
		Закрыть(Предприятие);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗагрузитьПредприятие()
	
	Предприятие = ИнтеграцияВЕТИС.ЗагрузитьПредприятие(ДанныеПредприятия);
	
КонецФункции

&НаСервере
Процедура ОбработататьПереданныеПараметры(Отказ)

	Если Не ЗначениеЗаполнено(Параметры.Идентификатор) Тогда
		
		ВызватьИсключение НСтр("ru = 'Форма не предназначена для открытия без передачи в неё идентификатора хозяйствующего субъекта.'");
		Отказ = Истина;
		
	Иначе
		
		Идентификатор = Параметры.Идентификатор;
		НеПоказыватьСостояниеЗагрузки = Параметры.НеПоказыватьСостояниеЗагрузки;
		Результат = ЦерберВЕТИСВызовСервера.ПредприятиеПоGUID(Идентификатор);
		
		Если Не ПустаяСтрока(Результат.ТекстОшибки) Тогда
			
			ЕстьОшибка  = Истина;
			ТекстОшибки = ПредприятияХозяйствующиеСубъектыВЕТИС.ТекстОшибкиПолученияДанных(Результат.ТекстОшибки);
			Элементы.ФормаЗагрузить.Доступность = Ложь;
			
		Иначе
			
			ЕстьОшибка  = Ложь;
			ДанныеПредприятия = ИнтеграцияВЕТИС.ДанныеПредприятия(Результат.Элемент);
			ЗаполнитьДанныеПредприятия(ДанныеПредприятия);
			Элементы.ФормаЗагрузить.Доступность = Истина;
			ОпределитьНаличиеВИБ();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьНаличиеВИБ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ПредприятияВЕТИС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПредприятияВЕТИС КАК ПредприятияВЕТИС
	|ГДЕ
	|	ПредприятияВЕТИС.Идентификатор = &Идентификатор";
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Предприятие = Выборка.Ссылка;
		
		Строки = Новый Массив;
		Строки.Добавить(НСтр("ru = 'Предприятие уже загружено'"));
		Строки.Добавить(" (");
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'открыть'"),, ЦветаСтиля.ЦветГиперссылкиГИСМ,, "ОткрытьПредприятие"));
		Строки.Добавить(").");
		
		ИнформацияСостояниеЗагрузки = Новый ФорматированнаяСтрока(Строки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПредприятия(ДанныеПредприятия)

	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеПредприятия, , "ВидыДеятельности, НомераПредприятий");
	НомераПредприятийПредставление = СтрСоединить(ДанныеПредприятия.НомераПредприятий, "; ");
	ВидыДеятельностиПредставление  = СтрСоединить(ДанныеПредприятия.ВидыДеятельности, Символы.ПС);

КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Если ЕстьОшибка Тогда
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаОшибка;
		Элементы.ФормаОтмена.Видимость         = Ложь;
		Элементы.ФормаЗакрыть.Видимость        = Истина;
		Элементы.ФормаЗагрузить.Видимость      = Истина;
		
	Иначе

		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаДанныеКлассификатора;
		
		Если ЗначениеЗаполнено(Предприятие) Тогда
			
			Если НеПоказыватьСостояниеЗагрузки Тогда
				Элементы.ИнформацияСостояниеЗагрузки.Видимость = Ложь;
			КонецЕсли;
			
			Элементы.ФормаОтмена.Видимость    = Ложь;
			Элементы.ФормаЗакрыть.Видимость   = Истина;
			Элементы.ФормаЗагрузить.Видимость = Ложь;
			
		Иначе
			
			Элементы.ИнформацияСостояниеЗагрузки.Видимость = Ложь;
			
			Элементы.ФормаОтмена.Видимость    = Истина;
			Элементы.ФормаЗакрыть.Видимость   = Ложь;
			Элементы.ФормаЗагрузить.Видимость = Истина;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры


#КонецОбласти
