
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Ключ.Пустая() Тогда
		
		ПриСозданииПриЧтенииНаСервере();
			
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаписатьДанныеОтслеживания();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПриСозданииПриЧтенииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого КИ Из Emailтрекинг Цикл
		
		Если НЕ ЗначениеЗаполнено(КИ.ЗначениеКИ) Тогда
			Продолжить;
		КонецЕсли;
		
		ИсточникПривлечения = РегистрыСведений.ОтслеживаниеИсточниковПривлечения.ПолучитьИсточникПривлеченияПоКИ(КИ.ЗначениеКИ);
		
		Если НЕ ЗначениеЗаполнено(ИсточникПривлечения) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ИсточникПривлечения = Объект.Ссылка Тогда
			Продолжить;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон(НСтр("ru='Контактная информация уже используется для отслеживания источника: %1'"), ИсточникПривлечения)
		);
		
		Отказ = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура ДобавитьОтслеживание(Команда)
	
	СписокКоманд = Новый СписокЗначений;
	
	Если ИспользоватьТелефонию Тогда
		СписокКоманд.Добавить("ВидТелефон", "Телефон");
	КонецЕсли;
	Если Элементы.Email_0.СписокВыбора.Количество() <> 0 Тогда
		СписокКоманд.Добавить("ВидЭП", "E-mail");
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьОтслеживаниеВидВыбран", ЭтотОбъект, ДополнительныеПараметры);

	ПоказатьВыборИзСписка(ОписаниеОповещения, СписокКоманд, ТекущийЭлемент);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииПриЧтенииНаСервере()
	
	ИспользоватьТелефонию = ПолучитьФункциональнуюОпцию("ИспользоватьОблачнуюТелефонию");
	
	ЗаполнитьСписокВыбораАдресовЭП();
	ЗаполнитьТаблицыОтслеживанияИсточника();
	ОбновитьЭлементыОтслеживания();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицыОтслеживанияИсточника()
	
	Emailтрекинг.Очистить();
	Коллтрекинг.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтслеживаниеИсточниковПривлечения.ИсточникПривлечения КАК ИсточникПривлечения,
	|	ОтслеживаниеИсточниковПривлечения.ТипКИ КАК ТипКИ,
	|	ОтслеживаниеИсточниковПривлечения.ЗначениеКИ КАК ЗначениеКИ
	|ИЗ
	|	РегистрСведений.ОтслеживаниеИсточниковПривлечения КАК ОтслеживаниеИсточниковПривлечения
	|ГДЕ ОтслеживаниеИсточниковПривлечения.ИсточникПривлечения = &ИсточникПривлечения";
	
	Запрос.УстановитьПараметр("ИсточникПривлечения", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ТипКИ = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
			НоваяСтрока = Emailтрекинг.Добавить();
			НоваяСтрока.ЗначениеКИ = Выборка.ЗначениеКИ;
			Продолжить;
		КонецЕсли;
		
		Если Выборка.ТипКИ = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
			НоваяСтрока = Коллтрекинг.Добавить();
			НоваяСтрока.ЗначениеКИ = Выборка.ЗначениеКИ;
			Продолжить;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Emailтрекинг.Количество() = 0 Тогда
		Emailтрекинг.Добавить();
	КонецЕсли;
	
	Если Коллтрекинг.Количество() = 0 Тогда
		Коллтрекинг.Добавить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыОтслеживания()
	
	УдаляемыеЭлементы = Новый Массив;
	УдаляемыеКоманды = Новый Массив;
	// Группа первого контактного лица создана в конфигураторе
	Для ИндексГруппы = 1 По Элементы.Телефоны.ПодчиненныеЭлементы.Количество()-1 Цикл
		УдаляемыеЭлементы.Добавить(Элементы.Телефоны.ПодчиненныеЭлементы[ИндексГруппы]);
	КонецЦикла;
	Для ИндексГруппы = 1 По Элементы.Email.ПодчиненныеЭлементы.Количество()-1 Цикл
		УдаляемыеЭлементы.Добавить(Элементы.Email.ПодчиненныеЭлементы[ИндексГруппы]);
	КонецЦикла;
	Для Каждого УдаляемыйЭлемент Из УдаляемыеЭлементы Цикл
		Элементы.Удалить(УдаляемыйЭлемент);
	КонецЦикла;
	
	Для Каждого Email Из Emailтрекинг Цикл
		
		ИндексПочты = Emailтрекинг.Индекс(Email);
		
		Элементы.Email_0.Доступность = Элементы.Email_0.СписокВыбора.Количество() <> 0;
		
		Если Элементы.Найти("Email_"+ ИндексПочты) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Элементы.Email_0.СписокВыбора.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;

		Если ИндексПочты > 0 Тогда
			
			ГруппаEmail = Элементы.Добавить("ГруппаEmail_" + ИндексПочты, Тип("ГруппаФормы"), Элементы.Email);
			ГруппаEmail.Вид = Элементы.ГруппаEmail_0.Вид;
			ГруппаEmail.Отображение = Элементы.ГруппаEmail_0.Отображение;
			ГруппаEmail.Группировка = Элементы.ГруппаEmail_0.Группировка;
			ГруппаEmail.СквозноеВыравнивание = Элементы.ГруппаEmail_0.СквозноеВыравнивание;
			ГруппаEmail.ОтображатьЗаголовок = Элементы.ГруппаEmail_0.ОтображатьЗаголовок;
			ГруппаEmail.Ширина = Элементы.ГруппаEmail_0.Ширина;
			
			ПолеEmail = Элементы.Добавить("Email_" + ИндексПочты, Тип("ПолеФормы"), ГруппаEmail);
			ПолеEmail.Вид = Элементы.Email_0.Вид;
			ПолеEmail.ПутьКДанным = "Emailтрекинг[" + ИндексПочты + "].ЗначениеКИ";
			ПолеEmail.ПодсказкаВвода = Элементы.Email_0.ПодсказкаВвода;
			ПолеEmail.Заголовок = Элементы.Email_0.Заголовок;
			ПолеEmail.КнопкаВыпадающегоСписка = Элементы.Email_0.КнопкаВыпадающегоСписка;
			ПолеEmail.ПоложениеЗаголовка = Элементы.Email_0.ПоложениеЗаголовка;
			ПолеEmail.АвтоМаксимальнаяШирина = Элементы.Email_0.АвтоМаксимальнаяШирина;
			ПолеEmail.МаксимальнаяШирина = Элементы.Email_0.МаксимальнаяШирина;
			ПолеEmail.СписокВыбора.ЗагрузитьЗначения(Элементы.Email_0.СписокВыбора.ВыгрузитьЗначения());
			ПолеEmail.Доступность = ПолеEmail.СписокВыбора.Количество() <> 0;
			ПолеEmail.РежимВыбораИзСписка = Элементы.Email_0.РежимВыбораИзСписка;
			
		КонецЕсли;
		
	КонецЦикла;

	
	Для Каждого Телефон Из Коллтрекинг Цикл
		
		ИндексТелефона = Коллтрекинг.Индекс(Телефон);
		
		Элементы.Телефон_0.Доступность = ИспользоватьТелефонию;
		
		Если ИспользоватьТелефонию Тогда
			Элементы.Телефон_0.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		КонецЕсли;
		
		Если Элементы.Найти("Телефон_"+ ИндексТелефона) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
				
		Если ИндексТелефона > 0 Тогда
			
			ГруппаТелефон = Элементы.Добавить("ГруппаТелефон_" + ИндексТелефона, Тип("ГруппаФормы"), Элементы.Телефоны);
			ГруппаТелефон.Вид = Элементы.ГруппаТелефон_0.Вид;
			ГруппаТелефон.Отображение = Элементы.ГруппаТелефон_0.Отображение;
			ГруппаТелефон.Группировка = Элементы.ГруппаТелефон_0.Группировка;
			ГруппаТелефон.СквозноеВыравнивание = Элементы.ГруппаТелефон_0.СквозноеВыравнивание;
			ГруппаТелефон.ОтображатьЗаголовок = Элементы.ГруппаТелефон_0.ОтображатьЗаголовок;
			ГруппаТелефон.Ширина = Элементы.ГруппаТелефон_0.Ширина;
			
			ПолеТелефон = Элементы.Добавить("Телефон_" + ИндексТелефона, Тип("ПолеФормы"), ГруппаТелефон);
			ПолеТелефон.Вид = Элементы.Телефон_0.Вид;
			ПолеТелефон.ПутьКДанным = "Коллтрекинг[" + ИндексТелефона + "].ЗначениеКИ";
			ПолеТелефон.ПодсказкаВвода = Элементы.Телефон_0.ПодсказкаВвода;
			ПолеТелефон.Заголовок = Элементы.Телефон_0.Заголовок;
			ПолеТелефон.КнопкаВыпадающегоСписка = Элементы.Телефон_0.КнопкаВыпадающегоСписка;
			ПолеТелефон.ПоложениеЗаголовка = Элементы.Телефон_0.ПоложениеЗаголовка;
			ПолеТелефон.АвтоМаксимальнаяШирина = Элементы.Телефон_0.АвтоМаксимальнаяШирина;
			ПолеТелефон.МаксимальнаяШирина = Элементы.Телефон_0.МаксимальнаяШирина;
			
			ПолеТелефон.Доступность = ИспользоватьТелефонию;
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.Переместить(Элементы.ДобавитьОтслеживание, Элементы.Отслеживание);
	Элементы.ДобавитьОтслеживание.Видимость = Элементы.Телефон_0.Доступность ИЛИ Элементы.Email_0.Доступность;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеОтслеживания()
	
	Если Коллтрекинг.Количество() = 0 И Emailтрекинг.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ОтслеживаниеИсточниковПривлечения.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИсточникПривлечения.Установить(Объект.Ссылка);
	
	Для Каждого КИ Из Emailтрекинг Цикл
		
		Если НЕ ЗначениеЗаполнено(КИ.ЗначениеКИ) Тогда
			Продолжить;
		КонецЕсли;

		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.ИсточникПривлечения = Объект.Ссылка;
		НоваяЗапись.ТипКИ = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
		НоваяЗапись.ЗначениеКИ = КИ.ЗначениеКИ;
	КонецЦикла;
	
	Для Каждого КИ Из Коллтрекинг Цикл
		
		Если НЕ ЗначениеЗаполнено(КИ.ЗначениеКИ) Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.ИсточникПривлечения = Объект.Ссылка;
		НоваяЗапись.ТипКИ = Перечисления.ТипыКонтактнойИнформации.Телефон;
		НоваяЗапись.ЗначениеКИ = КИ.ЗначениеКИ;
		НоваяЗапись.ЗначениеКИДляПоиска = КонтактнаяИнформацияУНФ.ПреобразоватьНомерДляКонтактнойИнформации(КИ.ЗначениеКИ);
		
	КонецЦикла;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораАдресовЭП()
	
	Элементы.Email_0.СписокВыбора.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УчетныеЗаписиЭлектроннойПочты.АдресЭлектроннойПочты КАК АдресЭП
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ЗначениеЗаполнено(Выборка.АдресЭП) Тогда
			Продолжить;
		КонецЕсли;
		
		Элементы.Email_0.СписокВыбора.Добавить(Выборка.АдресЭП, Выборка.АдресЭП);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОтслеживаниеВидВыбран(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныйЭлемент.Значение = "ВидТелефон" Тогда
		Коллтрекинг.Добавить();
	КонецЕсли;
	
	Если ВыбранныйЭлемент.Значение = "ВидЭП" Тогда
		Emailтрекинг.Добавить();
	КонецЕсли;
	
	ОбновитьЭлементыОтслеживания();
	
КонецПроцедуры

#КонецОбласти
