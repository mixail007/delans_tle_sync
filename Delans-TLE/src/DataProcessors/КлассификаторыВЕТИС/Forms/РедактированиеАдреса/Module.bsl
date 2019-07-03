
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.ДанныеАдреса <> Неопределено Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ДанныеАдреса);
		Страна = ИнтеграцияВЕТИСПовтИсп.СтранаМира(Параметры.ДанныеАдреса.СтранаGUID);
		
		СтранаGUID          = Параметры.ДанныеАдреса.СтранаGUID;
		СтранаПредставление = ДанныеСтраныМираВЕТИС(Страна).Наименование;
		
	Иначе
		
		Страна = Справочники.СтраныМира.Россия;
		Результат = ДанныеСтраныМираВЕТИС(Страна);
		
		СтранаGUID          = Результат.Идентификатор;
		СтранаПредставление = Результат.Наименование;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РегионGUID)
		И Не ЗначениеЗаполнено(РегионПредставление) Тогда
		
		РезультатВыполненияЗапроса = ИкарВЕТИСВызовСервера.РегионПоGUID(РегионGUID);
		Если РезультатВыполненияЗапроса.Элемент <> Неопределено Тогда
			РегионПредставление = РезультатВыполненияЗапроса.Элемент.name;
		Иначе
			РегионПредставление = НСтр("ru = '<нет представления>'");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РайонGUID)
		И Не ЗначениеЗаполнено(РайонПредставление) Тогда
		
		РезультатВыполненияЗапроса = ИкарВЕТИСВызовСервера.РайонПоGUID(РайонGUID);
		Если РезультатВыполненияЗапроса.Элемент <> Неопределено Тогда
			РайонПредставление = РезультатВыполненияЗапроса.Элемент.name;
		Иначе
			РайонПредставление = НСтр("ru = '<нет представления>'");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НаселенныйПунктGUID)
		И Не ЗначениеЗаполнено(НаселенныйПунктПредставление) Тогда
		
		НаселенныйПунктПредставление = НСтр("ru = '<нет представления>'");
		
		ВыполнятьПоиск = Истина;
		Пока ВыполнятьПоиск Цикл
			
			НомерСтраницы = 1;
			
			Если ЗначениеЗаполнено(РайонGUID) Тогда
				РезультатВыполненияЗапроса = ИкарВЕТИСВызовСервера.СписокНаселенныхПунктовРайона(РайонGUID, НомерСтраницы, 1000);
			Иначе
				РезультатВыполненияЗапроса = ИкарВЕТИСВызовСервера.СписокНаселенныхПунктовРайона(РегионGUID, НомерСтраницы, 1000);
			КонецЕсли;
			
			Если РезультатВыполненияЗапроса.Список <> Неопределено Тогда
				
				Для Каждого ЭлементСписка Из РезультатВыполненияЗапроса.Список Цикл
					
					Если ЭлементСписка.guid = НаселенныйПунктGUID Тогда
						ВыполнятьПоиск = Ложь;
						НаселенныйПунктПредставление = ЭлементСписка.view;
						Прервать;
					КонецЕсли;
					
				КонецЦикла;
				
				НомерСтраницы = НомерСтраницы + 1;
				
			Иначе
				
				ВыполнятьПоиск = Ложь;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УлицаGUID)
		И Не ЗначениеЗаполнено(УлицаПредставление) Тогда
		
		УлицаПредставление = НСтр("ru = '<нет представления>'");
		
		ВыполнятьПоиск = Истина;
		Пока ВыполнятьПоиск Цикл
			
			НомерСтраницы = 1;
			
			Если ЗначениеЗаполнено(НаселенныйПунктGUID) Тогда
				РезультатВыполненияЗапроса = ИкарВЕТИСВызовСервера.СписокУлицНаселенногоПункта(НаселенныйПунктGUID, НомерСтраницы, 1000);
			Иначе
				РезультатВыполненияЗапроса = ИкарВЕТИСВызовСервера.СписокУлицНаселенногоПункта(РегионGUID, НомерСтраницы, 1000);
			КонецЕсли;
			
			Если РезультатВыполненияЗапроса.Список <> Неопределено Тогда
				
				Для Каждого ЭлементСписка Из РезультатВыполненияЗапроса.Список Цикл
					
					Если ЭлементСписка.guid = УлицаGUID Тогда
						ВыполнятьПоиск = Ложь;
						УлицаПредставление = ЭлементСписка.view;
						Прервать;
					КонецЕсли;
					
				КонецЦикла;
				
				НомерСтраницы = НомерСтраницы + 1;
				
			Иначе
				
				ВыполнятьПоиск = Ложь;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Параметры.ЭтоАдресЗоныОтветственности Тогда
		
		НенужныеЭлементы = Новый Массив();
		НенужныеЭлементы.Добавить("ПочтовыйИндекс");
		НенужныеЭлементы.Добавить("УлицаПредставление");
		НенужныеЭлементы.Добавить("ГруппаНомерДома");
		НенужныеЭлементы.Добавить("ДополнительнаяИнформация");
		
		Для Каждого ИмяЭлемента Из НенужныеЭлементы Цикл
			Элементы[ИмяЭлемента].Видимость = Ложь;
		КонецЦикла;
		
	КонецЕсли;
	
	Элементы.АдресСтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(ДополнительнаяИнформация);
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
	СформироватьПредставлениеАдреса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	ПараметрыПоиска = ИнтеграцияВЕТИСКлиентСервер.СтруктураДанныхАдреса();
	ПараметрыПоиска.Вставить("ПредставлениеАдреса",          ПредставлениеАдреса);
	
	ПараметрыПоиска.Вставить("СтранаGUID",                   СтранаGUID);
	ПараметрыПоиска.Вставить("СтранаПредставление",          СтранаПредставление);
	
	ПараметрыПоиска.Вставить("РегионGUID",                   РегионGUID);
	ПараметрыПоиска.Вставить("РегионПредставление",          РегионПредставление);
	
	ПараметрыПоиска.Вставить("РайонGUID",                    РайонGUID);
	ПараметрыПоиска.Вставить("РайонПредставление",           РайонПредставление);
	
	ПараметрыПоиска.Вставить("НаселенныйПунктGUID",          НаселенныйПунктGUID);
	ПараметрыПоиска.Вставить("НаселенныйПунктПредставление", НаселенныйПунктПредставление);
	
	ПараметрыПоиска.Вставить("УлицаGUID",                    УлицаGUID);
	ПараметрыПоиска.Вставить("УлицаПредставление",           УлицаПредставление);
	
	ПараметрыПоиска.Вставить("НомерДома",                НомерДома);
	ПараметрыПоиска.Вставить("НомерСтроения",            НомерСтроения);
	ПараметрыПоиска.Вставить("НомерОфиса",               НомерОфиса);
	ПараметрыПоиска.Вставить("ПочтовыйИндекс",           ПочтовыйИндекс);
	ПараметрыПоиска.Вставить("АбонентскийЯщик",          АбонентскийЯщик);
	ПараметрыПоиска.Вставить("ДополнительнаяИнформация", ДополнительнаяИнформация);
	
	Закрыть(ПараметрыПоиска);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЭлементыФормы(Форма)
	
	РасширенныйАдрес = (Форма.Страна = ПредопределенноеЗначение("Справочник.СтраныМира.Россия"));
	
	Форма.Элементы.ТипАдреса.ТекущаяСтраница = ?(РасширенныйАдрес, Форма.Элементы.НациональныйАдрес, Форма.Элементы.ИностранныйАдрес);
	
	Форма.Элементы.РайонПредставление.Видимость           = РасширенныйАдрес;
	Форма.Элементы.НаселенныйПунктПредставление.Видимость = РасширенныйАдрес;
	Форма.Элементы.УлицаПредставление.Видимость           = РасширенныйАдрес;
	
	Форма.Элементы.РегионПредставление.Доступность = ЗначениеЗаполнено(Форма.СтранаGUID);
	Форма.Элементы.РайонПредставление.Доступность = ЗначениеЗаполнено(Форма.РегионGUID);
	Форма.Элементы.НаселенныйПунктПредставление.Доступность = ЗначениеЗаполнено(Форма.РайонGUID) Или ЗначениеЗаполнено(Форма.РегионGUID);
	Форма.Элементы.УлицаПредставление.Доступность = ЗначениеЗаполнено(Форма.НаселенныйПунктGUID) Или ЗначениеЗаполнено(Форма.РегионGUID);
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьФорму(
		"Обработка.КлассификаторыВЕТИС.Форма.КлассификаторСтран",,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ОбработатьВыборСтраны", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборСтраны(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	СтранаGUID          = Результат.Идентификатор;
	СтранаПредставление = Результат.Наименование;
	
	ПочтовыйИндекс               = Неопределено;
	НаселенныйПунктGUID          = Неопределено;
	НаселенныйПунктПредставление = Неопределено;
	ПочтовыйИндекс               = Неопределено;
	УлицаGUID                    = Неопределено;
	УлицаПредставление           = Неопределено;
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	СформироватьПредставлениеАдреса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РегионПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("GUIDСтраны", СтранаGUID);
	
	ОткрытьФорму(
		"Обработка.КлассификаторыВЕТИС.Форма.КлассификаторРегионов",
		ПараметрыОткрытия,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ОбработатьВыборРегиона", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборРегиона(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	РегионGUID          = Результат.GUID;
	РегионПредставление = Результат.НаименованиеПолное;
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	СформироватьПредставлениеАдреса(ЭтотОбъект);
	
КонецПроцедуры


&НаКлиенте
Процедура РайонПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("GUIDРегиона", РегионGUID);
	
	ОткрытьФорму(
		"Обработка.КлассификаторыВЕТИС.Форма.КлассификаторРайонов",
		ПараметрыОткрытия,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ОбработатьВыборРайона", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборРайона(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	РайонGUID          = Результат.GUID;
	РайонПредставление = Результат.НаименованиеПолное;
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	СформироватьПредставлениеАдреса(ЭтотОбъект);
	
КонецПроцедуры


&НаКлиенте
Процедура НаселенныйПунктПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("GUIDРегиона", РегионGUID);
	ПараметрыОткрытия.Вставить("GUIDРайона",  РайонGUID);
	
	ОткрытьФорму(
		"Обработка.КлассификаторыВЕТИС.Форма.КлассификаторНаселенныхПунктов",
		ПараметрыОткрытия,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ОбработатьВыборНаселенногоПункта", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборНаселенногоПункта(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	НаселенныйПунктGUID          = Результат.GUID;
	НаселенныйПунктПредставление = Результат.НаименованиеПолное;
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	СформироватьПредставлениеАдреса(ЭтотОбъект);
	
КонецПроцедуры



&НаКлиенте
Процедура УлицаПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыОткрытия = Новый Структура;
	Если ЗначениеЗаполнено(НаселенныйПунктGUID) Тогда
		ПараметрыОткрытия.Вставить("GUIDНаселенногоПункта", НаселенныйПунктGUID);
	Иначе
		ПараметрыОткрытия.Вставить("GUIDНаселенногоПункта", РегионGUID);
	КонецЕсли;

	ОткрытьФорму(
		"Обработка.КлассификаторыВЕТИС.Форма.КлассификаторУлиц",
		ПараметрыОткрытия,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ОбработатьВыборУлицы", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборУлицы(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	УлицаGUID          = Результат.GUID;
	УлицаПредставление = Результат.НаименованиеПолное;
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	СформироватьПредставлениеАдреса(ЭтотОбъект);
	
КонецПроцедуры


&НаКлиенте
Процедура СтранаПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтранаGUID          = Неопределено;
	СтранаПредставление = Неопределено;
	
	РегионGUID          = Неопределено;
	РегионПредставление = Неопределено;
	
	РайонGUID          = Неопределено;
	РайонПредставление = Неопределено;
	
	НаселенныйПунктGUID          = Неопределено;
	НаселенныйПунктПредставление = Неопределено;
	
	УлицаGUID          = Неопределено;
	УлицаПредставление = Неопределено;
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РегионПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	РегионGUID          = Неопределено;
	РегионПредставление = Неопределено;
	
	РайонGUID          = Неопределено;
	РайонПредставление = Неопределено;
	
	НаселенныйПунктGUID          = Неопределено;
	НаселенныйПунктПредставление = Неопределено;
	
	УлицаGUID          = Неопределено;
	УлицаПредставление = Неопределено;
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РайонПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	РайонGUID          = Неопределено;
	РайонПредставление = Неопределено;
	
	НаселенныйПунктGUID          = Неопределено;
	НаселенныйПунктПредставление = Неопределено;
	
	УлицаGUID          = Неопределено;
	УлицаПредставление = Неопределено;
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НаселенныйПунктПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	НаселенныйПунктGUID          = Неопределено;
	НаселенныйПунктПредставление = Неопределено;
	
	УлицаGUID          = Неопределено;
	УлицаПредставление = Неопределено;
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УлицаПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	УлицаGUID          = Неопределено;
	УлицаПредставление = Неопределено;
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НомерДомаПриИзменении(Элемент)
	
	СформироватьПредставлениеАдреса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НомерСтроенияПриИзменении(Элемент)
	
	СформироватьПредставлениеАдреса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НомерОфисаПриИзменении(Элемент)
	
	СформироватьПредставлениеАдреса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительнаяИнформацияПриИзменении(Элемент)
	
	СформироватьПредставлениеАдреса(ЭтотОбъект);
	
	ПодключитьОбработчикОжидания("УстановитьПиктограммуКомментария", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИндексПриИзменении(Элемент)
	
	СформироватьПредставлениеАдреса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьПредставлениеАдреса(Форма)
	
	ЭлементыАдреса = Новый Массив;
	Если ЗначениеЗаполнено(Форма.ПочтовыйИндекс) Тогда
		ЭлементыАдреса.Добавить(Форма.ПочтовыйИндекс);
	КонецЕсли;
	Если ЗначениеЗаполнено(Форма.СтранаПредставление) Тогда
		ЭлементыАдреса.Добавить(Форма.СтранаПредставление);
	КонецЕсли;
	Если ЗначениеЗаполнено(Форма.РегионПредставление) Тогда
		ЭлементыАдреса.Добавить(Форма.РегионПредставление);
	КонецЕсли;
	Если ЗначениеЗаполнено(Форма.РайонПредставление) Тогда
		ЭлементыАдреса.Добавить(Форма.РайонПредставление);
	КонецЕсли;
	Если ЗначениеЗаполнено(Форма.НаселенныйПунктПредставление) Тогда
		ЭлементыАдреса.Добавить(Форма.НаселенныйПунктПредставление);
	КонецЕсли;
	Если ЗначениеЗаполнено(Форма.УлицаПредставление) Тогда
		ЭлементыАдреса.Добавить(Форма.УлицаПредставление);
	КонецЕсли;
	Если ЗначениеЗаполнено(Форма.НомерДома) Тогда
		
		ЭлементыАдреса.Добавить(
			СтрШаблон(
				НСтр("ru = 'д. %1'"),
				Форма.НомерДома));
	КонецЕсли;
	Если ЗначениеЗаполнено(Форма.НомерСтроения) Тогда
		ЭлементыАдреса.Добавить(
			СтрШаблон(
				НСтр("ru = 'стр. %1'"),
				Форма.НомерСтроения));
	КонецЕсли;
	Если ЗначениеЗаполнено(Форма.НомерОфиса) Тогда
		ЭлементыАдреса.Добавить(
			СтрШаблон(
				НСтр("ru = '%1'"),
				Форма.НомерОфиса));
	КонецЕсли;
	Если ЗначениеЗаполнено(Форма.ДополнительнаяИнформация) Тогда
		ЭлементыАдреса.Добавить(Форма.ДополнительнаяИнформация);
	КонецЕсли;
	
	Форма.ПредставлениеАдреса = СтрСоединить(ЭлементыАдреса, ", ");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеСтраныМираВЕТИС(Страна)
	
	ВозвращаемоеЗначение = ПрочиеКлассификаторыВЕТИСВызовСервера.ДанныеСтраныМира(Страна);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаКлиенте
Процедура СтранаПриИзменении(Элемент)
	
	ДанныеСтраныМира = ДанныеСтраныМираВЕТИС(Страна);
	
	ОбработатьВыборСтраны(ДанныеСтраныМира, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаОчистка(Элемент, СтандартнаяОбработка)
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	Элементы.АдресСтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(ДополнительнаяИнформация);
КонецПроцедуры
