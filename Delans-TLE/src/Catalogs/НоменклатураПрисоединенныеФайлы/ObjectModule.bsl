#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("Выбрать Справочник.Номенклатура.Ссылка Где ФайлКартинки = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоменклатураОбъект = Выборка.Ссылка.ПолучитьОбъект();
		НоменклатураОбъект.ФайлКартинки = Неопределено;
		НоменклатураОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли