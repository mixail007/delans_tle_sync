
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установим настройки формы для случая открытия в режиме выбора
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	Элементы.Список.МножественныйВыбор = ?(Параметры.ЗакрыватьПриВыборе = Неопределено, Ложь, Не Параметры.ЗакрыватьПриВыборе);
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = "ВыборПодбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе
		КлючНазначенияИспользования = "Список";
	КонецЕсли;

	ПрочитатьИерархию();
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список,,,Новый Структура("ОтборПериод", "ДатаСоздания"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	Список,
	"Недействителен",
	Ложь,
	,
	,
	Не Элементы.ПоказыватьНедействительных.Пометка);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ИсточникиПривлеченияГруппа" Тогда
		
		НоваяГруппа = Неопределено;
		Если ТипЗнч(Параметр) = Тип("Массив") И Параметр.Количество() <> 0 Тогда
			НоваяГруппа = Параметр[0];
		ИначеЕсли ЗначениеЗаполнено(Параметр) Тогда
			НоваяГруппа = Параметр;
		КонецЕсли;
		
		ПрочитатьИерархию(НоваяГруппа);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	//УНФ.ОтборыСписка
	Если НЕ Элементы.Список.РежимВыбора Тогда
		СохранитьНастройкиОтборов();
	КонецЕсли;
	//Конец УНФ.ОтборыСписка
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтборИерархия

&НаКлиенте
Процедура ОтборИерархияПриАктивизацииСтроки(Элемент)
	
	УстановитьОтборПоИерархии(ЭтотОбъект);
		
КонецПроцедуры

&НаКлиенте
Процедура ОтборИерархияНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		Выполнение = Ложь;
		Возврат;
	КонецЕсли;
	
	СтрокаИерархии = ОтборИерархия.НайтиПоИдентификатору(Элемент.ТекущаяСтрока);
	Если СтрокаИерархии = Неопределено
		Или СтрокаИерархии.ГруппаИсточниковПривлечения = "Все"
		Или СтрокаИерархии.ГруппаИсточниковПривлечения = "БезГруппы" Тогда
		
		Выполнение = Ложь;
		Возврат;
	КонецЕсли;
	
	ПараметрыПеретаскивания.Значение = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтрокаИерархии.ГруппаИсточниковПривлечения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборИерархияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если Строка = Неопределено Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
	КонецЕсли;
	
	СтрокаИерархии = ОтборИерархия.НайтиПоИдентификатору(Строка);
	Если СтрокаИерархии = Неопределено Или СтрокаИерархии.ГруппаИсточниковПривлечения = "Все" Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
	КонецЕсли;
	
	ПараметрыПеретаскивания.ДопустимыеДействия	= ДопустимыеДействияПеретаскивания.Перемещение;
	ПараметрыПеретаскивания.Действие			= ДействиеПеретаскивания.Перемещение;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборИерархияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("Массив")
		Или ПараметрыПеретаскивания.Значение.Количество() = 0
		Или ТипЗнч(ПараметрыПеретаскивания.Значение[0]) <> Тип("СправочникСсылка.ИсточникиПривлеченияПокупателей")Тогда
		
		Возврат;
	КонецЕсли;
	
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаИерархии = ОтборИерархия.НайтиПоИдентификатору(Строка);
	Если СтрокаИерархии = Неопределено Или СтрокаИерархии.ГруппаИсточниковПривлечения = "Все" Тогда
		Возврат;
	КонецЕсли;
	
	НоваяГруппа = ?(СтрокаИерархии.ГруппаИсточниковПривлечения = "БезГруппы", ПредопределенноеЗначение("Справочник.ИсточникиПривлеченияПокупателей.ПустаяСсылка"), СтрокаИерархии.ГруппаИсточниковПривлечения);
	ИерархияПеретаскиваниеСервер(ПараметрыПеретаскивания.Значение, НоваяГруппа);
	
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура ИерархияИзменить(Команда)
	
	Если Элементы.ОтборИерархия.ТекущиеДанные = Неопределено
		Или ТипЗнч(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения) <> Тип("СправочникСсылка.ИсточникиПривлеченияПокупателей")
		Или Не ЗначениеЗаполнено(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения) Тогда
		
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(Неопределено, Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияСоздатьГруппу(Команда)
	
	Если Элементы.ОтборИерархия.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	Если ТипЗнч(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения) = Тип("СправочникСсылка.ИсточникиПривлеченияПокупателей") Тогда
		ЗначенияЗаполнения.Вставить("Родитель", Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ИсточникиПривлеченияПокупателей.ФормаГруппы",
		Новый Структура("ЗначенияЗаполнения, ЭтоГруппа", ЗначенияЗаполнения, Истина),
		Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияСкопировать(Команда)
	
	Если Элементы.ОтборИерархия.ТекущиеДанные = Неопределено
		Или ТипЗнч(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения) <> Тип("СправочникСсылка.ИсточникиПривлеченияПокупателей")
		Или Не ЗначениеЗаполнено(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения) Тогда
		
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ИсточникиПривлеченияПокупателей.ФормаГруппы",
		Новый Структура("ЗначениеКопирования, ЭтоГруппа", Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения, Истина),
		Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияУстановитьПометкуУдаления(Команда)
	
	Если Элементы.ОтборИерархия.ТекущиеДанные = Неопределено
		Или ТипЗнч(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения) <> Тип("СправочникСсылка.ИсточникиПривлеченияПокупателей")
		Или Не ЗначениеЗаполнено(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения) Тогда
		
		Возврат;
	КонецЕсли;
	
	ПометкаУдаления = ИзменитьПометкуУдаленияГруппыСервер(Элементы.ОтборИерархия.ТекущиеДанные.ПолучитьИдентификатор());
	
	ТекстОповещения = СтрШаблон(НСтр("ru='Пометка удаления %1'"),
		?(ПометкаУдаления, НСтр("ru='установлена'"), НСтр("ru='снята'")));
		
	ПоказатьОповещениеПользователя(
		ТекстОповещения,
		ПолучитьНавигационнуюСсылку(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения),
		Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения,
		БиблиотекаКартинок.Информация32);
		
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияВключаяВложенные(Команда)
	
	Элементы.ОтборИерархияКонтекстноеМенюИерархияВключаяВложенные.Пометка = Не Элементы.ОтборИерархияКонтекстноеМенюИерархияВключаяВложенные.Пометка;
	УстановитьОтборПоИерархии(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительных(Команда)
	
	Элементы.ПоказыватьНедействительных.Пометка = Не Элементы.ПоказыватьНедействительных.Пометка;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Недействителен",
		Ложь,
		,
		,
		Не Элементы.ПоказыватьНедействительных.Пометка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "ДатаСоздания");
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьОтборыНажатие(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
	
КонецПроцедуры

#КонецОбласти

#Область Иерархия

&НаСервере
Процедура ПрочитатьИерархию(ГруппаТекущейСтроки = Неопределено)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫБОР
		|		КОГДА ИсточникиПривлеченияПокупателей.ПометкаУдаления
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ИндексПиктограммы,
		|	ИсточникиПривлеченияПокупателей.Ссылка КАК ГруппаИсточниковПривлечения,
		|	ПРЕДСТАВЛЕНИЕ(ИсточникиПривлеченияПокупателей.Ссылка) КАК ПредставлениеГруппы
		|ИЗ
		|	Справочник.ИсточникиПривлеченияПокупателей КАК ИсточникиПривлеченияПокупателей
		|ГДЕ
		|	ИсточникиПривлеченияПокупателей.ЭтоГруппа = ИСТИНА
		|
		|УПОРЯДОЧИТЬ ПО
		|	ИсточникиПривлеченияПокупателей.Ссылка ИЕРАРХИЯ
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ЗначениеВРеквизитФормы(Дерево, "ОтборИерархия");
	
	ИдентификаторСтроки = Неопределено;
	Если ГруппаТекущейСтроки <> Неопределено Тогда
		ИдентификаторСтроки = ИдентификаторСтрокиДереваПоЗначению(ОтборИерархия, ГруппаТекущейСтроки);
	КонецЕсли;
	
	Если ИдентификаторСтроки <> Неопределено Тогда
		Элементы.ОтборИерархия.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;
	
	ЭлементыКоллекции = ОтборИерархия.ПолучитьЭлементы();
	
	СтрокаДерева = ЭлементыКоллекции.Вставить(0);
	СтрокаДерева.ИндексПиктограммы = -1;
	СтрокаДерева.ГруппаИсточниковПривлечения = "Все";
	СтрокаДерева.ПредставлениеГруппы = НСтр("ru='<Все группы>'");
	
	СтрокаДерева = ЭлементыКоллекции.Добавить();
	СтрокаДерева.ИндексПиктограммы = -1;
	СтрокаДерева.ГруппаИсточниковПривлечения = "БезГруппы";
	СтрокаДерева.ПредставлениеГруппы = НСтр("ru='<Нет группы>'");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоИерархии(Форма)
	
	Элементы = Форма.Элементы;
	Если Элементы.ОтборИерархия.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоОтборПоГруппе = ТипЗнч(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения) = Тип("СправочникСсылка.ИсточникиПривлеченияПокупателей");
	
	Элементы.ОтборИерархияКонтекстноеМенюИерархияИзменить.Доступность					= ЭтоОтборПоГруппе;
	Элементы.ОтборИерархияКонтекстноеМенюИерархияСкопировать.Доступность				= ЭтоОтборПоГруппе;
	Элементы.ОтборИерархияКонтекстноеМенюИерархияУстановитьПометкуУдаления.Доступность	= ЭтоОтборПоГруппе;
	
	ПравоеЗначение	= Неопределено;
	Сравнение		= ВидСравненияКомпоновкиДанных.Равно;
	Использование	= Истина;
	
	Если ЭтоОтборПоГруппе Тогда
		
		Если Элементы.ОтборИерархияКонтекстноеМенюИерархияВключаяВложенные.Пометка Тогда
			Сравнение = ВидСравненияКомпоновкиДанных.ВИерархии;
		КонецЕсли;
		ПравоеЗначение = Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения;
		
	ИначеЕсли Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения = "Все" Тогда
		
		Использование = Ложь;
		
	ИначеЕсли Элементы.ОтборИерархия.ТекущиеДанные.ГруппаИсточниковПривлечения = "БезГруппы" Тогда
		
		ПравоеЗначение = ПредопределенноеЗначение("Справочник.ИсточникиПривлеченияПокупателей.ПустаяСсылка");
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"Родитель",
		ПравоеЗначение,
		Сравнение,
		,
		Использование
	);
	
	Форма.ОтборИерархияТекущая = ПравоеЗначение;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИзменитьПометкуУдаления(ИсточникПривлечения)
	
	ИсточникПривлеченияОбъект = ИсточникПривлечения.ПолучитьОбъект();
	ИсточникПривлеченияОбъект.УстановитьПометкуУдаления(Не ИсточникПривлеченияОбъект.ПометкаУдаления, Истина);
	
	Возврат ИсточникПривлеченияОбъект.ПометкаУдаления;
	
КонецФункции

&НаСервере
Функция ИзменитьПометкуУдаленияГруппыСервер(ИдентификаторТекущейСтроки)
	
	ТекущаяСтрокаДерева = ОтборИерархия.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	ПометкаУдаления = ИзменитьПометкуУдаления(ТекущаяСтрокаДерева.ГруппаИсточниковПривлечения);
	ИзменитьПиктограммуРекурсивно(ТекущаяСтрокаДерева, ПометкаУдаления);
	
	Возврат ПометкаУдаления;
	
КонецФункции

&НаСервере
Процедура ИзменитьПиктограммуРекурсивно(СтрокаДерева, ПометкаУдаления)
	
	СтрокаДерева.ИндексПиктограммы = ?(ПометкаУдаления, 1, 0);
	
	СтрокиДерева = СтрокаДерева.ПолучитьЭлементы();
	Для Каждого СтрокаПодчиненная Из СтрокиДерева Цикл
		ИзменитьПиктограммуРекурсивно(СтрокаПодчиненная, ПометкаУдаления);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИерархияПеретаскиваниеСервер(МассивИсточников, НоваяГруппа)
	
	УстановитьНовуюГруппуИсточников(МассивИсточников, НоваяГруппа);
	
	Если МассивИсточников[0].ЭтоГруппа Тогда
		
		ПрочитатьИерархию();
		
		ИдентификаторСтроки = 0;
		ОбщегоНазначенияКлиентСервер.ПолучитьИдентификаторСтрокиДереваПоЗначениюПоля(
			"ГруппаИсточниковПривлечения",
			ИдентификаторСтроки,
			ОтборИерархия.ПолучитьЭлементы(),
			МассивИсточников[0],
			Ложь
		);
		Элементы.ОтборИерархия.ТекущаяСтрока = ИдентификаторСтроки;
		
	Иначе
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьНовуюГруппуИсточников(МассивИсточников, НоваяГруппа)
	
	Для Каждого Источник Из МассивИсточников Цикл
		ИсточникОбъект = Источник.ПолучитьОбъект();
		ИсточникОбъект.Родитель = НоваяГруппа;
		ИсточникОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ИдентификаторСтрокиДереваПоЗначению(Коллекция, ИскомоеЗначение)
	
	КоллекцияЭлементов = Коллекция.ПолучитьЭлементы();
	
	Для каждого Элемент Из КоллекцияЭлементов Цикл
		
		Если Элемент.ГруппаИсточниковПривлечения = ИскомоеЗначение Тогда
			Возврат Элемент.ПолучитьИдентификатор();
		КонецЕсли;
		
		Идентификатор = ИдентификаторСтрокиДереваПоЗначению(Элемент, ИскомоеЗначение);
		
		Если Идентификатор <> Неопределено Тогда
			Возврат Идентификатор;
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	ИмяКлючаОбъекта = СтрЗаменить(ЭтотОбъект.ИмяФормы,".","");
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяКлючаОбъекта, ИмяКлючаОбъекта+"_ОтборПоПериоду", ЭтотОбъект.ОтборПериод);
	
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(
		ИмяФормы,
		"ВключаяВложенные",
		Элементы.ОтборИерархияКонтекстноеМенюИерархияВключаяВложенные.Пометка
	);
	
КонецПроцедуры

#КонецОбласти