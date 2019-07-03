
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресСпискаОрганизацийЕГАИС = "";
	Параметры.Свойство("АдресСпискаОрганизацийЕГАИС", АдресСпискаОрганизацийЕГАИС);
	
	МассивЭлементов = ПолучитьИзВременногоХранилища(АдресСпискаОрганизацийЕГАИС);
	Если ТипЗнч(МассивЭлементов) <> Тип("Массив") Тогда
		ВызватьИсключение НСтр("ru = 'В форму создания контрагентов переданы некорректные параметры.'");
	КонецЕсли;
	
	СоответствиеКонтрагентов = ПолучитьСоответствиеКонтрагентов(МассивЭлементов);
	
	Для каждого ОрганизацияЕГАИС Из МассивЭлементов Цикл
	
		Если СоответствиеКонтрагентов.Получить(ОрганизацияЕГАИС) = Неопределено Тогда
			СписокОрганизацийЕГАИС.Добавить(ОрганизацияЕГАИС);
		КонецЕсли;
	
	КонецЦикла;
	
	Если СписокОрганизацийЕГАИС.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ВидКонтрагента = Перечисления.ВидыКонтрагентов.ЮридическоеЛицо;
	
	ЗаголовокКоманды = НСтр("ru = 'Создать контрагентов (%КоличествоЭлементов%)'");
	Элементы.ФормаСоздатьКонтрагентов.Заголовок = СтрЗаменить(ЗаголовокКоманды, "%КоличествоЭлементов%", СписокОрганизацийЕГАИС.Количество());
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьКонтрагентов(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСозданияКонтрагентов = Новый Структура;
	ПараметрыСозданияКонтрагентов.Вставить("Родитель"       , Родитель);
	ПараметрыСозданияКонтрагентов.Вставить("ВидКонтрагента"      , ВидКонтрагента);
	ПараметрыСозданияКонтрагентов.Вставить("МассивЭлементов", СписокОрганизацийЕГАИС.ВыгрузитьЗначения());
	
	Закрыть(ПараметрыСозданияКонтрагентов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьСоответствиеКонтрагентов(МассивОрганизацийЕГАИС)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОрганизацийЕГАИС", МассивОрганизацийЕГАИС);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Ссылка КАК ОрганизацияЕГАИС,
	|	КлассификаторОрганизацийЕГАИС.Контрагент КАК Контрагент
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	КлассификаторОрганизацийЕГАИС.Ссылка В(&МассивОрганизацийЕГАИС)
	|	И КлассификаторОрганизацийЕГАИС.Сопоставлено";
	
	СоответствиеКонтрагентов = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СоответствиеКонтрагентов.Вставить(Выборка.ОрганизацияЕГАИС, Выборка.Контрагент);
	КонецЦикла;
	
	Возврат СоответствиеКонтрагентов;
	
КонецФункции

#КонецОбласти
