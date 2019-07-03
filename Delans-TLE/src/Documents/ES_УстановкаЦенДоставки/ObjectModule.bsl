
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если НЕ Договор.Пустая() И НЕ Договор.ES_УчетПриРасчетеЦенТК Тогда
		Сообщить("Для договора "+Договор+" не установлен признак индивидуальных цен.",СтатусСообщения.ОченьВажное);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	   //Сережко АС +
	// регистр ES_ЦеныДоставки
	Движения.ES_ЦеныДоставки.Записывать = Истина;
	Для Каждого ТекСтрокаЦены Из Цены Цикл
		Движение = Движения.ES_ЦеныДоставки.Добавить();
		Движение.Период = Дата;
		Движение.Зона = ТекСтрокаЦены.ЗонаДоставки;
		Движение.Тариф = Тариф;
		Движение.Вес = ТекСтрокаЦены.Вес;
		Движение.Цена = ТекСтрокаЦены.Цена;
		Движение.Договор = Договор;
		Движение.ВидДоставки = ВидДоставки;	
		Движение.ВидКонтрагента = ВидКонтрагента;
		Движение.ВесОт = ТекСтрокаЦены.Вес.ВесОт;
		Движение.ВесДо = ТекСтрокаЦены.Вес.ВесДо;
		Движение.ЗаКаждый = ТекСтрокаЦены.Вес.ЗаКаждые;
		Движение.ИнтервалЗаКаждый = ТекСтрокаЦены.Вес.Интервал;
	КонецЦикла;
	
	Движения.ES_ЦеныДоставкиДопУслуги.Записывать = Истина;
	Для Каждого ТекСтрокаДопУслуги Из ДопУслуги Цикл    
		Движение = Движения.ES_ЦеныДоставкиДопУслуги.Добавить(); 
		Движение.Договор = Договор;    
		Движение.Номенклатура = ТекСтрокаДопУслуги.Номенклатура;
		Движение.ЦенаЗаКаждыйКилограмм = ТекСтрокаДопУслуги.ЦенаЗаКаждыйКг;
		Движение.Цена = ТекСтрокаДопУслуги.Цена;
		Движение.Период = Дата;
	КонецЦикла;        	
	
	  //Сережко АС -

КонецПроцедуры
