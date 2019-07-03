
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Параметры.ПараметрыФормы;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, ПараметрыФормы, "ПараметрыФормы");
	
	АдресТаблицыСравненияРеквизитов = Параметры.АдресТаблицыСравненияРеквизитов;
	ТаблицаЗначенийСравненияРеквизитов = ПолучитьИзВременногоХранилища(АдресТаблицыСравненияРеквизитов);
	ЗначениеВРеквизитФормы(ТаблицаЗначенийСравненияРеквизитов, "ТаблицаСравненияРеквизитов");
	
	Элементы.ТаблицаСравненияРеквизитов.ТекущаяСтрока = -1;
	
	ИзменитьОформлениеФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстПоясненияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КриптографияЭДКОКлиент.ПоказатьСертификат(СертификатДляПодписания);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы


&НаКлиенте
Процедура ЗаменитьЗначения(Команда)
	
	Если АвтоматическоеИсправлениеНевозможно Тогда
		Закрыть();
	Иначе
		Закрыть(НСтр("ru = 'Взять из сертификата'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВБумажномВиде(Команда)
	
	Закрыть(НСтр("ru = 'В бумажном виде'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЭлектронноеПодписаниеНевозможно()
	
	ЭлектронноеПодписаниеНевозможно = Ложь;
	
	Для каждого СтрокаТаблицы Из ТаблицаСравненияРеквизитов Цикл
		
		Если СтрокаТаблицы.Различается Тогда
			
			Если СтрокаТаблицы.Наименование = НСтр("ru = 'Страна'") Тогда
			
				ЭлектронноеПодписаниеНевозможно = Истина;
				Прервать;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЭлектронноеПодписаниеНевозможно;
	
КонецФункции

&НаСервере
Функция АвтоматическоеИсправлениеНевозможно()
	
	АвтоматическоеИсправлениеНевозможно = Ложь;
	
	Для каждого СтрокаТаблицы Из ТаблицаСравненияРеквизитов Цикл
		
		Если СтрокаТаблицы.Различается Тогда
			
			Если СтрокаТаблицы.Наименование = НСтр("ru = 'Регион'")
				ИЛИ СтрокаТаблицы.Наименование = НСтр("ru = 'Страна'") Тогда
			
				АвтоматическоеИсправлениеНевозможно = Истина;
				Прервать;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат АвтоматическоеИсправлениеНевозможно;
	
КонецФункции

&НаСервере
Процедура ИзменитьОформлениеФормы()
	
	ЭлектронноеПодписаниеНевозможно 	= ЭлектронноеПодписаниеНевозможно();
	АвтоматическоеИсправлениеНевозможно = АвтоматическоеИсправлениеНевозможно();
	
	Подстрока1 = НСтр("ru = 'Некоторые реквизиты сертификата '");
	Подстрока2 = Новый ФорматированнаяСтрока(ПредставлениеСертификата,,,,"Сертификат");
	Подстрока3 = НСтр("ru = ' отличаются от указанных в заявлении. '");
	
	Подстрока4 = НСтр("ru = 'Чтобы воспользоваться возможностью электронного подписания заявления в нем должны быть указаны такие же реквизиты, как и в сертификате.'");
	
	Если ЭлектронноеПодписаниеНевозможно Тогда
		
		// Бумажное подписание невозможно
		Элементы.ФормаЗаменитьЗначения.Видимость 	  = Ложь;
		Элементы.ФормаВБумажномВиде.КнопкаПоУмолчанию = Истина;
		
		Подстрока4 = НСтр("ru = 'В этом случае подписание электронной подписью недоступно, возможно оформление подключения только в бумажном виде (потребуется встреча с партнером).'");
		
	ИначеЕсли АвтоматическоеИсправлениеНевозможно Тогда
		
		// Нужно исправлять вручную
		Элементы.ФормаЗаменитьЗначения.Заголовок = НСтр("ru = 'Вернуться к заявлению для исправления'");
		
	КонецЕсли;
	
	Элементы.ТекстПояснения.Заголовок = Новый ФорматированнаяСтрока(
		Подстрока1,
		Подстрока2,
		Подстрока3,
		Подстрока4);

КонецПроцедуры

#КонецОбласти


