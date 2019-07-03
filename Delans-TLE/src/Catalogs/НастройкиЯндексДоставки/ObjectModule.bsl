#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		ДанныеЗаполнения = Новый Структура;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И Не ДанныеЗаполнения.Свойство("Организация") Тогда
		ДанныеЗаполнения.Вставить("Организация", Справочники.Организации.ОрганизацияПоУмолчанию());
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если НастройкаПоОрганизацииСуществует() Тогда
		ОбщегоНазначения.СообщитьПользователю(
		СтрШаблон(НСтр("ru = 'Настройка по организации ""%1"" существует!'"), Организация),,
		"Организация",
		"Объект",
		Отказ);
		Возврат;
	КонецЕсли;
	
	Наименование = СтрШаблон(
	НСтр("ru = 'Настройка для ""%1""'"),
	ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "Наименование"));
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		УстановитьПараметрыРазделенногоЗадания();
		
	Иначе
		
		УстановитьПараметрыНеразделенногоЗадания();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		УдалитьРазделенноеЗадание();
		
	Иначе
		
		УдалитьНеразделенноеЗадание();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НастройкаПоОрганизацииСуществует()
	
	Если ПометкаУдаления Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НастройкиЯндексДоставки.Ссылка
	|ИЗ
	|	Справочник.НастройкиЯндексДоставки КАК НастройкиЯндексДоставки
	|ГДЕ
	|	НастройкиЯндексДоставки.Организация = &Организация
	|	И НастройкиЯндексДоставки.Ссылка <> &Ссылка
	|	И НЕ НастройкиЯндексДоставки.ПометкаУдаления");
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

Процедура УстановитьПараметрыРазделенногоЗадания()
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", ВключитьРегламентноеЗадание());
	ПараметрыЗадания.Вставить("ИмяМетода" , Метаданные.РегламентныеЗадания.ЗагрузкаДанныхИзЯндексДоставки.ИмяМетода);
	ПараметрыЗадания.Вставить("Ключ" , Строка(Ссылка.УникальныйИдентификатор()));
	ПараметрыЗадания.Вставить("Параметры", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПараметрыЗадания.Ключ));
	ПараметрыЗадания.Вставить("Расписание", Расписание.Получить());
	
	Задание = Неопределено;
	
	ТаблицаЗаданий = ОчередьЗаданий.ПолучитьЗадания(Новый Структура("Ключ", ПараметрыЗадания.Ключ));
	Если ТаблицаЗаданий.Количество() <> 0 Тогда
		Задание = ТаблицаЗаданий[0].Идентификатор;
	КонецЕсли;
	
	Если Задание = Неопределено Тогда
		Задание = ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
	Иначе
		ОчередьЗаданий.ИзменитьЗадание(Задание, ПараметрыЗадания);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьПараметрыНеразделенногоЗадания()
	
	Задание = Неопределено;
	
	НайденныеЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Ключ", Строка(Ссылка.УникальныйИдентификатор())));
	Если ЗначениеЗаполнено(НайденныеЗадания) Тогда
		Задание = НайденныеЗадания[0];
	КонецЕсли;
	
	Если Задание = Неопределено Тогда
		Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(Метаданные.РегламентныеЗадания.ЗагрузкаДанныхИзЯндексДоставки);
	КонецЕсли;
	
	Задание.Использование = ВключитьРегламентноеЗадание();
	Задание.Ключ = Строка(Ссылка.УникальныйИдентификатор());
	Задание.Параметры = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Задание.Ключ);
	Задание.Наименование = СтрШаблон("%1 - %2", Метаданные.РегламентныеЗадания.ЗагрузкаДанныхИзЯндексДоставки.Наименование, Наименование);
	Задание.Расписание = Расписание.Получить();
	Задание.Записать();
	
КонецПроцедуры

Функция ВключитьРегламентноеЗадание()
	
	Если ПометкаУдаления Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КлючиМетодов) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Идентификаторы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Состояния) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура УдалитьРазделенноеЗадание()
	
	ОтборЗаданий = Новый Структура;
	ОтборЗаданий.Вставить("Ключ", Строка(Ссылка.УникальныйИдентификатор()));
	ТаблицаЗаданий = ОчередьЗаданий.ПолучитьЗадания(ОтборЗаданий);
	
	Для Каждого ТекСтрока Из ТаблицаЗаданий Цикл
		ОчередьЗаданий.УдалитьЗадание(ТекСтрока.Идентификатор);
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьНеразделенноеЗадание()
	
	ОтборЗаданий = Новый Структура;
	ОтборЗаданий.Вставить("Ключ", Строка(Ссылка.УникальныйИдентификатор()));
	НайденныеЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Ключ", Строка(Ссылка.УникальныйИдентификатор())));
	
	Для Каждого ТекЗадание Из НайденныеЗадания Цикл
		ТекЗадание.Удалить();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли