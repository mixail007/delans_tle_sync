
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СчетУчетаЗапасов = Параметры.СчетУчетаЗапасов;
	СчетУчетаЗатрат = Параметры.СчетУчетаЗатрат;
	СчетУчетаДоходов = Параметры.СчетУчетаДоходов;
	Ссылка = Параметры.Ссылка;
	
	// ФО Использовать подсистемы Производство.
	ИспользоватьПодсистемуПроизводство = Константы.ФункциональнаяОпцияИспользоватьПодсистемуПроизводство.Получить();
	
	Элементы.СчетУчетаЗапасов.Видимость = ?(
		(НЕ ЗначениеЗаполнено(Параметры.ТипНоменклатуры))
		 ИЛИ Параметры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас
		 ИЛИ Параметры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат,
		Истина,
		Ложь
	);
	
	Элементы.СчетУчетаЗатрат.Видимость = ?(
		(НЕ ЗначениеЗаполнено(Параметры.ТипНоменклатуры))
		 ИЛИ Параметры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас
		 ИЛИ Параметры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа
		 ИЛИ Параметры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Операция
		 ИЛИ Параметры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга
		 ИЛИ Параметры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат,
		Истина,
		Ложь
	);
	
	Элементы.СчетУчетаДоходов.Видимость = ?(
		(НЕ ЗначениеЗаполнено(Параметры.ТипНоменклатуры))
		 ИЛИ Параметры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат,
		Истина,
		Ложь
	);
	
	Если ОтказИзменитьСчетУчета(Ссылка) Тогда
		Элементы.Пояснение.Заголовок = НСтр("ru = 'В базе есть движения по этой номенклатуре: изменение счета учета запрещено.'");
		Элементы.Пояснение.Видимость = Истина;
		Элементы.ГруппаСчетовУчета.ТолькоПросмотр = Истина;
		Элементы.ПоУмолчанию.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПравоДоступа("Редактирование", Ссылка.Метаданные()) Тогда
		Элементы.ГруппаСчетовУчета.ТолькоПросмотр = Истина;
		Элементы.ПоУмолчанию.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СчетУчетаЗапасовПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СчетУчетаЗапасов) Тогда
		СчетУчетаЗапасов = ПредопределенноеЗначение("ПланСчетов.Управленческий.СырьеИМатериалы");
	КонецЕсли;
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаЗатратПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СчетУчетаЗатрат) Тогда
		Если ИспользоватьПодсистемуПроизводство Тогда
			СчетУчетаЗатрат = ПредопределенноеЗначение("ПланСчетов.Управленческий.НезавершенноеПроизводство");
		Иначе
			СчетУчетаЗатрат = ПредопределенноеЗначение("ПланСчетов.Управленческий.КоммерческиеРасходы");
		КонецЕсли;
	КонецЕсли;
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаДоходовПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(СчетУчетаДоходов) Тогда
		СчетУчетаДоходов = ПредопределенноеЗначение("ПланСчетов.Управленческий.ПрочиеДоходы");
	КонецЕсли;
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКомандФормы

// Процедура - обработчик нажатия команды ПоУмолчанию.
//
&НаКлиенте
Процедура ПоУмолчанию(Команда)
	
	Если Элементы.СчетУчетаЗапасов.Видимость Тогда
		СчетУчетаЗапасов = ПредопределенноеЗначение("ПланСчетов.Управленческий.СырьеИМатериалы");
	КонецЕсли;
	
	Если Элементы.СчетУчетаЗатрат.Видимость Тогда
		Если ИспользоватьПодсистемуПроизводство Тогда
			СчетУчетаЗатрат = ПредопределенноеЗначение("ПланСчетов.Управленческий.НезавершенноеПроизводство");
		Иначе
			СчетУчетаЗатрат = ПредопределенноеЗначение("ПланСчетов.Управленческий.КоммерческиеРасходы");
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.СчетУчетаДоходов.Видимость Тогда
		СчетУчетаДоходов = ПредопределенноеЗначение("ПланСчетов.Управленческий.ПрочиеДоходы");
	КонецЕсли;
	
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры // ПоУмолчанию()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция проверяет возможность изменения счета учета.
//
&НаСервере
Функция ОтказИзменитьСчетУчета(Ссылка)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Запасы.Период,
	|	Запасы.Регистратор,
	|	Запасы.НомерСтроки,
	|	Запасы.Активность,
	|	Запасы.ВидДвижения,
	|	Запасы.Организация,
	|	Запасы.СтруктурнаяЕдиница,
	|	Запасы.СчетУчета,
	|	Запасы.Номенклатура,
	|	Запасы.Характеристика,
	|	Запасы.Партия,
	|	Запасы.ЗаказПокупателя,
	|	Запасы.Количество,
	|	Запасы.Сумма,
	|	Запасы.КоррСтруктурнаяЕдиница,
	|	Запасы.КоррСчетУчета,
	|	Запасы.КоррНоменклатура,
	|	Запасы.КоррХарактеристика,
	|	Запасы.КоррПартия,
	|	Запасы.КоррЗаказПокупателя,
	|	Запасы.Спецификация,
	|	Запасы.КоррСпецификация,
	|	Запасы.ЗаказПродажи,
	|	Запасы.ДокументПродажи,
	|	Запасы.Подразделение,
	|	Запасы.Ответственный,
	|	Запасы.СтавкаНДС,
	|	Запасы.ФиксированнаяСтоимость,
	|	Запасы.ЗатратыНаВыпуск,
	|	Запасы.Возврат,
	|	Запасы.СодержаниеПроводки,
	|	Запасы.ПеремещениеВРозницуСуммовойУчет
	|ИЗ
	|	РегистрНакопления.Запасы КАК Запасы
	|ГДЕ
	|	Запасы.Номенклатура = &Номенклатура
	|	ИЛИ Запасы.КоррНоменклатура = &Номенклатура");
	
	Запрос.УстановитьПараметр("Номенклатура", ?(ЗначениеЗаполнено(Ссылка), Ссылка, Неопределено));
	
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции // ОтказИзменитьСчетУчетаЗапасов()

&НаКлиенте
Процедура ОповеститьОбИзмененииСчетовРасчетов()
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("СчетУчетаЗапасов", СчетУчетаЗапасов);
	СтруктураПараметры.Вставить("СчетУчетаЗатрат", СчетУчетаЗатрат);
	СтруктураПараметры.Вставить("СчетУчетаДоходов", СчетУчетаДоходов);
	
	Оповестить("ИзменилисьСчетаНоменклатуры", СтруктураПараметры);
	
КонецПроцедуры

#КонецОбласти
