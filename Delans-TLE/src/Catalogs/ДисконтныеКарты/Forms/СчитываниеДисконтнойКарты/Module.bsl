
&НаКлиенте
Перем СтэкСтраниц; // История переходов для возврата по кнопке назад

&НаКлиенте
Перем ДанныеСчитывателя; // Кэш данных считывателя магнитной карты

#Область ПроцедурыИФункцииОбщегоНазначения

// Функция возвращает любой реквизит вида дисконтной карты.
//
// Параметры:
//  Владелец - СправочникСсылка.ВидыДисконтныхКарт - вид дисконтной карты.
//  Реквизит - Строка - Имя реквизита владельца.
//
&НаСервереБезКонтекста
Функция ПолучитьРеквизитВидаДисконтнойКарты(Владелец, Реквизит)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыДисконтныхКарт."+Реквизит+" КАК Реквизит
		|ИЗ
		|	Справочник.ВидыДисконтныхКарт КАК ВидыДисконтныхКарт
		|ГДЕ
		|	ВидыДисконтныхКарт.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Владелец);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Реквизит;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции // ЭтоИменнаяКарта(Объект.ВидДисконтнойКарты)()

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Контрагент = Параметры.Контрагент;
	
	Если ОсновнойТипКода.Пустая() Тогда
		ОсновнойТипКода = ДисконтныеКартыСервер.ПолучитьОсновнойТипКодаДисконтнойКарты();
	КонецЕсли;
	
	НеИспользоватьРучнойВвод = Параметры.НеИспользоватьРучнойВвод;
	Если НеИспользоватьРучнойВвод Тогда
		Элементы.ГруппаКодКарты.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.КодКарты) Тогда
		
		// При считывании в форме списка было найдено несколько карт с данным кодом,
		// требуется предложить карты на выбор пользователю.
		ОбработатьПолученныйКодНаСервере(Параметры.КодКарты, Параметры.ТипКода, Истина);
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаВыборДисконтнойКарты;
		
	Иначе
		
		Если ЗначениеЗаполнено(ОсновнойТипКода) Тогда
			ТипКода = ОсновнойТипКода;
		Иначе
			ТипКода = Перечисления.ТипыКодовКарт.Штрихкод;
		КонецЕсли;
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеДисконтнойКарты;
		
	КонецЕсли;
	
	Элементы.СтраницыКнопкиНазад.ТекущаяСтраница = Элементы.СтраницыКнопкиНазад.ПодчиненныеЭлементы.КнопкаНазадОтсутствует;
	Элементы.СтраницыКнопкиДалее.ТекущаяСтраница = Элементы.СтраницыКнопкиДалее.ПодчиненныеЭлементы.КнопкаГотово;
	
	Если НЕ НеИспользоватьРучнойВвод Тогда
		Если Не ЗначениеЗаполнено(ОсновнойТипКода) Тогда
			Текст = НСтр("ru = 'Считайте дисконтную карту при помощи сканера штрихкода
			                   |(считывателя магнитных карт) или введите код вручную'");
		ИначеЕсли ОсновнойТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод") Тогда
			Текст = НСтр("ru = 'Считайте дисконтную карту при помощи считывателя
			                   |магнитных карт или введите магнитный код вручную'");
		ИначеЕсли ОсновнойТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
			Текст = НСтр("ru = 'Считайте дисконтную карту при помощи сканера
			                   |штрихкода или введите штрихкод вручную'");
		КонецЕсли;
	Иначе
		Если Не ЗначениеЗаполнено(ОсновнойТипКода) Тогда
			Текст = НСтр("ru = 'Считайте дисконтную карту при помощи сканера штрихкода
			                   |(считывателя магнитных карт)'");
		ИначеЕсли ОсновнойТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод") Тогда
			Текст = НСтр("ru = 'Считайте дисконтную карту при помощи считывателя
			                   |магнитных карт'");
		ИначеЕсли ОсновнойТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
			Текст = НСтр("ru = 'Считайте дисконтную карту при помощи сканера
			                   |штрихкода'");
		КонецЕсли;
	КонецЕсли;
	НадписьСчитываниеДисконтнойКарты = Текст;

	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = УправлениеНебольшойФирмойПовтИсп.ИспользоватьПодключаемоеОборудование();
	// Конец ПодключаемоеОборудование	
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СтэкСтраниц = Новый Массив;
	
	СформироватьЗаголовокФормы();
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода,СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование

КонецПроцедуры

// Процедура - обработчик события ПриЗакрытии.
//
&НаКлиенте
Процедура ПриЗакрытии()
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование

КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод");
			ОбработатьШтрихкоды(ДисконтныеКартыКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
			Параметр.Очистить();
		ИначеЕсли ИмяСобытия ="TracksData" Тогда
			ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод");
			ОбработатьДанныеСчитывателяМагнитныхКарт(Параметр);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

// Процедура - обработчик события Очистка элемента ТипКода.
//
&НаКлиенте
Процедура ТипКодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Процедура - обработчик события Выбор в таблице значений НайденныеДисконтныеКарты.
//
&НаКлиенте
Процедура НайденныеДисконтныеКартыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПодключитьОбработчикОжидания("ДалееОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении элемента ВидДисконтнойКарты.
//
&НаКлиенте
Процедура ВидДисконтнойКартыПриИзменении(Элемент)
	
	НастройкаВидимостиЭлементовПоВидуКартыНаСервере();
	Объект.Наименование = ДисконтныеКартыВызовСервера.УстановитьНаименованиеДисконтнойКарты(Объект.Владелец, Объект.ВладелецКарты, Объект.КодКартыШтрихкод, Объект.КодКартыМагнитный);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении элемента ВладелецКарты.
//
&НаКлиенте
Процедура ВладелецКартыПриИзменении(Элемент)
	
	Объект.Наименование = ДисконтныеКартыВызовСервера.УстановитьНаименованиеДисконтнойКарты(Объект.Владелец, Объект.ВладелецКарты, Объект.КодКартыШтрихкод, Объект.КодКартыМагнитный);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении элемента КодКартыШтрихкод.
//
&НаКлиенте
Процедура КодКартыШтрихкодПриИзменении(Элемент)
	
	Объект.Наименование = ДисконтныеКартыВызовСервера.УстановитьНаименованиеДисконтнойКарты(Объект.Владелец, Объект.ВладелецКарты, Объект.КодКартыШтрихкод, Объект.КодКартыМагнитный);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении элемента КодКартыМагнитный.
//
&НаКлиенте
Процедура КодКартыМагнитныйПриИзменении(Элемент)
	
	Объект.Наименование = ДисконтныеКартыВызовСервера.УстановитьНаименованиеДисконтнойКарты(Объект.Владелец, Объект.ВладелецКарты, Объект.КодКартыШтрихкод, Объект.КодКартыМагнитный);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

// Процедура - обработчик команды Назад формы.
//
&НаКлиенте
Процедура Назад(Команда)
	
	Если СтэкСтраниц.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = СтэкСтраниц[СтэкСтраниц.Количество()-1];
	СтэкСтраниц.Удалить(СтэкСтраниц.Количество()-1);
	
	Если СтэкСтраниц.Количество() = 0 Тогда
		Элементы.СтраницыКнопкиНазад.ТекущаяСтраница = Элементы.СтраницыКнопкиНазад.ПодчиненныеЭлементы.КнопкаНазадОтсутствует;
	КонецЕсли;
	
	Элементы.СтраницыКнопкиДалее.ТекущаяСтраница = Элементы.СтраницыКнопкиДалее.ПодчиненныеЭлементы.КнопкаГотово;
	
	СформироватьЗаголовокФормы();
	
КонецПроцедуры

// Процедура - обработчик команды Далее формы.
//
&НаКлиенте
Процедура Далее(Команда)
	
	ОтключитьОбработчикОжидания("ДалееОбработчикОжидания");
	
	ОчиститьСообщения();
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеДисконтнойКарты Тогда
		
		Если Не ЗначениеЗаполнено(КодКарты) Тогда
			
			Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
				ТекстСообщения = НСтр("ru = 'Штрихкод не заполнен.'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Магнитный код не заполнен.'");
			КонецЕсли;
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				ТекстСообщения,
				,
				"КодКарты");
			
			Возврат;
			
		КонецЕсли;
		
		ОбработатьПолученныйКодНаКлиенте(КодКарты, ТипКода, Ложь);
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаВыборДисконтнойКарты Тогда
		
		ТекущиеДанные = Элементы.НайденныеДисконтныеКарты.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
				
				ОбработатьВыборДисконтнойКарты(ТекущиеДанные);
				
			Иначе
				
				Объект.Владелец = ТекущиеДанные.ВидКарты;
				Объект.ВладелецКарты = Контрагент;
				Объект.КодКартыМагнитный = ТекущиеДанные.МагнитныйКод;
				Объект.КодКартыШтрихкод = ТекущиеДанные.Штрихкод;
				
				НастройкаВидимостиЭлементовПоВидуКартыНаСервере();
				Объект.Наименование = ДисконтныеКартыВызовСервера.УстановитьНаименованиеДисконтнойКарты(Объект.Владелец, Объект.ВладелецКарты, Объект.КодКартыШтрихкод, Объект.КодКартыМагнитный);
				
				ПерейтиНаСтраницу(Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСозданиеДисконтнойКарты);	
				
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСозданиеДисконтнойКарты Тогда
		
		Если ЗаписатьДисконтнуюКарту() Тогда
		
			ПараметрыЗакрытия = Новый Структура("ДисконтнаяКарта, СчитанаДисконтнаяКарта", Объект.Ссылка, Ложь);
			Закрыть(ПараметрыЗакрытия);
				
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Функция записывает текущий объект и возвращает Истина в случае успешной записи
//
&НаСервере
Функция ЗаписатьДисконтнуюКарту()

	Если ПроверитьЗаполнение() Тогда
		Попытка
			Записать();
			Возврат Истина;
		Исключение
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ОписаниеОшибки();
			Сообщение.Сообщить();
			Возврат Ложь;
		КонецПопытки;			
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

// Процедура формирует заголовок формы в зависимости от текущей страницы и выбранной строки в таблице значений найденных дисконтных карт или
// видов дисконтных карт
//
&НаКлиенте
Процедура СформироватьЗаголовокФормы()
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеДисконтнойКарты Тогда
		ЭтаФорма.АвтоЗаголовок = Ложь;
		ЭтаФорма.Заголовок = "Считывание дисконтной карты";
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаВыборДисконтнойКарты Тогда
		ЭтаФорма.АвтоЗаголовок = Ложь;
		ТекущиеДанные = Элементы.НайденныеДисконтныеКарты.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
				ЭтаФорма.Заголовок = "Выбор дисконтной карты";
			Иначе
				ЭтаФорма.Заголовок = "Выбор вида новой дисконтной карты";
			КонецЕсли;
		Иначе
			Если НайденныеДисконтныеКарты.Количество() > 0 Тогда
				Если ЗначениеЗаполнено(НайденныеДисконтныеКарты[0].Ссылка) Тогда
					ЭтаФорма.Заголовок = "Выбор дисконтной карты";
				Иначе
					ЭтаФорма.Заголовок = "Выбор вида новой дисконтной карты";
				КонецЕсли;
			Иначе
				ЭтаФорма.Заголовок = "Выбор дисконтной карты \ вида новой дисконтной карты";
			КонецЕсли;
		КонецЕсли;			
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСозданиеДисконтнойКарты Тогда
	    ЭтаФорма.АвтоЗаголовок = Истина;
		ЭтаФорма.Заголовок = "";
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик команды СкопироватьШКвМК формы.
//
&НаКлиенте
Процедура СкопироватьШКвМК(Команда)
	
	Объект.КодКартыМагнитный = Объект.КодКартыШтрихкод;
	Объект.Наименование = ДисконтныеКартыВызовСервера.УстановитьНаименованиеДисконтнойКарты(Объект.Владелец, Объект.ВладелецКарты, Объект.КодКартыШтрихкод, Объект.КодКартыМагнитный);
	
КонецПроцедуры

// Процедура - обработчик команды СкопироватьМКвШК формы.
//
&НаКлиенте
Процедура СкопироватьМКвШК(Команда)
	
	Объект.КодКартыШтрихкод = Объект.КодКартыМагнитный;
	Объект.Наименование = ДисконтныеКартыВызовСервера.УстановитьНаименованиеДисконтнойКарты(Объект.Владелец, Объект.ВладелецКарты, Объект.КодКартыШтрихкод, Объект.КодКартыМагнитный);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура настраивает условное оформление и отборы формы.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НайденныеДисконтныеКарты.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НайденныеДисконтныеКарты.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НайденныеДисконтныеКарты.АвтоматическаяРегистрацияПриПервомСчитывании");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", Новый Цвет());
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.НейтральноСерый);

КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

// Процедура обрабатывает данные штрихкода, которые передаются из обработки оповещения формы.
//
&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Если Элементы.Страницы.ТекущаяСтраница <> Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеДисконтнойКарты Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеШтрихкодов) = Тип("Массив") Тогда
		МассивШтрихкодов = ДанныеШтрихкодов;
	Иначе
		МассивШтрихкодов = Новый Массив;
		МассивШтрихкодов.Добавить(ДанныеШтрихкодов);
	КонецЕсли;
	
	ОбработатьПолученныйКодНаКлиенте(МассивШтрихкодов[0].Штрихкод, ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод"), Ложь);
	
КонецПроцедуры

// Процедура обрабатывает данные со считывателя магнитных карт, которые передаются из обработки оповещения формы.
//
&НаКлиенте
Процедура ОбработатьДанныеСчитывателяМагнитныхКарт(Данные)
	
	Если Элементы.Страницы.ТекущаяСтраница <> Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеДисконтнойКарты Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСчитывателя = Данные;
	ПодключитьОбработчикОжидания("ОбработатьПолученныйКодНаКлиентеВОбработкеОжидания", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ПерейтиНаСтраницу(Страница)
	
	СтэкСтраниц.Добавить(Элементы.Страницы.ТекущаяСтраница);
	Элементы.Страницы.ТекущаяСтраница = Страница;
	Элементы.СтраницыКнопкиНазад.ТекущаяСтраница = Элементы.СтраницыКнопкиНазад.ПодчиненныеЭлементы.КнопкаНазад;
	
	Если Страница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаВыборДисконтнойКарты Тогда
		Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод") Тогда
			Текст = НСтр("ru = 'Обнаружено несколько дисконтных карт с магнитным кодом ""%1"".
			                   |Выберите подходящую карту.'");
		Иначе
			Текст = НСтр("ru = 'Обнаружено несколько дисконтных карт со штрихкодом ""%1"".
			                   |Выберите подходящую карту.'");
		КонецЕсли;
		НадписьВыборДисконтнойКарты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КодКарты);
	КонецЕсли;
	
	СформироватьЗаголовокФормы();
	
КонецПроцедуры

// Функция проверяет магнитный код на соответствие шаблону и возвращает список ДК, магнитный код или штрикод.
//
&НаСервере
Функция ОбработатьПолученныйКодНаСервере(Данные, ТипКодаКарты, Предобработка, ЕстьНайденныеКарты = Ложь)
	
	ЕстьНайденныеКарты = Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НайденныеДисконтныеКарты.Очистить();
	
	ТипКода = ТипКодаКарты;
	Если ТипКода = Перечисления.ТипыКодовКарт.МагнитныйКод Тогда
		// При вызове функции параметр "Предобработка" будем устанавливать в значение Ложь, чтобы не использовались шаблоны магнитных карт.
		// В качестве кода карты будет использоваться строка, полученная конкатенацией строк со всех магнитных дорожек.
		// В большинстве дисконтных карт используется только одна дорожка, на которой записан только номер карты в формате ";КодКарты?".
		Если Предобработка Тогда
			КодКарты = Данные[0]; // Данные 3х дорожек магнитной карты. На данный момент не используется. Можно использовать если карта не найдена.
			                         // В случае, когда карта не соответствует ни одному шаблону, то будет выдано предупреждение, но кнопка "Готова" в форме нажата не будет.
			ДисконтныеКарты = ДисконтныеКартыВызовСервера.НайтиДисконтныеКартыПоДаннымСоСчитывателяМагнитныхКарт(Данные, ТипКода);
		Иначе
			Если ТипЗнч(Данные) = Тип("Массив") Тогда
				КодКарты = Данные[0];
			Иначе
				КодКарты = Данные;
			КонецЕсли;
			ДисконтныеКартыВызовСервера.ПодготовитьКодКартыПоНастройкамПоУмолчанию(КодКарты);
			ДисконтныеКарты = ДисконтныеКартыСервер.НайтиДисконтныеКартыПоМагнитномуКоду(КодКарты);
		КонецЕсли;
		
		Элементы.НайденныеДисконтныеКартыМагнитныйКод.Видимость = Истина;
	Иначе
		КодКарты = Данные;
		ДисконтныеКарты = ДисконтныеКартыВызовСервера.НайтиДисконтныеКартыПоШтрихкоду(КодКарты);
		
		Элементы.НайденныеДисконтныеКартыМагнитныйКод.Видимость = Ложь;
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из ДисконтныеКарты.ЗарегистрированныеДисконтныеКарты Цикл
		
		ЕстьНайденныеКарты = Истина;
		
		НоваяСтрока = НайденныеДисконтныеКарты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		
		НоваяСтрока.Наименование = Строка(СтрокаТЧ.Ссылка) + ?(ЗначениеЗаполнено(СтрокаТЧ.Контрагент) И ЗначениеЗаполнено(СтрокаТЧ.Ссылка), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = ' Клиент: %1'"), Строка(СтрокаТЧ.Контрагент)), "");
		
	КонецЦикла;
	
	Если ДисконтныеКарты.ЗарегистрированныеДисконтныеКарты.Количество() = 0 Тогда
		Для Каждого СтрокаТЧ Из ДисконтныеКарты.НеЗарегистрированныеДисконтныеКарты Цикл
			
			НоваяСтрока = НайденныеДисконтныеКарты.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
			
			НоваяСтрока.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1'"), Строка(СтрокаТЧ.ВидКарты))+?(СтрокаТЧ.ЭтоИменнаяКарта, " (Именная, ", " (")+СтрокаТЧ.ТипКарты+")";
			
		КонецЦикла;
	КонецЕсли;
	
	Возврат НайденныеДисконтныеКарты.Количество() > 0;
	
КонецФункции

// Функция проверяет магнитный код на соответствие шаблону и устанавливает магнитный код или штрикод элемента справочника.
//
&НаКлиенте
Процедура ОбработатьПолученныйКодНаКлиенте(Данные, ПолученныйТипКода, Предобработка)
	
	Перем ЕстьНайденныеКарты;
	
	Результат = ОбработатьПолученныйКодНаСервере(Данные, ПолученныйТипКода, Предобработка, ЕстьНайденныеКарты);
	Если Не Результат Тогда
		
		Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
			ТекстСообщения = НСтр("ru = 'Карта со штрихкодом ""%1"" не зарегистрирована и нет ни одного подходящего вида дисконтных карт.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Карта с магнитным кодом ""%1"" не зарегистрирована и нет ни одного подходящего вида дисконтных карт.'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, КодКарты),
			,
			"КодКарты");
		
		Возврат;
		
	КонецЕсли;
	
	Если НайденныеДисконтныеКарты.Количество() > 1 ИЛИ НЕ ЕстьНайденныеКарты Тогда
		ПерейтиНаСтраницу(Элементы.Страницы.ПодчиненныеЭлементы.ГруппаВыборДисконтнойКарты);
		Если ЕстьНайденныеКарты Тогда		
			Текст = НСтр("ru = 'Обнаружено несколько дисконтных карт с кодом ""%1"".
			                   |Выберите подходящую карту.'");
			НадписьВыборДисконтнойКарты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КодКарты);
		Иначе // Только виды карт для регистрации новой карты.
			Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
				Текст = НСтр("ru = 'Карта со штрихкодом ""%1"" не зарегистрирована.
			                   |Выберите подходящий вид карты для регистрации новой дисконтной карты.'");
			Иначе
				Текст = НСтр("ru = 'Карта с магнитным кодом ""%1"" не зарегистрирована.
			                   |Выберите подходящий вид карты для регистрации новой дисконтной карты.'");			   
			КонецЕсли;				   
			НадписьВыборДисконтнойКарты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КодКарты);
		КонецЕсли;
	ИначеЕсли НайденныеДисконтныеКарты.Количество() = 1 И ЕстьНайденныеКарты Тогда
		ОбработатьВыборДисконтнойКарты(НайденныеДисконтныеКарты[0]);
	КонецЕсли;
	
КонецПроцедуры

// Процедура вызывается при выборе пользователем определенной дисконтной карты.
//
&НаКлиенте
Процедура ОбработатьВыборДисконтнойКарты(ТекущиеДанные)
	
	ПараметрыЗакрытия = Новый Структура("ДисконтнаяКарта, СчитанаДисконтнаяКарта", ТекущиеДанные.Ссылка, Истина);
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

// Функция проверяет магнитный код на соответствие шаблону и устанавливает магнитный код элемента справочника или показывает список ДК или видов ДК.
//
&НаКлиенте
Процедура ОбработатьПолученныйКодНаКлиентеВОбработкеОжидания()
	
	ОбработатьПолученныйКодНаКлиенте(ДанныеСчитывателя, ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод"), Истина);
	
КонецПроцедуры

// Процедура нажимает кнопку Далее в обработке ожидания после имзенения кода карты или выбора дисконтной карты (вида дисконтной карты).
//
&НаКлиенте
Процедура ДалееОбработчикОжидания()
	
	Далее(Команды["Далее"]);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ПроцедурыИФункцииДляУправленияВнешнимВидомФормы

// Процедура настраивает видимость элементов в зависимости от реквзиитов вида дисконтной карты.
//
&НаСервере
Процедура НастройкаВидимостиЭлементовПоВидуКартыНаСервере()
	
	Если Не Объект.Владелец.Пустая() Тогда
		Именная = ПолучитьРеквизитВидаДисконтнойКарты(Объект.Владелец, "ЭтоИменнаяКарта");
		ТипКарты = ПолучитьРеквизитВидаДисконтнойКарты(Объект.Владелец, "ТипКарты");
	Иначе
		Именная = Ложь;
		ТипКарты = ПредопределенноеЗначение("Перечисление.ТипыКарт.ПустаяСсылка");		
	КонецЕсли;
	
	Элементы.ВладелецКарты.АвтоОтметкаНезаполненного = Именная;
	
	Элементы.ВладелецКарты.Видимость = Именная;
	Элементы.ЭтоИменнаяКарта.Видимость = Именная;
	
	Элементы.КодКартыМагнитный.Видимость = (ТипКарты = ПредопределенноеЗначение("Перечисление.ТипыКарт.Магнитная")
	                                        Или ТипКарты = ПредопределенноеЗначение("Перечисление.ТипыКарт.Смешанная"));
	Элементы.КодКартыШтрихкод.Видимость = (ТипКарты = ПредопределенноеЗначение("Перечисление.ТипыКарт.Штриховая")
	                                        Или ТипКарты = ПредопределенноеЗначение("Перечисление.ТипыКарт.Смешанная"));
											
	Если ТипКарты = ПредопределенноеЗначение("Перечисление.ТипыКарт.Смешанная") Тогда
		Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
			Элементы.СкопироватьМКвШК.Видимость = Ложь;
			Элементы.СкопироватьШКвМК.Видимость = Истина;
		Иначе
			Элементы.СкопироватьМКвШК.Видимость = Истина;
			Элементы.СкопироватьШКвМК.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.СкопироватьМКвШК.Видимость = Ложь;
		Элементы.СкопироватьШКвМК.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

