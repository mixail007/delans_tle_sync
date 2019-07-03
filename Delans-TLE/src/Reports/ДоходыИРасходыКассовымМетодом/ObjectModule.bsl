#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.ИспользоватьСравнение = Истина;
	НастройкиОтчета.ИспользоватьПериодичность = Истина;
	НастройкиОтчета.ПрограммноеИзменениеФормыОтчета = Истина;
	
	НастройкиВариантов["Основной"].Рекомендуемый = Истина;
	НастройкиВариантов["ДинамикаДоходовИРасходов"].Рекомендуемый = Истина;
	
	ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов);
	УстановитьТегиВариантов(НастройкиВариантов);
	
КонецПроцедуры

Процедура ОбновитьНастройкиНаФорме(НастройкиОтчета, НастройкиСКД, Форма) Экспорт
	
	ДобавитьПолеВыбораПериодичности(НастройкиСКД, Форма);
	
КонецПроцедуры

Процедура ПриИзмененииНестандартногоРеквизита(Тип, ИмяПоля, СтруктураЗначений, НастройкиСКД, Форма, ИмяЭлемента) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов)
	
	МассивПолейСумм = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("Доход,Расход,Прибыль"); 
	
	Для каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		
		ВариантыОформления = НастройкиТекВарианта.Значение.ВариантыОформления;
		ОтчетыУНФ.ДобавитьВариантыОформленияСумм(ВариантыОформления, МассивПолейСумм);
			
	КонецЦикла; 
	
КонецПроцедуры

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Основной"].Теги = НСТР("ru = 'Компания,Доходы,Расходы,Направление деятельности'");
	НастройкиВариантов["ДинамикаДоходовИРасходов"].Теги = НСТР("ru = 'Компания,Доходы,Расходы,Направление деятельности'");
	
КонецПроцедуры

Процедура ДобавитьПолеВыбораПериодичности(НастройкиСКД, Форма)
	
	ЗначениеПараметраПериодичность = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Периодичность");
	
	Если Не ЗначениеЗаполнено(ЗначениеПараметраПериодичность.ИдентификаторПользовательскойНастройки) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрСтПериод = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("СтПериод");
	
	Если ЗначениеЗаполнено(ЗначениеПараметраПериодичность.Значение) Тогда
		ЗначениеПоУмолчанию = ЗначениеПараметраПериодичность.Значение
	Иначе
		ЗначениеПоУмолчанию = УправлениеНебольшойФирмойОтчеты.ПолучитьЗначениеПериодичности(
		ПараметрСтПериод.Значение.ДатаНачала,
		ПараметрСтПериод.Значение.ДатаОкончания);
	КонецЕсли;
	
	Стр = Форма.ПоляНастроек.ПолучитьЭлементы().Добавить();
	Стр.Тип = "Параметр";
	Стр.Поле = "Периодичность";
	Стр.ТипЗначения = Новый ОписаниеТипов("ПеречислениеСсылка.Периодичность");
	Стр.Заголовок = НСтр("ru = 'Периодичность'");
	Стр.ВидЭлемента = "Поле";
	Стр.Реквизиты = Новый Структура;
	Стр.Элементы = Новый Структура;
	Стр.ДополнительныеПараметры = Новый Структура;
	ИмяРеквизита = "ПараметрПериодичность";
	Стр.Реквизиты.Вставить(ИмяРеквизита, ЗначениеПоУмолчанию);
	МассивРеквизитов = Новый Массив;
	Для каждого Элемент Из Стр.Реквизиты Цикл
		МассивРеквизитов.Добавить(Новый РеквизитФормы(Элемент.Ключ, Стр.ТипЗначения,, Стр.Заголовок));
	КонецЦикла;
	Стр.Создан = Истина;
	Форма.ИзменитьРеквизиты(МассивРеквизитов);
	Форма[ИмяРеквизита] = ЗначениеПоУмолчанию;
	НастройкиСКД.ПараметрыДанных.УстановитьЗначениеПараметра(Стр.Поле, ЗначениеПоУмолчанию);
	Элемент = Форма.Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), Форма.Элементы.ГруппаПараметрыЭлементы);
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	Элемент.ПутьКДанным = ИмяРеквизита;
	Элемент.КнопкаОткрытия = Ложь;
	Элемент.КнопкаВыбора = Ложь;
	Элемент.КнопкаСоздания = Ложь;
	Элемент.БыстрыйВыбор = Истина;
	Элемент.ЦветРамки = ЦветаСтиля.НедоступныеДанныеЦвет;
	Элемент.ПодсказкаВвода = Стр.Заголовок;
	Элемент.Ширина = 23;
	Элемент.ОтображениеКнопкиВыбора = ОтображениеКнопкиВыбора.ОтображатьВПолеВвода;
	Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_ПараметрПриИзменении");
	Стр.Элементы.Вставить(Элемент.Имя, Элемент.ПутьКДанным);
	
	ПереместитьВнизЭлементВыводитьЗаголовок(Форма);
	
КонецПроцедуры

Процедура ПереместитьВнизЭлементВыводитьЗаголовок(Знач Форма)
	
	Для Каждого ТекСтрокаРеквизит Из Форма.ПоляНастроек.ПолучитьЭлементы() Цикл
		
		Если НЕ ТекСтрокаРеквизит.Тип = "Параметр" Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ТекСтрокаЭлемент Из ТекСтрокаРеквизит.Элементы Цикл
			
			Если ТекСтрокаРеквизит.Поле = "ВыводитьЗаголовок" Тогда
				Форма.Элементы.Переместить(Форма.Элементы[ТекСтрокаЭлемент.Ключ], Форма.Элементы.ГруппаПараметрыЭлементы);
				Возврат;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

ЭтоОтчетУНФ = Истина;

#КонецЕсли