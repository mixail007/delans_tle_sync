///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Вызывается при получении представления объекта или ссылки в зависимости от языка,
// используемого при работе пользователя.
//
// Параметры:
//  Данные               - Структура - Содержит значения полей, из которых формируется представление.
//  Представление        - Строка - В данный параметр нужно поместить сформированное представление.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак формирования стандартного представления.
//  ИмяРеквизита         - Строка - Указывает, в каком реквизите хранится представление на основном языке.
//
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка, ИмяРеквизита = "Наименование") Экспорт
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ТолстыйКлиентУправляемоеПриложение Или ВнешнееСоединение Тогда
		
	Если ТекущийЯзык() = Метаданные.ОсновнойЯзык Или Не Данные.Свойство("Ссылка") Или Данные.Ссылка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Представления.%2 КАК Наименование
		|ИЗ
		|	%1.Представления КАК Представления
		|ГДЕ
		|	Представления.КодЯзыка = &Язык
		|	И Представления.Ссылка = &Ссылка";
	
	ТекстЗапроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗапроса,
		Данные.Ссылка.Метаданные().ПолноеИмя(), ИмяРеквизита);
		
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("Ссылка", Данные.Ссылка);
	Запрос.УстановитьПараметр("Язык",   ТекущийЯзык().КодЯзыка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		СтандартнаяОбработка = Ложь;
		Представление = РезультатЗапроса.Выгрузить()[0].Наименование;
	КонецЕсли;
	
#КонецЕсли
	
КонецПроцедуры

#КонецОбласти