#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Контрагент)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура формирования таблицы платежного календаря.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПриходДенежныхСредствПлан - Текущий документ
//	ДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа
//
Процедура СформироватьТаблицаПлатежныйКалендарь(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.ДатаОплаты КАК Период,
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Ссылка.ТипДенежныхСредств,
	|	ЗНАЧЕНИЕ(Перечисление.СтатусыУтвержденияПлатежей.Утвержден) КАК СтатусУтвержденияПлатежа,
	|	ТаблицаДокумента.Ссылка КАК СчетНаОплату,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ОплатаПоставщикам) КАК Статья,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные)
	|			ТОГДА ТаблицаДокумента.Ссылка.Касса
	|		КОГДА ТаблицаДокумента.Ссылка.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Безналичные)
	|			ТОГДА ТаблицаДокумента.Ссылка.БанковскийСчет
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК БанковскийСчетКасса,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.Договор.РасчетыВУсловныхЕдиницах
	|			ТОГДА ТаблицаДокумента.Ссылка.Договор.ВалютаРасчетов
	|		ИНАЧЕ ТаблицаДокумента.Ссылка.ВалютаДокумента
	|	КОНЕЦ КАК Валюта,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.Договор.РасчетыВУсловныхЕдиницах
	|			ТОГДА ВЫРАЗИТЬ(-ТаблицаДокумента.СуммаОплаты * ВЫБОР
	|						КОГДА КурсыВалютРасчетов.Курс <> 0
	|								И КурсыВалютДокумента.Кратность <> 0
	|							ТОГДА КурсыВалютДокумента.Курс * КурсыВалютРасчетов.Кратность / (ЕСТЬNULL(КурсыВалютРасчетов.Курс, 1) * ЕСТЬNULL(КурсыВалютДокумента.Кратность, 1))
	|						ИНАЧЕ 1
	|					КОНЕЦ КАК ЧИСЛО(15, 2))
	|		ИНАЧЕ -ТаблицаДокумента.СуммаОплаты
	|	КОНЕЦ КАК Сумма
	|ИЗ
	|	Документ.СчетНаОплатуПоставщика.ПлатежныйКалендарь КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, ) КАК КурсыВалютРасчетов
	|		ПО ТаблицаДокумента.Ссылка.Договор.ВалютаРасчетов = КурсыВалютРасчетов.Валюта
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, ) КАК КурсыВалютДокумента
	|		ПО ТаблицаДокумента.Ссылка.ВалютаДокумента = КурсыВалютДокумента.Валюта
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлатежныйКалендарь", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаПлатежныйКалендарь()

// Процедура формирования таблицы денежных средств в резерве.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ЗаказПоставщику - Текущий документ
//	ДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа
//
Процедура СформироватьТаблицаДенежныеСредстваВРезерве(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.ДатаОплаты КАК Период,
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.Ссылка.ТипДенежныхСредств,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные)
	|			ТОГДА ТаблицаДокумента.Ссылка.Касса
	|		КОГДА ТаблицаДокумента.Ссылка.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Безналичные)
	|			ТОГДА ТаблицаДокумента.Ссылка.БанковскийСчет
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК БанковскийСчетКасса,
	|	ТаблицаДокумента.Ссылка КАК Документ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.Договор.РасчетыВУсловныхЕдиницах
	|			ТОГДА ТаблицаДокумента.Ссылка.Договор.ВалютаРасчетов
	|		ИНАЧЕ ТаблицаДокумента.Ссылка.ВалютаДокумента
	|	КОНЕЦ КАК Валюта,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.Договор.РасчетыВУсловныхЕдиницах
	|			ТОГДА ВЫРАЗИТЬ(ТаблицаДокумента.СуммаОплаты * ВЫБОР
	|						КОГДА КурсыВалютРасчетов.Курс <> 0
	|								И КурсыВалютДокумента.Кратность <> 0
	|							ТОГДА КурсыВалютДокумента.Курс * КурсыВалютРасчетов.Кратность / (ЕСТЬNULL(КурсыВалютРасчетов.Курс, 1) * ЕСТЬNULL(КурсыВалютДокумента.Кратность, 1))
	|						ИНАЧЕ 1
	|					КОНЕЦ КАК ЧИСЛО(15, 2))
	|		ИНАЧЕ ТаблицаДокумента.СуммаОплаты
	|	КОНЕЦ КАК Сумма
	|ИЗ
	|	Документ.СчетНаОплатуПоставщика.ПлатежныйКалендарь КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, ) КАК КурсыВалютРасчетов
	|		ПО ТаблицаДокумента.Ссылка.Договор.ВалютаРасчетов = КурсыВалютРасчетов.Валюта
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, ) КАК КурсыВалютДокумента
	|		ПО ТаблицаДокумента.Ссылка.ВалютаДокумента = КурсыВалютДокумента.Валюта
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|	И ТаблицаДокумента.Ссылка.ЗапланироватьОплату
	|	И ТаблицаДокумента.Ссылка.РезервироватьДенежныеСредства";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ДенежныеСредстваВРезерве", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаПлатежныйКалендарь()

