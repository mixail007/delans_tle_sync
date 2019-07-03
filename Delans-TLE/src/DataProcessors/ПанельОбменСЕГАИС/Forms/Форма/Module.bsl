
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ПараметрыПодключенияКЕГАИС.Видимость             = ПравоДоступа("Чтение", Метаданные.РегистрыСведений.НастройкиОбменаЕГАИС);
	Элементы.КлассификаторАлкогольнойПродукцииЕГАИС.Видимость = ПравоДоступа("Чтение", Метаданные.Справочники.КлассификаторАлкогольнойПродукцииЕГАИС);
	Элементы.КлассификаторОрганизацийЕГАИС.Видимость          = ПравоДоступа("Чтение", Метаданные.Справочники.КлассификаторОрганизацийЕГАИС);
	Элементы.Справки1ЕГАИС.Видимость                          = ПравоДоступа("Чтение", Метаданные.Справочники.Справки1ЕГАИС);
	Элементы.Справки2ЕГАИС.Видимость                          = ПравоДоступа("Чтение", Метаданные.Справочники.Справки2ЕГАИС);
	
	ИнтеграцияЕГАИС.УстановитьВидимостьКомандыВыполнитьОбмен(ЭтотОбъект, "ФормаВыполнитьОбмен");
	
	ВосстановитьНастройкиФормы();
	ОбновитьСпискиДокументов();
	
	Если ОбщегоНазначенияКлиентСервер.РежимОтладки() Тогда
		Элементы.ОткрытьНастройкиРежимаОтладки.Видимость = Истина;
		Элементы.ИзменитьФорму.ТолькоВоВсехДействиях = Истина;
	КонецЕсли;
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НадписьСообщенияОжидающиеОтправкиНажатие(Элемент)
	
	Если ОрганизацииЕГАИС.Количество() > 0 Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("ОрганизацияЕГАИС", ОрганизацииЕГАИС.ВыгрузитьЗначения());
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Отбор", Отбор);
		
	Иначе
		
		ПараметрыОткрытияФормы = Неопределено;
		
	КонецЕсли;
	
	ОткрытьФорму(
		"РегистрСведений.ОчередьПередачиДанныхЕГАИС.ФормаСписка",
		ПараметрыОткрытияФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

#Область ОтборПоОрганизацииЕГАИС

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСПриИзменении(Элемент)
	
	Элементы.ОткрытьWebИнтерфейсУТМ.Видимость = ЗначениеЗаполнено(ОрганизацииЕГАИС);
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ОрганизацииЕГАИС, Ложь, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы(),
		Новый ОписаниеОповещения("ПослеВыбораОрганизацииЕГАИС", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, Неопределено, Ложь, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ВыбранноеЗначение, Ложь, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры


&НаКлиенте
Процедура ОтборОрганизацияЕГАИСПриИзменении(Элемент)
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ОрганизацияЕГАИС, Ложь, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(
		ЭтотОбъект,
		"Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы(),
		Новый ОписаниеОповещения("ПослеВыбораОрганизацииЕГАИС", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, Неопределено, Ложь, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ВыбранноеЗначение, Ложь, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПараметрыПодключенияКЕГАИС(Команда)
	
	ОткрытьФорму("РегистрСведений.НастройкиОбменаЕГАИС.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КлассификаторАлкогольнойПродукцииЕГАИС(Команда)
	
	ОткрытьФорму("Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыАлкогольнойПродукции(Команда)
	
	ОткрытьФорму("Справочник.ВидыАлкогольнойПродукции.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КлассификаторОрганизацийЕГАИС(Команда)
	
	ОткрытьФорму("Справочник.КлассификаторОрганизацийЕГАИС.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Справки1ЕГАИС(Команда)
	
	ОткрытьФорму("Справочник.Справки1ЕГАИС.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Справки2ЕГАИС(Команда)
	
	ОткрытьФорму("Справочник.Справки2ЕГАИС.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыУпаковок(Команда)
	
	ОткрытьФорму("Справочник.ШтрихкодыУпаковокТоваров.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

#Область ТТНВходщиеЕГАИС

&НаКлиенте
Процедура ОткрытьТТНВходящаяЕГАИС(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ТТНВходящаяЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТТНВходящаяЕГАИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ТТНВходящаяЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТТНВходящаяЕГАИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ТТНВходящаяЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

#КонецОбласти

#Область ТТНИсходящаяЕГАИС

&НаКлиенте
Процедура ОткрытьТТНИсходящаяЕГАИС(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ТТНИсходящаяЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТТНИсходящаяЕГАИСОформите(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ТТНИсходящаяЕГАИС.Форма.ФормаСпискаДокументов",
		Неопределено,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТТНИсходящаяЕГАИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ТТНИсходящаяЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТТНИсходящаяЕГАИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ТТНИсходящаяЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

#КонецОбласти

#Область АктПостановкиНаБалансЕГАИС

&НаКлиенте
Процедура ОткрытьАктПостановкиНаБалансЕГАИС(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.АктПостановкиНаБалансЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАктПостановкиНаБалансЕГАИСОформите(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.АктПостановкиНаБалансЕГАИС.Форма.ФормаСпискаДокументов",
		Неопределено,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАктПостановкиНаБалансЕГАИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.АктПостановкиНаБалансЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАктПостановкиНаБалансЕГАИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.АктПостановкиНаБалансЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

#КонецОбласти

#Область АктСписанияЕГАИС

&НаКлиенте
Процедура ОткрытьАктСписанияЕГАИС(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.АктСписанияЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАктСписанияЕГАИСОформите(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.АктСписанияЕГАИС.Форма.ФормаСпискаДокументов",
		Неопределено,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАктСписанияЕГАИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.АктСписанияЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАктСписанияЕГАИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.АктСписанияЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

#КонецОбласти

#Область ПередачаВРегистр2ЕГАИС

&НаКлиенте
Процедура ОткрытьПередачаВРегистр2ЕГАИС(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ПередачаВРегистр2ЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПередачаВРегистр2ЕГАИСОформите(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ПередачаВРегистр2ЕГАИС.Форма.ФормаСпискаДокументов",
		Неопределено,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПередачаВРегистр2ЕГАИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ПередачаВРегистр2ЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПередачаВРегистр2ЕГАИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ПередачаВРегистр2ЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

#КонецОбласти

#Область ВозвратИзРегистра2ЕГАИС

&НаКлиенте
Процедура ОткрытьВозвратИзРегистра2ЕГАИС(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ВозвратИзРегистра2ЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВозвратИзРегистра2ЕГАИСОформите(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ВозвратИзРегистра2ЕГАИС.Форма.ФормаСпискаДокументов",
		Неопределено,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВозвратИзРегистра2ЕГАИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ВозвратИзРегистра2ЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВозвратИзРегистра2ЕГАИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ВозвратИзРегистра2ЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

#КонецОбласти

#Область ЧекЕГАИС

&НаКлиенте
Процедура ОткрытьЧекЕГАИС(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ЧекЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЧекЕГАИСОформите(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ЧекЕГАИС.Форма.ФормаСпискаДокументов",
		Неопределено,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЧекЕГАИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ЧекЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЧекЕГАИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ЧекЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

#КонецОбласти

#Область ЧекЕГАИСВозврат

&НаКлиенте
Процедура ОткрытьЧекЕГАИСВозврат(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ЧекЕГАИСВозврат.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЧекЕГАИСВозвратОформите(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ЧекЕГАИСВозврат.Форма.ФормаСпискаДокументов",
		Неопределено,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЧекЕГАИСВозвратОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ЧекЕГАИСВозврат.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЧекЕГАИСВозвратОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ЧекЕГАИСВозврат.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

#КонецОбласти

#Область ОстаткиЕГАИС

&НаКлиенте
Процедура ОткрытьОстаткиЕГАИС(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ОстаткиЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОстаткиЕГАИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ОстаткиЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОстаткиЕГАИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ОстаткиЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

#КонецОбласти

#Область ЗапросыАкцизныхМарокЕГАИС

&НаКлиенте
Процедура ОткрытьЗапросыАкцизныхМарокЕГАИС(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ЗапросАкцизныхМарокЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗапросыАкцизныхМарокЕГАИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ЗапросАкцизныхМарокЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗапросыАкцизныхМарокЕГАИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ЗапросАкцизныхМарокЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

#КонецОбласти

#Область ОтчетыЕГАИС

&НаКлиенте
Процедура ОткрытьОтчетЕГАИС(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ОтчетЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетЕГАИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ОтчетЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетЕГАИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.ОтчетЕГАИС.Форма.ФормаСпискаДокументов",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОткрытьПротоколОбменаЕГАИС(Команда)
	
	ПараметрыФормы = Новый Структура;
	
	ОткрытьФорму("Справочник.ЕГАИСПрисоединенныеФайлы.Форма.ФормаСписка", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияЕГАИСКлиент.ВыполнитьОбмен(
		ИнтеграцияЕГАИСКлиент.ОрганизацииЕГАИСДляОбмена(
			ЭтотОбъект),,
		ЭтотОбъект.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьWebИнтерфейсУТМ(Команда)
	
	ОчиститьСообщения();
	
	Если ОрганизацииЕГАИС.Количество() = 0 Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не заполнено поле ""Организация ЕГАИС""'"),,
			"ОрганизацияЕГАИС");
		
	ИначеЕсли ОрганизацииЕГАИС.Количество() = 1 Тогда
		
		ВыполнитьОткрытьWebИнтерфейсУТМ(ОрганизацияЕГАИС);
		
	ИначеЕсли ОрганизацииЕГАИС.Количество() > 1 Тогда
		
		ОрганизацииЕГАИС.ПоказатьВыборЭлемента(
			Новый ОписаниеОповещения(
				"ОбработатьВыборОрганизацииЕГАИСДляОткрытияWebИнтерфейсаУТМ", ЭтотОбъект),
				НСтр("ru = 'Выбор организации ЕГАИС'"),
				ОрганизацииЕГАИС.Получить(0).Значение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиРежимаОтладки(Команда)
	
	ОткрытьФорму("Обработка.ПанельОбменСЕГАИС.Форма.НастройкиРежимаОтладки");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеОткрытияWebИнтерфейсаУТМ(Результат, ДополнительныеПараметры) Экспорт
	Возврат;
КонецПроцедуры

&НаСервереБезКонтекста
Функция АдресИПортУТМ(ОрганизацияЕГАИС)
	
	ВозвращаемоеЗначение = Неопределено;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НастройкиОбменаЕГАИС.АдресУТМ КАК АдресУТМ,
	|	НастройкиОбменаЕГАИС.ПортУТМ КАК ПортУТМ
	|ИЗ
	|	РегистрСведений.НастройкиОбменаЕГАИС КАК НастройкиОбменаЕГАИС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|		ПО НастройкиОбменаЕГАИС.ИдентификаторФСРАР = КлассификаторОрганизацийЕГАИС.Код
	|		И КлассификаторОрганизацийЕГАИС.Ссылка = &ОрганизацияЕГАИС
	|ГДЕ
	|	НастройкиОбменаЕГАИС.РабочееМесто = &РабочееМесто
	|	ИЛИ НастройкиОбменаЕГАИС.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМеста.ПустаяСсылка)");
	
	Запрос.УстановитьПараметр("РабочееМесто",     МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());
	Запрос.УстановитьПараметр("ОрганизацияЕГАИС", ОрганизацияЕГАИС);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ВозвращаемоеЗначение = Новый Структура;
		ВозвращаемоеЗначение.Вставить("АдресУТМ", Выборка.АдресУТМ);
		ВозвращаемоеЗначение.Вставить("ПортУТМ",  Выборка.ПортУТМ);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаСервере
Процедура СохранитьНастройкиФормы()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПанельОбменСЕГАИС", "ОрганизацииЕГАИС", ОрганизацииЕГАИС);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПанельОбменСЕГАИС", "Ответственный",    Ответственный);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиФормы()
	
	ОрганизацииЕГАИС = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПанельОбменСЕГАИС", "ОрганизацииЕГАИС", ОрганизацииЕГАИС);
	Ответственный    = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПанельОбменСЕГАИС", "Ответственный",    Ответственный);
	
	ИнтеграцияЕГАИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект, "Отбор");
	
КонецПроцедуры

Процедура ДобавитьДокумент(Таблица, Метаданные, Заголовок, Оформите, Отработайте, Ожидайте)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Метаданные  = Метаданные;
	НоваяСтрока.Заголовок   = Заголовок;
	НоваяСтрока.Оформите    = Оформите;
	НоваяСтрока.Отработайте = Отработайте;
	НоваяСтрока.Ожидайте    = Ожидайте;
	
	НоваяСтрока.ЕстьПравоЧтение         = ПравоДоступа("Чтение", Метаданные);
	НоваяСтрока.ЕстьПравоДобавление     = ПравоДоступа("Добавление", Метаданные);
	НоваяСтрока.ЕстьПравоРедактирование = ПравоДоступа("Редактирование", Метаданные);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСпискиДокументов()
	
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
		Метаданные.Документы.ТТНВходящаяЕГАИС,
		НСтр("ru = 'Товарно-транспортные накладные ЕГАИС (входящие)'"),
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ТТНИсходящаяЕГАИС,
		НСтр("ru = 'Товарно-транспортные накладные ЕГАИС (исходящие)'"),
		Истина, Истина, Истина);
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.АктПостановкиНаБалансЕГАИС,
		НСтр("ru = 'Акты постановки на баланс ЕГАИС'"),
		Истина, Истина, Истина);
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.АктСписанияЕГАИС,
		НСтр("ru = 'Акты списания ЕГАИС'"),
		Истина, Истина, Истина);
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ПередачаВРегистр2ЕГАИС,
		НСтр("ru = 'Передачи в регистр №2 ЕГАИС'"),
		Истина, Истина, Истина);
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ВозвратИзРегистра2ЕГАИС,
		НСтр("ru = 'Возвраты из регистра №2 ЕГАИС'"),
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ОстаткиЕГАИС,
		НСтр("ru = 'Остатки ЕГАИС'"),
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ОтчетЕГАИС,
		НСтр("ru = 'Отчеты ЕГАИС'"),
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ЗапросАкцизныхМарокЕГАИС,
		НСтр("ru = 'Запросы акцизных марок ЕГАИС'"),
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ЧекЕГАИС,
		НСтр("ru = 'Чеки ЕГАИС'"),
		Истина, Истина, Истина);
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ЧекЕГАИСВозврат,
		НСтр("ru = 'Чеки ЕГАИС на возврат'"),
		Истина, Истина, Истина);
	
	ТекстЗапроса = "";
	
	ВсеТребующиеОжидания = Новый Массив;
	ВсеТребующиеДействия = Новый Массив;
	
	Для Каждого ТекЭлемент Из ТаблицаДокументы Цикл
		
		Если Не ТекЭлемент.ЕстьПравоЧтение Тогда
			Элементы["Группа" + ТекЭлемент.Метаданные.Имя].Видимость = Ложь;
			Продолжить;
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТекЭлемент.Метаданные.ПолноеИмя());
		
		Для Каждого Элемент Из МенеджерОбъекта.ВсеТребующиеОжидания(Истина) Цикл
			Если ВсеТребующиеОжидания.Найти(Элемент) = Неопределено Тогда
				ВсеТребующиеОжидания.Добавить(Элемент);
			КонецЕсли;
		КонецЦикла;
		Для Каждого Элемент Из МенеджерОбъекта.ВсеТребующиеДействия(Истина) Цикл
			Если ВсеТребующиеДействия.Найти(Элемент) = Неопределено Тогда
				ВсеТребующиеДействия.Добавить(Элемент);
			КонецЕсли;
		КонецЦикла;
		
		Если ТекЭлемент.Оформите И ТекЭлемент.ЕстьПравоДобавление Тогда
			ТекстЗапроса = ТекстЗапроса + МенеджерОбъекта.ТекстЗапросаПанельОбменСЕГАИСОформите();
		КонецЕсли;
		
		Если ТекЭлемент.Отработайте И ТекЭлемент.ЕстьПравоРедактирование Тогда
			ТекстЗапроса = ТекстЗапроса + МенеджерОбъекта.ТекстЗапросаПанельОбменСЕГАИСОтработайте();
		КонецЕсли;
		
		Если ТекЭлемент.Ожидайте Тогда
			ТекстЗапроса = ТекстЗапроса + МенеджерОбъекта.ТекстЗапросаПанельОбменСЕГАИСОжидайте();
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ТекстЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ОрганизацияЕГАИС",            ОрганизацииЕГАИС);
	ПараметрыЗапроса.Вставить("БезОтбораПоОрганизацииЕГАИС", ОрганизацииЕГАИС.Количество() = 0);
	ПараметрыЗапроса.Вставить("Ответственный",        ?(ЗначениеЗаполнено(Ответственный), Ответственный,    Неопределено));
	ПараметрыЗапроса.Вставить("ВсеТребующиеОжидания", ВсеТребующиеОжидания);
	ПараметрыЗапроса.Вставить("ВсеТребующиеДействия", ВсеТребующиеДействия);
	
	Для Каждого ТекПараметр Из ПараметрыЗапроса Цикл
		Запрос.УстановитьПараметр(ТекПараметр.Ключ, ТекПараметр.Значение);
	КонецЦикла;
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ИндексЗапроса = 0;
	Для ТекИндекс = 0 По ТаблицаДокументы.Количество() - 1 Цикл
		
		ТекЭлемент = ТаблицаДокументы[ТекИндекс];
		ИмяДокумента = ТекЭлемент.Метаданные.Имя;
		
		Если НЕ ТекЭлемент.ЕстьПравоЧтение Тогда
			Продолжить;
		КонецЕсли;
		
		ОбщееКоличество  = 0;
		ТоваровКПередаче = 0;
		
		ЕстьПередачаВРегистр2ЕГАИС = Ложь;
		
		Если ТекЭлемент.Оформите Тогда
			КнопкаОформите = Элементы["Открыть" + ИмяДокумента + "Оформите"];
			ПустаяОформите = Элементы["Открыть" + ИмяДокумента + "ОформитеДекорация"];
			ТекстОформите  = НСтр("ru = 'оформите'");
			
			Если ТекЭлемент.ЕстьПравоДобавление Тогда
				Если ТекЭлемент.Метаданные = Метаданные.Документы.ПередачаВРегистр2ЕГАИС Тогда
					ЕстьПередачаВРегистр2ЕГАИС = Истина;
					ТоваровКПередаче = ВывестиПоказатель(
					РезультатЗапроса[ИндексЗапроса].Выбрать(), КнопкаОформите, ТекстОформите, Истина);
				ИначеЕсли ТекЭлемент.Метаданные = Метаданные.Документы.АктПостановкиНаБалансЕГАИС Тогда
					ИндексЗапроса = ИндексЗапроса + 2;
					
					Выборка = РезультатЗапроса[ИндексЗапроса].Выбрать();
					КоличествоДокументов = ?(Выборка.Следующий(), Выборка.КоличествоДокументов, 0);
					
					Если Цел(КоличествоДокументов) > 0 Тогда
						ОбщееКоличество = ОбщееКоличество + ВывестиПоказатель(Цел(КоличествоДокументов), КнопкаОформите, ТекстОформите);
					ИначеЕсли КоличествоДокументов > 0 Тогда
						ОбщееКоличество = ОбщееКоличество + ВывестиПоказатель(1, КнопкаОформите, ТекстОформите, Истина);
					Иначе
						ОбщееКоличество = ОбщееКоличество + ВывестиПоказатель(0, КнопкаОформите, ТекстОформите);
					КонецЕсли;
				Иначе
					ОбщееКоличество = ОбщееКоличество + ВывестиПоказатель(
					РезультатЗапроса[ИндексЗапроса].Выбрать(), КнопкаОформите, ТекстОформите);
				КонецЕсли;
				
				ИндексЗапроса = ИндексЗапроса + 1;
				
				ПустаяОформите.Видимость = Ложь;
			Иначе
				КнопкаОформите.Видимость = Ложь;
				ПустаяОформите.Видимость = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ТекЭлемент.Отработайте Тогда
			КнопкаОтработайте = Элементы["Открыть" + ИмяДокумента + "Отработайте"];
			ПустаяОтработайте = Элементы["Открыть" + ИмяДокумента + "ОтработайтеДекорация"];
			ТекстОтработайте  = НСтр("ru = 'отработайте'");
			
			Если ТекЭлемент.ЕстьПравоРедактирование Тогда
				ОбщееКоличество = ОбщееКоличество + ВывестиПоказатель(
					РезультатЗапроса[ИндексЗапроса].Выбрать(), КнопкаОтработайте, ТекстОтработайте);
				
				ИндексЗапроса = ИндексЗапроса + 1;
				
				ПустаяОтработайте.Видимость = Ложь;
			Иначе
				КнопкаОтработайте.Видимость = Ложь;
				ПустаяОтработайте.Видимость = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ТекЭлемент.Ожидайте Тогда
			КнопкаОжидайте = Элементы["Открыть" + ИмяДокумента + "Ожидайте"];
			ТекстОжидайте  = НСтр("ru = 'ожидайте'");
			
			ОбщееКоличество = ОбщееКоличество + ВывестиПоказатель(
				РезультатЗапроса[ИндексЗапроса].Выбрать(), КнопкаОжидайте, ТекстОжидайте);
				
			ИндексЗапроса = ИндексЗапроса + 1;
		КонецЕсли;
		
		Если ЕстьПередачаВРегистр2ЕГАИС И ОбщееКоличество = 0 И ТоваровКПередаче > 0 Тогда
			ВывестиПоказатель(
				1,
				Элементы["Открыть" + ИмяДокумента],
				ТекЭлемент.Заголовок, Истина);
		Иначе
			ВывестиПоказатель(
				ОбщееКоличество,
				Элементы["Открыть" + ИмяДокумента], 
				ТекЭлемент.Заголовок);
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЕСТЬNULL(КОЛИЧЕСТВО (РАЗЛИЧНЫЕ ОчередьПередачиДанныхЕГАИС.Сообщение), 0) КАК КоличествоСообщений
	|ИЗ
	|	РегистрСведений.ОчередьПередачиДанныхЕГАИС КАК ОчередьПередачиДанныхЕГАИС
	|ГДЕ
	|	ОчередьПередачиДанныхЕГАИС.ОрганизацияЕГАИС В(&ОрганизацияЕГАИС)
	|	ИЛИ &БезОтбораПоОрганизацииЕГАИС
	|");
	Запрос.УстановитьПараметр("ОрганизацияЕГАИС",            ОрганизацииЕГАИС);
	Запрос.УстановитьПараметр("БезОтбораПоОрганизацииЕГАИС", ОрганизацииЕГАИС.Количество() = 0);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() И Выборка.КоличествоСообщений > 0 Тогда
		ТекстЗаголовка = СтрШаблон(НСтр("ru = 'Есть сообщения (%1), ожидающие отправки в ЕГАИС. Выполните обмен.'"), Выборка.КоличествоСообщений);
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
Функция ВывестиПоказатель(Выборка, Кнопка, ТекстПоказателя, БезКоличества = Ложь)
	
	Если ТипЗнч(Выборка) = Тип("Число") Тогда
		КоличествоДокументов = Выборка;
	Иначе
		КоличествоДокументов = ?(Выборка.Следующий(), Выборка.КоличествоДокументов, 0);
	КонецЕсли;
	
	Если КоличествоДокументов > 0 Тогда
		Если БезКоличества Тогда
			ТекстЗаголовка = ТекстПоказателя;
		Иначе
			ТекстЗаголовка = ТекстПоказателя + " (" + КоличествоДокументов + ")";
		КонецЕсли;
		ЦветТекста = ЦветаСтиля.ЦветГиперссылкиГИСМ;
	Иначе
		ТекстЗаголовка = ТекстПоказателя;
		ЦветТекста = ЦветаСтиля.ЦветТекстаНеТребуетВниманияГИСМ;
	КонецЕсли;
	
	Кнопка.Заголовок = ТекстЗаголовка;
	Кнопка.ЦветТекста = ЦветТекста;
	Кнопка.Видимость = Истина;
	
	Возврат КоличествоДокументов;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуСпискаДокументов(ИмяФормы,
	                                   ДальнейшееДействиеЕГАИС,
	                                   ОткрытьРаспоряжения = Ложь,
	                                   ИмяПоляОтветственный = Неопределено,
	                                   ИмяПоляОрганизация = Неопределено)
	
	СтруктураБыстрогоОтбора = Новый Структура();
	ПараметрыФормы = Новый Структура;
	
	Если ОткрытьРаспоряжения Тогда
		ПараметрыФормы.Вставить("ОткрытьРаспоряжения", Истина);
	Иначе
		СтруктураБыстрогоОтбора.Вставить("ДальнейшееДействиеЕГАИС", ДальнейшееДействиеЕГАИС);
	КонецЕсли;
	
	Если ИмяПоляОтветственный = Неопределено Тогда
		ИмяПоляОтветственный = "Ответственный";
	КонецЕсли;
	
	Если ИмяПоляОрганизация = Неопределено Тогда
		ИмяПоляОрганизация = "ОрганизацияЕГАИС";
	КонецЕсли;
	
	СтруктураБыстрогоОтбора.Вставить(ИмяПоляОтветственный, Ответственный);
	СтруктураБыстрогоОтбора.Вставить(ИмяПоляОрганизация,   ОрганизацииЕГАИС);
	
	ПараметрыФормы.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	ОткрытьФорму(ИмяФормы, ПараметрыФормы,,,,,);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораОрганизацииЕГАИС(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОткрытьWebИнтерфейсУТМ(ВыбраннаяОрганизацияЕГАИС)
	
	ПараметрыУТМ = АдресИПортУТМ(ВыбраннаяОрганизацияЕГАИС);
	Если ПараметрыУТМ <> Неопределено Тогда
		ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(
			"http://" + ПараметрыУТМ.АдресУТМ + ":" + Формат(ПараметрыУТМ.ПортУТМ, "ЧГ=0") + "/",
			Новый ОписаниеОповещения("ПослеОткрытияWebИнтерфейсаУТМ", ЭтотОбъект));
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтрШаблон(
				НСтр("ru = 'Не заданы параметры подключения к УТМ для организации ЕГАИС %1'"), ВыбраннаяОрганизацияЕГАИС),,
			"ОрганизацияЕГАИС");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборОрганизацииЕГАИСДляОткрытияWebИнтерфейсаУТМ(ВыбраннаяОрганизацияЕГАИС, ДополнительныеПараметры) Экспорт
	
	Если ВыбраннаяОрганизацияЕГАИС = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОткрытьWebИнтерфейсУТМ(ВыбраннаяОрганизацияЕГАИС.Значение);
	
КонецПроцедуры

#КонецОбласти