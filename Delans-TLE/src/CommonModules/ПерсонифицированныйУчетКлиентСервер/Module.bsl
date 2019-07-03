////////////////////////////////////////////////////////////////////////////////////////////
//
// Процедуры и функции подсистемы персонифицированного учёта для вызова с клиента и сервера
// 
////////////////////////////////////////////////////////////////////////////////////////////

//Функция раскладывает строку с данными о месте рождения на элементы структуры
//
Функция РазложитьМестоРождения(Знач СтрокаМестоРождения, ВерхнийРегистр = Истина) Экспорт

	Особое = 0;НаселенныйПункт	= "";Район	= "";Область	= "";Страна	= "";
	
	МассивМестоРождения	= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(?(ВерхнийРегистр, Врег(СтрокаМестоРождения), СтрокаМестоРождения));
	
	ЭлементовВМассиве = МассивМестоРождения.Количество();   
	Если ЭлементовВМассиве	>	0	тогда
		Если СокрЛП(МассивМестоРождения[0]) = "1" тогда
			Особое	=	1;
		КонецЕсли;	 
	КонецЕсли;
	Если ЭлементовВМассиве	>	1	тогда
		НаселенныйПункт	=	СокрЛП(МассивМестоРождения[1]);
	КонецЕсли;
	Если ЭлементовВМассиве	>	2	тогда
		Район	=	СокрЛП(МассивМестоРождения[2]);
	КонецЕсли;
	Если ЭлементовВМассиве	>	3	тогда
		Область	=	СокрЛП(МассивМестоРождения[3]);
	КонецЕсли;
	Если ЭлементовВМассиве	>	4	тогда
		Страна	=	СокрЛП(МассивМестоРождения[4]);
	КонецЕсли;

	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Особое",Особое);
	СтруктураВозврата.Вставить("НаселенныйПункт",НаселенныйПункт);
	СтруктураВозврата.Вставить("Район",Район);
	СтруктураВозврата.Вставить("Область",Область);
	СтруктураВозврата.Вставить("Страна",Страна);
	Возврат СтруктураВозврата;
	
КонецФункции	 

//Возвращает строковое представление места рождения
Функция ПредставлениеМестаРождения(Знач СтрокаМестоРождения) Экспорт  
	СтруктураМестоРождения = РазложитьМестоРождения(СтрокаМестоРождения, Ложь);

    Если СтруктураМестоРождения.Особое = 1 Тогда
	
		Представление	=	"особое" +
		?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.НаселенныйПункт),		"",	"  "	+	СокрЛП(СтруктураМестоРождения.НаселенныйПункт))
		+?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.Район),	"",	"  "	+	СокрЛП(СтруктураМестоРождения.Район))
		+?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.Область),	"",	"  "	+	СокрЛП(СтруктураМестоРождения.Область))
		+?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.Страна),	"",	"  "	+	СокрЛП(СтруктураМестоРождения.Страна));
	
	Иначе
	
		Представление	= "" + ?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.НаселенныйПункт),		"",	СокрЛП(СтруктураМестоРождения.НаселенныйПункт))
		+?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.Район),	"",	", " + СокрЛП(СтруктураМестоРождения.Район))
		+?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.Область),	"",	", "	+	СокрЛП(СтруктураМестоРождения.Область))
		+?(НЕ ЗначениеЗаполнено(СтруктураМестоРождения.Страна),	"",	", "	+	СокрЛП(СтруктураМестоРождения.Страна));
		
		Если Лев(Представление, 1) = ","  Тогда
			Представление = Сред(Представление, 2)
		КонецЕсли;
			
	КонецЕсли; 

	Возврат Представление;
КонецФункции	

//Процедуры и функции работы с периодом отчетности

Функция ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод) Экспорт 
	Если ОтчетныйПериод >= '20110101' Тогда
		Возврат КонецКвартала(ОтчетныйПериод);
	ИначеЕсли  Месяц(ОтчетныйПериод) <= 6 Тогда
		Возврат Дата(Год(ОтчетныйПериод), 6, 30, 23, 59, 59); 
	Иначе
		Возврат КонецГода(ОтчетныйПериод);
	КонецЕсли;	
КонецФункции

Функция ОкончаниеОтчетногоПериодаСтажаПерсУчета(ОтчетныйПериод) Экспорт 
	
	Если ОтчетныйПериод >= '20170101' Тогда
		Возврат КонецГода(ОтчетныйПериод);
	ИначеЕсли ОтчетныйПериод >= '20110101' Тогда
		Возврат КонецКвартала(ОтчетныйПериод);
	ИначеЕсли ОтчетныйПериод >= '20100101' Тогда
		Если  Месяц(ОтчетныйПериод) <= 6 Тогда
			Возврат Дата(Год(ОтчетныйПериод), 6, 30, 23, 59, 59); 
		Иначе
			Возврат КонецГода(ОтчетныйПериод);
		КонецЕсли;
	ИначеЕсли ОтчетныйПериод >= '20020101' Тогда
		Возврат КонецГода(ОтчетныйПериод);
	ИначеЕсли ОтчетныйПериод >= '20010101' Тогда
		Возврат КонецКвартала(ОтчетныйПериод);
	ИначеЕсли ОтчетныйПериод >= '19970101' Тогда
		Если  Месяц(ОтчетныйПериод) <= 6 Тогда
			Возврат Дата(Год(ОтчетныйПериод), 6, 30, 23, 59, 59); 
		Иначе
			Возврат КонецГода(ОтчетныйПериод);
		КонецЕсли;
	ИначеЕсли ОтчетныйПериод = '19960101' Тогда 
		Возврат КонецДня('19960930');
	Иначе 
		Возврат КонецКвартала(ОтчетныйПериод);
	КонецЕсли;
	
КонецФункции

Функция ПредшествующийОтчетныйПериодСтажаПерсУчета(Дата) Экспорт 
	
	Если Дата <= '20110101' Тогда 
		Возврат ДобавитьМесяц(НачалоКвартала(Дата), -6);	
	ИначеЕсли Дата <= '20170101' Тогда 		
		Возврат ДобавитьМесяц(НачалоКвартала(Дата), -3);
	Иначе		
		Возврат ДобавитьМесяц(НачалоГода(Дата), -12);
	КонецЕсли;	
	
КонецФункции

Функция КодОтчетногоПериода(ОтчетныйПериод) Экспорт 
	
	Если ОтчетныйПериод >= '20170101' Тогда
		Возврат 0;
	ИначеЕсли ОтчетныйПериод >= '20140101' Тогда
		Если Месяц(ОтчетныйПериод) <= 3 Тогда 
			Возврат 3;
		ИначеЕсли Месяц(ОтчетныйПериод) <= 6 Тогда 
			Возврат 6;
		ИначеЕсли Месяц(ОтчетныйПериод) <= 9 Тогда 
			Возврат 9;
		Иначе 
			Возврат 0;
		КонецЕсли;
	ИначеЕсли ОтчетныйПериод >= '20110101' Тогда
		Если Месяц(ОтчетныйПериод) <= 3 Тогда 
			Возврат 1;
		ИначеЕсли Месяц(ОтчетныйПериод) <= 6 Тогда 
			Возврат 2;
		ИначеЕсли Месяц(ОтчетныйПериод) <= 9 Тогда 
			Возврат 3;
		Иначе 
			Возврат 4;
		КонецЕсли;
	ИначеЕсли ОтчетныйПериод >= '20100101' Тогда
		Если  Месяц(ОтчетныйПериод) <= 6 Тогда
			Возврат 1; 
		Иначе
			Возврат 2;
		КонецЕсли;
	ИначеЕсли ОтчетныйПериод >= '20020101' Тогда
		Возврат 0;
	ИначеЕсли ОтчетныйПериод >= '20010101' Тогда
		Если Месяц(ОтчетныйПериод) <= 3 Тогда 
			Возврат 5;
		ИначеЕсли Месяц(ОтчетныйПериод) <= 6 Тогда 
			Возврат 6;
		ИначеЕсли Месяц(ОтчетныйПериод) <= 9 Тогда 
			Возврат 7;
		Иначе 
			Возврат 8;
		КонецЕсли;
	ИначеЕсли ОтчетныйПериод >= '19970101' Тогда
		Если  Месяц(ОтчетныйПериод) <= 6 Тогда
			Возврат 2; 
		Иначе
			Возврат 4;
		КонецЕсли;
	ИначеЕсли ОтчетныйПериод = '19960101' Тогда 
		Возврат 3;
	Иначе 
		Возврат 4;
	КонецЕсли;
	
КонецФункции

Функция ПредшествующийОтчетныйПериодПерсУчета(Дата) Экспорт 
	
	Если Дата <= '20110101' Тогда 
		Возврат ДобавитьМесяц(НачалоКвартала(Дата), -6);	
	Иначе		
		Возврат ДобавитьМесяц(НачалоКвартала(Дата), -3);
	КонецЕсли;	
	
КонецФункции

Функция ПолучитьНачалоОтчетногоПериода(Дата) Экспорт
	Если Дата >= '20110101' Тогда
		Возврат НачалоКвартала(Дата);
	ИначеЕсли Месяц(Дата) <= 6 Тогда
		Возврат Дата(Год(Дата), 1, 1);
	Иначе
		Возврат  Дата(Год(Дата), 7, 1);
	КонецЕсли;		
КонецФункции	

Функция ПредставлениеОтчетногоПериода(Период, Кратко = Ложь) Экспорт
	
	Если Период = '00010101' Тогда
		Возврат "";
	ИначеЕсли Период >= '20170101' Тогда	
		Возврат Формат(Период, "ДФ='гггг ""г.""'");
	ИначеЕсли Период >= '20110101' Тогда	
		Если Кратко Тогда
			Возврат Формат(Период, "ДФ='к ""кв."" ггг ""г.""'");
		Иначе	
			Возврат ПредставлениеПериода(Период, ОкончаниеОтчетногоПериодаПерсУчета(Период), "ФП = Истина");
		КонецЕсли;
	ИначеЕсли Период >= '20100101' Тогда
		Если Месяц(Период) <= 6  Тогда
			Если Кратко Тогда
				Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '1 полугод. %1 г.'"), Формат(Период, "ДФ=ггг"));
			Иначе	
				Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '1 полугодие %1 г.'"), Формат(Период, "ДФ=ггг"));
			КонецЕсли;	
		Иначе
			Если Кратко Тогда
				Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '2 полугод. %1 г.'"), Формат(Период, "ДФ=ггг"));
			Иначе	
				Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '2 полугодие %1 г.'"), Формат(Период, "ДФ=ггг"));
			КонецЕсли;	
		КонецЕсли;
	ИначеЕсли Период >= '20020101' Тогда
		Возврат Формат(Период, "ДФ='гггг ""г.""'");
	ИначеЕсли Период >= '20010101' Тогда
		Возврат ПредставлениеПериода(Период, КонецКвартала(Период), "ФП = Истина");
	ИначеЕсли Период >= '19970101' Тогда
		Если Месяц(Период) <= 6  Тогда
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '1 полугодие %1 г.'"), Формат(Период, "ДФ=ггг"));
		Иначе
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '2 полугодие %1 г.'"), Формат(Период, "ДФ=ггг"));
		КонецЕсли;
	ИначеЕсли Период >= '19961001' Тогда
		Возврат ПредставлениеПериода(Период, КонецКвартала(Период), "ФП = Истина");
	Иначе 
		Возврат ПредставлениеПериода(Период, КонецДня('19960930'), "ФП = Истина");
	КонецЕсли;
	
КонецФункции	

Функция ПолучитьПредставлениеДокументаУдостоверяющегоЛичность(Запись) Экспорт
	Перем КемВыдан, ДатаВыдачи;
	
	ТекстСерия				= НСтр("ru = ', серия: %1'");
	ТекстНомер				= НСтр("ru = ', № %1'");
	ТекстДатаВыдачи			= НСтр("ru = ', выдан: %1 года'");
	ТекстСрокДействия		= НСтр("ru = ', действует до: %1 года'");
	ТекстКодПодразделения	= НСтр("ru = ', № подр. %1'");

	Запись.Свойство("КемВыдан", КемВыдан);
	Запись.Свойство("ДатаВыдачи", ДатаВыдачи);
	
	Возврат Строка(Запись.ВидДокумента)
				+ ?(ЗначениеЗаполнено(Запись.СерияДокумента), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСерия, Запись.СерияДокумента), "")
				+ ?(ЗначениеЗаполнено(Запись.НомерДокумента), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстНомер, Запись.НомерДокумента), "")
				+ ?(ЗначениеЗаполнено(ДатаВыдачи), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстДатаВыдачи, Формат(ДатаВыдачи,"ДФ='дд ММММ гггг'")), "")
				+ ?(ЗначениеЗаполнено(КемВыдан), ", " + КемВыдан, "");
КонецФункции				

Процедура ВыполнитьНумерациюЗаписейОСтаже(СтрокиСтажаПоСотруднику) Экспорт 
	НомерОсновнойЗаписи =0; 

	НомерСтроки =0;
	Для Каждого СтрокаСтажа Из СтрокиСтажаПоСотруднику цикл
		НомерСтроки = НомерСтроки +1;

		//Контролируем смену основной записи
		Если ЗначениеЗаполнено(СтрокаСтажа.ДатаНачалаПериода) тогда
			//Встретили основную запись
			НомерОсновнойЗаписи = НомерОсновнойЗаписи +1; 
			НомерДополнительнойЗаписи =0; 
		Иначе	
			Если НомерОсновнойЗаписи <> 0 тогда
				НомерДополнительнойЗаписи =НомерДополнительнойЗаписи + 1; 
			КонецЕсли;	 
		КонецЕсли;	

		СтрокаСтажа.НомерОсновнойЗаписи = НомерОсновнойЗаписи;
		СтрокаСтажа.НомерДополнительнойЗаписи = НомерДополнительнойЗаписи;
	КонецЦикла;	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////////////////
//СЗВ-6-1, СЗВ-6-2, СПВ-1, Обр.ПодготовкаДанныхВПФР

Процедура ДокументыРедактированияСтажаСотрудникиПередУдалением(УдаляемыеСтроки, Сотрудники, ЗаписиОСтаже) Экспорт
	Для Каждого Идентификатор Из УдаляемыеСтроки Цикл
		СтрокаСотрудник = Сотрудники.НайтиПоИдентификатору(Идентификатор);
		Если СтрокаСотрудник <> Неопределено Тогда 
			УдалитьСтрокиТаблицыЗаписиОСтаже(ЗаписиОСтаже, СтрокаСотрудник.Сотрудник);
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры	

Процедура УдалитьСтрокиТаблицыЗаписиОСтаже(ЗаписиОСтаже, Сотрудник) Экспорт
	УдаляемыеСтрокиТаблицы = ЗаписиОСтаже.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
	
	Для Каждого УдаляемаяСтрока Из УдаляемыеСтрокиТаблицы Цикл
		ЗаписиОСтаже.Удалить(ЗаписиОСтаже.Индекс(УдаляемаяСтрока));
	КонецЦикла;	
КонецПроцедуры	

Процедура ДокументыРедактированияСтажаУстановитьОтборЗаписейОСтаже(ЭлементФормыЗаписиОСтаже, Сотрудник) Экспорт 
	СтруктураОтбора = Новый ФиксированнаяСтруктура("Сотрудник", Сотрудник);
	ЭлементФормыЗаписиОСтаже.ОтборСтрок = СтруктураОтбора;		
КонецПроцедуры

Функция ПолучитьСсылкуНаОтправляемыйДокументПоФорме(Форма) Экспорт
	Возврат Форма.СсылкаНаОтправляемыйДокумент();
КонецФункции

//////////////////////////////////////////////////////////////////////////////////////////////////
// Раскраска адресов в ТЧ документов


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Типы ошибок при проверке документов ПФР

Функция НовыйОшибкаЗаполненияЭлементаДокумента() Экспорт
	Возврат Новый Структура("ТипОшибки, Документ, Поле, Текст", "ОшибкаЗаполненияЭлементаДокумента");	
КонецФункции	

Процедура ДобавитьОшибкуЗаполненияЭлементаДокумента(Ошибки, Документ, Текст, Поле = "", Отказ = Ложь) Экспорт
	ОшибкаЗаполненияЭлементаДокумента = НовыйОшибкаЗаполненияЭлементаДокумента();
	
	ОшибкаЗаполненияЭлементаДокумента.Документ = Документ;
	ОшибкаЗаполненияЭлементаДокумента.Поле = Поле;
	ОшибкаЗаполненияЭлементаДокумента.Текст = Текст;
	
	Ошибки.Добавить(ОшибкаЗаполненияЭлементаДокумента);
	
	Отказ = Истина;
КонецПроцедуры	

Функция НовыйОшибкаЗаполненияСпискаСотрудников() Экспорт
	Возврат Новый Структура("ТипОшибки, Документ, НомерВПачке, Поле, Текст", "ОшибкаЗаполненияСпискаСотрудников");			
КонецФункции	

Процедура ДобавитьОшибкуЗаполненияСпискаСотрудников(Ошибки, Документ, НомерВПачке, Текст, Поле = "", Отказ = Ложь) Экспорт 
	ОшибкаЗаполненияСпискаСотрудников = НовыйОшибкаЗаполненияСпискаСотрудников();
	
	ОшибкаЗаполненияСпискаСотрудников.Документ = Документ;
	ОшибкаЗаполненияСпискаСотрудников.НомерВПачке = НомерВПачке;
	ОшибкаЗаполненияСпискаСотрудников.Текст = Текст;
	ОшибкаЗаполненияСпискаСотрудников.Поле = Поле;
	
	Ошибки.Добавить(ОшибкаЗаполненияСпискаСотрудников);
	
	Отказ = Истина;
	
КонецПроцедуры	

Функция НовыйОшибкаЗаполненияДанныхЗЛ() Экспорт
	Возврат Новый Структура("ТипОшибки, Документ, ЗастрахованноеЛицо, НомерВПачке, Поле, Текст", "ОшибкаЗаполненияДанныхЗЛ");	
КонецФункции

Процедура ДобавитьОшибкуЗаполненияДанныхЗЛ(Ошибки, Документ, ЗастрахованноеЛицо, НомерВПачке, Текст, Поле = "", Отказ = Ложь) Экспорт 
	ОшибкаЗаполненияДанныхЗЛ = НовыйОшибкаЗаполненияДанныхЗЛ();
	
	ОшибкаЗаполненияДанныхЗЛ.Документ = Документ;
	ОшибкаЗаполненияДанныхЗЛ.ЗастрахованноеЛицо = ЗастрахованноеЛицо;
	ОшибкаЗаполненияДанныхЗЛ.НомерВПачке = НомерВПачке;
	ОшибкаЗаполненияДанныхЗЛ.Текст = Текст;
	ОшибкаЗаполненияДанныхЗЛ.Поле = Поле;
	
	Ошибки.Добавить(ОшибкаЗаполненияДанныхЗЛ);
	
	Отказ = Истина;
	
КонецПроцедуры	

Функция НовыйОшибкаДанныхОВзносах() Экспорт
	Возврат Новый Структура("ТипОшибки, Документ,  НомерВПачке, Поле, Текст", "ОшибкаДанныхОВзносах");	
КонецФункции

Процедура ДобавитьОшибкуДанныхОВзносах(Ошибки, Документ, НомерВПачке, Текст, Поле = "", Отказ = Ложь) Экспорт 
	ОшибкаДанныхОВзноса = НовыйОшибкаДанныхОВзносах();
	
	ОшибкаДанныхОВзноса.Документ = Документ;
	ОшибкаДанныхОВзноса.НомерВПачке = НомерВПачке;
	ОшибкаДанныхОВзноса.Текст = Текст;
	ОшибкаДанныхОВзноса.Поле = Поле;
	
	Ошибки.Добавить(ОшибкаДанныхОВзноса);
	
	Отказ = Истина;
	
КонецПроцедуры	

Функция НовыйОшибкаДанныхОСтаже() Экспорт
	Возврат Новый Структура("ТипОшибки, Документ, НомерВПачке, НомерСтрокиСтаж, Поле, Текст", "ОшибкаДанныхОСтаже");	
КонецФункции

Процедура ДобавитьОшибкуДанныхОСтаже(Ошибки, Документ, НомерВПачке, НомерСтрокиСтаж, Текст, Поле = "", Отказ = Ложь) Экспорт
	ОшибкаДанныхОСтаже = НовыйОшибкаДанныхОСтаже();
	
	ОшибкаДанныхОСтаже.Документ = Документ;
	ОшибкаДанныхОСтаже.НомерВПачке = НомерВПачке;
	ОшибкаДанныхОСтаже.НомерСтрокиСтаж = НомерСтрокиСтаж;
	ОшибкаДанныхОСтаже.Текст = Текст;
	ОшибкаДанныхОСтаже.Поле = Поле;
	
	Ошибки.Добавить(ОшибкаДанныхОСтаже);
	
	Отказ = Истина;
КонецПроцедуры	

Функция НовыйОшибкаДанныхОЗаработке() Экспорт
	Возврат Новый Структура("ТипОшибки, Документ, НомерВПачке, Текст", "ОшибкаДанныхОЗаработке");			
КонецФункции

Процедура ДобавитьОшибкуДанныхОЗаработке(Ошибки, Документ, НомерВПачке, Текст, Отказ = Ложь)Экспорт
	ОшибкаДанныхОЗаработке = НовыйОшибкаДанныхОЗаработке();
	
	ОшибкаДанныхОЗаработке.Документ = Документ;
	ОшибкаДанныхОЗаработке.НомерВПачке = НомерВПачке;
	ОшибкаДанныхОЗаработке.Текст = Текст;
	
	Ошибки.Добавить(ОшибкаДанныхОЗаработке);
	
	Отказ = Истина
КонецПроцедуры	

Функция НовыйОшибкаНеЗаполненыДанныеОЗаработке() Экспорт
	Возврат Новый Структура("ТипОшибки, Документ, НомерВПачке, Текст", "ОшибкаНеЗаполненыДанныеОЗаработке");			
КонецФункции

Процедура ДобавитьОшибкуНеЗаполненыДанныеОЗаработке(Ошибки, Документ, НомерВПачке, Текст, Отказ = Ложь)Экспорт
	ОшибкаНеЗаполненыДанныеОЗаработке = НовыйОшибкаНеЗаполненыДанныеОЗаработке();
	
	ОшибкаНеЗаполненыДанныеОЗаработке.Документ = Документ;
	ОшибкаНеЗаполненыДанныеОЗаработке.НомерВПачке = НомерВПачке;
	ОшибкаНеЗаполненыДанныеОЗаработке.Текст = Текст;
	
	Ошибки.Добавить(ОшибкаНеЗаполненыДанныеОЗаработке);
	
	Отказ = Истина;
КонецПроцедуры	

Функция НовыйОшибкаДанныхОЗаработкеЗаМесяц() Экспорт
	Возврат Новый Структура("ТипОшибки, Документ, НомерВПачке, НомерСтрокиЗаработок, Поле, Текст", "ОшибкаДанныхОЗаработкеЗаМесяц");	
КонецФункции

Процедура ДобавитьОшибкуДанныхОЗаработкеЗаМесяц(Ошибки, Документ, НомерВПачке, НомерСтрокиЗаработок, Текст, Поле = "", Отказ = Ложь) Экспорт 
	ОшибкаДанныхОЗаработкеЗаМесяц = НовыйОшибкаДанныхОЗаработкеЗаМесяц();
	
	ОшибкаДанныхОЗаработкеЗаМесяц.Документ = Документ;
	ОшибкаДанныхОЗаработкеЗаМесяц.НомерВПачке = НомерВПачке;
	ОшибкаДанныхОЗаработкеЗаМесяц.НомерСтрокиЗаработок = НомерСтрокиЗаработок;
	ОшибкаДанныхОЗаработкеЗаМесяц.Текст = Текст;
	ОшибкаДанныхОЗаработкеЗаМесяц.Поле = Поле;
	
	Ошибки.Добавить(ОшибкаДанныхОЗаработкеЗаМесяц);
	
	Отказ = Истина;
	
КонецПроцедуры	

Функция НовыйОшибкаДанныхДокументаОписи() Экспорт
	Возврат Новый Структура("ТипОшибки, Опись, Документ, НомерСтроки, Текст, Поле", "ОшибкаДанныхДокументаОписи");	
КонецФункции	

Процедура ДобавитьОшибкуДанныхДокументаОписи(Ошибки, Опись, Документ, НомерСтроки, Текст, Поле = "", Отказ = Ложь) Экспорт 
	ОшибкаДанныхДокументаОписи = НовыйОшибкаДанныхДокументаОписи();
	
	ОшибкаДанныхДокументаОписи.Документ = Опись;
	ОшибкаДанныхДокументаОписи.Документ = Документ;
	ОшибкаДанныхДокументаОписи.НомерСтроки = НомерСтроки;
	ОшибкаДанныхДокументаОписи.Поле = Поле;
	ОшибкаДанныхДокументаОписи.Текст = Текст;
	
	Ошибки.Добавить(ОшибкаДанныхДокументаОписи);
КонецПроцедуры	

Функция НовыйОшибкаСверкиИтоговКомплекта() Экспорт
	Возврат Новый Структура("ТипОшибки, РазделыИтогов, Текст", "ОшибкаСверкиИтоговКомплекта");	
КонецФункции	

Процедура ДобавитьОшибкуСверкиИтоговКомплекта(Ошибки, РазделыИтогов, Текст, Отказ = Ложь) Экспорт
	ОшибкаСверкиИтоговКомплекта = НовыйОшибкаСверкиИтоговКомплекта();
	
	ОшибкаСверкиИтоговКомплекта.РазделыИтогов = РазделыИтогов;
	ОшибкаСверкиИтоговКомплекта.Текст = Текст;
	
	Ошибки.Добавить(ОшибкаСверкиИтоговКомплекта);
КонецПроцедуры	

Процедура ДобавитьРазделИтоговРСВ(РазделыИтогов, ИтоговыйПоказатель) Экспорт
	Раздел = Новый Структура("Раздел, Показатель", "РСВ1", ИтоговыйПоказатель);	
	
	РазделыИтогов.Добавить(Раздел);
КонецПроцедуры

Процедура ДобавитьРазделИтоговСЗВ63(РазделыИтогов, ИтоговыйПоказатель) Экспорт 
	Раздел = Новый Структура("Раздел, Показатель", "СЗВ63", ИтоговыйПоказатель);
	РазделыИтогов.Добавить(Раздел);
КонецПроцедуры

Процедура ДобавитьРазделИтоговАДВ62(РазделыИтогов, ИтоговыйПоказатель) Экспорт
	Раздел = Новый Структура("Раздел, Показатель", "АДВ62", ИтоговыйПоказатель);
	РазделыИтогов.Добавить(Раздел);	
КонецПроцедуры	

Функция НовыйОшибкаСверкиСпискаСотрудниковКомплекта() Экспорт
	Возврат Новый Структура("ТипОшибки, ИсточникиДанныхСверки, Текст, ПолеСверки", "ОшибкаСверкиСпискаСотрудниковКомплекта");		
КонецФункции	

Процедура ДобавитьОшибкуСверкиСпискаСотрудниковКомплекта(Ошибки, ИсточникиДанныхСверки, Текст, ПолеСверки = "", Отказ = Ложь) Экспорт
	ОшибкаСверкиСпискаСотрудниковКомплекта = НовыйОшибкаСверкиСпискаСотрудниковКомплекта();
	
	ОшибкаСверкиСпискаСотрудниковКомплекта.ИсточникиДанныхСверки = ИсточникиДанныхСверки;
	ОшибкаСверкиСпискаСотрудниковКомплекта.Текст = Текст;
	ОшибкаСверкиСпискаСотрудниковКомплекта.ПолеСверки = ПолеСверки;
	
	Ошибки.Добавить(ОшибкаСверкиСпискаСотрудниковКомплекта);
	
	Отказ = Истина;
