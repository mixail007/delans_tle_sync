
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ХозяйствующиеСубъектыВЕТИС.Видимость      = ПравоДоступа("Чтение", Метаданные.Справочники.ХозяйствующиеСубъектыВЕТИС);
	Элементы.ПредприятияВЕТИС.Видимость                = ПравоДоступа("Чтение", Метаданные.Справочники.ПредприятияВЕТИС);
	Элементы.ПродукцияВЕТИС.Видимость                  = ПравоДоступа("Чтение", Метаданные.Справочники.ПродукцияВЕТИС);
	Элементы.ОткрытьЦелиВЕТИС.Видимость                = ПравоДоступа("Чтение", Метаданные.Справочники.ЦелиВЕТИС);
	
	ВосстановитьНастройкиФормы();
	ОбновитьСпискиДокументов();
	
	СобытияФормВЕТИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для использования данной функциональности нужно запустить программу в толстом, тонком или ВЕБ-клиенте'"));
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НадписьСообщенияОжидающиеОтправкиНажатие(Элемент)
	
	ПараметрыОткрытияФормы = Новый Структура;
	
	МассивОрганизацииВЕТИС = Новый Массив;
	ЭлементыДанных = ИнтеграцияВЕТИСКлиент.ОрганизацииВЕТИСДляОбмена(ЭтотОбъект);
	Если ЗначениеЗаполнено(ЭлементыДанных) Тогда
		Для Каждого ЭлементДанных Из ЭлементыДанных Цикл
			МассивОрганизацииВЕТИС.Добавить(ЭлементДанных.Организация);
		КонецЦикла;
	КонецЕсли;
	
	Если ОрганизацииВЕТИС.ПолучитьЭлементы().Количество() > 0 Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("ХозяйствующийСубъект", МассивОрганизацииВЕТИС);
		
		ПараметрыОткрытияФормы.Вставить("Отбор", Отбор);
		
	КонецЕсли;
	
	ОткрытьФорму(
		"РегистрСведений.ОчередьСообщенийВЕТИС.ФормаСписка",
		ПараметрыОткрытияФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

#Область ОтборПоОрганизацииВЕТИС

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСПриИзменении(Элемент)
	
	Элементы.ОткрытьЛичныйКабинетВЕТИС.Видимость = ЗначениеЗаполнено(ОрганизацииВЕТИС);
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ОрганизацииВЕТИС, Ложь, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы());
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),
		Новый ОписаниеОповещения("ПослеВыбораОрганизацииВЕТИС", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, Неопределено, Ложь, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы());
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ВыбранноеЗначение, Ложь, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы());
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры


&НаКлиенте
Процедура ОтборОрганизацияВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ОрганизацияВЕТИС, Ложь, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы());
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект,
		"Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),
		Новый ОписаниеОповещения("ПослеВыбораОрганизацииВЕТИС", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, Неопределено, Ложь, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы());
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ВыбранноеЗначение, Ложь, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы());
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСправочникЦелиВЕТИС(Команда)
	
	ОткрытьФорму("Справочник.ЦелиВЕТИС.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникХозяйствующиеСубъектыВЕТИС(Команда)
	
	ОткрытьФорму("Справочник.ХозяйствующиеСубъектыВЕТИС.Форма.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникПродукцияВЕТИС(Команда)
	
	ОткрытьФорму("Справочник.ПродукцияВЕТИС.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникПредприятийВЕТИС(Команда)
	
	ОткрытьФорму("Справочник.ПредприятияВЕТИС.Форма.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПротоколОбменаВЕТИС(Команда)
	
	ОткрытьФорму("Справочник.ВЕТИСПрисоединенныеФайлы.Форма.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЛичныйКабинетВЕТИС(Команда)
	
	Если ИнтеграцияВЕТИСКлиентСервер.РежимРаботыСТестовымКонтуромВЕТИС() Тогда
		ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку("https://t2-mercury.vetrf.ru/hs");
	Иначе
		ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку("https://mercury.vetrf.ru/hs");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияВЕТИСКлиент.ВыполнитьОбмен(
		ЭтотОбъект,
		ИнтеграцияВЕТИСКлиент.ОрганизацииВЕТИСДляОбмена(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбменОбработкаОжидания()
	
	ИнтеграцияВЕТИСКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникЕдиницыИзмеренияВЕТИС(Команда)
	
	ОткрытьФорму("Справочник.ЕдиницыИзмеренияВЕТИС.ФормаСписка");
	
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьСправочникУпаковкиВЕТИС(Команда)
	ОткрытьФорму("Справочник.УпаковкиВЕТИС.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВходящаяТранспортнаяОперацияВЕТИС(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ВходящаяТранспортнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов.ОткрытиеОсновногоСписка");
	
	ОткрытьФормуСпискаДокументов("Документ.ВходящаяТранспортнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВходящаяТранспортнаяОперацияВЕТИСОформите(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ВходящаяТранспортнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов.ОткрытиеСпискаРаспоряжений");
	
	ОткрытьФормуСпискаДокументов("Документ.ВходящаяТранспортнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов", Неопределено, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВходящаяТранспортнаяОперацияВЕТИСОтработайте(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ВходящаяТранспортнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов.ОткрытиеОсновногоСписка");
	
	ОткрытьФормуСпискаДокументов("Документ.ВходящаяТранспортнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВходящаяТранспортнаяОперацияВЕТИСОжидайте(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ВходящаяТранспортнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов.ОткрытиеОсновногоСписка");
	
	ОткрытьФормуСпискаДокументов("Документ.ВходящаяТранспортнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИнвентаризацияПродукцииВЕТИС(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ИнвентаризацияПродукцииВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИнвентаризацияПродукцииВЕТИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ИнвентаризацияПродукцииВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИнвентаризацияПродукцииВЕТИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ИнвентаризацияПродукцииВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИнвентаризацияПродукцииВЕТИСОформите(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ИнвентаризацияПродукцииВЕТИС.Форма.ФормаСпискаДокументов", Неопределено, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗапросСкладскогоЖурналаВЕТИС(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ЗапросСкладскогоЖурналаВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗапросСкладскогоЖурналаВЕТИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ЗапросСкладскогоЖурналаВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗапросСкладскогоЖурналаВЕТИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ЗапросСкладскогоЖурналаВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбъединениеЗаписейСкладскогоЖурналаВЕТИС(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбъединениеЗаписейСкладскогоЖурналаВЕТИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбъединениеЗаписейСкладскогоЖурналаВЕТИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсходящаяТранспортнаяОперацияВЕТИС(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ИсходящаяТранспортнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПроизводственнаяОперацияВЕТИС(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ПроизводственнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсходящаяТранспортнаяОперацияВЕТИСОформите(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ИсходящаяТранспортнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов", Неопределено, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсходящаяТранспортнаяОперацияВЕТИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ИсходящаяТранспортнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсходящаяТранспортнаяОперацияВЕТИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ИсходящаяТранспортнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПроизводственнаяОперацияВЕТИСОформите(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ПроизводственнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов", Неопределено, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПроизводственнаяОперацияВЕТИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ПроизводственнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПроизводственнаяОперацияВЕТИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.ПроизводственнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов", "ВсеТребующиеОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналПродукции(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"РегистрСведений.ОстаткиПродукцииВЕТИС.Форма.ФормаСписка",
		Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналВСДВЕТИС(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Форма.ФормаСписка",
		Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПанельСинхронизацииДанных(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"РегистрСведений.СинхронизацияКлассификаторовВЕТИС.Форма.ФормаСписка",
		Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаВЕТИС(Команда)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияВЕТИС.Форма.НастройкиВЕТИС", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеЭлементовФормы

&НаСервере
Процедура ОбновитьСпискиДокументов()
	
	// Заполним таблицу документов ВЕТИС.
	ТаблицаДокументы = Новый ТаблицаЗначений;
	ТаблицаДокументы.Колонки.Добавить("Метаданные");
	ТаблицаДокументы.Колонки.Добавить("Заголовок");
	ТаблицаДокументы.Колонки.Добавить("Оформите");
	ТаблицаДокументы.Колонки.Добавить("Отработайте");
	ТаблицаДокументы.Колонки.Добавить("Ожидайте");
	ТаблицаДокументы.Колонки.Добавить("ЕстьПравоЧтение");
	ТаблицаДокументы.Колонки.Добавить("ЕстьПравоДобавление");
	ТаблицаДокументы.Колонки.Добавить("ЕстьПравоРедактирование");
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ВходящаяТранспортнаяОперацияВЕТИС,
		НСтр("ru='Входящие транспортные операции ВетИС'"),
		Истина,  // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ИсходящаяТранспортнаяОперацияВЕТИС,
		НСтр("ru='Исходящие транспортные операции ВетИС'"),
		Истина,  // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ИнвентаризацияПродукцииВЕТИС,
		НСтр("ru='Инвентаризации продукции ВетИС'"),
		Истина,  // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ЗапросСкладскогоЖурналаВЕТИС,
		НСтр("ru='Запросы складского журнала ВетИС'"),
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС,
		НСтр("ru='Объединения записей складского журнала ВетИС'"),
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ПроизводственнаяОперацияВЕТИС,
		НСтр("ru='Производственные операции ВетИС'"),
		Истина,  // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
	
	// Инициализируем запрос для подсчета количества документов.
	ОрганизацииПредприятияВЕТИС = //Перенести: ИнтеграцияВЕТИС.
		ТаблицаОрганизацияПредприятие(ОрганизацииВЕТИС);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ОрганизацииПредприятияВЕТИС", ОрганизацииПредприятияВЕТИС);
	Запрос.УстановитьПараметр("БезОтбораПоОрганизацииВЕТИС", ОрганизацииПредприятияВЕТИС.Количество() = 0);
	Запрос.УстановитьПараметр("Ответственный",               ?(ЗначениеЗаполнено(Ответственный), Ответственный, Неопределено));
	Запрос.УстановитьПараметр("БезОтбораПоОтветственным",    НЕ ЗначениеЗаполнено(Ответственный));
	
	Запрос.УстановитьПараметр("ПустойТорговыйОбъект",
		ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа(Метаданные.ОпределяемыеТипы.ТорговыйОбъектВЕТИС.Имя));
	Запрос.УстановитьПараметр("ПустойПроизводственныйОбъект",
		ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа(Метаданные.ОпределяемыеТипы.ПроизводственныйОбъектВЕТИС.Имя));
	
	// Создадим общие временные таблицы для отборов в запросах подсчета количества документов.
	Запрос.Текст = ТекстЗапросаТаблицыДляОтборов();
	Запрос.Выполнить();
	
	Для Каждого ТекЭлемент Из ТаблицаДокументы Цикл
		
		Если НЕ ТекЭлемент.ЕстьПравоЧтение Тогда
			Элементы["Группа" + ТекЭлемент.Метаданные.Имя].Видимость = Ложь;
			Продолжить;
		КонецЕсли;
		
		МетаРеквизитОснование = ИнтеграцияИС.РеквизитДокументОснованиеДокументаИС(ТекЭлемент.Метаданные);
		
		Если МетаРеквизитОснование = Неопределено Тогда
			Запрос.УстановитьПараметр("ПустойДокументОснование", Неопределено);
		Иначе
			Запрос.УстановитьПараметр("ПустойДокументОснование", МетаРеквизитОснование.Тип.ПривестиЗначение(Неопределено));
		КонецЕсли;
		
		// Сформируем текст запроса выборки количества документов для каждого действия.
		МассивТекстовЗапросов = Новый Массив;
		ИндексЗапроса = -1;
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("Оформите",
			Новый Структура("Представление, ИндексЗапроса, Доступно", НСтр("ru='оформите'"), 	Неопределено, ТекЭлемент.ЕстьПравоДобавление));
		СтруктураДействий.Вставить("Отработайте",
			Новый Структура("Представление, ИндексЗапроса, Доступно", НСтр("ru='отработайте'"), Неопределено, ТекЭлемент.ЕстьПравоРедактирование));
		СтруктураДействий.Вставить("Ожидайте",
			Новый Структура("Представление, ИндексЗапроса, Доступно", НСтр("ru='ожидайте'"), 	Неопределено, ТекЭлемент.ЕстьПравоЧтение));
		
		Если ТекЭлемент.Оформите Тогда
			МассивТекстовЗапросов.Добавить(ТекстЗапросаОформите(ТекЭлемент.Метаданные));
			ИндексЗапроса = ИндексЗапроса + 1;
			СтруктураДействий.Оформите.ИндексЗапроса = ИндексЗапроса;
		КонецЕсли;
		
		Если ТекЭлемент.Отработайте Тогда
			МассивТекстовЗапросов.Добавить(ТекстЗапросаОтработайте(ТекЭлемент.Метаданные));
			ИндексЗапроса = ИндексЗапроса + 1;
			СтруктураДействий.Отработайте.ИндексЗапроса = ИндексЗапроса;
		КонецЕсли;
		
		Если ТекЭлемент.Ожидайте Тогда
			МассивТекстовЗапросов.Добавить(ТекстЗапросаОжидайте(ТекЭлемент.Метаданные));
			ИндексЗапроса = ИндексЗапроса + 1;
			СтруктураДействий.Ожидайте.ИндексЗапроса = ИндексЗапроса;
		КонецЕсли;
		
		// Получим запросом количество документов.
		ИмяДокумента      = ТекЭлемент.Метаданные.Имя;
		МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТекЭлемент.Метаданные.ПолноеИмя());
		ОбщееКоличество   = 0;
		
		Запрос.УстановитьПараметр("ВсеТребующиеОжидания", МенеджерДокумента.ВсеТребующиеОжидания(Истина));
		Запрос.УстановитьПараметр("ВсеТребующиеДействия", МенеджерДокумента.ВсеТребующиеДействия(Истина));
		
		Запрос.Текст = СтрСоединить(МассивТекстовЗапросов, Символы.ПС + ";" + Символы.ПС);
		
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		
		// Обновим тексты надписей действий с документом.
		Для Каждого КлючИЗначение Из СтруктураДействий Цикл
			
			ЭлементНадписи = Элементы.Найти("Открыть" + ИмяДокумента + КлючИЗначение.Ключ);
			
			Если ЭлементНадписи = Неопределено Тогда
				// Такое действие для документа не предусмотрено.
			ИначеЕсли КлючИЗначение.Значение.ИндексЗапроса = Неопределено Тогда
				ВывестиПоказатель(
					0,
					ЭлементНадписи,
					КлючИЗначение.Значение.Представление,
					КлючИЗначение.Значение.Доступно);
			Иначе
				ОбщееКоличество = ОбщееКоличество + ВывестиПоказатель(
					РезультатЗапроса[КлючИЗначение.Значение.ИндексЗапроса].Выбрать(),
					ЭлементНадписи,
					КлючИЗначение.Значение.Представление,
					КлючИЗначение.Значение.Доступно);
			КонецЕсли;
			
		КонецЦикла;
		
		// Обновим текст надписи самого документа.
		ВывестиПоказатель(
			ОбщееКоличество,
			Элементы["Открыть" + ИмяДокумента], 
			ТекЭлемент.Заголовок,
			Истина);
		
	КонецЦикла;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЕСТЬNULL(КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОчередьСообщенийВЕТИС.Сообщение), 0) КАК КоличествоСообщений
	|ИЗ
	|	РегистрСведений.ОчередьСообщенийВЕТИС КАК ОчередьСообщенийВЕТИС
	|ГДЕ
	|	ОчередьСообщенийВЕТИС.ХозяйствующийСубъект В(&Организация)
	|	ИЛИ &БезОтбораПоОрганизацииВЕТИС");
	Запрос.УстановитьПараметр("Организация", ОрганизацииПредприятияВЕТИС.ВыгрузитьКолонку("Организация"));
	Запрос.УстановитьПараметр("БезОтбораПоОрганизацииВЕТИС", ОрганизацииПредприятияВЕТИС.Количество() = 0);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() И Выборка.КоличествоСообщений > 0 Тогда
		ТекстЗаголовка = СтрШаблон(НСтр("ru='Есть сообщения (%1), ожидающие отправки в ВетИС. Выполните обмен.'"), Выборка.КоличествоСообщений);
		Элементы.НадписьСообщенияОжидающиеОтправки.Заголовок   = ТекстЗаголовка;
		Элементы.ДекорацияСообщенияОжидающиеОтправки.Видимость = Истина;
		Элементы.НадписьСообщенияОжидающиеОтправки.Видимость   = Истина;
	Иначе
		Элементы.ДекорацияСообщенияОжидающиеОтправки.Видимость = Ложь;
		Элементы.НадписьСообщенияОжидающиеОтправки.Видимость   = Ложь;
	КонецЕсли;
	
	СохранитьНастройкиФормы();
	
КонецПроцедуры


&НаСервере
Функция ТаблицаОрганизацияПредприятие(Дерево)
	
	ТаблицаОрганизацияПредприятиеВЕТИС = Новый ТаблицаЗначений;
	ТаблицаОрганизацияПредприятиеВЕТИС.Колонки.Добавить("Организация",Новый ОписаниеТипов("СправочникСсылка.ХозяйствующиеСубъектыВЕТИС"));
	ТаблицаОрганизацияПредприятиеВЕТИС.Колонки.Добавить("Предприятие",Новый ОписаниеТипов("СправочникСсылка.ПредприятияВЕТИС"));
	Для Каждого СтрокаОрганизация Из Дерево.ПолучитьЭлементы() Цикл 
		Для Каждого СтрокаПредприятие Из СтрокаОрганизация.ПолучитьЭлементы() Цикл 
			НоваяСтрока = ТаблицаОрганизацияПредприятиеВЕТИС.Добавить();
			НоваяСтрока.Организация = СтрокаОрганизация.ХозяйствующийСубъектПредприятиеВЕТИС;
			НоваяСтрока.Предприятие = СтрокаПредприятие.ХозяйствующийСубъектПредприятиеВЕТИС;
		КонецЦикла;
	КонецЦикла;
	Возврат ТаблицаОрганизацияПредприятиеВЕТИС;
	
КонецФункции

&НаСервере
Процедура ДобавитьДокумент(Таблица, Метаданные, Заголовок, Оформите, Отработайте, Ожидайте)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Метаданные  = Метаданные;
	НоваяСтрока.Заголовок   = Заголовок;
	
	НоваяСтрока.ЕстьПравоЧтение         = ПравоДоступа("Чтение", 		 Метаданные);
	НоваяСтрока.ЕстьПравоДобавление     = ПравоДоступа("Добавление", 	 Метаданные);
	НоваяСтрока.ЕстьПравоРедактирование = ПравоДоступа("Редактирование", Метаданные);
	
	НоваяСтрока.Оформите    = Оформите;
	НоваяСтрока.Отработайте = Отработайте;
	НоваяСтрока.Ожидайте    = Ожидайте;
	
КонецПроцедуры

&НаСервере
Функция ВывестиПоказатель(Выборка, Кнопка, ТекстПоказателя, ДействиеДоступно)
	
	Если ДействиеДоступно Тогда
		
		Если ТипЗнч(Выборка) = Тип("Число") Тогда
			КоличествоДокументов = Выборка;
		Иначе
			КоличествоДокументов = ?(Выборка.Следующий(), Выборка.КоличествоДокументов, 0);
		КонецЕсли;
		
		Если КоличествоДокументов > 0 Тогда
			ТекстЗаголовка = ТекстПоказателя + " (" + КоличествоДокументов + ")";
			ЦветТекста     = ЦветаСтиля.ЦветГиперссылкиГИСМ;
		Иначе
			ТекстЗаголовка = ТекстПоказателя;
			ЦветТекста     = ЦветаСтиля.ЦветТекстаНеТребуетВниманияГИСМ;
		КонецЕсли;
		
	Иначе
		
		КоличествоДокументов = 0;
		ТекстЗаголовка 		 = " ";
		ЦветТекста     		 = ЦветаСтиля.ЦветТекстаНеТребуетВниманияГИСМ;
		
	КонецЕсли;
	
	Кнопка.Заголовок   = ТекстЗаголовка;
	Кнопка.ЦветТекста  = ЦветТекста;
	Кнопка.Видимость   = Истина;
	Кнопка.Доступность = НЕ ПустаяСтрока(ТекстЗаголовка);
	
	Возврат КоличествоДокументов;
	
КонецФункции


&НаСервере
Функция ТекстЗапросаТаблицыДляОтборов()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ОрганизацииПредприятияВЕТИС.Организация КАК Организация,
	|	ОрганизацииПредприятияВЕТИС.Предприятие КАК Предприятие
	|ПОМЕСТИТЬ ФильтрОрганизации
	|ИЗ
	|	&ОрганизацииПредприятияВЕТИС КАК ОрганизацииПредприятияВЕТИС
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Предприятие
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ХозяйствующиеСубъектыВЕТИС.Контрагент КАК Контрагент,
	|	ПредприятияСубъекта.ТорговыйОбъект КАК ТорговыйОбъект,
	|	ПредприятияСубъекта.ПроизводственныйОбъект КАК ПроизводственныйОбъект
	|ПОМЕСТИТЬ ФильтрДанныеДокументаОснования
	|ИЗ
	|	Справочник.ХозяйствующиеСубъектыВЕТИС.Предприятия КАК ПредприятияСубъекта
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ХозяйствующиеСубъектыВЕТИС КАК ХозяйствующиеСубъектыВЕТИС
	|		ПО ПредприятияСубъекта.Ссылка = ХозяйствующиеСубъектыВЕТИС.Ссылка
	|	ЛЕВОЕ СОЕДИНЕНИЕ ФильтрОрганизации КАК ФильтрОрганизации
	|		ПО ФильтрОрганизации.Организация = ПредприятияСубъекта.Ссылка
	|			И ФильтрОрганизации.Предприятие = ПредприятияСубъекта.Предприятие
	|ГДЕ
	|	НЕ &БезОтбораПоОрганизацииВЕТИС И ФильтрОрганизации.Организация ЕСТЬ НЕ NULL";
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Функция ТекстЗапросаОтработайте(МетаданныеДокументаВЕТИС)
	
	ТекстЗапроса = ТекстаЗапросаКоличестваДокументовПоДальнейшемуДействию(
		МетаданныеДокументаВЕТИС,
		"&ВсеТребующиеДействия");
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Функция ТекстЗапросаОжидайте(МетаданныеДокументаВЕТИС)
	
	ТекстЗапроса = ТекстаЗапросаКоличестваДокументовПоДальнейшемуДействию(
		МетаданныеДокументаВЕТИС,
		"&ВсеТребующиеОжидания");
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Функция ТекстЗапросаОформите(МетаданныеДокументаВЕТИС)
	
	Если МетаданныеДокументаВЕТИС = Метаданные.Документы.ВходящаяТранспортнаяОперацияВЕТИС Тогда
		Возврат ТекстЗапросаВетеринарноСопроводительныеДокументы();
	КонецЕсли;
	
	ТипыДокументаОснования 	   = ИнтеграцияИС.РеквизитДокументОснованиеДокументаИС(МетаданныеДокументаВЕТИС).Тип.Типы();
	СтрокиСоединенияДокументов = Новый Массив;
	СтрокиОтбораДокументов 	   = Новый Массив;
	
	Для Каждого ТипОснования Из ТипыДокументаОснования Цикл
		
		МетаданныеОснования = Метаданные.НайтиПоТипу(ТипОснования);
		
		Если НЕ ПравоДоступа("Чтение", МетаданныеОснования) Тогда
			Продолжить;
		КонецЕсли;
		
		// Добавим соединение с документом-основанием для RLS.
		СтрокиСоединенияДокументов.Добавить("	ЛЕВОЕ СОЕДИНЕНИЕ Документ." + МетаданныеОснования.Имя + " КАК Документ" + МетаданныеОснования.Имя + "
			|		ПО Статусы.Основание = Документ" + МетаданныеОснования.Имя + ".Ссылка");
		
		СтрокиОтбораДокументов.Добавить("Документ" + МетаданныеОснования.Имя + ".Ссылка ЕСТЬ НЕ NULL");
		
	КонецЦикла;
	
	Если СтрокиОтбораДокументов.Количество() = 0 Тогда
		
		// Нет ни одного доступного документа-основания.
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	0 КАК КоличествоДокументов";
		
	Иначе
		
		ТекстСоединения = СтрСоединить(СтрокиСоединенияДокументов, Символы.ПС);
		ТекстОтбора 	= " И (" + СтрСоединить(СтрокиОтбораДокументов, Символы.ПС + "		ИЛИ ") + ")";
		
		ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Статусы.Основание) КАК КоличествоДокументов
		|ИЗ
		|	РегистрСведений.СтатусыОформленияДокументовВЕТИС КАК Статусы
		|%2
		|	ЛЕВОЕ СОЕДИНЕНИЕ ФильтрДанныеДокументаОснования КАК Отбор
		|		ПО Отбор.Контрагент = Статусы.Контрагент
		|			И ((Отбор.ТорговыйОбъект = Статусы.ТорговыйОбъект
		|					И Статусы.ТорговыйОбъект <> &ПустойТорговыйОбъект)
		|				ИЛИ (Отбор.ПроизводственныйОбъект = Статусы.ПроизводственныйОбъект
		|					И Статусы.ПроизводственныйОбъект <> &ПустойПроизводственныйОбъект))
		|ГДЕ
		|	Статусы.Документ = ЗНАЧЕНИЕ(Документ.%1.ПустаяСсылка)
		|	И Статусы.СтатусОформления В
		|		(ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовВЕТИС.НеОформлено),
		|		 ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовВЕТИС.ОформленоЧастично),
		|		 ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовВЕТИС.ЕстьОшибкиОформления),
		|		 ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовВЕТИС.ТребуетсяСопоставлениеНоменклатуры))
		|	И (&БезОтбораПоОрганизацииВЕТИС ИЛИ Отбор.Контрагент ЕСТЬ НЕ NULL)
		|	%3";
		
		ТекстЗапроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстЗапроса,
			МетаданныеДокументаВЕТИС.Имя,
			ТекстСоединения,
			ТекстОтбора);
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Функция ТекстЗапросаВетеринарноСопроводительныеДокументы()
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВСД.Ссылка) КАК КоличествоДокументов
	|ИЗ
	|	Справочник.ВетеринарноСопроводительныйДокументВЕТИС КАК ВСД
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыОформленияДокументовВЕТИС КАК Статусы
	|		ПО ВСД.Ссылка = Статусы.Основание
	|	ЛЕВОЕ СОЕДИНЕНИЕ ФильтрОрганизации КАК ФильтрОрганизации
	|		ПО ФильтрОрганизации.Организация = ВСД.ГрузополучательХозяйствующийСубъект
	|		 И ФильтрОрганизации.Предприятие = ВСД.ГрузополучательПредприятие
	|ГДЕ
	|	ВСД.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыВетеринарныхДокументовВЕТИС.Оформлен)
	|	И ВСД.Тип <> ЗНАЧЕНИЕ(Перечисление.ТипыВетеринарныхДокументовВЕТИС.Производственный)
	|	И НЕ ВСД.ПометкаУдаления
	|	И ЕСТЬNULL(Статусы.СтатусОформления, ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовВЕТИС.НеОформлено)) В
	|		(ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовВЕТИС.НеОформлено),
	|		 ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовВЕТИС.ОформленоЧастично),
	|		 ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовВЕТИС.ЕстьОшибкиОформления),
	|		 ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовВЕТИС.ТребуетсяСопоставлениеНоменклатуры))
	|	И (&БезОтбораПоОрганизацииВЕТИС ИЛИ ФильтрОрганизации.Организация ЕСТЬ НЕ NULL)";
	
	Возврат ТекстЗапроса;
	
КонецФункции


&НаСервере
Функция ТекстаЗапросаКоличестваДокументовПоДальнейшемуДействию(МетаданныеДокументаВЕТИС, ОтборДействия)
	
	МетаРеквизитОснование = ИнтеграцияИС.РеквизитДокументОснованиеДокументаИС(МетаданныеДокументаВЕТИС);
	
	Если МетаРеквизитОснование = Неопределено Тогда
		
		ТекстСоединения = "";
		ТекстОтбора 	= "";
		
	Иначе
		
		ТипыДокументаОснования 	   = МетаРеквизитОснование.Тип.Типы();
		СтрокиСоединенияДокументов = Новый Массив;
		СтрокиОтбораДокументов 	   = Новый Массив;
		
		Для Каждого ТипОснования Из ТипыДокументаОснования Цикл
			
			МетаданныеОснования = Метаданные.НайтиПоТипу(ТипОснования);
			
			Если НЕ ПравоДоступа("Чтение", МетаданныеОснования) Тогда
				Продолжить;
			КонецЕсли;
			
			// Добавим соединение с документом-основанием для RLS.
			СтрокиСоединенияДокументов.Добавить("	ЛЕВОЕ СОЕДИНЕНИЕ Документ." + МетаданныеОснования.Имя + " КАК Документ" + МетаданныеОснования.Имя + "
				|		ПО ДокументВЕТИС.ДокументОснование = Документ" + МетаданныеОснования.Имя + ".Ссылка");
			
			СтрокиОтбораДокументов.Добавить("Документ" + МетаданныеОснования.Имя + ".Ссылка ЕСТЬ НЕ NULL");
			
		КонецЦикла;
		
		Если СтрокиОтбораДокументов.Количество() = 0 Тогда
			
			// Нет ни одного доступного документа-основания.
			ТекстЗапроса =
			"ВЫБРАТЬ
			|	0 КАК КоличествоДокументов";
			
			Возврат ТекстЗапроса;
			
		КонецЕсли;
		
		СтрокиОтбораДокументов.Добавить("ДокументВЕТИС.ДокументОснование = &ПустойДокументОснование");
		
		ТекстСоединения = СтрСоединить(СтрокиСоединенияДокументов, Символы.ПС);
		ТекстОтбора 	= " И (" + СтрСоединить(СтрокиОтбораДокументов, Символы.ПС + "		ИЛИ ") + ")";
		
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыДокументовВЕТИС.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыДокументовВЕТИС КАК СтатусыДокументовВЕТИС
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.%1 КАК ДокументВЕТИС
	|		ПО СтатусыДокументовВЕТИС.Документ = ДокументВЕТИС.Ссылка
	|%5
	|	ЛЕВОЕ СОЕДИНЕНИЕ ФильтрОрганизации КАК ФильтрОрганизации
	|		ПО ФильтрОрганизации.Организация = ДокументВЕТИС.%2
	|			И ФильтрОрганизации.Предприятие = ДокументВЕТИС.%3
	|ГДЕ
	|	СтатусыДокументовВЕТИС.ДальнейшееДействие1 В (%4)
	|	И НЕ ДокументВЕТИС.ПометкаУдаления
	|	И (&БезОтбораПоОрганизацииВЕТИС ИЛИ ФильтрОрганизации.Организация ЕСТЬ НЕ NULL)
	|	И (&БезОтбораПоОтветственным ИЛИ ДокументВЕТИС.Ответственный = &Ответственный)
	|	%6";
	
	СтруктураПолей = ПоляДокументаВЕТИСДляОбмена(МетаданныеДокументаВЕТИС);
	
	ТекстЗапроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстЗапроса,
		МетаданныеДокументаВЕТИС.Имя,
		СтруктураПолей.ИмяПоляХозяйствующийСубъект,
		СтруктураПолей.ИмяПоляПредприятие,
		ОтборДействия,
		ТекстСоединения,
		ТекстОтбора);
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Функция ПоляДокументаВЕТИСДляОбмена(МетаданныеДокументаВЕТИС)
	
	СтруктураПолей = Новый Структура;
	
	Если МетаданныеДокументаВЕТИС = Метаданные.Документы.ВходящаяТранспортнаяОперацияВЕТИС Тогда
		
		СтруктураПолей.Вставить("ИмяПоляХозяйствующийСубъект", "ГрузополучательХозяйствующийСубъект");
		СтруктураПолей.Вставить("ИмяПоляПредприятие", 		   "ГрузополучательПредприятие");
		
	ИначеЕсли МетаданныеДокументаВЕТИС = Метаданные.Документы.ИсходящаяТранспортнаяОперацияВЕТИС Тогда
		
		СтруктураПолей.Вставить("ИмяПоляХозяйствующийСубъект", "ГрузоотправительХозяйствующийСубъект");
		СтруктураПолей.Вставить("ИмяПоляПредприятие", 		   "ГрузоотправительПредприятие");
		
	Иначе
		
		СтруктураПолей.Вставить("ИмяПоляХозяйствующийСубъект", "ХозяйствующийСубъект");
		СтруктураПолей.Вставить("ИмяПоляПредприятие", 		   "Предприятие");
		
	КонецЕсли;
	
	Возврат СтруктураПолей;
	
КонецФункции

#КонецОбласти

#Область ДействияСНастройкамиФормы

&НаСервере
Процедура СохранитьНастройкиФормы()
	
	ЭтоСтраницаОднаОрганизация = (Элементы.СтраницыОтборОрганизацияВЕТИС.ТекущаяСтраница = Элементы.СтраницаОтборОрганизацияВЕТИС);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПанельОбменСВЕТИС", "Ответственный",    Ответственный);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПанельОбменСВЕТИС", "ОрганизацияВЕТИС", ОрганизацияВЕТИС);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПанельОбменСВЕТИС", "ОрганизацииВЕТИСПредставление", ОрганизацииВЕТИСПредставление);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПанельОбменСВЕТИС", "ОрганизацииВЕТИС", ИнтеграцияВЕТИСКлиентСервер.ДеревоОтбораОрганизацииВЕТИСВМассивСтруктур(ОрганизацииВЕТИС,,Ложь,ЭтоСтраницаОднаОрганизация));
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиФормы()
	
	Ответственный                 = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПанельОбменСВЕТИС", "Ответственный",    Ответственный);
	
	ОрганизацииВЕТИССохраненные   = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПанельОбменСВЕТИС", "ОрганизацииВЕТИС", Неопределено);
	ИнтеграцияВЕТИСКлиентСервер.НастроитьОтборПоОрганизацииВЕТИС(ЭтотОбъект, ОрганизацииВЕТИССохраненные, "Отбор", "Отбор");
	ИнтеграцияВЕТИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект, "Отбор");
	
	ОрганизацияВЕТИС              = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПанельОбменСВЕТИС", "ОрганизацияВЕТИС", ОрганизацияВЕТИС);
	ОрганизацииВЕТИСПредставление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПанельОбменСВЕТИС", "ОрганизацииВЕТИСПредставление", ОрганизацииВЕТИСПредставление);
	
КонецПроцедуры

#КонецОбласти

#Область ДействияСФормамиДокументовВЕТИС

&НаКлиенте
Процедура ОткрытьФормуСпискаДокументов(ИмяФормы,
	                                   ДальнейшееДействиеВЕТИС,
	                                   ОткрытьРаспоряжения = Ложь,
	                                   ИмяПоляОтветственный = Неопределено,
	                                   ИмяПоляОрганизации = Неопределено,
	                                   ИмяПоляОрганизация = Неопределено,
	                                   ИмяПоляПредставления = Неопределено)
	
	СтруктураБыстрогоОтбора = Новый Структура();
	ПараметрыФормы = Новый Структура;
	
	Если ОткрытьРаспоряжения Тогда
		ПараметрыФормы.Вставить("ОткрытьРаспоряжения", Истина);
	Иначе
		СтруктураБыстрогоОтбора.Вставить("ДальнейшееДействиеВЕТИС", ДальнейшееДействиеВЕТИС);
	КонецЕсли;
	
	Если ИмяПоляОтветственный = Неопределено Тогда
		ИмяПоляОтветственный = "Ответственный";
	КонецЕсли;
	
	Если ИмяПоляОрганизации = Неопределено Тогда
		ИмяПоляОрганизации = "ОрганизацииВЕТИС";
	КонецЕсли;
	
	Если ИмяПоляОрганизация = Неопределено Тогда
		ИмяПоляОрганизация = "ОрганизацияВЕТИС";
	КонецЕсли;
	
	Если ИмяПоляПредставления = Неопределено Тогда
		ИмяПоляПредставления = "ОрганизацииВЕТИСПредставление";
	КонецЕсли;
	
	СтруктураБыстрогоОтбора.Вставить(ИмяПоляОтветственный, Ответственный);
	СтруктураБыстрогоОтбора.Вставить(ИмяПоляОрганизации,   ОрганизацииВЕТИС);
	СтруктураБыстрогоОтбора.Вставить(ИмяПоляОрганизация,   ОрганизацияВЕТИС);
	СтруктураБыстрогоОтбора.Вставить(ИмяПоляПредставления, ОрганизацииВЕТИСПредставление);
	
	ПараметрыФормы.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	ОткрытьФорму(ИмяФормы, ПараметрыФормы,,,,,);
	
КонецПроцедуры

#КонецОбласти

#Область ОтборПоОрганизацииВЕТИС

&НаКлиенте
Процедура ПослеВыбораОрганизацииВЕТИС(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
