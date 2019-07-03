///////////////////////////////////////////////////////////////////////////////
// КЛИЕНТСКИЕ ПРОЦЕДУРЫ И ФУНКЦИИ СВЯЗАННЫЕ С РЕГЛАМЕНТИРОВАННОЙ ОТЧЕТНОСТЬЮ УСН


// Функция производит обработку события календаря в зависимости от задачи
// Параметры:
//		Организация - СправочникСсылка.Организации - ОЕ по которой производится обработка события
//		СобытиеКалендаря - СправочникСсылка.КалендарьПодготовкиОтчетности -  событие календаря отчетности
// Возвращает:
//		СтруктураОбработки - ФиксированнаяСтруктура - структура, содержащая данные результата расчета,
//			в зависимости от рассчитываемого налога, взноса, формируемой отчтности
//
Функция ОбработатьСобытиеКалендаря(Организация, СобытиеКалендаря) Экспорт
	
	СтруктураСобытия = РегламентированнаяОтчетностьУСН.ПолучитьДанныеСобытия(
		СобытиеКалендаря, 
		"Задача,ДатаНачалаСобытия,ДатаОкончанияСобытия,ДатаДокументаОбработкиСобытия");
	
	Если СтруктураСобытия.ТипЗадачи = "РасчетЕдиногоНалога" Тогда
		Возврат РассчитатьЕдиныйНалог(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "РасчетАвансовогоПлатежа" Тогда
		Возврат РассчитатьАвансовыйПлатежПоУСН(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "ФормированиеДекларацииПоУСН" Тогда
		Возврат СформироватьДекларациюПоУСН(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "РасчетСтраховыхВзносовИП" Тогда
		Возврат РассчитатьСтраховыеВзносы(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "РасчетНалоговСотрудников" Тогда
		Возврат РассчитатьСтраховыеВзносыПоСотрудникам(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "ФормированиеДекларацииЕНВД" Тогда
		Возврат СформироватьДекларациюПоЕНВД(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "РасчетЕдиногоНалогаЕНВД" Тогда
		Возврат РассчитатьПлатежПоЕНВД(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "ФормированиеСреднесписочнойЧисленности" Тогда
		Возврат СформироватьСведенияОСреднесписочнойЧисленности(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "ФормированиеСправок2НДФЛ" Тогда
		Возврат СформироватьСправки2НДФЛ(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "ФормированиеОтчетностиВПФР" Тогда
		Возврат СформироватьОтчетностьВФПР(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "Формирование4ФСС" Тогда
		Возврат СформироватьФорму4ФСС(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "СтраховыеВзносыПриДоходахСвыше300тр" Тогда
		Возврат РассчитатьСтраховыеВзносыПриДоходахСвыше300тр(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи ="НалогПатент" Тогда
		Возврат РассчитатьПатент(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "ТорговыйСбор" Тогда
		Возврат РассчитатьТорговыйСбор(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "Форма1Предприниматель" Тогда
		Возврат СформироватьФорму1Предприниматель(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "Форма6НДФЛ" Тогда
		Возврат СформироватьФорму6НДФЛ(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "СведенияОЗастрахованныхЛицах" Тогда
		Возврат СформироватьСЗВМ(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "СЗВСтаж" Тогда
		Возврат СформироватьСЗВСтаж(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "Декларация12" Тогда
		Возврат СформироватьДекларацию12(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ИначеЕсли СтруктураСобытия.ТипЗадачи = "РасчетПоСтраховымВзносам" Тогда
		Возврат СформироватьРасчетПоСтраховымВзносам(Организация, СтруктураСобытия.ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	КонецЕсли;
	
КонецФункции

// Функция производит расчет единого налога по отчетной единице на дату документа обработки события
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		СтруктураРасчетаЕдиногоНалога - ФиксированнаяСтруктура - структура, содержащая данные результата расчета единого налога
//
Функция РассчитатьЕдиныйНалог(Организация, ДатаДокументаОбработкиСобытия, СобытиеКалендаря) Экспорт
	
	СформироватьЗаписиКУДиРЗаГод(Организация, ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.ВыполнитьРасчетЕдиногоНалога(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	Состояние(
		НСтр("ru='Рассчитано'"),
		,
		НСтр("ru='Единый налог рассчитан'"),
		БиблиотекаКартинок.Рассчет32
	);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.ЕдиныйНалог");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит расчет авансового платежа по УСН по отчетной единице на дату документа обработки события
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция РассчитатьАвансовыйПлатежПоУСН(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	СформироватьЗаписиКУДиРЗаГод(Организация, ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.ВыполнитьРасчетАвансовогоПлатежа(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	Состояние(
		НСтр("ru='Рассчитано'"),
		,
		НСтр("ru='Авансовый платеж рассчитан'"),
		БиблиотекаКартинок.Рассчет32);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.АвансовыйПлатежПоУСН");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит формирование декларации по УСН
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция СформироватьДекларациюПоУСН(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	СформироватьЗаписиКУДиРЗаГод(Организация, ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.СформироватьДекларациюПоУСН(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	// контроль 14го года и новой декларации
	Если ДатаДокументаОбработкиСобытия < Дата(2014,1,1) Тогда
		ИмяФормыРО = "ФормаОтчета2009Кв1";
	ИначеЕсли ДатаДокументаОбработкиСобытия < Дата(2015,1,1) Тогда
		ИмяФормыРО = "ФормаОтчета2014Кв1";
	Иначе
		ИмяФормыРО = "ФормаОтчета2015Кв1";
	КонецЕсли;
	
	Если Не РезультатРасчета.НалоговыйПериодПропущен Тогда
		// Проверка на существование документа отчетности,
		// Если таковой документ не существует, то сохраняем новый
		Если РезультатРасчета.ДокументОтчетности = Неопределено Тогда
			
			Параметры = Новый Структура(
				"Организация,мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,БезОткрытияФормы,мВыбраннаяФорма,ДатаПодписи,БезОткрытияФормы",
				РезультатРасчета.Организация,
				НачалоГода(РезультатРасчета.ДатаДокументаОбработкиСобытия),
				КонецГода(РезультатРасчета.ДатаДокументаОбработкиСобытия),
				Истина,
				ИмяФормыРО,
				ТекущаяДата(),
				Истина);
		Иначе
			Параметры = Новый Структура(
			"мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,мПериодичность,Организация,мВыбраннаяФорма,мСохраненныйДок,БезОткрытияФормы",
			РезультатРасчета.ПараметрыФормыДокумента.ДатаНачала,
			РезультатРасчета.ПараметрыФормыДокумента.ДатаОкончания,
			РезультатРасчета.ПараметрыФормыДокумента.Периодичность,
			Организация,
			РезультатРасчета.ПараметрыФормыДокумента.ВыбраннаяФорма,
			РезультатРасчета.ДокументОтчетности, 
			Истина);
		КонецЕсли;
		
		Параметры.Вставить("СформироватьФормуОтчетаАвтоматически", Истина);
		
		Форма = ПолучитьФорму("Отчет.РегламентированныйОтчетУСН.Форма."+ИмяФормыРО, Параметры);
		
		Форма.СохранитьНаКлиенте(Ложь);
	КонецЕсли;
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.ДекларацияПоУСН");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит формирование декларации по УСН
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция СформироватьФорму4ФСС(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.Сформировать4ФСС(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	Если ДатаДокументаОбработкиСобытия < '20130630' Тогда
		ФормаОтчета = "ФормаОтчета2012Кв1";
	ИначеЕсли ДатаДокументаОбработкиСобытия < '20140101' Тогда
		ФормаОтчета = "ФормаОтчета2013Кв2";
	ИначеЕсли ДатаДокументаОбработкиСобытия < '20150101' Тогда
		ФормаОтчета = "ФормаОтчета2014Кв1";
	ИначеЕсли ДатаДокументаОбработкиСобытия < '20160101' Тогда
		ФормаОтчета = "ФормаОтчета2015Кв1";
	ИначеЕсли ДатаДокументаОбработкиСобытия < '20160701' Тогда
		ФормаОтчета = "ФормаОтчета2016Кв1";
	ИначеЕсли ДатаДокументаОбработкиСобытия < '20170101' Тогда
		ФормаОтчета = "ФормаОтчета2016Кв3";
	ИначеЕсли ДатаДокументаОбработкиСобытия < '20170701' Тогда
		ФормаОтчета = "ФормаОтчета2017Кв1";
	Иначе
		ФормаОтчета = "ФормаОтчета2017Кв3";
	КонецЕсли;
	
	// Проверка на существование документа отчетности,
	// Если таковой документ не существует, то сохраняем новый
	Если РезультатРасчета.ДокументОтчетности = Неопределено Тогда
		
		Параметры = Новый Структура(
			"Организация,мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,БезОткрытияФормы,мВыбраннаяФорма,ДатаПодписи,БезОткрытияФормы",
			РезультатРасчета.Организация,
			НачалоГода(РезультатРасчета.ДатаДокументаОбработкиСобытия),
			РезультатРасчета.ДатаДокументаОбработкиСобытия,
			Истина,
			ФормаОтчета,
			ТекущаяДата(),
			Истина);
	Иначе
		Параметры = Новый Структура(
		"мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,мПериодичность,Организация,мВыбраннаяФорма,мСохраненныйДок,БезОткрытияФормы",
		РезультатРасчета.ПараметрыФормыДокумента.ДатаНачала,
		РезультатРасчета.ПараметрыФормыДокумента.ДатаОкончания,
		РезультатРасчета.ПараметрыФормыДокумента.Периодичность,
		Организация,
		РезультатРасчета.ПараметрыФормыДокумента.ВыбраннаяФорма,
		РезультатРасчета.ДокументОтчетности,
		Истина);
	КонецЕсли;
	
	Параметры.Вставить("СформироватьФормуОтчетаАвтоматически", Истина);
	
	Форма = ПолучитьФорму("Отчет.РегламентированныйОтчет4ФСС.Форма."+ФормаОтчета, Параметры);
	Форма.СтруктураРеквизитовФормы.мВариант = 0;
	
	Форма.СохранитьНаКлиенте(Истина);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.Форма4ФСС");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит формирование декларации по УСН
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция СформироватьДекларациюПоЕНВД(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	Отказ = Ложь;
	
	ДокЕнвд = РегламентированнаяОтчетностьЕНВД.ПолучитьДокументПоказателейЕНВД(Организация, ДатаДокументаОбработкиСобытия);
	
	Если НЕ ЗначениеЗаполнено(ДокЕнвд) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РезультатРасчета = РегламентированнаяОтчетностьЕНВД.СформироватьДекларациюПоЕНВД(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	// контроль 12го года и новой декларации
	Если ДатаДокументаОбработкиСобытия < Дата(2012,1,1) Тогда
		ИмяФормыРО = "ФормаОтчета2010Кв1";
	ИначеЕсли ДатаДокументаОбработкиСобытия < Дата(2014,1,1) Тогда
		ИмяФормыРО = "ФормаОтчета2012Кв1";
	ИначеЕсли ДатаДокументаОбработкиСобытия < Дата(2015,1,1) Тогда
		ИмяФормыРО = "ФормаОтчета2013Кв4";
	ИначеЕсли ДатаДокументаОбработкиСобытия < Дата(2016,1,1) Тогда
		ИмяФормыРО = "ФормаОтчета2015Кв1";
	ИначеЕсли ДатаДокументаОбработкиСобытия < Дата(2017,1,1) Тогда
		ИмяФормыРО = "ФормаОтчета2016Кв1";
	ИначеЕсли ДатаДокументаОбработкиСобытия < Дата(2018,1,1) Тогда
		ИмяФормыРО = "ФормаОтчета2017Кв1";
	ИначеЕсли ДатаДокументаОбработкиСобытия < Дата(2018,7,1) Тогда
		ИмяФормыРО = "ФормаОтчета2018Кв1";
	ИначеЕсли ДатаДокументаОбработкиСобытия < Дата(2018,10,1) Тогда
		ИмяФормыРО = "ФормаОтчета2018Кв3";
	Иначе
		ИмяФормыРО = "ФормаОтчета2018Кв4";
	КонецЕсли;
	
	// Проверка на существование документа отчетности,
	// Если таковой документ не существует, то сохраняем новый
	Если РезультатРасчета.ДокументОтчетности = Неопределено Тогда
		
		Параметры = Новый Структура(
			"Организация,мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,БезОткрытияФормы,мВыбраннаяФорма,ДатаПодписи,БезОткрытияФормы",
			РезультатРасчета.Организация,
			НачалоКвартала(РезультатРасчета.ДатаДокументаОбработкиСобытия),
			КонецКвартала(РезультатРасчета.ДатаДокументаОбработкиСобытия),
			Истина,
			ИмяФормыРО,
			ТекущаяДата(),
			Истина);
	Иначе
		Параметры = Новый Структура(
		"мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,мПериодичность,Организация,мВыбраннаяФорма,мСохраненныйДок,БезОткрытияФормы",
		РезультатРасчета.ПараметрыФормыДокумента.ДатаНачала,
		РезультатРасчета.ПараметрыФормыДокумента.ДатаОкончания,
		РезультатРасчета.ПараметрыФормыДокумента.Периодичность,
		Организация,
		РезультатРасчета.ПараметрыФормыДокумента.ВыбраннаяФорма,
		РезультатРасчета.ДокументОтчетности,
		Истина);
	КонецЕсли;
	
	Параметры.Вставить("СформироватьФормуОтчетаАвтоматически", Истина);
	
	Форма = ПолучитьФорму("Отчет.РегламентированныйОтчетЕдиныйНалогНаВмененныйДоход.Форма."+ИмяФормыРО, Параметры);
	
	Форма.СохранитьНаКлиенте(Ложь);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.ДекларацияПоЕНВД");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит расчет взносов в ПФР
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция РассчитатьСтраховыеВзносы(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	Отказ = Ложь;
	// Возможно какая то процедура будет тут
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.ВыполнитьРасчетВзносовВПФРиФСС(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.СтраховыеВзносыИП");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит расчет страховых взносов
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция РассчитатьСтраховыеВзносыПоСотрудникам(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	Отказ = Ложь;
	// Возможно какая то процедура будет тут
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РезультатРасчета = РегламентированнаяОтчетностьСотрудники.ВыполнитьРасчетВзносовИНалоговПоСотрудникам(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.НалогиСотрудников");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит расчет суммы по ЕНВД
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция РассчитатьПлатежПоЕНВД(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	Отказ = Ложь;
	// Возможно какая то процедура будет тут
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РезультатРасчета = РегламентированнаяОтчетностьЕНВД.ВыполнитьРасчетЕНВД(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.ЕдиныйНалогЕНВД");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит формирование сведений о среднесписочной численности
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция СформироватьСведенияОСреднесписочнойЧисленности(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.СформироватьСведенияОСреднесписочнойЧисленности(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	// Проверка на существование документа отчетности,
	// Если таковой документ не существует, то сохраняем новый
	Если РезультатРасчета.ДокументОтчетности = Неопределено Тогда
		
		Параметры = Новый Структура(
			"Организация,мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,БезОткрытияФормы,мВыбраннаяФорма,ДатаПодписи,БезОткрытияФормы",
			РезультатРасчета.Организация,
			НачалоГода(РезультатРасчета.ДатаДокументаОбработкиСобытия),
			КонецГода(РезультатРасчета.ДатаДокументаОбработкиСобытия),
			Истина,
			"ФормаОтчета2007Кв1",
			ТекущаяДата(),
			Истина);
	Иначе
		Параметры = Новый Структура(
		"мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,мПериодичность,Организация,мВыбраннаяФорма,мСохраненныйДок,БезОткрытияФормы",
		РезультатРасчета.ПараметрыФормыДокумента.ДатаНачала,
		РезультатРасчета.ПараметрыФормыДокумента.ДатаОкончания,
		РезультатРасчета.ПараметрыФормыДокумента.Периодичность,
		Организация,
		РезультатРасчета.ПараметрыФормыДокумента.ВыбраннаяФорма,
		РезультатРасчета.ДокументОтчетности,
		Истина);
	КонецЕсли;
	
	Параметры.Вставить("СформироватьФормуОтчетаАвтоматически", Истина);
	
	Форма = ПолучитьФорму("Отчет.РегламентированныйОтчетСведенияОСреднесписочнойЧисленностиРаботников.Форма.ФормаОтчета2007Кв1", Параметры);
	
	Форма.СохранитьНаКлиенте(Ложь);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.СведенияОСреднесписочнойЧисленности");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит формирование справок 2-НДФЛ
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция СформироватьСправки2НДФЛ(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	Отказ = Ложь;
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.СформироватьСправки2НДФЛ(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.Справки2НДФЛ");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит формирование справки по РСВ
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция СформироватьОтчетностьВФПР(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	РезультатРасчета = Новый Структура;
	
	// Формируем комплект отчетности в ПФР.
	РегламентированнаяОтчетностьУСН.СформироватьКомплектОтчетностиВПФР(Организация, ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.ОтчетностьВПФР");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит расчет взносов в ПФР при превышении доходов на 300 тр.
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция РассчитатьСтраховыеВзносыПриДоходахСвыше300тр(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	Отказ = Ложь;
	// Возможно какая то процедура будет тут
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.ВыполнитьРасчетВзносовВПФРПриДоходахСвыше300тр(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.СтраховыеВзносыПриДоходахСвыше300тр");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит расчет торгового сбора
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция РассчитатьТорговыйСбор(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	Отказ = Ложь;
	// Возможно какая то процедура будет тут
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.ВыполнитьРасчетТорговогоСбора(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.ТорговыйСбор");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит формирование формы №1-предприниматель
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция СформироватьФорму1Предприниматель(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.СформироватьФорму1Предприниматель(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	ФормаОтчета = "ФормаОтчета2015Кв1";
	
	// Проверка на существование документа отчетности,
	// Если таковой документ не существует, то сохраняем новый
	Если РезультатРасчета.ДокументОтчетности = Неопределено Тогда
		
		Параметры = Новый Структура(
			"Организация,мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,БезОткрытияФормы,мВыбраннаяФорма,ДатаПодписи,БезОткрытияФормы",
			РезультатРасчета.Организация,
			НачалоГода(РезультатРасчета.ДатаДокументаОбработкиСобытия),
			РезультатРасчета.ДатаДокументаОбработкиСобытия,
			Истина,
			ФормаОтчета,
			ТекущаяДата(),
			Истина);
	Иначе
		Параметры = Новый Структура(
		"мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,мПериодичность,Организация,мВыбраннаяФорма,мСохраненныйДок,БезОткрытияФормы",
		РезультатРасчета.ПараметрыФормыДокумента.ДатаНачала,
		РезультатРасчета.ПараметрыФормыДокумента.ДатаОкончания,
		РезультатРасчета.ПараметрыФормыДокумента.Периодичность,
		Организация,
		РезультатРасчета.ПараметрыФормыДокумента.ВыбраннаяФорма,
		РезультатРасчета.ДокументОтчетности,
		Истина);
	КонецЕсли;
	
	Параметры.Вставить("СформироватьФормуОтчетаАвтоматически", Истина);
	
	Форма = ПолучитьФорму("Отчет.РегламентированныйОтчетСтатистикаФорма1Предприниматель.Форма."+ФормаОтчета, Параметры);
	Форма.СтруктураРеквизитовФормы.мВариант = 0;
	
	Форма.СохранитьНаКлиенте(Истина);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.Форма1Предприниматель");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит формирование сведений о 6-НДФЛ
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция СформироватьФорму6НДФЛ(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.СформироватьФорму6НДФЛ(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	Если ДатаДокументаОбработкиСобытия < '20171231' 
		ИЛИ (ДатаДокументаОбработкиСобытия = '20171231') И (РегламентированнаяОтчетностьКлиентСерверПереопределяемый.ДатаДействияПриказа6НДФЛЗа2017год() > ТекущаяДата()) Тогда
		ФормаОтчета = "ФормаОтчета2016Кв1";
	Иначе
		ФормаОтчета = "ФормаОтчета2017Кв4";
	КонецЕсли;
	
	// Проверка на существование документа отчетности,
	// Если таковой документ не существует, то сохраняем новый
	Если РезультатРасчета.ДокументОтчетности = Неопределено Тогда
		
		Параметры = Новый Структура(
			"Организация,мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,БезОткрытияФормы,мВыбраннаяФорма,ДатаПодписи,БезОткрытияФормы,СформироватьФормуОтчетаАвтоматически",
			РезультатРасчета.Организация,
			НачалоГода(РезультатРасчета.ДатаДокументаОбработкиСобытия),
			КонецКвартала(РезультатРасчета.ДатаДокументаОбработкиСобытия),
			Истина,
			ФормаОтчета,
			ТекущаяДата(),
			Истина,
			Истина);
	Иначе
		Параметры = Новый Структура(
		"мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,мПериодичность,Организация,мВыбраннаяФорма,мСохраненныйДок,БезОткрытияФормы,СформироватьФормуОтчетаАвтоматически",
		НачалоГода(РезультатРасчета.ПараметрыФормыДокумента.ДатаНачала),
		РезультатРасчета.ПараметрыФормыДокумента.ДатаОкончания,
		РезультатРасчета.ПараметрыФормыДокумента.Периодичность,
		Организация,
		РезультатРасчета.ПараметрыФормыДокумента.ВыбраннаяФорма,
		РезультатРасчета.ДокументОтчетности,
		Истина,
		Истина);
	КонецЕсли;
	
	Форма = ПолучитьФорму("Отчет.РегламентированныйОтчет6НДФЛ.Форма."+ФормаОтчета, Параметры);
	Форма.СтруктураРеквизитовФормы.мВариант = 0;
	
	РегламентированнаяОтчетностьКлиент.Очистить(Форма,, Ложь);
	
	Форма.Инициализация(Истина);
	
	Форма.СохранитьНаКлиенте(Истина);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.Форма6НДФЛ");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит формирование сведений об Алкогольной декларации №12
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция СформироватьДекларацию12(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.СформироватьДекларацию12(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	// Проверка на существование документа отчетности,
	// Если таковой документ не существует, то сохраняем новый
	Если РезультатРасчета.ДокументОтчетности = Неопределено Тогда
		
		Параметры = Новый Структура(
			"Организация,мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,БезОткрытияФормы,мВыбраннаяФорма,ДатаПодписи,БезОткрытияФормы,СформироватьФормуОтчетаАвтоматически",
			РезультатРасчета.Организация,
			НачалоКвартала(РезультатРасчета.ДатаДокументаОбработкиСобытия),
			КонецКвартала(РезультатРасчета.ДатаДокументаОбработкиСобытия),
			Истина,
			"ФормаОтчета2012Кв3",
			ТекущаяДата(),
			Истина,
			Истина);
	Иначе
		Параметры = Новый Структура(
		"мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,мПериодичность,Организация,мВыбраннаяФорма,мСохраненныйДок,БезОткрытияФормы,СформироватьФормуОтчетаАвтоматически",
		РезультатРасчета.ПараметрыФормыДокумента.ДатаНачала,
		РезультатРасчета.ПараметрыФормыДокумента.ДатаОкончания,
		РезультатРасчета.ПараметрыФормыДокумента.Периодичность,
		Организация,
		РезультатРасчета.ПараметрыФормыДокумента.ВыбраннаяФорма,
		РезультатРасчета.ДокументОтчетности,
		Истина,
		Ложь);
	КонецЕсли;
	
	ФормаОтчетаДлитОперации = ПолучитьФорму("Отчет.РегламентированныйОтчетАлкоПриложение12.Форма.ФормаОтчета2012Кв3", Параметры);
	ФормаОтчетаДлитОперации.СтруктураРеквизитовФормы.мВариант = 0;
	
	ФормаОтчетаДлитОперации.ПризнакФормыОтчетности = "4";
	ФормаОтчетаДлитОперации.ПользовательНажалСохранитьОтчет = Истина;
	ФормаОтчетаДлитОперации.СохранитьНаКлиенте( Истина);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.Декларация12");
	РезультатРасчета.Вставить("ФормаОтчетаДлитОперации", ФормаОтчетаДлитОперации);
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит формирование Сведений о застрахованных лицах (СЗВ-М)
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция СформироватьСЗВМ(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	Отказ = Ложь;
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.СформироватьСЗВМ(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.СведенияОЗастрахованныхЛицах");
	
	Возврат РезультатРасчета;
	
КонецФункции

// Функция производит формирование СЗВ-Стаж
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция СформироватьСЗВСтаж(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	Отказ = Ложь;
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.СформироватьСЗВСтаж(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.СЗВСтаж");
	
	Возврат РезультатРасчета;
	
КонецФункции


// Функция производит формирование отчета "Расчет по страховым взносам"
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция СформироватьРасчетПоСтраховымВзносам(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.СформироватьРасчетПоСтраховымВзносам(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	// Проверка на существование документа отчетности,
	// Если таковой документ не существует, то сохраняем новый
	Если РезультатРасчета.ДокументОтчетности = Неопределено Тогда
		
		Параметры = Новый Структура(
			"Организация,мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,БезОткрытияФормы,мВыбраннаяФорма,ДатаПодписи,БезОткрытияФормы,СформироватьФормуОтчетаАвтоматически",
			РезультатРасчета.Организация,
			НачалоКвартала(РезультатРасчета.ДатаДокументаОбработкиСобытия),
			КонецКвартала(РезультатРасчета.ДатаДокументаОбработкиСобытия),
			Истина,
			"ФормаОтчета2017Кв1",
			ТекущаяДата(),
			Истина,
			Истина);
	Иначе
		Параметры = Новый Структура(
		"мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,мПериодичность,Организация,мВыбраннаяФорма,мСохраненныйДок,БезОткрытияФормы,СформироватьФормуОтчетаАвтоматически",
		РезультатРасчета.ПараметрыФормыДокумента.ДатаНачала,
		РезультатРасчета.ПараметрыФормыДокумента.ДатаОкончания,
		РезультатРасчета.ПараметрыФормыДокумента.Периодичность,
		Организация,
		РезультатРасчета.ПараметрыФормыДокумента.ВыбраннаяФорма,
		РезультатРасчета.ДокументОтчетности,
		Истина,
		Истина);
	КонецЕсли;
	
	Форма = ПолучитьФорму("Отчет.РегламентированныйОтчетРасчетПоСтраховымВзносам.Форма.ФормаОтчета2017Кв1", Параметры);
	Форма.СтруктураРеквизитовФормы.мВариант = 0;
	
	//РегламентированнаяОтчетностьКлиент.Очистить(Форма,, Ложь);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.РасчетПоСтраховымВзносам");
	РезультатРасчета.Вставить("ФормаОтчетаДлитОперации", Форма);
	
	Возврат РезультатРасчета;
	
КонецФункции

// ВСПОМОГАТЕЛЬНЫЕ ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИ

// Процедура определяет регламентированный отчет по событие календаря и открывает его форму
//
// Параметры:
//		Организация - СправочникСсылка.Организации
//		СобытиеКалендаря - СправочникСсылка.КалендарьПодготовкиОтчетности
//
Процедура ОткрытьФормуРегламентированногоОтчетаПоСобытию(Организация = Неопределено,СобытиеКалендаря) Экспорт
	
	ДокументРегламентированнойОтчетности = РегламентированнаяОтчетностьУСН.ПолучитьДокументРегламентированнойОтчетностиПоСобытиюКалендаря(Организация,СобытиеКалендаря);
	
	Если ДокументРегламентированнойОтчетности = Неопределено  Тогда
		ПоказатьПредупреждение(,НСтр("ru='Нет сохраненного отчета. Сформируйте отчет.'"));
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(,ДокументРегламентированнойОтчетности);
	
КонецПроцедуры

// Процедура сохраняет файл выгрузки регламентированной отчетности
//
// Параметры:
//		ДокументОтчетности - ДокументСсылка.РгалментированныйОтчет
//
Процедура СохранитьФайлВыгрузкиОтчетности(ДокументОтчетности) Экспорт
	
	ФормаВыгрузкиРеглОтчета = ПолучитьФорму("Документ.ВыгрузкаРегламентированныхОтчетов.Форма.ФормаДокумента", , );
	
	СпДокОсн = Новый СписокЗначений;
	СпДокОсн.Добавить(ДокументОтчетности);
	
	ФормаВыгрузкиРеглОтчета.СформироватьИЗаписать(СпДокОсн);
	
КонецПроцедуры

// Процедура выводит регламентированный очтет на печать в машиночитаемом виде
//
// Параметры:
//		ДокументОтчетности - ДокументСсылка.РегламентированныйОтчет
//
Процедура РаспечататьМашиночитаемыйРегламентированныйОтчет(ДокументОтчетности) Экспорт
	
	
	
	ДанныеДокумента = РегламентированнаяОтчетностьУСН.ПолучитьДанныеДокументаОтчетности(
		ДокументОтчетности,
		"Организация,ДатаПодписи,ВыбраннаяФорма,ДатаНачала,ДатаОкончания,ИсточникОтчета");
	
	ПараметрыФормы = Новый Структура(
		"БезОткрытияФормы,
		|ДатаПодписи,
		|мВыбраннаяФорма,
		|мДатаКонцаПериодаОтчета,
		|мДатаНачалаПериодаОтчета,
		|мСохраненныйДок,
		|Организация",
		Истина,
		ДанныеДокумента.ДатаПодписи,
		ДанныеДокумента.ВыбраннаяФорма,
		ДанныеДокумента.ДатаОкончания,
		ДанныеДокумента.ДатаНачала,
		ДокументОтчетности,
		ДанныеДокумента.Организация);
	
	Форма = ПолучитьФорму("Отчет."+ДанныеДокумента.ИсточникОтчета+".Форма."+ДанныеДокумента.ВыбраннаяФорма, ПараметрыФормы);
	
	// ПечататьСразуСДвухмернымШтрихкодомPDF417
	РегламентированнаяОтчетностьКлиент.ВывестиМашиночитаемуюФорму(Форма, "");
	
	
КонецПроцедуры

// Формирует записи КУДиР за год события
//
Процедура СформироватьЗаписиКУДиРЗаГод(Организация, Знач ДатаДокументаОбработкиСобытия, СобытиеКалендаря) Экспорт
	
	ДатаДокументаОбработкиСобытия = КонецДня(ДатаДокументаОбработкиСобытия);
	
	РегламентированнаяОтчетностьУСН.ВыполнитьФормированияВсехЗаписейКУДИР(ДатаДокументаОбработкиСобытия);
	
КонецПроцедуры

Процедура ПолучитьБанковскийСчетДляУплатыНалога(ОповещениеВыбораСчета, Организация, Форма = Неопределено, ЭлементФормы = Неопределено) Экспорт
	
	СпсБанкСчетов = РегламентированнаяОтчетностьУСН.ПолучитьСписокБанковскихСчетов(Организация);
	
	Если СпсБанкСчетов.Количество() = 0 Тогда
		СпсОтвет = Новый СписокЗначений;
		СпсОтвет.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Показать счета'"));
		СпсОтвет.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена'"));
		
		оп = Новый ОписаниеОповещения("ОповещениеВопросаПоказаСпискаСчетов", ЭтотОбъект, Новый Структура("Организация", Организация));
		ПоказатьВопрос(оп, НСтр("ru='Не найдены подходящие банковские счета'"), СпсОтвет);
		Возврат;
	КонецЕсли;
	
	БанковскийСчет = Неопределено;
	
	Если СпсБанкСчетов.Количество() = 1 Тогда
		БанковскийСчет = СпсБанкСчетов[0].Значение;
	Иначе
		оп = Новый ОписаниеОповещения("ОповещениеВыбораСчета", ЭтотОбъект, Новый Структура("ОповещениеВыбораСчета", ОповещениеВыбораСчета));
		#Если ВебКлиент Тогда
		СпсБанкСчетов.ПоказатьВыборЭлемента(оп, НСтр("ru='С какого счета провести оплату'"));
		#Иначе
		Если Форма = Неопределено Тогда
			СпсБанкСчетов.ПоказатьВыборЭлемента(оп, НСтр("ru='С какого счета провести оплату'"));
		Иначе
			Форма.ПоказатьВыборИзМеню(оп, СпсБанкСчетов, ЭлементФормы);
		КонецЕсли;
		#КонецЕсли
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОповещениеВыбораСчета, БанковскийСчет);
	
КонецПроцедуры

Процедура ОповещениеВопросаПоказаСпискаСчетов(Ответ, Параметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОткрытьФорму("Справочник.БанковскиеСчета.ФормаСписка", Новый Структура("Отбор", Новый Структура("Владелец", Параметры.Организация)));
	КонецЕсли;
КонецПроцедуры

Процедура ОповещениеВыбораСчета(БанковскийСчет, Параметры) Экспорт
	
	Если БанковскийСчет = Неопределено Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОповещениеВыбораСчета, Неопределено);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Параметры.ОповещениеВыбораСчета, БанковскийСчет.Значение);
	
КонецПроцедуры

// Показывает форму описание вычета НДФЛ
//
// Параметры:
//		КодВычета - Строка - Код Вычета
Процедура ПоказатьОписаниеВычетаНДФЛ(КодВычета) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИзМакета", Истина);
	ПараметрыФормы.Вставить("ПутьДоМакета", "Справочник.ВычетыНДФЛ");
	ПараметрыФормы.Вставить("ИмяМакета","Код"+КодВычета);
	ПараметрыФормы.Вставить("Заголовок","Вычет " + КодВычета);
	
	ОткрытьФорму("ОбщаяФорма.ПроизвольныйHTMLТекст",ПараметрыФормы);
	
КонецПроцедуры


// Функция производит расчет суммы по патенту
//
// Параметры:
//		Организация
//		ДатаДокументаОбработкиСобытия - ДатаВремя - дата документа, регистрирующего данные расчета
// Возвращает:
//		Структура
//
Функция РассчитатьПатент(Организация, ДатаДокументаОбработкиСобытия,СобытиеКалендаря) Экспорт
	
	Отказ = Ложь;
	// Возможно какая то процедура будет тут
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РезультатРасчета = РегламентированнаяОтчетностьУСН.ВыполнитьРасчетНалогаПоПатенту(Организация,ДатаДокументаОбработкиСобытия, СобытиеКалендаря);
	
	РезультатРасчета.Вставить("ИмяФормыРезультата", "Обработка.ОбработкиНалоговИОтчетности.Форма.НалогПатент");
	
	Возврат РезультатРасчета;
	
КонецФункции

Функция ОбработкаКомандыНалоговогоРаздела(Задача) Экспорт
	
	ДанныеСобытия = РегламентированнаяОтчетностьУСН.ПолучитьТекущиеДанныеСобытияПоЗадачеКалендаря(
		ПредопределенноеЗначение("Справочник.ЗадачиКалендаряПодготовкиОтчетности."+Задача));
		
	Если ДанныеСобытия.ТолькоПросмотр Или ДанныеСобытия.ЗадачаПрименима Тогда
		ОткрытьФорму("Справочник.ЗаписиКалендаряПодготовкиОтчетности.Форма.КалендарьНалоговИОтчетности", 
			Новый Структура("Задача", ПредопределенноеЗначение("Справочник.ЗадачиКалендаряПодготовкиОтчетности."+Задача)),,Задача);
	Иначе
		ОткрытьФорму("Справочник.ЗаписиКалендаряПодготовкиОтчетности.Форма.КалендарьНалоговИОтчетности",
				Новый Структура("Организация,Задача,Недоступность", ДанныеСобытия.Организация,  ПредопределенноеЗначение("Справочник.ЗадачиКалендаряПодготовкиОтчетности."+Задача), Истина),,Задача);
	КонецЕсли;
	
	
КонецФункции