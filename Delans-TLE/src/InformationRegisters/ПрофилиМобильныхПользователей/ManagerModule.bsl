// Назначает профиль пользователю.
//
Процедура НазначитьПрофильПользователю(Пользователь, Профиль) Экспорт
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Пользователь = Пользователь;
	Если ТипЗнч(Профиль) = Тип("Строка") Тогда
		МенеджерЗаписи.Профиль = Перечисления.ПрофилиМобильногоПриложения[Профиль];
	Иначе
		МенеджерЗаписи.Профиль = Профиль;
	КонецЕсли;
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры // УстановитьИзменитьОсновнуюЦенуПродажи()

Функция ПолучитьПрофильПользователя(Пользователь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрофилиМобильныхПользователей.Профиль
	|ИЗ
	|	РегистрСведений.ПрофилиМобильныхПользователей КАК ПрофилиМобильныхПользователей
	|ГДЕ
	|	ПрофилиМобильныхПользователей.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Профиль;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции
