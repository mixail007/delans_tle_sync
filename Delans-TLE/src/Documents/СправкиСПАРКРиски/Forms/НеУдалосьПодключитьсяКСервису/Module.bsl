///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ДекорацияОшибкаПодключения.Заголовок = Параметры.СообщениеОбОшибке;
	ИнформацияОбОшибке = Параметры.ИнформацияОбОшибке;
	
	Элементы.ДекорацияНаписатьВТехПоддержку.Видимость = Не ОбщегоНазначения.РазделениеВключено();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ДекорацияРекомендацииПриОшибкеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "open:ProxySettings" Тогда
		ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера",
			Новый Структура("НастройкаПроксиНаКлиенте", Ложь),
			ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНаписатьВТехПоддержкуОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОтправитьСообщениеВТехПоддержку("webIts");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОткрытьЖурналРегистрацииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Новый Структура("Пользователь", ИмяПользователя()));
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОтправитьСообщениеВТехПоддержку(АдресПолучателя)
	
	Тема      = НСтр("ru = 'Интернет-поддержка. 1СПАРК Риски'");
	Сообщение = НСтр("ru = 'Ошибка при подключении к сервису 1СПАРК Риски.
		|Описание ошибки:'")
		+ Символы.ПС
		+ ИнформацияОбОшибке;
	
	ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(Тема, Сообщение);
	
КонецПроцедуры

#КонецОбласти
