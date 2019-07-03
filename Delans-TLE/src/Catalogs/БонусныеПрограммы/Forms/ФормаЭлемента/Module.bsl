#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокАвтоСкидок.Параметры.УстановитьЗначениеПараметра("БонуснаяПрограмма", Объект.Ссылка);
	
	ЕстьДействующиеПравилаНачисления = РаботаСБонусами.ЕстьДействующиеПравилаНачисления(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеВидимостьюИДоступностью();
	
	СформироватьПодсказку_1();
	СформироватьПодсказку_2();
	СформироватьПодсказку_3();
	СформироватьПодсказку_4();
	
КонецПроцедуры

#КонецОбласти

#Область СобытияЭлементовШапкиФормы

&НаКлиенте
Процедура УправлениеВидимостьюИДоступностью()
	
	Элементы.ГруппаОтсрочка.Доступность = Объект.ОтсрочкаНачисления;
	Элементы.ГруппаСписание.Доступность = Объект.СписаниеНеиспользованных;
	
	НачислятьНаДР = Объект.НачислятьБонусыНаДеньРождения;
	Элементы.КоличествоБонусовНаДеньРождения.Доступность	= НачислятьНаДР;
	Элементы.ДекорацияБаллов.Доступность					= НачислятьНаДР;
	Элементы.ГруппаДниПередДР.Доступность						= НачислятьНаДР;
	Элементы.ГруппаДниПослеДР.Доступность						= НачислятьНаДР;
	
	Элементы.ДнейПередДнемРождения.Доступность	= Объект.НачислятьПередДнемРождения;
	Элементы.ДнейПослеДняРождения.Доступность	= Объект.СписыватьПослеДняРождения;
	
	Элементы.СписокАвтоСкидок.Видимость = ЕстьДействующиеПравилаНачисления;
	Элементы.ГруппаЗаглушка.Видимость = Не ЕстьДействующиеПравилаНачисления;
	
	ПодсказкаВозврата = НСтр("ru = 'При возврате товаров, оплаченных бонусами, потраченные баллы будут начислены снова%1'");
	ПодсказкаВозврата = СтрШаблон(ПодсказкаВозврата, ?(Объект.СписаниеНеиспользованных, НСтр("ru = ' (будет рассчитана новая дата списания)'"), ""));
	Элементы.ГруппаВозврат.Подсказка = ПодсказкаВозврата;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтсрочкаНачисленияПриИзменении(Элемент)
	
	УправлениеВидимостьюИДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура СписаниеНеиспользованныхПриИзменении(Элемент)
	
	УправлениеВидимостьюИДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура НачислятьПередДнемРожденияПриИзменении(Элемент)
	
	УправлениеВидимостьюИДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура СписыватьПослеДняРожденияПриИзменении(Элемент)
	
	УправлениеВидимостьюИДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьСкидкиПриРасчетеПриИзменении(Элемент)
	
	УправлениеВидимостьюИДоступностью();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьКартинкуДляКомментария", 0.5, Истина);
	
КонецПроцедуры // КомментарийПриИзменении()

&НаКлиенте
Процедура Подключаемый_УстановитьКартинкуДляКомментария()
	
	УправлениеНебольшойФирмойКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.ГруппаДополнительно, Объект.Комментарий);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКНастройке(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗаписьИПереходКНастройкам", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Перед переходом объект будет записан. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
	Иначе
		ПерейтиКНастройкеПродолжение("", "");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписьИПереходКНастройкам(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если Записать() Тогда
			ПерейтиКНастройкеПродолжение("", "");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКНастройкеПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПерейтиКНастройкеЗавершение", ЭтотОбъект);
	ПараметрыОткрытия = Новый Структура("Ключ", Объект.Ссылка);
	ОткрытьФорму("Справочник.БонусныеПрограммы.Форма.ФормаДействующихПравилНачисления", ПараметрыОткрытия, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКНастройкеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	НовоеЗначение = РаботаСБонусами.ЕстьДействующиеПравилаНачисления(Объект.Ссылка);
	Если Не ЕстьДействующиеПравилаНачисления = НовоеЗначение Тогда
		ЕстьДействующиеПравилаНачисления = НовоеЗначение;
		УправлениеВидимостьюИДоступностью();
		СписокАвтоСкидок.Параметры.УстановитьЗначениеПараметра("БонуснаяПрограмма", Объект.Ссылка);
		Элементы.СписокАвтоСкидок.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НачислятьБонусыНаДеньРожденияПриИзменении(Элемент)
	
	УправлениеВидимостьюИДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПодсказку_1()
	
	Подсказка_1 = Новый ФорматированнаяСтрока(НСтр("ru = '1. Настройте параметры бонусной программы на закладке ""Настройки"".'"));
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПодсказку_2()
	
	Подсказка_2 = Новый ФорматированнаяСтрока(НСтр("ru = '2. Создайте правила начисления бонусов на закладке ""Правила начисления"".'"));
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПодсказку_3()
	
	Часть1 = Новый ФорматированнаяСтрока(НСтр("ru = '3. Укажите бонусную программу в карточке '"));
	Часть2 = Новый ФорматированнаяСтрока(НСтр("ru = 'вида дисконтных карт.'"),,,, ПолучитьНавигационнуюСсылку(ПолучитьФорму("Справочник.ВидыДисконтныхКарт.ФормаСписка")));
	
	Подсказка_3 = Новый ФорматированнаяСтрока(Часть1, Часть2);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПодсказку_4()
	
	Часть1 = Новый ФорматированнаяСтрока(НСтр("ru = '4. Настройте оповещения о начислениях и списаниях с помощью '"));
	Часть2 = Новый ФорматированнаяСтрока(НСтр("ru = 'ассистента УНФ.'"),,,, "Ссылка");
	
	Подсказка_4 = Новый ФорматированнаяСтрока(Часть1, Часть2);
	
КонецПроцедуры

&НаКлиенте
Процедура Подсказка4ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("Обработка.АссистентУправления.Форма");
	
КонецПроцедуры

#КонецОбласти