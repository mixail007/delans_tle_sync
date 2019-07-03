
#Область ПрограммныйИнтерфейс

// Обрабатывает текст HTML электронного письма.
//
// Параметры:
//  Событие  - ДокументСсылка.ЭлектронноеПисьмоВходящее,
//            ДокументСсылка.ЭлектронноеПисьмоИсходящее - письмо для которого будет проведена оценка.
//  Кодировка - Строка - кодировка текста
//  ТаблицаВложений - Коллекция строк - таблица с колонками Идентификатор, Представление, АдресВоВременномХранилище
//
// Возвращаемое значение:
//   Строка   - обработанный текст электронного письма.
//
Функция ОбработатьТекстHTML(ТекстHTML, Кодировка = Неопределено, ТаблицаВложений = Неопределено) Экспорт
	
	Если ПустаяСтрока(ТекстHTML) Тогда
		Возврат ТекстHTML;
	КонецЕсли;
	
	// Добавим тег HTML если он отсутствует. Такие письма могут приходить к примеру с Gmail. 
	// Необходимо для корректного отображения в элементе формы.
	Если СтрЧислоВхождений(ТекстHTML, "<html") = 0 Тогда
		ТекстHTML = СтрШаблон("<html>%1</html>", ТекстHTML);
	КонецЕсли;
	
	Если ТаблицаВложений = Неопределено Тогда
		Возврат ТекстHTML;
	КонецЕсли;
	
	Если ТаблицаВложений.Количество() = 0 Тогда
		Возврат ТекстHTML;
	КонецЕсли;
	
	ДокументHTML = ЗаменитьИдентификаторыКартинокНаПутьКФайлам(ТекстHTML, ТаблицаВложений, Кодировка);
	
	Возврат ПолучитьТекстHTMLИзОбъектаДокументHTML(ДокументHTML);
	
КонецФункции

// Возвращает структуру "Заголовок, Тело, Окончание",
// где ТекстHTML = Заголовок + Тело + Окончание
// и Тело - содержимое тега body
//
Функция РазложитьТекстHTML(ТекстHTML) Экспорт
	
	НРегТекстHTML = НРег(ТекстHTML);
	
	ПозицияНачалаТела = 1;
	ПозицияОкончанияТела = СтрДлина(ТекстHTML);
	
	ПозицияНачалаТегаHTML = СтрНайти(НРегТекстHTML, "<html");
	Если ПозицияНачалаТегаHTML > 0 Тогда
		ПозицияОкончанияТегаHTML = НайтиПосле(НРегТекстHTML, ">", ПозицияНачалаТегаHTML);
		Если ПозицияОкончанияТегаHTML > 0 Тогда
			ПозицияНачалаТела = ПозицияОкончанияТегаHTML + 1;
		КонецЕсли;
	КонецЕсли;
	
	ПозицияНачалаТегаBODY = НайтиПосле(НРегТекстHTML, "<body", ПозицияНачалаТела - 1);
	Если ПозицияНачалаТегаBODY > 0 Тогда
		ПозицияОкончанияТегаBODY = НайтиПосле(НРегТекстHTML, ">", ПозицияНачалаТегаBODY);
		Если ПозицияОкончанияТегаBODY > 0 Тогда
			ПозицияНачалаТела = ПозицияОкончанияТегаBODY + 1;
		КонецЕсли;
	КонецЕсли;
	
	ПозицияНачалаЗакрывающегоТегаBODY = НайтиПосле(НРегТекстHTML, "</body>", ПозицияНачалаТела - 1);
	Если ПозицияНачалаЗакрывающегоТегаBODY > 0 Тогда
		ПозицияОкончанияТела = ПозицияНачалаЗакрывающегоТегаBODY - 1;
	Иначе
		ПозицияНачалаЗакрывающегоТегаHTML = НайтиПосле(НРегТекстHTML, "</html>", ПозицияНачалаТела - 1);
		Если ПозицияНачалаЗакрывающегоТегаHTML > 0 Тогда
			ПозицияОкончанияТела = ПозицияНачалаЗакрывающегоТегаHTML - 1;
		КонецЕсли;
	КонецЕсли;
	
	Заголовок = Лев(ТекстHTML, ПозицияНачалаТела - 1);
	Тело = Сред(ТекстHTML, ПозицияНачалаТела, ПозицияОкончанияТела - ПозицияНачалаТела + 1);
	Окончание = Сред(ТекстHTML, ПозицияОкончанияТела + 1);
	
	Результат = Новый Структура("Заголовок, Тело, Окончание", Заголовок, Тело, Окончание);
	
	Возврат Результат;
	
КонецФункции

// Преобразовывает HTML текст в текст
Функция ПолучитьТекстИзHTML(Знач ТекстHTML, Знач Кодировка = Неопределено) Экспорт
	
	ПереводСтроки = Символы.ВК + Символы.ПС;
	
	ТекстHTML = СтрЗаменить(ТекстHTML, "</o:p>", "</o:p>" + ПереводСтроки);
	ТекстHTML = СтрЗаменить(ТекстHTML, "</o:p>" + ПереводСтроки + ПереводСтроки, "</o:p>" + ПереводСтроки);
	ТекстHTML = СтрЗаменить(ТекстHTML, "</p>", "</p>" + ПереводСтроки);
	ТекстHTML = СтрЗаменить(ТекстHTML, "</p>" + ПереводСтроки + ПереводСтроки, "</p>" + ПереводСтроки);
	ТекстHTML = СтрЗаменить(ТекстHTML, "</div>", "</div>" + ПереводСтроки);
	ТекстHTML = СтрЗаменить(ТекстHTML, "</div>" + ПереводСтроки + ПереводСтроки, "</div>" + ПереводСтроки);
	ТекстHTML = СтрЗаменить(ТекстHTML, "<br>", ПереводСтроки + ПереводСтроки);
	
	Построитель = Новый ПостроительDOM;
	ЧтениеHTML = Новый ЧтениеHTML;
	Если ЗначениеЗаполнено(Кодировка) Тогда
		Попытка
			ЧтениеHTML.УстановитьСтроку(ТекстHTML, Кодировка);
		Исключение	
			ЧтениеHTML.УстановитьСтроку(ТекстHTML); // кодировка могла быть некорректная - ставим без кодировки
		КонецПопытки;	
	Иначе
		ЧтениеHTML.УстановитьСтроку(ТекстHTML);
	КонецЕсли;
	
	ДокументHTML = Построитель.Прочитать(ЧтениеHTML);
	
	УдалитьТегиИзЭлементаHTML(ДокументHTML, "style");
	
	Если ДокументHTML.Тело = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат ДокументHTML.Тело.ТекстовоеСодержимое;
	
КонецФункции

// Заменяет в строке все спецсимволы на соответствующие им имена,
// возвращает измененную строку.
//
Функция ЗаменитьСпецСимволыHTML(Строка) Экспорт
	
	СоответствиеСпецСимволов = СоответствиеСпецСимволов();
	
	ЗаменитьСпецСимволHTML(Строка, 38, "amp");
	
	НоваяСтрока = "";
	
	Для Поз = 1 По СтрДлина(Строка) Цикл
		
		Код = КодСимвола(Строка, Поз);
		ИмяСимвола = СоответствиеСпецСимволов.Получить(Код);
		
		Если ИмяСимвола = Неопределено Тогда
			НоваяСтрока = НоваяСтрока + Символ(Код);
		Иначе
			НоваяСтрока = НоваяСтрока + "&" + ИмяСимвола + ";";
		КонецЕсли;
		
	КонецЦикла;
	
	Строка = НоваяСтрока;
	
	Возврат Строка;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает вложения письма с непустым ИД.
//
// Параметры:
//  Письмо  - ДокументСсылка.Событие,
//
// Возвращаемое значение:
//   ТаблицаЗначений   - таблица с информацией о вложениях электронного письма с непустым ИД.
//
Функция ПолучитьВложенияПисьмаСНеПустымИД(Событие) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПрисоединенныеФайлыПисьма.Ссылка,
	|	ПрисоединенныеФайлыПисьма.Наименование,
	|	ПрисоединенныеФайлыПисьма.Размер,
	|	ПрисоединенныеФайлыПисьма.ИДФайлаЭлектронногоПисьма
	|ИЗ
	|	Справочник.СобытиеПрисоединенныеФайлы КАК ПрисоединенныеФайлыПисьма
	|ГДЕ
	|	ПрисоединенныеФайлыПисьма.ВладелецФайла = &ВладелецФайлов
	|	И НЕ ПрисоединенныеФайлыПисьма.ПометкаУдаления
	|	И ПрисоединенныеФайлыПисьма.ИДФайлаЭлектронногоПисьма <> &ПустаяСтрока");
	
	Запрос.УстановитьПараметр("ПустаяСтрока","");
	Запрос.УстановитьПараметр("ВладелецФайлов", Событие);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции 

// Заменяет в тексте HTML ИД картинок вложений на путь к файлам и создает объект документ HTML.
//
// Параметры:
//  ТекстHTML - Строка - обрабатываемый текст HTML.
//  ТаблицаВложений - ТаблицаЗначений - таблица, содержащая информацию о присоединенных файлах в колонках:
//    * Идентификатор - Строка - идентификатор картинки, используется для переопределения атрибута src в производном HTML,
//    * Представление - Строка - интерпретируется как полное имя файла, используется для определения типа файла,
//    * АдресВоВременномХранилище - Строка - адрес во временном хранилище.
//  Кодировка - Строка - кодировка текста HTML.
//
// Возвращаемое значение:
//  ДокументHTML   - созданный документ HTML.
//
Функция ЗаменитьИдентификаторыКартинокНаПутьКФайлам(ТекстHTML, ТаблицаВложений, Кодировка = Неопределено, ОбработатьКартинки = Ложь)
	
	ДокументHTML = ПолучитьОбъектДокументHTMLИзТекстаHTML(ТекстHTML, Кодировка);
	
	Для каждого ТекВложение Из ТаблицаВложений Цикл
		
		Для каждого Картинка Из ДокументHTML.Картинки Цикл
			
			АтрибутИсточникКартинки = Картинка.Атрибуты.ПолучитьИменованныйЭлемент("src");
			Если АтрибутИсточникКартинки = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если СтрЧислоВхождений(АтрибутИсточникКартинки.Значение, ТекВложение.Идентификатор) > 0 Тогда
				
				НовыйАтрибутКартинки = АтрибутИсточникКартинки.КлонироватьУзел(Ложь);
				Если ОбработатьКартинки Тогда
					ДвоичныеДанные = ПолучитьИзВременногоХранилища(ТекВложение.АдресВоВременномХранилище);
					ТекстовоеСодержимое = СтрШаблон(
					"data:image/%1;base64,
					|%2",
					ТипКартинки(ДвоичныеДанные),
					Base64Строка(ДвоичныеДанные));
				Иначе
					// Если данные картинки получить не удалось, то картинку не выводим. Пользователю при этом ничего не сообщаем.
					Попытка
						ТекстовоеСодержимое = ТекВложение.АдресВоВременномХранилище;
					Исключение
						ТекстовоеСодержимое = "";
					КонецПопытки;
				КонецЕсли;
				
				НовыйАтрибутКартинки.ТекстовоеСодержимое = ТекстовоеСодержимое;
				Картинка.Атрибуты.УстановитьИменованныйЭлемент(НовыйАтрибутКартинки);
				
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ДокументHTML;
	
КонецФункции

// Получает объект ДокументHTML из текста HTML.
//
// Параметры:
//  ТекстHTML  - Строка - 
//
// Возвращаемое значение:
//   ДокументHTML   - созданный документ HTML.
Функция ПолучитьОбъектДокументHTMLИзТекстаHTML(ТекстHTML,Кодировка = Неопределено)
	
	Построитель = Новый ПостроительDOM;
	ЧтениеHTML = Новый ЧтениеHTML;
	
	НовыйТекстHTML = ТекстHTML;
	ПозицияОткрытиеXML = СтрНайти(НовыйТекстHTML,"<?xml");
	
	Если ПозицияОткрытиеXML > 0 Тогда
		
		ПозицияЗакрытиеXML = СтрНайти(НовыйТекстHTML,"?>");
		Если ПозицияЗакрытиеXML > 0 Тогда
			
			НовыйТекстHTML = ЛЕВ(НовыйТекстHTML,ПозицияОткрытиеXML - 1) + ПРАВ(НовыйТекстHTML,СтрДлина(НовыйТекстHTML) - ПозицияЗакрытиеXML -1);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Кодировка = Неопределено Тогда
		ЧтениеHTML.УстановитьСтроку(ТекстHTML);
	Иначе
		ЧтениеHTML.УстановитьСтроку(ТекстHTML, Кодировка);
	КонецЕсли;
	Возврат Построитель.Прочитать(ЧтениеHTML);
	
КонецФункции

// Получает текст HTML из объекта ДокументHTML.
//
// Параметры:
//  ДокументHTML  - ДокументHTML - документ, из которого будет извлекаться текст.
//
// Возвращаемое значение:
//   Строка   - текст HTML
//
Функция ПолучитьТекстHTMLИзОбъектаДокументHTML(ДокументHTML)
	
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьHTML = Новый ЗаписьHTML;
	ЗаписьHTML.УстановитьСтроку();
	ЗаписьDOM.Записать(ДокументHTML,ЗаписьHTML);
	Возврат ЗаписьHTML.Закрыть();
	
КонецФункции

// Ищет подстроку в строке, после указанной позиции
//
Функция НайтиПосле(Строка, Подстрока, НачальнаяПозиция = 0)
	
	Если СтрДлина(Строка) <= НачальнаяПозиция Тогда
		Возврат 0;
	КонецЕсли;
	
	Позиция = СтрНайти(Строка, Подстрока, НаправлениеПоиска.СНачала, НачальнаяПозиция + 1);
	Возврат Позиция;
	
КонецФункции

Процедура ЗаменитьСпецСимволHTML(Строка, КодСимвола, ИмяСимвола)
	
	Строка = СтрЗаменить(Строка, Символ(КодСимвола), "&" + ИмяСимвола + ";");
	
КонецПроцедуры

Функция СоответствиеСпецСимволов()
	
	Результат = Новый Соответствие;
	
	Результат.Вставить(193, "Aacute");
	Результат.Вставить(225, "aacute");
	Результат.Вставить(226, "acirc");
	Результат.Вставить(194, "Acirc");
	Результат.Вставить(180, "acute");
	Результат.Вставить(230, "aelig");
	Результат.Вставить(198, "AElig");
	Результат.Вставить(192, "Agrave");
	Результат.Вставить(224, "agrave");
	Результат.Вставить(8501, "alefsym");
	Результат.Вставить(913, "Alpha");
	Результат.Вставить(945, "alpha");
	Результат.Вставить(8743, "and");
	Результат.Вставить(8736, "ang");
	Результат.Вставить(229, "aring");
	Результат.Вставить(197, "Aring");
	Результат.Вставить(8776, "asymp");
	Результат.Вставить(195, "Atilde");
	Результат.Вставить(227, "atilde");
	Результат.Вставить(196, "Auml");
	Результат.Вставить(228, "auml");
	Результат.Вставить(8222, "bdquo");
	Результат.Вставить(914, "Beta");
	Результат.Вставить(946, "beta");
	Результат.Вставить(166, "brvbar");
	Результат.Вставить(8226, "bull");
	Результат.Вставить(8745, "cap");
	Результат.Вставить(199, "Ccedil");
	Результат.Вставить(231, "ccedil");
	Результат.Вставить(184, "cedil");
	Результат.Вставить(162, "cent");
	Результат.Вставить(967, "chi");
	Результат.Вставить(935, "Chi");
	Результат.Вставить(710, "circ");
	Результат.Вставить(9827, "clubs");
	Результат.Вставить(8773, "cong");
	Результат.Вставить(169, "copy");
	Результат.Вставить(8629, "crarr");
	Результат.Вставить(8746, "cup");
	Результат.Вставить(164, "curren");
	Результат.Вставить(8224, "dagger");
	Результат.Вставить(8225, "Dagger");
	Результат.Вставить(8659, "dArr");
	Результат.Вставить(8595, "darr");
	Результат.Вставить(176, "deg");
	Результат.Вставить(916, "Delta");
	Результат.Вставить(948, "delta");
	Результат.Вставить(9830, "diams");
	Результат.Вставить(247, "divide");
	Результат.Вставить(233, "eacute");
	Результат.Вставить(201, "Eacute");
	Результат.Вставить(202, "Ecirc");
	Результат.Вставить(234, "ecirc");
	Результат.Вставить(232, "egrave");
	Результат.Вставить(200, "Egrave");
	Результат.Вставить(8709, "empty");
	Результат.Вставить(8195, "emsp");
	Результат.Вставить(8194, "ensp");
	Результат.Вставить(949, "epsilon");
	Результат.Вставить(917, "Epsilon");
	Результат.Вставить(8801, "equiv");
	Результат.Вставить(919, "Eta");
	Результат.Вставить(951, "eta");
	Результат.Вставить(240, "eth");
	Результат.Вставить(208, "ETH");
	Результат.Вставить(235, "euml");
	Результат.Вставить(203, "Euml");
	Результат.Вставить(8364, "euro");
	Результат.Вставить(8707, "exist");
	Результат.Вставить(402, "fnof");
	Результат.Вставить(8704, "forall");
	Результат.Вставить(189, "frac12");
	Результат.Вставить(188, "frac14");
	Результат.Вставить(190, "frac34");
	Результат.Вставить(8260, "frasl");
	Результат.Вставить(915, "Gamma");
	Результат.Вставить(947, "gamma");
	Результат.Вставить(8805, "ge");
	Результат.Вставить(62, "gt");
	Результат.Вставить(8660, "hArr");
	Результат.Вставить(8596, "harr");
	Результат.Вставить(9829, "hearts");
	Результат.Вставить(8230, "hellip");
	Результат.Вставить(237, "iacute");
	Результат.Вставить(205, "Iacute");
	Результат.Вставить(238, "icirc");
	Результат.Вставить(206, "Icirc");
	Результат.Вставить(161, "iexcl");
	Результат.Вставить(204, "Igrave");
	Результат.Вставить(236, "igrave");
	Результат.Вставить(8465, "image");
	Результат.Вставить(8734, "infin");
	Результат.Вставить(8747, "int");
	Результат.Вставить(921, "Iota");
	Результат.Вставить(953, "iota");
	Результат.Вставить(191, "iquest");
	Результат.Вставить(8712, "isin");
	Результат.Вставить(207, "Iuml");
	Результат.Вставить(239, "iuml");
	Результат.Вставить(922, "Kappa");
	Результат.Вставить(954, "kappa");
	Результат.Вставить(955, "lambda");
	Результат.Вставить(923, "Lambda");
	Результат.Вставить(9001, "lang");
	Результат.Вставить(171, "laquo");
	Результат.Вставить(8592, "larr");
	Результат.Вставить(8656, "lArr");
	Результат.Вставить(8968, "lceil");
	Результат.Вставить(8220, "ldquo");
	Результат.Вставить(8804, "le");
	Результат.Вставить(8970, "lfloor");
	Результат.Вставить(8727, "lowast");
	Результат.Вставить(9674, "loz");
	Результат.Вставить(8206, "lrm");
	Результат.Вставить(8249, "lsaquo");
	Результат.Вставить(8216, "lsquo");
	Результат.Вставить(60, "lt");
	Результат.Вставить(175, "macr");
	Результат.Вставить(8212, "mdash");
	Результат.Вставить(181, "micro");
	Результат.Вставить(183, "middot");
	Результат.Вставить(8722, "minus");
	Результат.Вставить(924, "Mu");
	Результат.Вставить(956, "mu");
	Результат.Вставить(8711, "nabla");
	Результат.Вставить(160, "nbsp");
	Результат.Вставить(8211, "ndash");
	Результат.Вставить(8800, "ne");
	Результат.Вставить(8715, "ni");
	Результат.Вставить(172, "not");
	Результат.Вставить(8713, "notin");
	Результат.Вставить(8836, "nsub");
	Результат.Вставить(241, "ntilde");
	Результат.Вставить(209, "Ntilde");
	Результат.Вставить(925, "Nu");
	Результат.Вставить(957, "nu");
	Результат.Вставить(243, "oacute");
	Результат.Вставить(211, "Oacute");
	Результат.Вставить(212, "Ocirc");
	Результат.Вставить(244, "ocirc");
	Результат.Вставить(338, "OElig");
	Результат.Вставить(339, "oelig");
	Результат.Вставить(242, "ograve");
	Результат.Вставить(210, "Ograve");
	Результат.Вставить(8254, "oline");
	Результат.Вставить(969, "omega");
	Результат.Вставить(937, "Omega");
	Результат.Вставить(927, "Omicron");
	Результат.Вставить(959, "omicron");
	Результат.Вставить(8853, "oplus");
	Результат.Вставить(8744, "or");
	Результат.Вставить(170, "ordf");
	Результат.Вставить(186, "ordm");
	Результат.Вставить(216, "Oslash");
	Результат.Вставить(248, "oslash");
	Результат.Вставить(213, "Otilde");
	Результат.Вставить(245, "otilde");
	Результат.Вставить(8855, "otimes");
	Результат.Вставить(214, "Ouml");
	Результат.Вставить(246, "ouml");
	Результат.Вставить(182, "para");
	Результат.Вставить(8706, "part");
	Результат.Вставить(8240, "permil");
	Результат.Вставить(8869, "perp");
	Результат.Вставить(966, "phi");
	Результат.Вставить(934, "Phi");
	Результат.Вставить(928, "Pi");
	Результат.Вставить(960, "pi");
	Результат.Вставить(982, "piv");
	Результат.Вставить(177, "plusmn");
	Результат.Вставить(163, "pound");
	Результат.Вставить(8243, "Prime");
	Результат.Вставить(8242, "prime");
	Результат.Вставить(8719, "prod");
	Результат.Вставить(8733, "prop");
	Результат.Вставить(968, "psi");
	Результат.Вставить(936, "Psi");
	Результат.Вставить(34, "quot");
	Результат.Вставить(8730, "radic");
	Результат.Вставить(9002, "rang");
	Результат.Вставить(187, "raquo");
	Результат.Вставить(8658, "rArr");
	Результат.Вставить(8594, "rarr");
	Результат.Вставить(8969, "rceil");
	Результат.Вставить(8221, "rdquo");
	Результат.Вставить(8476, "real");
	Результат.Вставить(174, "reg");
	Результат.Вставить(8971, "rfloor");
	Результат.Вставить(929, "Rho");
	Результат.Вставить(961, "rho");
	Результат.Вставить(8207, "rlm");
	Результат.Вставить(8250, "rsaquo");
	Результат.Вставить(8217, "rsquo");
	Результат.Вставить(8218, "sbquo");
	Результат.Вставить(352, "Scaron");
	Результат.Вставить(353, "scaron");
	Результат.Вставить(8901, "sdot");
	Результат.Вставить(167, "sect");
	Результат.Вставить(173, "shy");
	Результат.Вставить(931, "Sigma");
	Результат.Вставить(963, "sigma");
	Результат.Вставить(962, "sigmaf");
	Результат.Вставить(8764, "sim");
	Результат.Вставить(9824, "spades");
	Результат.Вставить(8834, "sub");
	Результат.Вставить(8838, "sube");
	Результат.Вставить(8721, "sum");
	Результат.Вставить(8835, "sup");
	Результат.Вставить(185, "sup1");
	Результат.Вставить(178, "sup2");
	Результат.Вставить(179, "sup3");
	Результат.Вставить(8839, "supe");
	Результат.Вставить(223, "szlig");
	Результат.Вставить(932, "Tau");
	Результат.Вставить(964, "tau");
	Результат.Вставить(8756, "there4");
	Результат.Вставить(920, "Theta");
	Результат.Вставить(952, "theta");
	Результат.Вставить(977, "thetasym");
	Результат.Вставить(8201, "thinsp");
	Результат.Вставить(222, "THORN");
	Результат.Вставить(254, "thorn");
	Результат.Вставить(732, "tilde");
	Результат.Вставить(215, "times");
	Результат.Вставить(8482, "trade");
	Результат.Вставить(250, "uacute");
	Результат.Вставить(218, "Uacute");
	Результат.Вставить(8657, "uArr");
	Результат.Вставить(8593, "uarr");
	Результат.Вставить(251, "ucirc");
	Результат.Вставить(219, "Ucirc");
	Результат.Вставить(217, "Ugrave");
	Результат.Вставить(249, "ugrave");
	Результат.Вставить(168, "uml");
	Результат.Вставить(978, "upsih");
	Результат.Вставить(965, "upsilon");
	Результат.Вставить(933, "Upsilon");
	Результат.Вставить(252, "uuml");
	Результат.Вставить(220, "Uuml");
	Результат.Вставить(8472, "weierp");
	Результат.Вставить(958, "xi");
	Результат.Вставить(926, "Xi");
	Результат.Вставить(253, "yacute");
	Результат.Вставить(221, "Yacute");
	Результат.Вставить(165, "yen");
	Результат.Вставить(255, "yuml");
	Результат.Вставить(376, "Yuml");
	Результат.Вставить(918, "Zeta");
	Результат.Вставить(950, "zeta");
	Результат.Вставить(8205, "zwj");
	Результат.Вставить(8204, "zwnj");
	
	Возврат Результат;
	
КонецФункции

Процедура УдалитьТегиИзЭлементаHTML(ЭлементHTML, Тег)
	
	Для каждого Узел Из ЭлементHTML.ДочерниеУзлы Цикл
		Если НРег(Узел.ИмяУзла) = НРег(Тег) Тогда
			ЭлементHTML.УдалитьДочерний(Узел);
		Иначе
			// Рекурсия
			УдалитьТегиИзЭлементаHTML(Узел, Тег);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ТипКартинки(ДвоичныеДанные)
	
	Картинка = Новый Картинка(ДвоичныеДанные);
	Возврат НРег(Картинка.Формат());
	
КонецФункции

#КонецОбласти