////////////////////////////////////////////////////////////////////////////////
// ДоставкаСервер: процедуры и функции расчета данных доставки.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция определяет вводился ли раннее элемент расчета
//
// ЗначениеИдентификатора (Строка) - значение реквизита Идентификатор элемента справочника ПараметрыРасчетовДоставки
//
Функция ПараметрРасчетаСуществует(ЗначениеИдентификатора) Экспорт
	
	Если ПустаяСтрока(ЗначениеИдентификатора)Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат НЕ Справочники.ПараметрыРасчетовДоставки.НайтиПоРеквизиту("Идентификатор", ЗначениеИдентификатора).Пустая();
	
КонецФункции // ПараметрРасчетаСуществует()

// Процедура заполняет таблицу параметров по тексту формул
//
// ПараметрыРасчетов (ТаблицаЗначений, ТабличнаяЧасть) - таблица, в котрую будут добавлены используемые параметры.
//		Колонки:
//		Параметр (СправочникСсылка.ПараметрыРасчетовДоставки) - параметр, значение которого содержится в таблице
// ЗначенияФормулы (ТаблицаЗначений, ТабличнаяЧасть) - таблица фиксированных значений, использумых в формуле
//		Колонки:
//		Идентификатор (Строка) - Идентификатор значения (как он отображается в формуле)
//		Значение (Произвольный) - Собственно само значение
// ФормулаСтоимости (Строка) - текст формулы расчета стоимости
// ФормулаСебестоимости (Строка) - текст формулы расчета себестоимости
// Отказ (Булево) - Признак ошибки разбора формул
//
Процедура ОбновитьПараметрыРасчета(ПараметрыРасчетов, ЗначенияФормулы, ФормулаСтоимости, ФормулаСебестоимости, Отказ) Экспорт
	
	Ошибки = Неопределено;
	МассивПараметров = Новый Массив;
	
	ОшибкаВФормуле = Ложь;
	ДобавитьПараметрыВСтруктуру(ФормулаСтоимости, МассивПараметров, ОшибкаВФормуле);
	Если ОшибкаВФормуле Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
		Ошибки, 
		"Объект.ФормулаСтоимости", 
		НСтр("ru = 'Ошибка составления формулы расчета стоимости'"),
		"Объект.ФормулаСтоимости");
		Отказ = Истина;
	КонецЕсли;
	ОшибкаВФормуле = Ложь;
	ДобавитьПараметрыВСтруктуру(ФормулаСебестоимости, МассивПараметров, ОшибкаВФормуле);
	Если ОшибкаВФормуле Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
		Ошибки, 
		"Объект.ФормулаСебестоимости", 
		НСтр("ru = 'Ошибка составления формулы расчета себестоимости'"), 
		"Объект.ФормулаСебестоимости");
		Отказ = Истина;  
	КонецЕсли;
	Если Отказ Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
		Возврат;
	КонецЕсли; 
	
	ТаблицаПараметров = Новый ТаблицаЗначений;
	ТаблицаПараметров.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(100)));
	Для каждого Параметр Из МассивПараметров Цикл
		Если Найти(Параметр, ".")>0 Тогда
			Продолжить;
		КонецЕсли; 
		ТаблицаПараметров.Добавить().Имя = Параметр;
	КонецЦикла; 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаПараметров", ТаблицаПараметров);
	Запрос.УстановитьПараметр("ЗначенияФормулы", ЗначенияФормулы.Выгрузить());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаПараметров.Имя
	|ПОМЕСТИТЬ ТаблицаПараметров
	|ИЗ
	|	&ТаблицаПараметров КАК ТаблицаПараметров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗначенияФормулы.Идентификатор
	|ПОМЕСТИТЬ ЗначенияФормулы
	|ИЗ
	|	&ЗначенияФормулы КАК ЗначенияФормулы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПараметрыРасчетовДоставки.Ссылка КАК Параметр,
	|	ПараметрыРасчетовДоставки.Идентификатор
	|ИЗ
	|	Справочник.ПараметрыРасчетовДоставки КАК ПараметрыРасчетовДоставки
	|ГДЕ
	|	ПараметрыРасчетовДоставки.Идентификатор В
	|			(ВЫБРАТЬ
	|				ТаблицаПараметров.Имя
	|			ИЗ
	|				ТаблицаПараметров КАК ТаблицаПараметров)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПараметров.Имя
	|ИЗ
	|	ТаблицаПараметров КАК ТаблицаПараметров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПараметрыРасчетовДоставки КАК ПараметрыРасчетовДоставки
	|		ПО ТаблицаПараметров.Имя = ПараметрыРасчетовДоставки.Идентификатор
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЗначенияФормулы КАК ЗначенияФормулы
	|		ПО ТаблицаПараметров.Имя = ЗначенияФормулы.Идентификатор
	|ГДЕ
	|	ПараметрыРасчетовДоставки.Ссылка ЕСТЬ NULL 
	|	И ЗначенияФормулы.Идентификатор ЕСТЬ NULL ";
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	Если НЕ РезультатЗапроса.Получить(3).Пустой() Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
		Ошибки, 
		"Объект", 
		НСтр("ru = 'В формулах используются несуществующие параметры'"),
		"Объект");
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
		Возврат;
	КонецЕсли;
	
	ВыборкаПараметров = РезультатЗапроса.Получить(2).Выбрать();
	Пока ВыборкаПараметров.Следующий() Цикл
		ПараметрыРасчетов.Добавить().Параметр = ВыборкаПараметров.Параметр;	
	КонецЦикла; 

КонецПроцедуры

// Функция выполняет расчет стоимости доставки по формуле.
//
// Контекст (ДанныеФормы) - данные заказа покупателя
// СтруктураПараметров (Структура) - структура значенний параметров, устанавливаемых вручную
//
Функция СтоимостьДоставки(Контекст, СтруктураПараметров) Экспорт
	
	СлужбаДоставки = Контекст.СлужбаДоставки;
	Если НЕ ЗначениеЗаполнено(СлужбаДоставки) Тогда
		Возврат 0;
	КонецЕсли; 
	
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СлужбаДоставки, "ВариантУчета, ФормулаСтоимости, ФормулаСебестоимости");
	
	Если СтруктураРеквизитов.ВариантУчета=Перечисления.ВариантыУчетаДоставки.БесплатнаяДоставка Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Службой ""%1"" доставка выполняется бесплатно'"), СлужбаДоставки);
		УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(СлужбаДоставки, ТекстСообщения, , , "ВариантУчета");
		Возврат 0;
	ИначеЕсли СтруктураРеквизитов.ВариантУчета=Перечисления.ВариантыУчетаДоставки.ВозмещениеСтоимости Тогда
		Формула = СтруктураРеквизитов.ФормулаСебестоимости;
		Если ПустаяСтрока(Формула) Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не задана формула расчета себестоимости доставки для службы ""%1""'",), СлужбаДоставки);
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(СлужбаДоставки, ТекстСообщения, , , "ФормулаСебестоимости");
			Возврат 0;
		КонецЕсли; 
	ИначеЕсли СтруктураРеквизитов.ВариантУчета=Перечисления.ВариантыУчетаДоставки.ДоставкаСОплатой Тогда
		Формула = СтруктураРеквизитов.ФормулаСтоимости;
		Если ПустаяСтрока(Формула) Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не задана формула расчета стоимости доставки для службы ""%1""'",), СлужбаДоставки);
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(СлужбаДоставки, ТекстСообщения, , , "ФормулаСтоимости");
			Возврат 0;
		КонецЕсли; 
	Иначе
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не задан вариант учета для службы ""%1""'"), СлужбаДоставки);
		УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(СлужбаДоставки, ТекстСообщения, , , "ВариантУчета");
		Возврат 0;
	КонецЕсли; 
	
	Стоимость = РассчитатьПоФормуле(Контекст, Формула, СтруктураПараметров);
	
	Возврат Стоимость;
	
КонецФункции

// Функция выполняет расчет себестоимости доставки по формуле.
//
// Контекст (ДанныеФормы) - данные заказа покупателя
// СтруктураПараметров (Структура) - структура значенний параметров, устанавливаемых вручную
//
Функция СебестоимостьДоставки(Контекст, СтруктураПараметров) Экспорт
	
	СлужбаДоставки = Контекст.СлужбаДоставки;
	Если НЕ ЗначениеЗаполнено(СлужбаДоставки) Тогда
		Возврат 0;
	КонецЕсли; 
	
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СлужбаДоставки, "ВариантУчета, ФормулаСебестоимости");
	
	Если НЕ ЗначениеЗаполнено(СтруктураРеквизитов.ВариантУчета) Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не задан вариант учета для службы ""%1""'"), СлужбаДоставки);
		УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(СлужбаДоставки, ТекстСообщения, , , "ВариантУчета");
		Возврат 0;
	ИначеЕсли ПустаяСтрока(СтруктураРеквизитов.ФормулаСебестоимости) Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не задана формула расчета себестоимости доставки для службы ""%1""'",), СлужбаДоставки);
		УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(СлужбаДоставки, ТекстСообщения, , , "ФормулаСебестоимости");
		Возврат 0;
	КонецЕсли; 
	
	Себестоимость = РассчитатьПоФормуле(Контекст, СтруктураРеквизитов.ФормулаСебестоимости, СтруктураПараметров);
	
	Возврат Себестоимость;
	
КонецФункции

Функция ИспользуетсяДоставка(СпособДоставки) Экспорт
	
	Если НЕ ЗначениеЗаполнено(СпособДоставки) ИЛИ СпособДоставки=Перечисления.СпособыДоставки.Самовывоз Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли; 	
	
КонецФункции

#Область ИнтерфейсПечати 

// Функция возвращает признак необходимости вывода данных о доставке на печать.
//
// Шапка (ВыборкаДанныхЗапроса, Структура) - Структура данных шапки печатаемого документа
//		Обязательные свойства:
//		СпособДоставки (ПеречислениеСсылка.СпособыДоставки) - способ доставки заказа
//		НоменклатураДоставки (СправочникСсылка.Номенклатура) - услуга, использующаяся для отражения доставки в учете
//
Функция ВозможностьПечатиДоставки(Шапка) Экспорт
	
	Если НЕ ИспользуетсяДоставка(Шапка.СпособДоставки) Тогда
		Возврат Ложь;
	КонецЕсли; 	
	Если Не ЗначениеЗаполнено(Шапка.НоменклатураДоставки) Тогда
		ОбщегоНазначения.СообщитьПользователю(
		НСтр("ru = 'Не заполнена услуга доставки. Печать невозможна'"),
		Шапка.Ссылка,
		"НоменклатураДоставки",
		"Объект");
		Возврат Неопределено;
	КонецЕсли;
	Возврат Истина;
	
КонецФункции

Процедура ДобавитьСтрокуДоставкиУниверсальныеДанные(ДанныеДокументов, ИмяТабличнойЧасти = "ТаблицаЗапасы") Экспорт
	
	ПоляНаименование = "ПредставлениеНоменклатуры, Запас, НаименованиеНоменклатуры, Содержание";
	ПоляКод = "ЗапасКод, ТоварКод, Код, КодПродукции";
	ПоляЕдиница = "ЕдиницаИзмерения";
	ПоляКодЕдиницы = "ЕдиницаИзмеренияПоОКЕИ_Код, ЕдиницаИзмеренияКод";
	ПоляНаименованиеЕдиницы = "ЕдиницаИзмеренияПоОКЕИ_Наименование, НаименованиеЕдиницыИзмерения, БазоваяЕдиницаНаименование";
	ПоляКоэффициент = "КоэффициентЕдиницыИзмерения, ЕдиницаИзмеренияКоэфициент";
	
	Для Каждого ТекСтрока Из ДанныеДокументов Цикл
		
		Если Не ЗначениеЗаполнено(ТекСтрока.НоменклатураДоставки) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТекСтрока[ИмяТабличнойЧасти].Колонки.Найти("НомерВариантаКП")<>Неопределено Тогда
			ТаблицаВариантов = ТекСтрока[ИмяТабличнойЧасти].Скопировать(, "НомерВариантаКП");
			ТаблицаВариантов.Свернуть("НомерВариантаКП");
			МассивВариантовКП = ТаблицаВариантов.ВыгрузитьКолонку("НомерВариантаКП");
		Иначе
			МассивВариантовКП = Новый Массив;
			МассивВариантовКП.Добавить(0);
		КонецЕсли;
		
		ДатаОтгрузки = '0001-01-01';
		Если ТекСтрока[ИмяТабличнойЧасти].Колонки.Найти("ДатаОтгрузки")<>Неопределено Тогда
			Для каждого СтрокаЗапасы Из ТекСтрока[ИмяТабличнойЧасти] Цикл
				ДатаОтгрузки = Макс(ДатаОтгрузки, СтрокаЗапасы.ДатаОтгрузки);
			КонецЦикла; 
		КонецЕсли; 
		
		Для каждого НомерВариантаКП Из МассивВариантовКП Цикл
			НоваяСтрокаДоставка = ТекСтрока[ИмяТабличнойЧасти].Добавить();
			
			ДанныеСтроки = Новый Структура;
			ДанныеСтроки.Вставить("НомерВариантаКП", НомерВариантаКП);
			ДанныеСтроки.Вставить("НомерСтроки", ТекСтрока[ИмяТабличнойЧасти].Количество());
			
			// Наименование
			Для каждого ИмяПоля Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПоляНаименование) Цикл
				ДанныеСтроки.Вставить(ИмяПоля, ТекСтрока.ПредставлениеНоменклатурыДоставки);
			КонецЦикла; 
			
			// Код, артикул
			Если ДанныеДокументов.Колонки.Найти("КодДоставки")<>Неопределено Тогда
				Для каждого ИмяПоля Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПоляКод) Цикл
					ДанныеСтроки.Вставить(ИмяПоля, ТекСтрока.КодДоставки);
				КонецЦикла; 
			КонецЕсли; 
			Если ДанныеДокументов.Колонки.Найти("АртикулДоставки")<>Неопределено Тогда
				ДанныеСтроки.Вставить("Артикул", ТекСтрока.АртикулДоставки);
			КонецЕсли; 
			
			// Тип номенклатуры
			ДанныеСтроки.Вставить("ТипНоменклатуры", Перечисления.ТипыНоменклатуры.Услуга);
			
			// Ставка НДС
			Если ДанныеДокументов.Колонки.Найти("СтавкаНДСДоставки") <> Неопределено Тогда
				ДанныеСтроки.Вставить("СтавкаНДС", ТекСтрока.СтавкаНДСДоставки);
			КонецЕсли;
			
			// Единица измерения
			Если ДанныеДокументов.Колонки.Найти("ЕдиницаИзмеренияДоставки")<>Неопределено Тогда
				Единица = ТекСтрока.ЕдиницаИзмеренияДоставки;
			Иначе
				Единица = Справочники.КлассификаторЕдиницИзмерения.шт;
			КонецЕсли;
			Для каждого ИмяПоля Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПоляЕдиница) Цикл
				ДанныеСтроки.Вставить(ИмяПоля, Единица);
			КонецЦикла; 
			НаименованиеЕдиницы = Строка(Единица);
			Для каждого ИмяПоля Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПоляНаименованиеЕдиницы) Цикл
				ДанныеСтроки.Вставить(ИмяПоля, НаименованиеЕдиницы);
			КонецЦикла; 
			Если ДанныеДокументов.Колонки.Найти("КодЕдиницыИзмеренияДоставки")<>Неопределено Тогда
				КодЕдиницы = ТекСтрока.КодЕдиницыИзмеренияДоставки;
			Иначе
				КодЕдиницы = ?(ТипЗнч(Единица)=Тип("СправочникСсылка.КлассификаторЕдиницИзмерения"), ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Единица, "Код"), "");
			КонецЕсли; 
			Для каждого ИмяПоля Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПоляКодЕдиницы) Цикл
				ДанныеСтроки.Вставить(ИмяПоля, КодЕдиницы);
			КонецЦикла; 
			Для каждого ИмяПоля Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПоляКоэффициент) Цикл
				ДанныеСтроки.Вставить(ИмяПоля, 1);
			КонецЦикла; 
			
			ДанныеСтроки.Вставить("Количество", 1);
			ДанныеСтроки.Вставить("КоличествоМест", 0);
			ДанныеСтроки.Вставить("Цена", ТекСтрока.СтоимостьДоставки);
			ДанныеСтроки.Вставить("Сумма", ТекСтрока.СтоимостьДоставки);
			ДанныеСтроки.Вставить("СуммаНДС", ТекСтрока.СуммаНДСДоставки);
			ДанныеСтроки.Вставить("Всего", ТекСтрока.СтоимостьДоставки);
			ДанныеСтроки.Вставить("Скидка", 0);
			ДанныеСтроки.Вставить("Вес", 0);
			ДанныеСтроки.Вставить("МассаБрутто", 0);
			ДанныеСтроки.Вставить("Объем", 0);
			ДанныеСтроки.Вставить("ЭтоРазделитель", Ложь);
			ДанныеСтроки.Вставить("ДатаОтгрузки", ДатаОтгрузки);
			
			// Наборы
			ДанныеСтроки.Вставить("НеобходимоВыделитьКакСоставНабора", Ложь);
			ДанныеСтроки.Вставить("ЭтоНабор", Ложь);
			// Конец Наборы
			
			// УКД
			Если ДанныеДокументов.Колонки.Найти("СуммаНДСДоИзмененияДоставка")<>Неопределено
				И ДанныеДокументов.Колонки.Найти("СуммаНДСПослеИзмененияДоставка")<>Неопределено
				И ДанныеДокументов.Колонки.Найти("СтоимостьСНДСДоИзмененияДоставка")<>Неопределено
				И ДанныеДокументов.Колонки.Найти("СтоимостьСНДСПослеИзмененияДоставка")<>Неопределено Тогда
				СтоимостьБезНДСДоИзменения = (ТекСтрока.СтоимостьСНДСДоИзмененияДоставка-ТекСтрока.СуммаНДСДоИзмененияДоставка);
				СтоимостьБезНДСПослеИзменения = (ТекСтрока.СтоимостьСНДСПослеИзмененияДоставка-ТекСтрока.СуммаНДСПослеИзмененияДоставка);
				ДанныеСтроки.Вставить("СуммаНДСДоИзменения", ТекСтрока.СуммаНДСДоИзмененияДоставка);
				ДанныеСтроки.Вставить("СуммаНДСПослеИзменения", ТекСтрока.СуммаНДСПослеИзмененияДоставка);
				ДанныеСтроки.Вставить("СтоимостьСНДСДоИзменения", ТекСтрока.СтоимостьСНДСДоИзмененияДоставка);
				ДанныеСтроки.Вставить("СтоимостьСНДСПослеИзменения", ТекСтрока.СтоимостьСНДСПослеИзмененияДоставка);
				ДанныеСтроки.Вставить("РазницаБезНДСУвеличение", ?(СтоимостьБезНДСПослеИзменения>СтоимостьБезНДСДоИзменения, СтоимостьБезНДСПослеИзменения-СтоимостьБезНДСДоИзменения, 0));
				ДанныеСтроки.Вставить("РазницаБезНДСУменьшение", ?(СтоимостьБезНДСДоИзменения>СтоимостьБезНДСПослеИзменения, СтоимостьБезНДСДоИзменения-СтоимостьБезНДСПослеИзменения, 0));
				ДанныеСтроки.Вставить("РазницаНДСУвеличение", ?(ТекСтрока.СуммаНДСПослеИзмененияДоставка>ТекСтрока.СуммаНДСДоИзмененияДоставка, ТекСтрока.СуммаНДСПослеИзмененияДоставка-ТекСтрока.СуммаНДСДоИзмененияДоставка, 0));
				ДанныеСтроки.Вставить("РазницаНДСУменьшение", ?(ТекСтрока.СуммаНДСДоИзмененияДоставка>ТекСтрока.СуммаНДСПослеИзмененияДоставка, ТекСтрока.СуммаНДСДоИзмененияДоставка-ТекСтрока.СуммаНДСПослеИзмененияДоставка, 0));
				ДанныеСтроки.Вставить("РазницаСНДСУвеличение", ?(ТекСтрока.СтоимостьСНДСПослеИзмененияДоставка>ТекСтрока.СтоимостьСНДСДоИзмененияДоставка, ТекСтрока.СтоимостьСНДСПослеИзмененияДоставка-ТекСтрока.СтоимостьСНДСДоИзмененияДоставка, 0));
				ДанныеСтроки.Вставить("РазницаСНДСУменьшение", ?(ТекСтрока.СтоимостьСНДСДоИзмененияДоставка>ТекСтрока.СтоимостьСНДСПослеИзмененияДоставка, ТекСтрока.СтоимостьСНДСДоИзмененияДоставка-ТекСтрока.СтоимостьСНДСПослеИзмененияДоставка, 0));
				ДанныеСтроки.Вставить("СтоимостьБезНДСДоИзменения", СтоимостьБезНДСДоИзменения);
				ДанныеСтроки.Вставить("СтоимостьБезНДСПослеИзменения", СтоимостьБезНДСПослеИзменения);
				ДанныеСтроки.Вставить("КоличествоДоИзменения", ?(ТекСтрока.СтоимостьСНДСДоИзмененияДоставка>0, 1, 0));
				ДанныеСтроки.Вставить("КоличествоПослеИзменения", ?(ТекСтрока.СтоимостьСНДСПослеИзмененияДоставка>0, 1, 0));
			КонецЕсли;
			// Конец УКД
			
			ЗаполнитьЗначенияСвойств(НоваяСтрокаДоставка, ДанныеСтроки);
			
		КонецЦикла; 
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ПрограммныйСлужебныйИнтерфейс

// Процедура обновляет на форме поля параметров рачета доставки, которые требуется вводить вручную.
//
// Форма (УправляемаяФорма) - форма, на которой следует обновить поля
// СлужбаДоставки (СправочникСсылка.СлужбыДоставки) - выбранная служба доставки
// ТаблицаЗначений (ТаблицаЗначений) - таблица текущих значений параметров расчета доставки
//		Колонки:
//		Параметр (СправочникСсылка.ПараметрыРасчетовДоставки) - параметр, значение которого содержится в таблице
//		Значение (Число) - значение параметра, заданного вручную
// Группа (ГруппаФормы) - группа формы, в которую добавляются поля ввода параметров
//
Процедура ОбновитьРеквизитыПараметрыДоставки(Форма, СлужбаДоставки, ТаблицаЗначений, Группа) Экспорт
	
	ДобавляемыеРеквизиты = Новый Массив;
	УдаляемыеРеквизиты = Новый Массив;
	Для каждого СтрокаТабличнойЧасти Из Форма.ПараметрыДоставки Цикл
		УдаляемыеРеквизиты.Добавить(СтрокаТабличнойЧасти.ИмяРеквизита);
		Форма.Элементы.Удалить(Форма.Элементы[СтрокаТабличнойЧасти.ИмяРеквизита]);
	КонецЦикла;
	Форма.ПараметрыДоставки.Очистить();
	
	Если ЗначениеЗаполнено(СлужбаДоставки) Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("СлужбаДоставки", СлужбаДоставки);
		Запрос.УстановитьПараметр("ТаблицаЗначений", ТаблицаЗначений);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Значения.Параметр,
		|	Значения.Значение
		|ПОМЕСТИТЬ Значения
		|ИЗ
		|	&ТаблицаЗначений КАК Значения
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СлужбыДоставкиПараметрыРасчетов.Параметр,
		|	СлужбыДоставкиПараметрыРасчетов.Параметр.Идентификатор КАК Идентификатор,
		|	СлужбыДоставкиПараметрыРасчетов.Параметр.Наименование КАК Наименование,
		|	ЕСТЬNULL(Значения.Значение, 0) КАК Значение
		|ИЗ
		|	Справочник.СлужбыДоставки.ПараметрыРасчетов КАК СлужбыДоставкиПараметрыРасчетов
		|		ЛЕВОЕ СОЕДИНЕНИЕ Значения КАК Значения
		|		ПО СлужбыДоставкиПараметрыРасчетов.Параметр = Значения.Параметр
		|ГДЕ
		|	СлужбыДоставкиПараметрыРасчетов.Ссылка = &СлужбаДоставки
		|	И СлужбыДоставкиПараметрыРасчетов.Параметр.ЗадаватьЗначениеПриРасчете";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СтрокаТабличнойЧасти = Форма.ПараметрыДоставки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка);
			ИмяРеквизита = "ПараметрДоставки_"+СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
			Реквизит = Новый РеквизитФормы(
			ИмяРеквизита,
			Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,3)),
			,
			Выборка.Наименование);
			ДобавляемыеРеквизиты.Добавить(Реквизит);
			СтрокаТабличнойЧасти.ИмяРеквизита = ИмяРеквизита;
		КонецЦикла; 
	КонецЕсли; 
	
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты, УдаляемыеРеквизиты);
	
	Для каждого СтрокаТабличнойЧасти Из Форма.ПараметрыДоставки Цикл
		Элемент = Форма.Элементы.Добавить(СтрокаТабличнойЧасти.ИмяРеквизита, Тип("ПолеФормы"), Группа);
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
		Элемент.ПутьКДанным = СтрокаТабличнойЧасти.ИмяРеквизита;
		Элемент.АвтоМаксимальнаяШирина = Ложь;
		Элемент.МаксимальнаяШирина = 5;
		Элемент.Ширина = 10;
		Форма[СтрокаТабличнойЧасти.ИмяРеквизита] = СтрокаТабличнойЧасти.Значение;
	КонецЦикла; 
	
КонецПроцедуры

Процедура ЗаполнитьДеревоПараметровРасчета(ПараметрыРасчетов, ТолькоЧисловые = Ложь) Экспорт
	
	ПараметрыРасчетов.ПолучитьЭлементы().Очистить();
	
	СтрокаРодитель = ПараметрыРасчетов.ПолучитьЭлементы().Добавить();
	СтрокаРодитель.Идентификатор = НСтр("ru = 'Заказ'");
	ИменаРеквизитов = "Дата,Автор,АдресДоставки,ВалютаДокумента,Вес,ВидЗаказа,ВидСкидкиНаценки,ВидЦен,ВремяДоставкиС,ВремяДоставкиПо,Высота,ДатаОтгрузки,Длина,ЗапаснойТелефон,
	|ЗонаТариф,КонтактныйТелефон,Контрагент,Курс,НалогообложениеНДС,НДСВключатьВСтоимость,Объем,ОбъявленнаяЦенность,Организация,Ответственный,ПочтаПолучателя,ПроцентСкидкиПоДисконтнойКарте,
	|СлужбаДоставки,СпособДоставки,СпособОтгрузки,СуммаВключаетНДС,СтруктурнаяЕдиницаПродажи,СтруктурнаяЕдиницаРезерв,СуммаДокумента,
	|ТрекНомер,Ширина,Ячейка,НоменклатураДоставки,Курьер";
	ДобавитьВложенныеРеквизиты(СтрокаРодитель, Метаданные.Документы.ЗаказПокупателя, Справочники.НаборыДополнительныхРеквизитовИСведений.Документ_ЗаказПокупателя, ИменаРеквизитов, ТолькоЧисловые);
	СтрокаРодитель = ПараметрыРасчетов.ПолучитьЭлементы().Добавить();
	СтрокаРодитель.Идентификатор = НСтр("ru = 'Контрагент'");
	СтрокаРодитель.Тип = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	ИменаРеквизитов = "Ссылка,Наименование,НаименованиеПолное,ВидКонтрагента,ДатаРождения,ДатаСоздания,ИсточникПривлеченияПокупателя,Комментарий,Ответственный,Покупатель,Пол,Поставщик,СтранаРегистрации,СтатьяДДСПоУмолчанию";
	ДобавитьВложенныеРеквизиты(СтрокаРодитель, Метаданные.Справочники.Контрагенты, Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Контрагенты, ИменаРеквизитов, ТолькоЧисловые);
	Если СтрокаРодитель.ПолучитьЭлементы().Количество()=0 Тогда
		ПараметрыРасчетов.ПолучитьЭлементы().Удалить(СтрокаРодитель);
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПараметрыРасчетовДоставки.Ссылка КАК Параметр,
	|	ПараметрыРасчетовДоставки.Идентификатор
	|ИЗ
	|	Справочник.ПараметрыРасчетовДоставки КАК ПараметрыРасчетовДоставки
	|ГДЕ
	|	НЕ ПараметрыРасчетовДоставки.ПометкаУдаления";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаПараметр = ПараметрыРасчетов.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПараметр, Выборка);
		СтрокаПараметр.Тип = Новый ОписаниеТипов("Число");
	КонецЦикла; 
	
КонецПроцедуры

Процедура ЗаданиеРассчитатьСтоимостьДоставки(Знач Параметры, Знач АдресХранилища) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("СтоимостьДоставки", 0);
	
	Объект = ПолучитьИзВременногоХранилища(Параметры.АдресОбъекта);
	
	Результат.СтоимостьДоставки = ДоставкаСервер.СтоимостьДоставки(Объект, Параметры);
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьПараметрыВСтруктуру(СтрокаФормулы, МассивПараметров, Отказ = Ложь)

	Формула = СтрокаФормулы;
	
	НачОперанда = СтрНайти(Формула, "[");
	КонОперанда = СтрНайти(Формула, "]");
     
	ЕстьОперанд = Истина;
	Пока ЕстьОперанд Цикл
     
		Если НачОперанда <> 0 И КонОперанда <> 0 Тогда
			
            Идентификатор = СокрЛП(Сред(Формула, НачОперанда+1, КонОперанда - НачОперанда - 1));
            Формула = Прав(Формула, СтрДлина(Формула) - КонОперанда);   
			
			Попытка
				Если МассивПараметров.Найти(Идентификатор)=Неопределено Тогда
					МассивПараметров.Добавить(Идентификатор);
				КонецЕсли;
			Исключение
				Отказ = Истина;
			    Прервать;
			КонецПопытки 
			 
		КонецЕсли;     
          
		НачОперанда = СтрНайти(Формула, "[");
		КонОперанда = СтрНайти(Формула, "]");
          
		Если НЕ (НачОперанда <> 0 И КонОперанда <> 0) Тогда
			ЕстьОперанд = Ложь;
        КонецЕсли;     
               
	КонецЦикла;	

КонецПроцедуры

// Функция выполняет расчет по формуле.
//
// Контекст (ДанныеФормы) - данные заказа покупателя
// Формула (Строка) - формула для расчета
// ДополнительныеПараметры (Структура) - структура значенний параметров, устанавливаемых вручную
//
Функция РассчитатьПоФормуле(Контекст, Формула, ДополнительныеПараметры)

	Отказ = Ложь;
	
	МассивПараметров = Новый Массив;
	ДобавитьПараметрыВСтруктуру(Формула, МассивПараметров, Отказ);
	
	Если Отказ Тогда
		Возврат 0;
	КонецЕсли;
	
	СтруктураОбщихПараметров = Новый Структура;
	СтруктураОбщихПараметров.Вставить("Заказ", Контекст.Ссылка);
	СтруктураОбщихПараметров.Вставить("Контрагент", Контекст.Контрагент);
	СтруктураОбщихПараметров.Вставить("ЗаказДата", Контекст.Дата);
	СтруктураОбщихПараметров.Вставить("ЗаказВидЦен", Контекст.ВидЦен);
	СтруктураОбщихПараметров.Вставить("ЗаказНоменклатураДоставки", Контекст.НоменклатураДоставки);
	СтруктураОбщихПараметров.Вставить("Запасы", Контекст.Запасы.Выгрузить());
	
	// 1. Выборка и расчет параметров
	Параметры = Новый Соответствие;
	МассивИдентификаторов = Новый Массив;
	Для каждого Параметр Из МассивПараметров Цикл
		МассивИдентификаторов.Добавить(Параметр); 
	КонецЦикла; 
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификаторы", МассивИдентификаторов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПараметрыРасчетовДоставки.Ссылка КАК Параметр,
	|	ПараметрыРасчетовДоставки.Идентификатор,
	|	ПараметрыРасчетовДоставки.ЗадаватьЗначениеПриРасчете,
	|	ПараметрыРасчетовДоставки.Запрос,
	|	ПараметрыРасчетовДоставки.ПроизвольныйЗапрос
	|ИЗ
	|	Справочник.ПараметрыРасчетовДоставки КАК ПараметрыРасчетовДоставки
	|ГДЕ
	|	ПараметрыРасчетовДоставки.Идентификатор В(&Идентификаторы)";
	ВыборкаПараметры = Запрос.Выполнить().Выбрать();
	Пока ВыборкаПараметры.Следующий() Цикл
		Если ВыборкаПараметры.ЗадаватьЗначениеПриРасчете Тогда
			Продолжить;
		КонецЕсли; 
		ТекстОшибки = "";
		СтруктураОтборов = Новый Структура;
		Для каждого Элемент Из СтруктураОбщихПараметров Цикл
			СтруктураОтборов.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла; 
		ЗначениеПараметра = УправлениеНебольшойФирмойСервер.РассчитатьЗначениеПараметра(СтруктураОтборов, ВыборкаПараметры.Параметр, ТекстОшибки);
		Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(Контекст, ТекстОшибки);
			Возврат 0;
		КонецЕсли;
		Параметры.Вставить(ВыборкаПараметры.Идентификатор, ЗначениеПараметра);
	КонецЦикла;
	
	// 2. Добавление параметров из контекста
	РеквизитыКонтрагента = "";
	ДопРеквизитыЗаказа = Новый Массив;
	ДопРеквизитыКонтрагента = Новый Массив;
	Для каждого Параметр Из МассивПараметров Цикл
		Позиция = Найти(Параметр, ".");
		Если Позиция=0 Тогда
			Продолжить;
		КонецЕсли; 
		ИмяРеквизита = Сред(Параметр, Позиция+1);
		Если ВРег(Лев(Параметр, 5))="ЗАКАЗ" Тогда
			Если ВРег(ИмяРеквизита)="СУММАДОКУМЕНТА" Тогда
				// Сумму документа нужно предварительно пересчитать
				СуммаДокумента = 0;
				Для каждого Стр Из Контекст.Запасы Цикл
					Если Стр.ЭтоРазделитель ИЛИ Стр.НомерВариантаКП <> Контекст.ОсновнойВариантКП Тогда
						Продолжить;
					КонецЕсли;
					СуммаДокумента = СуммаДокумента + Стр.Всего;
				КонецЦикла;
				СуммаДокумента = СуммаДокумента + Контекст.Работы.Итог("Всего");
				Параметры.Вставить(Параметр, СуммаДокумента);
			ИначеЕсли Найти(ИмяРеквизита, " ")>0 ИЛИ НЕ Контекст.Свойство(ИмяРеквизита) Тогда
				ДопРеквизитыЗаказа.Добавить(ИмяРеквизита);
			Иначе
				Параметры.Вставить(Параметр, Контекст[ИмяРеквизита]);
			КонецЕсли; 
		ИначеЕсли ВРег(Лев(Параметр, 10))="КОНТРАГЕНТ" Тогда
			Если Найти(ИмяРеквизита, " ")>0 ИЛИ Метаданные.Справочники.Контрагенты.Реквизиты.Найти(ИмяРеквизита)=Неопределено Тогда
				ДопРеквизитыКонтрагента.Добавить(ИмяРеквизита);
			Иначе
				РеквизитыКонтрагента = РеквизитыКонтрагента+?(ПустаяСтрока(РеквизитыКонтрагента), "", ", ")+ИмяРеквизита;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	Если НЕ ПустаяСтрока(РеквизитыКонтрагента) Тогда
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Контекст.Контрагент, РеквизитыКонтрагента);
		Для каждого Элемент Из СтруктураРеквизитов Цикл
			Параметры.Вставить("Контрагент."+Элемент.Ключ, Элемент.Значение);
		КонецЦикла; 
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДопРеквизитыКонтрагента", ДопРеквизитыКонтрагента);
	Запрос.УстановитьПараметр("ДопРеквизитыЗаказа", ДопРеквизитыЗаказа);
	Запрос.УстановитьПараметр("Контрагент", Контекст.Контрагент);
	Запрос.УстановитьПараметр("ЗначенияДопРеквизитов", Контекст.ДополнительныеРеквизиты.Выгрузить());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ЗначенияДопРеквизитов.Свойство КАК ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения) КАК Свойство,
	|	ЗначенияДопРеквизитов.Значение
	|ПОМЕСТИТЬ ЗначенияДопРеквизитов
	|ИЗ
	|	&ЗначенияДопРеквизитов КАК ЗначенияДопРеквизитов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""Контрагент."" + КонтрагентыДополнительныеРеквизиты.Свойство.Заголовок КАК Идентификатор,
	|	КонтрагентыДополнительныеРеквизиты.Значение
	|ИЗ
	|	Справочник.Контрагенты.ДополнительныеРеквизиты КАК КонтрагентыДополнительныеРеквизиты
	|ГДЕ
	|	КонтрагентыДополнительныеРеквизиты.Свойство.Заголовок В(&ДопРеквизитыКонтрагента)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Заказ."" + ЗначенияДопРеквизитов.Свойство.Заголовок,
	|	ЗначенияДопРеквизитов.Значение
	|ИЗ
	|	ЗначенияДопРеквизитов КАК ЗначенияДопРеквизитов
	|ГДЕ
	|	ЗначенияДопРеквизитов.Свойство.Заголовок В(&ДопРеквизитыЗаказа)";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Параметры.Вставить(Выборка.Идентификатор, Выборка.Значение);	
	КонецЦикла;
	
	// 3. Добавление значений параметров, заданных вручную
	Для каждого ДополнительныйПараметр Из ДополнительныеПараметры Цикл
		Параметры.Вставить(ДополнительныйПараметр.Ключ, ДополнительныйПараметр.Значение);
	КонецЦикла; 
	
	Для каждого ДопРеквизит Из ДопРеквизитыКонтрагента Цикл
		ИмяПараметра = "Контрагент."+ДопРеквизит;
		Если Параметры.Получить(ИмяПараметра)=Неопределено Тогда
			Параметры.Вставить(ИмяПараметра, Неопределено);
		КонецЕсли; 
	КонецЦикла; 
	Для каждого ДопРеквизит Из ДопРеквизитыЗаказа Цикл
		ИмяПараметра = "Заказ."+ДопРеквизит;
		Если Параметры.Получить(ИмяПараметра)=Неопределено Тогда
			Параметры.Вставить(ИмяПараметра, Неопределено);
		КонецЕсли; 
	КонецЦикла; 
	
	// 4. Подстановка значений параметров и расчет по формуле
	Для каждого Параметр Из Параметры Цикл
		Формула = СтрЗаменить(Формула, "[" + Параметр.Ключ + "]", "Параметры.Получить("""+Параметр.Ключ+""")");
	КонецЦикла;
	
	// 5. Значения формулы
	ЗначенияФормулы = Новый Структура;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СлужбаДоставки", Контекст.СлужбаДоставки);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СлужбыДоставкиЗначенияФормулы.Идентификатор,
	|	СлужбыДоставкиЗначенияФормулы.Значение
	|ИЗ
	|	Справочник.СлужбыДоставки.ЗначенияФормулы КАК СлужбыДоставкиЗначенияФормулы
	|ГДЕ
	|	СлужбыДоставкиЗначенияФормулы.Ссылка = &СлужбаДоставки";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ИмяПараметра = "ЗначениеФормулы."+Выборка.Идентификатор;
		Формула = СтрЗаменить(Формула, "[" + Выборка.Идентификатор + "]", "Параметры.Получить("""+ИмяПараметра+""")");
		Параметры.Вставить(ИмяПараметра, Выборка.Значение);
	КонецЦикла; 
	
	Попытка
		Результат = РаботаВБезопасномРежиме.ВычислитьВБезопасномРежиме(Формула, Параметры);
	Исключение
		ТекстСообщения = НСтр("ru = 'Не удалось рассчитать параметры доставки. Возможно, формула содержит ошибку или не заполнены показатели.'");
		
		УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(Контекст, ТекстСообщения);
		
		Результат = 0;
	КонецПопытки;
	
	Возврат Результат; 

КонецФункции // РассчитатьПоФормулам()

// Функция выполняет расчет объема и веса запасов
Функция РассчитатьОбъемИВесЗапасов(ТаблицаЗапасов)Экспорт
	
	Результат = Новый Структура("Объем, Вес",0,0);
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаНоменклатура.Номенклатура,
	|	ТаблицаНоменклатура.Количество
	|ПОМЕСТИТЬ ВТНоменклатура
	|ИЗ
	|	&ТаблицаНоменклатура КАК ТаблицаНоменклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(СправочникНоменклатура.Вес * ТаблицаНоменклатура.Количество) КАК Вес,
	|	СУММА(СправочникНоменклатура.Объем * ТаблицаНоменклатура.Количество) КАК Объем
	|ИЗ
	|	ВТНоменклатура КАК ТаблицаНоменклатура
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО (СправочникНоменклатура.Ссылка = ТаблицаНоменклатура.Номенклатура)");
	Запрос.УстановитьПараметр("ТаблицаНоменклатура", ТаблицаЗапасов);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ДобавитьВложенныеРеквизиты(СтрокаРодитель, МетаданныеОбъекта, НаборСвойств, ИменаРеквизитов, ТолькоЧисловые)
	
	СписокРеквизитов = Новый СписокЗначений;
	Реквизиты = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрЗаменить(ИменаРеквизитов, Символы.ПС, ""));
	
	Для каждого Реквизит Из МетаданныеОбъекта.СтандартныеРеквизиты Цикл
		Если Реквизиты.Найти(Реквизит.Имя)=Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если ТолькоЧисловые И НЕ Реквизит.Тип.СодержитТип(Тип("Число")) Тогда
			Продолжить;
		КонецЕсли; 
		СписокРеквизитов.Добавить(Реквизит.Тип, СтрокаРодитель.Идентификатор+"."+Реквизит.Имя);
	КонецЦикла; 	
	Для каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		Если Реквизиты.Найти(Реквизит.Имя)=Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		Если ТолькоЧисловые И НЕ Реквизит.Тип.СодержитТип(Тип("Число")) Тогда
			Продолжить;
		КонецЕсли; 
		СписокРеквизитов.Добавить(Реквизит.Тип, СтрокаРодитель.Идентификатор+"."+Реквизит.Имя);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НаборСвойств", НаборСвойств);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДополнительныеРеквизиты.Свойство КАК Параметр,
	|	ДополнительныеРеквизиты.Свойство.Заголовок КАК Имя,
	|	ДополнительныеРеквизиты.Свойство.ТипЗначения КАК ТипЗначения
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
	|ГДЕ
	|	ДополнительныеРеквизиты.Ссылка = &НаборСвойств
	|	И НЕ ДополнительныеРеквизиты.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДополнительныеСведения.Свойство,
	|	ДополнительныеСведения.Свойство.Заголовок,
	|	ДополнительныеСведения.Свойство.ТипЗначения
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|ГДЕ
	|	ДополнительныеСведения.Ссылка = &НаборСвойств
	|	И НЕ ДополнительныеСведения.ПометкаУдаления";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ТолькоЧисловые И НЕ Выборка.ТипЗначения.СодержитТип(Тип("Число")) Тогда
			Продолжить;
		КонецЕсли; 
		СписокРеквизитов.Добавить(Выборка.ТипЗначения, СтрокаРодитель.Идентификатор+"."+Выборка.Имя);
	КонецЦикла;
	
	СписокРеквизитов.СортироватьПоПредставлению();
	Для каждого ЭлементСписка Из СписокРеквизитов Цикл
		СтрокаРекувизит = СтрокаРодитель.ПолучитьЭлементы().Добавить();
		СтрокаРекувизит.Идентификатор = ЭлементСписка.Представление;
		СтрокаРекувизит.Тип = ЭлементСписка.Значение;
	КонецЦикла; 
	
КонецПроцедуры

Функция АдресОтправленияИзСклада() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("РезервированиеЗапасов") И ПолучитьФункциональнуюОпцию("УчетПоНесколькимСкладам");
	
КонецФункции

Функция ПоляАдресаОтправления(Субъект) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("АдресОтправления", "");
	Результат.Вставить("АдресОтправленияИсточник", Субъект);
	Результат.Вставить("АдресОтправленияЗначение", "");
	Результат.Вставить("АдресОтправленияНавигационнаяСсылка", "");
	Результат.Вставить("АдресОтправленияПодсказка", Новый ФорматированнаяСтрока(""));
	
	Если Не ЗначениеЗаполнено(Субъект) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат.АдресОтправленияНавигационнаяСсылка = ПолучитьНавигационнуюСсылку(Субъект);
	Результат.АдресОтправленияПодсказка = ПодсказкаДляАдресаОтправления(Субъект);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КонтактнаяИнформация.Представление,
	|	КонтактнаяИнформация.Значение
	|ИЗ
	|	Справочник.СтруктурныеЕдиницы.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Вид = &Вид
	|	И КонтактнаяИнформация.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", Субъект);
	
	Если ТипЗнч(Субъект) = Тип("СправочникСсылка.Организации") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Справочник.СтруктурныеЕдиницы", "Справочник.Организации");
		Запрос.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
	Иначе
		Запрос.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.ФактАдресСтруктурнойЕдиницы);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Результат.АдресОтправления = Выборка.Представление;
	Результат.АдресОтправленияЗначение = Выборка.Значение;
	
	Возврат Результат;
	
КонецФункции

Функция ПодсказкаДляАдресаОтправления(Субъект)
	
	Строки = Новый Массив;
	
	Строки.Добавить(НСтр("ru = 'В качестве адреса отправления используется фактический адрес'"));
	Строки.Добавить(" ");
	
	Если ТипЗнч(Субъект) = Тип("СправочникСсылка.Организации") Тогда
		Строки.Добавить(НСтр("ru = 'организации'"));
	ИначеЕсли ТипЗнч(Субъект) = Тип("СправочникСсылка.СтруктурныеЕдиницы") Тогда
		Строки.Добавить(НСтр("ru = 'склада'"));
	КонецЕсли;
	
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(Строка(Субъект),,,, ПолучитьНавигационнуюСсылку(Субъект)));
	Строки.Добавить(".");
	
	Если ТипЗнч(Субъект) = Тип("СправочникСсылка.СтруктурныеЕдиницы") Тогда
		Строки.Добавить(Символы.ПС);
		Строки.Добавить(НСтр("ru = 'Выбрать склад можно на вкладке ""Дополнительно"".'"));
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(Строки);
	
КонецФункции

#КонецОбласти