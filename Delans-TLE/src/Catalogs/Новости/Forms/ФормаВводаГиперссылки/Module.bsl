///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем СписокРазделовДляСвертки;

&НаКлиенте
Перем СписокРазделовДляМаркеровСостояния;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("ТаблицаМетаданных")
			И ТипЗнч(Параметры.ТаблицаМетаданных) = Тип("ДанныеФормыКоллекция") Тогда
		ЭтотОбъект.ТаблицаМетаданных.Загрузить(Параметры.ТаблицаМетаданных.Выгрузить());
	Иначе
		ЭтотОбъект.ТаблицаМетаданных.Загрузить(ОбработкаНовостейПовтИсп.ПолучитьТаблицуМетаданных());
	КонецЕсли;

	Элементы.ПараметрДействия_НавигационнаяСсылка.СписокВыбора.Очистить();
	Элементы.ПараметрДействия_РазделСправки.СписокВыбора.Очистить();
	Для каждого ТекущийОбъектМетаданных Из ЭтотОбъект.ТаблицаМетаданных Цикл
		Если НЕ ПустаяСтрока(ТекущийОбъектМетаданных.НавигационнаяСсылка) Тогда
			Элементы.ПараметрДействия_НавигационнаяСсылка.СписокВыбора.Добавить(ТекущийОбъектМетаданных.НавигационнаяСсылка, ТекущийОбъектМетаданных.ИмяМетаданных);
		КонецЕсли;
		Если НЕ ПустаяСтрока(ТекущийОбъектМетаданных.РазделСправки) Тогда
			Элементы.ПараметрДействия_РазделСправки.СписокВыбора.Добавить(ТекущийОбъектМетаданных.РазделСправки, ТекущийОбъектМетаданных.ИмяМетаданных);
		КонецЕсли;
	КонецЦикла;
	Элементы.ПараметрДействия_НавигационнаяСсылка.СписокВыбора.СортироватьПоПредставлению(); // В представлении - правильная сортировка
	Элементы.ПараметрДействия_РазделСправки.СписокВыбора.СортироватьПоЗначению(); // В значении - правильная сортировка

	// Список уникальных идентификаторов действий (для автонумерации)
	ЭтотОбъект.СписокУИНДействий = Параметры.СписокУИНДействий;

	ДанныеДляПередачиНаКлиента = Новый Структура;
	ДанныеДляПередачиНаКлиента.Вставить("СписокРазделовДляСвертки", Параметры.СписокРазделовДляСвертки);
	ДанныеДляПередачиНаКлиента.Вставить("СписокРазделовДляМаркеровСостояния", Параметры.СписокРазделовДляМаркеровСостояния);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ТипСтруктура = Тип("Структура");
	ТипСписокЗначений = Тип("СписокЗначений");

	Если ТипЗнч(ДанныеДляПередачиНаКлиента) = ТипСтруктура Тогда
		Если (ДанныеДляПередачиНаКлиента.Свойство("СписокРазделовДляСвертки"))
				И (ТипЗнч(ДанныеДляПередачиНаКлиента.СписокРазделовДляСвертки) = ТипСписокЗначений) Тогда
			СписокРазделовДляСвертки = ДанныеДляПередачиНаКлиента.СписокРазделовДляСвертки;
		КонецЕсли;
		Если (ДанныеДляПередачиНаКлиента.Свойство("СписокРазделовДляМаркеровСостояния"))
				И (ТипЗнч(ДанныеДляПередачиНаКлиента.СписокРазделовДляМаркеровСостояния) = ТипСписокЗначений) Тогда
			СписокРазделовДляМаркеровСостояния = ДанныеДляПередачиНаКлиента.СписокРазделовДляМаркеровСостояния;
		КонецЕсли;
	КонецЕсли;

	ДанныеДляПередачиНаКлиента = Неопределено;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	// Проверяемые реквизиты:
	//  Действие            - всегда;
	//  УИНДействия         - всегда;
	//  ИнтернетСсылка      - для действия "Переход по интернет ссылке";
	//  КартинкаДанные      - для действия "Показать картинку";
	//  КартинкаЗаголовок   - для действия "Показать картинку";
	//  НавигационнаяСсылка - для действия "Переход по навигационной ссылке";
	//  РазделСправки       - для действия "Открытие раздела справки".

	Если ПустаяСтрока(ЭтотОбъект.Действие) Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Не заполнено поле Действие'");
		Сообщение.Поле  = "Действие";
		Сообщение.Сообщить();
	КонецЕсли;

	Если ПустаяСтрока(ЭтотОбъект.УИНДействия) Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Не заполнен идентификатор гиперссылки (должен заполниться автоматически после выбора Действия)'");
		Сообщение.Поле  = "УИНДействия";
		Сообщение.Сообщить();
	КонецЕсли;

	Если ЭтотОбъект.Действие = "Переход по навигационной ссылке" Тогда
		Если ПустаяСтрока(ЭтотОбъект.ПараметрДействия_НавигационнаяСсылка) Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Не заполнена навигационная ссылка'");
			Сообщение.Поле  = "ПараметрДействия_НавигационнаяСсылка";
			Сообщение.Сообщить();
		КонецЕсли;
	ИначеЕсли ЭтотОбъект.Действие = "Оповещение" Тогда
		// Ничего не делать
	ИначеЕсли ЭтотОбъект.Действие = "Открытие раздела справки" Тогда
		Если ПустаяСтрока(ЭтотОбъект.ПараметрДействия_РазделСправки) Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Не заполнен раздел справки'");
			Сообщение.Поле  = "ПараметрДействия_РазделСправки";
			Сообщение.Сообщить();
		КонецЕсли;
	ИначеЕсли ЭтотОбъект.Действие = "Запуск процедуры с параметрами" Тогда
		// Ничего не делать
	ИначеЕсли ЭтотОбъект.Действие = "Переход по интернет ссылке" Тогда
		Если ПустаяСтрока(ЭтотОбъект.ПараметрДействия_ИнтернетСсылка) Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Не заполнена интернет-ссылка'");
			Сообщение.Поле  = "ПараметрДействия_ИнтернетСсылка";
			Сообщение.Сообщить();
		КонецЕсли;
	ИначеЕсли ЭтотОбъект.Действие = "Показать картинку" Тогда
		Если ПустаяСтрока(ЭтотОбъект.КартинкаЗаголовок) Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Не заполнен заголовок картинки'");
			Сообщение.Поле  = "КартинкаЗаголовок";
			Сообщение.Сообщить();
		КонецЕсли;
		Если ПустаяСтрока(ЭтотОбъект.КартинкаДанные) Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Не загружена картинка. Нажмите <Выбрать картинку из файла>'");
			Сообщение.Поле  = "КартинкаЗаголовок";
			Сообщение.Сообщить();
		КонецЕсли;
	ИначеЕсли ЭтотОбъект.Действие = "Открытие новости" Тогда
		// Ничего не делать
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДействиеПриИзменении(Элемент)

	ПрефиксНомера = "";
	// 1. Отобразить правильную закладку
	Если ЭтотОбъект.Действие = "Переход по навигационной ссылке" Тогда
		Элементы.СтраницыПараметров.ТекущаяСтраница = Элементы.СтраницаНавигационнаяСсылка;
		ПрефиксНомера = "1C:GoTo";
	ИначеЕсли ЭтотОбъект.Действие = "Оповещение" Тогда
		Элементы.СтраницыПараметров.ТекущаяСтраница = Элементы.СтраницаОповещение;
		ПрефиксНомера = "1C:Notif";
	ИначеЕсли ЭтотОбъект.Действие = "Открытие раздела справки" Тогда
		Элементы.СтраницыПараметров.ТекущаяСтраница = Элементы.СтраницаРазделСправки;
		ПрефиксНомера = "1C:OpenHelp";
	ИначеЕсли ЭтотОбъект.Действие = "Запуск процедуры с параметрами" Тогда
		Элементы.СтраницыПараметров.ТекущаяСтраница = Элементы.СтраницаРазное;
		ПрефиксНомера = "1C:App";
	ИначеЕсли ЭтотОбъект.Действие = "Переход по интернет ссылке" Тогда
		Элементы.СтраницыПараметров.ТекущаяСтраница = Элементы.СтраницаИнтернетСсылка;
		ПрефиксНомера = "1C:Web";
		Если ПустаяСтрока(ЭтотОбъект.ПараметрДействия_ИнтернетСсылка) Тогда
			ЭтотОбъект.ПараметрДействия_ИнтернетСсылка = "http://";
		КонецЕсли;
	ИначеЕсли ЭтотОбъект.Действие = "Показать картинку" Тогда
		Элементы.СтраницыПараметров.ТекущаяСтраница = Элементы.СтраницаКартинки;
		ПрефиксНомера = "1C:ShowPict";
	ИначеЕсли ЭтотОбъект.Действие = "Открытие новости" Тогда
		Элементы.СтраницыПараметров.ТекущаяСтраница = Элементы.СтраницаРазное;
		ПрефиксНомера = "1C:OpenNews";
	Иначе
		Элементы.СтраницыПараметров.ТекущаяСтраница = Элементы.СтраницаПусто;
	КонецЕсли;

	// 2. Присвоить уникальный номер
	Для С=1 По 999 Цикл
		НовыйУИН = ПрефиксНомера + Формат(С, "ЧЦ=3; ЧВН=");
		Если ЭтотОбъект.СписокУИНДействий.НайтиПоЗначению(НовыйУИН) = Неопределено Тогда
			ЭтотОбъект.УИНДействия = НовыйУИН;
			Прервать;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПерейтиПоИнтернетСсылкеНажатие(Элемент)

	Если НЕ ПустаяСтрока(ЭтотОбъект.ПараметрДействия_ИнтернетСсылка) Тогда
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ЭтотОбъект.ПараметрДействия_ИнтернетСсылка);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НавигационнаяСсылкаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)

	Если (Ожидание > 0) И (СтрДлина(Текст) > 0) Тогда
		// Найти в списке похожие значения и вывести их
		ДанныеВыбора = Новый СписокЗначений;
		Для каждого ЭлементСписка Из Элементы.ПараметрДействия_НавигационнаяСсылка.СписокВыбора Цикл
			Если СтрНайти(ВРег(ЭлементСписка.Значение), ВРег(Текст)) > 0 Тогда
				ДанныеВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
			КонецЕсли;
		КонецЦикла;

		Если ДанныеВыбора.Количество() = 1 Тогда
			СтандартнаяОбработка = Ложь;
			ЭтотОбъект.ПараметрДействия_НавигационнаяСсылка = ДанныеВыбора[0].Значение;
		ИначеЕсли ДанныеВыбора.Количество() > 0 Тогда
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НавигационнаяСсылкаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)

	// Найти в списке похожие значения и вывести их
	ДанныеВыбора = Новый СписокЗначений;
	Для каждого ЭлементСписка Из Элементы.ПараметрДействия_НавигационнаяСсылка.СписокВыбора Цикл
		Если СтрНайти(ВРег(ЭлементСписка.Значение), ВРег(Текст)) > 0 Тогда
			ДанныеВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
		КонецЕсли;
	КонецЦикла;

	Если ДанныеВыбора.Количество() = 1 Тогда
		СтандартнаяОбработка = Ложь;
		ЭтотОбъект.ПараметрДействия_НавигационнаяСсылка = ДанныеВыбора[0].Значение;
	ИначеЕсли ДанныеВыбора.Количество() > 0 Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РазделСправкиАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)

	Если (Ожидание > 0) И (СтрДлина(Текст) > 0) Тогда
		// Найти в списке похожие значения и вывести их
		ДанныеВыбора = Новый СписокЗначений;
		Для каждого ЭлементСписка Из Элементы.ПараметрДействия_РазделСправки.СписокВыбора Цикл
			Если СтрНайти(ВРег(ЭлементСписка.Значение), ВРег(Текст)) > 0 Тогда
				ДанныеВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
			КонецЕсли;
		КонецЦикла;

		Если ДанныеВыбора.Количество() = 1 Тогда
			СтандартнаяОбработка = Ложь;
			ЭтотОбъект.ПараметрДействия_РазделСправки = ДанныеВыбора[0].Значение;
		ИначеЕсли ДанныеВыбора.Количество() > 0 Тогда
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РазделСправкиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)

	// Найти в списке похожие значения и вывести их
	ДанныеВыбора = Новый СписокЗначений;
	Для каждого ЭлементСписка Из Элементы.ПараметрДействия_РазделСправки.СписокВыбора Цикл
		Если СтрНайти(ВРег(ЭлементСписка.Значение), ВРег(Текст)) > 0 Тогда
			ДанныеВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
		КонецЕсли;
	КонецЦикла;

	Если ДанныеВыбора.Количество() = 1 Тогда
		СтандартнаяОбработка = Ложь;
		ЭтотОбъект.ПараметрДействия_РазделСправки = ДанныеВыбора[0].Значение;
	ИначеЕсли ДанныеВыбора.Количество() > 0 Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияДобавитьКартинкуНажатие(Элемент)

	АдресВХранилище = "";
	ИмяФайла = "";

	ОписаниеОповещенияПослеВыбораФайла = Новый ОписаниеОповещения(
		"ПослеВыбораФайла",
		ЭтотОбъект,
		Неопределено);

	НачатьПомещениеФайла(
		ОписаниеОповещенияПослеВыбораФайла, // ОписаниеОповещенияОЗавершении
		АдресВХранилище, // Адрес
		ИмяФайла, // НачальноеИмяФайла
		Истина, // Интерактивно
		ЭтотОбъект.УникальныйИдентификатор); // УникальныйИдентификаторФормы

