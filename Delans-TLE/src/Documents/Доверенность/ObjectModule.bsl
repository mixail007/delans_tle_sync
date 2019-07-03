#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыЗаполнения

Процедура ЗаполнитьПоЗаказуПоставщику(ДанныеЗаполнения) Экспорт
	
	ЭтотОбъект.ДокументОснование = ДанныеЗаполнения.Ссылка;
	Организация = ДанныеЗаполнения.Организация;
	Контрагент = ДанныеЗаполнения.Контрагент;
	НаПолучениеОт = ?(ЗначениеЗаполнено(Контрагент.НаименованиеПолное), Контрагент.НаименованиеПолное, Контрагент.Наименование);
	Договор = ДанныеЗаполнения.Договор;
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения.Ссылка)
		И НЕ (ПустаяСтрока(ДанныеЗаполнения.Ссылка.НомерВходящегоДокумента)
				ИЛИ ПустаяСтрока(ДанныеЗаполнения.Ссылка.ДатаВходящегоДокумента)) Тогда
		
		ПоДокументу = НСтр("ru ='Счет на оплату покупателя №'") + СокрЛП(ДанныеЗаполнения.Ссылка.НомерВходящегоДокумента) + НСтр("ru =' от '") + СокрЛП(ДанныеЗаполнения.Ссылка.ДатаВходящегоДокумента);
		
	Иначе
		
		ПоДокументу = ДанныеЗаполнения.Ссылка;
		
	КонецЕсли;
	
	НаПолучениеОт = ДанныеЗаполнения.Контрагент.НаименованиеПолное;
	БанковскийСчет = ДанныеЗаполнения.Организация.БанковскийСчетПоУмолчанию;
	ДатаДействия = ТекущаяДата() + 5 * 24 * 60 * 60;
	
	// Заполнение табличной части документа.
	Запасы.Очистить();
	
	Для каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Запасы Цикл
		
		Если СтрокаТабличнойЧасти.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас
			Или СтрокаТабличнойЧасти.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат
		Тогда
			
			НоваяСтрока = Запасы.Добавить();
			НоваяСтрока.НаименованиеТовара = СтрокаТабличнойЧасти.Номенклатура.НаименованиеПолное;
			НоваяСтрока.ЕдиницаИзмерения = СтрокаТабличнойЧасти.ЕдиницаИзмерения;
			НоваяСтрока.Количество = СтрокаТабличнойЧасти.Количество;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПоСчетуНаОплатуПоставщика(ДанныеЗаполнения) Экспорт
	
	ЭтотОбъект.ДокументОснование = ДанныеЗаполнения.Ссылка;
	Организация = ДанныеЗаполнения.Организация;
	Контрагент = ДанныеЗаполнения.Контрагент;
	НаПолучениеОт = ?(ЗначениеЗаполнено(Контрагент.НаименованиеПолное), Контрагент.НаименованиеПолное, Контрагент.Наименование);
	Договор = ДанныеЗаполнения.Договор;
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения.Ссылка)
		И НЕ (ПустаяСтрока(ДанныеЗаполнения.Ссылка.НомерВходящегоДокумента)
				ИЛИ ПустаяСтрока(ДанныеЗаполнения.Ссылка.ДатаВходящегоДокумента)) Тогда
		
		ПоДокументу = НСтр("ru ='Счет на оплату покупателя №'") + СокрЛП(ДанныеЗаполнения.Ссылка.НомерВходящегоДокумента) + НСтр("ru =' от '") + СокрЛП(ДанныеЗаполнения.Ссылка.ДатаВходящегоДокумента);
		
	Иначе
		
		ПоДокументу = ДанныеЗаполнения.Ссылка;
		
	КонецЕсли;
	
	НаПолучениеОт = ДанныеЗаполнения.Контрагент.НаименованиеПолное;
	БанковскийСчет = ДанныеЗаполнения.Организация.БанковскийСчетПоУмолчанию;
	ДатаДействия = ТекущаяДата() + 5 * 24 * 60 * 60;
	
	// Заполнение табличной части документа.
	Запасы.Очистить();
	
	Для каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Запасы Цикл
		
		Если СтрокаТабличнойЧасти.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас Тогда
			
			НоваяСтрока = Запасы.Добавить();
			НоваяСтрока.НаименованиеТовара = СтрокаТабличнойЧасти.Номенклатура.НаименованиеПолное;
			НоваяСтрока.ЕдиницаИзмерения = СтрокаТабличнойЧасти.ЕдиницаИзмерения;
			НоваяСтрока.Количество = СтрокаТабличнойЧасти.Количество;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
	
	
#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ДатаДействия = ТекущаяДатаСеанса() + 10 * (24 * 60 * 60);
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ЗаказПоставщику")] = "ЗаполнитьПоЗаказуПоставщику";
	СтратегияЗаполнения[Тип("ДокументСсылка.СчетНаОплатуПоставщика")] = "ЗаполнитьПоСчетуНаОплатуПоставщика";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент)
	И НЕ Контрагент.ВестиРасчетыПоДоговорам
	И НЕ ЗначениеЗаполнено(Договор) Тогда
		Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(Контрагент);
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ Контрагент.ВестиРасчетыПоДоговорам Тогда
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Договор");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли