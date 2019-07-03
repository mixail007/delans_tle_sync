


&НаСервере
Функция СоздатьЗаказНаСервере()
	Запрос = Новый Запрос;     
	Запрос.Текст = 	
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказПокупателя.Ссылка
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	|ГДЕ
	|	ЗаказПокупателя.ES_НомерНакладной = &НомерНакладной";
	Запрос.УстановитьПараметр("НомерНакладной", НомерНакладной); 	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Если РезультатЗапроса.Количество() > 1 Тогда
		СтруктураВозв = Новый Структура;
		Сообщить("Заказ уже создан.");
		СтруктураВозв.Вставить("СсылкаДок",Документы.ЗаказПокупателя.ПустаяСсылка());
		Возврат СтруктураВозв;
	Иначе  			
		НовыйДокумент = Документы.ЗаказПокупателя.СоздатьДокумент();
	КонецЕсли;    	
	НовыйДокумент.Дата = ТекущаяДата();
	НовыйДокумент.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ES_ЗаказНаДоставку;
	НовыйДокумент.ДатаОтгрузки =  ТекущаяДата();
	НовыйДокумент.СостояниеЗаказа = Справочники.СостоянияЗаказовПокупателей.НайтиПоНаименованию("В работе");
	НовыйДокумент.ВидЗаказа = Справочники.ВидыЗаказовПокупателей.Основной;
	//НовыйДокумент.Контрагент = Справочники.Контрагенты.НайтиПоНаименованию(Заказчик);
	//ПараметрыДоговорПоУмолчанию = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НовыйДокумент.Контрагент, "ДоговорПоУмолчанию");
	//НовыйДокумент.Договор = ПараметрыДоговорПоУмолчанию.ДоговорПоУмолчанию;
	НовыйДокумент.Организация = ES_ОбщегоНазначения.ПолучитьСтартовуюНастройку(Перечисления.ES_ВидыСтартовыхНастроек.Организация); 
	//НовыйДокумент.ВидСкидкиНаценки = ПараметрыДоговорПоУмолчанию.ДоговорПоУмолчанию.ВидСкидкиНаценки;
	//НовыйДокумент.ВидЦен = ПараметрыДоговорПоУмолчанию.ДоговорПоУмолчанию.ВидЦен;
	//НовыйДокумент.СуммаВключаетНДС = ?(ЗначениеЗаполнено(ПараметрыДоговорПоУмолчанию.ДоговорПоУмолчанию.ВидЦен), ПараметрыДоговорПоУмолчанию.ДоговорПоУмолчанию.ВидЦен.ЦенаВключаетНДС, Неопределено);
	//НовыйДокумент.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДС;
	НовыйДокумент.ES_НомерНакладной = НомерНакладной;
	НовыйДокумент.ES_ВхНакладная = ВхНакладная;
	НовыйДокумент.ES_СрочностьДоставки = СрочностьДоставки;
	НовыйДокумент.Контрагент = Заказчик;
	НовыйДокумент.ES_ЗаказчикКонтактноеЛицо = КонтактноеЛицо;
	НовыйДокумент.ES_ЗаказчикТелефон = Телефон;
	НовыйДокумент.ES_СправочноЗаказчик = Заказчик;
	НовыйДокумент.Договор = ?(ЗначениеЗаполнено(Договор), Договор, Заказчик.ДоговорПоУмолчанию);
	НовыйДокумент.ES_Направление = Направление; 	
	НовыйДокумент.ES_Город1 = Направление.Город1;
	НовыйДокумент.ES_АдресДоставкиГород = Направление.Город2;  	
	ЗонаСрок = ES_ОбщегоНазначения.ОпределитьЗонуДоставки(Направление, Заказчик.ES_ВидКонтрагента, СрочностьДоставки);
	НовыйДокумент.ES_ЗонаДоставки = ЗонаСрок.Зона;
	НовыйДокумент.ES_СрокДоставки = ЗонаСрок.СрокДоставки;
	НовыйДокумент.ES_ЗаказчикИОтправительОдноЛицо = Истина;
	
	//НовыйДокумент.ES_Получатель = Заказчик;
	//НовыйДокумент.ES_ПолучательКонтактноеЛицо = КонтактноеЛицо;
	//НовыйДокумент.ES_ПолучательТелефон = Телефон;
	
	НовыйДокумент.ES_ВидДоставки = Перечисления.ES_ВидыДоставки.СкладДвери;
	НовыйДокумент.ES_Направление = Направление;
	НовыйДокумент.ES_ДоУточнения = Истина;
	НовыйДокумент.ES_ОбщийВес = Вес;
	НовыйДокумент.ES_КоличествоМест = 1;
	НовыйДокумент.ES_НППлан = СуммаДокумента;
	НовыйДокумент.ES_ВнутризональныйКоэф = 1;
	//НовыйДокумент.ES_ЗаборАдрес = Адрес;
	//НовыйДокумент.ES_ЗаборОтправитель = Отправитель;
	//НовыйДокумент.ES_ЗаборКомментарий = Примечание;
	//НовыйДокумент.ES_ЗаборРегион = Метро;
	//НовыйДокумент.ES_ЗаборТелефон = Телефон;
	//НовыйДокумент.ES_ЗаборДата = ДатаЗабора;
	//НовыйДокумент.ES_ЗаборВремяС = ВремяЗабораС;
	//НовыйДокумент.ES_ВремяДоставкиПо = ВремяЗабораПо;
	
	ЗаполнитьСтавкуНДСПоОрганизациияНалогообложениеНДС(НовыйДокумент);
	ЗаполнитьДокДаннымиКонтрагента(НовыйДокумент);
	СтруктураВозврата = ES_ОбщегоНазначенияКлиентСервер.ЭР_ОбновитьСтоимостьДоставки(НовыйДокумент.Дата, НовыйДокумент.Договор, НовыйДокумент.ES_ЗонаДоставки, Вес, СрочностьДоставки, НовыйДокумент.ES_ВидДоставки, Заказчик.ES_ВидКонтрагента); 
	НовыйДокумент.Запасы.Очистить();
	ES_ОбщегоНазначения.ЭР_ЗаполнитьДопУслугиПоДоговору(НовыйДокумент);
	ТЧ = НовыйДокумент.Запасы.Добавить();
	УслугаДоставки =  ES_ОбщегоНазначения.ПолучитьСтартовуюНастройку(Перечисления.ES_ВидыСтартовыхНастроек.УслугаДоставки);
	ТЧ.Номенклатура = УслугаДоставки;
	ТЧ.Количество = 1;
	ТЧ.Цена = СтруктураВозврата.Цена;
	ТЧ.Сумма = СтруктураВозврата.Цена;  
	ТЧ.СтавкаНДС = ES_ОбщегоНазначения.ПолучитьСтавкуНДСНоменклатуры(ТЧ.Номенклатура);
	
	//ES_ОбщегоНазначенияКлиентСервер.ЭР_ОбновитьУслугиТЧДоставки(НовыйДокумент.Договор.Услуги, ТекущаяДата(), НовыйДокумент.Договор,СтруктураВозврата.Цена,0,НовыйДокумент.ES_НППлан,НовыйДокумент.ES_ОбщийВес);
	
	//Для Каждого СтрокаТабличнойЧасти Из НовыйДокумент.Запасы Цикл
	//	Если СтрокаТабличнойЧасти.Номенклатура = УслугаДоставки Тогда
	//		Продолжить;
	//	КонецЕсли;
	//	
	//	НоваяЦена = ЭР_ОбновитьУслугиТЧДоставкиНаСервере(СтрокаТабличнойЧасти.Номенклатура,УслугаДоставки);
	//	СтрокаТабличнойЧасти.Цена = ?(НоваяЦена.Количество() <> 0, НоваяЦена[0],  0);
	//	СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Цена*СтрокаТабличнойЧасти.Количество;
	//	РассчитатьСуммуНДС(СтрокаТабличнойЧасти,НовыйДокумент);
	//	
	//	// Всего.
	//	СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(НовыйДокумент.СуммаВключаетНДС, 0, СтрокаТабличнойЧасти.СуммаНДС);
	//КонецЦикла;

	
	Попытка 
		НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
		Сообщить("Создан новый документ "+НовыйДокумент.Ссылка);
	Исключение
		НовыйДокумент.Записать(РежимЗаписиДокумента.Запись);
		Сообщить("Документ изменен "+НовыйДокумент.Ссылка);     
	КонецПопытки;
	СтруктураВозв = Новый Структура;
	СтруктураВозв.Вставить("СсылкаДок",НовыйДокумент.Ссылка);
	Возврат СтруктураВозв;
КонецФункции
&НаКлиенте
Процедура СоздатьЗаказ(Команда)   	
	СсылкаНаЗаказ =СоздатьЗаказНаСервере().СсылкаДок;
	Если СсылкаНаЗаказ.Пустая() Тогда
		Возврат;
	КонецЕсли;	
	мВладелец = ЭтаФорма.ВладелецФормы;
	// 
	Стр = Новый Структура;
	Стр.Вставить("Заказ",СсылкаНаЗаказ);
	ТЧПоиск = мВладелец.Объект.Заказы.НайтиСтроки(Стр);
	Если ТЧПоиск.Количество()> 0 Тогда
		Возврат;
	Иначе 		
		ТЧ = мВладелец.Объект.Заказы.Добавить();
		ТЧ.Заказ = СсылкаНаЗаказ;
	КонецЕсли;
	
	Закрыть();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ES_НаправлениеПриИзмененииНаСервере(Направление)
	  //EFSOL Сережко А.С. +    
	  Структура = Новый Структура;
	  
	  Структура.Вставить("Город1", Направление.Город1);
	  Структура.Вставить("Город2", Направление.Город2);
	  Возврат Структура;
	  //EFSOL Сережко А.С. -  
КонецФункции


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Заказчик = Параметры.Контрагент;
	Договор = Параметры.Договор;
	Отправитель = Параметры.Отправитель;
	Адрес = Параметры.Адрес;
	Телефон = Параметры.Телефон;
	Метро = Параметры.Метро;
	Примечание = Параметры.Примечание;
	ДатаЗабора = Параметры.ДатаЗабора;
	ВремяЗабораС = Параметры.ВремяЗабораС;
	ВремяЗабораПо = Параметры.ВремяЗабораПо;
	КонтактноеЛицо = Параметры.КонтактноеЛицо;
	СуммаДокумента = Параметры.СуммаДокумента;
КонецПроцедуры

&НаСервере
Процедура РассчитатьСуммуНДС(СтрокаТабличнойЧасти,мОбъект)
	
	СтавкаНДС = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДС(СтрокаТабличнойЧасти.СтавкаНДС);
	
	СтрокаТабличнойЧасти.СуммаНДС = ?(мОбъект.СуммаВключаетНДС, 
	СтрокаТабличнойЧасти.Сумма - (СтрокаТабличнойЧасти.Сумма) / ((СтавкаНДС + 100) / 100),
	СтрокаТабличнойЧасти.Сумма * СтавкаНДС / 100);
	
КонецПроцедуры // ПересчитатьСуммыДокумента() 

&НаСервере
Процедура ЗаполнитьДокДаннымиКонтрагента(НовыйДокумент)
	
	//НовыйДокумент = НовДокСсылка.ПолучитьОбъект();
	Контрагент = НовыйДокумент.Контрагент;
	
	СтруктураДанные = ПолучитьДанныеКонтрагентПриИзменении(НовыйДокумент.Ссылка, Контрагент, НовыйДокумент.Организация,Договор);
	
	НовыйДокумент.Договор = СтруктураДанные.Договор;
	НовыйДокумент.ВалютаДокумента = ?(ЗначениеЗаполнено(СтруктураДанные.ВалютаРасчетов), СтруктураДанные.ВалютаРасчетов, Константы.НациональнаяВалюта.Получить());
	
	Если ЗначениеЗаполнено(НовыйДокумент.Договор) Тогда 
		НовыйДокумент.Курс      = ?(СтруктураДанные.ВалютаРасчетовКурсКратность.Курс = 0, 1, СтруктураДанные.ВалютаРасчетовКурсКратность.Курс);
		НовыйДокумент.Кратность = ?(СтруктураДанные.ВалютаРасчетовКурсКратность.Кратность = 0, 1, СтруктураДанные.ВалютаРасчетовКурсКратность.Кратность);
		НовыйДокумент.ВидЦен = СтруктураДанные.ВидЦен;
		НовыйДокумент.ВидСкидкиНаценки = СтруктураДанные.ВидСкидкиНаценки;
		НовыйДокумент.СуммаВключаетНДС = СтруктураДанные.СуммаВключаетНДС;
		////ЭР Несторук С.И. 19.04.2017 9:34:50 {
		//Если СтруктураДанные.СуммаВключаетНДС <> Неопределено Тогда
		//	НовыйДокумент.НДСВключатьВСтоимость = ?(СтруктураДанные.СуммаВключаетНДС, Истина, Ложь);
		//КонецЕсли;
		////}ЭР Несторук С.И.

	КонецЕсли;
	
	НовыйДокумент.Записать();

КонецПроцедуры // КонтрагентПриИзменении()

// Получает набор данных с сервера для процедуры КонтрагентПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеКонтрагентПриИзменении(НовДокСсылка, Контрагент, Организация, Договор)
	
	//ДоговорПоУмолчанию = ПолучитьДоговорПоУмолчанию(НовДокСсылка, Контрагент, Организация, Перечисления.ВидыОперацийЗаказПокупателя.ES_ЗаказНаДоставку);
	
	СтруктураДанные = Новый Структура();
	
	СтруктураДанные.Вставить(
		"Договор",
		Договор
	);
	
	СтруктураДанные.Вставить(
		"ВалютаРасчетов",
		Договор.ВалютаРасчетов
	);
	
	СтруктураДанные.Вставить(
		"ВалютаРасчетовКурсКратность",
		РегистрыСведений.КурсыВалют.ПолучитьПоследнее(ТекущаяДата(), Новый Структура("Валюта", Договор.ВалютаРасчетов))
	);
	
	СтруктураДанные.Вставить(
		"РасчетыВУсловныхЕдиницах",
		Договор.РасчетыВУсловныхЕдиницах
	);
	
	СтруктураДанные.Вставить(
		"ВидСкидкиНаценки",
		Договор.ВидСкидкиНаценки
	);
	
	СтруктураДанные.Вставить(
		"ВидЦен",
		Договор.ВидЦен
	);
	
	СтруктураДанные.Вставить(
		"СуммаВключаетНДС",
		?(ЗначениеЗаполнено(Договор.ВидЦен), Договор.ВидЦен.ЦенаВключаетНДС, Неопределено)
	);
		
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеКонтрагентПриИзменении()

Процедура ЗаполнитьСтавкуНДСПоОрганизациияНалогообложениеНДС(НовыйДокумент)
	
	НовыйДокумент.НалогообложениеНДС = УправлениеНебольшойФирмойСервер.НалогообложениеНДС(НовыйДокумент.Организация,, НовыйДокумент.Дата);
	
	Если НовыйДокумент.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НеОблагаетсяНДС Тогда	
		НовыйДокумент.НДСВключатьВСтоимость = Ложь;
		СтавкаНДСПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСБезНДС();
	Иначе
		НовыйДокумент.НДСВключатьВСтоимость = Истина;
		СтавкаНДСПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСНоль();
	КонецЕсли;	
	
	Для каждого СтрокаТабличнойЧасти Из НовыйДокумент.Запасы Цикл
		
		//ЕФСОЛ Несторук 09-11-16 +
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНДС) Тогда  
			//ЕФСОЛ Несторук 09-11-16 -
			
			
			СтрокаТабличнойЧасти.СтавкаНДС = СтавкаНДСПоУмолчанию;
			СтрокаТабличнойЧасти.СуммаНДС = 0;
			
			СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма;
			
			//ЕФСОЛ Несторук 09-11-16 +
		КонецЕсли;
		//ЕФСОЛ Несторук 09-11-16 -

	КонецЦикла;	
	
КонецПроцедуры // ЗаполнитьСтавкуНДСПоНалогообложениеНДС()