// Процедура формирования таблицы счетов на оплату.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПриходДенежныхСредствПлан - Текущий документ
//	ДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа
//
Процедура СформироватьТаблицаОплатаСчетовИЗаказов(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.Ссылка КАК СчетНаОплату,
	|	ТаблицаДокумента.СуммаДокумента КАК Сумма
	|ИЗ
	|	Документ.СчетНаОплатуПоставщика КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Контрагент.ВестиУчетОплатыПоСчетам
	|	И ТаблицаДокумента.Ссылка = &Ссылка
	|	И ТаблицаДокумента.СуммаДокумента <> 0";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОплатаСчетовИЗаказов", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаОплатаСчетовИЗаказов()

// Формирует таблицу данных документа.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПриходДенежныхСредствПлан - Текущий документ
//	СтруктураДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа
//	
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	СформироватьТаблицаПлатежныйКалендарь(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаОплатаСчетовИЗаказов(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаДенежныеСредстваВРезерве(ДокументСсылка, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылкаСчетНаОплатуПоставщика, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Если НЕ Константы.КонтролироватьОстаткиПриПроведении.Получить() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРезервированиеДенежныхСредств") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДенежныеСредстваВРезервеОстатки.Организация КАК Организация,
		|	ДенежныеСредстваВРезервеОстатки.ТипДенежныхСредств КАК ТипДенежныхСредств,
		|	ДенежныеСредстваВРезервеОстатки.БанковскийСчетКасса КАК БанковскийСчетКассаПредставление,
		|	ДенежныеСредстваВРезервеОстатки.Валюта КАК Валюта,
		|	ДенежныеСредстваВРезервеОстатки.Документ КАК Документ,
		|	ДенежныеСредстваВРезервеОстатки.СуммаОстаток КАК ВРезерве
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваВРезерве.Остатки(&МоментКонтроля, Документ = &СсылкаНаДокумент) КАК ДенежныеСредстваВРезервеОстатки
		|ГДЕ
		|	ДенежныеСредстваВРезервеОстатки.СуммаОстаток < 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияДенежныеСредстваВРезервеИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.Организация КАК ОрганизацияПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса КАК БанковскийСчетКассаПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.Валюта КАК ВалютаПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств КАК ТипДенежныхСредствПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств КАК ТипДенежныхСредств,
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаВалОстаток, 0) КАК ОстатокДенежныхСредств,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.СуммаПередЗаписью КАК СуммаПередЗаписью,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.СуммаПриЗаписи КАК СуммаПриЗаписи,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.СуммаИзменение КАК СуммаИзменение,
		|	ЕСТЬNULL(РезервыПоДокументам.СуммаОстаток, 0) + ЕСТЬNULL(НеснижаемыеОстаткиДенежныхСредствСрезПоследних.СуммаНеснижаемогоОстатка, 0) - ДвиженияДенежныеСредстваВРезервеИзменение.СуммаПриЗаписи КАК ВРезерве,
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаВалОстаток, 0) КАК СвободныйОстаток
		|ИЗ
		|	ДвиженияДенежныеСредстваВРезервеИзменение КАК ДвиженияДенежныеСредстваВРезервеИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДенежныеСредства.Остатки(&МоментКонтроля, ) КАК ДенежныеСредстваОстатки
		|		ПО ДвиженияДенежныеСредстваВРезервеИзменение.Организация = ДенежныеСредстваОстатки.Организация
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств = ДенежныеСредстваОстатки.ТипДенежныхСредств
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса = ДенежныеСредстваОстатки.БанковскийСчетКасса
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.Валюта = ДенежныеСредстваОстатки.Валюта
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НеснижаемыеОстаткиДенежныхСредств.СрезПоследних(&МоментКонтроля, ) КАК НеснижаемыеОстаткиДенежныхСредствСрезПоследних
		|		ПО ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств = НеснижаемыеОстаткиДенежныхСредствСрезПоследних.ТипДенежныхСредств
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса = НеснижаемыеОстаткиДенежныхСредствСрезПоследних.БанковскийСчетКасса
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.Валюта = НеснижаемыеОстаткиДенежныхСредствСрезПоследних.Валюта
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ДенежныеСредстваВРезервеОстатки.Организация КАК Организация,
		|			ДенежныеСредстваВРезервеОстатки.ТипДенежныхСредств КАК ТипДенежныхСредств,
		|			ДенежныеСредстваВРезервеОстатки.БанковскийСчетКасса КАК БанковскийСчетКасса,
		|			ДенежныеСредстваВРезервеОстатки.Валюта КАК Валюта,
		|			СУММА(ДенежныеСредстваВРезервеОстатки.СуммаОстаток) КАК СуммаОстаток
		|		ИЗ
		|			РегистрНакопления.ДенежныеСредстваВРезерве.Остатки(&МоментКонтроля, ) КАК ДенежныеСредстваВРезервеОстатки
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ДенежныеСредстваВРезервеОстатки.Организация,
		|			ДенежныеСредстваВРезервеОстатки.ТипДенежныхСредств,
		|			ДенежныеСредстваВРезервеОстатки.БанковскийСчетКасса,
		|			ДенежныеСредстваВРезервеОстатки.Валюта) КАК РезервыПоДокументам
		|		ПО ДвиженияДенежныеСредстваВРезервеИзменение.Организация = РезервыПоДокументам.Организация
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств = РезервыПоДокументам.ТипДенежныхСредств
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса = РезервыПоДокументам.БанковскийСчетКасса
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.Валюта = РезервыПоДокументам.Валюта
		|ГДЕ
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаВалОстаток, 0) - (ЕСТЬNULL(НеснижаемыеОстаткиДенежныхСредствСрезПоследних.СуммаНеснижаемогоОстатка, 0) + ЕСТЬNULL(РезервыПоДокументам.СуммаОстаток, 0)) < 0");
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		Запрос.УстановитьПараметр("СсылкаНаДокумент", ДокументСсылкаСчетНаОплатуПоставщика);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		Если 	 НЕ МассивРезультатов[0].Пустой() 
			 ИЛИ НЕ МассивРезультатов[1].Пустой() Тогда
			ДокументОбъектСчетНаОплатуПоставщика = ДокументСсылкаСчетНаОплатуПоставщика.ПолучитьОбъект()
		КонецЕсли;
		
		// Отрицательный остаток по денежным средствам в резерве.
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструДенежныеСредстваВРезерве(ДокументОбъектСчетНаОплатуПоставщика, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
		// Отрицательный остаток по денежным средствам с учетом резервов.
		Если НЕ МассивРезультатов[1].Пустой() Тогда //Если остатка денежных средств не хватает, то выводить ошибку по резервам нет смысла
			Если ДокументСсылкаСчетНаОплатуПоставщика.РезервироватьДенежныеСредства Тогда
				ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
				УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструДенежныеСредстваСУчетомРезервов(ДокументСсылкаСчетНаОплатуПоставщика, ВыборкаИзРезультатаЗапроса, Отказ);
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКонтроль()

#КонецОбласти

#Область ЗагрузкаДанныхИзВнешнегоИсточника

Процедура ПоляЗагрузкиДанныхИзВнешнегоИсточника(ТаблицаПолейЗагрузки, НастройкиЗагрузкиДанных) Экспорт
	
	//
	// Для группы полей действует правило: хотя бы одно поле в группе должно быть выбрано в колонках
	//
	
	ОписаниеТиповСтрока25 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(25));
	ОписаниеТиповСтрока50 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(50));
	ОписаниеТиповСтрока100 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100));
	ОписаниеТиповСтрока150 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(150));
	ОписаниеТиповСтрока200 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(200));
	ОписаниеТиповСтрока1000 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(1000));
	ОписаниеТиповЧисло15_2 = Новый ОписаниеТипов("Число", , , , Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Неотрицательный));
	ОписаниеТиповЧисло15_3 = Новый ОписаниеТипов("Число", , , , Новый КвалификаторыЧисла(15, 3, ДопустимыйЗнак.Неотрицательный));
	ОписаниеТиповДата = Новый ОписаниеТипов("Дата", , , , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.Номенклатура");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Штрихкод", "Штрихкод", ОписаниеТиповСтрока200, ОписаниеТиповКолонка, "Номенклатура", 1, , Истина);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Артикул", "Артикул", ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "Номенклатура", 2, , Истина);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "НоменклатураНаименование", "Номенклатура (наименование)", ОписаниеТиповСтрока100, ОписаниеТиповКолонка, "Номенклатура", 3, , Истина);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "НоменклатураНаименованиеПолное","Номенклатура (полное наименование)", ОписаниеТиповСтрока1000, ОписаниеТиповКолонка, "Номенклатура", 5, , Истина);
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Содержание", "Содержание", ОписаниеТиповСтрока1000, ОписаниеТиповСтрока1000, , , , , НастройкиЗагрузкиДанных.СодержаниеВидимо);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") Тогда
		
		ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры");
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Характеристика", "Характеристика (наименование)", ОписаниеТиповСтрока150, ОписаниеТиповКолонка);
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартии") Тогда
		
		ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.ПартииНоменклатуры");
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Партия", "Партия (наименование)", ОписаниеТиповСтрока100, ОписаниеТиповКолонка);
		
	КонецЕсли;
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Количество", "Количество", ОписаниеТиповСтрока25, ОписаниеТиповЧисло15_3, , , Истина);
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.КлассификаторЕдиницИзмерения, СправочникСсылка.ЕдиницыИзмерения");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ЕдиницаИзмерения", "Ед. изм.", ОписаниеТиповСтрока25, ОписаниеТиповКолонка, , , , , ПолучитьФункциональнуюОпцию("УчетВРазличныхЕдиницахИзмерения"));
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Цена", "Цена", ОписаниеТиповСтрока25, ОписаниеТиповЧисло15_2, , , Истина);
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.СтавкиНДС");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "СтавкаНДС", "Ставка НДС", ОписаниеТиповСтрока50, ОписаниеТиповКолонка);
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "СуммаНДС", "Сумма НДС", ОписаниеТиповСтрока25, ОписаниеТиповЧисло15_2);
	