КонецПроцедуры	

Процедура ДобавитьИсточникСверкиСпискаСотрудников(ИсточникиСверки, Документ, НомерВПачке) Экспорт
	ИсточникСверкиСпискаСотрудников = Новый Структура("Документ, НомерВПачке", Документ, НомерВПачке);
	
	ИсточникиСверки.Добавить(ИсточникСверкиСпискаСотрудников);
КонецПроцедуры	

Функция НовыйОшибкаСверкиВзносовРСВ1СОписьюПоКатегории() Экспорт
	Возврат Новый Структура("ТипОшибки, КатегорияЗастрахованныхЛиц, Текст, Поле", "ОшибкаСверкиВзносовРСВ1СОписьюПоКатегории");		
КонецФункции

Процедура ДобавитьОшибкуСверкиВзносовРСВ1СОписьюПоКатегории(Ошибки, КатегорияЗастрахованныхЛиц, Текст, Поле = "", Отказ = Ложь) Экспорт
	ОшибкаСверкиВзносовРСВ1СОписьюПоКатегории = НовыйОшибкаСверкиВзносовРСВ1СОписьюПоКатегории();
	
	ОшибкаСверкиВзносовРСВ1СОписьюПоКатегории.КатегорияЗастрахованныхЛиц = КатегорияЗастрахованныхЛиц;
	ОшибкаСверкиВзносовРСВ1СОписьюПоКатегории.Текст = Текст;
	ОшибкаСверкиВзносовРСВ1СОписьюПоКатегории.Поле = Поле;
	
	Ошибки.Добавить(ОшибкаСверкиВзносовРСВ1СОписьюПоКатегории);
	
	Отказ = Истина;
КонецПроцедуры	

Функция НовыйОшибкаНесоответствияТарифовКатегориям() Экспорт 
	Возврат Новый Структура("ТипОшибки, Текст", "ОшибкаНесоответствияТарифовКатегориям");	
КонецФункции

Процедура ДобавитьОшибкуНесоответствияТарифовКатегориям(Ошибки, Текст, Отказ = Ложь) Экспорт 
	ОшибкаНесоответствияТарифовКатегориям = НовыйОшибкаНесоответствияТарифовКатегориям();
	
	ОшибкаНесоответствияТарифовКатегориям.Текст = Текст;
	
	Ошибки.Добавить(ОшибкаНесоответствияТарифовКатегориям);
	
	Отказ = Истина;
КонецПроцедуры	

Функция НовыйОшибкаДанныхРСВ1() Экспорт
	Возврат Новый Структура("ТипОшибки, ОтчетДок, Отчет, Раздел, Графа, Строка, Страница, СтрокаПП, ИмяЯчейки, Описание", "ОшибкаДанныхРСВ1");	
КонецФункции

Процедура ДобавитьОшибкуДанныхРСВ1(Ошибки, ОтчетДок, Отчет, Описание, Раздел = "", Графа = "", Строка = "", Страница = "", СтрокаПП = "", ИмяЯчейки = "", Отказ = Ложь) Экспорт
	ОшибкаДанныхРСВ1 = НовыйОшибкаДанныхРСВ1();
	
	ОшибкаДанныхРСВ1.ОтчетДок = ОтчетДок;
	ОшибкаДанныхРСВ1.Отчет = Отчет;
	ОшибкаДанныхРСВ1.Раздел = Раздел;
	ОшибкаДанныхРСВ1.Графа = Графа;
	ОшибкаДанныхРСВ1.Строка = Строка;
	ОшибкаДанныхРСВ1.Страница = Страница;
	ОшибкаДанныхРСВ1.СтрокаПП = СтрокаПП;
	ОшибкаДанныхРСВ1.ИмяЯчейки = ИмяЯчейки;
	ОшибкаДанныхРСВ1.Описание = Описание;
	
	Ошибки.Добавить(ОшибкаДанныхРСВ1);
КонецПроцедуры	

Функция НовыйОшибкаУникальностиНомеровПачекКомплекта() Экспорт
	Возврат Новый Структура("ТипОшибки, Документ, Текст", "шибкаУникальностиНомеровПачекКомплекта");	
КонецФункции

Процедура ДобавитьОшибкуУникальностиНомеровПачекКомплекта(Ошибки, Документ, Текст, Отказ = Ложь) Экспорт
	ОшибкаУникальностиНомеровПачекКомплекта = НовыйОшибкаУникальностиНомеровПачекКомплекта();
	
	ОшибкаУникальностиНомеровПачекКомплекта.Документ = Документ;
	ОшибкаУникальностиНомеровПачекКомплекта.Текст = Текст;
	
	Ошибки.Добавить(ОшибкаУникальностиНомеровПачекКомплекта);
	
	Отказ = Истина;
КонецПроцедуры	

Функция НовыйОшибкаДанныхОЗадолженности() Экспорт
	Возврат Новый Структура("ТипОшибки, Документ, НомерСтроки, Текст, Поле", "ОшибкаДанныхОЗадолженности");		
КонецФункции

Процедура ДобавитьОшибкуДанныхОЗадолженности(Ошибки, Документ, НомерСтроки, Текст, Поле = "", Отказ = Ложь) Экспорт 
	ОшибкаДанныхОЗадолженности = НовыйОшибкаДанныхОЗадолженности();
	
	ОшибкаДанныхОЗадолженности.Документ = Документ;
	ОшибкаДанныхОЗадолженности.НомерСтроки = НомерСтроки;
	ОшибкаДанныхОЗадолженности.Поле = Поле;
	ОшибкаДанныхОЗадолженности.Текст = Текст;
	
	Ошибки.Добавить(ОшибкаДанныхОЗадолженности);
КонецПроцедуры	

Функция ЗначенияРеквизитовХраненияОшибокВСтруктуру(Форма, ИсточникДанных, ПутьКДанным) Экспорт	
	ЗначенияРеквизитовХраненияОшибок = Новый Структура;
	
	СвойстваЭлементовИндикацииОшибок = Форма.ОписаниеЭлементовСИндикациейОшибок();
	
	ЕстьХранилищеОшибок = Ложь;
	Для Каждого ОписаниеЭлемента Из СвойстваЭлементовИндикацииОшибок Цикл
		Если Сред(ОписаниеЭлемента.Ключ, 1, СтрДлина(ПутьКДанным)) = ПутьКДанным
			И (СтрДлина(ПутьКДанным) = СтрДлина(ОписаниеЭлемента.Ключ)
			Или Сред(ОписаниеЭлемента.Ключ, СтрДлина(ПутьКДанным) + 1, 1) = ".") Тогда 
			
			Если ТипЗнч(ИсточникДанных) = Тип("ДанныеФормыЭлементКоллекции") Тогда
				Если СтрДлина(ПутьКДанным) = СтрДлина(ОписаниеЭлемента.Ключ) Тогда
					ЗначенияРеквизитовХраненияОшибок.Вставить("ЕстьОшибки", ИсточникДанных["ЕстьОшибки"]);		
				Иначе
					ЭлементыПути = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ОписаниеЭлемента.Ключ, ".");
					
					ИмяРеквизита = ЭлементыПути[ЭлементыПути.Количество() - 1] + "ЕстьОшибки";
					
					ЗначенияРеквизитовХраненияОшибок.Вставить(ИмяРеквизита, ИсточникДанных[ИмяРеквизита]);
				КонецЕсли;		
			Иначе
				ЭлементыПути = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ОписаниеЭлемента.Ключ, ".");
				
				ЗначениеРеквизита = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(ИсточникДанных, ПутьКДанным + "ЕстьОшибки");
				
				ИмяРеквизита = ЭлементыПути[ЭлементыПути.Количество - 1] + "ЕстьОшибки";
				
				ЗначенияРеквизитовХраненияОшибок.Вставить(ИмяРеквизита, ЗначениеРеквизита);
			КонецЕсли;	
			
			Если ОписаниеЭлемента.Значение.ПутьКХранилищуОшибок <> Неопределено Тогда
				ЕстьХранилищеОшибок = Истина;					
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;	
	
	Если ЕстьХранилищеОшибок Тогда	
		Ошибки = Новый Соответствие;
		Для Каждого ДанныеОшибки Из ИсточникДанных["Ошибки"] Цикл
			ОшибкиПоПолю = Ошибки.Получить(ДанныеОшибки.Поле);
			Если ОшибкиПоПолю = Неопределено Тогда
				ОшибкиПоПолю = Новый Массив;
				Ошибки.Вставить(ДанныеОшибки.Поле, ОшибкиПоПолю);
			КонецЕсли;	
			
			ОписаниеОшибки = Новый Структура("Поле, ТекстОшибки", ДанныеОшибки.Поле, ДанныеОшибки.ТекстОшибки);
			
			ОшибкиПоПолю.Добавить(ОписаниеОшибки);
		КонецЦикла;
		
		ЗначенияРеквизитовХраненияОшибок.Вставить("Ошибки", Ошибки);	
	КонецЕсли;	
	
	Возврат ЗначенияРеквизитовХраненияОшибок;
КонецФункции	