КонецПроцедуры

&НаКлиенте
Процедура ПараметрДействия_Оповещение_ИмяСобытияПриИзменении(Элемент)

	Если ПараметрДействия_Оповещение_ИмяСобытия = "Новости. Скрыть показать блок" Тогда
		// Жестко задать список параметров:
		// - УИНБлока;
		// - УИНМаркера;
		// - МаркерРазвернуто;
		// - МаркерСвернуто.
		УИНБлока         = "";
		УИНМаркера       = "";
		МаркерРазвернуто = "";
		МаркерСвернуто   = "";
		Для Каждого ТекущийЭлементСписка Из ПараметрДействия_Оповещение_Параметры Цикл
			Если ТекущийЭлементСписка.Представление = "УИНБлока" Тогда // Идентификатор.
				УИНБлока         = ТекущийЭлементСписка.Значение;
			ИначеЕсли ТекущийЭлементСписка.Представление = "УИНМаркера" Тогда // Идентификатор.
				УИНМаркера       = ТекущийЭлементСписка.Значение;
			ИначеЕсли ТекущийЭлементСписка.Представление = "МаркерРазвернуто" Тогда // Идентификатор.
				МаркерРазвернуто = ТекущийЭлементСписка.Значение;
			ИначеЕсли ТекущийЭлементСписка.Представление = "МаркерСвернуто" Тогда // Идентификатор.
				МаркерСвернуто   = ТекущийЭлементСписка.Значение;
			КонецЕсли;
		КонецЦикла;
		// Воссоздадим список значений заново, добавим элементы в правильном порядке. Лишние элементы будут удалены.
		ПараметрДействия_Оповещение_Параметры.Очистить();
		НоваяСтрока = ПараметрДействия_Оповещение_Параметры.Добавить();
			НоваяСтрока.ИмяПараметра = "УИНБлока";
			НоваяСтрока.ЗначениеПараметра = УИНБлока;
		НоваяСтрока = ПараметрДействия_Оповещение_Параметры.Добавить();
			НоваяСтрока.ИмяПараметра = "УИНМаркера";
			НоваяСтрока.ЗначениеПараметра = УИНМаркера;
		НоваяСтрока = ПараметрДействия_Оповещение_Параметры.Добавить();
			НоваяСтрока.ИмяПараметра = "МаркерРазвернуто";
			НоваяСтрока.ЗначениеПараметра = МаркерРазвернуто;
		НоваяСтрока = ПараметрДействия_Оповещение_Параметры.Добавить();
			НоваяСтрока.ИмяПараметра = "МаркерСвернуто";
			НоваяСтрока.ЗначениеПараметра = МаркерСвернуто;
		// Запретить менять состав параметров.
		Элементы.ПараметрДействия_Оповещение_Параметры.ИзменятьПорядокСтрок = Ложь;
		Элементы.ПараметрДействия_Оповещение_Параметры.ИзменятьСоставСтрок  = Ложь;
		Элементы.ПараметрДействия_Оповещение_ПараметрыИмяПараметра.ТолькоПросмотр = Истина;
	Иначе
		// Разрешить менять состав параметров.
		Элементы.ПараметрДействия_Оповещение_Параметры.ИзменятьПорядокСтрок = Истина;
		Элементы.ПараметрДействия_Оповещение_Параметры.ИзменятьСоставСтрок  = Истина;
		Элементы.ПараметрДействия_Оповещение_ПараметрыИмяПараметра.ТолькоПросмотр = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПараметрДействия_Оповещение_ПараметрыЗначениеПараметраНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ТипСписокЗначений = Тип("СписокЗначений");

	ТекущиеДанные = Элементы.ПараметрДействия_Оповещение_Параметры.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Если ТекущиеДанные.ИмяПараметра = "УИНБлока" Тогда // Идентификатор.
			Если ТипЗнч(СписокРазделовДляСвертки) = ТипСписокЗначений Тогда
				ДанныеВыбора = Новый СписокЗначений;
				ДанныеВыбора.ЗагрузитьЗначения(СписокРазделовДляСвертки.ВыгрузитьЗначения());
				СтандартнаяОбработка = Ложь;
			КонецЕсли;
		ИначеЕсли ТекущиеДанные.ИмяПараметра = "УИНМаркера" Тогда // Идентификатор.
			Если ТипЗнч(СписокРазделовДляМаркеровСостояния) = ТипСписокЗначений Тогда
				ДанныеВыбора = Новый СписокЗначений;
				ДанныеВыбора.ЗагрузитьЗначения(СписокРазделовДляМаркеровСостояния.ВыгрузитьЗначения());
				СтандартнаяОбработка = Ложь;
			КонецЕсли;
		ИначеЕсли ТекущиеДанные.ИмяПараметра = "МаркерРазвернуто" Тогда // Идентификатор.
			СтандартнаяОбработка = Ложь;
			ДанныеВыбора = Новый СписокЗначений;
			ДанныеВыбора.Добавить(НСтр("ru='развернуто'"));
			ДанныеВыбора.Добавить(НСтр("ru='свернуть'"));
			ДанныеВыбора.Добавить("[-]");
		ИначеЕсли ТекущиеДанные.ИмяПараметра = "МаркерСвернуто" Тогда // Идентификатор.
			СтандартнаяОбработка = Ложь;
			ДанныеВыбора = Новый СписокЗначений;
			ДанныеВыбора.Добавить(НСтр("ru='свернуто'"));
			ДанныеВыбора.Добавить(НСтр("ru='развернуть'"));
			ДанныеВыбора.Добавить("[+]");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПараметрДействия_Оповещение_ИсточникиЗначениеПараметраНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Истина;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)

	ОчиститьСообщения();

	Если ПроверитьЗаполнение() Тогда
		ОписаниеОповещения = Новый СписокЗначений;
		ОписаниеОповещения.Добавить(ПараметрДействия_Оповещение_ИмяСобытия, "ИмяСобытия");
		Для Каждого ТекущийЭлементСписка Из ПараметрДействия_Оповещение_Источники Цикл
			Если НЕ ПустаяСтрока(ТекущийЭлементСписка.ИмяПараметра) Тогда
				ОписаниеОповещения.Добавить(СокрЛП(ТекущийЭлементСписка.ИмяПараметра) + "=" + СокрЛП(ТекущийЭлементСписка.ЗначениеПараметра), "Источник");
			КонецЕсли;
		КонецЦикла;
		Для Каждого ТекущийЭлементСписка Из ПараметрДействия_Оповещение_Параметры Цикл
			Если НЕ ПустаяСтрока(ТекущийЭлементСписка.ИмяПараметра) Тогда
				ОписаниеОповещения.Добавить(СокрЛП(ТекущийЭлементСписка.ИмяПараметра) + "=" + СокрЛП(ТекущийЭлементСписка.ЗначениеПараметра), "Параметр");
			КонецЕсли;
		КонецЦикла;

		Результат = Новый Структура;
		Результат.Вставить("УИНДействия", УИНДействия);
		Результат.Вставить("Действие", Действие);
		Результат.Вставить("ВсплывающаяПодсказка", ВсплывающаяПодсказка);
		Результат.Вставить("ИнтернетСсылка", ПараметрДействия_ИнтернетСсылка);
		Результат.Вставить("КартинкаДанные", КартинкаДанные);
		Результат.Вставить("КартинкаРазмер", КартинкаРазмер);
		Результат.Вставить("НавигационнаяСсылка", ПараметрДействия_НавигационнаяСсылка);
		Результат.Вставить("КартинкаЗаголовок", КартинкаЗаголовок);
		Результат.Вставить("РазделСправки", ПараметрДействия_РазделСправки);
		Результат.Вставить("Оповещение", ОписаниеОповещения);

		ЭтотОбъект.Закрыть(Результат);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Функция загружает файл в текущую строку.
// 
// Параметры:
//  АдресВХранилище     - Строка;
//  ИдентификаторСтроки - Число.
//
Функция ПолучитьBase64ИзФайлаСервер(АдресВХранилище)

	Результат = Новый Структура("Данные, Размер", "", 0);

	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВХранилище);

	// ... а вот добавленный реквизит-колонка ДанныеСтрока64 недоступен на сервере
	Результат.Вставить("Данные", Base64Строка(ДвоичныеДанные));
	Результат.Вставить("Размер", ДвоичныеДанные.Размер());

	Возврат Результат;

КонецФункции

&НаКлиенте
// Процедура обрабатывает добавление файла
//
// Параметры:
//  Результат               - Булево - Ложь - в параметре <Интерактивно> установлен интерактивный режим (Истина) и пользователь отказался от выполнения операции в диалоге выбора файла, 
//  АдресВХранилище         - Строка - расположение нового файла, 
//  ВыбранноеИмяФайла       - Строка - Через этот параметр возвращается путь к файлу, указанный в диалоге выбора файла. Для неинтерактивного режима выбранное имя файла соответствует начальному имени файла. В режиме запуска "Веб-клиент" значение параметра зависит от типа браузера. Для Mozilla Firefox 3 в параметре возвращается только имя файла без пути. Для Microsoft Internet Explorer возвращаемое значение зависит от настройки текущей зоны. Подробности: http://msdn.microsoft.com/en-us/library/ms535128(VS.85).aspx, 
//  ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
//
Процедура ПослеВыбораФайла(Результат, АдресВХранилище, ВыбранноеИмяФайла, ДополнительныеПараметры = Неопределено) Экспорт

	Если Результат = Истина Тогда
		СтруктураСохраненногоФайла = ПолучитьBase64ИзФайлаСервер(АдресВХранилище);
		ЭтотОбъект.КартинкаДанные = СтруктураСохраненногоФайла.Данные;
		ЭтотОбъект.КартинкаРазмер = СтруктураСохраненногоФайла.Размер;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
