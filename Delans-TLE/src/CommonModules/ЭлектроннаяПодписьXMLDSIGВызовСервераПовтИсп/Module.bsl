
#Область ПрограммныйИнтерфейс

// Определяет тип криптопровайдера по его имени
//
// Параметры:
//  ИмяКриптопровайдера - Строка - Имя модуля криптографии
//
// Возвращаемое значение:
//  Число - Специальное число, которое описывает тип программы и дополняет имя программы.
//
Функция ТипКриптопровайдераПоИмени(ИмяКриптопровайдера) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПрограммыЭлектроннойПодписиИШифрования.ТипПрограммы
	|ИЗ
	|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК ПрограммыЭлектроннойПодписиИШифрования
	|ГДЕ
	|	ПрограммыЭлектроннойПодписиИШифрования.ИмяПрограммы = &ИмяПрограммы");
	
	Запрос.УстановитьПараметр("ИмяПрограммы", ИмяКриптопровайдера);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ТипПрограммы;
	Иначе
		Возврат Неопределено;
	КонецЕсли
	
КонецФункции

#КонецОбласти