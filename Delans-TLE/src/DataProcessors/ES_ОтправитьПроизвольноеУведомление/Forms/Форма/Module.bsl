
&НаСервере
Процедура ОтправитьНаСервере()
	ОтправитьУведомление = Истина;
	Уведомление = Новый ДоставляемоеУведомление();
	Уведомление.Текст = Объект.Содержание;
	Уведомление.Заголовок = "Уведомление";
	ES_РаботаСДоставляемымиУведомлениями.ОтправитьУведомление(Уведомление,Объект.Курьер);
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	ОтправитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Получатель") Тогда
		Объект.Курьер = Параметры.Получатель;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПолучитьКоординатыНаСервере()
	ОтправитьУведомление = Истина;
	Уведомление = Новый ДоставляемоеУведомление();
	Уведомление.Текст = "Синхронизация";
	Уведомление.Данные = "get_courier_coordinates";
	Уведомление.Заголовок = "Уведомление";
	ES_РаботаСДоставляемымиУведомлениями.ОтправитьУведомление(Уведомление,Объект.Курьер);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКоординаты(Команда)
	ПолучитьКоординатыНаСервере();
КонецПроцедуры
