
&НаСервере
Процедура ОдинОтправительПриИзмененииНаСервере()
	//мОбъект = РеквизитФормыВЗначение("Объект");
	//Для Каждого мСтрока Из мОбъект.ТЧПолучатели Цикл
	//	мСтрока.Отправитель = Справочники.ES_Адреса.ПустаяСсылка();	
	//КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОдинОтправительПриИзменении(Элемент)
	
	//Если Объект.ОдинОтправитель Тогда
	//	
	//	Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопрос",ЭтотОбъект);
	//	
	//	ПоказатьВопрос(Оповещение, "При выборе одного отправителя соответствующая колонка в табличной части будет очищена. Продолжить?",РежимДиалогаВопрос.ДаНет,0,,"ВНИМАНИЕ!!!");
	//
	//КонецЕсли;
	//
	//Элементы.Отправитель.Видимость = Объект.ОдинОтправитель;
	//Элементы.ТЧПолучателиОтправитель.Видимость = Не Объект.ОдинОтправитель;
	
КонецПроцедуры

&НаКлиенте

Процедура ПослеОтветаНаВопрос(Результат, Параметры) Экспорт 

	//Если Результат = КодВозвратаДиалога.Да Тогда
	//	ОдинОтправительПриИзмененииНаСервере();		
	//Иначе		
	//	Объект.ОдинОтправитель = Ложь;
	//	Возврат;	
	//КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	//Если Объект.ОдинОтправитель и Не ЗначениеЗаполнено(Объект.Отправитель) Тогда
	//	Сообщить("Не заполнен отправитель!",СтатусСообщения.Внимание);
	//	Отказ = Истина;
	//ИначеЕсли НЕ Объект.ОдинОтправитель Тогда
	//	Сообщение = "";
	//	ПередЗаписьюНаСервере(Отказ,Сообщение);
	//	Если Отказ Тогда
	//		Сообщить(Сообщение,СтатусСообщения.Внимание);
	//	КонецЕсли;
	//КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ,Сообщение)
	
	//мОбъект = РеквизитФормыВЗначение("Объект");
	//
	//Для Каждого мСтрока Из мОбъект.ТЧПолучатели Цикл
	//	Если Не ЗначениеЗаполнено(мСтрока.Отправитель) Тогда
	//		Сообщение = "В строке "+мСтрока.НомерСтроки+" не заполнен отправитель.";
	//		Отказ = Истина;
	//		Прервать;
	//	КонецЕсли;
	//КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//ЭР Несторук С.И. 10.04.2019 9:32:27 {
	ES_БиллингКлиент.ПроверитьДоступностьСервисаDelans(Отказ);
	//}ЭР Несторук С.И.
КонецПроцедуры

