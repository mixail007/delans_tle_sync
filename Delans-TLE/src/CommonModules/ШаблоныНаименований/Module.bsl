
#Область ПрограммныйИнтерфейс

Процедура ИнициализироватьНастройкиФормированияНаименований(Форма, Настройки) Экспорт
	
	Настройки = Новый Структура;
	
	Настройки.Вставить("ТребуетсяОбновитьНаименования", Истина);
	Настройки.Вставить("СформированныеНаименования", Новый СписокЗначений);
	Настройки.Вставить("СписокСвойств", Новый СписокЗначений);
	Настройки.Вставить("НаименованиеПолучено", Ложь);
	
	Форма.ШаблоныНаименованийКэш.Очистить();
	
	Если НЕ ЗначениеЗаполнено(Форма.Объект.Ссылка) Тогда
		
		// Наименование будет изменяться автоматически для создаваемого/копируемого объекта. Для записанного объекта наименование не меняется.
		ФормироватьНаименованиеАвтоматически = Истина;
		
		Если Форма.Параметры.Свойство("ТекстЗаполнения") И ЗначениеЗаполнено(Форма.Параметры.ТекстЗаполнения) Тогда
			ФормироватьНаименованиеАвтоматически = Ложь;
		КонецЕсли;
		
		Если ТипЗнч(Форма.Объект.Ссылка) = Тип("СправочникСсылка.Номенклатура") Тогда
			
			Категория = Форма.Объект.КатегорияНоменклатуры;
			Шаблоны = ШаблоныНаименованийПовтИсп.ШаблоныНаименованийКатегории(Категория, Ложь);
			
			Если Шаблоны.Количество() = 0 Тогда
				Возврат;
			КонецЕсли;
			
			Если ФормироватьНаименованиеАвтоматически Тогда
				ВидНаименования = Перечисления.ВидыНаименованийОбъектов.НоменклатураРабочее;
				Шаблон = ВыбратьШаблонНаименования(
					Шаблоны,
					Категория,
					ВидНаименования
				);
				ДобавитьИнформациюОШаблонеВНастройкиФормы(Форма, Шаблон, ВидНаименования);
			КонецЕсли;
			
			Если ФормироватьНаименованиеАвтоматически Тогда
				ВидНаименования = Перечисления.ВидыНаименованийОбъектов.НоменклатураДляПечати;
				Шаблон = ВыбратьШаблонНаименования(
					Шаблоны,
					Категория,
					ВидНаименования
				);
				ДобавитьИнформациюОШаблонеВНастройкиФормы(Форма, Шаблон, ВидНаименования);
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("СправочникСсылка.ХарактеристикиНоменклатуры") Тогда
			
			Категория = Форма.КатегорияНоменклатуры;
			Шаблоны = ШаблоныНаименованийПовтИсп.ШаблоныНаименованийКатегории(Категория, Истина);
			
			Если Шаблоны.Количество() = 0 Тогда
				Возврат;
			КонецЕсли;
			
			Если ФормироватьНаименованиеАвтоматически Тогда
				ВидНаименования = Перечисления.ВидыНаименованийОбъектов.ХарактеристикаРабочее;
				Шаблон = ВыбратьШаблонНаименования(
					Шаблоны,
					Категория,
					ВидНаименования
				);
				ДобавитьИнформациюОШаблонеВНастройкиФормы(Форма, Шаблон, ВидНаименования);
			КонецЕсли;
			
			Если ФормироватьНаименованиеАвтоматически Тогда
				ВидНаименования = Перечисления.ВидыНаименованийОбъектов.ХарактеристикаДляПечати;
				Шаблон = ВыбратьШаблонНаименования(
					Шаблоны,
					Категория,
					ВидНаименования
				);
				ДобавитьИнформациюОШаблонеВНастройкиФормы(Форма, Шаблон, ВидНаименования);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьСписокСвойствОбъекта(Форма, Истина);
	
КонецПроцедуры

Процедура СоздатьШаблоныПоУмолчанию(Категория) Экспорт
	
	Шаблон = "{[Наименование]}{ [Артикул]}";
	
	ШаблонОбъект = Справочники.ШаблоныНаименований.СоздатьЭлемент();
	ШаблонОбъект.Владелец = Категория.Ссылка;
	ШаблонОбъект.ДляХарактеристики = Ложь;
	ШаблонОбъект.ШаблонДляПредставления = Шаблон;
	ШаблонОбъект.ШаблонДляФормирования = Шаблон;
	СформироватьНаименованиеШаблона(ШаблонОбъект);
	ШаблонОбъект.Записать();
	
	Шаблон = "{[Наименование]}{ [Код]}";
	
	ШаблонОбъект = Справочники.ШаблоныНаименований.СоздатьЭлемент();
	ШаблонОбъект.Владелец = Категория.Ссылка;
	ШаблонОбъект.ДляХарактеристики = Ложь;
	ШаблонОбъект.ШаблонДляПредставления = Шаблон;
	ШаблонОбъект.ШаблонДляФормирования = Шаблон;
	СформироватьНаименованиеШаблона(ШаблонОбъект);
	ШаблонОбъект.Записать();
	
КонецПроцедуры

Процедура СоздатьШаблоныПоУмолчаниюДляНабораСвойств(Категория, НаборСвойств, ДляХарактеристики) Экспорт
	
	Если ДляХарактеристики Тогда
		Если НаборСвойств.ДополнительныеРеквизиты.Количество() <> 0 Тогда
			
			ШаблонОбъект = Справочники.ШаблоныНаименований.СоздатьЭлемент();
			ШаблонОбъект.Владелец = Категория.Ссылка;
			ШаблонОбъект.ДляХарактеристики = ДляХарактеристики;
			ШаблонОбъект.НаборСвойств = НаборСвойств;
			ШаблонОбъект.ВидНаименования = Перечисления.ВидыНаименованийОбъектов.ХарактеристикаРабочее;
			ШаблонОбъект.ЭтоПредопределенный = Истина;
			СФормироватьШаблон(ШаблонОбъект, НаборСвойств);
			СформироватьНаименованиеШаблона(ШаблонОбъект);
			ШаблонОбъект.Записать();
			
			ШаблонОбъект = Справочники.ШаблоныНаименований.СоздатьЭлемент();
			ШаблонОбъект.Владелец = Категория.Ссылка;
			ШаблонОбъект.ДляХарактеристики = ДляХарактеристики;
			ШаблонОбъект.НаборСвойств = НаборСвойств;
			ШаблонОбъект.ВидНаименования = Перечисления.ВидыНаименованийОбъектов.ХарактеристикаДляПечати;
			ШаблонОбъект.ЭтоПредопределенный = Истина;
			СФормироватьШаблон(ШаблонОбъект, НаборСвойств);
			СформироватьНаименованиеШаблона(ШаблонОбъект);
			ШаблонОбъект.Записать();
			
		КонецЕсли;
	Иначе
		Если НаборСвойств.ДополнительныеРеквизиты.Количество() <> 0 Тогда
			
			ШаблонОбъект = Справочники.ШаблоныНаименований.СоздатьЭлемент();
			ШаблонОбъект.Владелец = Категория.Ссылка;
			ШаблонОбъект.ДляХарактеристики = ДляХарактеристики;
			ШаблонОбъект.НаборСвойств = НаборСвойств;
			ШаблонОбъект.ВидНаименования = Перечисления.ВидыНаименованийОбъектов.НоменклатураРабочее;
			ШаблонОбъект.ЭтоПредопределенный = Истина;
			СФормироватьШаблон(ШаблонОбъект, НаборСвойств);
			СформироватьНаименованиеШаблона(ШаблонОбъект);
			ШаблонОбъект.Записать();
			
			ШаблонОбъект = Справочники.ШаблоныНаименований.СоздатьЭлемент();
			ШаблонОбъект.Владелец = Категория.Ссылка;
			ШаблонОбъект.ДляХарактеристики = ДляХарактеристики;
			ШаблонОбъект.НаборСвойств = НаборСвойств;
			ШаблонОбъект.ВидНаименования = Перечисления.ВидыНаименованийОбъектов.НоменклатураДляПечати;
			ШаблонОбъект.ЭтоПредопределенный = Истина;
			СФормироватьШаблон(ШаблонОбъект, НаборСвойств);
			СформироватьНаименованиеШаблона(ШаблонОбъект);
			ШаблонОбъект.Записать();
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьНаименованиеШаблона(ШаблонОбъект) Экспорт
	
	Наименование = "";
	ТекстовыеБлоки = Новый Массив;
	Блоки = ШаблоныНаименованийКлиентСервер.РазделитьШаблонНаБлоки(ШаблонОбъект.ШаблонДляПредставления);
	
	Для каждого Блок Из Блоки Цикл
		
		НовыйБлок = "%1%2%3";
		Если ЗначениеЗаполнено(Блок.Параметр) Тогда
			ПредставлениеПараметра = "[" + Блок.Параметр + "]";
		Иначе
			ПредставлениеПараметра = "";
		КонецЕсли;
		НовыйБлок = СтрШаблон(НовыйБлок, Блок.ТекстСлева, ПредставлениеПараметра, Блок.ТекстСправа);
		
		Наименование = Наименование + НовыйБлок;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Наименование) Тогда
		Наименование = СокрЛП(Наименование);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Наименование) Тогда
		ШаблонОбъект.Наименование = Наименование;
	Иначе
		ШаблонОбъект.Наименование = НаименованиеНезаполненногоШаблона();
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьНаименования(Форма, Категория) Экспорт
	
	Если ТипЗнч(Форма.Объект.Ссылка) = Тип("СправочникСсылка.Номенклатура") Тогда
		ДляХарактеристики = Ложь;
	ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("СправочникСсылка.ХарактеристикиНоменклатуры") Тогда
		ДляХарактеристики = Истина;
	Иначе
		Возврат;
	КонецЕсли;
	
	СписокСвойств = Форма.ШаблоныНаименованийНастройки.СписокСвойств;
	
	СформированныеНаименования = Новый СписокЗначений;
	
	Шаблоны = ШаблоныНаименованийПовтИсп.ШаблоныНаименованийКатегории(Категория, ДляХарактеристики);
	Для каждого Шаблон Из Шаблоны Цикл
		
		СФормированноеНаименование = ШаблоныНаименованийКлиентСервер.СформироватьНаименованиеПоШаблону(СписокСвойств, Шаблон.ШаблонДляФормирования);
		Если ЗначениеЗаполнено(СФормированноеНаименование) И НЕ УжеЕстьТакоеНаименование(СформированныеНаименования, СФормированноеНаименование) Тогда
			СформированныеНаименования.Добавить(Шаблон.Ссылка, СФормированноеНаименование);
		КонецЕсли;
		
	КонецЦикла;
	
	СформированныеНаименования.Добавить(Справочники.ШаблоныНаименований.ПустаяСсылка(), "<показать все шаблоны>",,БиблиотекаКартинок.Выбрать);
	
	Форма.ШаблоныНаименованийНастройки.ТребуетсяОбновитьНаименования = Ложь;
	Форма.ШаблоныНаименованийНастройки.СФормированныеНаименования = СформированныеНаименования;
	
КонецПроцедуры

Процедура ЗапомнитьШаблоныДляВидовНаименований(Форма, КатегорияНоменклатуры) Экспорт
	
	Для каждого ШаблонКэш Из Форма.ШаблоныНаименованийКэш Цикл
		
		ВидНаименования = ШаблонКэш.ВидНаименования;
		Шаблон          = ШаблонКэш.ШаблонСсылка;
		
		ТекущийШаблон = ШаблоныНаименованийПовтИсп.ПолучитьШаблонДляВидаНаименования(КатегорияНоменклатуры, ВидНаименования);
		Если Шаблон = ТекущийШаблон Тогда
			Возврат;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.ШаблоныНаименований.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.КатегорияНоменклатуры.Установить(КатегорияНоменклатуры);
		НаборЗаписей.Отбор.ВидНаименования.Установить(ВидНаименования);
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() = 0 Тогда
			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.КатегорияНоменклатуры = КатегорияНоменклатуры;
			НоваяЗапись.ВидНаименования       = ВидНаименования;
			НоваяЗапись.Шаблон                = Шаблон;
			
		Иначе
			
			Запись = НаборЗаписей.Получить(0);
			Запись.Шаблон = Шаблон;
			
		КонецЕсли;
		
		НаборЗаписей.Записать();
		ОбновитьПовторноИспользуемыеЗначения();
		
	КонецЦикла;
	
КонецПроцедуры

Функция НаименованиеНезаполненногоШаблона() Экспорт
	
	Возврат НСтр("ru='<пустой>'");
	
КонецФункции

Процедура НаборыДополнительныхРеквизитовИСведенийПриЗаписи(Объект, Отказ) Экспорт
	
	Если Объект.ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
		
	Если Объект.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Предопределенный Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ШаблоныНаименований.Ссылка
	|ИЗ
	|	Справочник.ШаблоныНаименований КАК ШаблоныНаименований
	|ГДЕ
	|	ШаблоныНаименований.ЭтоПредопределенный
	|	И ШаблоныНаименований.НаборСвойств = &НаборСвойств";
	
	Запрос.УстановитьПараметр("НаборСвойств", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() <> 0 Тогда
		
		// Редактируем имеющиеся предопределенные шаблоны.
		
		Пока Выборка.Следующий() Цикл
			
			Шаблон = Выборка.Ссылка.ПолучитьОбъект();
			
			СФормироватьШаблон(Шаблон, Объект);
			СформироватьНаименованиеШаблона(Шаблон);
			Шаблон.Записать();
			
		КонецЦикла;
		
	Иначе
		
		// Создаем новые предопределенные шаблоны.
		ЗапросКатегории = Новый Запрос;
		ЗапросКатегории.Текст = 
		"ВЫБРАТЬ
		|	КатегорииНоменклатуры.Ссылка,
		|	КатегорииНоменклатуры.НаборСвойств,
		|	КатегорииНоменклатуры.НаборСвойствХарактеристики
		|ИЗ
		|	Справочник.КатегорииНоменклатуры КАК КатегорииНоменклатуры
		|ГДЕ
		|	КатегорииНоменклатуры.НаборСвойств = &НаборСвойств
		|	ИЛИ КатегорииНоменклатуры.НаборСвойствХарактеристики = &НаборСвойств";
		
		ЗапросКатегории.УстановитьПараметр("НаборСвойств", Объект.Ссылка);
		
		ВыборкаКатегории = ЗапросКатегории.Выполнить().Выбрать();
		Пока ВыборкаКатегории.Следующий() Цикл
			
			ДляХарактеристики = ВыборкаКатегории.НаборСвойств <> Объект.Ссылка 
								И ВыборкаКатегории.НаборСвойствХарактеристики = Объект.Ссылка;
			СоздатьШаблоныПоУмолчаниюДляНабораСвойств(ВыборкаКатегории.Ссылка, Объект.Ссылка, ДляХарактеристики);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

Функция ЗаполнитьСписокСвойствОбъекта(Форма, ПриСозданииНаСервере = Ложь) Экспорт
	
	Форма.ШаблоныНаименованийНастройки.СписокСвойств.Очистить();
	
	Если ТипЗнч(Форма.Объект.Ссылка) = Тип("СправочникСсылка.Номенклатура") Тогда
		ЗаполнитьСписокСвойствОбъектаНоменклатура(Форма, Форма.ШаблоныНаименованийНастройки.СписокСвойств, ПриСозданииНаСервере);
	ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("СправочникСсылка.ХарактеристикиНоменклатуры") Тогда
		ЗаполнитьСписокСвойствОбъектаХарактеристика(Форма, Форма.ШаблоныНаименованийНастройки.СписокСвойств);
	КонецЕсли;
	
КонецФункции

Функция ОбработатьРезультатВыбора(РезультатЗначение, РезультатПредставление) Экспорт
	
	ВыбранноеЗначение = Новый Структура;
	ВыбранноеЗначение.Вставить("ШаблонСсылка", РезультатЗначение);
	ВыбранноеЗначение.Вставить("Наименование", РезультатПредставление);
	ВыбранноеЗначение.Вставить("ШаблонДляФормирования", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РезультатЗначение, "ШаблонДляФормирования"));
	
	Возврат ВыбранноеЗначение;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСписокСвойствОбъектаНоменклатура(Форма, СписокСвойств, ПриСозданииНаСервере)
	
	Объект = Форма.Объект;
	
	Если ПриСозданииНаСервере И Форма.Параметры.Свойство("ТекстЗаполнения") Тогда
		СписокСвойств.Добавить("Наименование", Форма.Параметры.ТекстЗаполнения);
	Иначе
		СписокСвойств.Добавить("Наименование", Объект.Наименование);
	КонецЕсли;
	СписокСвойств.Добавить("Артикул", Объект.Артикул);
	СписокСвойств.Добавить("Код", Объект.Код);
	СписокСвойств.Добавить("СтранаПроисхождения", Объект.СтранаПроисхождения);
	СписокСвойств.Добавить("Поставщик", Объект.Поставщик);
	
	Если НЕ Форма.Свойства_ИспользоватьСвойства
		ИЛИ НЕ Форма.Свойства_ИспользоватьДопРеквизиты Тогда
		
		Возврат;
	КонецЕсли;
	
	Для каждого Свойство Из Форма.Свойства_ОписаниеДополнительныхРеквизитов Цикл
		
		НаименованиеСвойства = Строка(Свойство.Свойство);
		ЗначениеСвойства     = "";
		
		Если ЗначениеЗаполнено(Свойство.ИмяРеквизитаЗначение) Тогда
			ЗначениеСвойства = Форма[Свойство.ИмяРеквизитаЗначение];
		КонецЕсли;
		
		Если ТипЗнч(ЗначениеСвойства) = Тип("Булево") Тогда
			ЗначениеСвойства = ?(ЗначениеСвойства = Истина, Свойство.Наименование, "");
		ИначеЕсли НЕ ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЗначениеСвойства = "";
		КонецЕсли;
		
		СписокСвойств.Добавить(НаименованиеСвойства, ЗначениеСвойства);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСписокСвойствОбъектаХарактеристика(Форма, СписокСвойств)
	
	СписокСвойств.Добавить("Наименование", Форма.Объект.Наименование);
	
	Для каждого Свойство Из Форма.Свойства_ТаблицаСвойстваИЗначения Цикл
		
		НаименованиеСвойства = Строка(Свойство.Свойство);
		ЗначениеСвойства     = Свойство.Значение;
		
		Если ТипЗнч(ЗначениеСвойства) = Тип("Булево") Тогда
			ЗначениеСвойства = ?(ЗначениеСвойства = Истина, Свойство.Наименование, "");
		КонецЕсли;
		
		СписокСвойств.Добавить(НаименованиеСвойства, ЗначениеСвойства);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьИнформациюОШаблонеВНастройкиФормы(Форма, Шаблон, ВидНаименования)
	
	НоваяСтрока = Форма.ШаблоныНаименованийКэш.Добавить();
	НоваяСтрока.ШаблонСсылка          = Шаблон;
	НоваяСтрока.ШаблонДляФормирования = Шаблон.ШаблонДляФормирования;
	НоваяСтрока.ВидНаименования       = ВидНаименования;
	
КонецПроцедуры

Процедура СФормироватьШаблон(ШаблонОбъект, НаборСвойств)
	
	ВидНаименования = ШаблонОбъект.ВидНаименования;
	
	ШаблонОбъект.ШаблонДляПредставления = "";
	ШаблонОбъект.ШаблонДляФормирования = "";
	
	Для каждого Эл Из НаборСвойств.ДополнительныеРеквизиты Цикл
		
		Если Эл.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВидНаименования = Перечисления.ВидыНаименованийОбъектов.НоменклатураРабочее
			ИЛИ ВидНаименования = Перечисления.ВидыНаименованийОбъектов.ХарактеристикаРабочее Тогда
			
			Заголовок = "";
		Иначе
			
			ЭтоБулевскийРеквизит = ОбщегоНазначения.ОписаниеТипаСостоитИзТипа(Эл.Свойство.ТипЗначения, Тип("Булево"));
			
			Если ЭтоБулевскийРеквизит Тогда
				Заголовок = "";
			Иначе
				Заголовок = Эл.Свойство.Заголовок + " ";
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ШаблонОбъект.ШаблонДляПредставления) Тогда
			Разделитель = ", ";
		Иначе
			Разделитель = "";
		КонецЕсли;
		
		ПараметрПредставление = "[" + Эл.Свойство.Заголовок + "]";
		ПараметрФормирование  = "[" + Эл.Свойство.Наименование + "]";
		
		НовыйБлок = "{%1%2%3}";
		НовыйБлокПредставление = СтрШаблон(НовыйБлок, Разделитель, Заголовок, ПараметрПредставление);
		НовыйБлокФормирование  = СтрШаблон(НовыйБлок, Разделитель, Заголовок, ПараметрФормирование);
		
		ШаблонОбъект.ШаблонДляПредставления = ШаблонОбъект.ШаблонДляПредставления + НовыйБлокПредставление;
		ШаблонОбъект.ШаблонДляФормирования  = ШаблонОбъект.ШаблонДляФормирования + НовыйБлокФормирование;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ВыбратьШаблонНаименования(Шаблоны, КатегорияНоменклатуры, ВидНаименования)
	
	Шаблон = ШаблоныНаименованийПовтИсп.ПолучитьШаблонДляВидаНаименования(КатегорияНоменклатуры, ВидНаименования);
	
	Если ЗначениеЗаполнено(Шаблон) Тогда
		Возврат Шаблон;
	КонецЕсли;
	
	ИскомаяСтрока = Шаблоны.Найти(ВидНаименования, "ВидНаименования");
	Если ИскомаяСтрока <> Неопределено Тогда
		Шаблон = ИскомаяСтрока.Ссылка;
		Возврат Шаблон;
	КонецЕсли;
	
	Если Шаблоны.Количество() <> 0 Тогда
		Шаблон = Шаблоны[0].Ссылка;
		Возврат Шаблон;
	КонецЕсли;
	
КонецФункции

Функция УжеЕстьТакоеНаименование(СписокНаименований, НовоеНаименование)
	
	Для каждого Эл Из СписокНаименований Цикл
		
		Если Эл.Представление = НовоеНаименование Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

