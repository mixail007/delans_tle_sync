#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка) Экспорт

	СтандартнаяОбработка = Ложь;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ПараметрПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ПараметрПериод <> Неопределено
		И ПараметрПериод.Использование
		И ЗначениеЗаполнено(ПараметрПериод.Значение) Тогда
		
		ПараметрПериод.Значение = КонецДня(ПараметрПериод.Значение);
	КонецЕсли;
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета(НастройкиОтчета);
	
	УправлениеНебольшойФирмойОтчеты.УстановитьМакетОформленияОтчета(НастройкиОтчета);
	УправлениеНебольшойФирмойОтчеты.ВывестиЗаголовокОтчета(ПараметрыОтчета, ДокументРезультат);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	//Создадим и инициализируем процессор компоновки
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	//Создадим и инициализируем процессор вывода результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	//Обозначим начало вывода
	ПроцессорВывода.НачатьВывод();
	ТаблицаЗафиксирована = Ложь;

	ДокументРезультат.ФиксацияСверху = 0;
	//Основной цикл вывода отчета
	Пока Истина Цикл
		//Получим следующий элемент результата компоновки
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();

		Если ЭлементРезультата = Неопределено Тогда
			//Следующий элемент не получен - заканчиваем цикл вывода
			Прервать;
		Иначе
			// Зафиксируем шапку
			Если  Не ТаблицаЗафиксирована 
				  И ЭлементРезультата.ЗначенияПараметров.Количество() > 0 
				  И ТипЗнч(КомпоновщикНастроек.Настройки.Структура[0]) <> Тип("ДиаграммаКомпоновкиДанных") Тогда

				ТаблицаЗафиксирована = Истина;
				ДокументРезультат.ФиксацияСверху = ДокументРезультат.ВысотаТаблицы;

			КонецЕсли;
			//Элемент получен - выведем его при помощи процессора вывода
			ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
		КонецЕсли;
	КонецЦикла;

	ПроцессорВывода.ЗакончитьВывод();

КонецПроцедуры

Функция ПодготовитьПараметрыОтчета(НастройкиОтчета)
	
	Период  = Дата(1,1,1);
	ВыводитьЗаголовок = Ложь;
	Заголовок = "Товары на складе";
	
	ПараметрПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ПараметрПериод <> Неопределено
		И ПараметрПериод.Использование
		И ЗначениеЗаполнено(ПараметрПериод.Значение) Тогда
		
		Период  = ПараметрПериод.Значение;
	КонецЕсли;
	
	ПараметрВыводитьЗаголовок = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьЗаголовок"));
	Если ПараметрВыводитьЗаголовок <> Неопределено
		И ПараметрВыводитьЗаголовок.Использование Тогда
		
		ВыводитьЗаголовок = ПараметрВыводитьЗаголовок.Значение;
	КонецЕсли;
	
	ПараметрВывода = НастройкиОтчета.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок"));
	Если ПараметрВывода <> Неопределено
		И ПараметрВывода.Использование Тогда
		Заголовок = ПараметрВывода.Значение;
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Период"              , Период);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"   , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("Заголовок"           , Заголовок);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета" , "АнализДоступности");
	ПараметрыОтчета.Вставить("НастройкиОтчета"	   , НастройкиОтчета);
		
	Возврат ПараметрыОтчета;
	
КонецФункции

#КонецЕсли