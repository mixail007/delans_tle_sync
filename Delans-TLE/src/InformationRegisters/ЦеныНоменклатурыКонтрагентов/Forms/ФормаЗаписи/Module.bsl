
&НаСервереБезКонтекста
Функция ВыполняетсяРасчетОчередиЦенВРазделеннойИБ(ВидЦенКонтрагента)
	
	РезультатПроверки = Ложь;
	Если НЕ ОбщегоНазначения.РазделениеВключено() Тогда
		
		Возврат РезультатПроверки;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("Выбрать Истина Из РегистрСведений.СвязиВидовЦенСлужебный КАК СвязиВидовЦен Где СвязиВидовЦен.ВидЦенБазовый = &ВидЦенКонтрагента");
	Запрос.УстановитьПараметр("ВидЦенКонтрагента", ВидЦенКонтрагента);
	
	РезультатВыполненияЗапроса = Запрос.Выполнить();
	Если РезультатВыполненияЗапроса.Пустой() Тогда
		
		Возврат РезультатПроверки;
		
	КонецЕсли;
	
	// Параметры:
	//   ОбластьДанных
	//   Использование
	//   ЗапланированныйМоментЗапуска
	//   ЭксклюзивноеВыполнение.
	//   ИмяМетода - обязательно для указания.
	//   Параметры
	//   Ключ
	//   ИнтервалПовтораПриАварийномЗавершении.
	//   Расписание
	//   КоличествоПовторовПриАварийномЗавершении
	
	ИмяМетода = "ЦенообразованиеСервер.РасчетОчередиЦен";
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ИмяМетода",		ИмяМетода);
	
	ТаблицаНайденныхЗаданий = ОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
	
	Если ТаблицаНайденныхЗаданий.Количество() <> 0 Тогда
		
		Для каждого ЗапланированноеРЗ Из ТаблицаНайденныхЗаданий Цикл
			
			Если ЗапланированноеРЗ.СостояниеЗадания = Перечисления.СостоянияЗаданий.Выполняется Тогда
				
				РезультатПроверки = Истина;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат РезультатПроверки;
	
КонецФункции

&НаСервереБезКонтекста
// Получает набор данных с сервера для процедуры НоменклатураПриИзменении.
//
Функция ПолучитьДанныеНоменклатураПриИзменении(Номенклатура)
	
	Возврат Номенклатура.ЕдиницаИзмерения;
	
КонецФункции // ПолучитьДанныеНоменклатураПриИзменении()	

&НаСервереБезКонтекста
// Получает набор данных с сервера для процедуры ВидЦенПриИзменении.
//
Функция ПолучитьДанныеВидЦенПриИзменении(ВидЦенКонтрагента)
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ВыполняетсяРасчетОчередиЦенВРазделеннойИБ", ВыполняетсяРасчетОчередиЦенВРазделеннойИБ(ВидЦенКонтрагента));
	
	Возврат СтруктураДанных;
	
КонецФункции // ПолучитьДанныеВидЦенПриИзменении()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
// Процедура - обработчик события ПередЗакрытием формы.
//
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если ЗаписьБылЗаписана Тогда
		Оповестить("ИзмененаЦенаКонтрагента", ЗаписьБылЗаписана);
	КонецЕсли;
КонецПроцедуры

&НаСервере
// Процедура - обработчик события ПередЗаписью формы.
//
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Модифицированность Тогда
		ТекущийОбъект.Автор = Пользователи.ТекущийПользователь();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ПослеЗаписи формы.
//
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ЗаписьБылЗаписана = Истина;
КонецПроцедуры

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаписьБылЗаписана = Ложь;
	
	Если ЗначениеЗаполнено(Запись.ВидЦенКонтрагента) Тогда
		Контрагент = Запись.ВидЦенКонтрагента.Владелец;	
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(Запись.ИсходныйКлючЗаписи.ВидЦенКонтрагента) Тогда
		
		Запись.Автор = Пользователи.ТекущийПользователь();
		
		Если Параметры.ЗначенияЗаполнения.Свойство("Контрагент") И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.Контрагент) Тогда
			Контрагент = Параметры.ЗначенияЗаполнения.Контрагент;
		КонецЕсли;
		
		Если Параметры.Свойство("Контрагент") И ЗначениеЗаполнено(Параметры.Контрагент) Тогда
			Контрагент = Параметры.Контрагент;	
		КонецЕсли;
		
		Если Параметры.ЗначенияЗаполнения.Свойство("Номенклатура") И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.Номенклатура) Тогда
			Запись.ЕдиницаИзмерения = Параметры.ЗначенияЗаполнения.Номенклатура.ЕдиницаИзмерения;	
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВыполняетсяРасчетОчередиЦенВРазделеннойИБ(Запись.ВидЦенКонтрагента) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияПредупреждение", "Видимость", Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Номенклатура.
//
Процедура НоменклатураПриИзменении(Элемент)
	
	Запись.ЕдиницаИзмерения = ПолучитьДанныеНоменклатураПриИзменении(Запись.Номенклатура);
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события НачалоВыбора поля ввода ВидЦен.
//
Процедура ВидЦенНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		
		СтандартнаяОбработка = Ложь;
		ТекстСообщения = НСтр("ru = 'Укажите контрагента для выбора видов цен.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , , "Контрагент");
		
	КонецЕсли;
	
КонецПроцедуры // ВидЦенНачалоВыбора()

&НаКлиенте
Процедура ВидЦенПриИзменении(Элемент)
	
	СтруктураДанных = ПолучитьДанныеВидЦенПриИзменении(Запись.ВидЦенКонтрагента);
	Если СтруктураДанных.ВыполняетсяРасчетОчередиЦенВРазделеннойИБ = Истина Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияПредупреждение", "Видимость", Истина);
		
	КонецЕсли;
	
КонецПроцедуры


