
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ЭлектронноеВзаимодействиеСлужебный.УстановитьУсловноеОформлениеДереваМаршрута(ЭтотОбъект, "ДеревоМаршрутаПодписания");
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Объект = Параметры.Объект;
	
	СообщениеОбмена = ОбменСБанкамиСлужебный.СообщениеОбменаПоВладельцу(Объект);
	
	Если ЗначениеЗаполнено(СообщениеОбмена) Тогда
		НастройкаОбмена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СообщениеОбмена, "НастройкаОбмена");
	КонецЕсли;
	
	ЗаполнитьТаблицуЭП();
	
	Состояние = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СообщениеОбмена, "Состояние");
	
	Элементы.ГруппаМаршрутПодписания.Видимость = Состояние = Перечисления.СостоянияОбменСБанками.НаПодписи;
	
	КлючСохраненияПоложенияОкна = Строка(Элементы.ГруппаМаршрутПодписания.Видимость);
	
	ОбновитьДеревоМаршрутаПодписания();
	
	Элементы.ПроверитьПодписи.Видимость = ЭП.Количество();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСертификат(Команда)
	
	Если Элементы.ЭП.ТекущиеДанные <> Неопределено Тогда
		ПоказатьСертификат(Элементы.ЭП.ТекущиеДанные.Отпечаток);
	Иначе
		ОчиститьСообщения();
		ТекстОшибки = НСтр("ru = 'Выберите сертификат в списке установленных подписей.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодписи(Команда)
	
	ОчиститьСообщения();
	Оповещение = Новый ОписаниеОповещения("ОбновитьДанныеФормыПослеПроверкиПодписей", ЭтотОбъект);
	МассивСообщенийОбмена = Новый Массив;
	МассивСообщенийОбмена.Добавить(СообщениеОбмена);
	ОбменСБанкамиСлужебныйКлиент.ОпределитьСтатусыПодписейСбербанк(Оповещение, НастройкаОбмена, МассивСообщенийОбмена);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПоказатьСертификат(Отпечаток)
	
	АдресДанныхСертификата = АдресДанныхСертификата(СообщениеОбмена, Отпечаток, УникальныйИдентификатор);
	
	СтруктураСертификата = СтруктураСертификата(АдресДанныхСертификата);
	Если СтруктураСертификата <> Неопределено Тогда
		ПараметрыФормы = Новый Структура(
			"СтруктураСертификата, Отпечаток, АдресСертификата", СтруктураСертификата, Отпечаток, АдресДанныхСертификата);
		ОткрытьФорму("ОбщаяФорма.Сертификат", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция АдресДанныхСертификата(СообщениеОбмена, Отпечаток, УникальныйИдентификатор)
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЭП.Сертификат
	|ИЗ
	|	РегистрСведений.ЭлектронныеПодписи КАК ЭП
	|ГДЕ
	|	ЭП.Отпечаток = &Отпечаток
	|	И ЭП.ПодписанныйОбъект.ВладелецФайла = &ВладелецФайла";
	
	Запрос.УстановитьПараметр("Отпечаток", Отпечаток);
	Запрос.УстановитьПараметр("ВладелецФайла", СообщениеОбмена);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ДвоичныеДанныеСертификата = Выборка.Сертификат.Получить();
	
	Возврат ПоместитьВоВременноеХранилище(ДвоичныеДанныеСертификата, УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьДанныеФормыПослеПроверкиПодписей(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат);
	КонецЕсли;
	
	ЗаполнитьТаблицуЭП();
	ОбновитьОтображениеДанных();

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрограммаБанка(Знач НастройкаОбмена)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаОбмена, "ПрограммаБанка");
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭПСтатус.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЭП.ПодписьВерна");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(255, 0, 0));
	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтруктураСертификата(Знач АдресДанныхСертификата)
	
	ДвоичныеДанныеСертификата = ПолучитьИзВременногоХранилища(АдресДанныхСертификата);

	ВыбранныйСертификат = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
	Если ВыбранныйСертификат = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Сертификат не найден'"));
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ЭлектроннаяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(ВыбранныйСертификат);
	
КонецФункции


&НаСервере
Процедура ЗаполнитьТаблицуЭП()
	
	УстановитьПривилегированныйРежим(Истина);

	ТаблицаЭП = РеквизитФормыВЗначение("ЭП");
	ТаблицаЭП.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЭП.КомуВыданСертификат КАК КомуВыданСертификат,
	|	ЭП.ДатаПроверкиПодписи КАК ДатаПроверкиПодписи,
	|	ЭП.ПодписьВерна КАК ПодписьВерна,
	|	ЭП.ДатаПодписи КАК ДатаПодписи,
	|	ЭП.Отпечаток КАК Отпечаток,
	|	ЭП.ПорядковыйНомер КАК НомерСтроки,
	|	ЭП.УстановившийПодпись КАК УстановившийПодпись
	|ИЗ
	|	РегистрСведений.ЭлектронныеПодписи КАК ЭП
	|ГДЕ
	|	ЭП.ПодписанныйОбъект.ВладелецФайла = &ВладелецФайла";
	
	Запрос.УстановитьПараметр("ВладелецФайла", СообщениеОбмена);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ТаблицаЭП.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		ЗаполнитьСтатусПодписи(НоваяСтрока, Выборка);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ТаблицаЭП, "ЭП");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "КомандаПроверитьПодписи", "Видимость", ЭП.Количество());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатусПодписи(НоваяСтрока, ТекСтрока)
	
	Если ЗначениеЗаполнено(ТекСтрока.ДатаПроверкиПодписи) Тогда
		НоваяСтрока.Представление = ?(ТекСтрока.ПодписьВерна, НСтр("ru = 'Верна'"), НСтр("ru = 'Неверна'"))
			+" (" + ТекСтрока.ДатаПроверкиПодписи + ")";
	Иначе
		НоваяСтрока.Представление = НСтр("ru = 'Не проверена'");
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоМаршрутаПодписания()

	Если Состояние = Перечисления.СостоянияОбменСБанками.НаПодписи Тогда
		ЭлектронноеВзаимодействиеСлужебный.ЗаполнитьДеревоМаршрутаНаФорме(
			ЭтотОбъект, СообщениеОбмена, "ДеревоМаршрутаПодписания");
	Иначе
		ДеревоМаршрутаПодписания.ПолучитьЭлементы().Очистить();
		Статус = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект, "Статус");
		
		Если Статус = Перечисления.СтатусыОбменСБанками.Сформирован ИЛИ Статус = Перечисления.СтатусыОбменСБанками.Черновик Тогда
			ПараметрыОбмена = ОбменСБанкамиСлужебныйВызовСервера.ПараметрыОбменаПоВидуЭД(
				НастройкаОбмена, Перечисления.ВидыЭДОбменСБанками.Письмо);
			Если ЗначениеЗаполнено(ПараметрыОбмена.МаршрутПодписания) Тогда
				ТаблицаМаршрута = ПараметрыОбмена.МаршрутПодписания.ТаблицаТребований.Выгрузить();
				
				ЭлектронноеВзаимодействиеСлужебный.ЗаполнитьДеревоМаршрутаНаФорме(ЭтотОбъект, ТаблицаМаршрута, 
					"ДеревоМаршрутаПодписания");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры



#КонецОбласти