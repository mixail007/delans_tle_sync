#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ВыполнитьЗакрытиеМесяца(СтруктураПараметров, ФоновоеЗаданиеАдресХранилища = "") Экспорт
	
	ТекМесяц = СтруктураПараметров.ТекМесяц;
	ТекГод = СтруктураПараметров.ТекГод;
	Организация = СтруктураПараметров.Организация;
	МассивОпераций = СтруктураПараметров.МассивОпераций;
	
	СтруктураТекущихДокументов = ОтменитьЗакрытиеМесяца(СтруктураПараметров);
	
	Если СтруктураПараметров.ВыполнитьРасчетАмортизации Тогда
		
		Если ЗначениеЗаполнено(СтруктураТекущихДокументов.ДокументАмортизацияВА) Тогда
			
			ДокОбъект = СтруктураТекущихДокументов.ДокументАмортизацияВА.ПолучитьОбъект();
			Если ДокОбъект.ПометкаУдаления Тогда
				ДокОбъект.УстановитьПометкуУдаления(Ложь);
			КонецЕсли;
			
		Иначе
			
			ДокОбъект = Документы.АмортизацияВА.СоздатьДокумент();
			ДокОбъект.Организация = Организация;
			ДокОбъект.Дата = КонецМесяца(Дата(ТекГод, ТекМесяц, 1));
			ДокОбъект.Комментарий = НСтр("ru='#Создан автоматически, помощником закрытия месяца.'");
			
		КонецЕсли;
		
		ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
	КонецЕсли;
	
	МассивДокументовЗМ = СтруктураТекущихДокументов.ДокументЗакрытиеМесяца;
	РазмерМассиваДокументовЗМ = МассивДокументовЗМ.Количество() - 1;
	РазмерМассиваОпераций = МассивОпераций.Количество() - 1;
	
	Для Итератор = 0 По РазмерМассиваОпераций Цикл
		
		Операция = МассивОпераций[Итератор];
		ДокументЗакрытияМесяца = ?(Итератор <= РазмерМассиваДокументовЗМ, МассивДокументовЗМ[Итератор], Неопределено);
		ВыполнитьОперациюЗакрытияМесяца(СтруктураПараметров, Операция, ДокументЗакрытияМесяца);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ОтменитьЗакрытиеМесяца(СтруктураПараметров) Экспорт
	
	ТекМесяц = СтруктураПараметров.ТекМесяц;
	ТекГод = СтруктураПараметров.ТекГод;
	Организация = СтруктураПараметров.Организация;
	
	СтруктураВозврата = Новый Структура("ДокументЗакрытиеМесяца, ДокументАмортизацияВА");
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗакрытиеМесяца.Дата КАК Дата,
	|	ЗакрытиеМесяца.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗакрытиеМесяца КАК ЗакрытиеМесяца
	|ГДЕ
	|	ГОД(ЗакрытиеМесяца.Дата) = &Год
	|	И МЕСЯЦ(ЗакрытиеМесяца.Дата) = &Месяц
	|	И ЗакрытиеМесяца.Организация = &Организация
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АмортизацияВА.Дата КАК Дата,
	|	АмортизацияВА.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.АмортизацияВА КАК АмортизацияВА
	|ГДЕ
	|	ГОД(АмортизацияВА.Дата) = &Год
	|	И МЕСЯЦ(АмортизацияВА.Дата) = &Месяц
	|	И АмортизацияВА.Организация = &Организация
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Ссылка";
	
	Запрос.УстановитьПараметр("Год", ТекГод);
	Запрос.УстановитьПараметр("Месяц", ТекМесяц);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ДокВыборка = РезультатЗапроса[1].Выбрать();
	Пока ДокВыборка.Следующий() Цикл
		
		ДокОбъект = ДокВыборка.Ссылка.ПолучитьОбъект();
		Если ДокОбъект.ПометкаУдаления Тогда
			ДокОбъект.УстановитьПометкуУдаления(Ложь);
		КонецЕсли;
		
		ДокОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		СтруктураВозврата.ДокументАмортизацияВА = ДокВыборка.Ссылка;
		
	КонецЦикла;
	
	СтруктураВозврата.ДокументЗакрытиеМесяца = Новый Массив;
	
	ДокВыборка = РезультатЗапроса[0].Выбрать();
	Пока ДокВыборка.Следующий() Цикл
		
		ДокОбъект = ДокВыборка.Ссылка.ПолучитьОбъект();
		Если ДокОбъект.ПометкаУдаления Тогда
			ДокОбъект.УстановитьПометкуУдаления(Ложь);
		КонецЕсли;
		
		ДокОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		СтруктураВозврата.ДокументЗакрытиеМесяца.Добавить(ДокВыборка.Ссылка);
		
	КонецЦикла;
	
	Возврат СтруктураВозврата;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьОперациюЗакрытияМесяца(СтруктураПараметров, Операция, ДокументЗакрытияМесяца)
	
	ТекМесяц = СтруктураПараметров.ТекМесяц;
	ТекГод = СтруктураПараметров.ТекГод;
	Организация = СтруктураПараметров.Организация;
	
	Если ДокументЗакрытияМесяца = Неопределено Тогда
		
		ДокОбъект = Документы.ЗакрытиеМесяца.СоздатьДокумент();
		ДокОбъект.Организация = Организация;
		ДокОбъект.Дата = КонецМесяца(Дата(ТекГод, ТекМесяц, 1));
		ДокОбъект.Комментарий = НСтр("ru='#Создан автоматически, помощником закрытия месяца.'");
		
	Иначе
		
		ДокОбъект = ДокументЗакрытияМесяца.ПолучитьОбъект();
		
		Если ДокОбъект.ПометкаУдаления Тогда
			ДокОбъект.УстановитьПометкуУдаления(Ложь);
		КонецЕсли;
		
		ДокОбъект.РасчетПрямыхЗатрат = Ложь;
		ДокОбъект.РаспределениеЗатрат = Ложь;
		ДокОбъект.РасчетФактическойСебестоимости = Ложь;
		ДокОбъект.РасчетФинансовогоРезультата = Ложь;
		ДокОбъект.РасчетКурсовыхРазниц = Ложь;
		ДокОбъект.РасчетСебестоимостиВРозницеСуммовойУчет = Ложь;
		
	КонецЕсли;
	
	ДокОбъект[Операция] = Истина;
	ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры

#КонецОбласти

#Область ТекущиеДела

// Заполняет список текущих дел пользователя.
// Описание параметров процедуры см. в ТекущиеДелаСлужебный.НоваяТаблицаТекущихДел()
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ГруппаДел	= НСтр("ru = 'Закрытие месяца'");
	ИмяФормы	= "Обработка.ЗакрытиеМесяца.Форма.Форма";
	
	ОбщиеПараметрыЗапросов = ТекущиеДелаСлужебный.ОбщиеПараметрыЗапросов();
	
	Если Не ОбщиеПараметрыЗапросов.ЭтоПолноправныйПользователь
		Или ТекущиеДелаСервер.ДелоОтключено(ГруппаДел) Тогда
		
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
		|			КОГДА ТИПЗНАЧЕНИЯ(ДокЗакрытиеМесяца.Ссылка) <> ТИП(Документ.ЗакрытиеМесяца)
		|				ТОГДА ЗапасыОстатки.Организация
		|		КОНЕЦ) КАК ЗакрытиеМесяцаНеРассчитаныИтоги
		|ИЗ
		|	РегистрНакопления.Запасы.Остатки(КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(&ТекущаяДата, МЕСЯЦ, -1), МЕСЯЦ), ) КАК ЗапасыОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗакрытиеМесяца КАК ДокЗакрытиеМесяца
		|		ПО ЗапасыОстатки.Организация = ДокЗакрытиеМесяца.Организация
		|			И (ДокЗакрытиеМесяца.Проведен)
		|			И (НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(&ТекущаяДата, МЕСЯЦ, -1), МЕСЯЦ) = НАЧАЛОПЕРИОДА(ДокЗакрытиеМесяца.Дата, МЕСЯЦ))";
	
	ДанныеДел = ТекущиеДелаСлужебный.ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов);
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор	 = "ЗакрытиеМесяцаНеРассчитаныИтоги";
	Дело.ЕстьДела		= ДанныеДел.ЗакрытиеМесяцаНеРассчитаныИтоги > 0;
	Дело.Важное			= Истина;
	Дело.Представление	= НСтр("ru = 'Выполнить закрытие месяца'");
	Дело.Количество		= ДанныеДел.ЗакрытиеМесяцаНеРассчитаныИтоги;
	Дело.Форма			= ИмяФормы;
	Дело.ПараметрыФормы	= Новый Структура("ТекущиеДела");
	Дело.Владелец		= ГруппаДел;
	Дело.Подсказка		= НСтр("ru = 'Закрытие месяца необходимо выполнить для окончательного расчета себестоимости, финансового результата и курсовых разниц'");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли