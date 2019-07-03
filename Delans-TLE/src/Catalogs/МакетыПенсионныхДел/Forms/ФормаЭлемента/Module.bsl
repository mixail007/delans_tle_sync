&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	РеестрДокументов = ПредставлениеФайловПоУмолчанию();
	СтраховойНомерПФР = ТекстСсылкиПоУмолчанию();
	АдресРегистрации = ТекстСсылкиПоУмолчанию();
	Телефон = ТекстСсылкиПоУмолчанию();
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗаполнитьДокументыПоУмолчанию();
	Иначе
		ЗаполнитьТаблицуДокументов();
	КонецЕсли;
	
	УстановитьЗаголовокФормы(ЭтотОбъект);
	
	Если ТипЗнч(Объект.Отправитель) = Тип("СправочникСсылка.Организации") Тогда
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.СкрытьЭлементыФормыПриИспользованииОднойОрганизации(ЭтотОбъект, "Отправитель");
	КонецЕсли;
	
	КонтекстЭДО = КонтекстЭДОСервер();
	Элементы.КнопкаОтправить.Видимость = КонтекстЭДО <> Неопределено;
	
	СтатусОтправки = КонтекстЭДО.ПолучитьСтатусОтправкиОбъекта(Объект.Ссылка);	
	ПисьмоОтправлено = ЗначениеЗаполнено(СтатусОтправки) И СтатусОтправки <> Перечисления.СтатусыОтправки.ВКонверте;

	ИмяТипаСотрудник = Объект.Сотрудник.Метаданные().Имя;
	
	УправлениеСсылкамиСотрудника(ЭтотОбъект);
	
	ЕстьПолучатели = ЕстьПолучателиНаСервере(Объект.Организация);
	
	УправлениеФормой(ЭтотОбъект);
	
	ЗаполнитьНастройки(ЭтаФорма);
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт

	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если ПисьмоОтправлено Тогда
		ТекущийЭлемент = Элементы.ГруппаПанельОтправки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_" + ИмяТипаСотрудник И Параметр = Объект.Сотрудник Тогда
		СотрудникПриИзменении(Элементы.Сотрудник);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ЭтоНовый() Тогда
		Ссылка = Справочники.МакетыПенсионныхДел.ПолучитьСсылку();
		ТекущийОбъект.УстановитьСсылкуНового(Ссылка);
	Иначе
		Ссылка = ТекущийОбъект.Ссылка;
	КонецЕсли;
	
	ТекущийОбъект.ЭлектронныеДокументы.Очистить();
	
	СоответствиеФайлов = Новый Соответствие;
	Для Каждого СтрокаТаблицы Из ТаблицаДокументов Цикл
		ДобавитьСтрокуВТаблицуЭлектронныеДокументы(
			ТекущийОбъект, Ссылка, СтрокаТаблицы.Документ, СтрокаТаблицы.Файлы, СоответствиеФайлов);
	КонецЦикла;
	ДобавитьСтрокуВТаблицуЭлектронныеДокументы(
		ТекущийОбъект, Ссылка, "Реестр", ФайлыРеестра, СоответствиеФайлов);

	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("СоответствиеФайлов", СоответствиеФайлов);

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ВсеФайлы = Новый Массив;
	Для Каждого СтрокаТаблицы Из ТекущийОбъект.ЭлектронныеДокументы Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.Файл) Тогда
			ОписаниеФайла = ТекущийОбъект.ДополнительныеСвойства.СоответствиеФайлов[СтрокаТаблицы.Файл];
			
			Если ЗначениеЗаполнено(ОписаниеФайла.АдресФайлаВоВременномХранилище) Тогда
				Если ОбщегоНазначения.СсылкаСуществует(СтрокаТаблицы.Файл) Тогда
					РаботаСФайлами.ОбновитьФайл(СтрокаТаблицы.Файл, ОписаниеФайла);
				Иначе
					ПараметрыФайла = Новый Структура;
					ПараметрыФайла.Вставить("Автор", Неопределено);
					ПараметрыФайла.Вставить("ВладелецФайлов", ТекущийОбъект.Ссылка);
					ПараметрыФайла.Вставить("ИмяБезРасширения", ОписаниеФайла.ИмяБезРасширения);
					ПараметрыФайла.Вставить("РасширениеБезТочки", ОписаниеФайла.Расширение);
					ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Неопределено);
					
					РаботаСФайлами.ДобавитьФайл(
						ПараметрыФайла,
						ОписаниеФайла.АдресФайлаВоВременномХранилище,,,
						СтрокаТаблицы.Файл);
				КонецЕсли;
			КонецЕсли;	
			ВсеФайлы.Добавить(СтрокаТаблицы.Файл);	
		КонецЕсли;
	КонецЦикла;
	
	ВсеСуществующиеФайлы = Новый Массив;
	РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(ТекущийОбъект.Ссылка, ВсеСуществующиеФайлы);
	
	ФайлыКУдалению = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ВсеСуществующиеФайлы, ВсеФайлы);
	Для Каждого ФайлКУдалению Из ФайлыКУдалению Цикл
		ФайлКУдалению.ПолучитьОбъект().Удалить();
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_МакетыПенсионныхДел", , Объект.Ссылка);
	
	УстановитьЗаголовокФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ЕстьРеестр = Ложь;
	КоличествоНеЗаполненныхДокументов = 0;
	Для Каждого СтрокаТаблицы Из ТаблицаДокументов Цикл
		Если Не СтрокаТаблицы.ФайлыВыбраны И ЗначениеЗаполнено(СтрокаТаблицы.Документ) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(НСтр("ru = 'Добавьте файлы для документа ""%1""'"), СтрокаТаблицы.Документ),, 
				СтрШаблон("ТаблицаДокументов[%1].ФайлыПредставление", Формат(ТаблицаДокументов.Индекс(СтрокаТаблицы), "ЧГ=")),, 
				Отказ);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Документ) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(НСтр("ru = 'Заполните вид документа в строке %1'"), ТаблицаДокументов.Индекс(СтрокаТаблицы) + 1),,
				СтрШаблон("ТаблицаДокументов[%1].Документ", Формат(ТаблицаДокументов.Индекс(СтрокаТаблицы), "ЧГ=")),, 
				Отказ);
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтправительПриИзменении(Элемент)
	
	Объект.Организация = Объект.Отправитель;
	ПроверитьПолучателей(Объект.Организация);
	ЗаполнитьНастройки(ЭтаФорма);
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПолучательПриИзменении(Элемент)
	
	ЗаполнитьНастройки(ЭтаФорма);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	СведенияОСотруднике = ПолучитьСведенияОСотрудникеНаСервере(Объект.Сотрудник);
	
	Объект.СтраховойНомерПФР = СведенияОСотруднике.СНИЛС;
	Объект.АдресРегистрации = СведенияОСотруднике.АдресРегистрации;
	Объект.Телефон = СведенияОСотруднике.Телефон;
	Объект.ФИО = СведенияОСотруднике.Фамилия + " " + СведенияОСотруднике.Имя + ?(ЗначениеЗаполнено(СведенияОСотруднике.Отчество), " " + СведенияОСотруднике.Отчество, "");
	
	ЗаполнитьОрганПФРПоМестуНазначенияПенсии();
	УстановитьНаименование();
	УправлениеСсылкамиСотрудника(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСведенияОСотрудникеНаСервере(Сотрудник)
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("Фамилия");
	МассивПоказателей.Добавить("Имя");
	МассивПоказателей.Добавить("Отчество");
	МассивПоказателей.Добавить("СНИЛС");
	МассивПоказателей.Добавить("АдресРегистрации");
	МассивПоказателей.Добавить("Телефон");
	
	СведенияОСотруднике = ЭлектронныйДокументооборотСКонтролирующимиОрганами.ПолучитьСведенияОСотруднике(Сотрудник, МассивПоказателей);
	
	Возврат СведенияОСотруднике;
	
КонецФункции

&НаКлиенте
Процедура СотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	Оповещение = Новый ОписаниеОповещения("СотрудникПослеВыбораИзСписка", ЭтотОбъект);
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ВыбратьСотрудникаИзСписка(
		Оповещение, Объект.Сотрудник, Объект.Отправитель, ЭтаФорма, СтандартнаяОбработка);
	
КонецПроцедуры
	
&НаКлиенте
Процедура СотрудникПослеВыбораИзСписка(Результат, ВходящийКонтекст) Экспорт
	
	Объект.Сотрудник = Результат;
	СотрудникПриИзменении(Элементы.Сотрудник);
	
КонецПроцедуры

&НаКлиенте
Процедура СтраховойНомерПФРНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Если Не ПроверитьЗаполнениеПоляСотрудник() Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("СтраховойНомерПФРНажатиеЗавершение", ЭтотОбъект);
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьФормуСотрудникаНаРеквизите(
		Оповещение,
		ЭтотОбъект,
		Объект.Сотрудник,
		Объект.СтраховойНомерПФР,
		"СНИЛС");
	
КонецПроцедуры
	
&НаКлиенте
Процедура СтраховойНомерПФРНажатиеЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Объект.СтраховойНомерПФР = Результат.СНИЛС;
		Модифицированность = Истина;
		
		УстановитьНаименование();		
		УправлениеСсылкамиСотрудника(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресРегистрацииНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Не ПроверитьЗаполнениеПоляСотрудник() Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("АдресНажатиеЗавершение", ЭтотОбъект, Новый Структура("Реквизит", "АдресРегистрации"));
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьФормуСотрудникаНаРеквизите(
		Оповещение,
		ЭтотОбъект,
		Объект.Сотрудник,
		Объект.АдресРегистрации,
		"АдресРегистрации");
	
КонецПроцедуры

&НаКлиенте
Процедура АдресНажатиеЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Объект[ВходящийКонтекст.Реквизит] = Результат.Представление;
		ЗаполнитьОрганПФРПоМестуНазначенияПенсии();
		УправлениеСсылкамиСотрудника(ЭтотОбъект);
		Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры
	
&НаКлиенте
Процедура ТелефонНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Не ПроверитьЗаполнениеПоляСотрудник() Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ТелефонЗавершение", ЭтотОбъект, Новый Структура("Реквизит", "Телефон"));
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьФормуСотрудникаНаРеквизите(
		Оповещение,
		ЭтотОбъект,
		Объект.Сотрудник,
		Объект.Телефон,
		"Телефон");
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Объект[ВходящийКонтекст.Реквизит] = Результат.Представление;
		УправлениеСсылкамиСотрудника(ЭтотОбъект);
		Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СсылкаРеестрДокументовНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФайлыДляПросмотра(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаДокументов

&НаКлиенте
Процедура РеестрДокументов(Команда)
	
	Объект.ЭлектронныеДокументы.Очистить();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если (Модифицированность ИЛИ Параметры.Ключ.Пустая()) И Не Записать() Тогда
		Возврат;
	КонецЕсли;
		
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Справочник.МакетыПенсионныхДел", "РеестрДокументов", Объект.Ссылка, ЭтотОбъект); 
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьТребованияКИзображениямНажатие(Элемент)
	
	Если ПроверитьЗаполнениеПоляПолучатель() Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ДопустимыеТипыФайлов", ДопустимыеТипыФайлов);
		ПараметрыФормы.Вставить("МаксимальныйРазмерФайла", МаксимальныйРазмерФайла);
		
		ОткрытьФорму("Справочник.МакетыПенсионныхДел.Форма.ТребованияКИзображениям", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = Элементы.ТаблицаДокументовФайлыПредставление.Имя Тогда
		ОткрытьФайлыДляПросмотра(Элемент, ВыбраннаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если НЕ ПроверитьЗаполнениеПоляПолучатель() Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока И Не ОтменаРедактирования Тогда
		Элемент.ТекущиеДанные.ФайлыПредставление = ПредставлениеФайловПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовДокументНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗаполнитьСписокВыбораДокументов(ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовДокументАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если Ожидание > 0 Тогда
		ЗаполнитьСписокВыбораДокументов(ДанныеВыбора, СтандартнаяОбработка, Текст);	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОтправить(Команда)

	Если (Модифицированность ИЛИ Параметры.Ключ.Пустая()) 
		И Не Записать() ИЛИ Не ПроверитьЗаполнение() Тогда
		Возврат;	
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандаОтправитьПослеПолученияКонтекстаЭДО", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтправитьПослеПолученияКонтекстаЭДО(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = Результат.КонтекстЭДО;
	
	ДополнительныеПараметры = Новый Структура("КонтекстЭДО", КонтекстЭДО);
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандаОтправитьПослеВыполнения", ЭтотОбъект, ДополнительныеПараметры);
	
	КонтекстЭДО.ОтправкаМакетаПенсионногоДелаИЗаявления(Объект.Ссылка, Объект.Организация, ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура КомандаОтправитьПослеВыполнения(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = ДополнительныеПараметры.КонтекстЭДО;
	
	// Перерисовка статуса отправки в форме Отчетность
	ПараметрыОповещения = Новый Структура; 
	ПараметрыОповещения.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыОповещения.Вставить("Организация", Объект.Организация);
	Оповестить("Завершение отправки в контролирующий орган", ПараметрыОповещения, Объект.Ссылка);
	
	СтатусОтправки = КонтекстЭДО.ПолучитьСтатусОтправкиОбъекта(Объект.Ссылка);	
	ПисьмоОтправлено = ЗначениеЗаполнено(СтатусОтправки) И СтатусОтправки <> ПредопределенноеЗначение("Перечисление.СтатусыОтправки.ВКонверте");
	Если ПисьмоОтправлено Тогда
		Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыПисем.Отправленное");
		Объект.ДатаОтправки = ОбщегоНазначенияКлиент.ДатаСеанса();
		Записать();
	КонецЕсли;
	
	Если Открыта() И ПисьмоОтправлено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПрорисоватьСтатус(Форма)
	
	ВидКонтролирующегоОргана = ИмяТекущегоТипаПолучателя();
	
	ПараметрыПрорисовкиПанелиОтправки = ДокументооборотСКОВызовСервера.ПараметрыПрорисовкиПанелиОтправки(Форма.Объект.Ссылка, Форма.Объект.Организация, ВидКонтролирующегоОргана);
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПрименитьПараметрыПрорисовкиПанелиОтправки(Форма, ПараметрыПрорисовкиПанелиОтправки);
		
КонецПроцедуры

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, ИмяТекущегоТипаПолучателя());
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, ИмяТекущегоТипаПолучателя());
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, ИмяТекущегоТипаПолучателя());
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, ИмяТекущегоТипаПолучателя());
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, ИмяТекущегоТипаПолучателя());
КонецПроцедуры

#КонецОбласти

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;

	ПрорисоватьСтатус(Форма);
	
	Элементы.КнопкаЗаписать.ТолькоВоВсехДействиях = Форма.ПисьмоОтправлено;
	Элементы.КнопкаОтправить.Видимость = Не Форма.ПисьмоОтправлено;
	
	Элементы.ГруппаШапка.ТолькоПросмотр = Форма.ПисьмоОтправлено;
	Элементы.ГруппаДокументы.ТолькоПросмотр = Форма.ПисьмоОтправлено;
	
	Элементы.ГруппаДокументыКоманднаяПанель.Видимость = Не Форма.ПисьмоОтправлено;
	
	Если Форма.ПисьмоОтправлено Тогда
		Элементы.Отправитель.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.Получатель.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.Сотрудник.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.ДатаВыходаНаПенсию.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.Стаж.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.ОрганПФРПоМестуНазначенияПенсии.Вид = ВидПоляФормы.ПолеНадписи;

		Элементы.ОрганПФРПоМестуНазначенияПенсии.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		
		Элементы.СтраховойНомерПФР.Гиперссылка = Ложь; 
		Элементы.АдресРегистрации.Гиперссылка = Ложь;
		Элементы.Телефон.Гиперссылка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокФормы(Форма)
	
	Если Не Форма.Параметры.Ключ.Пустая() Тогда
		Форма.Заголовок = Форма.Объект.Наименование;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КонтекстЭДОСервер(ТекстСоощения = "")
	
	ТекстСообщения = "";
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДОСервер = Неопределено Тогда 
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось получить текст вложения с именем
                                         |%1.'"), ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат КонтекстЭДОСервер;
		
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяТекущегоТипаПолучателя()
	
	Возврат "ПФР";
	
КонецФункции

&НаКлиенте
Процедура ДокументыВыборПослеВыбораФайла(Результат, ВходящийКонтекст) Экспорт

	Если Результат.Выполнено И ЗначениеЗаполнено(Результат.ОписанияФайлов) Тогда
		Файлы = Новый Массив;
		Для Каждого ОписаниеФайла Из Результат.ОписанияФайлов Цикл
			ПараметрыФайла = Новый Структура;
			ПараметрыФайла.Вставить("Адрес", ОписаниеФайла.Адрес);
			ПараметрыФайла.Вставить("ИсходноеИмя", ОписаниеФайла.Имя);
			Файлы.Добавить(ПараметрыФайла);
		КонецЦикла;
		
		ВходящийКонтекст.Вставить("Файлы", Файлы);
		
		Оповещение = Новый ОписаниеОповещения("ПослеПоказаФайлов", ЭтотОбъект, ВходящийКонтекст);
		ОткрытьФорму("Справочник.МакетыПенсионныхДел.Форма.ПросмотрДокументов",
			ВходящийКонтекст, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПоказаФайлов(Результат, ВходящийКонтекст) Экспорт
	
	Если ПисьмоОтправлено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Результат) = Тип("Массив") Тогда
		Если ВходящийКонтекст.ЭтоРеестр = Истина Тогда
			ЗагрузитьФайлыРеестра(ЭтаФорма, Результат);
		Иначе
			Данные = ТаблицаДокументов.НайтиПоИдентификатору(ВходящийКонтекст.ВыбраннаяСтрока);
			Данные.Файлы.ЗагрузитьЗначения(Результат);
			Данные.ФайлыВыбраны = ЗначениеЗаполнено(Данные.Файлы);
			Данные.ФайлыПредставление = ПредставлениеФайлов(Результат);
		КонецЕсли;
		
		Модифицированность = Истина;
	Иначе
		ВсеФайлы = Новый Массив;
		Для Каждого СтрокаТаблицы Из ТаблицаДокументов Цикл
			Для Каждого ЭлементСписка Из СтрокаТаблицы.Файлы Цикл
				ВсеФайлы.Добавить(ЭлементСписка.Значение.Адрес);
			КонецЦикла;
		КонецЦикла;
		
		Для Каждого Файл Из ВходящийКонтекст.Файлы Цикл
			Если ВсеФайлы.Найти(Файл.Адрес) = Неопределено Тогда
				УдалитьИзВременногоХранилища(Файл.Адрес);
			КонецЕсли;
		КонецЦикла;		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗагрузитьФайлыРеестра(Форма, Файлы)
	
	Элементы = Форма.Элементы;
	
	Форма.ФайлыРеестра.ЗагрузитьЗначения(Файлы);
	Форма.РеестрДокументов = ПредставлениеФайлов(Файлы);
	Элементы.СсылкаРеестрДокументов.ЦветТекста = ?(ЗначениеЗаполнено(Форма.ФайлыРеестра), Новый Цвет, Новый Цвет(225, 40, 40));
	
КонецПроцедуры
		
&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеФайлов(Файлы)
	
	Представление = ПредставлениеФайловПоУмолчанию();
	Если ЗначениеЗаполнено(Файлы) Тогда
		
		ОбщийРазмер = 0;
		Представление = "";
		
		КоличествоСтраниц = 0;
		Страницы = Новый Массив;
		Для Каждого ОписаниеФайла Из Файлы Цикл
			ОбщийРазмер = ОбщийРазмер + ОписаниеФайла.Размер;
			
			Если ЗначениеЗаполнено(ОписаниеФайла.Страница2) Тогда
				Страницы.Добавить(СтрШаблон("%1-%2", ОписаниеФайла.Страница1, ОписаниеФайла.Страница2));
				КоличествоСтраниц = КоличествоСтраниц + 2;
			Иначе
				Если ЗначениеЗаполнено(ОписаниеФайла.Страница1) Тогда
					Страницы.Добавить(СтрШаблон("%1", ОписаниеФайла.Страница1));
				Иначе
					Страницы.Добавить(1);
				КонецЕсли;
				КоличествоСтраниц = КоличествоСтраниц + 1;
			КонецЕсли;
		КонецЦикла;
		
		Если КоличествоСтраниц = 1 Тогда
			ШаблонПредставления = НСтр("ru = 'Страница № %1 (%2)'");
		Иначе
			ШаблонПредставления = НСтр("ru = 'Страницы № %1 (%2)'");
		КонецЕсли;
		
		Представление = СтрШаблон(
			ШаблонПредставления, 
			СтрСоединить(Страницы, ", "), 
			ОбщегоНазначенияЭДКОКлиентСервер.ТекстовоеПредставлениеРазмераФайла(ОбщийРазмер));		
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуДокументов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МакетыПенсионныхДелЭлектронныеДокументы.Документ КАК Документ,
	|	МакетыПенсионныхДелЭлектронныеДокументы.Файл,
	|	МакетыПенсионныхДелЭлектронныеДокументы.Страница1,
	|	МакетыПенсионныхДелЭлектронныеДокументы.Страница2,
	|	МакетыПенсионныхДелЭлектронныеДокументы.Размер,
	|	МакетыПенсионныхДелЭлектронныеДокументы.Файл.Расширение,
	|	МакетыПенсионныхДелЭлектронныеДокументы.Файл.Наименование
	|ИЗ
	|	Справочник.МакетыПенсионныхДел.ЭлектронныеДокументы КАК МакетыПенсионныхДелЭлектронныеДокументы
	|ГДЕ
	|	МакетыПенсионныхДелЭлектронныеДокументы.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	МакетыПенсионныхДелЭлектронныеДокументы.НомерСтроки
	|ИТОГИ ПО
	|	Документ";
	Запрос.УстановитьПараметр("Ссылка", Параметры.Ключ);
	
	ВыборкаДокумент = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаДокумент.Следующий() Цикл
		Выборка = ВыборкаДокумент.Выбрать();
		Файлы = Новый Массив;
		Пока Выборка.Следующий() Цикл
			Если ЗначениеЗаполнено(Выборка.ФайлНаименование) Тогда
				ОписаниеФайла = Новый Структура;
				ОписаниеФайла.Вставить("Адрес", "");
				ОписаниеФайла.Вставить("Файл", Выборка.Файл);
				ОписаниеФайла.Вставить("Размер", Выборка.Размер);
				ОписаниеФайла.Вставить("Страница1", Выборка.Страница1);
				ОписаниеФайла.Вставить("Страница2", Выборка.Страница2);
				ОписаниеФайла.Вставить("ИсходноеИмя", Выборка.ФайлНаименование + "." + Выборка.ФайлРасширение);
				Файлы.Добавить(ОписаниеФайла);
			КонецЕсли;
		КонецЦикла;
		
		Если НРег(ВыборкаДокумент.Документ) = "реестр" Тогда
			ЗагрузитьФайлыРеестра(ЭтаФорма, Файлы);
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ТаблицаДокументов.Добавить();
		НоваяСтрока.Документ = ВыборкаДокумент.Документ;
		НоваяСтрока.Файлы.ЗагрузитьЗначения(Файлы);
		НоваяСтрока.ФайлыПредставление = ПредставлениеФайлов(Файлы); 
		НоваяСтрока.ФайлыВыбраны = ЗначениеЗаполнено(НоваяСтрока.Файлы);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументыПоУмолчанию()
	
	ТаблицаДокументов.Очистить();
	
	ДокументыПоУмолчанию = Новый Массив;
	ДокументыПоУмолчанию.Добавить("Паспорт");
	ДокументыПоУмолчанию.Добавить("Страховое свидетельство");
	ДокументыПоУмолчанию.Добавить("Трудовая книжка");
	ДокументыПоУмолчанию.Добавить("Согласие на обработку персональных данных");
	
	Для Каждого ДокументПоУмолчанию Из ДокументыПоУмолчанию Цикл
		НовыйДокумент = ТаблицаДокументов.Добавить();
		НовыйДокумент.Документ = ДокументПоУмолчанию;
		НовыйДокумент.ФайлыПредставление = ПредставлениеФайловПоУмолчанию();
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеФайловПоУмолчанию()
	
	Возврат НСтр("ru = 'Выберите файл'");
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьАдресФайла(Файл, Идентификатор)
	
	ДанныеФайла = РаботаСФайлами.ДанныеФайла(Файл, Идентификатор, Истина);
	
	Возврат ДанныеФайла.СсылкаНаДвоичныеДанныеФайла;
	
КонецФункции

&НаКлиенте
Функция ПроверитьЗаполнениеПоляОтправитель()
	
	ПолеЗаполнено = Истина;
	Если Не ЗначениеЗаполнено(Объект.Отправитель) Тогда
		ОчиститьСообщения();
		ТекстСообщения = НСтр("ru = 'Заполните поле ""От кого""'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Отправитель");
		ПолеЗаполнено = Ложь;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Отправитель) И Не ЗначениеЗаполнено(УчетнаяЗаписьОтправителя(Объект.Отправитель)) Тогда
		ОчиститьСообщения();
		ТекстСообщения = НСтр("ru = 'Организация не подключена к 1С-Отчетности'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Отправитель");
		ПолеЗаполнено = Ложь;	
	КонецЕсли;
	
	Возврат ПолеЗаполнено;
	
КонецФункции

&НаСервереБезКонтекста
Функция УчетнаяЗаписьОтправителя(Отправитель)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Отправитель, "УчетнаяЗаписьОбмена");
	
КонецФункции

&НаКлиенте
Функция ПроверитьЗаполнениеПоляПолучатель()
	
	ПолеЗаполнено = Истина;
	Если Не ЗначениеЗаполнено(Объект.Получатель) Тогда
		ОчиститьСообщения();
		ТекстСообщения = НСтр("ru = 'Заполните поле ""Кому"".
                               |Требования к документам определяются выбранным органом ПФР.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Получатель");
		ПолеЗаполнено = Ложь;	
	КонецЕсли;
	
	Возврат ПолеЗаполнено;
	
КонецФункции

&НаКлиенте
Функция ПроверитьЗаполнениеПоляСотрудник()
	
	ПолеЗаполнено = Истина;
	Если Не ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Заполните поле ""Сотрудник""'"),, 
			"Объект.Сотрудник");
		ПолеЗаполнено = Ложь;	
	КонецЕсли;
	
	Возврат ПолеЗаполнено;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеСсылкамиСотрудника(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	СНИЛС = СтрЗаменить(СтрЗаменить(Объект.СтраховойНомерПФР, "-", ""), " ", "");
	АдресРегистрации = СокрЛП(СтрЗаменить(Объект.АдресРегистрации, ",", ""));
	Телефон = СокрЛП(Объект.Телефон);
		
	Форма.СтраховойНомерПФР = ?(ЗначениеЗаполнено(СНИЛС), Объект.СтраховойНомерПФР, ТекстСсылкиПоУмолчанию());
	Форма.АдресРегистрации = ?(ЗначениеЗаполнено(АдресРегистрации), Объект.АдресРегистрации, ТекстСсылкиПоУмолчанию());	
	Форма.Телефон = ?(ЗначениеЗаполнено(Телефон), Объект.Телефон, ТекстСсылкиПоУмолчанию());
	
	ЦветНеЗаполненнойСсылки = Новый Цвет(225, 40, 40);	
	Элементы.СтраховойНомерПФР.ЦветТекста = ?(ЗначениеЗаполнено(СНИЛС), Новый Цвет, ЦветНеЗаполненнойСсылки);
	Элементы.АдресРегистрации.ЦветТекста = ?(ЗначениеЗаполнено(АдресРегистрации), Новый Цвет, ЦветНеЗаполненнойСсылки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекстСсылкиПоУмолчанию()
	
	Возврат НСтр("ru = 'Заполнить'");
	
КонецФункции

&НаКлиенте
Процедура УстановитьНаименование()
	
	Объект.Наименование = СтрШаблон("Макет пенсионного дела (%1, %2)", Объект.Сотрудник, Объект.СтраховойНомерПФР);
	УстановитьЗаголовокФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбораДокументов(ДанныеВыбора, СтандартнаяОбработка, Текст = "")
	
	ТекущийСписокВидовДокументов = Новый Массив;
	Для Каждого СтрокаТаблицы Из ТаблицаДокументов Цикл
		ТекущийСписокВидовДокументов.Добавить(СтрокаТаблицы.Документ);
	КонецЦикла;
	
	НевыбранныеВидыДокументов = ОбщегоНазначенияКлиентСервер.РазностьМассивов(
		ПолучитьСпискоПредопределенныхДокументов(), ТекущийСписокВидовДокументов);
		
	ВидыДокументов = Новый Массив;
	Если ЗначениеЗаполнено(Текст) Тогда
		Для Каждого ЭлементСписка Из НевыбранныеВидыДокументов Цикл
			Если СтрНайти(ЭлементСписка, Текст) Тогда
				ВидыДокументов.Добавить(ЭлементСписка);
			КонецЕсли;
		КонецЦикла;
	Иначе
		ВидыДокументов = НевыбранныеВидыДокументов;
	КонецЕсли;
	
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.ЗагрузитьЗначения(ВидыДокументов);
	ДанныеВыбора.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	
	СтандартнаяОбработка = Ложь;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСпискоПредопределенныхДокументов()
	
	ВидыДокументов = Новый Массив;
	ВидыДокументов.Добавить("Анкета");
	ВидыДокументов.Добавить("Архивная справка о работе");
	ВидыДокументов.Добавить("Военный билет");
	ВидыДокументов.Добавить("Диплом");
	ВидыДокументов.Добавить("Паспорт");
	ВидыДокументов.Добавить("Свидетельство о заключении брака");
	ВидыДокументов.Добавить("Свидетельство о рождении ребенка");
	ВидыДокументов.Добавить("Согласие на обработку персональных данных");
	ВидыДокументов.Добавить("Справка о заработке");
	ВидыДокументов.Добавить("Справка о переименовании (реорганизации) организации");
	ВидыДокументов.Добавить("Справка о периоде проживания с мужем-военнослужащим");
	ВидыДокументов.Добавить("Справка о работе");
	ВидыДокументов.Добавить("Справка об обучении нетрудоспособных членов семьи по очной форме");
	ВидыДокументов.Добавить("Справка органов занятости");
	ВидыДокументов.Добавить("Справка, уточняющая работу в условиях, дающих право на досрочную пенсию");
	ВидыДокументов.Добавить("Страховое свидетельство ребенка");
	ВидыДокументов.Добавить("Страховое свидетельство");
	ВидыДокументов.Добавить("Трудовая книжка");
	
	Возврат ВидыДокументов;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьНастройки(Форма)
	
	Объект = Форма.Объект;
	
	Настройки = ПолучитьНастройки(Объект.Отправитель, Объект.Получатель);
	Если ЗначениеЗаполнено(Настройки) Тогда
		Форма.ДопустимыеТипыФайлов = Настройки.Вложение.ДопустимыеТипы;
		Форма.МаксимальныйРазмерФайла = Настройки.Вложение.МаксимальныйРазмерФайла;
		Форма.МаксимальныйРазмерВложения = Настройки.Вложение.МаксимальныйРазмерВложения;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНастройки(Отправитель, Получатель)
	
	Настройки = Новый Структура;
	
	Если ЗначениеЗаполнено(Отправитель) И ЗначениеЗаполнено(Получатель) Тогда
		Настройки = РегистрыСведений.ПравилаОтправкиОтчетностиПоФизЛицам.ПолучитьНастройки(
			Отправитель,
			Получатель,
			Перечисления.ВидыОтчетностиПоФизЛицам.МакетПенсионныхДел);
	КонецЕсли;
	
	Возврат Настройки;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьОрганПФРПоМестуНазначенияПенсии()
	
	Если Не ЗначениеЗаполнено(СтрЗаменить(Объект.ОрганПФРПоМестуНазначенияПенсии, "-", ""))
		ИЛИ Прав(Объект.ОрганПФРПоМестуНазначенияПенсии, 3) = "000" Тогда
		Объект.ОрганПФРПоМестуНазначенияПенсии = ПолучитьКодПФРПоАдресу(Объект.АдресРегистрации);
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКодПФРПоАдресу(Адрес);

	КодПФР = Неопределено;
	
	Регион = "";
	
	ЧастиАдреса = СтрРазделить(Адрес, ",");
	Для Каждого ЧастьАдреса Из ЧастиАдреса Цикл
		Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ЧастьАдреса,, Ложь)
			И ВРег(СокрП(ЧастьАдреса)) <> "РОССИЯ" Тогда
			Регион = СокрЛП(ЧастьАдреса);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ОтделенияПФР = Новый ТаблицаЗначений;
	ОтделенияПФР.Колонки.Добавить("КодРегиона");
	ОтделенияПФР.Колонки.Добавить("НаименованиеРегиона");
	ОтделенияПФР.Колонки.Добавить("КодПФР");
	
	Макет = Справочники.МакетыПенсионныхДел.ПолучитьМакет("ОтделенияПФР");
	Для Индекс = 1 По Макет.ВысотаТаблицы Цикл
		НоваяСтрока = ОтделенияПФР.Добавить();
		НоваяСтрока.КодРегиона = Макет.Область(Индекс, 1).Текст;
		НоваяСтрока.НаименованиеРегиона = Макет.Область(Индекс, 2).Текст;
		НоваяСтрока.КодПФР = Макет.Область(Индекс, 3).Текст;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Регион) Тогда
		Регион = СтрРазделить(Регион, " ", Ложь)[0];
		Для Каждого СтрокаТаблицы Из ОтделенияПФР Цикл
			Если СтрНайти(СтрокаТаблицы.НаименованиеРегиона, Регион) Тогда
				КодПФР = СтрокаТаблицы.КодПФР;
				Прервать;
			КонецЕсли;                             
		КонецЦикла;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КодПФР) Тогда
		КодПФР = СтрШаблон("%1-000", КодПФР);
	КонецЕсли;
			
	Возврат КодПФР;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФайлыДляПросмотра(Элемент, ВыбраннаяСтрока = Неопределено)
	
	Если ПроверитьЗаполнениеПоляОтправитель() И ПроверитьЗаполнениеПоляПолучатель() Тогда
		Если Элемент = Элементы.СсылкаРеестрДокументов Тогда
			Документ = "Реестр";
			ЭтоРеестр = Истина;
			СписокФайлов = ФайлыРеестра;
		Иначе
			ТекущиеДанные = ТаблицаДокументов.НайтиПоИдентификатору(ВыбраннаяСтрока);
			
			Документ = ТекущиеДанные.Документ;
			СписокФайлов = ТекущиеДанные.Файлы;
			
			Если Не ЗначениеЗаполнено(Документ) Тогда
				ОчиститьСообщения();
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Поле ""Документ"" не заполнено'"),, 
					СтрШаблон("ТаблицаДокументов[%1].Документ", Формат(ТаблицаДокументов.Индекс(ТекущиеДанные), "ЧГ=")));
				Возврат;
			КонецЕсли;
		КонецЕсли;			
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Документ", Документ);
		ПараметрыФормы.Вставить("Идентификатор", УникальныйИдентификатор);
		ПараметрыФормы.Вставить("ВыбраннаяСтрока", ВыбраннаяСтрока);
		ПараметрыФормы.Вставить("МаксимальныйРазмерФайла", МаксимальныйРазмерФайла);
		ПараметрыФормы.Вставить("ВозвращатьРазмер", Истина);
		ПараметрыФормы.Вставить("ДопустимыеТипыФайлов", ДопустимыеТипыФайлов);
		ПараметрыФормы.Вставить("РежимТолькоПросмотр", ПисьмоОтправлено);
		ПараметрыФормы.Вставить("ЭтоРеестр", ЭтоРеестр);
		
		Если ЗначениеЗаполнено(СписокФайлов) Тогда
			Файлы = Новый Массив;
			Для Каждого ОписаниеФайла Из СписокФайлов Цикл
				ПараметрыФайла = Новый Структура;
				Если Не ЗначениеЗаполнено(ОписаниеФайла.Значение.Адрес) Тогда
					ПараметрыФайла.Вставить("Адрес", ПолучитьАдресФайла(ОписаниеФайла.Значение.Файл, УникальныйИдентификатор));
				Иначе
					ПараметрыФайла.Вставить("Адрес", ОписаниеФайла.Значение.Адрес);
				КонецЕсли;
				ПараметрыФайла.Вставить("ИсходноеИмя", ОписаниеФайла.Значение.ИсходноеИмя);
				ПараметрыФайла.Вставить("Страница1", ОписаниеФайла.Значение.Страница1);
				ПараметрыФайла.Вставить("Страница2", ОписаниеФайла.Значение.Страница2);
				Если ОписаниеФайла.Значение.Свойство("Файл") Тогда
					ПараметрыФайла.Вставить("Файл", ОписаниеФайла.Значение.Файл);
				КонецЕсли;
				Файлы.Добавить(ПараметрыФайла);
			КонецЦикла;
			
			ПараметрыФормы.Вставить("Файлы", Файлы);
			
			Оповещение = Новый ОписаниеОповещения("ПослеПоказаФайлов", ЭтотОбъект, ПараметрыФормы);
			ОткрытьФорму("Справочник.МакетыПенсионныхДел.Форма.ПросмотрДокументов",
				ПараметрыФормы, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
			Оповещение = Новый ОписаниеОповещения("ДокументыВыборПослеВыбораФайла", ЭтотОбъект, ПараметрыФормы);
			ОперацииСФайламиЭДКОКлиент.ДобавитьФайлы(Оповещение, УникальныйИдентификатор,
				СтрШаблон(НСтр("ru = 'Выберите файлы документа <%1> '"), Документ), ПараметрыФормы);		
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуВТаблицуЭлектронныеДокументы(ТекущийОбъект, Ссылка, Документ, Файлы, СоответствиеФайлов)
	
	Если ЗначениеЗаполнено(Файлы) Тогда
		Для Каждого ЭлементСписка Из Файлы Цикл		
			НоваяСтрока = ТекущийОбъект.ЭлектронныеДокументы.Добавить();
			НоваяСтрока.Документ = Документ;
			Если ЭлементСписка.Значение.Свойство("Файл") И ЗначениеЗаполнено(ЭлементСписка.Значение.Файл) Тогда
				НоваяСтрока.Файл = ЭлементСписка.Значение.Файл;
			Иначе
				НоваяСтрока.Файл = РаботаСФайлами.НоваяСсылкаНаФайл(Ссылка);
				ЭлементСписка.Значение.Вставить("Файл", НоваяСтрока.Файл);
			КонецЕсли;
			НоваяСтрока.Страница1 = ЭлементСписка.Значение.Страница1;
			НоваяСтрока.Страница2 = ЭлементСписка.Значение.Страница2;
			НоваяСтрока.Размер = ЭлементСписка.Значение.Размер;
			
			Файл = Новый Файл(ЭлементСписка.Значение.ИсходноеИмя);
			ОписаниеФайла = Новый Структура;
			ОписаниеФайла.Вставить("ИмяБезРасширения", Файл.ИмяБезРасширения);
			ОписаниеФайла.Вставить("Расширение", СтрЗаменить(Файл.Расширение, ".", ""));
			ОписаниеФайла.Вставить("АдресФайлаВоВременномХранилище", ЭлементСписка.Значение.Адрес);
			ОписаниеФайла.Вставить("АдресВременногоХранилищаТекста", "");
			
			СоответствиеФайлов.Вставить(НоваяСтрока.Файл, ОписаниеФайла);
		КонецЦикла;
	Иначе
		НоваяСтрока = ТекущийОбъект.ЭлектронныеДокументы.Добавить();
		НоваяСтрока.Документ = Документ;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПолучателей(Организация)
	
	ЕстьПолучатели = ЕстьПолучателиНаСервере(Организация);
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьПолучателиНаСервере(Организация)
	
	Возврат РегистрыСведений.ПравилаОтправкиОтчетностиПоФизЛицам.ЕстьПолучатели(
		Организация,
		Перечисления.ВидыОтчетностиПоФизЛицам.МакетПенсионныхДел);
	
КонецФункции

#КонецОбласти
