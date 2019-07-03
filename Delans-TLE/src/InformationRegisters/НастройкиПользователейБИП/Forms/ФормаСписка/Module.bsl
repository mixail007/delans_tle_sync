///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем КэшПредставленийНастроекПоказаНовостей;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ЭтотОбъект.РольДоступнаПолныеПрава = ОбработкаНовостейПовтИсп.ЕстьРольПолныеПрава();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если ЭтотОбъект.РольДоступнаПолныеПрава = Истина Тогда
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			СтандартнаяОбработка = Ложь;
			ОткрытьФорму(
				"ХранилищеНастроек.НастройкиНовостей.Форма.ФормаНастройкиПоказаНовостей",
				Новый Структура("ТекущийПользователь, ОткрытаИзОбработки_УправлениеНовостями",
					Элемент.ТекущиеДанные.Пользователь,
					Истина),
				ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)

	ПодключитьОбработчикОжидания("СформироватьПредставлениеНастройкиПросмотраНовостей", 0.2, Истина)

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует текстовое представление настройки для текущей строки.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура СформироватьПредставлениеНастройкиПросмотраНовостей()

	ТипСоответствие   = Тип("Соответствие");

	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		// Попробовать найти в кэше.
		Если ТипЗнч(КэшПредставленийНастроекПоказаНовостей) <> ТипСоответствие Тогда
			КэшПредставленийНастроекПоказаНовостей = Новый Соответствие;
		КонецЕсли;
		Результат = КэшПредставленийНастроекПоказаНовостей.Получить(Элементы.Список.ТекущиеДанные.Пользователь);
		Если Результат = Неопределено Тогда
			Результат = ПолучитьПредставлениеНастройкиПросмотраНовостей(Элементы.Список.ТекущиеДанные.Пользователь);
			КэшПредставленийНастроекПоказаНовостей.Вставить(Элементы.Список.ТекущиеДанные.Пользователь, Результат);
		КонецЕсли;
		ЭтотОбъект.ПредставлениеНастройкиПросмотраНовостей = Результат;
		// Очистить кэш, если там > 50 значений.
		Если КэшПредставленийНастроекПоказаНовостей.Количество() > 50 Тогда
			КэшПредставленийНастроекПоказаНовостей = Новый Соответствие;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Формирует текстовое представление настройки для текущей строки.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь, для которого надо получить представление настройки.
//
&НаСервереБезКонтекста
Функция ПолучитьПредставлениеНастройкиПросмотраНовостей(Пользователь)

	Результат = "";

	ТипСтруктура = Тип("Структура");

	Запись = РегистрыСведений.НастройкиПользователейБИП.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Прочитать();
	Если Запись.Выбран() Тогда
		ЗначениеНастроек = Запись.НастройкиПоказаНовостей.Получить();
		Если ТипЗнч(ЗначениеНастроек) = ТипСтруктура Тогда
			Результат = ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеЗначения(
				ЗначениеНастроек,
				": ",
				Символы.ПС);
		Иначе
			Результат = "По-умолчанию";
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти
