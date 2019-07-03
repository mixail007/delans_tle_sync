#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		
		НаборЗаписейФИО = РегистрыСведений.ФИОФизЛиц.СоздатьНаборЗаписей();
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ФИОФизЛицСрезПоследних.Фамилия,
		                      |	ФИОФизЛицСрезПоследних.Имя,
		                      |	ФИОФизЛицСрезПоследних.Отчество
		                      |ИЗ
		                      |	РегистрСведений.ФИОФизЛиц.СрезПоследних(, ФизЛицо = &ФизЛицо) КАК ФИОФизЛицСрезПоследних");
							  
		Запрос.УстановитьПараметр("ФизЛицо", Ссылка);
		РезультатЗапроса = Запрос.Выполнить();
		
		// набор уже записан
		Если Не РезультатЗапроса.Пустой() Тогда
			Возврат;
		КонецЕсли;
		
		ФИО = Наименование;
		
		Фамилия  = УправлениеНебольшойФирмойСервер.ВыделитьСлово(ФИО);
		Имя      = УправлениеНебольшойФирмойСервер.ВыделитьСлово(ФИО);
		Отчество = УправлениеНебольшойФирмойСервер.ВыделитьСлово(ФИО);

		ЗаписьНабора = НаборЗаписейФИО.Добавить();
		ЗаписьНабора.Период		= ?(ЗначениеЗаполнено(ДатаРождения), ДатаРождения, '19000101');
		ЗаписьНабора.Фамилия	= Фамилия;
		ЗаписьНабора.Имя		= Имя;
		ЗаписьНабора.Отчество	= Отчество;
		
		Если НаборЗаписейФИО.Количество() > 0 И ЗначениеЗаполнено(НаборЗаписейФИО[0].Период) Тогда
			
			НаборЗаписейФИО[0].Физлицо = Ссылка;
			
			НаборЗаписейФИО.Отбор.Физлицо.Использование	= Истина;
			НаборЗаписейФИО.Отбор.Физлицо.Значение			= НаборЗаписейФИО[0].Физлицо;
			НаборЗаписейФИО.Отбор.Период.Использование		= Истина;
			НаборЗаписейФИО.Отбор.Период.Значение			= НаборЗаписейФИО[0].Период;
			Если Не ЗначениеЗаполнено(ЗаписьНабора.Фамилия + ЗаписьНабора.Имя + ЗаписьНабора.Отчество) Тогда
				ЗаписьНабора.Фамилия	= Фамилия;
				ЗаписьНабора.Имя		= Имя;
				ЗаписьНабора.Отчество	= Отчество;
			КонецЕсли;
			
			НаборЗаписейФИО.Записать(Истина);
			
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли