
// Служебные

&НаСервереБезКонтекста
Процедура СохранитьНовыеНастройкиИОбновитьИнтерфейс(НеобходимоОбновитьИнтерфейс, ИзменныеНастройки)
	
	Для Каждого ЭлементНастройки Из ИзменныеНастройки Цикл
		
		ТекущееЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки(ЭлементНастройки.Ключ);
		Если ЭлементНастройки.Значение <> ТекущееЗначениеНастройки Тогда
			
			НеобходимоОбновитьИнтерфейс = Истина;
			УправлениеНебольшойФирмойСервер.УстановитьНастройкуПользователя(ЭлементНастройки.Значение, ЭлементНастройки.Ключ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Команды

&НаКлиенте
Процедура ОК(Команда)
	
	ИзменныеНастройки = Новый Структура;
	
	Если Модифицированность Тогда
		
		НеобходимоОбновитьИнтерфейс = Ложь;
		
		ИзменныеНастройки.Вставить("ЗапрашиватьКоличество", ЗапрашиватьКоличество);
		
		СохранитьНовыеНастройкиИОбновитьИнтерфейс(НеобходимоОбновитьИнтерфейс, ИзменныеНастройки);
		
		Если НеобходимоОбновитьИнтерфейс Тогда
			
			ОбновитьИнтерфейс();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Закрыть(ИзменныеНастройки);
	
КонецПроцедуры

// Форма

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗапрашиватьКоличество = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("ЗапрашиватьКоличество");
	
КонецПроцедуры

// Реквизиты формы