
////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.УслугаДоставки 	= ES_ОбщегоНазначения.ПолучитьСтартовуюНастройку(Перечисления.ES_ВидыСтартовыхНастроек.УслугаДоставки);
		Объект.Характеристика 	= ES_ОбщегоНазначения.ПолучитьСтартовуюНастройку(Перечисления.ES_ВидыСтартовыхНастроек.Характеристика);
		Объект.ВидЗабора 		= ES_ОбщегоНазначения.ПолучитьСтартовуюНастройку(Перечисления.ES_ВидыСтартовыхНастроек.ВидЗабора);
		Объект.Срочность		= Перечисления.ES_СрочностьДоставки.Стандартная;
		
		//Почкун 14.05.2019 +
		Объект.ДеньДоставки		= ES_ОбщегоНазначения.ПолучитьСтартовуюНастройку(Перечисления.ES_ВидыСтартовыхНастроек.ДеньДоставки);
		Объект.ДеньСбора		= Перечисления.ES_ДниДоставки.Сегодня;
		//Почкун 14.05.2019 -

	КонецЕсли;
	
	Если Объект.СоздатьСбор Тогда
		Элементы.БезВыезда.Доступность = Ложь;
	Иначе
		Элементы.БезВыезда.Доступность = Истина;
	КонецЕсли;
	
	Если Объект.БезВыезда Тогда
		Элементы.СоздатьЗабор.Доступность = Ложь;
	Иначе
		Элементы.СоздатьЗабор.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	//ЕФСОЛ Несторук 12.09.2016 +
	//Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
	//	Объект.Наименование = Объект.Контрагент;
	//КонецЕсли; 
	//ЕФСОЛ Несторук 12.09.2016 -  
	
	//ЕФСОЛ Сережко А.С. 29.09.2017 +   
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Если НЕ ЗначениеЗаполнено(Объект.Договор) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Поле = "Объект.Договор";
			Сообщение.Текст = "Договор не заполнен";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли; 
	//ЕФСОЛ Сережко -
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ОбновитьДанныеНастройки");
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ ЭЛЕМЕНТОВ

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
		Объект.Наименование = Объект.Контрагент;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправительПриИзменении(Элемент)
	ОтправительПриИзмененииНаСервере();	
КонецПроцедуры

&НаСервере
Процедура ОтправительПриИзмененииНаСервере()
	
	Объект.Адрес  = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Объект.Отправитель,ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресКонтрагента"));

КонецПроцедуры   

&НаКлиенте
Процедура СоздатьЗаборПриИзменении()
	Если Объект.СоздатьСбор Тогда
		Элементы.БезВыезда.Доступность = Ложь;
	Иначе
		Элементы.БезВыезда.Доступность = Истина;
	КонецЕсли; 	
КонецПроцедуры

&НаКлиенте
Процедура БезВыездаПриИзменении()
	Если Объект.БезВыезда Тогда
		Элементы.СоздатьЗабор.Доступность = Ложь;
	Иначе
		Элементы.СоздатьЗабор.Доступность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//ЭР Несторук С.И. 10.04.2019 9:32:27 {
	ES_БиллингКлиент.ПроверитьДоступностьСервисаDelans(Отказ);
	//}ЭР Несторук С.И.
КонецПроцедуры

#КонецОбласти
