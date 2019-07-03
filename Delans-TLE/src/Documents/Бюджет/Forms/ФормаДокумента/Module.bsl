
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	
	Компания = УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Объект.Организация);
	
	Периодичность = ПериодичностьСценарияПланирования(Объект.СценарийПланирования);
	
	Пользователь = Пользователи.ТекущийПользователь();
	
	ЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, "ОсновноеПодразделение");
	ОсновноеПодразделение = ?(ЗначениеЗаполнено(ЗначениеНастройки), ЗначениеНастройки, Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение);
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УправлениеНебольшойФирмойСервер.НастроитьФормуОбъектаМобильныйКлиент(Элементы, "Остатки,ПрямыеЗатраты,КосвенныеЗатраты,Поступления,Выбытия,Доходы,Расходы,Операции");
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ДатаПриИзменении()

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	// Обработка события изменения организации.
	Объект.Номер = "";
	СтруктураДанные = ПолучитьДанныеОрганизацияПриИзменении(Объект.Организация);
	Компания = СтруктураДанные.Компания;
	
КонецПроцедуры // ОрганизацияПриИзменении()

&НаКлиенте
Процедура СценарийПланированияПриИзменении(Элемент)
	
	Периодичность = ПериодичностьСценарияПланирования(Объект.СценарийПланирования);
	ВыровнятьДатуПланирования();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	ВыровнятьДатуПланирования();
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	ВыровнятьДатуПланирования();
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицФормы

&НаКлиенте
Процедура ПрямыеЗатратыДатаПланированияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СценарийПланирования)
	   И Элементы.ПрямыеЗатраты.ТекущиеДанные.ДатаПланирования <> '00010101' Тогда
		
		ВыровнятьДатуПланированияПоПериодуПланирования(Элементы.ПрямыеЗатраты.ТекущиеДанные.ДатаПланирования);	
		
	КонецЕсли;	

КонецПроцедуры // ПоступленияДатаПланированияПриИзменении()

&НаКлиенте
Процедура КосвенныеЗатратыДатаПланированияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СценарийПланирования)
	   И Элементы.КосвенныеЗатраты.ТекущиеДанные.ДатаПланирования <> '00010101' Тогда
		
		ВыровнятьДатуПланированияПоПериодуПланирования(Элементы.КосвенныеЗатраты.ТекущиеДанные.ДатаПланирования);	
		
	КонецЕсли;	

КонецПроцедуры // КосвенныеЗатратыДатаПланированияПриИзменении()

&НаКлиенте
Процедура ДоходыДатаПланированияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СценарийПланирования)
	   И Элементы.Доходы.ТекущиеДанные.ДатаПланирования <> '00010101' Тогда
		
		ВыровнятьДатуПланированияПоПериодуПланирования(Элементы.Доходы.ТекущиеДанные.ДатаПланирования);	
		
	КонецЕсли;	

КонецПроцедуры // ДоходыДатаПланированияПриИзменении()

&НаКлиенте
Процедура ДоходыСчетПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Доходы.ТекущиеДанные;
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("Счет", СтрокаТабличнойЧасти.Счет);
	
	СтруктураДанные = ПолучитьДанныеТипСчета(СтруктураДанные);
		
	Если СтруктураДанные.ТипСчетаПрочие Тогда
		СтрокаТабличнойЧасти.СтруктурнаяЕдиница = Неопределено;
		СтрокаТабличнойЧасти.НаправлениеДеятельности = ПредопределенноеЗначение("Справочник.НаправленияДеятельности.Прочее");
	Иначе
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтруктурнаяЕдиница) Тогда
			СтрокаТабличнойЧасти.СтруктурнаяЕдиница = ОсновноеПодразделение;
		КонецЕсли;
		СтрокаТабличнойЧасти.НаправлениеДеятельности = Неопределено;
	КонецЕсли;
	
КонецПроцедуры // ДоходыСчетПриИзменении()

&НаКлиенте
Процедура РасходыДатаПланированияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СценарийПланирования)
	   И Элементы.Расходы.ТекущиеДанные.ДатаПланирования <> '00010101' Тогда
		
		ВыровнятьДатуПланированияПоПериодуПланирования(Элементы.Расходы.ТекущиеДанные.ДатаПланирования);	
		
	КонецЕсли;	

КонецПроцедуры // РасходыДатаПланированияПриИзменении()

&НаКлиенте
Процедура РасходыСчетПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Расходы.ТекущиеДанные;
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("Счет", СтрокаТабличнойЧасти.Счет);
	
	СтруктураДанные = ПолучитьДанныеТипСчета(СтруктураДанные);
		
	Если СтруктураДанные.ТипСчетаПрочие Тогда
		СтрокаТабличнойЧасти.СтруктурнаяЕдиница = Неопределено;
		СтрокаТабличнойЧасти.НаправлениеДеятельности = ПредопределенноеЗначение("Справочник.НаправленияДеятельности.Прочее");
	Иначе
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтруктурнаяЕдиница) Тогда
			СтрокаТабличнойЧасти.СтруктурнаяЕдиница = ОсновноеПодразделение;
		КонецЕсли;
		СтрокаТабличнойЧасти.НаправлениеДеятельности = Неопределено;
	КонецЕсли;
	
КонецПроцедуры // РасходыСчетПриИзменении()

&НаКлиенте
Процедура ПоступленияДатаПланированияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СценарийПланирования)
	   И Элементы.Поступления.ТекущиеДанные.ДатаПланирования <> '00010101' Тогда
		
		ВыровнятьДатуПланированияПоПериодуПланирования(Элементы.Поступления.ТекущиеДанные.ДатаПланирования);	
		
	КонецЕсли;	

КонецПроцедуры // ПоступленияДатаПланированияПриИзменении()

&НаКлиенте
Процедура ВыбытияДатаПланированияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СценарийПланирования)
	   И Элементы.Выбытия.ТекущиеДанные.ДатаПланирования <> '00010101' Тогда
	   
		ВыровнятьДатуПланированияПоПериодуПланирования(Элементы.Выбытия.ТекущиеДанные.ДатаПланирования);	
		
	КонецЕсли;	

КонецПроцедуры // ВыбытияДатаПланированияПриИзменении()

&НаКлиенте
Процедура ОперацииДатаПланированияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СценарийПланирования)
	   И Элементы.Операции.ТекущиеДанные.ДатаПланирования <> '00010101' Тогда
		
		ВыровнятьДатуПланированияПоПериодуПланирования(Элементы.Операции.ТекущиеДанные.ДатаПланирования);	
		
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением)
	
	РазностьДат = УправлениеНебольшойФирмойСервер.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура();
	
	СтруктураДанные.Вставить(
		"РазностьДат",
		РазностьДат
	);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДатаПриИзменении()

&НаСервереБезКонтекста
Функция ПолучитьДанныеОрганизацияПриИзменении(Организация)
	
	СтруктураДанные = Новый Структура();
	
	СтруктураДанные.Вставить(
		"Компания",
		УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация)
	);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеОрганизацияПриИзменении()

&НаСервереБезКонтекста
Функция ПериодичностьСценарияПланирования(СценарийПланирования)
	
	Если Не ЗначениеЗаполнено(СценарийПланирования) Тогда
		Возврат Перечисления.Периодичность.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СценарийПланирования, "Периодичность");
	
КонецФункции // ПолучитьДанныеПериодаПланирования()

&НаКлиенте
Процедура ВыровнятьДатуПланированияПоПериодуПланирования(ДатаПланирования)
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		
		ДатаПланирования = НачалоНедели(ДатаПланирования);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		
		Если День(ДатаПланирования) < 11 Тогда
			
			ДатаПланирования = Дата(Год(ДатаПланирования), Месяц(ДатаПланирования), 1);
			
		ИначеЕсли День(ДатаПланирования) < 21 Тогда	
			
			ДатаПланирования = Дата(Год(ДатаПланирования), Месяц(ДатаПланирования), 11);
			
		Иначе
			
			ДатаПланирования = Дата(Год(ДатаПланирования), Месяц(ДатаПланирования), 21);
			
		КонецЕсли;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		ДатаПланирования = НачалоМесяца(ДатаПланирования);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		
		ДатаПланирования = НачалоКвартала(ДатаПланирования);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		
		МесяцДатыНачала = Месяц(ДатаПланирования);
		
		ДатаПланирования = НачалоГода(ДатаПланирования);
		
		Если МесяцДатыНачала > 6 Тогда
			
			ДатаПланирования = ДобавитьМесяц(ДатаПланирования, 6);
			
		КонецЕсли;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		
		ДатаПланирования = НачалоГода(ДатаПланирования);
		
	Иначе
		
		ДатаПланирования = '00010101';
		
	КонецЕсли;
	
	Если Объект.ДатаНачала <> '00010101'
		И (ДатаПланирования < Объект.ДатаНачала
		ИЛИ ДатаПланирования > Объект.ДатаОкончания) Тогда
		
		ДатаПланирования = Объект.ДатаНачала;
		
	КонецЕсли;
	
КонецПроцедуры // ВыровнятьДатуПланированияПоПериодуПланирования()

&НаКлиенте
Процедура ВыровнятьДатуПланирования()
	
	Для каждого СтрокаТабличнойЧасти Из Объект.ПрямыеЗатраты Цикл
		ВыровнятьДатуПланированияПоПериодуПланирования(СтрокаТабличнойЧасти.ДатаПланирования);
	КонецЦикла;
	
	Для каждого СтрокаТабличнойЧасти Из Объект.КосвенныеЗатраты Цикл
		ВыровнятьДатуПланированияПоПериодуПланирования(СтрокаТабличнойЧасти.ДатаПланирования);
	КонецЦикла;
	
	Для каждого СтрокаТабличнойЧасти Из Объект.Доходы Цикл
		ВыровнятьДатуПланированияПоПериодуПланирования(СтрокаТабличнойЧасти.ДатаПланирования);
	КонецЦикла;
	
	Для каждого СтрокаТабличнойЧасти Из Объект.Расходы Цикл
		ВыровнятьДатуПланированияПоПериодуПланирования(СтрокаТабличнойЧасти.ДатаПланирования);
	КонецЦикла;
	
	Для каждого СтрокаТабличнойЧасти Из Объект.Поступления Цикл
		ВыровнятьДатуПланированияПоПериодуПланирования(СтрокаТабличнойЧасти.ДатаПланирования);
	КонецЦикла;
	
	Для каждого СтрокаТабличнойЧасти Из Объект.Выбытия Цикл
		ВыровнятьДатуПланированияПоПериодуПланирования(СтрокаТабличнойЧасти.ДатаПланирования);
	КонецЦикла;
	
	Для каждого СтрокаТабличнойЧасти Из Объект.Операции Цикл
		ВыровнятьДатуПланированияПоПериодуПланирования(СтрокаТабличнойЧасти.ДатаПланирования);
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеТипСчета(СтруктураДанные)
	
	Если СтруктураДанные.Счет.ТипСчета = Перечисления.ТипыСчетов.ПрочиеДоходы
		ИЛИ СтруктураДанные.Счет.ТипСчета = Перечисления.ТипыСчетов.ПрочиеРасходы
		ИЛИ СтруктураДанные.Счет.ТипСчета = Перечисления.ТипыСчетов.ПроцентыПоКредитам Тогда
	
		СтруктураДанные.Вставить("ТипСчетаПрочие", Истина);
		
	Иначе
		
		СтруктураДанные.Вставить("ТипСчетаПрочие", Ложь);
		
	КонецЕсли;	
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеТипСчета()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти