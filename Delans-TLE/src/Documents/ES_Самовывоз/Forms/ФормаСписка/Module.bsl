
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура - обработчик нажатия на кнопку ОтборДень.
//
&НаКлиенте
Процедура ОтборДень(Команда)
	
	НастройкаПериода = Элементы.Список.Период;
	НастройкаПериода.Вариант = ВариантСтандартногоПериода.Сегодня;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры // ОтборДень()

// Процедура - обработчик нажатия на кнопку ОтборНеделя.
//
&НаКлиенте
Процедура ОтборНеделя(Команда)
	
	НастройкаПериода = Элементы.Список.Период;
	НастройкаПериода.Вариант = ВариантСтандартногоПериода.ЭтаНеделя;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры // ОтборНеделя()

// Процедура - обработчик нажатия на кнопку ОтборМесяц.
//
&НаКлиенте
Процедура ОтборМесяц(Команда)
	
	НастройкаПериода = Элементы.Список.Период;
	НастройкаПериода.Вариант = ВариантСтандартногоПериода.ЭтотМесяц;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры // ОтборМесяц()

// Процедура - обработчик нажатия на кнопку ОтборОчистить.
//
&НаКлиенте
Процедура ОтборОчистить(Команда)
	
	НастройкаПериода = Элементы.Список.Период;
	НастройкаПериода.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод;
	НастройкаПериода.ДатаНачала = '00010101';
	НастройкаПериода.ДатаОкончания = '00010101';
	
	Элементы.Список.Обновить();
	
КонецПроцедуры // ОтборОчистить()


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаВажныеКомандыВыдачи);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти


// НЕ ИСПОЛЬЗУЕТСЯ
&НаКлиенте
Процедура ОтборИсполнительПриИзменении(Элемент)
	
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Исполнитель", ОтборИсполнитель, ЗначениеЗаполнено(ОтборИсполнитель));

КонецПроцедуры

// НЕ ИСПОЛЬЗУЕТСЯ
&НаКлиенте
Процедура ОтборДатаПриИзменении(Элемент)
	
	
	ЭлементыОтбора = Список.Отбор.Элементы;
	
	// Удаление предыдущего отбора по этому полю
	Если ЭлементыОтбора.Количество() > 0 Тогда
		й = ЭлементыОтбора.Количество() - 1;
		Пока й >= 0 Цикл
			Если ЭлементыОтбора[й].ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Дата") Тогда
				ЭлементыОтбора.Удалить(ЭлементыОтбора[й]);
			КонецЕсли; 
			й = й - 1;
		КонецЦикла;
	КонецЕсли; 
	
	// Добавление нового отбора
	Если ЗначениеЗаполнено(ОтборДата) Тогда
		ЭлементОтбора = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Дата");
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		ЭлементОтбора.ПравоеЗначение = ОтборДата;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
		
		ЭлементОтбора = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Дата");
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
		ЭлементОтбора.ПравоеЗначение = КонецДня(ОтборДата);
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
		Элементы.Список.Обновить();
	КонецЕсли; 
	
КонецПроцедуры

// НЕ ИСПОЛЬЗУЕТСЯ
&НаКлиенте
Процедура УстановитьРасходнуюНакладную(Команда)
	
	//Если Элементы.Список.ВыделенныеСтроки.Количество() > 0 Тогда
	//	ВыбДок = Неопределено;
	//	Если ВвестиЗначение(ВыбДок, "Выбор документа", Тип("ДокументСсылка.РасходнаяНакладная")) Тогда
	//		ИзменитьЗначениеРеквизитаРасходнаяНакладная(ВыбДок);
	//		Сообщить("Изменения внесены");
	//	КонецЕсли;
	//КонецЕсли; 
	
КонецПроцедуры

// НЕ ИСПОЛЬЗУЕТСЯ
&НаСервере
Процедура ИзменитьЗначениеРеквизитаРасходнаяНакладная(ВыбДок)
	
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	ES_Выдачи.Ссылка,
	//	|	ES_Выдачи.РасходнаяНакладная
	//	|ИЗ
	//	|	Документ.ES_Выдачи КАК ES_Выдачи
	//	|ГДЕ
	//	|	ES_Выдачи.Ссылка В(&МассивВыделенныхДокументов)";
	//
	//Запрос.УстановитьПараметр("МассивВыделенныхДокументов", Элементы.Список.ВыделенныеСтроки);
	//
	//РезультатЗапроса = Запрос.Выполнить();
	//Если НЕ РезультатЗапроса.Пустой() Тогда
	//	
	//	Выборка = РезультатЗапроса.Выбрать();
	//	
	//	Пока Выборка.Следующий() Цикл
	//		
	//		ДокОбъект = Выборка.Ссылка.ПолучитьОбъект();
	//		ДокОбъект.РасходнаяНакладная = ВыбДок;
	//		Попытка
	//			ДокОбъект.Записать();
	//		Исключение
	//			Сообщить("Не удалось записать " + Выборка.Ссылка);
	//		КонецПопытки;
	//		
	//	КонецЦикла;
	//
	//КонецЕсли; 

КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//ЭР Несторук С.И. 10.04.2019 9:32:27 {
	ES_БиллингКлиент.ПроверитьДоступностьСервисаDelans(Отказ);
	//}ЭР Несторук С.И.
КонецПроцедуры
 