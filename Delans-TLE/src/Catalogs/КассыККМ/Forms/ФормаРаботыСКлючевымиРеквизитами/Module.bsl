
// Процедура вызывается по кнопке "Разрешить редактирование".
//
&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	Результат = Новый Массив;
	
	Если РазрешитьРедактированиеВалютаДенежныхСредств Тогда
		Результат.Добавить("ВалютаДенежныхСредств");
	КонецЕсли;
	
	Если РазрешитьРедактированиеТипКассы Тогда
		Результат.Добавить("ТипКассы");
	КонецЕсли;
	
	Если РазрешитьРедактированиеСтруктурнойЕдиницы Тогда
		Результат.Добавить("СтруктурнаяЕдиница");
	КонецЕсли;
	
	Если РазрешитьРедактированиеПодразделение Тогда
		Результат.Добавить("Подразделение");
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры // РазрешитьРедактирование()
