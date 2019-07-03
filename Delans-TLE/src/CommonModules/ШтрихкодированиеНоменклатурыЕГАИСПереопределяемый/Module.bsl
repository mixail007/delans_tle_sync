
#Область ПрограммныйИнтерфейс

// В функции нужно реализовать подготовку данных для дальнейшей обработки штрихкодов.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой происходит обработка,
//  ДанныеШтрихкодов - Массив - полученные штрихкоды,
//  ПараметрыЗаполнения - Структура - параметры заполнения (см. ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти()).
//
// Возвращаемое значение:
//  Структура - подготовленные данные.
//
Функция ПодготовитьДанныеДляОбработкиШтрихкодов(Форма, ДанныеШтрихкодов, ПараметрыЗаполнения) Экспорт
	
	
	Возврат Неопределено;
	
КонецФункции

// В процедуре требуется реализовать алгоритм обработки полученных штрихкодов.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой происходит обработка,
//  ДанныеДляОбработки - Структура - подготовленные ранее данные для обработки,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ.
//
Процедура ОбработатьШтрихкоды(Форма, ДанныеДляОбработки, КэшированныеЗначения) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// В процедуре требуется реализовать алгоритм обработки полученных штрихкодов из ТСД.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой происходит обработка,
//  ДанныеДляОбработки - Структура - подготовленные ранее данные для обработки,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ.
//
Процедура ОбработатьДанныеИзТСД(Форма, ДанныеДляОбработки, КэшированныеЗначения) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// В функции требуется реализовать алгоритм получения массива штрихкодов по переданному отбору.
//
// Параметры:
//  Отбор - Структура - структура с ключами:
//   * Номенклатура - ОпределяемыйТип.Номенклатура - ссылка на номенклатуру,
//   * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - ссылка на характеристику номенклатуры,
//   * Упаковка - ОпределяемыйТип.Упаковка - ссылка на упаковку.
//
// Возвращаемое значение:
//  Массив - массив штрихкодов.
//
Функция ПолучитьШтрихкодыНоменклатуры(Отбор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура", Отбор.Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Отбор.Характеристика);
	Запрос.УстановитьПараметр("Упаковка", Отбор.Упаковка);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Штрихкоды.Штрихкод КАК Штрихкод
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК Штрихкоды
	|ГДЕ
	|	Штрихкоды.Номенклатура = &Номенклатура
	|	И Штрихкоды.Характеристика = &Характеристика
	|	И (Штрихкоды.ЕдиницаИзмерения = &Упаковка
	|			ИЛИ Штрихкоды.ЕдиницаИзмерения = ЗНАЧЕНИЕ(Справочник.ЕдиницыИзмерения.ПустаяСсылка))";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Штрихкод");
	
КонецФункции

// Получить данные о номенклатуре по штрихкоду.
//
// Параметры:
//  Штрихкод - Строка - считанный штрихкод.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НоменклатураЕГАИС - СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС - ссылка на алкогольную продукцию,
//   * Номенклатура - ОпределяемыйТип.Номенклатура - ссылка на номенклатуру,
//   * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - ссылка на характеристику номенклатуры.
//   * Упаковка - ОпределяемыйТип.Упаковка - ссылка на упаковку номенклатуры.
//  Неопределено - номенклатура не найдена.
//
Функция НайтиПоШтрихкоду(Штрихкод) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Штрихкоды.Номенклатура КАК Номенклатура,
	|	Штрихкоды.Характеристика КАК Характеристика,
	|	Штрихкоды.ЕдиницаИзмерения КАК Упаковка
	|ПОМЕСТИТЬ ДанныеПоШтрихкоду
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК Штрихкоды
	|ГДЕ
	|	Штрихкоды.Штрихкод = &Штрихкод
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция, ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка))) КАК АлкогольнаяПродукция,
	|	ТабличнаяЧасть.Номенклатура КАК Номенклатура,
	|	ТабличнаяЧасть.Характеристика КАК Характеристика
	|ПОМЕСТИТЬ СопоставленыеПозиции
	|ИЗ
	|	ДанныеПоШтрихкоду КАК ТабличнаяЧасть
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПО (СоответствиеНоменклатурыЕГАИС.Номенклатура = ТабличнаяЧасть.Номенклатура)
	|			И (СоответствиеНоменклатурыЕГАИС.Характеристика = ТабличнаяЧасть.Характеристика)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТабличнаяЧасть.Номенклатура,
	|	ТабличнаяЧасть.Характеристика
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция, ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка))) = 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеПоШтрихкоду.Номенклатура КАК Номенклатура,
	|	ДанныеПоШтрихкоду.Характеристика КАК Характеристика,
	|	ДанныеПоШтрихкоду.Упаковка КАК Упаковка,
	|	МАКСИМУМ(ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция, ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка))) КАК АлкогольнаяПродукция
	|ИЗ
	|	ДанныеПоШтрихкоду КАК ДанныеПоШтрихкоду
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленыеПозиции КАК СоответствиеНоменклатурыЕГАИС
	|		ПО ДанныеПоШтрихкоду.Номенклатура = СоответствиеНоменклатурыЕГАИС.Номенклатура
	|			И ДанныеПоШтрихкоду.Характеристика = СоответствиеНоменклатурыЕГАИС.Характеристика
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеПоШтрихкоду.Номенклатура,
	|	ДанныеПоШтрихкоду.Характеристика,
	|	ДанныеПоШтрихкоду.Упаковка";
	
	Запрос.УстановитьПараметр("Штрихкод", Штрихкод);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ВозвращаемоеЗначение = Новый Структура;
		ВозвращаемоеЗначение.Вставить("АлкогольнаяПродукция", Выборка.АлкогольнаяПродукция);
		ВозвращаемоеЗначение.Вставить("Номенклатура",         Выборка.Номенклатура);
		ВозвращаемоеЗначение.Вставить("Характеристика",       Выборка.Характеристика);
		ВозвращаемоеЗначение.Вставить("Упаковка",             Выборка.Упаковка);
		
		Возврат ВозвращаемоеЗначение;
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// В функции требуется определить право на регистрацию нового штрихкода для текущего пользователя.
//
// Возвращаемое значение:
//  Булево - Истина, если есть право на регистрацию штрихкода. Ложь - в противном случае.
//
Функция ЕстьПравоРегистрацииШтрихкодовНоменклатуры() Экспорт
	
	Возврат ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.ШтрихкодыНоменклатуры);
	
КонецФункции

#КонецОбласти

