
&НаКлиенте
Перем МассивИзмененныхРеквизитов;

#Область Служебные

&НаКлиенте
Процедура ЗафиксироватьИзменениеЗначенияРеквизита(ИмяРеквизита)
	
	Если МассивИзмененныхРеквизитов.Найти(ИмяРеквизита) = Неопределено Тогда
		
		МассивИзмененныхРеквизитов.Добавить(ИмяРеквизита);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзмененияИЗакрытьФорму(Команда = Неопределено)
	
	ПараметрыЗакрытия = Новый Структура;
	Если Команда <> Неопределено Тогда
		
		ПараметрыЗакрытия.Вставить("Команда", Команда);
		
	КонецЕсли;
	
	ИзмененныеРеквизиты = Новый Структура;
	Для каждого ЭлементМассива Из МассивИзмененныхРеквизитов Цикл
		
		ИзмененныеРеквизиты.Вставить(ЭлементМассива, КонтекстПечати[ЭлементМассива]);
		
	КонецЦикла;
	ПараметрыЗакрытия.Вставить("ИзмененныеРеквизиты", ИзмененныеРеквизиты);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаСервере
Процедура ЗаголовокФормы()
	
	ЭтаФорма.Заголовок = Обработки.РеквизитыПечати.ЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьПодписиПоУмолчаниюНаСервере()
	
	ДокументОбъект = ДанныеФормыВЗначение(КонтекстПечати, Тип("ДокументОбъект.РасходныйОрдер"));
	Обработки.РеквизитыПечати.ПодписиПоУмолчанию(ДокументОбъект);
	ЗначениеВДанныеФормы(ДокументОбъект, КонтекстПечати);
	
КонецПроцедуры

#КонецОбласти

#Область Форма

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивОбъектовМетаданных = Новый Массив(1);
	МассивОбъектовМетаданных[0] = Параметры.КонтекстПечати.Ссылка.Метаданные();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = МассивОбъектовМетаданных;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	УправлениеНебольшойФирмойСервер.УстановитьОтображаниеПодменюПечати(Элементы.ПодменюПечать);
	
	ЗаполнитьЗначенияСвойств(КонтекстПечати, Параметры.КонтекстПечати, "СтруктурнаяЕдиница, ПодписьКладовщика");
	
	ЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МассивИзмененныхРеквизитов = Новый Массив;
	
КонецПроцедуры

#КонецОбласти

#Область Библиотеки

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ЗаписатьИзмененияИЗакрытьФорму(Команда);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	
	// работа метода не предусмотрена
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	Возврат; // работа метода не предусмотрена
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура ОК(Команда)
	
	ЗаписатьИзмененияИЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьПодписиПоУмолчанию(Команда)
	
	ПредыдущиеЗначения = Новый Структура("ПодписьКладовщика");
	ЗаполнитьЗначенияСвойств(ПредыдущиеЗначения, КонтекстПечати);
	
	ПолучитьПодписиПоУмолчаниюНаСервере();
	
	Для каждого ЭлементСтруктуры Из ПредыдущиеЗначения Цикл
		
		Если ЭлементСтруктуры.Значение <> КонтекстПечати[ЭлементСтруктуры.Ключ] Тогда
			
			ЗафиксироватьИзменениеЗначенияРеквизита(ЭлементСтруктуры.Ключ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Реквизиты

&НаКлиенте
Процедура КонтекстПечатиПодписьКладовщикаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита("ПодписьКладовщика");
	
КонецПроцедуры

#КонецОбласти
