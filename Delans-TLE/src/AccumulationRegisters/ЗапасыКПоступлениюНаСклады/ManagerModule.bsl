#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура создает пустую временную таблицу изменения движений.
//
Процедура СоздатьПустуюВременнуюТаблицуИзменение(ДополнительныеСвойства) Экспорт
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	ЗапасыКПоступлениюНаСклады.НомерСтроки КАК НомерСтроки,
	|	ЗапасыКПоступлениюНаСклады.Организация КАК Организация,
	|	ЗапасыКПоступлениюНаСклады.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЗапасыКПоступлениюНаСклады.Номенклатура КАК Номенклатура,
	|	ЗапасыКПоступлениюНаСклады.Характеристика КАК Характеристика,
	|	ЗапасыКПоступлениюНаСклады.Партия КАК Партия,
	|	ЗапасыКПоступлениюНаСклады.Количество КАК КоличествоПередЗаписью,
	|	ЗапасыКПоступлениюНаСклады.Количество КАК КоличествоИзменение,
	|	ЗапасыКПоступлениюНаСклады.Количество КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗапасыКПоступлениюНаСкладыИзменение
	|ИЗ
	|	РегистрНакопления.ЗапасыКПоступлениюНаСклады КАК ЗапасыКПоступлениюНаСклады");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыКПоступлениюНаСкладыИзменение", Ложь);
	
КонецПроцедуры // СоздатьПустуюВременнуюТаблицуИзменение()

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли