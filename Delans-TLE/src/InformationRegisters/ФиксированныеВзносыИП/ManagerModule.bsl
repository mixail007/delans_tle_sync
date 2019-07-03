#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда



#Область ПрограммныйИнтерфейс

Процедура УстановитьФиксированныеВзносыИП() Экспорт
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ФиксированныеВзносыИП.СоздатьНаборЗаписей();
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20180101';
	НоваяСтрока.РазмерПФР = 26545;
	НоваяСтрока.РазмерФОМС = 5840;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20190101';
	НоваяСтрока.РазмерПФР = 29354;
	НоваяСтрока.РазмерФОМС = 6884;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20200101';
	НоваяСтрока.РазмерПФР = 32448;
	НоваяСтрока.РазмерФОМС = 8426;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Возвращает структуру, содержащую размер фиксированных взносов в ПФР и ФОМС на переданную дату
//
Функция ФиксированныеВзносыИПНаДату(Дата = Неопределено) Экспорт
	
	ТекущиеВзносы = Новый Структура("РазмерПФР,РазмерФОМС", 0, 0);
	
	// МРОТ
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ФиксированныеВзносыИП.РазмерПФР КАК РазмерПФР,
	|	ФиксированныеВзносыИП.РазмерФОМС КАК РазмерФОМС
	|ИЗ
	|	РегистрСведений.ФиксированныеВзносыИП.СрезПоследних(&ДатаСреза, ) КАК ФиксированныеВзносыИП");
	Запрос.УстановитьПараметр("ДатаСреза", НачалоГода(Дата));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ТекущиеВзносы, Выборка);
	КонецЕсли;
	
	Возврат ТекущиеВзносы;
	
КонецФункции

#КонецОбласти

#КонецЕсли