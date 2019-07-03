
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установим формат для текущей даты: ДФ=Ч:мм
	УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(Список);
	
	УстановитьВидимостьИДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия="ВводОстатков" Тогда
		Элементы.Список.Обновить();
		УстановитьВидимостьИДоступность();
	КонецЕсли; 	
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьИДоступность()
	
	Если Документы.ВводНачальныхОстатков.ОстаткиВведены() И НЕ Элементы.Найти("ФормаСоздать")=Неопределено Тогда
		Элементы.ФормаСоздать.Заголовок = НСтр("ru = 'Продолжить ввод остатков'");
	КонецЕсли; 
	
КонецПроцедуры
 
#КонецОбласти 