КонецПроцедуры

Процедура ПриОпределенииОбразцовЗагрузкиДанных(НастройкиЗагрузкиДанных, УникальныйИдентификатор) Экспорт
	
	Образец_xlsx = ПолучитьМакет("ОбразецЗагрузкиДанных_xlsx");
	ОбразецЗагрузкиДанных_xlsx = ПоместитьВоВременноеХранилище(Образец_xlsx, УникальныйИдентификатор);
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_xlsx", ОбразецЗагрузкиДанных_xlsx);
	
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_mxl", "ОбразецЗагрузкиДанных_mxl");
	
	Образец_csv = ПолучитьМакет("ОбразецЗагрузкиДанных_csv");
	ОбразецЗагрузкиДанных_csv = ПоместитьВоВременноеХранилище(Образец_csv, УникальныйИдентификатор);
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_csv", ОбразецЗагрузкиДанных_csv);
	
КонецПроцедуры

Процедура СопоставитьЗагружаемыеДанныеИзВнешнегоИсточника(ТаблицаСопоставленияДанных, НастройкиЗагрузкиДанных) Экспорт
	
	ПолноеИмяОбъектаЗаполнения = НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения;
	
	// ТаблицаСопоставленияДанных - Тип ДанныеФормыКоллекция
	Для каждого СтрокаТаблицыФормы Из ТаблицаСопоставленияДанных Цикл
		
		// Номенклатура по ШтрихКоду, Артикулу, Наименованию, НаименованиеПолное
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьНоменклатуру(СтрокаТаблицыФормы.Номенклатура, СтрокаТаблицыФормы.Штрихкод, СтрокаТаблицыФормы.Артикул, СтрокаТаблицыФормы.НоменклатураНаименование, СтрокаТаблицыФормы.НоменклатураНаименованиеПолное);
		
		// Содержание
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СкопироватьСтрокуВЗначениеСтроковогоТипа(СтрокаТаблицыФормы.Содержание, СтрокаТаблицыФормы.Содержание_ВходящиеДанные);
		
		// Характеристика по Владельцу и Наименованию
		Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") Тогда
			
			Если ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура) Тогда
				
				ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьХарактеристику(СтрокаТаблицыФормы.Характеристика, СтрокаТаблицыФормы.Номенклатура, СтрокаТаблицыФормы.Штрихкод, СтрокаТаблицыФормы.Характеристика_ВходящиеДанные);
				
			КонецЕсли;
			
		КонецЕсли;
		
		// Партия по Владельцу и Наименованию
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПартии") Тогда
			
			Если ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура) Тогда
				
				ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьПартию(СтрокаТаблицыФормы.Партия, СтрокаТаблицыФормы.Номенклатура, СтрокаТаблицыФормы.Штрихкод, СтрокаТаблицыФормы.Партия_ВходящиеДанные);
				
			КонецЕсли;
			
		КонецЕсли;
		
		// Количество
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВЧисло(СтрокаТаблицыФормы.Количество, СтрокаТаблицыФормы.Количество_ВходящиеДанные, 1);
		
		// ЕдиницыИзмерения по Наименованию (так же рассмотреть возможность прикрутить пользовательские ЕИ)
		ЗначениеПоУмолчанию = ?(ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура), СтрокаТаблицыФормы.Номенклатура.ЕдиницаИзмерения, Справочники.КлассификаторЕдиницИзмерения.шт);
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьЕдиницыИзмерения(СтрокаТаблицыФормы.Номенклатура, СтрокаТаблицыФормы.ЕдиницаИзмерения, СтрокаТаблицыФормы.ЕдиницаИзмерения_ВходящиеДанные, ЗначениеПоУмолчанию);
		
		// Цена
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВЧисло(СтрокаТаблицыФормы.Цена, СтрокаТаблицыФормы.Цена_ВходящиеДанные, 1);
		
		// СтавкаНДС по наименованию
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьСтавкуНДС(СтрокаТаблицыФормы.СтавкаНДС, СтрокаТаблицыФормы.СтавкаНДС_ВходящиеДанные, Неопределено);
		
		// СуммаНДС
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВЧисло(СтрокаТаблицыФормы.СуммаНДС, СтрокаТаблицыФормы.СуммаНДС_ВходящиеДанные, 0);
		
		ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы, ПолноеИмяОбъектаЗаполнения = "") Экспорт
	
	ИмяСлужебногоПоля = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна();
	
	СтрокаТаблицыФормы[ИмяСлужебногоПоля] = ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура)
		И (СтрокаТаблицыФормы.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас 
			ИЛИ СтрокаТаблицыФормы.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга)
		И СтрокаТаблицыФормы.Количество <> 0;
	
КонецПроцедуры

#КонецОбласти

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли