
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СчетУчета = Параметры.СчетУчета;
	Ссылка = Параметры.Ссылка;
	
	Если ОтказИзменитьСчетУчета(Ссылка) Тогда
		Элементы.Пояснение.Заголовок = НСтр("ru = 'В базе есть движения по этой кассе: изменение счета учета запрещено.'");
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
Процедура СчетУчетаПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СчетУчета) Тогда
		СчетУчета = ПредопределенноеЗначение("ПланСчетов.Управленческий.Касса");
	КонецЕсли;
	ОповеститьОбИзмененииСчетов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик нажатия команды ПоУмолчанию.
//
&НаКлиенте
Процедура ПоУмолчанию(Команда)
	
	СчетУчета = ПредопределенноеЗначение("ПланСчетов.Управленческий.Касса");
	ОповеститьОбИзмененииСчетов();
	
КонецПроцедуры // ПоУмолчанию()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция проверяет возможность изменения счета учета.
//
&НаСервере
Функция ОтказИзменитьСчетУчета(Ссылка)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДенежныеСредства.Период,
	|	ДенежныеСредства.Регистратор,
	|	ДенежныеСредства.НомерСтроки,
	|	ДенежныеСредства.Активность,
	|	ДенежныеСредства.ВидДвижения,
	|	ДенежныеСредства.Организация,
	|	ДенежныеСредства.ТипДенежныхСредств,
	|	ДенежныеСредства.БанковскийСчетКасса,
	|	ДенежныеСредства.Валюта,
	|	ДенежныеСредства.Сумма,
	|	ДенежныеСредства.СуммаВал,
	|	ДенежныеСредства.СодержаниеПроводки,
	|	ДенежныеСредства.Статья
	|ИЗ
	|	РегистрНакопления.ДенежныеСредства КАК ДенежныеСредства
	|ГДЕ
	|	ДенежныеСредства.БанковскийСчетКасса = &БанковскийСчетКасса");
	
	Запрос.УстановитьПараметр("БанковскийСчетКасса", ?(ЗначениеЗаполнено(Ссылка), Ссылка, Неопределено));
	
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции // ОтказИзменитьСчетУчета()

&НаКлиенте
Процедура ОповеститьОбИзмененииСчетов()
	
	СтруктураПараметры = Новый Структура(
		"СчетУчета",
		СчетУчета
	);
	
	Оповестить("ИзменилисьСчетаКассы", СтруктураПараметры);
	
КонецПроцедуры

#КонецОбласти

