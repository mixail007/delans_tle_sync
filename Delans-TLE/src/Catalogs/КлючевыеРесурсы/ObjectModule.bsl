#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если НЕ ЗначениеЗаполнено(ЗначениеРесурса) Тогда
		ЗначениеРесурса = Неопределено;	
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ВидыРесурсовПредприятия.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.РесурсПредприятия.Установить(Ссылка);
    НаборЗаписей.Отбор.ВидРесурсаПредприятия.Установить(Справочники.ВидыРесурсовПредприятия.ВсеРесурсы);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.ВидРесурсаПредприятия = Справочники.ВидыРесурсовПредприятия.ВсеРесурсы;
	НоваяЗапись.РесурсПредприятия = Ссылка;
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли