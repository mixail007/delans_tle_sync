#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.ПоказыватьНастройкиДиаграммыНаФормеОтчета = Ложь;
	НастройкиОтчета.ИспользоватьСравнение = Истина;
	НастройкиОтчета.ИспользоватьПериодичность = Истина;
	НастройкиОтчета.Вставить("РежимПериода", "ЗаПериод");
	
	НастройкиВариантов["Основной"].Теги = НСтр("ru = 'Продажи,Биллинг,Регулярные услуги'");
	НастройкиВариантов["Основной"].Рекомендуемый = Истина;
	НастройкиВариантов["Основной"].ФункциональнаяОпция = "ИспользоватьБиллинг";
	
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
	Если Константы.БиллингВестиУчетРасходовПоДоговорамОбслуживания.Получить() Тогда
		ВыбранноеПолеКД = КомпоновщикНастроек.Настройки.Выбор.Элементы.Вставить(0, Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПолеКД.Поле = Новый ПолеКомпоновкиДанных("СуммаРасходы");
		ВыбранноеПолеКД.Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка) Экспорт
	
	ДоговорыОбслуживания = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДоговорыКонтрагентов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.ЭтоДоговорОбслуживания
	|	И НЕ ДоговорыКонтрагентов.ПометкаУдаления";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДоговорыОбслуживания.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	ОтчетыУНФ.УстановитьПараметрОтчетаПоУмолчанию(КомпоновщикНастроек.Настройки, "ВалютаУчета", УправлениеНебольшойФирмойПовтИсп.ПолучитьВалютуУчета());
	ОтчетыУНФ.УстановитьПараметрОтчетаПоУмолчанию(КомпоновщикНастроек.Настройки, "ДоговорыОбслуживания", ДоговорыОбслуживания);
	ОтчетыУНФ.ДобавитьСимволВалютыКЗаголовкамПолей(СхемаКомпоновкиДанных, "СуммаРасходы,СуммаВыставлено,УвДолгаКонтрагентаВал,УмДолгаКонтрагентаВал");
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	СтруктураВарианта = НастройкиВариантов["Основной"];
	ОтчетыУНФ.ДобавитьОписаниеПривязки(СтруктураВарианта.СвязанныеПоля, "ДоговорОбслуживания", "Справочник.ДоговорыКонтрагентов",,, Истина);
	ОтчетыУНФ.ДобавитьОписаниеПривязки(СтруктураВарианта.СвязанныеПоля, "Контрагент", "Справочник.Контрагенты",,, Истина);
	
КонецПроцедуры

Функция НайтиГруппировкуПоПолюКомпоновкиДанныхРекурсивно(КоллекцияЭлементовСтруктурыНастроекКД, ПолеКД)
	
	Для каждого ГруппировкаКД Из КоллекцияЭлементовСтруктурыНастроекКД Цикл
		Для каждого ПолеГруппировкиКД Из ГруппировкаКД.ПоляГруппировки.Элементы Цикл
			Если ПолеГруппировкиКД.Поле = ПолеКД Тогда
				Возврат ГруппировкаКД;
			КонецЕсли;
		КонецЦикла;
		НайденнаяГруппировкаКД = НайтиГруппировкуПоПолюКомпоновкиДанныхРекурсивно(ГруппировкаКД.Структура, ПолеКД);
		Если НайденнаяГруппировкаКД <> Неопределено Тогда
			Возврат НайденнаяГруппировкаКД;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

ЭтоОтчетУНФ = Истина;

#КонецЕсли