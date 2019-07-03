
Процедура УстановитьКартинкуДляКнопки(ЭлементКнопка, УстановитьКартинку) Экспорт
	
	Если УстановитьКартинку Тогда
		ЭлементКнопка.Картинка = БиблиотекаКартинок.Успешно32;
	Иначе
		ЭлементКнопка.Картинка = Новый Картинка;
	КонецЕсли;
	
КонецПроцедуры

//услуга НП
&НаСервере
Процедура ДобавитьУслугуПроцентОтНП(ЭтотОбъект) Экспорт
	// EFSOL Шаповал О. А. 11.11.2015  +
	ПроцентНП = ЭтотОбъект.Контрагент.ES_ПроцентОтНП;
	Если НЕ ПроцентНП > 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.ES_НППлан = 0 Тогда
		Возврат;
	КонецЕсли;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ES_СтартовыеНастройки.Значение КАК Услуга,
	               |	ES_СтартовыеНастройки.Пользователь,
	               |	ES_СтартовыеНастройки.ВидСтартовойНастройки
	               |ИЗ
	               |	РегистрСведений.ES_СтартовыеНастройки КАК ES_СтартовыеНастройки
	               |ГДЕ
	               |	ES_СтартовыеНастройки.ВидСтартовойНастройки = ЗНАЧЕНИЕ(Перечисление.ES_ВидыСтартовыхНастроек.УслугаРКО)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		УслугаРКО = Выборка.Услуга;
		
		Сумма = ЭтотОбъект.ES_НППлан;
		
		Запасы = ЭтотОбъект.Запасы; 
		мСтрока = Запасы.Найти(УслугаРКО,"Номенклатура");
		
		Если мСтрока = Неопределено Тогда
			// добавляем
			НоваяСтрока = Запасы.Добавить();
			НоваяСтрока.Номенклатура = УслугаРКО;
			НоваяСтрока.Количество = 1;
			НоваяСтрока.ЕдиницаИзмерения = УслугаРКО.ЕдиницаИзмерения;
			НоваяСтрока.ДатаОтгрузки = ЭтотОбъект.Дата;
			НоваяСтрока.СтавкаНДС = УслугаРКО.СтавкаНДС;
			НоваяСтрока.Цена = Сумма * ПроцентНП / 100;
			НоваяСтрока.Сумма = НоваяСтрока.Цена;
			НоваяСтрока.Всего = НоваяСтрока.Цена;
		Иначе
			//корректируем
			//СуммаНПБезУслуги = Сумма - мСтрока.Сумма;
			мСтрока.СтавкаНДС = УслугаРКО.СтавкаНДС;
			мСтрока.Цена = Сумма * ПроцентНП / 100;
			мСтрока.Сумма = мСтрока.Цена;
			мСтрока.Всего = мСтрока.Цена;
		КонецЕсли;
		
	КонецЕсли;
	// EFSOL Шаповал О. А. 11.11.2015  -	
КонецПроцедуры

&НаСервере
Функция ЭР_ОбновитьСтоимостьДоставки (Дата, Знач Договор, ЗонаДоставки, Вес, СрочностьДоставки, ВидДоставки,ВидКонтрагента) Экспорт
	//EFSOL_Шаповал Олег Анатольевич 16 марта 2017 г. 11:36:46 +
	//мВес = ЭтотОбъект.ES_ОбщийВес;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Цена",0);
	//Возврат СтруктураВозврата;
	
	Если НЕ Договор.ES_УчетПриРасчетеЦенТК Тогда
		Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		//"ВЫБРАТЬ
		//|	ES_ЦеныДоставкиСрезПоследних.Договор КАК Договор,
		//|	ES_ЦеныДоставкиСрезПоследних.Тариф КАК Тариф,
		//|	ES_ЦеныДоставкиСрезПоследних.Зона КАК Зона,
		//|	ES_ЦеныДоставкиСрезПоследних.Вес,
		//|	ES_ЦеныДоставкиСрезПоследних.ЗаКаждый,
		//|	ES_ЦеныДоставкиСрезПоследних.Цена,
		//|	ES_ЦеныДоставкиСрезПоследних.ВидДоставки,
		//|	ES_ЦеныДоставкиСрезПоследних.ВидКонтрагента
		//|ПОМЕСТИТЬ ОбщиеЦены
		//|ИЗ
		//|	РегистрСведений.ES_ЦеныДоставки.СрезПоследних(
		//|			&Дата,
		//|			Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
		//|				И Зона = &Зона
		//|				И Тариф = &Срочность
		//|				И ВидДоставки = &ВидДоставки
		//|				И ВидКонтрагента = &ВидКонтрагента) КАК ES_ЦеныДоставкиСрезПоследних
		//|;
		//|
		//|////////////////////////////////////////////////////////////////////////////////
		//|ВЫБРАТЬ
		//|	ES_ЦеныДоставкиСрезПоследних.Договор КАК Договор,
		//|	ES_ЦеныДоставкиСрезПоследних.Тариф КАК Тариф,
		//|	ES_ЦеныДоставкиСрезПоследних.Зона КАК Зона,
		//|	ES_ЦеныДоставкиСрезПоследних.Вес,
		//|	ES_ЦеныДоставкиСрезПоследних.ЗаКаждый,
		//|	ES_ЦеныДоставкиСрезПоследних.Цена,
		//|	ES_ЦеныДоставкиСрезПоследних.ВидДоставки,
		//|	ES_ЦеныДоставкиСрезПоследних.ВидКонтрагента
		//|ПОМЕСТИТЬ ЦеныКлиента
		//|ИЗ
		//|	РегистрСведений.ES_ЦеныДоставки.СрезПоследних(
		//|			&Дата,
		//|			Договор = &Договор
		//|				И Зона = &Зона
		//|				И Тариф = &Срочность
		//|				И ВидДоставки = &ВидДоставки
		//|				И ВидКонтрагента = &ВидКонтрагента) КАК ES_ЦеныДоставкиСрезПоследних
		//|ГДЕ
		//|	&ICN
		//|;
		//|
		//|////////////////////////////////////////////////////////////////////////////////
		//|ВЫБРАТЬ
		//|	ЕСТЬNULL(ЦеныКлиента.Договор, ОбщиеЦены.Договор) КАК Договор,
		//|	ЕСТЬNULL(ЦеныКлиента.Тариф, ОбщиеЦены.Тариф) КАК Продукт,
		//|	ЕСТЬNULL(ЦеныКлиента.Зона, ОбщиеЦены.Зона) КАК Зона,
		//|	ЕСТЬNULL(ЦеныКлиента.Вес, ОбщиеЦены.Вес) КАК Вес,
		//|	ЕСТЬNULL(ЦеныКлиента.ЗаКаждый, ОбщиеЦены.ЗаКаждый) КАК Каждый,
		//|	ЕСТЬNULL(ЦеныКлиента.Цена, ОбщиеЦены.Цена) КАК Цена,
		//|	ЕСТЬNULL(ЦеныКлиента.ВидДоставки, ОбщиеЦены.ВидДоставки) КАК ВидДоставки,
		//|	ЕСТЬNULL(ЦеныКлиента.ВидКонтрагента, ОбщиеЦены.ВидКонтрагента) КАК ВидКонтрагента
		//|ПОМЕСТИТЬ Итог
		//|ИЗ
		//|	ОбщиеЦены КАК ОбщиеЦены
		//|		ПОЛНОЕ СОЕДИНЕНИЕ ЦеныКлиента КАК ЦеныКлиента
		//|		ПО ОбщиеЦены.Тариф = ЦеныКлиента.Тариф
		//|			И ОбщиеЦены.Зона = ЦеныКлиента.Зона
		//|			И ОбщиеЦены.Вес = ЦеныКлиента.Вес
		//|;
		//|
		//|////////////////////////////////////////////////////////////////////////////////
		//|ВЫБРАТЬ
		//|	ES_Вес.Ссылка
		//|ПОМЕСТИТЬ ВТ_Вес
		//|ИЗ
		//|	Справочник.ES_Вес КАК ES_Вес
		//|ГДЕ
		//|	ES_Вес.ВесОт <= &Вес
		//|	И ES_Вес.ВесДо >= &Вес
		//|	И НЕ ES_Вес.ЗаКаждые
		//|;
		//|
		//|////////////////////////////////////////////////////////////////////////////////
		//|ВЫБРАТЬ ПЕРВЫЕ 1
		//|	ЕСТЬNULL(Итог.Цена, 0) КАК Цена,
		//|	Итог.Вес.ЗаКаждые КАК ВесЗаКаждый,
		//|	Итог.Вес.ВесОт КАК ВесВесОт,
		//|	Итог.Вес.ВесДо КАК ВесВесДо,
		//|	ВЫБОР
		//|		КОГДА &Вес - Итог.Вес.ВесДо < 0
		//|			ТОГДА 0
		//|		ИНАЧЕ &Вес - Итог.Вес.ВесДо
		//|	КОНЕЦ КАК дельта
		//|ИЗ
		//|	Итог КАК Итог
		//|ГДЕ
		//|	Итог.Вес.ВесОт <= &Вес
		//|	И НЕ Итог.Вес.ЗаКаждые
		//|
		//|УПОРЯДОЧИТЬ ПО
		//|	Итог.Вес.ВесОт УБЫВ
		//|;
		//|
		//|////////////////////////////////////////////////////////////////////////////////
		//|ВЫБРАТЬ
		//|	ES_Вес.Ссылка
		//|ПОМЕСТИТЬ ВТ_Вес_каждый
		//|ИЗ
		//|	Справочник.ES_Вес КАК ES_Вес
		//|ГДЕ
		//|	ES_Вес.ВесОт <= &Вес
		//|	И ES_Вес.ВесДо >= &Вес
		//|	И ES_Вес.ЗаКаждые
		//|;
		//|
		//|////////////////////////////////////////////////////////////////////////////////
		//|ВЫБРАТЬ ПЕРВЫЕ 1
		//|	СУММА(ЕСТЬNULL(Итог.Цена, 0)) КАК ЦенаКаждый,
		//|	МАКСИМУМ(Итог.Вес.ЗаКаждые) КАК ВесЗаКаждые,
		//|	СУММА(Итог.Вес.Интервал) КАК ИнтервалЗаКаждый,
		//|	(&Вес - Итог.Вес.ВесОт) / ВЫБОР
		//|		КОГДА ЕСТЬNULL(Итог.Вес.Интервал, 0) = 0
		//|			ТОГДА 1
		//|		ИНАЧЕ Итог.Вес.Интервал
		//|	КОНЕЦ КАК Количество
		//|ИЗ
		//|	Итог КАК Итог
		//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Вес_каждый КАК ВТ_Вес_каждый
		//|		ПО Итог.Вес = ВТ_Вес_каждый.Ссылка
		//|ГДЕ
		//|	Итог.Вес.ЗаКаждые
		//|
		//|СГРУППИРОВАТЬ ПО
		//|	(&Вес - Итог.Вес.ВесОт) / ВЫБОР
		//|		КОГДА ЕСТЬNULL(Итог.Вес.Интервал, 0) = 0
		//|			ТОГДА 1
		//|		ИНАЧЕ Итог.Вес.Интервал
		//|	КОНЕЦ";
		"ВЫБРАТЬ
		|	ES_ЦеныДоставкиСрезПоследних.Вес,
		|	ES_ЦеныДоставкиСрезПоследних.ЗаКаждый,
		|	ES_ЦеныДоставкиСрезПоследних.Цена
		|ПОМЕСТИТЬ ОбщиеЦены
		|ИЗ
		|	РегистрСведений.ES_ЦеныДоставки.СрезПоследних(
		|			&Дата,
		|			Договор = &Договор
		|				И Зона = &Зона
		|				И Тариф = &Срочность
		|				И ВидДоставки = &ВидДоставки
		|				И ВидКонтрагента = &ВидКонтрагента) КАК ES_ЦеныДоставкиСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОбщиеЦены.Вес,
		|	ОбщиеЦены.ЗаКаждый,
		|	ОбщиеЦены.Цена,
		|	&Вес - ОбщиеЦены.Вес.ВесДо КАК Дельта
		|ИЗ
		|	ОбщиеЦены КАК ОбщиеЦены
		|ГДЕ
		|	НЕ ОбщиеЦены.ЗаКаждый
		|	И ОбщиеЦены.Вес.ВесОт <= &Вес
		|
		|УПОРЯДОЧИТЬ ПО
		|	ОбщиеЦены.Вес.ВесДо УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОбщиеЦены.Вес,
		|	ОбщиеЦены.ЗаКаждый,
		|	ОбщиеЦены.Цена,
		|	ОбщиеЦены.Вес.Интервал,
		|	ОбщиеЦены.Вес.ВесОт
		|ИЗ
		|	ОбщиеЦены КАК ОбщиеЦены
		|ГДЕ
		|	ОбщиеЦены.ЗаКаждый
		|	И ОбщиеЦены.Вес.ВесОт < &Вес
		|	И ОбщиеЦены.Вес.ВесДо > &Вес";
	
	
	Запрос.УстановитьПараметр("Дата",Новый Граница(Дата,ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Зона",ЗонаДоставки);
	Запрос.УстановитьПараметр("Срочность",СрочностьДоставки);
	Запрос.УстановитьПараметр("Вес",Вес);	
	Запрос.УстановитьПараметр("ВидДоставки",ВидДоставки);
	Запрос.УстановитьПараметр("ВидКонтрагента",ВидКонтрагента);
	//УчетПриРасчетеЦенТК = Справочники.ДоговорыКонтрагентов.НайтиПоРеквизиту("ES_УчетПриРасчетеЦенТК", Истина).ES_УчетПриРасчетеЦенТК;
	Запрос.УстановитьПараметр("Договор", Договор);
	//Если Договор.Пустая() Тогда
	//	Запрос.УстановитьПараметр("ICN", Ложь);
	//Иначе
	//	Запрос.УстановитьПараметр("ICN", Истина);
	//КонецЕсли;
	
	//Запрос.УстановитьПараметр("Заказчик", ЭтотОбъект.Контрагент);	
	
	
	//СтруктураВозврата.Вставить("Срок",0);
	   	
	Пакеты = Запрос.ВыполнитьПакет();
		
	
	ВыборкаПакет1 = Пакеты[1].Выбрать();
	БазоваяЦена = 0;
	Дельта = 0;
	//вес попал в интервал
	Пока ВыборкаПакет1.Следующий() Цикл
		//Если ВыборкаПакет1.ЗаКаждый = Ложь Тогда
		//	СтруктураВозврата.Вставить("Цена",ВыборкаПакет1.Цена);
		//	СтруктураВозврата.Вставить("Срок",0);
		//КонецЕсли;
		БазоваяЦена = ВыборкаПакет1.Цена;
		Дельта = Окр(ВыборкаПакет1.Дельта,0,РежимОкругления.Окр15как20);
		
	КонецЦикла; 	
	
	ВыборкаПакет2 = Пакеты[2].Выбрать(); 
	СтоимостьЗАКаждый = 0;
	Интервал = 1;
	
	Пока ВыборкаПакет2.Следующий() Цикл
	// необходимо начислять стоимость за каждый N веса 
		//Если ВыборкаПакет2.ВесЗаКаждые = Истина Тогда   			
		//	СтруктураВозврата.Цена = ВыборкаПакет2.ЦенаКаждый + ВыборкаПакет2.ЦенаКаждый * Окр(ВыборкаПакет2.Количество,0,РежимОкругления.Окр15как20);	
		//	СтруктураВозврата.Вставить("Срок",0);
		//КонецЕсли;
		Интервал = ВыборкаПакет2.ВесИнтервал;
		СтоимостьЗаКаждый = ВыборкаПакет2.Цена;
	КонецЦикла;
	
	//Цена = 0;
	Если БазоваяЦена > 0 Тогда
		СтруктураВозврата.Цена = БазоваяЦена + Окр(Дельта/Интервал,0,РежимОкругления.Окр15как20) * СтоимостьЗаКаждый;
		//СтруктураВозврата.Вставить("Срок",0);
	КонецЕсли;
	
	Если СтруктураВозврата.Цена = 0 И НЕ Договор.Пустая() Тогда
		СтруктураВозврата = ЭР_ОбновитьСтоимостьДоставки (Дата, Справочники.ДоговорыКонтрагентов.ПустаяСсылка(), ЗонаДоставки, Вес, СрочностьДоставки, ВидДоставки,ВидКонтрагента);
	КонецЕсли;
	Возврат СтруктураВозврата;
	  		
	
	
	//EFSOL Сережко А.С. +
	
КонецФункции

&НаСервере

Функция ЭР_ОбновитьУслугиТЧДоставки (ТЗНоменклатура,Дата,Договор,СтоимостьДоставки =0, ОценочнаяСтоимость = 0,СуммаНП = 0, Вес = 0) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ES_ЦеныДоставкиДопУслугиСрезПоследних.Цена) КАК Цена,
		|	ES_ЦеныДоставкиДопУслугиСрезПоследних.Номенклатура,
		|	ES_ЦеныДоставкиДопУслугиСрезПоследних.ЦенаЗаКаждыйКилограмм
		|ПОМЕСТИТЬ ВТ_УслугиРозница
		|ИЗ
		|	РегистрСведений.ES_ЦеныДоставкиДопУслуги.СрезПоследних(
		|			&Период,
		|			Номенклатура В (&Номенклатура)
		|				И Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)) КАК ES_ЦеныДоставкиДопУслугиСрезПоследних
		|
		|СГРУППИРОВАТЬ ПО
		|	ES_ЦеныДоставкиДопУслугиСрезПоследних.Номенклатура,
		|	ES_ЦеныДоставкиДопУслугиСрезПоследних.ЦенаЗаКаждыйКилограмм
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(ES_ЦеныДоставкиДопУслугиСрезПоследних.Цена) КАК Цена,
		|	ES_ЦеныДоставкиДопУслугиСрезПоследних.Номенклатура,
		|	ES_ЦеныДоставкиДопУслугиСрезПоследних.ЦенаЗаКаждыйКилограмм
		|ПОМЕСТИТЬ ВТ_УслугиИКН
		|ИЗ
		|	РегистрСведений.ES_ЦеныДоставкиДопУслуги.СрезПоследних(
		|			&Период,
		|			Номенклатура В (&Номенклатура)
		|				И Договор = &Договор) КАК ES_ЦеныДоставкиДопУслугиСрезПоследних
		|ГДЕ
		|	&ICN
		|
		|СГРУППИРОВАТЬ ПО
		|	ES_ЦеныДоставкиДопУслугиСрезПоследних.Номенклатура,
		|	ES_ЦеныДоставкиДопУслугиСрезПоследних.ЦенаЗаКаждыйКилограмм
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(ЕСТЬNULL(ВТ_УслугиИКН.Цена, ВТ_УслугиРозница.Цена)) КАК Цена,
		|	ЕСТЬNULL(ВТ_УслугиИКН.Номенклатура, ВТ_УслугиРозница.Номенклатура) КАК Номенклатура,
		|	ЕСТЬNULL(ВТ_УслугиИКН.ЦенаЗаКаждыйКилограмм, ВТ_УслугиРозница.ЦенаЗаКаждыйКилограмм) КАК ЦенаЗаКаждыйКилограмм
		|ПОМЕСТИТЬ Итоговая
		|ИЗ
		|	ВТ_УслугиИКН КАК ВТ_УслугиИКН
		|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_УслугиРозница КАК ВТ_УслугиРозница
		|		ПО (ВТ_УслугиРозница.Номенклатура = ВТ_УслугиИКН.Номенклатура)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЕСТЬNULL(ВТ_УслугиИКН.Номенклатура, ВТ_УслугиРозница.Номенклатура),
		|	ЕСТЬNULL(ВТ_УслугиИКН.ЦенаЗаКаждыйКилограмм, ВТ_УслугиРозница.ЦенаЗаКаждыйКилограмм)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Итоговая.Номенклатура,
		|	ЕСТЬNULL(Итоговая.Цена, 0) КАК Цена,
		|	Итоговая.ЦенаЗаКаждыйКилограмм
		|ИЗ
		|	Итоговая КАК Итоговая";
	
	Запрос.УстановитьПараметр("Период",Новый Граница(Дата,ВидГраницы.Включая));
	//Запрос.УстановитьПараметр("Зона",ЭтотОбъект.ES_ЗонаДоставки);
	//Запрос.УстановитьПараметр("Срочность",СрочностьДоставки);
	//Запрос.УстановитьПараметр("ВидДоставки",ВидДоставки);
	Запрос.УстановитьПараметр("ICN",?(Договор.Пустая(),Ложь,Истина));	
	Запрос.УстановитьПараметр("Договор", Договор);	
	//Запрос.УстановитьПараметр("ВидКонтрагента", ВидКонтрагента);
	Запрос.УстановитьПараметр("Номенклатура", ТЗНоменклатура.ВыгрузитьКолонку("Номенклатура"));
	
	ТЗ_Выборка = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СТ_Номенклатура Из ТЗНоменклатура Цикл
		Цена = 0;
		ЦенаЗаКаждыйКг = 0;
		СТ_Поиска = ТЗ_Выборка.Найти(СТ_Номенклатура.Номенклатура,"Номенклатура");
		Если СТ_Поиска = Неопределено Тогда
			//Продолжить;
		Иначе
			Цена = СТ_Поиска.Цена;
			ЦенаЗаКаждыйКг = СТ_Поиска.ЦенаЗаКаждыйКилограмм;
		КонецЕсли;
		
		//проверяем если это услуга расчета по коэф
		Если СТ_Номенклатура.Номенклатура = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Коэф = СТ_Номенклатура.Номенклатура.ES_Коэффициент;
		
		Если Коэф Тогда
			Если СТ_Номенклатура.Номенклатура.Артикул = "1001" Тогда // Наложенный платеж (COD)
				мСтоимость = СуммаНП;
			ИначеЕсли СТ_Номенклатура.Номенклатура.Артикул = "1002" Тогда // Объявленная ценность (Организация страхования)
				мСтоимость = ОценочнаяСтоимость;
			Иначе
				мСтоимость = СтоимостьДоставки;
			КонецЕсли;
			Цена = мСтоимость * (Цена/100);
		КонецЕсли;
		
		// проверяем если интервальный вес
		Интервал = СТ_Номенклатура.Номенклатура.ES_ИспользоватьИнтервалыВеса;
		
		Если Интервал Тогда
			ВесОт = СТ_Номенклатура.Номенклатура.ES_ВесОт;
			ВесДо = СТ_Номенклатура.Номенклатура.ES_ВесДо;
			Если Вес >= ВесОт И Вес <= ВесДо Тогда
				Цена = Цена;
			ИначеЕсли Вес > ВесДо Тогда
				Цена = Цена + Окр((Вес-ВесДо),0,РежимОкругления.Окр15как20) * ЦенаЗаКаждыйКг;
			Иначе
				Цена = 0;
			КонецЕсли;
		КонецЕсли;	
		
		// за хранение. фикса не меняется
		Если СТ_Номенклатура.Номенклатура.Артикул = "1015" Тогда // Дополнительное хранение на складе
			Цена = Цена * Окр(Вес,0,РежимОкругления.Окр15как20);
		КонецЕсли;
				
		СТ_Номенклатура.Цена = Цена;
	КонецЦикла;     	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОбновитьКоординатыМестонахожденияКурьеров() Экспорт
	
	//Запрос = Новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.Курьер КАК Курьер
	//               |ИЗ
	//               |	РегистрСведений.ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров КАК ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров
	//               |
	//               |СГРУППИРОВАТЬ ПО
	//               |	ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.Курьер";
	//
	//Выборка = Запрос.Выполнить().Выбрать();
	//
	//Пока Выборка.Следующий() Цикл
	//	ОтправитьУведомление = Истина;
	//	Уведомление = Новый ДоставляемоеУведомление();
	//	Уведомление.Текст = "Синхронизация";
	//	Уведомление.Данные = "get_courier_coordinates";
	//	Уведомление.Заголовок = "Синхронизация";
	//	ES_РаботаСДоставляемымиУведомлениями.ОтправитьУведомление(Уведомление,Выборка.Курьер);	
	//КонецЦикла;
КонецПроцедуры

Функция ЭтоТестоваяСреда() Экспорт
	
	СтрокаСоединения = Врег(СтрокаСоединенияИнформационнойБазы());	
	ТестоваяСреда = Ложь; 
	Если СтрНайти(СтрокаСоединения, Врег("ef-1c83-d7")) <> 0 ИЛИ СтрНайти(СтрокаСоединения, Врег("d7.efsol.ru")) <> 0
		ИЛИ СтрНайти(СтрокаСоединения, Врег("beta-area-1c-04")) <> 0 ИЛИ СтрНайти(СтрокаСоединения, Врег("beta-unf.42clouds.com")) <> 0 
		ИЛИ СтрНайти(СтрокаСоединения, Врег("beta-area-1c-03")) <> 0 
		ИЛИ СтрНайти(СтрокаСоединения, Врег("sql-d7")) <> 0 
		ИЛИ СтрНайти(СтрокаСоединения, Врег("FILE=")) <> 0 Тогда
		ТестоваяСреда = Истина;
	КонецЕсли;
	
	Возврат ТестоваяСреда;
	
КонецФункции


//Efsol Рыбалка Н.А. 25.06.2019+
&НаСервере
Функция ПолучитьТаблицуТочекПолигонаПоРадиусу(КоординатыЦентПолигона, РасстояниеКМ) Экспорт
	
	ТаблЗначений = Новый ТаблицаЗначений;
	КвалификаторыЧисла = Новый КвалификаторыЧисла(11,7,ДопустимыйЗнак.Любой);
	ОписаниеЧисла = Новый ОписаниеТипов("Число", КвалификаторыЧисла);
	ТаблЗначений.Колонки.Добавить("Х",ОписаниеЧисла);
	ТаблЗначений.Колонки.Добавить("У",ОписаниеЧисла);
	ТаблЗначений.Колонки.Добавить("НомерСтроки", ОписаниеЧисла);
	Pi = 3.1415926535897932;
	Радиус = Константы.ES_ОграничениеПоРасстоянию.Получить() + РасстояниеКМ;
	//Радиус = Константы.ES_ОграничениеПоРасстоянию.Получить();
	Угол = 0;
	
	Для Н=0 По 12 Цикл
		X = Число(КоординатыЦентПолигона.Долгота) + Радиус * 0.005 * Sin(Угол*Pi/180);
		Y = Число(КоординатыЦентПолигона.Широта) + Радиус * 0.01 * Cos(Угол*Pi/180);
		НоваяСтрока = ТаблЗначений.Добавить();
		НоваяСтрока.Х = X;
		НоваяСтрока.У = Y;
		НоваяСтрока.НомерСтроки = Н+1;
		
		Угол = Угол + 30;
	КонецЦикла;
	
	Возврат ТаблЗначений;
		
КонецФункции

&НаСервере
Функция ПолучитьТаблицуТочекДляПроверки(ТЗТочек) Экспорт
	
	ТаблЗначений 	= Новый ТаблицаЗначений;
	КвалификаторыЧисла 	= Новый КвалификаторыЧисла(11, 7, ДопустимыйЗнак.Любой);
    ОписаниеЧисла 		= Новый ОписаниеТипов("Число", КвалификаторыЧисла);
	ОписаниеЗаказ		= Новый ОписаниеТипов("ДокументСсылка.ЗаказПокупателя");
	ТаблЗначений.Колонки.Добавить("Заявка",ОписаниеЗаказ);
	ТаблЗначений.Колонки.Добавить("Х",ОписаниеЧисла);
	ТаблЗначений.Колонки.Добавить("У",ОписаниеЧисла);
	ТаблЗначений.Колонки.Добавить("НомерСтроки",ОписаниеЧисла);
	Итератор = 1;
	Для Каждого Элем Из ТЗТочек Цикл
		НоваяСтрока = ТаблЗначений.Добавить();
		Если ТипЗнч(Элем.Заявка) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
			НоваяСтрока.Х = Элем.Заявка.ES_АдресДоставкиДолгота;
			НоваяСтрока.У = Элем.Заявка.ES_АдресДоставкиШирота;
		Иначе
			НоваяСтрока.Х = Элем.Заявка.АдресДолгота;
			НоваяСтрока.У = Элем.Заявка.АдресШирота;
		КонецЕсли;
		НоваяСтрока.НомерСтроки = Итератор;
		НоваяСтрока.Заявка = Элем.Заявка;
		Итератор = Итератор + 1;		
		
	КонецЦикла;
	
	Возврат ТаблЗначений;
	
КонецФункции

&НаСервере
Функция ПроверитьТочкиЗапросом(Полигон, Точки) Экспорт
	
	Если Полигон.Количество() < 3 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Полигон", Полигон);
	Запрос.УстановитьПараметр("РазмерПолигона", Полигон.Количество());
	Запрос.УстановитьПараметр("Точки", Точки);
	Запрос.Текст =
	"ВЫБРАТЬ
        |	Полигон.НомерСтроки КАК НомерТочкиПолигона,
        |	Полигон.Х,
        |	Полигон.У
        |ПОМЕСТИТЬ Полигон
        |ИЗ
        |	&Полигон КАК Полигон
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |	Точки.НомерСтроки КАК НаименованиеТочки,
        |	Точки.Х КАК Х,
        |	Точки.У КАК У,
        |	Точки.Заявка КАК Заявка
        |ПОМЕСТИТЬ Точки
        |ИЗ
        |	&Точки КАК Точки
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |	Точки.НаименованиеТочки,
        |	Точки.Х КАК Точка_Х,
        |	Точки.У КАК Точка_У,
        |	Полигон.НомерТочкиПолигона,
        |	Полигон.Х КАК Полигон_Х,
        |	Полигон.У КАК Полигон_У,
        |	Полигон.Х - Точки.Х КАК Разница_Х,
        |	Полигон.У - Точки.У КАК Разница_У,
        |	ВЫБОР
        |		КОГДА Полигон.Х - Точки.Х < 0
        |				И Полигон.У - Точки.У < 0
        |			ТОГДА 2
        |		КОГДА Полигон.Х - Точки.Х < 0
        |				И Полигон.У - Точки.У >= 0
        |			ТОГДА 1
        |		КОГДА Полигон.Х - Точки.Х >= 0
        |				И Полигон.У - Точки.У < 0
        |			ТОГДА 3
        |		КОГДА Полигон.Х - Точки.Х >= 0
        |				И Полигон.У - Точки.У >= 0
        |			ТОГДА 0
        |	КОНЕЦ КАК К,
        |	Точки.Заявка
        |ПОМЕСТИТЬ Таб
        |ИЗ
        |	Точки КАК Точки,
        |	Полигон КАК Полигон
        |
        |ИНДЕКСИРОВАТЬ ПО
        |	Точки.НаименованиеТочки,
        |	Полигон.НомерТочкиПолигона
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |	Таб.НаименованиеТочки,
        |	Таб.Точка_Х,
        |	Таб.Точка_У,
        |	Таб.НомерТочкиПолигона,
        |	Таб.Полигон_Х,
        |	Таб.Полигон_У,
        |	Таб.К КАК К,
        |	ТабПред.К КАК ПредК,
        |	Таб.К - ТабПред.К КАК ДельтаКу,
        |	ВЫБОР
        |		КОГДА Таб.К - ТабПред.К = -3
        |			ТОГДА 1
        |		КОГДА Таб.К - ТабПред.К = 3
        |			ТОГДА -1
        |		КОГДА Таб.К - ТабПред.К = -2
        |				И ТабПред.Разница_Х * Таб.Разница_У >= ТабПред.Разница_У * Таб.Разница_Х
        |			ТОГДА 1
        |		КОГДА Таб.К - ТабПред.К = 2
        |				И НЕ ТабПред.Разница_Х * Таб.Разница_У >= ТабПред.Разница_У * Таб.Разница_Х
        |			ТОГДА -1
        |		ИНАЧЕ 0
        |	КОНЕЦ КАК Результат,
        |	Таб.Заявка
        |ПОМЕСТИТЬ Развернуто
        |ИЗ
        |	Таб КАК Таб
        |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Таб КАК ТабПред
        |		ПО Таб.НаименованиеТочки = ТабПред.НаименованиеТочки
        |			И (Таб.НомерТочкиПолигона = ТабПред.НомерТочкиПолигона + 1
        |				ИЛИ Таб.НомерТочкиПолигона = 1
        |					И ТабПред.НомерТочкиПолигона = &РазмерПолигона)
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |	Развернуто.НаименованиеТочки,
        |	Развернуто.Точка_Х КАК Х,
        |	Развернуто.Точка_У КАК У,
        |	ВЫБОР
        |		КОГДА СУММА(Развернуто.Результат) = 0
        |			ТОГДА ЛОЖЬ
        |		ИНАЧЕ ИСТИНА
        |	КОНЕЦ КАК Результат,
        |	Развернуто.Заявка
        |ПОМЕСТИТЬ ВТ
        |ИЗ
        |	Развернуто КАК Развернуто
        |
        |СГРУППИРОВАТЬ ПО
        |	Развернуто.НаименованиеТочки,
        |	Развернуто.Точка_Х,
        |	Развернуто.Точка_У,
        |	Развернуто.Заявка
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |	ВТ.НаименованиеТочки,
        |	ВТ.Х,
        |	ВТ.У,
        |	ВТ.Результат,
        |	ВТ.Заявка КАК Заявка
        |ИЗ
        |	ВТ КАК ВТ
        |ГДЕ
        |	ВТ.Результат
        |
        |УПОРЯДОЧИТЬ ПО
        |	Заявка";
	Возврат Запрос.Выполнить().Выгрузить();
	
	
КонецФункции

&НаСервере
Функция ПолучитьВремяМаршрута(СтартСтруктура, ФинишСтруктура, ВремяСтарт = Неопределено,ПоЗаявке = Ложь) Экспорт
	
	Время = 0;
	Расстояние = 0;
	
	НачальныеКоординатыДолгота = СтрЗаменить(СтартСтруктура.Долгота,",",".");
	НачальныеКоординатыШирота  = СтрЗаменить(СтартСтруктура.Широта,",","."); 
	КонечныеКоординатыДолгота  = СтрЗаменить(ФинишСтруктура.Долгота,",",".");
	КонечныеКоординатыШирота   = СтрЗаменить(ФинишСтруктура.Широта,",",".");
	
	//Создаем временный файл в который запишем данные 
	ВремФайл = ПолучитьИмяВременногоФайла("xml");
	
	НачальныеКоординаты = "&flat=" + НачальныеКоординатыДолгота + "&flon=" + НачальныеКоординатыШирота + ""; 
	КонечныеКоординаты = "&tlat=" + КонечныеКоординатыДолгота + "&tlon=" + КонечныеКоординатыШирота + "";
	
	КодСтраницыСайта = Новый HTTPСоединение("yournavigation.org",,,,Неопределено);  
	КодСтраницыСайта.Получить("/api/1.0/gosmore.php?format=kml&v=graphhopper_car" + НачальныеКоординаты + "" + КонечныеКоординаты + "",ВремФайл);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ВремФайл);
	
	Попытка
		
		Пока ЧтениеXML.Прочитать() Цикл
			
			Если ЧтениеXML.Имя = "distance" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда 
				ЧтениеXML.Прочитать();
				Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
					
					Расстояние = Число(ЧтениеXML.Значение);
				КонецЕсли; 
				
			ИначеЕсли ЧтениеXML.Имя = "traveltime" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда       
				ЧтениеXML.Прочитать();
				Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
					
					Время = Число(ЧтениеXML.Значение);
					Прервать;
				КонецЕсли; 
				
			КонецЕсли;
			
		КонецЦикла;
		ЧтениеXML.Закрыть();
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	Если Не Расстояние = 0 Тогда
		Скорость = Время/Расстояние;
	КонецЕсли;
	
	Если Не ВремФайл = Неопределено Тогда
		УдалитьФайлы(ВремФайл);
	КонецЕсли;
	
	Расстояние = Окр(Расстояние, 0, 1);
	
	КоэфициентЗон = 0;
	ДельтаВремени = Константы.ES_ДельтаВремени.Получить();
	Время = Время + КоэфициентЗон + ДельтаВремени;
	
	мСтруктура = Новый Структура;
	мСтруктура.Вставить("Время", Время);
	мСтруктура.Вставить("Расстояние", Расстояние);
	
	Возврат мСтруктура;		
	
КонецФункции

//Efsol Рыбалка Н.А.-