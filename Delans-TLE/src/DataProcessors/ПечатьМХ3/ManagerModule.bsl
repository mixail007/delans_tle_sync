
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ServiceAPI

Функция ИдентификаторПечатнойФормы() Экспорт
	
	Возврат "МХ3";
	
КонецФункции

Функция КлючПараметровПечати() Экспорт
	
	Возврат "ПАРАМЕТРЫ_ПЕЧАТИ_Универсальные_МХ3";
	
КонецФункции

Функция ПолныйПутьКМакету() Экспорт
	
	Возврат "Обработка.ПечатьМХ3.ПФ_MXL_МХ3";
	
КонецФункции

Функция ПредставлениеПФ() Экспорт
	
	Возврат НСтр("ru ='МХ-3 (Акт о возврате запасов сданных на хранение)'");
	
КонецФункции

Функция СформироватьПФ(ОписаниеПечатнойФормы, ДанныеОбъектовПечати, ОбъектыПечати) Экспорт
	Перем Ошибки, ПервыйДокумент, НомерСтрокиНачало;
	
	Макет				= УправлениеПечатью.МакетПечатнойФормы(ОписаниеПечатнойФормы.ПолныйПутьКМакету);
	ТабличныйДокумент	= ОписаниеПечатнойФормы.ТабличныйДокумент;
	ДанныеПечати		= Новый Структура;
	ЕстьТЧЗапасы		= (ДанныеОбъектовПечати.Колонки.Найти("ТаблицаЗапасы") <> Неопределено);
	
	Для каждого ДанныеОбъекта Из ДанныеОбъектовПечати Цикл
		
		ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало, ДанныеПечати);
		
		СведенияОбОрганизации = УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(ДанныеОбъекта.Организация, ДанныеОбъекта.ДатаДокумента, ,);
		СведенияОбКонтрагенте = УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(ДанныеОбъекта.Контрагент, ДанныеОбъекта.ДатаДокумента, ,);
		
		// Заголовок
		ОбластьМакета = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Заголовок", "", Ошибки);
		Если ОбластьМакета <> Неопределено Тогда
			
			ДанныеПечати.Вставить("НомерДокумента", ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(ДанныеОбъекта.ДатаДокумента, ДанныеОбъекта.Номер, ДанныеОбъекта.Префикс));
			ДанныеПечати.Вставить("ДатаДокумента", Формат(ДанныеОбъекта.ДатаДокумента, "ДЛФ=D"));
			ДанныеПечати.Вставить("ВидОперацииМХ3", ДанныеОбъекта.ВидОперацииМХ3);
			ДанныеПечати.Вставить("ПредставлениеОрганизации", УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,ЮридическийАдрес,Телефон,Факс"));
			ДанныеПечати.Вставить("ПредставлениеПодразделения", ДанныеОбъекта.ПредставлениеПодразделения);
			ДанныеПечати.Вставить("ПредставлениеСклада", ДанныеОбъекта.ПредставлениеСклада);
			ДанныеПечати.Вставить("СрокХранения", ДанныеОбъекта.СрокХранения);
			ДанныеПечати.Вставить("ПредставлениеКонтрагента", УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОбКонтрагенте, "ПолноеНаименование,ЮридическийАдрес,Телефон,Факс"));
			ДанныеПечати.Вставить("РасшифровкаПодписиКонтрагента", ДанныеОбъекта.РасшифровкаПодписиКонтрагента);
			ДанныеПечати.Вставить("ДоговорНомер", ДанныеОбъекта.ДоговорНомер);
			ДанныеПечати.Вставить("ДоговорДата", ДанныеОбъекта.ДоговорДата);
			ДанныеПечати.Вставить("ОрганизацияПоОКПО", ДанныеОбъекта.ОрганизацияПоОКПО);
			ДанныеПечати.Вставить("ВидДеятельностиПоОКДП", ДанныеОбъекта.ВидДеятельностиПоОКДП);
			ДанныеПечати.Вставить("КонтрагентПоОКПО", ДанныеОбъекта.КонтрагентПоОКПО);
			
			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЕсли;
		
		//Табличная часть
		НомерСтраницы = 1;
		
		ОбластьМакетаШапкаТаблицы = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "ШапкаТаблицы", "", Ошибки);
		Если ОбластьМакета <> Неопределено Тогда
			
			ДанныеПечати.Вставить("НомерСтраницы", НСтр("ru ='Страница '") + НомерСтраницы);
			
			ОбластьМакетаШапкаТаблицы.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакетаШапкаТаблицы);
			
		КонецЕсли;
		
		СтруктураИтогов = Новый Структура(
		"НомерСтроки,
		|КоличествоПоСтранице,
		|КоличествоПоАкту,
		|СуммаПоСтранице,
		|СуммаПоАкту,
		|ОсталосьВывестиСтрок",
		0, 0, 0, 0, 0, 0);
		
		СтруктураОбластейМакета = Новый Структура;
		СтруктураОбластейМакета.Вставить("ОбластьМакетаСтрока", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Строка", "", Ошибки));
		СтруктураОбластейМакета.Вставить("ОбластьМакетаИтоговПоСтранице", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "ИтогоПоСтранице", "", Ошибки));
		СтруктураОбластейМакета.Вставить("ОбластьМакетаВсего", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Всего", "", Ошибки));
		СтруктураОбластейМакета.Вставить("ОбластьМакетаШапкаТаблицы", ОбластьМакетаШапкаТаблицы);
		
		Если СтруктураОбластейМакета.ОбластьМакетаСтрока <> Неопределено Тогда
			
			Если ЕстьТЧЗапасы Тогда
				
				ПараметрыПроверки = Новый Структура;
				ПараметрыПроверки.Вставить("СтруктураОбластейМакета", СтруктураОбластейМакета);
				ПараметрыПроверки.Вставить("СтруктураИтогов", СтруктураИтогов);
				ПараметрыПроверки.Вставить("НомерСтраницы", НомерСтраницы);
				
				ПараметрыНоменклатуры = Новый Структура;
				СтруктураИтогов.ОсталосьВывестиСтрок = КоличествоСтрокКВыводуНаПечать(ДанныеОбъекта);
				
				Для каждого СтрокаТабличнойЧасти Из ДанныеОбъекта.ТаблицаЗапасы Цикл
					
					Если СтрокаТабличнойЧасти.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Запас Тогда
						
						Продолжить;
						
					КонецЕсли;
					
					СтруктураИтогов.ОсталосьВывестиСтрок = СтруктураИтогов.ОсталосьВывестиСтрок - 1;
					
					ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаТабличнойЧасти, ДанныеПечати, ПараметрыНоменклатуры, СтруктураИтогов, ДанныеОбъекта);
					
					СтруктураОбластейМакета.ОбластьМакетаСтрока.Параметры.Заполнить(ДанныеПечати);
					
					СтрокаПоместиласьНаСтранице(ТабличныйДокумент, ПараметрыПроверки);
					
					ТабличныйДокумент.Вывести(СтруктураОбластейМакета.ОбластьМакетаСтрока);
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
		// Итого по странице
		Если СтруктураОбластейМакета.ОбластьМакетаИтоговПоСтранице <> Неопределено Тогда
			
			ДанныеПечати.Вставить("КоличествоПоСтранице", СтруктураИтогов.КоличествоПоСтранице);
			ДанныеПечати.Вставить("СуммаПоСтранице", УправлениеНебольшойФирмойСервер.ФорматСумм(СтруктураИтогов.СуммаПоСтранице));
			
			СтруктураОбластейМакета.ОбластьМакетаИтоговПоСтранице.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(СтруктураОбластейМакета.ОбластьМакетаИтоговПоСтранице);
			
		КонецЕсли;
		
		// Всего
		Если СтруктураОбластейМакета.ОбластьМакетаВсего <> Неопределено Тогда
			
			ДанныеПечати.Вставить("КоличествоПоАкту", СтруктураИтогов.КоличествоПоАкту);
			ДанныеПечати.Вставить("СуммаПоАкту", УправлениеНебольшойФирмойСервер.ФорматСумм(СтруктураИтогов.СуммаПоАкту));
			
			СтруктураОбластейМакета.ОбластьМакетаВсего.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(СтруктураОбластейМакета.ОбластьМакетаВсего);
			
		КонецЕсли;
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		// Таблица услуг (заголовок и шапка таблицы)
		ОбластьМакета = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "ШапкаТаблицыУслуг", "", Ошибки);
		Если ОбластьМакета <> Неопределено Тогда
			
			ОбластьМакета.Параметры.Заполнить(ДанныеОбъекта);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЕсли;
		
		// Таблица услуг (пустые строки)
		ОбластьМакета = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "СтрокаУслуг", "", Ошибки);
		Если ОбластьМакета <> Неопределено Тогда
			
			Итератор = 0;
			Для Итератор = 1 По 5 Цикл
				
				ТабличныйДокумент.Вывести(ОбластьМакета);
				
			КонецЦикла;
			
		КонецЕсли;
		
		// Таблица услуг (всего)
		ОбластьМакета = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "ВсегоУслуг", "", Ошибки);
		Если ОбластьМакета <> Неопределено Тогда
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЕсли;
		
		// Таблица услуг (Детализация хранения)
		ОбластьМакета = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "ДетализацияХранения", "", Ошибки);
		Если ОбластьМакета <> Неопределено Тогда
			
			ОбластьМакета.Параметры.Заполнить(ДанныеОбъекта);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЕсли;
		
		//Подписи
		ОбластьМакета = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Подписи", , Ошибки);
		Если ОбластьМакета <> Неопределено Тогда
			
			ОбластьМакета.Параметры.Заполнить(ДанныеОбъекта);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеОбъекта.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

