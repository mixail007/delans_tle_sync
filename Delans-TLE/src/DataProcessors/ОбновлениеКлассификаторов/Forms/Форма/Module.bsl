///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница        = Элементы.ГруппаРезультатыОбновления;
		Элементы.ДекорацияОписаниеРезультата.Заголовок = НСтр("ru = 'Использование обработки недоступно при работе в модели сервиса.'");
		Элементы.ДекорацияКартинкаРезультат.Картинка   = БиблиотекаКартинок.Ошибка32;
		Элементы.КнопкаНазад.Видимость                 = Ложь;
		Элементы.КнопкаДалее.Видимость                 = Ложь;
	Иначе
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимОбновленияПриИзменении(Элемент)
	
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлОбновленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекстПредложения = НСтр("ru = 'Для загрузки классификаторов из файла необходимо
		|установить расширение для работы с файлами.'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПодключеноРасширениеРаботыСФайлами",
		ЭтотОбъект);
	
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(
		ОписаниеОповещения,
		ТекстПредложения,
		Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОписаниеРезультатаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "action:openLog" Тогда
		СтандартнаяОбработка = Ложь;
		Отбор = Новый Структура;
		Отбор.Вставить("Уровень", "Ошибка");
		ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(Отбор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПоясненияПодключенияАвторизацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "action:openPortal" Тогда
		СтандартнаяОбработка = Ложь;
		ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницу(
			ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыСервисаLogin(
				,
				ИнтернетПоддержкаПользователейКлиент.НастройкиСоединенияССерверами()));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛогинПриИзменении(Элемент)
	
	СохранитьДанныеАутентификации = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДанныеКлассификаторов

&НаКлиенте
Процедура ДанныеКлассификаторовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеКлассификаторовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	ОчиститьСообщения();
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу Тогда
		
		ОчиститьСообщения();
		Отказ = Ложь;
		Если ПустаяСтрока(Логин) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Не заполнен логин.'"),
				,
				"Логин",
				,
				Отказ);
		КонецЕсли;
		
		Если ПустаяСтрока(Пароль) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Не заполнен пароль.'"),
				,
				"Пароль",
				,
				Отказ);
		КонецЕсли;
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		ПроверитьПодключениеКПорталу1СИТС();
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРежимаОбновления Тогда
		Если РежимОбновления = РежимОбновленияЧерезИнтернет() Тогда
			ИнформацияОДоступныхОбновленияхИзСервиса();
		Иначе
			ИнформацияОДоступныхОбновленияхИзФайла();
		КонецЕсли;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборКлассификаторов Тогда
		НачатьОбновлениеКлассификаторов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРежимаОбновления;
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	Логин  = "";
	Пароль = "";
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьОтметку(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьОтметку(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ФайлОбновленияНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() <> 0 Тогда
		ФайлОбновления = ВыбранныеФайлы[0];
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПодключениеКПорталу1СИТС()
	
	ПараметрыПолучения = ПодготовитьПараметрыПолученияИнформацииОбОбновлениях();
	
	// Получение информации из сервиса классификаторов.
	РезультатОперации = РаботаСКлассификаторами.СлужебнаяДоступныеОбновленияКлассификаторов(
		ПараметрыПолучения.Идентификаторы,
		Новый Структура("Логин, Пароль", Логин, Пароль));
	
	Если РезультатОперации.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
		ОбщегоНазначения.СообщитьПользователю(
			РезультатОперации.СообщениеОбОшибке,
			,
			"Логин");
		Возврат;
	КонецЕсли;
	
	ЗаполнитьИнформациюОДоступныхОбновлениях(
		РезультатОперации,
		ПараметрыПолучения.ВерсииКлассификаторов);
	
КонецПроцедуры

&НаСервере
Процедура ИнформацияОДоступныхОбновленияхИзСервиса()
	
	ПараметрыПолучения = ПодготовитьПараметрыПолученияИнформацииОбОбновлениях();
	
	// Получение информации из сервиса классификаторов.
	РезультатОперации = РаботаСКлассификаторами.ДоступныеОбновленияКлассификаторов(
		ПараметрыПолучения.Идентификаторы);
	ЗаполнитьИнформациюОДоступныхОбновлениях(
		РезультатОперации,
		ПараметрыПолучения.ВерсииКлассификаторов);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюОДоступныхОбновлениях(РезультатОперации, ВерсииКлассификаторов)
	
		// Обработка ошибок операции.
	Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
		Если РезультатОперации.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
			СохранитьДанныеАутентификации = Истина;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу;
			УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		Иначе
			// Если авторизация прошла успешно, необходимо очистить реквизиты формы.
			Если СохранитьДанныеАутентификации Тогда
				Логин = "";
				Пароль = "";
				СохранитьДанныеАутентификации = Ложь;
			КонецЕсли;
			УстановитьОтображениеИнформацииОбОшибке(
				ЭтотОбъект,
				РезультатОперации.СообщениеОбОшибке);
			УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// Если авторизация прошла успешно, необходимо очистить реквизиты формы.
	Если СохранитьДанныеАутентификации Тогда
		
		// Запись данных.
		УстановитьПривилегированныйРежим(Истина);
		ИнтернетПоддержкаПользователей.СохранитьДанныеАутентификации(Новый Структура("Логин, Пароль", Логин, Пароль));
		УстановитьПривилегированныйРежим(Ложь);
		
		Логин = "";
		Пароль = "";
		СохранитьДанныеАутентификации = Ложь;
		
	КонецЕсли;
	
	// Заполнение таблицы с обновлениями.
	Для Каждого ОписаниеКлассификатора Из ВерсииКлассификаторов Цикл
		
		ЕстьОбновление = Ложь;
		Для Каждого ОписаниеВерсии Из РезультатОперации.ДоступныеВерсии Цикл
			Если ОписаниеВерсии.Идентификатор = ОписаниеКлассификатора.Идентификатор Тогда
				
				СтрокаКлассификатора = ДанныеКлассификаторов.Добавить();
				ЗаполнитьЗначенияСвойств(
					СтрокаКлассификатора,
					ОписаниеКлассификатора,
					"Идентификатор, Наименование");
				
				Если ОписаниеКлассификатора.Версия >= ОписаниеВерсии.Версия Тогда
					СтрокаКлассификатора.Версия = ОписаниеКлассификатора.Версия;
				Иначе
					СтрокаКлассификатора.ТребуетсяОбновление = Истина;
					СтрокаКлассификатора.Отметка             = Истина;
					СтрокаКлассификатора.КонтрольнаяСумма    = ОписаниеВерсии.ИдентификаторФайла.КонтрольнаяСумма;
					СтрокаКлассификатора.ИдентификаторФайла  = ОписаниеВерсии.ИдентификаторФайла.ИдентификаторФайла;
					СтрокаКлассификатора.Версия              = ОписаниеВерсии.Версия;
				КонецЕсли;
				
				ЕстьОбновление = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ЕстьОбновление Тогда
			СтрокаКлассификатора = ДанныеКлассификаторов.Добавить();
			СтрокаКлассификатора.Идентификатор = ОписаниеКлассификатора.Идентификатор;
			СтрокаКлассификатора.Наименование  = ОбновлениеНеТребуется(ОписаниеКлассификатора.Наименование);
			СтрокаКлассификатора.Версия        = ?(СтрокаКлассификатора.Версия = 0,
				ОписаниеКлассификатора.Версия,
				СтрокаКлассификатора.Версия);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДанныеКлассификаторов.Количество() <> 0 Тогда
		ДанныеКлассификаторов.Сортировать("Отметка Убыв, Наименование");
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборКлассификаторов;
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	Иначе
		УстановитьОтображениеИнформацииОбОшибке(
			ЭтотОбъект,
			НСтр("ru = 'Не найдены доступные обновления классификаторов.'"),
			Ложь,
			Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОДоступныхОбновленияхИзФайла()
	
	ДанныеКлассификаторов.Очистить();
	
	Если Не ЗначениеЗаполнено(ФайлОбновления) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не выбран файл обновления.'"),
			,
			"ФайлОбновления");
		Возврат;
	КонецЕсли;
	
	КомпонентыПути = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ФайлОбновления);
	Если КомпонентыПути.Расширение <> ".zip" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Неверный формат файла.'"),
			,
			"ФайлОбновления");
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбработатьФайлОбновленияКлассификаторов",
		ЭтотОбъект);
	
	ОписаниеПередаваемогоФайла = Новый ОписаниеПередаваемогоФайла(ФайлОбновления);
	
	ФайлыОбновлений = Новый Массив;
	ФайлыОбновлений.Добавить(ОписаниеПередаваемогоФайла);
	
	НачатьПомещениеФайлов(
		ОписаниеОповещения,
		ФайлыОбновлений,
		"",
		Ложь,
		УникальныйИдентификатор);
	
КонецПроцедуры

// Завершение диалога предложения расширения для работы с файлами.
//
&НаКлиенте
Процедура ПодключеноРасширениеРаботыСФайлами(Знач РасширениеПодключено, Знач ДополнительныеПараметры) Экспорт
	
	Если РасширениеПодключено <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Фильтр = НСтр("ru = 'Архив'") + "(*.zip)|*.zip";
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ФайлОбновленияНачалоВыбораЗавершение",
		ЭтотОбъект);
	
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьФайлОбновленияКлассификаторов(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Или ПомещенныеФайлы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Файл с обновлениями не загружен.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания           = Ложь;
	
	РезультатВыполнения = ОбработатьФайлОбновленияКлассификаторовНаСервере(
		ПомещенныеФайлы[0].Хранение,
		ЭтотОбъект.УникальныйИдентификатор);
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ОбработатьФайлОбновленияКлассификаторовЗавершение",
		ЭтотОбъект);
		
	Если РезультатВыполнения.Статус = "Выполнено" Или РезультатВыполнения.Статус = "Ошибка" Тогда
		ОбработатьФайлОбновленияКлассификаторовЗавершение(РезультатВыполнения, Неопределено);
		Возврат;
	КонецЕсли;
	
	// Настройка страницы длительной операции.
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
	Элементы.ИндикаторОбновления.Видимость  = Ложь;
	Элементы.ДекорацияСостояние.Заголовок   = НСтр("ru = 'Передача файлов на сервер приложения.'");
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбработатьФайлОбновленияКлассификаторовНаСервере(АдресФайла, УникальныйИдентификатор)
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ДанныеФайла", ПолучитьИзВременногоХранилища(АдресФайла));
	УдалитьИзВременногоХранилища(АдресФайла);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обработка файлов классификатора на сервере.'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"РаботаСКлассификаторами.ОбработатьФайлОбновленияКлассификаторов",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьФайлОбновленияКлассификаторовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		ОписаниеКлассификаторов = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Для Каждого ОписаниеКлассификатора Из ОписаниеКлассификаторов Цикл
			СтрокаКлассификатор = ДанныеКлассификаторов.Добавить();
			ЗаполнитьЗначенияСвойств(
				СтрокаКлассификатор,
				ОписаниеКлассификатора,
				"Отметка, Наименование, Версия, ТребуетсяОбновление, Идентификатор");
			Если СтрокаКлассификатор.ТребуетсяОбновление Тогда
				СтрокаКлассификатор.ИдентификаторФайла = ПоместитьВоВременноеХранилище(
					ОписаниеКлассификатора.ДанныеФайла,
					УникальныйИдентификатор);
			Иначе
				СтрокаКлассификатор.Наименование = ОбновлениеНеТребуется(СтрокаКлассификатор.Наименование);
			КонецЕсли;
		КонецЦикла;
		Если ДанныеКлассификаторов.Количество() <> 0 Тогда
			ДанныеКлассификаторов.Сортировать("Отметка Убыв, Наименование");
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборКлассификаторов;
			УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		Иначе
			УстановитьОтображениеИнформацииОбОшибке(
				ЭтотОбъект,
				НСтр("ru = 'Не найдены доступные обновления классификаторов.'"),
				Ложь,
				Ложь);
		КонецЕсли;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ИнформацияОбОшибке = Результат.КраткоеПредставлениеОшибки;
		УстановитьОтображениеИнформацииОбОшибке(ЭтотОбъект, ИнформацияОбОшибке);
	КонецЕсли;
	
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбновлениеКлассификаторов()
	
	ИндикаторОбновления = 0;
	ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения(
		"ОбновитьИндикаторЗагрузки",
		ЭтотОбъект);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания           = Ложь;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = ОповещениеОПрогрессеВыполнения;
	
	РезультатВыполнения = НачатьОбновлениеКлассификаторовНаСервере();
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"НачатьОбновлениеКлассификаторовЗавершение",
		ЭтотОбъект);
		
	Если РезультатВыполнения.Статус = "Выполнено" Или РезультатВыполнения.Статус = "Ошибка" Тогда
		НачатьОбновлениеКлассификаторовЗавершение(РезультатВыполнения, Неопределено);
		Возврат;
	КонецЕсли;
	
	// Настройка страницы длительной операции.
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
	Элементы.ИндикаторОбновления.Видимость = Истина;
	Элементы.ДекорацияСостояние.Заголовок  = НСтр("ru = 'Выполняется обновление классификаторов. Обновление может занять от
		|нескольких минут до нескольких часов в зависимости от размера обновления.'");
	
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция НачатьОбновлениеКлассификаторовНаСервере()
	
	ДанныеКлассификаторовПодготовка = ДанныеКлассификаторов.Выгрузить();
	ДанныеКлассификаторовПодготовка.Колонки.Добавить("ДанныеФайла");
	СтрокиУдалить = Новый Массив;
	Для Каждого ОписаниеКлассификатора Из ДанныеКлассификаторовПодготовка Цикл
		Если Не ОписаниеКлассификатора.ТребуетсяОбновление Или Не ОписаниеКлассификатора.Отметка Тогда
			СтрокиУдалить.Добавить(ОписаниеКлассификатора);
		ИначеЕсли РежимОбновления = РежимОбновленияИзФайла() Тогда
			ОписаниеКлассификатора.ДанныеФайла = ПолучитьИзВременногоХранилища(ОписаниеКлассификатора.ИдентификаторФайла);
			УдалитьИзВременногоХранилища(ОписаниеКлассификатора.ИдентификаторФайла);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ОписаниеКлассификатора Из СтрокиУдалить Цикл
		ДанныеКлассификаторовПодготовка.Удалить(ОписаниеКлассификатора);
	КонецЦикла;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ДанныеКлассификаторов", ДанныеКлассификаторовПодготовка);
	ПараметрыПроцедуры.Вставить("РежимОбновления",       РежимОбновления);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обновление данных классификаторов.'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"РаботаСКлассификаторами.ИнтерактивноеОбновлениеКлассификаторов",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьИндикаторЗагрузки(СтатусВыполнения, ДополнительныеПараметры) Экспорт
	
	Результат = ПрочитатьПрогресс(СтатусВыполнения.ИдентификаторЗадания);
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИндикаторОбновления = Результат.Процент;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрочитатьПрогресс(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ПрочитатьПрогресс(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура НачатьОбновлениеКлассификаторовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		РезультатОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
			УстановитьОтображениеИнформацииОбОшибке(
				ЭтотОбъект,
				РезультатОперации.СообщениеОбОшибке,
				Ложь);
		Иначе
			УстановитьОтображениеУспешногоЗавершения(ЭтотОбъект);
		КонецЕсли;
		
		// Обновление открытых форм классификаторов.
		Идентификаторы = Новый Массив;
		Для Каждого СтрокаТаблицы Из ДанныеКлассификаторов Цикл 
			Идентификаторы.Добавить(СтрокаТаблицы.Идентификатор);
		КонецЦикла;
		
		Оповестить(
			РаботаСКлассификаторамиКлиент.ИмяСобытияОповещенияОЗагрузки(),
			Идентификаторы,
			ЭтотОбъект);
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ИнформацияОбОшибке = Результат.КраткоеПредставлениеОшибки;
		УстановитьОтображениеИнформацииОбОшибке(ЭтотОбъект, ИнформацияОбОшибке);
	КонецЕсли;
	
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеЭлементовФормы(Форма)
	
	Элементы = Форма.Элементы;
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРежимаОбновления Тогда
		Элементы.КнопкаНазад.Видимость = Ложь;
		Элементы.КнопкаДалее.Видимость = Истина;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу Тогда
		Элементы.КнопкаНазад.Видимость = Истина;
		Элементы.КнопкаДалее.Видимость = Истина;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборКлассификаторов Тогда
		Элементы.КнопкаНазад.Видимость = Истина;
		КнопкаДалееДоступна = Ложь;
		Для Каждого СтрокаКлассификатора Из Форма.ДанныеКлассификаторов Цикл
			Если СтрокаКлассификатора.ТребуетсяОбновление Тогда
				КнопкаДалееДоступна = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если КнопкаДалееДоступна Тогда
			Элементы.КнопкаДалее.Видимость = Истина;
		Иначе
			Элементы.КнопкаДалее.Видимость = Ложь;
		КонецЕсли;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация Тогда
		Элементы.КнопкаНазад.Видимость = Ложь;
		Элементы.КнопкаДалее.Видимость = Ложь;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРезультатыОбновления Тогда
		Элементы.КнопкаНазад.Видимость = Истина;
		Элементы.КнопкаДалее.Видимость = Ложь;
	КонецЕсли;
	
	Если Форма.РежимОбновления = 0 Тогда
		Элементы.ФайлОбновления.Доступность = Ложь;
	Иначе
		Элементы.ФайлОбновления.Доступность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеИнформацииОбОшибке(
		Форма,
		ИнформацияОбОшибке,
		Ошибка = Истина,
		ОтображатьЖР = Истина)
	
	Если ОтображатьЖР Тогда
		ЧастиСтрок = Новый Массив;
		ЧастиСтрок.Добавить(ИнформацияОбОшибке);
		ЧастиСтрок.Добавить(Символы.ПС);
		ЧастиСтрок.Добавить(Символы.ПС);
		ЧастиСтрок.Добавить(НСтр("ru = 'Подробную информацию см. в'"));
		ЧастиСтрок.Добавить(Символы.НПП);
		ЧастиСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Журнале регистрации'"),,,,"action:openLog"));
		ЧастиСтрок.Добавить(".");
		ПредставлениеОшибки = Новый ФорматированнаяСтрока(ЧастиСтрок);
	Иначе
		ПредставлениеОшибки = ИнформацияОбОшибке;
	КонецЕсли;
	
	Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница        = Форма.Элементы.ГруппаРезультатыОбновления;
	Форма.Элементы.ДекорацияОписаниеРезультата.Заголовок = ПредставлениеОшибки;
	Форма.Элементы.ДекорацияКартинкаРезультат.Картинка   = ?(
		Ошибка,
		БиблиотекаКартинок.Ошибка32,
		БиблиотекаКартинок.Предупреждение32);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеУспешногоЗавершения(Форма)
	
	Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница        = Форма.Элементы.ГруппаРезультатыОбновления;
	Форма.Элементы.ДекорацияКартинкаРезультат.Картинка   = БиблиотекаКартинок.Успешно32;
	Форма.Элементы.ДекорацияОписаниеРезультата.Заголовок = НСтр("ru = 'Обновление классификаторов успешно завершено.'");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеКлассификаторовВерсия.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеКлассификаторовНаименование.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеКлассификаторовОтметка.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДанныеКлассификаторов.ТребуетсяОбновление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",     Новый Цвет(128,128,128));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтметку(Значение)
	
	Для Каждого СтрокаКлассификатора Из ДанныеКлассификаторов Цикл
		Если Не СтрокаКлассификатора.ТребуетсяОбновление Тогда
			Продолжить;
		КонецЕсли;
		СтрокаКлассификатора.Отметка = Значение;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РежимОбновленияИзФайла()
	
	Возврат 1;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РежимОбновленияЧерезИнтернет()
	
	Возврат 0;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОбновлениеНеТребуется(Наименование)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 (обновление не требуется)'"),
		Наименование);
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыПолученияИнформацииОбОбновлениях()
	
	ДанныеКлассификаторов.Очистить();
	
	ВерсииКлассификаторов = РаботаСКлассификаторами.ДанныеКлассификаторовДляИнтерактивногоОбновления();
	Идентификаторы = Новый Массив;
	
	Для Каждого ОписаниеКлассификатора Из ВерсииКлассификаторов Цикл
		Идентификаторы.Добавить(ОписаниеКлассификатора.Идентификатор);
	КонецЦикла;
	
	ПараметрыПолучения = Новый Структура;
	ПараметрыПолучения.Вставить("ВерсииКлассификаторов", ВерсииКлассификаторов);
	ПараметрыПолучения.Вставить("Идентификаторы",        Идентификаторы);
	
	Возврат ПараметрыПолучения;
	
КонецФункции

#КонецОбласти
