
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	ГотовоНаСервере();
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ГотовоНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.Оборудование КАК Оборудование
	|ИЗ
	|	РегистрСведений.ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров КАК ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Оборудование) Тогда
			УстановитьЗначениеВРегистре(Пользователь, Пароль, Выборка.Оборудование);
		КонецЕсли;
	КонецЦикла;
			
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеВРегистре(Знач Пользователь, Знач Пароль, Знач Оборудование)
	
	НаборЗаписей = РегистрыСведений.ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Оборудование.Установить(Оборудование);
	НаборЗаписей.Прочитать();
	
	ТЗ = НаборЗаписей.Выгрузить();
	
	Если ТЗ.Количество() > 0 Тогда
		
		СтрокаДанных = ТЗ[0];
		СтрокаДанных.Пользователь	= Пользователь;
		СтрокаДанных.Пароль			= Пароль;
		НаборЗаписей.Загрузить(ТЗ);
		Попытка
			НаборЗаписей.Записать(Истина);
	    Исключение
		КонецПопытки;
		
	КонецЕсли;
		
КонецПроцедуры
