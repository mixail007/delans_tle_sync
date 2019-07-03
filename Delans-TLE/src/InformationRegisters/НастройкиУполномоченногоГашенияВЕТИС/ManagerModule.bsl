#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ВыполнитьЗаписьПоГрузоотправителю(Грузоотправитель, Грузополучатели) Экспорт

	Если Не ЗначениеЗаполнено(Грузоотправитель) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	МассивГрузополучателей = Новый Массив;
	Для Каждого Грузополучатель Из Грузополучатели Цикл
		
		Если ЗначениеЗаполнено(Грузополучатель)
			И МассивГрузополучателей.Найти(Грузополучатель) = Неопределено Тогда
			
			МассивГрузополучателей.Добавить(Грузополучатель);
			
		КонецЕсли;
		
	КонецЦикла;
	
	НаборЗаписей = РегистрыСведений.НастройкиУполномоченногоГашенияВЕТИС.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Грузоотправитель.Установить(Грузоотправитель);
	
	Для Каждого Грузополучатель Из МассивГрузополучателей Цикл
		
		ЗаписьНабора = НаборЗаписей.Добавить();
		ЗаписьНабора.Грузоотправитель = Грузоотправитель;
		ЗаписьНабора.Грузополучатель  = Грузополучатель;
		
	КонецЦикла;
	
	НаборЗаписей.Записать();

КонецПроцедуры

#КонецОбласти

#КонецЕсли