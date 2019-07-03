
&НаКлиенте
Процедура ПечатьQR(Команда)
	
	ВыбранныеСтроки = Элементы.Список.ТекущиеДанные;
	МассивОборудования = Новый Массив;
	МассивОборудования.Добавить(ВыбранныеСтроки.Оборудование);
		
	МассивСтрок = ПолучитьСтрокуQR(МассивОборудования);
	мТабДок = Новый ТабличныйДокумент;
	Итератор = 1;
	КоличествоЭлем = МассивСтрок.Количество();
	Для Каждого СТ_Элем Из МассивСтрок Цикл
		QRСтрока = СТ_Элем.СтрокаQR;
		Курьер = СТ_Элем.Курьер;
		ТекстОшибки = "";
		Ответ = ЗаполнитьТабдок(QRСтрока,ТекстОшибки,мТабДок,Курьер,КоличествоЭлем,Итератор);
		Итератор = Итератор + 1;
	КонецЦикла;
	
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	
	Ответ.ТабДок.Показать();
КонецПроцедуры

&НаСервере
Функция ПолучитьСтрокуQR(МассивОборудования)
	мОтвет = Новый Массив;
	//!!to do - доработать выбор типа адреса сервера
	//в зависимости от типа адреса, поле адреса сервера будет менятся как в мобильном приложении
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.Оборудование КАК Оборудование,
	               |	ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.Курьер КАК Курьер,
	               |	ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.ID КАК ID,
	               |	ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.АдресСервера КАК АдресПодключения,
	               |	ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.ИмяБазы КАК ИмяБазы,
	               |	ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.Пользователь КАК Пользователь,
	               |	ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.Пароль КАК Пароль,
	               |	ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.Оборудование.ИдентификаторWebСервисОборудования КАК ИДКурьера,
	               |	2 КАК ТипСинхронизации,
	               |	ВЫБОР
	               |		КОГДА ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.ТипАдреса = 0
	               |			ТОГДА 1
	               |		ИНАЧЕ ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.ТипАдреса
	               |	КОНЕЦ КАК ТипАдреса,
	               |	ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.SSL КАК SSL
	               |ИЗ
	               |	РегистрСведений.ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров КАК ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров
	               |ГДЕ
	               |	ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.Оборудование В(&Оборудование)";
	Запрос.УстановитьПараметр("Оборудование",МассивОборудования);
	Выборка = Запрос.Выполнить().Выбрать();
	ОбработкаJSON = Обработки.JSON_and_UnJSON.Создать();
	Пока Выборка.Следующий() Цикл
		мСтруктураСтроки = ПолучитьСтруктуруСтроки();
		мСтруктураОтвета = Новый Структура;
		ЗаполнитьЗначенияСвойств(мСтруктураСтроки,Выборка);
		//ЭР Несторук С.И. 19.04.2019 10:32:53 {
		мСтруктураСтроки.Пользователь = ES_БиллингСервер.ОпределитьПользователяИБ(Выборка.Пользователь);
		//}ЭР Несторук С.И.
		СтрокаQR =  ОбработкаJSON.JSON(мСтруктураСтроки);
		//ЭР Несторук С.И. 22.04.2019 13:16:25 {
		СтрокаQR	= ES_ОбщегоНазначения.ЗакодироватьСтрокуВДД(СтрокаQR);
		//}ЭР Несторук С.И.
		мСтруктураОтвета.Вставить("СтрокаQR",СтрокаQR);
		мСтруктураОтвета.Вставить("Курьер",Выборка.Курьер);
		мОтвет.Добавить(мСтруктураОтвета);
	КонецЦикла;
	
	Возврат мОтвет;

КонецФункции

&НаСервере
Функция ПолучитьСтруктуруСтроки()
	мОтвет = Новый Структура;
	мОтвет.Вставить("ТипСинхронизации");
	мОтвет.Вставить("ИДКурьера");
	мОтвет.Вставить("ТипАдреса");
	мОтвет.Вставить("АдресПодключения");
	мОтвет.Вставить("ИмяБазы");
	мОтвет.Вставить("SSL");
	мОтвет.Вставить("Пользователь");
	мОтвет.Вставить("Пароль");
	Возврат мОтвет;

КонецФункции

&НаСервере
Функция ЗаполнитьТабдок(QRСтрока,ТекстОшибки,мТабДок,Курьер,КоличествоЭлем,Итератор)
	
	//мОб = РеквизитФормыВЗначение("Объект");
	
	//мМакет = ПолучитьМакет("МакетНастроек");
	мМакет = РегистрыСведений.ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.ПолучитьМакет("МакетНастроек");
	ОбластьМакета = мМакет.ПолучитьОбласть("ОбластьQR");
	
	ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(QRСтрока, 0, 190);
	
	КартинкаQRКода = Новый Картинка(ДанныеQRКода);
	
	ОбластьМакета.Рисунки.КартинкаQR.Картинка = КартинкаQRКода;
	ОбластьМакета.Параметры.Курьер = Курьер;
	мТабДок.Вывести(ОбластьМакета);
	
	Если не КоличествоЭлем = Итератор Тогда 
		мТабДок.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;	
	
	мСтрукт = Новый Структура;
	мСтрукт.Вставить("ТабДок",мТабДок);
	
	Возврат мСтрукт;

КонецФункции


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//ЭР Несторук С.И. 10.04.2019 9:32:27 {
	ES_БиллингКлиент.ПроверитьДоступностьСервисаDelans(Отказ);
	//}ЭР Несторук С.И.
КонецПроцедуры


&НаКлиенте
Процедура ЗаполинтьИзСервисаDelans(Команда)
	ES_БиллингСервер.ЗаполнитьСписокПользователейСУслугойКурьерDelans();
	Элементы.Список.Обновить();
КонецПроцедуры


&НаКлиенте
Процедура ВыборПользователяПароляЗавершения(Результат, ДополинтельныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьПользователяИПароль(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборПользователяПароляЗавершения", ЭтаФорма);
	ОткрытьФорму("РегистрСведений.ES_CоответствиеПравилОбменаОборудованияOfflineИКурьеров.Форма.ФормаЗаполненияПользователяИПароля",,ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

