
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Исполнитель") Тогда
		//Список.ТекстЗапроса = "ВЫБРАТЬ
		//	|	ES_ПланДоставки.Номер,
		//	|	ES_ПланДоставки.Дата,
		//	|	ES_ПланДоставки.Исполнитель,
		//	|	ES_ПланДоставки.ТранспортноеСредство
		//	|ИЗ
		//	|	Документ.ES_ПланДоставки КАК ES_ПланДоставки
		//	|ГДЕ
		//	|	НЕ ES_ПланДоставки.ПометкаУдаления
		//	|	И ES_ПланДоставки.Проведен
		//	|	И ES_ПланДоставки.Исполнитель = &Исполнитель";
		//
		//Список.Параметры.УстановитьЗначениеПараметра("Исполнитель", Параметры.Исполнитель);
		
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Исполнитель", Параметры.Исполнитель, ЗначениеЗаполнено(Параметры.Исполнитель));

	КонецЕсли;
	
КонецПроцедуры
