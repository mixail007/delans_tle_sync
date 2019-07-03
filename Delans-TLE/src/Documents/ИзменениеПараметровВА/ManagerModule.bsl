#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаИзменениеПараметровВА, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаИзменениеПараметровВА);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Ссылка.Дата КАК Период,
	|	ТаблицаДокумента.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	ТаблицаДокумента.ВнеоборотныйАктив.СчетУчета КАК СчетУчета,
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемПродукцииРаботДляВычисленияАмортизации,
	|	ТаблицаДокумента.СтоимостьДляВычисленияАмортизации КАК СтоимостьДляВычисленияАмортизации,
	|	ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения КАК СтоимостьДляВычисленияАмортизацииДоИзменения,
	|	ТаблицаДокумента.СчетПереоценки КАК СчетПереоценки,
	|	ТаблицаДокумента.ПрименитьВТекущемМесяце КАК ПрименитьВТекущемМесяце,
	|	ТаблицаДокумента.СрокИспользованияДляВычисленияАмортизации КАК СрокИспользованияДляВычисленияАмортизации,
	|	ТаблицаДокумента.СчетЗатрат КАК СчетЗатрат,
	|	ТаблицаДокумента.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности
	|ПОМЕСТИТЬ ВременнаяТаблицаИзменениеПараметровВА
	|ИЗ
	|	Документ.ИзменениеПараметровВА.ВнеоборотныеАктивы КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СформироватьТаблицаПараметрыВнеоборотныхАктивов(ДокументСсылкаИзменениеПараметровВА, СтруктураДополнительныеСвойства);
	СформироватьТаблицаВнеоборотныеАктивы(ДокументСсылкаИзменениеПараметровВА, СтруктураДополнительныеСвойства);
	СформироватьТаблицаДоходыИРасходы(ДокументСсылкаИзменениеПараметровВА, СтруктураДополнительныеСвойства);
	СформироватьТаблицаУправленческий(ДокументСсылкаИзменениеПараметровВА, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаВнеоборотныеАктивы(ДокументСсылкаИзменениеПараметровВА, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("ПринятиеВнеоборотногоАктиваКУчету", "Изменение параметров");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Период КАК Период,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтоимостьДляВычисленияАмортизации - ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения > 0
	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	КОНЕЦ КАК ВидДвижения,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтоимостьДляВычисленияАмортизации - ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения > 0
	|			ТОГДА ТаблицаДокумента.СтоимостьДляВычисленияАмортизации - ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения
	|		ИНАЧЕ ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения - ТаблицаДокумента.СтоимостьДляВычисленияАмортизации
	|	КОНЕЦ КАК Стоимость,
	|	0 КАК Амортизация,
	|	&ПринятиеВнеоборотногоАктиваКУчету КАК СодержаниеПроводки
	|ИЗ
	|	ВременнаяТаблицаИзменениеПараметровВА КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаВнеоборотныеАктивы", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаВнеоборотныеАктивы()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаДоходыИРасходы(ДокументСсылкаИзменениеПараметровВА, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ОтражениеДоходов", НСтр("ru = 'Отражение доходов'"));
	Запрос.УстановитьПараметр("ОтражениеРасходов", НСтр("ru = 'Отражение расходов'"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Период КАК Период,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК СтруктурнаяЕдиница,
	|	НЕОПРЕДЕЛЕНО КАК Заказ,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.Прочее) КАК НаправлениеДеятельности,
	|	ТаблицаДокумента.СчетПереоценки КАК СчетУчета,
	|	ТаблицаДокумента.ВнеоборотныйАктив КАК Аналитика,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтоимостьДляВычисленияАмортизации - ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения > 0
	|			ТОГДА &ОтражениеДоходов
	|		ИНАЧЕ &ОтражениеРасходов
	|	КОНЕЦ КАК СодержаниеПроводки,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтоимостьДляВычисленияАмортизации - ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения > 0
	|			ТОГДА ТаблицаДокумента.СтоимостьДляВычисленияАмортизации - ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаДоходов,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтоимостьДляВычисленияАмортизации - ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения > 0
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения - ТаблицаДокумента.СтоимостьДляВычисленияАмортизации
	|	КОНЕЦ КАК СуммаРасходов
	|ИЗ
	|	ВременнаяТаблицаИзменениеПараметровВА КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.СтоимостьДляВычисленияАмортизации - ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДоходыИРасходы", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаДоходыИРасходы()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаУправленческий(ДокументСсылкаИзменениеПараметровВА, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ОтражениеДоходов", НСтр("ru = 'Отражение доходов'"));
	Запрос.УстановитьПараметр("ОтражениеРасходов", НСтр("ru = 'Отражение расходов'"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Период КАК Период,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический) КАК СценарийПланирования,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтоимостьДляВычисленияАмортизации - ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения > 0
	|			ТОГДА ТаблицаДокумента.СчетУчета
	|		ИНАЧЕ ТаблицаДокумента.СчетПереоценки
	|	КОНЕЦ КАК СчетДт,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтоимостьДляВычисленияАмортизации - ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения > 0
	|			ТОГДА ТаблицаДокумента.СчетПереоценки
	|		ИНАЧЕ ТаблицаДокумента.СчетУчета
	|	КОНЕЦ КАК СчетКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	0 КАК СуммаВалДт,
	|	0 КАК СуммаВалКт,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтоимостьДляВычисленияАмортизации - ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения > 0
	|			ТОГДА ТаблицаДокумента.СтоимостьДляВычисленияАмортизации - ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения
	|		ИНАЧЕ ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения - ТаблицаДокумента.СтоимостьДляВычисленияАмортизации
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтоимостьДляВычисленияАмортизации - ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения > 0
	|			ТОГДА &ОтражениеДоходов
	|		ИНАЧЕ &ОтражениеРасходов
	|	КОНЕЦ КАК Содержание
	|ИЗ
	|	ВременнаяТаблицаИзменениеПараметровВА КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.СтоимостьДляВычисленияАмортизации - ТаблицаДокумента.СтоимостьДляВычисленияАмортизацииДоИзменения <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаУправленческий", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаУправленческий()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаПараметрыВнеоборотныхАктивов(ДокументСсылкаИзменениеПараметровВА, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаИзменениеПараметровВА);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Период КАК Период,
	|	ТаблицаДокумента.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемПродукцииРаботДляВычисленияАмортизации,
	|	ТаблицаДокумента.СтоимостьДляВычисленияАмортизации КАК СтоимостьДляВычисленияАмортизации,
	|	ТаблицаДокумента.ПрименитьВТекущемМесяце КАК ПрименитьВТекущемМесяце,
	|	ТаблицаДокумента.СрокИспользованияДляВычисленияАмортизации КАК СрокИспользованияДляВычисленияАмортизации,
	|	ТаблицаДокумента.СчетЗатрат КАК СчетЗатрат,
	|	ТаблицаДокумента.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности
	|ИЗ
	|	ВременнаяТаблицаИзменениеПараметровВА КАК ТаблицаДокумента
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПараметрыВнеоборотныхАктивов", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаПараметрыВнеоборотныхАктивов()

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