Процедура СтрокаПоместиласьНаСтранице(ТабличныйДокумент, ПараметрыПроверки)
	
	МассивВыводимыхОбластей = Новый Массив;
	МассивВыводимыхОбластей.Добавить(ПараметрыПроверки.СтруктураОбластейМакета.ОбластьМакетаСтрока);
	МассивВыводимыхОбластей.Добавить(ПараметрыПроверки.СтруктураОбластейМакета.ОбластьМакетаИтоговПоСтранице);
	
	Если ПараметрыПроверки.СтруктураИтогов.ОсталосьВывестиСтрок = 0 Тогда
		
		МассивВыводимыхОбластей.Добавить(ПараметрыПроверки.СтруктураОбластейМакета.ОбластьМакетаВсего);
		
	КонецЕсли;
	
	Если НЕ ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
		
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("СуммаПоСтранице", УправлениеНебольшойФирмойСервер.ФорматСумм(ПараметрыПроверки.СтруктураИтогов.СуммаПоСтранице));
		
		ПараметрыПроверки.СтруктураОбластейМакета.ОбластьМакетаИтоговПоСтранице.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ПараметрыПроверки.СтруктураОбластейМакета.ОбластьМакетаИтоговПоСтранице);
		
		ПараметрыПроверки.СтруктураИтогов.СуммаПоСтранице = 0;
		ПараметрыПроверки.СтруктураИтогов.КоличествоПоСтранице = 0;
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		ПараметрыПроверки.НомерСтраницы = ПараметрыПроверки.НомерСтраницы + 1;
		ДанныеПечати.Вставить("НомерСтраницы", НСтр("ru ='Страница '") + ПараметрыПроверки.НомерСтраницы);
		
		ПараметрыПроверки.СтруктураОбластейМакета.ОбластьМакетаШапкаТаблицы.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ПараметрыПроверки.СтруктураОбластейМакета.ОбластьМакетаШапкаТаблицы);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаТабличнойЧасти, ДанныеПечати, ПараметрыНоменклатуры, СтруктураИтогов, ДанныеОбъекта)
	
	ДанныеПечати.Очистить();
	
	СтруктураИтогов.НомерСтроки = СтруктураИтогов.НомерСтроки + 1;
	ДанныеПечати.Вставить("НомерСтроки", СтруктураИтогов.НомерСтроки);
	
	ПараметрыНоменклатуры.Очистить();
	ПараметрыНоменклатуры.Вставить("Содержание", СтрокаТабличнойЧасти.Содержание);
	ПараметрыНоменклатуры.Вставить("ПредставлениеНоменклатуры", СтрокаТабличнойЧасти.ПредставлениеНоменклатуры);
	ПараметрыНоменклатуры.Вставить("ПредставлениеПартии", СтрокаТабличнойЧасти.Партия);
	ДанныеПечати.Вставить("ПредставлениеНоменклатуры", ПечатьДокументовУНФ.ПредставлениеНоменклатуры(ПараметрыНоменклатуры));
	ДанныеПечати.Вставить("ПредставлениеКодаНоменклатуры", ПечатьДокументовУНФ.ПредставлениеКодаНоменклатуры(СтрокаТабличнойЧасти));
	
	ПараметрыНоменклатуры.Очистить();
	ПараметрыНоменклатуры.Вставить("ПредставлениеХарактеристики", СтрокаТабличнойЧасти.Характеристика);
	ДанныеПечати.Вставить("ПредставлениеХарактеристики", ПечатьДокументовУНФ.СтрокаПредставленияХарактеристики(ПараметрыНоменклатуры));
	
	ДанныеПечати.Вставить("Количество", СтрокаТабличнойЧасти.КоличествоПоКоэффициенту);
	ДанныеПечати.Вставить("ЕдиницаИзмерения", СтрокаТабличнойЧасти.ЕдиницаИзмерения);
	ДанныеПечати.Вставить("ЕдиницаИзмеренияПоОКЕИ_Наименование", СтрокаТабличнойЧасти.ЕдиницаИзмеренияПоОКЕИ_Наименование);
	ДанныеПечати.Вставить("ЕдиницаИзмеренияПоОКЕИ_Код", СтрокаТабличнойЧасти.ЕдиницаИзмеренияПоОКЕИ_Код);
	
	СуммаКПечати = ?(ДанныеОбъекта.СуммаВключаетНДС, СтрокаТабличнойЧасти.ВсегоВНациональнойВалюте, СтрокаТабличнойЧасти.ВсегоВНациональнойВалюте - СтрокаТабличнойЧасти.СуммаНДСВНациональнойВалюте); 
	ДанныеПечати.Вставить("Цена", УправлениеНебольшойФирмойСервер.ФорматСумм(Окр(СуммаКПечати / СтрокаТабличнойЧасти.КоличествоПоКоэффициенту, 2)));
	ДанныеПечати.Вставить("Сумма", УправлениеНебольшойФирмойСервер.ФорматСумм(СтрокаТабличнойЧасти.ВсегоВНациональнойВалюте));
	
	СтруктураИтогов.СуммаПоСтранице		= СтруктураИтогов.СуммаПоСтранице + СтрокаТабличнойЧасти.ВсегоВНациональнойВалюте;
	СтруктураИтогов.СуммаПоАкту			= СтруктураИтогов.СуммаПоАкту + СтрокаТабличнойЧасти.ВсегоВНациональнойВалюте;
	СтруктураИтогов.КоличествоПоСтранице= СтруктураИтогов.КоличествоПоСтранице + СтрокаТабличнойЧасти.КоличествоПоКоэффициенту;
	СтруктураИтогов.КоличествоПоАкту	= СтруктураИтогов.КоличествоПоАкту + СтрокаТабличнойЧасти.КоличествоПоКоэффициенту;
	
КонецПроцедуры

Функция КоличествоСтрокКВыводуНаПечать(ДанныеОбъекта)
	
	КоличествоРезультирующихСтрок = 0;
	
	Для каждого СтрокаТаблицы Из ДанныеОбъекта.ТаблицаЗапасы Цикл
		
		Если СтрокаТаблицы.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Запас Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		КоличествоРезультирующихСтрок = КоличествоРезультирующихСтрок + 1;
		
	КонецЦикла;
	
	Возврат КоличествоРезультирующихСтрок;
	
КонецФункции

#КонецЕсли