
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АссистентПодключен = АссистентУправления.Подключен();
	ИнформационнаяБазаПодключена = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	
	ТекущийЭлемент = Элементы.ИзмениСостояниеПриОплате;
	ОтображатьЗадачиПроизводства = ПолучитьФункциональнуюОпцию("ИспользоватьПодсистемуПроизводство");
	УстановитьПризнакиВРаботе();
	УправлениеФормой();
	НастроитьФормуМобильныйКлиент();
	
	Шаблон = "Конфигурация: [СинонимКонфигурации] ([ВерсияКонфигурации])
	|Платформа: 1С:Предприятие ([ВерсияПлатформы])
	|Идентификатор базы: [ИдентификаторБазы]";
	СисИнфо = Новый СистемнаяИнформация;
	ВставляемыеЗначения = Новый Структура;
	ВставляемыеЗначения.Вставить("СинонимКонфигурации",	Метаданные.Синоним);
	ВставляемыеЗначения.Вставить("ВерсияКонфигурации",	Метаданные.Версия);
	ВставляемыеЗначения.Вставить("ВерсияПлатформы",		СисИнфо.ВерсияПриложения);
	ВставляемыеЗначения.Вставить("ИдентификаторБазы",	СтандартныеПодсистемыСервер.ИдентификаторИнформационнойБазы());
	ИнформацияОПрограмме = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Шаблон, ВставляемыеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

//ЗадачиАссистента
&НаКлиенте
Процедура ИзмениСостояниеПриОплате(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ИзменениеСостоянияЗаказаПриОплате");
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеПриОплатеИОтгрузке(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ИзменениеСостоянияЗаказаПриОплатеИОтгрузке");
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеПриОтгрузке(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ИзменениеСостоянияЗаказаПриОтгрузке");
КонецПроцедуры

&НаКлиенте
Процедура СообщиПриОплатеЗаказа(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеПользователяПриОплатеЗаказа");
КонецПроцедуры

&НаКлиенте
Процедура СообщиПриОтгрузкеЗаказа(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеПользователяПриОтгрузкеЗаказа");
КонецПроцедуры

&НаКлиенте
Процедура СообщиПриОтгрузкеИОплате(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеПользователяПриОтгрузкеИОплатеЗаказа");
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказПокупателяПоЗаказамПоставщикам(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаПокупателяПоСостояниюЗаказовПоставщикам";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПокупателяПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказПокупателяПоЗаказамНаПроизводство(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаПокупателяПоСостояниюЗаказовНаПроизводство";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПокупателяПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказаПоставщикуПриОплате(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаПоставщикуПриОплате";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПриОплатеИПоставке", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказаПоставщикуПриПоставке(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаПоставщикуПриПоставке";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПриОплатеИПоставке", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказаПоставщикуПриОплатеИПоставке(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаПоставщикуПриОплатеИПоставке";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПриОплатеИПоставке", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповестиПользователяПриОплатеЗаказаПоставщику(Команда)
	
	ИдентификаторГруппы = "ОповещениеПользователюПриОплатеЗаказаПоставщику";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПриОплатеИПоставке", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповестиПользователяПриПоставкеЗаказаПоставщику(Команда)
	
	ИдентификаторГруппы = "ОповещениеПользователюПриПоставкеЗаказаПоставщику";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПриОплатеИПоставке", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповестиПользователяПриОплатеИПоставкеЗаказаПоставщику(Команда)
	
	ИдентификаторГруппы = "ОповещениеПользователюПриОплатеИПоставкеЗаказаПоставщику";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПриОплатеИПоставке", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказПокупателяПоЗаказамПоставщикамНаПроизводство(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаПокупателяПоСостояниюЗаказовПоставщикамИНаПроизводство";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПокупателяПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщиЗаказуПокупателяПоЗаказамПоставщикам(Команда)
	
	ИдентификаторГруппы = "ОповещениеЗаказуПокупателяПоСостояниюЗаказовПоставщикам";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПокупателяПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщиЗаказуПокупателяПоЗаказамНаПроизводство(Команда)
	
	ИдентификаторГруппы = "ОповещениеЗаказуПокупателяПоСостояниюЗаказовНаПроизводство";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПокупателяПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщиЗаказуПокупателяПоЗаказамПоставщикамИНаПроизводство(Команда)
	
	ИдентификаторГруппы = "ОповещениеЗаказуПокупателяПоСостояниюЗаказовПоставщикамИНаПроизводство";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПокупателяПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказПоставщикуПоЗаказамПокупателей(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаПоставщикуПоСостояниюЗаказовПокупателей";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщиЗаказуПоставщикуПоЗаказамПокупателей(Команда)
	
	ИдентификаторГруппы = "ОповещениеЗаказаПоставщикуПоСостояниюЗаказовПокупателей";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказаНаПроизводствоПриВыполнении(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаНаПроизводствоПриВыполнении";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомНаПроизводствоПриВыполнении", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказаНаПроизводствоПоЗаказуПокупателя(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаНаПроизводствоПоСостояниюЗаказовПокупателей";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомНаПроизводствоПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповестиПользователяПриВыполненииЗаказаНаПроизводство(Команда)
	
	ИдентификаторГруппы = "ОповещениеПользователюПриВыполненииЗаказаНаПроизводство";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомНаПроизводствоПриВыполнении", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщиЗаказуНаПроизводствоПоЗаказамПокупателей(Команда)
	
	ИдентификаторГруппы = "ОповещениеЗаказаНаПроизводствоПоСостояниюЗаказовПокупателей";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомНаПроизводствоПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповестиКлиентаОБонусахПриУсловиях(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеКлиентаОБонусахПриУсловиях");
КонецПроцедуры

&НаКлиенте
Процедура ОповестиКлиентаОБонусахПриПродаже(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеКлиентаОБонусахПриПродаже");
КонецПроцедуры

//Конец ЗадачиАссистента

&НаКлиенте
Процедура КурсОперУправление(Команда)
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://1c.ru/rus/partners/training/uc1/course.jsp?id=286");
КонецПроцедуры

&НаКлиенте
Процедура ЭкзаменСпециалист(Команда)
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://1c.ru/rus/partners/training/uc1/course.jsp?id=657");
КонецПроцедуры

&НаКлиенте
Процедура ИсторияВыполненияЗадач(Команда)
	
	ОткрытьФорму("РегистрСведений.ВыполненныеЗадачиАссистентаУправления.Форма.ВыполненныеЗадачи");
	
КонецПроцедуры

#КонецОбласти

#Область ОбрабочикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПодключитьОбсужденияНажатие(Элемент)
	ОткрытьФорму("Обработка.РегистрацияВСистемеВзаимодействияУНФ.Форма",,,,,, Новый ОписаниеОповещения("ЗавершитьПодключениеОбсуждений", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ТекстОшибкиПодключениеНажатие(Элемент)
	ПодключитьАссистента();
КонецПроцедуры

&НаКлиенте
Процедура ТекстОшибкиОбсуждениеНажатие(Элемент)
	СоздатьОбсуждение();
КонецПроцедуры

&НаКлиенте
Процедура ПредложитьНажатие(Элемент)
	
	ТекстПисьма = ИнформацияОПрограмме + Символы.ПС + Символы.ПС + "# Больше навыков Ассистента УНФ (уточните какие)" + Символы.ПС;
	
	Получатель = Новый СписокЗначений;
	Получатель.Добавить("sbm@1c.ru", "Фирма 1С");
	
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Получатель", Получатель);
	ПараметрыПисьма.Вставить("Тема", "Хочу эти возможности в будущей версии");
	ПараметрыПисьма.Вставить("Текст", ТекстПисьма);
	
	РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыПисьма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодключитьАссистента()
	
	Если АссистентПодключен Тогда
		Возврат;
	КонецЕсли;

	ПодключитьАссистентаНаСервере();
	АссистентУправленияКлиент.Подключить();
	
КонецПроцедуры

&НаСервере
Процедура ПодключитьАссистентаНаСервере()
	
	Если АссистентПодключен Тогда
		Возврат;
	КонецЕсли;
	
	АссистентУправления.Подключить();
	
	АссистентПодключен = АссистентУправления.Подключен();
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПризнакиВРаботе(ИдентификаторГруппы = Неопределено)
	
	ОтборПоГруппе = Ложь;
	
	Если ИдентификаторГруппы = Неопределено Тогда
		ОтборПоГруппе = Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗадачиАссистента.Родитель КАК Родитель,
	|	ЗадачиАссистента.Используется КАК Используется
	|ПОМЕСТИТЬ ИспользуемыеГруппыЗадач
	|ИЗ
	|	Справочник.ЗадачиАссистентаУправления КАК ЗадачиАссистента
	|ГДЕ
	|	ЗадачиАссистента.ПометкаУдаления = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗадачиАссистента.Родитель,
	|	ЗадачиАссистента.Используется
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗадачиАссистента.ИдентификаторГруппы КАК ИдентификаторГруппы,
	|	ИспользуемыеГруппыЗадач.Используется КАК Используется
	|ИЗ
	|	ИспользуемыеГруппыЗадач КАК ИспользуемыеГруппыЗадач
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗадачиАссистентаУправления КАК ЗадачиАссистента
	|		ПО ИспользуемыеГруппыЗадач.Родитель = ЗадачиАссистента.Ссылка
	|ГДЕ
	|	(&ОтборПоГруппе
	|			ИЛИ ЗадачиАссистента.ИдентификаторГруппы = &ИдентификаторГруппы)";
	
	Запрос.УстановитьПараметр("ОтборПоГруппе", ОтборПоГруппе);
	Запрос.УстановитьПараметр("ИдентификаторГруппы", ИдентификаторГруппы);
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();

	Пока Выборка.Следующий() Цикл
		
		ЭлементВРаботе = Элементы.Найти("ВРаботе_"+Выборка.ИдентификаторГруппы);
		
		Если ЭлементВРаботе = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементВРаботе.Видимость = Выборка.Используется;
		
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПодключениеОбсуждений(Результат, ДополнительныеПараметры) Экспорт
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	РазрешеноИзменятьЗадачи      = Обработки.АссистентУправления.РазререшеноИзменятьЗадачи();
	ИнформационнаяБазаПодключена = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	
	Элементы.ИмяОбсуждения.Видимость        = ИнформационнаяБазаПодключена ИЛИ НЕ РазрешеноИзменятьЗадачи;
	Элементы.ПодключитьОбсуждения.Видимость = НЕ ИнформационнаяБазаПодключена И РазрешеноИзменятьЗадачи;
	
	ОбсуждениеСоздано            = АссистентУправления.ПолучитьОбсуждениеЖурналРаботыАссистента() <> Неопределено;
	ЕстьОшибкиПодключения        = ЕстьОшибкиПодключения();
	ЕстьОшибкиСозданияОбсуждения = ЕстьОшибкиСозданияОбсуждения();
	
	Элементы.ПанельОшибки.Видимость      = (ЕстьОшибкиПодключения ИЛИ ЕстьОшибкиСозданияОбсуждения) И РазрешеноИзменятьЗадачи;
	Элементы.ОшибкаОбсуждения.Видимость  = ЕстьОшибкиСозданияОбсуждения И НЕ ЕстьОшибкиПодключения И РазрешеноИзменятьЗадачи;
	Элементы.ОшибкаПодключения.Видимость = ЕстьОшибкиПодключения И РазрешеноИзменятьЗадачи;
	
	Элементы.ИзменениеСостоянияЗаказПокупателяЗаказНаПроизводство.Видимость             = ОтображатьЗадачиПроизводства;
	Элементы.ИзменениеСостоянияЗаказыПокупателяЗаказПоставщикуИНаПроизводство.Видимость = ОтображатьЗадачиПроизводства;
	Элементы.ОповещениеЗаказаПокупателяПоЗаказамНаПроизводство.Видимость                = ОтображатьЗадачиПроизводства;
	Элементы.ОповещениеЗаказаПокупателяПоЗаказамПоставщикамИНаПроизводство.Видимость    = ОтображатьЗадачиПроизводства;
	Элементы.ИзменениеСостоянияЗаказаНаПроизводство.Видимость                           = ОтображатьЗадачиПроизводства;
	Элементы.ОповещениеПользователяОСтатусеЗаказаНаПроизводство.Видимость               = ОтображатьЗадачиПроизводства;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьОбсуждение()
	
	Если АссистентУправления.ПолучитьОбсуждениеЖурналРаботыАссистента() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АссистентУправления.СоздатьОбсуждениеЖурналРаботыАссистента();
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуЗадачи(ИмяФормы, ИдентификаторГруппы = "")
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработатьЗакрытиеФормыЗадачи",ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИдентификаторГруппы", ИдентификаторГруппы);
	ОткрытьФорму(ИмяФормы, ПараметрыФормы ,,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗакрытиеФормыЗадачи(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено ИЛИ ТипЗнч(Результат) <> Тип("Структура") тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьЗакрытиеФормыЗадачиСервер(Результат);
	
	Если НЕ ИнформационнаяБазаПодключена Тогда
		Возврат;
	КонецЕсли;
	
	Если АссистентПодключен Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьАссистента();
	
КонецПроцедуры 

&НаСервере
Процедура ОбработатьЗакрытиеФормыЗадачиСервер(Результат)
	
	ИнформационнаяБазаПодключена = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.ИзмененПризнакВРаботе Тогда
		УстановитьПризнакиВРаботе(Результат.ГруппаЗадач);
		ОпределитьИспользованиеЗадачАссистентаУправления();
	КонецЕсли;
	
	Если НЕ ИнформационнаяБазаПодключена Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ АссистентПодключен Тогда
		Возврат;
	КонецЕсли;
	
	ОбсуждениеСоздано = АссистентУправления.ПолучитьОбсуждениеЖурналРаботыАссистента() <> Неопределено;
	
	Если НЕ ОбсуждениеСоздано Тогда
		Попытка
			СоздатьОбсуждение();
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	УправлениеФормой();
	
	Если ЗначениеЗаполнено(Результат.АвторИзменений) И Результат.НужноДобавитьВОбсуждение Тогда
		Попытка
			АссистентУправления.ОбновитьУчастниковЖурналРаботыАссистента(Результат.АвторИзменений);
		Исключение
		КонецПопытки;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ЕстьОшибкиПодключения()
	
	Возврат НЕ АссистентУправления.Подключен() И ПолучитьФункциональнуюОпцию("ИспользованиеЗадачАссистентаУправления");
	
КонецФункции

&НаСервере
Функция ЕстьОшибкиСозданияОбсуждения()
	
	ОбсуждениеСоздано = АссистентУправления.ПолучитьОбсуждениеЖурналРаботыАссистента() <> Неопределено;
	
	Возврат НЕ ОбсуждениеСоздано И ПолучитьФункциональнуюОпцию("ИспользованиеЗадачАссистентаУправления");
	
КонецФункции

&НаСервере
Процедура ОпределитьИспользованиеЗадачАссистентаУправления()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗадачиАссистентаУправления.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЗадачиАссистентаУправления КАК ЗадачиАссистентаУправления
	|ГДЕ
	|	НЕ ЗадачиАссистентаУправления.ПометкаУдаления
	|	И ЗадачиАссистентаУправления.Используется";
	
	Константы.ИспользованиеЗадачАссистентаУправления.Установить(Запрос.Выполнить().Выбрать().Количество() <> 0);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуМобильныйКлиент()
	
	Если НЕ ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ГоризонтальныйОтступ.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти
