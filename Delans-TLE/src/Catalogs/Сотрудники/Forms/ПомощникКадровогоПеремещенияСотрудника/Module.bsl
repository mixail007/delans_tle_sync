
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Параметры.Сотрудник)
		И НЕ (Параметры.ПринятьНаРаботу
		ИЛИ Параметры.ИзменитьДолжность
		ИЛИ Параметры.ИзменитьОклад
		ИЛИ Параметры.ОформитьУвольнение) Тогда
		
		Отказ = Истина;
		Возврат;
	Иначе
		Организация = Параметры.Организация;
		Если Не Параметры.ПринятьНаРаботу И Не ЗначениеЗаполнено(Организация) Тогда
			Отказ = Истина;
			Возврат;
			
		КонецЕсли;
		
		Сотрудник = Параметры.Сотрудник;
		ПринятьНаРаботу 	= Параметры.ПринятьНаРаботу;
		ИзменитьДолжность 	= Параметры.ИзменитьДолжность;
		ИзменитьОклад 		= Параметры.ИзменитьОклад;
		ОформитьУвольнение 	= Параметры.ОформитьУвольнение;
	КонецЕсли;
	
	
	ПриемНаРаботуЗанимаемыхСтавок = 1;
	
	ИспользуютсяОрганизации = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Если ИспользуютсяОрганизации Тогда
		
		УчетПоОрганизации = Константы.УчетПоКомпании.Получить();
		Если УчетПоОрганизации Тогда
			
			Организация = Справочники.Организации.ОрганизацияКомпания();
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Организация", "Доступность", Ложь);
			
		КонецЕсли;
		
	Иначе
		
		Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Организация", "Доступность", Ложь);
		
	КонецЕсли;
	
	ИспользуютсяПодразделения = ПолучитьФункциональнуюОпцию("УчетПоНесколькимПодразделениям");
	Если НЕ ИспользуютсяПодразделения Тогда
		
		ПриемНаРаботуСтруктурнаяЕдиница = Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение;
		
	КонецЕсли;
	ПриемНаРаботуВалюта = Константы.НациональнаяВалюта.Получить();
	ИспользуютсяВалюты = ПолучитьФункциональнуюОпцию("УчетВалютныхОпераций");
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПриемНаРаботуВалюта", "Видимость", ИспользуютсяВалюты);
	
	ИспользуетсяШтатноеРасписание = ПолучитьФункциональнуюОпцию("ВестиШтатноеРасписание");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПриемНаРаботуЗанимаемыхСтавок", "Видимость", ИспользуетсяШтатноеРасписание);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПриемНаРаботуДобавитьСтавки", "Видимость", ИспользуетсяШтатноеРасписание);
	Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаПриемНаРаботу1;
	
	Если ПринятьНаРаботу Тогда
		ЭтаФорма.Заголовок = НСтр("ru='Прием на работу сотрудника '")+ Сотрудник;
		Элементы.ПанельОсновная.Видимость = Истина;
		Элементы.ГруппаУвольнение.Видимость = Ложь;
	ИначеЕсли ОформитьУвольнение Тогда
		Элементы.ПанельОсновная.Видимость = Ложь;
		Элементы.ГруппаУвольнение.Видимость = Истина;
		ЭтаФорма.Заголовок = НСтр("ru='Увольнение сотрудника '")+ Сотрудник;
	ИначеЕсли ИзменитьОклад Тогда
		Элементы.ПанельОсновная.Видимость = Истина;
		Элементы.ГруппаУвольнение.Видимость = Ложь;
		
		ЭтаФорма.Заголовок = НСтр("ru='Изменение заработной зарплаты сотрудника '")+ Сотрудник;
		Элементы.ДекорацияТри.Заголовок = НСтр("ru='Изменение оклада'");
		Элементы.ПриемНаРаботуДатаПриема.Заголовок = НСтр("ru='Дата изменения'");
		Элементы.ПриемНаРаботуОрганизация.ТолькоПросмотр = Истина;
		Элементы.ПриемНаРаботуДолжность.Видимость = Ложь;
		Элементы.ПриемНаРаботуСтруктурнаяЕдиница.Видимость = Ложь;
		Элементы.ГруппаСтавки.Видимость = Ложь;
		Элементы.ПриемНаРаботуГрафикРаботы.Видимость = Ложь;
	ИначеЕсли ИзменитьДолжность Тогда
		Элементы.ПанельОсновная.Видимость = Истина;
		Элементы.ГруппаУвольнение.Видимость = Ложь;
		
		ЭтаФорма.Заголовок = НСтр("ru='Кадровое перемещение сотрудника '")+ Сотрудник;
		Элементы.ДекорацияТри.Заголовок = НСтр("ru='Кадровое перемещение'");
		Элементы.ПриемНаРаботуДатаПриема.Заголовок = НСтр("ru='Дата перемещения'");
		Элементы.ПриемНаРаботуОрганизация.ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	Отказ = Ложь;
	ПриПереходеДалее(Отказ);
	Если Не Отказ Тогда
		Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаПриемНаРаботу2;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаПриемНаРаботу1;
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	Отказ = Ложь;
	СоздатьИтоговыйДокумент(Отказ);
	
	Если Не Отказ Тогда
		Оповестить("ИзменениеПоКадровомуУчету");
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьИтоговыйДокумент(Отказ)
	Перем Ошибки;
	
	Если ОформитьУвольнение Тогда
		Если Не ЗначениеЗаполнено(УвольнениеДатаУвольнения) Тогда
			ТекстСообщения = НСтр("ru ='Необходимо заполнить дату увольнения.'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "УвольнениеДатаУвольнения", ТекстСообщения, Неопределено);
			Отказ = Истина;
			
			ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
			
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	
	
	Попытка
		
		НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = Блокировка.Добавить("Справочник.Сотрудники");
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Разделяемый;
		
		Если ПринятьНаРаботу Тогда
			
			ЭлементБлокировкиДанных = Блокировка.Добавить("Документ.ПриемНаРаботу");
			ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Разделяемый;
			
		КонецЕсли;
		
		Если ИзменитьОклад ИЛИ ИзменитьДолжность Тогда
			
			ЭлементБлокировкиДанных = Блокировка.Добавить("Документ.КадровоеПеремещение");
			ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Разделяемый;
			
		КонецЕсли;
		
		Если ОформитьУвольнение Тогда
			
			ЭлементБлокировкиДанных = Блокировка.Добавить("Документ.Увольнение");
			ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Разделяемый;
			
		КонецЕсли;
		
		Блокировка.Заблокировать();
		
		
		//::: Прием на работу
		Если ПринятьНаРаботу Тогда
			
			СобытиеЖурналаРегистрации = НСтр("ru ='Добавление ставок в штатное расписание'");
			Если ИспользуетсяШтатноеРасписание
				И СвободноСтавок < ПриемНаРаботуЗанимаемыхСтавок 
				И ПриемНаРаботуДобавитьСтавки Тогда
				
				Отбор = Новый Структура("Организация, СтруктурнаяЕдиница, Должность", Организация, ПриемНаРаботуСтруктурнаяЕдиница, ПриемНаРаботуДолжность);
				ТаблицаЗаписей = РегистрыСведений.ШтатноеРасписание.СрезПоследних(ПриемНаРаботуДатаПриема, Отбор);
				
				МенеджерЗаписи = РегистрыСведений.ШтатноеРасписание.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.Период = ПриемНаРаботуДатаПриема;
				МенеджерЗаписи.Организация = Организация;
				МенеджерЗаписи.СтруктурнаяЕдиница = ПриемНаРаботуСтруктурнаяЕдиница;
				МенеджерЗаписи.Должность = ПриемНаРаботуДолжность;
				МенеджерЗаписи.ВалютаТарифнойСтавки = ПриемНаРаботуВалюта;
				
				Если ТаблицаЗаписей.Количество() <> 0 Тогда
					
					МенеджерЗаписи.КоличествоСтавок = ТаблицаЗаписей[0].КоличествоСтавок + ?(СвободноСтавок < 0, СвободноСтавок * -1, СвободноСтавок) + ПриемНаРаботуЗанимаемыхСтавок;
					МенеджерЗаписи.ВидНачисленияУдержания = ТаблицаЗаписей[0].ВидНачисленияУдержания;
					МенеджерЗаписи.МинимальнаяТарифнаяСтавка = ТаблицаЗаписей[0].МинимальнаяТарифнаяСтавка;
					МенеджерЗаписи.МаксимальнаяТарифнаяСтавка = ТаблицаЗаписей[0].МаксимальнаяТарифнаяСтавка;
					
				Иначе
					
					МенеджерЗаписи.КоличествоСтавок = ?(СвободноСтавок < 0, СвободноСтавок * -1, СвободноСтавок) + ПриемНаРаботуЗанимаемыхСтавок;
					
				КонецЕсли;
				
				МенеджерЗаписи.Записать(Истина);
				
			КонецЕсли;
			
			СобытиеЖурналаРегистрации = НСтр("ru ='Запись приема на работу нового сотрудника'");
			ПриемНаРаботуОбъект					= Документы.ПриемНаРаботу.СоздатьДокумент();
			ПриемНаРаботуОбъект.Дата			= ТекущаяДатаСеанса();
			ПриемНаРаботуОбъект.Организация 	= Организация;
			ПриемНаРаботуОбъект.Заполнить(Неопределено);
			
			СтрокаСотрудники					= ПриемНаРаботуОбъект.Сотрудники.Добавить();
			СтрокаСотрудники.Период				= ПриемНаРаботуДатаПриема;
			СтрокаСотрудники.Сотрудник			= Сотрудник;
			СтрокаСотрудники.СтруктурнаяЕдиница = ПриемНаРаботуСтруктурнаяЕдиница;
			СтрокаСотрудники.Должность			= ПриемНаРаботуДолжность;
			СтрокаСотрудники.ГрафикРаботы		= ПриемНаРаботуГрафикРаботы;
			СтрокаСотрудники.ЗанимаемыхСтавок	= ПриемНаРаботуЗанимаемыхСтавок;
			СтрокаСотрудники.КлючСвязи			= 1;
			
			Для каждого СтрокаТЧ Из НачисленияИУдержания Цикл
				
				Если ЗначениеЗаполнено(СтрокаТЧ.ВидНачисленияУдержания) Тогда
					
					СтрокаНачисления						= ПриемНаРаботуОбъект.НачисленияУдержания.Добавить();
					СтрокаНачисления.ВидНачисленияУдержания = СтрокаТЧ.ВидНачисленияУдержания;
					СтрокаНачисления.Сумма					= СтрокаТЧ.Сумма;
					СтрокаНачисления.Валюта					= ПриемНаРаботуВалюта;
					СтрокаНачисления.СчетЗатрат				= СтрокаТЧ.СчетЗатрат;
					СтрокаНачисления.КлючСвязи				= 1;
					
				КонецЕсли; 
				
			КонецЦикла;
			
			ПриемНаРаботуОбъект.Записать(РежимЗаписиДокумента.Проведение);
			
		КонецЕсли;
		
		//::: Увольнение
		Если ОформитьУвольнение Тогда
			
			СобытиеЖурналаРегистрации = НСтр("ru ='Запись увольнения сотрудника'");
			УвольнениеОбъект					= Документы.Увольнение.СоздатьДокумент();
			УвольнениеОбъект.Дата			= ТекущаяДатаСеанса();
			УвольнениеОбъект.Организация 	= Организация;
			УвольнениеОбъект.Заполнить(Неопределено);
			
			СтрокаСотрудники					= УвольнениеОбъект.Сотрудники.Добавить();
			СтрокаСотрудники.Период				= УвольнениеДатаУвольнения;
			СтрокаСотрудники.Сотрудник			= Сотрудник;
			СтрокаСотрудники.ОснованиеУвольнения = УвольнениеОснованиеУвольнения;
			
			УвольнениеОбъект.Записать(РежимЗаписиДокумента.Проведение);
			
		КонецЕсли;
		
		//::: Кадровое перемещение
		Если ИзменитьДолжность Тогда
			
			СобытиеЖурналаРегистрации = НСтр("ru ='Добавление ставок в штатное расписание'");
			Если ИспользуетсяШтатноеРасписание
				И СвободноСтавок < ПриемНаРаботуЗанимаемыхСтавок 
				И ПриемНаРаботуДобавитьСтавки Тогда
				
				Отбор = Новый Структура("Организация, СтруктурнаяЕдиница, Должность", Организация, ПриемНаРаботуСтруктурнаяЕдиница, ПриемНаРаботуДолжность);
				ТаблицаЗаписей = РегистрыСведений.ШтатноеРасписание.СрезПоследних(ПриемНаРаботуДатаПриема, Отбор);
				
				МенеджерЗаписи = РегистрыСведений.ШтатноеРасписание.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.Период = ПриемНаРаботуДатаПриема;
				МенеджерЗаписи.Организация = Организация;
				МенеджерЗаписи.СтруктурнаяЕдиница = ПриемНаРаботуСтруктурнаяЕдиница;
				МенеджерЗаписи.Должность = ПриемНаРаботуДолжность;
				МенеджерЗаписи.ВалютаТарифнойСтавки = ПриемНаРаботуВалюта;
				
				Если ТаблицаЗаписей.Количество() <> 0 Тогда
					
					МенеджерЗаписи.КоличествоСтавок = ТаблицаЗаписей[0].КоличествоСтавок + ?(СвободноСтавок < 0, СвободноСтавок * -1, СвободноСтавок) + ПриемНаРаботуЗанимаемыхСтавок;
					МенеджерЗаписи.ВидНачисленияУдержания = ТаблицаЗаписей[0].ВидНачисленияУдержания;
					МенеджерЗаписи.МинимальнаяТарифнаяСтавка = ТаблицаЗаписей[0].МинимальнаяТарифнаяСтавка;
					МенеджерЗаписи.МаксимальнаяТарифнаяСтавка = ТаблицаЗаписей[0].МаксимальнаяТарифнаяСтавка;
					
				Иначе
					
					МенеджерЗаписи.КоличествоСтавок = ?(СвободноСтавок < 0, СвободноСтавок * -1, СвободноСтавок) + ПриемНаРаботуЗанимаемыхСтавок;
					
				КонецЕсли;
				
				МенеджерЗаписи.Записать(Истина);
				
			КонецЕсли;
			
			СобытиеЖурналаРегистрации = НСтр("ru ='Запись кадровое перемещение сотрудника'");
			КадровоеПеремещениеОбъект					= Документы.КадровоеПеремещение.СоздатьДокумент();
			КадровоеПеремещениеОбъект.Дата			= ТекущаяДатаСеанса();
			КадровоеПеремещениеОбъект.Организация 	= Организация;
			КадровоеПеремещениеОбъект.ВидОперации = Перечисления.ВидыОперацийКадровоеПеремещение.ПеремещениеИИзменениеСпособаОплаты;
			
			КадровоеПеремещениеОбъект.Заполнить(Неопределено);
			
			СтрокаСотрудники					= КадровоеПеремещениеОбъект.Сотрудники.Добавить();
			СтрокаСотрудники.Период				= ПриемНаРаботуДатаПриема;
			СтрокаСотрудники.Сотрудник			= Сотрудник;
			СтрокаСотрудники.СтруктурнаяЕдиница = ПриемНаРаботуСтруктурнаяЕдиница;
			СтрокаСотрудники.Должность			= ПриемНаРаботуДолжность;
			СтрокаСотрудники.ГрафикРаботы		= ПриемНаРаботуГрафикРаботы;
			СтрокаСотрудники.ЗанимаемыхСтавок	= ПриемНаРаботуЗанимаемыхСтавок;
			СтрокаСотрудники.КлючСвязи			= 1;
			
			Для каждого СтрокаТЧ Из НачисленияИУдержания Цикл
				
				Если ЗначениеЗаполнено(СтрокаТЧ.ВидНачисленияУдержания) Тогда
					
					СтрокаНачисления						= КадровоеПеремещениеОбъект.НачисленияУдержания.Добавить();
					СтрокаНачисления.ВидНачисленияУдержания = СтрокаТЧ.ВидНачисленияУдержания;
					СтрокаНачисления.Сумма					= СтрокаТЧ.Сумма;
					СтрокаНачисления.Валюта					= ПриемНаРаботуВалюта;
					СтрокаНачисления.СчетЗатрат				= СтрокаТЧ.СчетЗатрат;
					СтрокаНачисления.КлючСвязи				= 1;
					СтрокаНачисления.Актуальность			= Истина;
					
				КонецЕсли; 
				
			КонецЦикла;
			
			КадровоеПеремещениеОбъект.Записать(РежимЗаписиДокумента.Проведение);
			
		КонецЕсли;
		
		//::: Изменение оклада
		Если ИзменитьОклад Тогда
			
			
			СобытиеЖурналаРегистрации = НСтр("ru ='Запись кадровое перемещение сотрудника'");
			КадровоеПеремещениеОбъект					= Документы.КадровоеПеремещение.СоздатьДокумент();
			КадровоеПеремещениеОбъект.Дата			= ТекущаяДатаСеанса();
			КадровоеПеремещениеОбъект.Организация 	= Организация;
			КадровоеПеремещениеОбъект.ВидОперации = Перечисления.ВидыОперацийКадровоеПеремещение.ИзменениеСпособаОплаты;
			
			КадровоеПеремещениеОбъект.Заполнить(Неопределено);
			
			СтрокаСотрудники					= КадровоеПеремещениеОбъект.Сотрудники.Добавить();
			
			СтруктураСотрудник = Новый Структура();
			СтруктураСотрудник.Вставить("Сотрудник", Сотрудник);
			СтруктураСотрудник.Вставить("Период", ПриемНаРаботуДатаПриема);
			СтруктураСотрудник.Вставить("Организация", Организация);
			
			ПолучитьДанныеСотрудника(СтруктураСотрудник);
			
			ЗаполнитьЗначенияСвойств(СтрокаСотрудники, СтруктураСотрудник);
			СтрокаСотрудники.КлючСвязи			= 1;
			
			Для каждого СтрокаТЧ Из НачисленияИУдержания Цикл
				
				Если ЗначениеЗаполнено(СтрокаТЧ.ВидНачисленияУдержания) Тогда
					
					СтрокаНачисления						= КадровоеПеремещениеОбъект.НачисленияУдержания.Добавить();
					СтрокаНачисления.ВидНачисленияУдержания = СтрокаТЧ.ВидНачисленияУдержания;
					СтрокаНачисления.Сумма					= СтрокаТЧ.Сумма;
					СтрокаНачисления.Валюта					= ПриемНаРаботуВалюта;
					СтрокаНачисления.СчетЗатрат				= СтрокаТЧ.СчетЗатрат;
					СтрокаНачисления.КлючСвязи				= 1;
					СтрокаНачисления.Актуальность			= Истина;
					
				КонецЕсли; 
				
			КонецЦикла;
			
			КадровоеПеремещениеОбъект.Записать(РежимЗаписиДокумента.Проведение);
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ИнформацияООшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации, УровеньЖурналаРегистрации.Ошибка, Метаданные.Справочники.Сотрудники, , ИнформацияООшибке, );
		
		ВызватьИсключение ИнформацияООшибке;
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Функция ПриПереходеДалее(Отказ)
	Перем Ошибки;
	
	Если НЕ ЗначениеЗаполнено(ПриемНаРаботуДатаПриема) Тогда
		Если ПринятьНаРаботу Тогда
			ТекстСообщения = НСтр("ru ='Необходимо заполнить дату приема на работу.'");
		ИначеЕсли ИзменитьОклад Тогда
			ТекстСообщения = НСтр("ru ='Необходимо заполнить дату изменения заработной платы.'");
		ИначеЕсли ИзменитьДолжность Тогда
			ТекстСообщения = НСтр("ru ='Необходимо заполнить дату кадрового перемещения.'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ПриемНаРаботуДатаПриема", ТекстСообщения, Неопределено);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		ТекстСообщения = НСтр("ru ='Необходимо заполнить организацию.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Организация", ТекстСообщения, Неопределено);
		
	КонецЕсли;
	
	Если ИспользуютсяПодразделения
		И НЕ ЗначениеЗаполнено(ПриемНаРаботуСтруктурнаяЕдиница) И Не ИзменитьОклад Тогда
		
		ТекстСообщения = НСтр("ru ='Необходимо заполнить подразделение.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ПриемНаРаботуСтруктурнаяЕдиница", ТекстСообщения, Неопределено);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПриемНаРаботуДолжность) И Не ИзменитьОклад Тогда
		
		ТекстСообщения = НСтр("ru ='Необходимо заполнить должность сотрудника.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ПриемНаРаботуДолжность", ТекстСообщения, Неопределено);
		
	КонецЕсли;
	
	Если ИспользуетсяШтатноеРасписание И  Не ИзменитьОклад Тогда
		
		Если НЕ ЗначениеЗаполнено(ПриемНаРаботуЗанимаемыхСтавок) Тогда
			
			ТекстСообщения = НСтр("ru ='Необходимо заполнить количество занимаемых ставок.'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ПриемНаРаботуЗанимаемыхСтавок", ТекстСообщения, Неопределено);
			
		Иначе
			
			СтруктураДанных = Новый Структура;
			СтруктураДанных.Вставить("ДатаПриемаНаРаботу", ПриемНаРаботуДатаПриема);
			СтруктураДанных.Вставить("Организация", Организация);
			СтруктураДанных.Вставить("СтруктурнаяЕдиница", ПриемНаРаботуСтруктурнаяЕдиница);
			СтруктураДанных.Вставить("Должность", ПриемНаРаботуДолжность);
			СтруктураДанных.Вставить("ПланируетсяЗанятьСтавок", ПриемНаРаботуЗанимаемыхСтавок);
			СтруктураДанных.Вставить("ДобавитьСтавки", ПриемНаРаботуДобавитьСтавки);
			
			ВыполнитьКонтрольШтатногоРасписания(СтруктураДанных, Ошибки, Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИзменитьДолжность ИЛИ ИзменитьОклад Тогда
		 ВыполнитьКонтрольДатыИзмененияДолжностиОклада(Ошибки, Отказ);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецФункции

&НаСервере
// Выполняет контроль штатного расписания
//
Процедура ВыполнитьКонтрольШтатногоРасписания(СтруктураДанных, Ошибки, Отказ)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ШтатноеРасписаниеСрезПоследних.КоличествоСтавок КАК КоличествоСтавок,
	|	ШтатноеРасписаниеСрезПоследних.МинимальнаяТарифнаяСтавка,
	|	ШтатноеРасписаниеСрезПоследних.МаксимальнаяТарифнаяСтавка,
	|	ШтатноеРасписаниеСрезПоследних.ВидНачисленияУдержания,
	|	ШтатноеРасписаниеСрезПоследних.ВалютаТарифнойСтавки
	|ИЗ
	|	РегистрСведений.ШтатноеРасписание.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И СтруктурнаяЕдиница = &СтруктурнаяЕдиница
	|				И Должность = &Должность) КАК ШтатноеРасписаниеСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ЗанятыеСтавки.ЗанимаемыхСтавок) КАК ЗанятыеСтавки
	|ИЗ
	|	(ВЫБРАТЬ
	|		СУММА(СотрудникиСрезПоследних.ЗанимаемыхСтавок) КАК ЗанимаемыхСтавок,
	|		МАКСИМУМ(СотрудникиСрезПоследних.Период) КАК Период,
	|		СотрудникиСрезПоследних.Организация КАК Организация,
	|		СотрудникиСрезПоследних.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		СотрудникиСрезПоследних.Должность КАК Должность
	|	ИЗ
	|		РегистрСведений.Сотрудники.СрезПоследних(&Период, ) КАК СотрудникиСрезПоследних
	|	
	|	СГРУППИРОВАТЬ ПО
	|		СотрудникиСрезПоследних.Организация,
	|		СотрудникиСрезПоследних.СтруктурнаяЕдиница,
	|		СотрудникиСрезПоследних.Должность) КАК ЗанятыеСтавки
	|ГДЕ
	|	ЗанятыеСтавки.Организация = &Организация
	|	И ЗанятыеСтавки.СтруктурнаяЕдиница = &СтруктурнаяЕдиница
	|	И ЗанятыеСтавки.Должность = &Должность");
	
	Запрос.УстановитьПараметр("Период", 		СтруктураДанных.ДатаПриемаНаРаботу);
	Запрос.УстановитьПараметр("Организация",	СтруктураДанных.Организация);
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтруктураДанных.СтруктурнаяЕдиница);
	Запрос.УстановитьПараметр("Должность", 		СтруктураДанных.Должность);
	
	РезультатВыполненияПакетаЗапроса = Запрос.ВыполнитьПакет();
	ВыборкаКоличествоСтавок = РезультатВыполненияПакетаЗапроса[0].Выбрать();
	ВыборкаЗанятоСтавок = РезультатВыполненияПакетаЗапроса[1].Выбрать();
	
	ТекстСообщения = "";
	Если СтруктураДанных.ДобавитьСтавки Тогда // Если включена опция добавлять ставки, ошибки в отсутсвии свободных ставок быть не может.
		
		ВыборкаКоличествоСтавок.Следующий();
		ВыборкаЗанятоСтавок.Следующий();
		СвободноСтавок = ?(ЗначениеЗаполнено(ВыборкаКоличествоСтавок.КоличествоСтавок), ВыборкаКоличествоСтавок.КоличествоСтавок, 0) - ?(ЗначениеЗаполнено(ВыборкаЗанятоСтавок.ЗанятыеСтавки), ВыборкаЗанятоСтавок.ЗанятыеСтавки, 0);
		
	ИначеЕсли НЕ ВыборкаКоличествоСтавок.Следующий() Тогда
		
		ТекстСообщения = НСтр("ru = 'В штатном расписании организации %1 по структурной единице %2 не предусмотрены ставки для должности %3!'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтруктураДанных.Организация, СтруктураДанных.СтруктурнаяЕдиница, СтруктураДанных.Должность);
		
	Иначе
		
		ВыборкаЗанятоСтавок.Следующий();
		СвободноСтавок = ВыборкаКоличествоСтавок.КоличествоСтавок - ?(ЗначениеЗаполнено(ВыборкаЗанятоСтавок.ЗанятыеСтавки), ВыборкаЗанятоСтавок.ЗанятыеСтавки, 0);
		
		Если СвободноСтавок < СтруктураДанных.ПланируетсяЗанятьСтавок Тогда
			
			ТекстСообщения = НСтр("ru = 'В штатном расписании организации %1 по структурной единице %2 нет достаточного количества свободных ставок для должности %3!
				|Свободно ставок %4, а требуется ставок %5.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтруктураДанных.Организация, СтруктураДанных.СтруктурнаяЕдиница, СтруктураДанных.Должность, СвободноСтавок, СтруктураДанных.ПланируетсяЗанятьСтавок);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ТекстСообщения) Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , ТекстСообщения, Неопределено);
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКонтрольШтатногоРасписания()

&НаСервере
Процедура ВыполнитьКонтрольДатыИзмененияДолжностиОклада(Ошибки, Отказ)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПлановыеНачисленияИУдержания.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрСведений.ПлановыеНачисленияИУдержания КАК ПлановыеНачисленияИУдержания
	|ГДЕ
	|	ПлановыеНачисленияИУдержания.Период = &Период
	|	И ПлановыеНачисленияИУдержания.Организация = &Организация
	|	И ПлановыеНачисленияИУдержания.Сотрудник = &Сотрудник";
	Запрос.УстановитьПараметр("Период", ПриемНаРаботуДатаПриема);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ТекстСообщения = НСтр("ru = 'У сотрудника  %1 на дату %2 в программе уже  есть кадровое перемещение. Выберите другую дату, либо измените документ ""Кадровое перемещение""'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Сотрудник, ПриемНаРаботуДатаПриема);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , ТекстСообщения, Неопределено);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
// Получает с сервера набор данных из РС Сотрудники.
//
Процедура ПолучитьДанныеСотрудника(СтруктураСотрудник)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СотрудникиСрезПоследних.СтруктурнаяЕдиница,
	|	СотрудникиСрезПоследних.Должность,
	|	СотрудникиСрезПоследних.ЗанимаемыхСтавок,
	|	СотрудникиСрезПоследних.ГрафикРаботы
	|ИЗ
	|	РегистрСведений.Сотрудники.СрезПоследних(
	|			&Период,
	|			Сотрудник = &Сотрудник
	|				И Организация = &Организация) КАК СотрудникиСрезПоследних");
	
	Запрос.УстановитьПараметр("Период", СтруктураСотрудник.Период);
	Запрос.УстановитьПараметр("Сотрудник", СтруктураСотрудник.Сотрудник);
	Запрос.УстановитьПараметр("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(СтруктураСотрудник.Организация));
	
	СтруктураСотрудник.Вставить("СтруктурнаяЕдиница");
	СтруктураСотрудник.Вставить("Должность");
	СтруктураСотрудник.Вставить("ЗанимаемыхСтавок", 1);
	СтруктураСотрудник.Вставить("ГрафикРаботы");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СтруктураСотрудник, Выборка);
	КонецЦикла;
	
КонецПроцедуры // ПолучитьДанныеДатаПриИзменении()

#КонецОбласти
