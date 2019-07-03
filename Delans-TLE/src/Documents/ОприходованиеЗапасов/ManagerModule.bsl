#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область Проведение

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаОприходованиеЗапасов, СтруктураДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОприходованиеЗапасовЗапасы.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ОприходованиеЗапасовЗапасы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ОприходованиеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ВЫБОР
	|		КОГДА ОприходованиеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Склад)
	|				ИЛИ ОприходованиеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Розница)
	|			ТОГДА ОприходованиеЗапасовЗапасы.Номенклатура.СчетУчетаЗапасов
	|		ИНАЧЕ ОприходованиеЗапасовЗапасы.Номенклатура.СчетУчетаЗатрат
	|	КОНЕЦ КАК СчетУчета,
	|	ОприходованиеЗапасовЗапасы.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &ИспользоватьХарактеристики
	|			ТОГДА ОприходованиеЗапасовЗапасы.Характеристика
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Характеристика,
	|	ВЫБОР
	|		КОГДА &ИспользоватьПартии
	|			ТОГДА ОприходованиеЗапасовЗапасы.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Партия,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ОприходованиеЗапасовЗапасы.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
	|			ТОГДА ОприходованиеЗапасовЗапасы.Количество
	|		ИНАЧЕ ОприходованиеЗапасовЗапасы.Количество * ОприходованиеЗапасовЗапасы.ЕдиницаИзмерения.Коэффициент
	|	КОНЕЦ КАК Количество,
	|	ИСТИНА КАК ФиксированнаяСтоимость,
	|	ОприходованиеЗапасовЗапасы.Сумма КАК Сумма,
	|	ЗНАЧЕНИЕ(ВидДвиженияБухгалтерии.Дебет) КАК ВидДвиженияУправленческий,
	|	ОприходованиеЗапасовЗапасы.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ОприходованиеЗапасовЗапасы.НомерГТД КАК НомерГТД,
	|	&ОприходованиеЗапасов КАК СодержаниеПроводки
	|ИЗ
	|	Документ.ОприходованиеЗапасов.Запасы КАК ОприходованиеЗапасовЗапасы
	|ГДЕ
	|	ОприходованиеЗапасовЗапасы.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОприходованиеЗапасовЗапасы.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ОприходованиеЗапасовЗапасы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ОприходованиеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ВЫБОР
	|		КОГДА &УчетПоЯчейкам
	|			ТОГДА ОприходованиеЗапасовЗапасы.Ссылка.Ячейка
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Ячейка,
	|	ОприходованиеЗапасовЗапасы.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &ИспользоватьХарактеристики
	|			ТОГДА ОприходованиеЗапасовЗапасы.Характеристика
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Характеристика,
	|	ВЫБОР
	|		КОГДА &ИспользоватьПартии
	|			ТОГДА ОприходованиеЗапасовЗапасы.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Партия,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ОприходованиеЗапасовЗапасы.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
	|			ТОГДА ОприходованиеЗапасовЗапасы.Количество
	|		ИНАЧЕ ОприходованиеЗапасовЗапасы.Количество * ОприходованиеЗапасовЗапасы.ЕдиницаИзмерения.Коэффициент
	|	КОНЕЦ КАК Количество
	|ИЗ
	|	Документ.ОприходованиеЗапасов.Запасы КАК ОприходованиеЗапасовЗапасы
	|ГДЕ
	|	ОприходованиеЗапасовЗапасы.Ссылка = &Ссылка
	|	И ОприходованиеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница.ОрдерныйСклад = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОприходованиеЗапасовЗапасы.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ОприходованиеЗапасовЗапасы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ОприходованиеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ОприходованиеЗапасовЗапасы.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &ИспользоватьХарактеристики
	|			ТОГДА ОприходованиеЗапасовЗапасы.Характеристика
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Характеристика,
	|	ВЫБОР
	|		КОГДА &ИспользоватьПартии
	|			ТОГДА ОприходованиеЗапасовЗапасы.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Партия,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ОприходованиеЗапасовЗапасы.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
	|			ТОГДА ОприходованиеЗапасовЗапасы.Количество
	|		ИНАЧЕ ОприходованиеЗапасовЗапасы.Количество * ОприходованиеЗапасовЗапасы.ЕдиницаИзмерения.Коэффициент
	|	КОНЕЦ КАК Количество
	|ИЗ
	|	Документ.ОприходованиеЗапасов.Запасы КАК ОприходованиеЗапасовЗапасы
	|ГДЕ
	|	ОприходованиеЗапасовЗапасы.Ссылка = &Ссылка
	|	И ОприходованиеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница.ОрдерныйСклад = ИСТИНА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОприходованиеЗапасовЗапасы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.Прочее) КАК НаправлениеДеятельности,
	|	СУММА(ОприходованиеЗапасовЗапасы.Сумма) КАК СуммаДоходов,
	|	СУММА(ОприходованиеЗапасовЗапасы.Сумма) КАК Сумма,
	|	ОприходованиеЗапасовЗапасы.Ссылка.Корреспонденция КАК СчетУчета,
	|	ОприходованиеЗапасовЗапасы.Номенклатура КАК Аналитика,
	|	ЗНАЧЕНИЕ(ВидДвиженияБухгалтерии.Кредит) КАК ВидДвиженияУправленческий,
	|	&ПоступлениеДоходов КАК СодержаниеПроводки
	|ИЗ
	|	Документ.ОприходованиеЗапасов.Запасы КАК ОприходованиеЗапасовЗапасы
	|ГДЕ
	|	ОприходованиеЗапасовЗапасы.Ссылка = &Ссылка
	|	И ОприходованиеЗапасовЗапасы.Ссылка.Корреспонденция.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеДоходы)
	|	И ОприходованиеЗапасовЗапасы.Сумма > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ОприходованиеЗапасовЗапасы.Ссылка,
	|	ОприходованиеЗапасовЗапасы.Ссылка.Дата,
	|	ОприходованиеЗапасовЗапасы.Ссылка.Корреспонденция,
	|	ОприходованиеЗапасовЗапасы.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ТаблицаЗапасыВРазрезеГТД.НомерСтроки) КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаЗапасыВРазрезеГТД.Ссылка.Дата КАК Период,
	|	ТаблицаЗапасыВРазрезеГТД.Ссылка.Организация КАК Организация,
	|	ТаблицаЗапасыВРазрезеГТД.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасыВРазрезеГТД.Характеристика КАК Характеристика,
	|	ТаблицаЗапасыВРазрезеГТД.Партия КАК Партия,
	|	ТаблицаЗапасыВРазрезеГТД.НомерГТД КАК НомерГТД,
	|	ТаблицаЗапасыВРазрезеГТД.СтранаПроисхождения КАК СтранаПроисхождения,
	|	СУММА(ТаблицаЗапасыВРазрезеГТД.Количество) КАК Количество
	|ИЗ
	|	Документ.ОприходованиеЗапасов.Запасы КАК ТаблицаЗапасыВРазрезеГТД
	|ГДЕ
	|	ТаблицаЗапасыВРазрезеГТД.Ссылка = &Ссылка
	|	И ТаблицаЗапасыВРазрезеГТД.СтранаПроисхождения <> ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)
	|	И ТаблицаЗапасыВРазрезеГТД.СтранаПроисхождения <> ЗНАЧЕНИЕ(Справочник.СтраныМира.ПустаяССылка)
	|	И ТаблицаЗапасыВРазрезеГТД.НомерГТД <> ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяССылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаЗапасыВРазрезеГТД.Ссылка.Дата,
	|	ТаблицаЗапасыВРазрезеГТД.Ссылка.Организация,
	|	ТаблицаЗапасыВРазрезеГТД.Номенклатура,
	|	ТаблицаЗапасыВРазрезеГТД.Характеристика,
	|	ТаблицаЗапасыВРазрезеГТД.Партия,
	|	ТаблицаЗапасыВРазрезеГТД.НомерГТД,
	|	ТаблицаЗапасыВРазрезеГТД.СтранаПроисхождения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОприходованиеЗапасовЗапасы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический) КАК СценарийПланирования,
	|	ВЫБОР
	|		КОГДА ОприходованиеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Склад)
	|				ИЛИ ОприходованиеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Розница)
	|			ТОГДА ОприходованиеЗапасовЗапасы.Номенклатура.СчетУчетаЗапасов
	|		ИНАЧЕ ОприходованиеЗапасовЗапасы.Номенклатура.СчетУчетаЗатрат
	|	КОНЕЦ КАК СчетДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	0 КАК СуммаВалДт,
	|	ОприходованиеЗапасовЗапасы.Ссылка.Корреспонденция КАК СчетКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	0 КАК СуммаВалКт,
	|	СУММА(ОприходованиеЗапасовЗапасы.Сумма) КАК Сумма,
	|	&ОприходованиеЗапасов КАК Содержание
	|ИЗ
	|	Документ.ОприходованиеЗапасов.Запасы КАК ОприходованиеЗапасовЗапасы
	|ГДЕ
	|	ОприходованиеЗапасовЗапасы.Ссылка = &Ссылка
	|	И ОприходованиеЗапасовЗапасы.Сумма > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ОприходованиеЗапасовЗапасы.Ссылка.Дата,
	|	ВЫБОР
	|		КОГДА ОприходованиеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Склад)
	|				ИЛИ ОприходованиеЗапасовЗапасы.Ссылка.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Розница)
	|			ТОГДА ОприходованиеЗапасовЗапасы.Номенклатура.СчетУчетаЗапасов
	|		ИНАЧЕ ОприходованиеЗапасовЗапасы.Номенклатура.СчетУчетаЗатрат
	|	КОНЕЦ,
	|	ОприходованиеЗапасовЗапасы.Ссылка.Корреспонденция
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.Ссылка.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаЗапасы.Ссылка.Дата КАК ДатаСобытия,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииСерийныхНомеров.Приход) КАК Операция,
	|	ТаблицаСерийныеНомера.СерийныйНомер КАК СерийныйНомер,
	|	&Организация КАК Организация,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика,
	|	ТаблицаЗапасы.Партия КАК Партия,
	|	ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаЗапасы.Ссылка.Ячейка КАК Ячейка,
	|	1 КАК Количество
	|ИЗ
	|	Документ.ОприходованиеЗапасов.Запасы КАК ТаблицаЗапасы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОприходованиеЗапасов.СерийныеНомера КАК ТаблицаСерийныеНомера
	|		ПО ТаблицаЗапасы.Ссылка = ТаблицаСерийныеНомера.Ссылка
	|			И ТаблицаЗапасы.КлючСвязи = ТаблицаСерийныеНомера.КлючСвязи
	|ГДЕ
	|	ТаблицаСерийныеНомера.Ссылка = &Ссылка
	|	И ТаблицаЗапасы.Ссылка = &Ссылка
	|	И &ИспользоватьСерийныеНомера
	|	И НЕ ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница.ОрдерныйСклад");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаОприходованиеЗапасов);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.Дляпроведения.Организация);
	Запрос.УстановитьПараметр("ИспользоватьХарактеристики", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьХарактеристики);
	Запрос.УстановитьПараметр("УчетПоЯчейкам", СтруктураДополнительныеСвойства.УчетнаяПолитика.УчетПоЯчейкам);
	Запрос.УстановитьПараметр("ИспользоватьПартии", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьПартии);
	
	Запрос.УстановитьПараметр("ОприходованиеЗапасов", НСтр("ru = 'Оприходование запасов'"));
	Запрос.УстановитьПараметр("ПоступлениеДоходов", НСтр("ru = 'Поступление прочих доходов'"));
	Запрос.УстановитьПараметр("ПрочееОприходование", НСтр("ru = 'Прочее оприходование запасов'"));
	
	Запрос.УстановитьПараметр("ИспользоватьСерийныеНомера", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьСерийныеНомера);
	
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасы", МассивРезультатов[0].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасыНаСкладах", МассивРезультатов[1].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасыКПоступлениюНаСклады", МассивРезультатов[2].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДоходыИРасходы", МассивРезультатов[3].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасыВРазрезеГТД", МассивРезультатов[4].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаУправленческий", МассивРезультатов[5].Выгрузить());
	
	РезультатЗапроса6 = МассивРезультатов[6].Выгрузить();
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерийныеНомераГарантии", РезультатЗапроса6);
	Если СтруктураДополнительныеСвойства.УчетнаяПолитика.ОстаткиСерийныхНомеров Тогда
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерийныеНомераОстатки", РезультатЗапроса6);
	Иначе
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерийныеНомераОстатки", Новый ТаблицаЗначений);
	КонецЕсли;
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылкаОприходованиеЗапасов, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Если Не УправлениеНебольшойФирмойСервер.ВыполнитьКонтрольОстатков() Тогда
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Если временные таблицы "ДвиженияЗапасыНаСкладахИзменение", "ДвиженияЗапасыИзменение"
	// содержат записи, необходимо выполнить контроль реализации товаров.
	
	Если СтруктураВременныеТаблицы.ДвиженияЗапасыНаСкладахИзменение
		ИЛИ СтруктураВременныеТаблицы.ДвиженияЗапасыВРазрезеГТДИзменение
		ИЛИ СтруктураВременныеТаблицы.ДвиженияЗапасыИзменение
		Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗапасыНаСкладахИзменение.НомерСтроки КАК НомерСтроки,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Организация) КАК ОрганизацияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.СтруктурнаяЕдиница) КАК СтруктурнаяЕдиницаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Номенклатура) КАК НоменклатураПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Характеристика) КАК ХарактеристикаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Партия) КАК ПартияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Ячейка) КАК ЯчейкаПредставление,
		|	ЗапасыНаСкладахОстатки.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы КАК ТипСтруктурнойЕдиницы,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЗапасыНаСкладахОстатки.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
		|	ЕСТЬNULL(ДвиженияЗапасыНаСкладахИзменение.КоличествоИзменение, 0) + ЕСТЬNULL(ЗапасыНаСкладахОстатки.КоличествоОстаток, 0) КАК ОстатокЗапасыНаСкладах,
		|	ЕСТЬNULL(ЗапасыНаСкладахОстатки.КоличествоОстаток, 0) КАК КоличествоОстатокЗапасыНаСкладах
		|ИЗ
		|	ДвиженияЗапасыНаСкладахИзменение КАК ДвиженияЗапасыНаСкладахИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗапасыНаСкладах.Остатки(
		|				&МоментКонтроля,
		|				(Организация, СтруктурнаяЕдиница, Номенклатура, Характеристика, Партия, Ячейка) В
		|					(ВЫБРАТЬ
		|						ДвиженияЗапасыНаСкладахИзменение.Организация КАК Организация,
		|						ДвиженияЗапасыНаСкладахИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|						ДвиженияЗапасыНаСкладахИзменение.Номенклатура КАК Номенклатура,
		|						ДвиженияЗапасыНаСкладахИзменение.Характеристика КАК Характеристика,
		|						ДвиженияЗапасыНаСкладахИзменение.Партия КАК Партия,
		|						ДвиженияЗапасыНаСкладахИзменение.Ячейка КАК Ячейка
		|					ИЗ
		|						ДвиженияЗапасыНаСкладахИзменение КАК ДвиженияЗапасыНаСкладахИзменение)) КАК ЗапасыНаСкладахОстатки
		|		ПО ДвиженияЗапасыНаСкладахИзменение.Организация = ЗапасыНаСкладахОстатки.Организация
		|			И ДвиженияЗапасыНаСкладахИзменение.СтруктурнаяЕдиница = ЗапасыНаСкладахОстатки.СтруктурнаяЕдиница
		|			И ДвиженияЗапасыНаСкладахИзменение.Номенклатура = ЗапасыНаСкладахОстатки.Номенклатура
		|			И ДвиженияЗапасыНаСкладахИзменение.Характеристика = ЗапасыНаСкладахОстатки.Характеристика
		|			И ДвиженияЗапасыНаСкладахИзменение.Партия = ЗапасыНаСкладахОстатки.Партия
		|			И ДвиженияЗапасыНаСкладахИзменение.Ячейка = ЗапасыНаСкладахОстатки.Ячейка
		|ГДЕ
		|	ЕСТЬNULL(ЗапасыНаСкладахОстатки.КоличествоОстаток, 0) < 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияЗапасыИзменение.НомерСтроки КАК НомерСтроки,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыИзменение.Организация) КАК ОрганизацияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыИзменение.СтруктурнаяЕдиница) КАК СтруктурнаяЕдиницаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыИзменение.СчетУчета) КАК СчетУчетаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыИзменение.Номенклатура) КАК НоменклатураПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыИзменение.Характеристика) КАК ХарактеристикаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыИзменение.Партия) КАК ПартияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыИзменение.ЗаказПокупателя) КАК ЗаказПокупателяПредставление,
		|	ЗапасыОстатки.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы КАК ТипСтруктурнойЕдиницы,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЗапасыОстатки.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
		|	ЕСТЬNULL(ДвиженияЗапасыИзменение.КоличествоИзменение, 0) + ЕСТЬNULL(ЗапасыОстатки.КоличествоОстаток, 0) КАК ОстатокЗапасы,
		|	ЕСТЬNULL(ЗапасыОстатки.КоличествоОстаток, 0) КАК КоличествоОстатокЗапасы,
		|	ЕСТЬNULL(ЗапасыОстатки.СуммаОстаток, 0) КАК СуммаОстатокЗапасы
		|ИЗ
		|	ДвиженияЗапасыИзменение КАК ДвиженияЗапасыИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Запасы.Остатки(
		|				&МоментКонтроля,
		|				(Организация, СтруктурнаяЕдиница, СчетУчета, Номенклатура, Характеристика, Партия, ЗаказПокупателя) В
		|					(ВЫБРАТЬ
		|						ДвиженияЗапасыИзменение.Организация КАК Организация,
		|						ДвиженияЗапасыИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|						ДвиженияЗапасыИзменение.СчетУчета КАК СчетУчета,
		|						ДвиженияЗапасыИзменение.Номенклатура КАК Номенклатура,
		|						ДвиженияЗапасыИзменение.Характеристика КАК Характеристика,
		|						ДвиженияЗапасыИзменение.Партия КАК Партия,
		|						ДвиженияЗапасыИзменение.ЗаказПокупателя КАК ЗаказПокупателя
		|					ИЗ
		|						ДвиженияЗапасыИзменение КАК ДвиженияЗапасыИзменение)) КАК ЗапасыОстатки
		|		ПО ДвиженияЗапасыИзменение.Организация = ЗапасыОстатки.Организация
		|			И ДвиженияЗапасыИзменение.СтруктурнаяЕдиница = ЗапасыОстатки.СтруктурнаяЕдиница
		|			И ДвиженияЗапасыИзменение.СчетУчета = ЗапасыОстатки.СчетУчета
		|			И ДвиженияЗапасыИзменение.Номенклатура = ЗапасыОстатки.Номенклатура
		|			И ДвиженияЗапасыИзменение.Характеристика = ЗапасыОстатки.Характеристика
		|			И ДвиженияЗапасыИзменение.Партия = ЗапасыОстатки.Партия
		|			И ДвиженияЗапасыИзменение.ЗаказПокупателя = ЗапасыОстатки.ЗаказПокупателя
		|ГДЕ
		|	ЕСТЬNULL(ЗапасыОстатки.КоличествоОстаток, 0) < 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияЗапасыВРазрезеГТДИзменение.НомерСтроки КАК НомерСтроки,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыВРазрезеГТДИзменение.Организация) КАК ОрганизацияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыВРазрезеГТДИзменение.НомерГТД) КАК НомерГТДПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыВРазрезеГТДИзменение.Номенклатура) КАК НоменклатураПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыВРазрезеГТДИзменение.Характеристика) КАК ХарактеристикаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыВРазрезеГТДИзменение.Партия) КАК ПартияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыВРазрезеГТДИзменение.СтранаПроисхождения) КАК СтранаПроисхожденияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЗапасыВРазрезеГТДОстатки.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
		|	ЕСТЬNULL(ДвиженияЗапасыВРазрезеГТДИзменение.КоличествоИзменение, 0) + ЕСТЬNULL(ЗапасыВРазрезеГТДОстатки.КоличествоОстаток, 0) КАК ОстатокЗапасыВРазрезеГТД,
		|	ЕСТЬNULL(ЗапасыВРазрезеГТДОстатки.КоличествоОстаток, 0) КАК КоличествоОстатокЗапасыВРазрезеГТД
		|ИЗ
		|	ДвиженияЗапасыВРазрезеГТДИзменение КАК ДвиженияЗапасыВРазрезеГТДИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗапасыВРазрезеГТД.Остатки(
		|				&МоментКонтроля,
		|				(Организация, НомерГТД, Номенклатура, Характеристика, Партия, СтранаПроисхождения) В
		|					(ВЫБРАТЬ
		|						ДвиженияЗапасыВРазрезеГТДИзменение.Организация КАК Организация,
		|						ДвиженияЗапасыВРазрезеГТДИзменение.НомерГТД КАК НомерГТД,
		|						ДвиженияЗапасыВРазрезеГТДИзменение.Номенклатура КАК Номенклатура,
		|						ДвиженияЗапасыВРазрезеГТДИзменение.Характеристика КАК Характеристика,
		|						ДвиженияЗапасыВРазрезеГТДИзменение.Партия КАК Партия,
		|						ДвиженияЗапасыВРазрезеГТДИзменение.СтранаПроисхождения КАК СтранаПроисхождения
		|					ИЗ
		|						ДвиженияЗапасыВРазрезеГТДИзменение КАК ДвиженияЗапасыВРазрезеГТДИзменение)) КАК ЗапасыВРазрезеГТДОстатки
		|		ПО ДвиженияЗапасыВРазрезеГТДИзменение.Организация = ЗапасыВРазрезеГТДОстатки.Организация
		|			И ДвиженияЗапасыВРазрезеГТДИзменение.НомерГТД = ЗапасыВРазрезеГТДОстатки.НомерГТД
		|			И ДвиженияЗапасыВРазрезеГТДИзменение.Номенклатура = ЗапасыВРазрезеГТДОстатки.Номенклатура
		|			И ДвиженияЗапасыВРазрезеГТДИзменение.Характеристика = ЗапасыВРазрезеГТДОстатки.Характеристика
		|			И ДвиженияЗапасыВРазрезеГТДИзменение.Партия = ЗапасыВРазрезеГТДОстатки.Партия
		|			И ДвиженияЗапасыВРазрезеГТДИзменение.СтранаПроисхождения = ЗапасыВРазрезеГТДОстатки.СтранаПроисхождения
		|ГДЕ
		|	ЕСТЬNULL(ЗапасыВРазрезеГТДОстатки.КоличествоОстаток, 0) < 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки");
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		Если НЕ МассивРезультатов[0].Пустой()
			ИЛИ НЕ МассивРезультатов[1].Пустой()
			ИЛИ НЕ МассивРезультатов[2].Пустой()
			Тогда
			
			ДокументОбъектОприходованиеЗапасов = ДокументСсылкаОприходованиеЗапасов.ПолучитьОбъект()
			
		КонецЕсли;
		
		// Отрицательный остаток запасов на складе.
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструЗапасыНаСкладах(ДокументОбъектОприходованиеЗапасов, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
		// Отрицательный остаток учета запасов и затрат.
		Если НЕ МассивРезультатов[1].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструЗапасы(ДокументОбъектОприходованиеЗапасов, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
		// Отрицательный остаток по остаткам запасов в разрезе номеров ГТД.
		Если Константы.КонтролироватьОстаткиПоНомерамГТД.Получить()
			И НЕ МассивРезультатов[2].Пустой() Тогда
			
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструЗапасыВРазрезеГТД(ДокументОбъектОприходованиеЗапасов, ВыборкаИзРезультатаЗапроса, Отказ);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ВыполнитьКонтроль()

#КонецОбласти

#Область ИнтерфейсПечати

Функция СформироватьАктОприходованияЗапасов(ПечатнаяФорма, МассивОбъектов, ОбъектыПечати)
	Перем ПервыйДокумент, НомерСтрокиНачало;
	
	ТабличныйДокумент = ПечатнаяФорма.ТабличныйДокумент;
	Макет = УправлениеПечатью.МакетПечатнойФормы(ПечатнаяФорма.ПолныйПутьКМакету);
	ВалютаУчета = Константы.ВалютаУчета.Получить();
	
	Для каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало);
		
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОприходованиеЗапасов.Дата КАК ДатаДокумента,
		|	ОприходованиеЗапасов.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	ОприходованиеЗапасов.Организация КАК Организация,
		|	ОприходованиеЗапасов.Номер,
		|	ОприходованиеЗапасов.Организация.Префикс КАК Префикс,
		|	ОприходованиеЗапасов.Ячейка КАК Ячейка,
		|	ОприходованиеЗапасов.ВидЦен КАК ВидЦен,
		|	ОприходованиеЗапасов.ПодписьКладовщика.Должность КАК ДолжностьКладовщика,
		|	ОприходованиеЗапасов.ПодписьКладовщика.РасшифровкаПодписи КАК РасшифровкаПодписиКладовщика,
		|	ОприходованиеЗапасов.Запасы.(
		|		НомерСтроки КАК НомерСтроки,
		|		ВЫБОР
		|			КОГДА (ВЫРАЗИТЬ(ОприходованиеЗапасов.Запасы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))) = """"
		|				ТОГДА ОприходованиеЗапасов.Запасы.Номенклатура.Наименование
		|			ИНАЧЕ ВЫРАЗИТЬ(ОприходованиеЗапасов.Запасы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))
		|		КОНЕЦ КАК Запас,
		|		Номенклатура.Артикул КАК Артикул,
		|		Номенклатура.Код КАК Код,
		|		ЕдиницаИзмерения КАК ЕдиницаХранения,
		|		Количество КАК Количество,
		|		Цена КАК Цена,
		|		Сумма КАК Сумма,
		|		Характеристика,
		|		Партия,
		|		КлючСвязи
		|	),
		|	ОприходованиеЗапасов.СерийныеНомера.(
		|		СерийныйНомер,
		|		КлючСвязи
		|	)
		|ИЗ
		|	Документ.ОприходованиеЗапасов КАК ОприходованиеЗапасов
		|ГДЕ
		|	ОприходованиеЗапасов.Ссылка = &ТекущийДокумент
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		
		ВыборкаСтрокЗапасы = Шапка.Запасы.Выбрать();
		ВыборкаСтрокСерийныеНомера = Шапка.СерийныеНомера.Выбрать();
		
		НомерДокумента = ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(Шапка.ДатаДокумента, Шапка.Номер, Шапка.Префикс);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = "Акт об оприходовании запасов № "
			+ НомерДокумента
			+ " от "
			+ Формат(Шапка.ДатаДокумента, "ДЛФ=DD");
		
		ОбластьМакета.Параметры.Получатель = Шапка.СтруктурнаяЕдиница;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ВремяПечати");
		ОбластьМакета.Параметры.ВремяПечати =
			"Дата и время печати: "
			+ ТекущаяДата()
			+ ". Пользователь: "
			+ Пользователи.ТекущийПользователь();
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		
		СуммаВсего 			= 0;
		ВсегоНаименований	= 0;
		
		Пока ВыборкаСтрокЗапасы.Следующий() Цикл
			
			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокЗапасы);
			
			СтрокаСерийныеНомера = РаботаССерийнымиНомерами.СтрокаСерийныеНомераИзВыборки(ВыборкаСтрокСерийныеНомера, ВыборкаСтрокЗапасы.КлючСвязи);
			ОбластьМакета.Параметры.Запас = УправлениеНебольшойФирмойСервер.ПолучитьПредставлениеНоменклатурыДляПечати(ВыборкаСтрокЗапасы.Запас, 
			ВыборкаСтрокЗапасы.Характеристика, ВыборкаСтрокЗапасы.Артикул, СтрокаСерийныеНомера);
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			СуммаВсего			= СуммаВсего + ВыборкаСтрокЗапасы.Сумма;
			ВсегоНаименований	= ВсегоНаименований + 1;
			
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		
		ОбластьМакета.Параметры.СуммаПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаВсего, ВалютаУчета);
		
		ТекстИтоговойСтроки = НСтр("ru = 'Всего наименований %ВсегоНаименований%, на сумму %СуммаВсего% %ВалютаУпр%'");
		
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%ВсегоНаименований%", ВсегоНаименований);
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%СуммаВсего%", Формат(СуммаВсего, "ЧЦ=15; ЧДЦ=2"));
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%ВалютаУпр%", Строка(ВалютаУчета));
		
		ОбластьМакета.Параметры.ИтоговаяСтрока = ТекстИтоговойСтроки;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "АктОбОприходованиеЗапасов");
	Если ПечатнаяФорма <> Неопределено Тогда
		
		ПечатнаяФорма.ТабличныйДокумент = Новый ТабличныйДокумент;
		ПечатнаяФорма.ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОприходованиеЗапасов_АктОбОприходованиеЗапасов";
		ПечатнаяФорма.ПолныйПутьКМакету = "Документ.ОприходованиеЗапасов.ПФ_MXL_АктОбОприходованиеЗапасов";
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Акт об оприходовании запасов'");
		
		СформироватьАктОприходованияЗапасов(ПечатнаяФорма, МассивОбъектов, ОбъектыПечати);
		
	КонецЕсли;
	
	// параметры отправки печатных форм по электронной почте
	УправлениеНебольшойФирмойСервер.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктОбОприходованиеЗапасов";
	КомандаПечати.Представление = НСтр("ru = 'Акт об оприходовании запасов'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 1;
	
	Если ПравоДоступа("Просмотр", Метаданные.Обработки.ПечатьЭтикетокИЦенников)
		И ПолучитьФункциональнуюОпцию("ПечатьЭтикетокИЦенников")Тогда
		
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеНебольшойФирмойКлиент.ПечатьЭтикетокИЦенниковИзДокументов";
		КомандаПечати.Идентификатор = "ПечатьЭтикетокИзОприходованиеЗапасов";
		КомандаПечати.Представление = НСтр("ru = 'Печать этикеток'");
		КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка,ФормаСпискаДокументов";
		КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
		КомандаПечати.Порядок = 4;
		
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеНебольшойФирмойКлиент.ПечатьЭтикетокИЦенниковИзДокументов";
		КомандаПечати.Идентификатор = "ПечатьЦенниковИзОприходованиеЗапасов";
		КомандаПечати.Представление = НСтр("ru = 'Печать ценников'");
		КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка,ФормаСпискаДокументов";
		КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
		КомандаПечати.Порядок = 7;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли