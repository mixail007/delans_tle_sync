
#Область ПрограммныйИнтерфейс

Процедура ОбработатьВводШтрихкода(Форма, ДанныеШтрихкода, КэшированныеЗначения) Экспорт
	
	Если ДанныеШтрихкода = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РезультатОбработкиШтрихкода = Форма.Подключаемый_ОбработатьВводШтрихкода(ДанныеШтрихкода, КэшированныеЗначения);
	
	ЗавершитьОбработкуВводаШтрихкода(Форма, РезультатОбработкиШтрихкода, КэшированныеЗначения);
	
КонецПроцедуры

Процедура ЗавершитьОбработкуВводаШтрихкода(Форма, РезультатОбработкиШтрихкода, КэшированныеЗначения, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(РезультатОбработкиШтрихкода.ТекстОшибки) Тогда
		
		ДанныеШтрихкода = Новый Структура;
		ДанныеШтрихкода.Вставить("АлкогольнаяПродукция", РезультатОбработкиШтрихкода.АлкогольнаяПродукция);
		ДанныеШтрихкода.Вставить("Штрихкод",             РезультатОбработкиШтрихкода.Штрихкод);
		ДанныеШтрихкода.Вставить("ТекстОшибки",          РезультатОбработкиШтрихкода.ТекстОшибки);
		ДанныеШтрихкода.Вставить("ТипШтрихкода",         РезультатОбработкиШтрихкода.ТипШтрихкода);
		
		ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ДанныеШтрихкода);
		
	ИначеЕсли РезультатОбработкиШтрихкода.ЕстьОшибкиВДеревеУпаковок Тогда
		
		ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, РезультатОбработкиШтрихкода.АдресДереваУпаковок);
		
	ИначеЕсли РезультатОбработкиШтрихкода.ТребуетсяВыборНоменклатуры Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма",                       Форма);
		ДополнительныеПараметры.Вставить("РезультатОбработкиШтрихкода", РезультатОбработкиШтрихкода);
		ДополнительныеПараметры.Вставить("КэшированныеЗначения",        КэшированныеЗначения);
		ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении",     ОповещениеПриЗавершении);
		
		ОткрытьФорму(
			"Обработка.РаботаСАкцизнымиМаркамиЕГАИС.Форма.ФормаВводаАкцизнойМаркиПоискНоменклатуры",
			РезультатОбработкиШтрихкода.ПараметрыВыбораНоменклатуры,
			Форма,,,,
			Новый ОписаниеОповещения("ВыборНоменклатурыЗавершение", ЭтотОбъект, ДополнительныеПараметры),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли РезультатОбработкиШтрихкода.ТребуетсяВыборСправки2 Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("Ссылка", РезультатОбработкиШтрихкода.Справки2);
		
		ПараметрыВыбораСправки2 = Новый Структура;
		ПараметрыВыбораСправки2.Вставить("РежимВыбора",        Истина);
		ПараметрыВыбораСправки2.Вставить("ЗакрыватьПриВыборе", Истина);
		ПараметрыВыбораСправки2.Вставить("Отбор",              Отбор);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма",                       Форма);
		ДополнительныеПараметры.Вставить("РезультатОбработкиШтрихкода", РезультатОбработкиШтрихкода);
		ДополнительныеПараметры.Вставить("КэшированныеЗначения",        КэшированныеЗначения);
		ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении",     ОповещениеПриЗавершении);
		
		ОткрытьФорму(
			"Справочник.Справки2ЕГАИС.ФормаВыбора",
			ПараметрыВыбораСправки2,
			Форма,,,,
			Новый ОписаниеОповещения("ВыборСправки2Завершение", ЭтотОбъект, ДополнительныеПараметры),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли РезультатОбработкиШтрихкода.ТребуетсяОбработкаШтрихкода Тогда
		
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ПослеОбработкиШтрихкодов", 0.1, Истина);
		
	Иначе
		
		ПараметрыСканированияАкцизныхМарок = АкцизныеМаркиКлиентСервер.ПараметрыСканированияАкцизныхМарок(Форма);
		
		Если ПараметрыСканированияАкцизныхМарок.ВозможнаЗагрузкаТСД
			И Форма.ЗагрузкаДанныхТСД <> Неопределено Тогда
		
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ПослеОбработкиШтрихкодаТСД", 0.1, Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыборНоменклатурыЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если РезультатВыбора = Неопределено Тогда
		
		ПараметрыСканированияАкцизныхМарок = АкцизныеМаркиКлиентСервер.ПараметрыСканированияАкцизныхМарок(Форма);
		
		Если ПараметрыСканированияАкцизныхМарок.ВозможнаЗагрузкаТСД
			И Форма.ЗагрузкаДанныхТСД <> Неопределено Тогда
		
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ПослеОбработкиШтрихкодаТСД", 0.1, Истина);
			
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РезультатВыбора.Номенклатура) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указана номенклатура'"));
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении = Неопределено Тогда
		
		РезультатОбработкиШтрихкода = Форма.Подключаемый_ОбработатьВыборНоменклатуры(
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода,
			ДополнительныеПараметры.КэшированныеЗначения);
		
		ЗавершитьОбработкуВводаШтрихкода(Форма, РезультатОбработкиШтрихкода, ДополнительныеПараметры.КэшированныеЗначения);
		
	Иначе
		
		ДанныеШтрихкода = АкцизныеМаркиВызовСервера.ОбработатьДанныеШтрихкодаПослеВыбораНоменклатуры(
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода);
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, ДанныеШтрихкода);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыборСправки2Завершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении = Неопределено Тогда
		РезультатОбработкиШтрихкода = Форма.Подключаемый_ОбработатьВыборСправки2(
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода,
			ДополнительныеПараметры.КэшированныеЗначения);
		
		ЗавершитьОбработкуВводаШтрихкода(Форма, РезультатОбработкиШтрихкода, ДополнительныеПараметры.КэшированныеЗначения);
	Иначе
		
		ДанныеШтрихкода = АкцизныеМаркиВызовСервера.ОбработатьДанныеШтрихкодаПослеВыбораСправки2(
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода);
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, ДанныеШтрихкода);
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает считанный ШК в зависимости от его формата.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая при завершении обработки,
//  Форма - УправляемаяФорма - форма, в которой отсканирован штрихкод,
//  СтруктураШтрихкода - Структура - структура с ключами:
//   * Штрихкод - Строка - считанный штрихкод,
//   * Количество - Число - количество упаковок.
//  ПараметрыСканированияАкцизныхМарок - Структура - параметры обработки акцизной марки (см. АкцизныеМаркиКлиентСервер.ПараметрыСканированияАкцизныхМарок()).
//
Процедура ОбработатьДанныеШтрихкода(ОповещениеПриЗавершении, Форма, СтруктураШтрихкода, ПараметрыСканированияАкцизныхМарок = Неопределено) Экспорт
	
	Если ПараметрыСканированияАкцизныхМарок = Неопределено Тогда
		ПараметрыСканированияАкцизныхМарок = АкцизныеМаркиКлиентСервер.ПараметрыСканированияАкцизныхМарок(Форма);
	КонецЕсли;
	
	СписокШтрихкодов = Новый Массив;
	
	Для Сч = 1 По СтруктураШтрихкода.Количество Цикл
		СписокШтрихкодов.Добавить(СтруктураШтрихкода.Штрихкод);
	КонецЦикла;
	
	ДанныеШтрихкодов = АкцизныеМаркиВызовСервера.ПолучитьДанныеПоШтрихкодам(
		СписокШтрихкодов, ПараметрыСканированияАкцизныхМарок,
		Неопределено, Форма.УникальныйИдентификатор);
		
	ОтразитьИзменениеАдресаДанныхОснованияВФорме(Форма, ПараметрыСканированияАкцизныхМарок);
	
	РезультатОбработки = ДанныеШтрихкодов.РезультатыОбработкиШтрихкодов[СтруктураШтрихкода.Штрихкод];
	
	Если РезультатОбработки <> Неопределено Тогда
		
		Если ПараметрыСканированияАкцизныхМарок.СоответствиеШтрихкодовСтрокДерева <> Неопределено 
			И РезультатОбработки.ТребуетсяВыборНоменклатуры Тогда
			
			Если ПараметрыСканированияАкцизныхМарок.СоответствиеШтрихкодовСтрокДерева.Получить(СтруктураШтрихкода.Штрихкод) <> Неопределено Тогда
				РезультатОбработки.ТребуетсяВыборНоменклатуры = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		Если РезультатОбработки.ЕстьОшибкиВДеревеУпаковок
			Или Не ПустаяСтрока(РезультатОбработки.ТекстОшибки)
			Или РезультатОбработки.ТребуетсяВыборНоменклатуры
			Или РезультатОбработки.ТребуетсяВыборСправки2 Тогда
			ЗавершитьОбработкуВводаШтрихкода(Форма, РезультатОбработки, Неопределено, ОповещениеПриЗавершении);
		Иначе
			ДанныеШтрихкода = ПолучитьИзВременногоХранилища(РезультатОбработки.АдресДанныхШтрихкода);
			ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ДанныеШтрихкода);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - Открыть форму считывания акцизной марки
//
// Параметры:
//  Результат - Булево - Не используется
//  ДополнительныеПараметры - Структура - Параметры открытия формы считывания марки: (Форма, ИдентификаторСтроки, Редактирование, АдресВоВременномХранилище)
//
Процедура ОткрытьФормуСчитыванияАкцизнойМарки(Результат, ДополнительныеПараметры) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДополнительныеПараметры.Форма, "Объект") Тогда
		Источник = ДополнительныеПараметры.Форма.Объект;
	Иначе
		Источник = ДополнительныеПараметры.Форма;
	КонецЕсли;
	
	ТекущиеДанные = Источник.Товары.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
	
	Если Не ТекущиеДанные.МаркируемаяАлкогольнаяПродукция Тогда
		ПоказатьПредупреждение(
			Неопределено,
			НСтр("ru = 'Для данной строки не указываются акцизные марки'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Номенклатура"  , ТекущиеДанные.Номенклатура);
	ПараметрыОткрытияФормы.Вставить("Характеристика", ТекущиеДанные.Характеристика);
	
	ОткрытьФорму(
		"Обработка.РаботаСАкцизнымиМаркамиЕГАИС.Форма.ФормаВводаАкцизнойМарки",
		ПараметрыОткрытияФормы,
		ДополнительныеПараметры.Форма,,,,
		Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ДополнительныеПараметры.Форма, ДополнительныеПараметры))
	
КонецПроцедуры

Процедура ОтразитьИзменениеАдресаДанныхОснованияВФорме(Форма, ПараметрыСканированияАкцизныхМарок)
	
	Если Не ЗначениеЗаполнено(ПараметрыСканированияАкцизныхМарок.ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
		
	ФормаСоЗначением = Неопределено;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "АдресДанныхДокументаОснования") Тогда
		ФормаСоЗначением = Форма;
	ИначеЕсли Форма.ВладелецФормы <> Неопределено
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.ВладелецФормы, "АдресДанныхДокументаОснования") Тогда
		ФормаСоЗначением = Форма.ВладелецФормы;
	КонецЕсли;
	
	Если ФормаСоЗначением = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ФормаСоЗначением["АдресДанныхДокументаОснования"] <> ПараметрыСканированияАкцизныхМарок.АдресДанныхДокументаОснования Тогда
		ФормаСоЗначением["АдресДанныхДокументаОснования"] = ПараметрыСканированияАкцизныхМарок.АдресДанныхДокументаОснования
	КонецЕсли;
	
КонецПроцедуры

Процедура ПредставлениеСохраненногоВыбораОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки) Экспорт
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "СброситьСохраненныеДанныеВыбораПоАлкогольнойПродукции" Тогда
		
		Форма.СохраненВыборПоАлкогольнойПродукции = Ложь;
		Форма.ДанныеВыбораПоАлкогольнойПродукции  = Неопределено;
		АкцизныеМаркиКлиентСервер.ОтобразитьСохраненныйВыборПоАлкогольнойПродукции(Форма);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьАлкогольнуюПродукцию" Тогда
		
		ПоказатьЗначение(, Форма.ДанныеВыбораПоАлкогольнойПродукции.АлкогольнаяПродукция);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьНоменклатуру" Тогда
		
		ПоказатьЗначение(, Форма.ДанныеВыбораПоАлкогольнойПродукции.Номенклатура);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьХарактеристику" Тогда
		
		ПоказатьЗначение(, Форма.ДанныеВыбораПоАлкогольнойПродукции.Характеристика);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьСерию" Тогда
		
		ПоказатьЗначение(, Форма.ДанныеВыбораПоАлкогольнойПродукции.Серия);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ДанныеОПроблеме) Экспорт
	
	Если ТипЗнч(ДанныеОПроблеме) = Тип("Структура") Тогда
		ПараметрыОткрытияФормы = Новый Структура();
		ПараметрыОткрытияФормы.Вставить("ДанныеШтрихкода", ДанныеОПроблеме);
	Иначе
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("АдресХранилищаДереваУпаковки", ДанныеОПроблеме);
	КонецЕсли;
	
	ОткрытьФорму(
		"Обработка.ПроверкаИПодборАлкогольнойПродукцииЕГАИС.Форма.ИнформацияОНевозможностиДобавленияОтсканированного",
		ПараметрыОткрытияФормы,
		Форма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти