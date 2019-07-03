
// См. описание этой же процедуры в общем модуле
// ОчередьЗаданийПереопределяемый.
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СоответствиеИменПсевдонимам.Вставить(Метаданные.РегламентныеЗадания.ОбменДаннымиССерверомШтрихМ.ИмяМетода);
	СоответствиеИменПсевдонимам.Вставить(Метаданные.РегламентныеЗадания.ОбменТоваромССерверомШтрихМ.ИмяМетода);
	
	
КонецПроцедуры

// Возвращает реквизиты кассы ШтрихМ из регистра настройки кассы
//
Функция ПолучитьРеквизитыКассыШтрихМ(КассаККМ) Экспорт
	
	ДанныеКассы = Новый Структура(
	"ДатаНачалаЗапросаЧеков,
	|ДатаОкончанияЗапросаЧеков,
	|ЗапроситьЧекиНаСервереШтрихМ,
	|ЗарегистрированНаСервереШтрихМ,
	|ЗарегистрироватьТоварыНаСервереШтрихМ,
	|ИдентификаторОбластиНаСервереШтрихМ,
	|ОчиститьТоварыНаСервереШтрихМ,
	|ПроверитьРегистрациюТоваровНаСервереШтрихМ,
	|РегистрационныйНомер,
	|СерийныйНомер,
	|Токен,
	|ИдентификаторТарификации,
	|ПрайсЛист,
	|СообщениеПриРегистрации,
	|ОтключенаЛицензия");
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НастройкиКассыШтрихМ.ДатаНачалаЗапросаЧеков КАК ДатаНачалаЗапросаЧеков,
	|	НастройкиКассыШтрихМ.ДатаОкончанияЗапросаЧеков КАК ДатаОкончанияЗапросаЧеков,
	|	НастройкиКассыШтрихМ.ЗапроситьЧекиНаСервереШтрихМ КАК ЗапроситьЧекиНаСервереШтрихМ,
	|	НастройкиКассыШтрихМ.ЗарегистрированНаСервереШтрихМ КАК ЗарегистрированНаСервереШтрихМ,
	|	НастройкиКассыШтрихМ.ЗарегистрироватьТоварыНаСервереШтрихМ КАК ЗарегистрироватьТоварыНаСервереШтрихМ,
	|	НастройкиКассыШтрихМ.ИдентификаторОбластиНаСервереШтрихМ КАК ИдентификаторОбластиНаСервереШтрихМ,
	|	НастройкиКассыШтрихМ.ОчиститьТоварыНаСервереШтрихМ КАК ОчиститьТоварыНаСервереШтрихМ,
	|	НастройкиКассыШтрихМ.ПроверитьРегистрациюТоваровНаСервереШтрихМ КАК ПроверитьРегистрациюТоваровНаСервереШтрихМ,
	|	НастройкиКассыШтрихМ.РегистрационныйНомер КАК РегистрационныйНомер,
	|	НастройкиКассыШтрихМ.СерийныйНомер КАК СерийныйНомер,
	|	НастройкиКассыШтрихМ.Токен КАК Токен,
	|	НастройкиКассыШтрихМ.ИдентификаторТарификации КАК ИдентификаторТарификации,
	|	НастройкиКассыШтрихМ.СообщениеПриРегистрации КАК СообщениеПриРегистрации,
	|	НастройкиКассыШтрихМ.ПрайсЛист КАК ПрайсЛист,
	|	НастройкиКассыШтрихМ.ОтключенаЛицензия КАК ОтключенаЛицензия
	|ИЗ
	|	РегистрСведений.НастройкиКассыШтрихМ КАК НастройкиКассыШтрихМ
	|ГДЕ
	|	НастройкиКассыШтрихМ.КассаККМ = &КассаККМ");
	
	Запрос.УстановитьПараметр("КассаККМ", КассаККМ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ДанныеКассы, Выборка);
	КонецЕсли;
	
	Возврат ДанныеКассы;
	
КонецФункции

// Функция возвращает кассу по её регистрационному номеру из регистра настроек касс
//
// Параметры:
//  РегистрационныйНомер  - Строка - Регистрационный номер кассы
//
// Возвращаемое значение:
//   СправочникСсылка.КассыККМ   - Искомая по регномеру касса
//
Функция ПолучитьКассуПоРегистрационномуНомеру(РегистрационныйНомер)Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НастройкиКассыШтрихМ.КассаККМ
	|ИЗ
	|	РегистрСведений.НастройкиКассыШтрихМ КАК НастройкиКассыШтрихМ
	|ГДЕ
	|	НастройкиКассыШтрихМ.РегистрационныйНомер = &РегистрационныйНомер");
	
	Запрос.УстановитьПараметр("РегистрационныйНомер", СокрЛП(РегистрационныйНомер));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КассаККМ;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции // ПолучитьКассуПоРегистрационномуНомеру()

// Функция возвращает кассу по её регистрационному номеру из регистра настроек касс
//
// Параметры:
//  РегистрационныйНомер  - Строка - Регистрационный номер кассы
//
// Возвращаемое значение:
//   СправочникСсылка.КассыККМ   - Искомая по регномеру касса
//
Функция ПолучитьКассуПоИдентификаторуЛицензии(Лицензия)Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НастройкиКассыШтрихМ.КассаККМ
	|ИЗ
	|	РегистрСведений.НастройкиКассыШтрихМ КАК НастройкиКассыШтрихМ
	|ГДЕ
	|	НастройкиКассыШтрихМ.ИдентификаторТарификации = &Лицензия");
	
	Запрос.УстановитьПараметр("Лицензия", СокрЛП(Лицензия));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КассаККМ;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции // ПолучитьКассуПоРегистрационномуНомеру()

Процедура ВойтиВОбластьДанныхНаСервере(Знач ОбластьДанных) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбщегоНазначения.УстановитьРазделениеСеанса(Истина, ОбластьДанных);
	
	НачатьТранзакцию();
	
	Попытка
		
		КлючОбласти = РаботаВМоделиСервиса.СоздатьКлючЗаписиРегистраСведенийВспомогательныхДанных(
			РегистрыСведений.ОбластиДанных,
			Новый Структура(РаботаВМоделиСервиса.РазделительВспомогательныхДанных(), ОбластьДанных));
		ЗаблокироватьДанныеДляРедактирования(КлючОбласти);
		
		Блокировка = Новый БлокировкаДанных;
		Элемент = Блокировка.Добавить("РегистрСведений.ОбластиДанных");
		Элемент.УстановитьЗначение("ОбластьДанныхВспомогательныеДанные", ОбластьДанных);
		Элемент.Режим = РежимБлокировкиДанных.Разделяемый;
		Блокировка.Заблокировать();
		
		МенеджерЗаписи = РегистрыСведений.ОбластиДанных.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ОбластьДанныхВспомогательныеДанные = ОбластьДанных;
		МенеджерЗаписи.Прочитать();
		Если Не МенеджерЗаписи.Выбран() Тогда
			МенеджерЗаписи.ОбластьДанныхВспомогательныеДанные = ОбластьДанных;
			МенеджерЗаписи.Статус = Перечисления.СтатусыОбластейДанных.Используется;
			МенеджерЗаписи.Записать();
		КонецЕсли;
		РазблокироватьДанныеДляРедактирования(КлючОбласти);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

Процедура ВыйтиИзОбластиДанныхНаСервере() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбщегоНазначения.УстановитьРазделениеСеанса(Ложь);
КонецПроцедуры

Функция ЗагрузитьДанныеОбменаИз1СКасса(ИмяФайла) Экспорт
	
	// при таком обмене не контролируем остатки
	Константы.КонтролироватьОстаткиПриПробитииЧековККМ.Установить(Ложь);
	Константы.ИспользоватьОбменСКассойMinikassir.Установить(Истина);
	Константы.ИспользоватьНесколькоОрганизаций.Установить(Истина);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ИмяФайла);
	ЧтениеXML.Прочитать(); // Message
	ЧтениеXML.Прочитать(); // Header
	
	Header = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ФабрикаXDTO.Тип("http://www.1c.ru/SSL/Exchange/Message", "Header"));
	Если ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента
		Или ЧтениеXML.ЛокальноеИмя <> "Body" Тогда
		
		ЗаписьЖурналаРегистрации(
			"Загрузка1СКасса.Загрузка1СКасса",
			УровеньЖурналаРегистрации.Ошибка,,, 
			НСтр("ru='Ошибка чтения сообщения загрузки. Неверный формат сообщения.'"));
			
		Возврат Ложь;
	КонецЕсли;
	
	ФорматОбмена = РазложитьФорматОбмена(Header.Format);
	ВерсияФорматаДляЗагрузки = ФорматОбмена.Версия;
	КомпонентыОбмена = КомпонентыОбмена("Получение", ВерсияФорматаДляЗагрузки);
	КомпонентыОбмена.XMLСхема = Header.Format;

	
	ЧтениеXML.Прочитать(); // Body
	КомпонентыОбмена.Вставить("ФайлОбмена", ЧтениеXML);
	
	ОбменДаннымиXDTOСервер.ПроизвестиЧтениеДанных(КомпонентыОбмена);
	
	ЧтениеXML.Закрыть();
	Если КомпонентыОбмена.ФлагОшибки Тогда
				ЗаписьЖурналаРегистрации(
			"Загрузка1СКасса.Загрузка1СКасса",
			УровеньЖурналаРегистрации.Ошибка,,, 
			 НСтр("ru='В ходе выполнения операции возникли ошибки'") + ": " + Символы.ПС + КомпонентыОбмена.СтрокаСообщенияОбОшибке);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция РазложитьФорматОбмена(Знач ФорматОбмена)
	
	Результат = Новый Структура("БазовыйФормат, Версия");
	
	ЭлементыФормата = СтрРазделить(ФорматОбмена, "/");
	
	Если ЭлементыФормата.Количество() = 0 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неканоническое имя формата обмена <%1>'"), ФорматОбмена);
	КонецЕсли;
	
	Результат.Версия = ЭлементыФормата[ЭлементыФормата.ВГраница()];
	
	Версии = СтрРазделить(Результат.Версия, ".");
	
	Если Версии.Количество() = 0 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неканоническое представление версии формата обмена: <%1>.'"), Результат.Версия);
	КонецЕсли;
	
	ЭлементыФормата.Удалить(ЭлементыФормата.ВГраница());
	
	Результат.БазовыйФормат = СтрСоединить(ЭлементыФормата, "/");
	
	Возврат Результат;
КонецФункции

// Выполняет подготовку структуры КомпонентыОбмена.
// Параметры:
//   НаправлениеОбмена - Строка - Отправка или Получение.
//   ВерсияФорматаОбменаПриЗагрузке - Строка - Версия формата, которая должна применяться при загрузке данных.
//
// Возвращаемое значение:
//   Структура - Компоненты обмена.
//
Функция КомпонентыОбмена(НаправлениеОбмена, ВерсияФорматаОбменаПриЗагрузке = "") Экспорт
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена(НаправлениеОбмена);
	ТекВерсияФормата = "1.4";
	КомпонентыОбмена.ЭтоОбменЧерезПланОбмена = Ложь;
	
	КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = НСтр("ru = 'Перенос данных через буфер обмена'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	КомпонентыОбмена.ВерсияФорматаОбмена = "1.4";
	КомпонентыОбмена.XMLСхема = "http://v8.1c.ru/edi/edi_stnd/EnterpriseData/" + ТекВерсияФормата;
	
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	МенеджерОбменаВнутренний = Истина;
	
	Если МенеджерОбменаВнутренний Тогда
		ВерсииФорматаОбмена = Новый Соответствие;
		ОбменДаннымиПереопределяемый.ПриПолученииДоступныхВерсийФормата(ВерсииФорматаОбмена);
		КомпонентыОбмена.МенеджерОбмена = ВерсииФорматаОбмена.Получить(ТекВерсияФормата);
		Если КомпонентыОбмена.МенеджерОбмена = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не поддерживается версия формата обмена: <%1>.'"), ТекВерсияФормата);
		КонецЕсли;
	КонецЕсли;
	
	ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена);
	
	Возврат КомпонентыОбмена;
	
КонецФункции

Функция ПолучитьПрайсЛистПоУмолчанию(Организация) Экспорт
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПрайсЛист.Ссылка КАК ПрайсЛист
	|ИЗ Справочник.ПрайсЛисты КАК ПрайсЛист
	|ГДЕ ПрайсЛист.Наименование = ""Прайс-лист кассы Штрих-М""");

	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		Возврат Выборка.ПрайсЛист;
	Иначе
		НовыйПрайсЛист = Справочники.ПрайсЛисты.СоздатьЭлемент();
		НовыйПрайсЛист.Наименование = "Прайс-лист кассы Штрих-М";
		НовыйПрайсЛист.Валюта = Константы.НациональнаяВалюта.Получить();
		НовыйПрайсЛист.Организация = Организация;
		НовыйПрайсЛист.ИерархияСодержимого = Перечисления.ИерархияПрайсЛистов.ИерархияНоменклатуры;
		НовыйПрайсЛист.ПечатьПрайсЛиста = Перечисления.ВариантыПечатиПрайсЛиста.Полотно;
		СтрокаВидаЦены = НовыйПрайсЛист.ВидыЦен.Добавить();
		СтрокаВидаЦены.ВидЦен = РозничныйВидЦены(Неопределено);
		
		ТаблицаПредставлений = Неопределено;
		Справочники.ПрайсЛисты.ДоступныеПоляНоменклатуры(ТаблицаПредставлений);
		НовыйПрайсЛист.ПредставлениеНоменклатуры.Загрузить(ТаблицаПредставлений);
		
		НовыйПрайсЛист.Записать();
		
		Возврат НовыйПрайсЛист.Ссылка;
		
	КонецЕсли;
КонецФункции

Функция РозничныйВидЦены(КассовыйАппарат = Неопределено) Экспорт
	
	Если КассовыйАппарат <> Неопределено Тогда
		ПрайсЛистКассы = ПолучитьРеквизитыКассыШтрихМ(КассовыйАппарат).ПрайсЛист;
		
				// Определение вида цены прайслиста
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПрайсЛистыВидыЦен.ВидЦен
		|ИЗ
		|	Справочник.ПрайсЛисты.ВидыЦен КАК ПрайсЛистыВидыЦен
		|ГДЕ
		|	ПрайсЛистыВидыЦен.Ссылка = &Ссылка");
		
		Запрос.УстановитьПараметр("Ссылка", ПрайсЛистКассы);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ВидЦены = Выборка.ВидЦен;
		Иначе
			ВидЦены = ИнтеграцияОбменШтрихМ.РозничныйВидЦены();
		КонецЕсли;
		
		Возврат ВидЦены;
		
	КонецЕсли;
	
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыЦен.Ссылка КАК ВидЦен
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|ГДЕ
	|	(ВидыЦен.Наименование = ""Розничные""
	|			ИЛИ ВидыЦен.Наименование = ""Розничная""
	|			ИЛИ ВидыЦен.Наименование = ""Розничная цена"")");
	
	// найден вид цен с названием розничные, розничная
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ВидЦеныКассы = Выборка.ВидЦен;
		Возврат ВидЦеныКассы;
	КонецЕсли;
	
	
	РозничнаяЦена = Справочники.ВидыЦен.СоздатьЭлемент();
	РозничнаяЦена.Наименование = "Розничная";
	РозничнаяЦена.ВалютаЦены = Константы.НациональнаяВалюта.Получить();
	РозничнаяЦена.ЦенаВключаетНДС = Истина;
	РозничнаяЦена.ТипВидаЦен = Перечисления.ТипыВидовЦен.Статический;
	РозничнаяЦена.ПорядокОкругления = 1;
	РозничнаяЦена.ФорматЦены = "ЧЦ=15; ЧДЦ=2";
	РозничнаяЦена.ИдентификаторФормул = "Розничная";
	
	РозничнаяЦена.Записать();
	
	Возврат РозничнаяЦена.Ссылка;
	
КонецФункции

Функция ВключитьРозничныеПродажи() Экспорт
	
	Константы.ФункциональнаяОпцияУчетРозничныхПродаж.Установить(Истина);
	Константы.ФункциональнаяОпцияЛегкиеРозничныеПродажи.Установить(Истина);
	Константы.КонтролироватьОстаткиПриПробитииЧековККМ.Установить(Ложь);
	
КонецФункции

// Выполняет попытку отмены регистрации на сервере тарификации кассового аппарата.
//
// Параметры:
//  Ссылка - СправочникСсылка.КассовыеАппараты - ссылка на кассовый аппарат.
//  УдалениеОбъекта - Булево - флаг удаления кассового аппарата.
//
// Возвращаемое значение:
//  Булево - флаг успешной отмены регистрации.
//
Функция ОтменаРегистрацииКассыНаСервереТарификации(ИдентификаторЛицензии, УдалениеОбъекта = Истина, ОтменитьДляВсехОбластей = Ложь, КодОбластиДанных = 0) Экспорт
	
	// Тариф проверям только во Фреше.
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЛицензии) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИдентификаторОперации = Новый УникальныйИдентификатор;
	
	ТарифноеОграничение = ТарификацияПереопределяемый.ОграничениеКоличествоКассПоТарифу();
	
	ЛицензияИспользуется = ПроверкаИспользованияЛицензииКоличествоКасс(ИдентификаторЛицензии, ТарифноеОграничение);
	
	Если ЛицензияИспользуется = Неопределено Тогда
		Возврат Истина;
	Иначе
		Если Не ЛицензияИспользуется Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		Если ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей() Тогда
			Результат = Тарификация.ОсвободитьЛицензиюУникальнойУслуги(ТарифноеОграничение.Поставщик,
				ТарифноеОграничение.Идентификатор,
				ИдентификаторЛицензии,
				ИдентификаторОперации, КодОбластиДанных,, ОтменитьДляВсехОбластей);
		Иначе
			Результат = Тарификация.ОсвободитьЛицензиюУникальнойУслуги(ТарифноеОграничение.Поставщик,
				ТарифноеОграничение.Идентификатор,
				ИдентификаторЛицензии,
				ИдентификаторОперации,,, ОтменитьДляВсехОбластей);
		КонецЕсли;
		Если Результат Тогда
			Тарификация.ПодтвердитьОперацию(ИдентификаторОперации);
			Возврат Истина;
		Иначе
			Тарификация.ОтменитьОперацию(ИдентификаторОперации);
			Возврат Ложь;
		КонецЕсли;
	Исключение
		Возврат Ложь;
	КонецПопытки;
КонецФункции

Функция ПроверкаИспользованияЛицензииКоличествоКасс(ИдентификаторЛицензии, ТарифноеОграничение = Неопределено)
	
	ЛицензияИспользуется = Неопределено;
	
	Если ТарифноеОграничение = Неопределено Тогда
		ТарифноеОграничение = ТарификацияПереопределяемый.ОграничениеКоличествоКассПоТарифу();
	КонецЕсли;
	
	Попытка
		ЛицензияИспользуется = Тарификация.ЗарегистрированаЛицензияУникальнойУслуги(ТарифноеОграничение.Поставщик,
			ТарифноеОграничение.Идентификатор,
			ИдентификаторЛицензии);
	Исключение
		ЛицензияИспользуется = Неопределено;
	КонецПопытки;
	
	Возврат ЛицензияИспользуется;
КонецФункции

// С помощью менеджера сервиса отправляет ответственному 
// письмо о новому абоненте из приложения 1С:Касса
Функция ОтправитьПисьмоОНовомАбонентеИз1СКасса() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		КодОбласти 	= ОбщегоНазначения.ЗначениеРазделителяСеанса();
		Прокси 		= ПолучитьПроксиМенеджераСервиса();
		КлючОбласти = Константы["КлючОбластиДанных"].Получить();
		АдресПочты  = Константы.ЭлектроннаяПочтаОтвественногоПерехода1СКасса.Получить();
		
		Если ПустаяСтрока(АдресПочты) Тогда
			ИмяСобытия = НСтр("ru = 'Загрузка1СКасса.Загрузка1СКасса'", 
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				
			Комментарий = НСтр("ru='Не установлен адрес электронной почты получателя уведомления о новом пользователе из 1С:Кассы'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
			
			ЗаписьЖурналаРегистрации(
				ИмяСобытия ,
				УровеньЖурналаРегистрации.Ошибка,,,
				Комментарий);
			
			Возврат Ложь;
		КонецЕсли;
		
		Результат = Прокси.IsSupportedByShtrihM(КодОбласти);
		
		// письма рассылаются только в случае, если обслуживающая организация Штрих-М
		Если НЕ Результат Тогда
			
			ИмяСобытия = НСтр("ru = 'Загрузка1СКасса.Загрузка1СКасса'", 
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				
			ЗаписьЖурналаРегистрации(
				ИмяСобытия ,
				УровеньЖурналаРегистрации.Информация,,,
				НСтр("ru='Абонент не принадлежит Штрих-М'"));

			
			Возврат Истина;
		КонецЕсли;
		
		Результат = Прокси.SendLetterToPerson(
			КодОбласти, 
			КлючОбласти,
			АдресПочты);
			
		Если НЕ ПустаяСтрока(Результат) Тогда
			ИмяСобытия = НСтр("ru = 'Загрузка1СКасса.Загрузка1СКасса'", 
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				
			ЗаписьЖурналаРегистрации(
				ИмяСобытия ,
				УровеньЖурналаРегистрации.Ошибка,,,
				Результат);
			
			Возврат Ложь;
		КонецЕсли;
		
	Исключение
		
		ИмяСобытия = НСтр("ru = 'Загрузка1СКасса.Загрузка1СКасса'", 
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
			
		Комментарий = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(
			ИмяСобытия ,
			УровеньЖурналаРегистрации.Ошибка,,,
			Комментарий);
			
		
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ПолучитьПроксиМенеджераСервиса()
	
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	
	Адрес 	= МодульРаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса() + "/ws/PrivateAPI?wsdl";
	Логин 	= МодульРаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса();
	Пароль 	= МодульРаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса();
	
	Опр = Новый WSОпределения(Адрес, Логин, Пароль);
	Прокси = Новый WSПрокси(Опр, "http://www.1c.ru/1cFresh/PrivateAPI/1.0", "PrivateAPI", "PrivateAPISoap");
	Прокси.Пользователь = Логин;
	Прокси.Пароль = Пароль;
	Возврат Прокси;
	
КонецФункции

