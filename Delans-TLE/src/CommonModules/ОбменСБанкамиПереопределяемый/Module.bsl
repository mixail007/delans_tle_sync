////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиПереопределяемый: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет массив актуальными видами электронных документов для прикладного решения.
//
// Параметры:
//  Массив - виды актуальных ЭД.
//
Процедура ПолучитьАктуальныеВидыЭД(Массив) Экспорт
	
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.ПлатежноеПоручение);
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.ЗапросВыписки);
	
КонецПроцедуры

// Используется для получения номеров счетов в виде массив строк
//
// Параметры:
//  Организация - <СправочникСсылка.Организации> - отбор по организации.
//  Банк - <СправочникСсылка.КлассификаторБанковРФ> - отбор по банку.
//  МассивНомеровБанковскихСчетов - массив возврата, в элементах строки с номерами счетов
//
Процедура ПолучитьНомераБанковскихСчетов(Организация, Банк, МассивНомеровБанковскихСчетов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	БанковскиеСчета.НомерСчета
	               |ИЗ
	               |	Справочник.БанковскиеСчета КАК БанковскиеСчета
	               |ГДЕ
	               |	БанковскиеСчета.Банк = &Банк
	               |	И БанковскиеСчета.Владелец = &Организация
	               |	И НЕ БанковскиеСчета.ПометкаУдаления";
	Запрос.УстановитьПараметр("Банк", Банк);
	Запрос.УстановитьПараметр("Организация", Организация);
	ТабРез = Запрос.Выполнить().Выгрузить();
	МассивНомеровБанковскихСчетов = ТабРез.ВыгрузитьКолонку("НомерСчета");
	
КонецПроцедуры

// Определяет параметры электронного документа по типу владельца.
//
// Параметры:
//  Источник - объекта либо ссылка документа/справочника-источника.
//  ПараметрыЭД - структура параметров источника, необходимых для определения
//                настроек обмена ЭД. Обязательные параметры: ВидЭД, Банк, Организация.
//
Процедура ЗаполнитьПараметрыЭДПоИсточнику(Источник, ПараметрыЭД) Экспорт
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("ДокументСсылка.ПлатежноеПоручение")
		ИЛИ ТипИсточника = Тип("ДокументОбъект.ПлатежноеПоручение") Тогда
		
		ПараметрыЭД.ВидЭД = Перечисления.ВидыЭДОбменСБанками.ПлатежноеПоручение;
		ПараметрыЭД.Организация = Источник.Организация;
		СчетОрганизации = Источник.БанковскийСчет;
		Если ЗначениеЗаполнено(СчетОрганизации) Тогда
			ПараметрыЭД.Банк = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СчетОрганизации, "Банк");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Платежное поручение.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПлатежноеПоручение из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//
Процедура ЗаполнитьДанныеПлатежныхПоручений(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
	Счетчик = 0;
	Для Каждого СсылкаНаОбъект Из МассивСсылок Цикл
		
		ДеревоДокумента = ДанныеДляЗаполнения.Получить(Счетчик);
		Счетчик = Счетчик + 1;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПлатежноеПоручение.Дата,
		|	ПлатежноеПоручение.СуммаДокумента КАК Сумма,
		|	ПлатежноеПоручение.Контрагент.НаименованиеПолное КАК РеквизитыПолучателя_Наименование,
		|	ПлатежноеПоручение.Контрагент.ИНН КАК РеквизитыПолучателя_ИНН,
		|	ПлатежноеПоручение.Контрагент.КПП КАК РеквизитыПолучателя_КПП,
		|	ПлатежноеПоручение.СчетКонтрагента.НомерСчета КАК РеквизитыПолучателя_РасчСчет,
		|	ПлатежноеПоручение.СчетКонтрагента.Банк.Код КАК РеквизитыПолучателя_Банк_БИК,
		|	ПлатежноеПоручение.СчетКонтрагента.Банк.Наименование КАК РеквизитыПолучателя_Банк_Наименование,
		|	ПлатежноеПоручение.СчетКонтрагента.Банк.Город КАК РеквизитыПолучателя_Банк_Город,
		|	ПлатежноеПоручение.СчетКонтрагента.Банк.КоррСчет КАК РеквизитыПолучателя_Банк_КоррСчет,
		|	ПлатежноеПоручение.Организация.Наименование КАК РеквизитыПлательщика_Наименование,
		|	ПлатежноеПоручение.Организация.ИНН КАК РеквизитыПлательщика_ИНН,
		|	ПлатежноеПоручение.Организация.КПП КАК РеквизитыПлательщика_КПП,
		|	ПлатежноеПоручение.БанковскийСчет.НомерСчета КАК РеквизитыПлательщика_РасчСчет,
		|	ПлатежноеПоручение.БанковскийСчет.Банк.Код КАК РеквизитыПлательщика_Банк_БИК,
		|	ПлатежноеПоручение.БанковскийСчет.Банк.Наименование КАК РеквизитыПлательщика_Банк_Наименование,
		|	ПлатежноеПоручение.БанковскийСчет.Банк.Город КАК РеквизитыПлательщика_Банк_Город,
		|	ПлатежноеПоручение.БанковскийСчет.Банк.КоррСчет КАК РеквизитыПлательщика_Банк_КоррСчет,
		|	ПлатежноеПоручение.ВидПлатежа КАК РеквизитыПлатежа_ВидПлатежа,
		|	""01"" КАК РеквизитыПлатежа_ВидОплаты,
		|	ПлатежноеПоручение.ОчередностьПлатежа КАК РеквизитыПлатежа_Очередность,
		|	ПлатежноеПоручение.ИдентификаторПлатежа КАК РеквизитыПлатежа_Код,
		|	ПлатежноеПоручение.НазначениеПлатежа КАК РеквизитыПлатежа_НазначениеПлатежа,
		|	ПлатежноеПоручение.Контрагент КАК Получатель,
		|	ВЫБОР
		|		КОГДА ПлатежноеПоручение.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПлатежноеПоручение.ПеречислениеНалога)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ПеречислениеВБюджет,
		|	ПлатежноеПоручение.СтатусСоставителя КАК ПлатежиВБюджет_СтатусСоставителя,
		|	ПлатежноеПоручение.КодБК КАК ПлатежиВБюджет_ПоказательКБК,
		|	ПлатежноеПоручение.КодОКАТО КАК ПлатежиВБюджет_ОКТМО,
		|	ПлатежноеПоручение.ПоказательОснования КАК ПлатежиВБюджет_ПоказательОснования,
		|	ВЫБОР
		|		КОГДА ПлатежноеПоручение.ПоказательПериода = """"
		|			ТОГДА ""0""
		|		ИНАЧЕ ПлатежноеПоручение.ПоказательПериода
		|	КОНЕЦ КАК ПлатежиВБюджет_ПоказательПериода,
		|	ВЫБОР
		|		КОГДА ПлатежноеПоручение.ПоказательНомера = """"
		|			ТОГДА ""0""
		|		ИНАЧЕ ПлатежноеПоручение.ПоказательНомера
		|	КОНЕЦ КАК ПлатежиВБюджет_ПоказательНомера,
		|	ПлатежноеПоручение.ПоказательДаты КАК ПоказательДаты
		|ИЗ
		|	Документ.ПлатежноеПоручение КАК ПлатежноеПоручение
		|ГДЕ
		|	ПлатежноеПоручение.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
		ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
		
		Если ТаблицаДокументов.Количество()>0 Тогда
			
			ПлатежноеПоручение = ТаблицаДокументов[0];
			
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "Дата",
				ПлатежноеПоручение.Дата);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "Сумма",
				ПлатежноеПоручение.Сумма);
			
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлатежа.ВидПлатежа",
				ПлатежноеПоручение.РеквизитыПлатежа_ВидПлатежа);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлатежа.ВидОплаты",
				"01");
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлатежа.Очередность",
				ПлатежноеПоручение.РеквизитыПлатежа_Очередность);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлатежа.Код",
				ПлатежноеПоручение.РеквизитыПлатежа_Код);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлатежа.НазначениеПлатежа",
				ПлатежноеПоручение.РеквизитыПлатежа_НазначениеПлатежа);
			
			// Плательщик
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.Наименование",
				ПлатежноеПоручение.РеквизитыПлательщика_Наименование);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.ИНН",
				ПлатежноеПоручение.РеквизитыПлательщика_ИНН);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.КПП",
				ПлатежноеПоручение.РеквизитыПлательщика_КПП);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.РасчСчет",
				ПлатежноеПоручение.РеквизитыПлательщика_РасчСчет);
			
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.Банк.БИК",
				ПлатежноеПоручение.РеквизитыПлательщика_Банк_БИК);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.Банк.Наименование",
				ПлатежноеПоручение.РеквизитыПлательщика_Банк_Наименование);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.Банк.Город",
				ПлатежноеПоручение.РеквизитыПлательщика_Банк_Город);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.Банк.КоррСчет",
				ПлатежноеПоручение.РеквизитыПлательщика_Банк_КоррСчет);
			
			// Получатель
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "Получатель",
				ПлатежноеПоручение.Получатель);
			
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.Наименование",
				ПлатежноеПоручение.РеквизитыПолучателя_Наименование);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.ИНН",
				ПлатежноеПоручение.РеквизитыПолучателя_ИНН);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.КПП",
				ПлатежноеПоручение.РеквизитыПолучателя_КПП);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.РасчСчет",
				ПлатежноеПоручение.РеквизитыПолучателя_РасчСчет);
			
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.Банк.БИК",
				ПлатежноеПоручение.РеквизитыПолучателя_Банк_БИК);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.Банк.Наименование",
				ПлатежноеПоручение.РеквизитыПолучателя_Банк_Наименование);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.Банк.Город",
				ПлатежноеПоручение.РеквизитыПолучателя_Банк_Город);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.Банк.КоррСчет",
				ПлатежноеПоручение.РеквизитыПолучателя_Банк_КоррСчет);
				
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет",
				ПлатежноеПоручение.ПеречислениеВБюджет);
				
			// Платежи в бюджет
			Если ПлатежноеПоручение.ПеречислениеВБюджет Тогда
				
				ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет.СтатусСоставителя",
					ПлатежноеПоручение.ПлатежиВБюджет_СтатусСоставителя);
				ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет.ПоказательКБК",
					ПлатежноеПоручение.ПлатежиВБюджет_ПоказательКБК);
				ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет.ОКТМО",
					ПлатежноеПоручение.ПлатежиВБюджет_ОКТМО);
				ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет.ПоказательОснования",
					ПлатежноеПоручение.ПлатежиВБюджет_ПоказательОснования);
				ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет.ПоказательПериода",
					ПлатежноеПоручение.ПлатежиВБюджет_ПоказательПериода);
				ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет.ПоказательНомера",
					ПлатежноеПоручение.ПлатежиВБюджет_ПоказательНомера);
					
				ПоказательДатыСтрокой = Формат(ПлатежноеПоручение.ПоказательДаты, "ДФ=dd.MM.yyyy");
				ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет.ПоказательДаты",
					ПоказательДатыСтрокой);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Платежное требование.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПлатежноеТребование из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//
Процедура ЗаполнитьДанныеПлатежныхТребований(МассивСсылок, ДанныеДляЗаполнения) Экспорт

КонецПроцедуры

// Подготавливает данные для электронного документа типа Поручение на перевод валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПоручениеНаПереводВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//
Процедура ЗаполнитьДанныеПорученийНаПереводВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Поручение на покупку валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПоручениеНаПокупкуВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//
Процедура ЗаполнитьДанныеПорученийНаПокупкуВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Поручение на продажу валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПоручениеНаПродажуВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//
Процедура ЗаполнитьДанныеПорученийНаПродажуВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Распоряжение на обязательную продажу валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета РаспоряжениеНаОбязательнуюПродажуВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//
Процедура ЗаполнитьДанныеРаспоряженийНаОбязательнуюПродажуВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Справка о подтверждающих документах.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета СправкаОПодтверждающихДокументах из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//
Процедура ЗаполнитьДанныеСправокОПодтверждающихДокументах(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
КонецПроцедуры

// Вызывается при получении уведомления о зачислении валюты
//
// Параметры:
//  ДеревоРазбора - ДеревоЗначений - дерево данных, соответствующее макету Обработки.ОбменСБанками.УведомлениеОЗачислении
//  НовыйДокументСсылка - ДокументСсылка - ссылка на созданный документ на основании данных электронного документа.
//
Процедура ПриПолученииУведомленияОЗачислении(ДеревоРазбора, НовыйДокументСсылка) Экспорт
	
КонецПроцедуры

// Заполняет список команд ЭДО.
// 
// Параметры:
//  СоставКоманд - Массив - например "Документ._ДемоПлатежныйДокумент".
//
Процедура ПодготовитьСтруктуруОбъектовКомандЭДО(СоставКомандЭДО) Экспорт
	
	СоставКомандЭДО.Добавить("Документ.ПлатежноеПоручение");
	
КонецПроцедуры

// Включает тестовый режим обмена в банком.
// При включении тестового режима возможно ручное указание URL сервера для получения настроек обмена.
//
// Параметры:
//    Используется - Булево - признак использования тестового режима.
//
Процедура ПроверитьИспользованиеТестовогоРежима(ИспользуетсяТестовыйРежим) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Найти(ВРег(Константы.ЗаголовокСистемы.Получить()), ВРег("DirectBank")) > 0 Тогда
		
		ИспользуетсяТестовыйРежим = Истина;
		
	Иначе
		
		ИспользуетсяТестовыйРежим = Константы.ИспользоватьТестовыйРежимDirectBank.Получить();
		
	КонецЕсли;
	
КонецПроцедуры

#Область ЗарплатныйПроект

// Вызывается для формирования XML файла в прикладном решении
//
// Параметры:
//    ОбъектДляВыгрузки = ДокументСсылка - ссылка на документ, на основании которого будет сформирован ЭД.
//    ИмяФайла - Строка - имя сформированного файла
//    АдресФайла - АдресВременногоХранилища - содержит двоичные данные файла
//
Процедура ПриФормированииXMLФайла(ОбъектДляВыгрузки, ИмяФайла, АдресФайла) Экспорт
	
КонецПроцедуры

// Формирует табличный документ на основании файла XML для визуального отображения электронного документа.
//
// Параметры:
//  ИмяФайла - Строка - полный путь к файлу XML
//  ТабличныйДокумент - ТабличныйДокумент - возвращаемое значение, визуальное отображение данных файла.
//
Процедура ЗаполнитьТабличныйДокумент(Знач ИмяФайла, ТабличныйДокумент) Экспорт
	
КонецПроцедуры

// Вызывается при получении файла из банка
//
// Параметры:
// АдресДанныхФайла - Строка - адрес временного хранилища с двоичными данными файла.
// ИмяФайла - Строка - формализованное имя файла данных
// ИдентификаторЭДВладельца - Строка - (возвращаемый параметр) идентификатор ЭД, на основании которого был получен ответ из банка.
// ОбъектВладелец - ДокументСсылка - (возвращаемый параметр) ссылка на документ, который был создан на основании ЭД.
// ДанныеОповещения - Структура - (возвращаемый параметр) данные для вызова метода Оповестить на клиенте.
//                 * Ключ - Строка - имя события
//                 * Значение - Произвольный - параметр сообщения
Процедура ПриПолученииXMLФайла(АдресДанныхФайла, ИмяФайла, ОбъектВладелец, ДанныеОповещения) Экспорт
	
КонецПроцедуры

// Вызвается при изменении состояния элекронного документооборота.
//
// Параметры:
//  СсылкаНаОбъект - ДокументСсылка - владелец электронного документооборота;
//  СостояниеЭД - ПеречислениеСсылка.СостоянияОбменСБанками - новое состояние электронного документооборота.
//
Процедура ПриИзмененииСостоянияЭД(СсылкаНаОбъект, СостояниеЭД) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
