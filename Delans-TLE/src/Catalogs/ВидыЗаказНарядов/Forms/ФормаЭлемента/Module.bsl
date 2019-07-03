
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеСостоянияЗавершен(
		УсловноеОформление,
		ПредопределенноеЗначение("Справочник.СостоянияЗаказНарядов.Завершен"),
		"Объект.ПорядокСостояний.Состояние",
		"ПорядокСостояний"
	);
	
	УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	ЗаполнитьСписокВыбораСостоянияВыполнения(ЭтотОбъект);
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СостоянияЗаказНарядов" Тогда
		УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ВидыЗаказНарядов", Объект.Ссылка, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СостояниеВыполненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗаполнитьСписокВыбораСостоянияВыполнения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеВыполненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ПорядокСостояний.НайтиСтроки(Новый Структура("Состояние", ВыбранноеЗначение)).Количество() = 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Выбранного состояния нет среди используемых в виде заказ-наряда.'"),
			,
			"Объект.СостояниеВыполнения"
		);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокСостоянийПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКомандВверхВниз();
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокСостоянийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не Копирование Тогда
		
		Отказ = Истина;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		
		ОткрытьФорму("Справочник.СостоянияЗаказНарядов.ФормаВыбора", ПараметрыФормы, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокСостоянийОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		Если Объект.ПорядокСостояний.НайтиСтроки(Новый Структура("Состояние", ВыбранноеЗначение)).Количество() > 0 Тогда
			Возврат;
		КонецЕсли;
		
		Если Элемент.ТекущаяСтрока = Неопределено Или ВыбранноеЗначение = ПредопределенноеЗначение("Справочник.СостоянияЗаказНарядов.Завершен") Тогда
			НоваяСтрока = Объект.ПорядокСостояний.Добавить();
		Иначе
			НоваяСтрока = Объект.ПорядокСостояний.Вставить(Объект.ПорядокСостояний.НайтиПоИдентификатору(Элемент.ТекущаяСтрока).НомерСтроки-1);
		КонецЕсли;
		НоваяСтрока.Состояние = ВыбранноеЗначение;
		
		Элемент.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокСостоянийПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ЗапрещеноИзменениеПорядка = Ложь;
	
	СтрокаПорядкаСостояний = Объект.ПорядокСостояний.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение);
	Если СтрокаПорядкаСостояний <> Неопределено
		И СтрокаПорядкаСостояний.Состояние = ПредопределенноеЗначение("Справочник.СостоянияЗаказНарядов.Завершен") Тогда
		
		ЗапрещеноИзменениеПорядка = Истина;
	КонецЕсли;
	
	Если Не ЗапрещеноИзменениеПорядка И Строка <> Неопределено Тогда
		СтрокаПорядкаСостояний = Объект.ПорядокСостояний.НайтиПоИдентификатору(Строка);
		Если СтрокаПорядкаСостояний <> Неопределено
			И СтрокаПорядкаСостояний.Состояние = ПредопределенноеЗначение("Справочник.СостоянияЗаказНарядов.Завершен") Тогда
			
			ЗапрещеноИзменениеПорядка = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗапрещеноИзменениеПорядка Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьВсе(Команда)
	
	ДобавитьВсеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	
	ПереместитьСтрокуТЧ(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	
	ПереместитьСтрокуТЧ(1);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеПоЦветамСостоянийСервер()
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеПоЦветамСостояний(
		УсловноеОформление,
		Метаданные.Справочники.СостоянияЗаказНарядов.ПолноеИмя(),
		"Объект.ПорядокСостояний.Состояние",
		"ПорядокСостояний"
	);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВсеНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СостоянияЗаказНарядов.Ссылка КАК Состояние,
		|	ВЫБОР
		|		КОГДА СостоянияЗаказНарядов.Ссылка = ЗНАЧЕНИЕ(Справочник.СостоянияЗаказНарядов.Завершен)
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Порядок
		|ИЗ
		|	Справочник.СостоянияЗаказНарядов КАК СостоянияЗаказНарядов
		|ГДЕ
		|	СостоянияЗаказНарядов.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок,
		|	СостоянияЗаказНарядов.Наименование";
	
	Состояния = Запрос.Выполнить().Выгрузить();
	
	Объект.ПорядокСостояний.Загрузить(Состояния);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьСтрокуТЧ(Смещение)
	
	Если Элементы.ПорядокСостояний.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаПорядка = Объект.ПорядокСостояний.НайтиПоИдентификатору(Элементы.ПорядокСостояний.ТекущаяСтрока);
	Если СтрокаПорядка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрокаПорядка.НомерСтроки + Смещение = 0
		Или СтрокаПорядка.НомерСтроки + Смещение > Объект.ПорядокСостояний.Количество()
		Или Объект.ПорядокСостояний[СтрокаПорядка.НомерСтроки+Смещение-1].Состояние = ПредопределенноеЗначение("Справочник.СостоянияЗаказНарядов.Завершен") Тогда
		
		Возврат;
	КонецЕсли;
	
	Объект.ПорядокСостояний.Сдвинуть(СтрокаПорядка.НомерСтроки-1, Смещение);
	УстановитьДоступностьКомандВверхВниз();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандВверхВниз()
	
	Данные = Элементы.ПорядокСостояний.ТекущиеДанные;
	Если Данные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоЗавершен = Данные.Состояние = ПредопределенноеЗначение("Справочник.СостоянияЗаказНарядов.Завершен");
	
	Элементы.ПорядокСостояний.ИзменятьПорядокСтрок			= Не ЭтоЗавершен;
	Элементы.ПорядокСостоянийПереместитьВниз.Доступность	= Не ЭтоЗавершен;
	Элементы.ПорядокСостоянийПереместитьВверх.Доступность	= Не ЭтоЗавершен;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораСостоянияВыполнения(Форма)
	
	Форма.Элементы.СостояниеВыполнения.СписокВыбора.Очистить();
	Для Каждого СтрокаСостояния Из Форма.Объект.ПорядокСостояний Цикл
		Форма.Элементы.СостояниеВыполнения.СписокВыбора.Добавить(СтрокаСостояния.Состояние);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
