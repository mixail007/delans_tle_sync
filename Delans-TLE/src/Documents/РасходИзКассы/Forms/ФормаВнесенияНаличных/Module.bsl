#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ИнтернетПоддержкаПользователей.Новости
	ОбработкаНовостей.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтотОбъект,
		"УНФ.Документ.РасходИзКассы",
		"ФормаВнесенияНаличных",
		Неопределено,
		НСтр("ru='Новости: Внесение денег'"),
		Ложь,
		Новый Структура("ПолучатьНовостиНаСервере, ХранитьМассивНовостейТолькоНаСервере", Истина, Истина),
		"ПриОткрытии"
	);
	// Конец ИнтернетПоддержкаПользователей.Новости
	
	Если Параметры.Свойство("Касса") Тогда
		ДенежныеСредстваКПоступлению.Параметры.УстановитьЗначениеПараметра("Касса", Параметры.Касса);
	Иначе
		КассаККМ = Справочники.КассыККМ.ПолучитьКассуККМПоУмолчанию(Перечисления.ТипыКассККМ.ФискальныйРегистратор);
		ДенежныеСредстваКПоступлению.Параметры.УстановитьЗначениеПараметра("Касса", КассаККМ);
	КонецЕсли;
	
	ДенежныеСредстваКПоступлению.Параметры.УстановитьЗначениеПараметра("ПоказатьВыемки", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.Новости
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВнестиДеньги(Команда)
	
	Если Элементы.ДенежныеСредстваКПоступлению.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДокумента = СоздатьВнесениеДенегНаСервере(Элементы.ДенежныеСредстваКПоступлению.ТекущиеДанные.Ссылка,
													   Элементы.ДенежныеСредстваКПоступлению.ТекущиеДанные.СуммаОстаток);
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Создан документ'"),
								   ПолучитьНавигационнуюСсылку(СтруктураДокумента.Ссылка), СтруктураДокумента.Ссылка);
	
	Закрыть(СтруктураДокумента.СуммаДокумента);
	
КонецПроцедуры

&НаСервере
Функция СоздатьВнесениеДенегНаСервере(ДокументОснование, Сумма)
	
	СтруктураЗаполнения = СформироватьСтруктуруДляЗаполненияДокумента(ДокументОснование, Сумма);
	
	СсылкаНаДокумент = СформироватьИПровестиДокумент(СтруктураЗаполнения);
	
	СтруктураВозврата = Новый Структура("Ссылка, СуммаДокумента",
										 СсылкаНаДокумент,
										 СсылкаНаДокумент.СуммаДокумента);
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаСервере
Функция СформироватьСтруктуруДляЗаполненияДокумента(ДокументОснование, Сумма)
	
	ОтчетОРозничныхПродажах = РозничныеПродажиСервер.ПолучитьСостояниеКассовойСмены(ДокументОснование.КассаККМ).ОтчетОРозничныхПродажах;
	
	СтруктураЗаполнения = Новый Структура;
	СтруктураЗаполнения.Вставить("ДокументОснование", ДокументОснование);
	СтруктураЗаполнения.Вставить("Дата", ТекущаяДата());
	СтруктураЗаполнения.Вставить("Организация", ДокументОснование.Организация);
	СтруктураЗаполнения.Вставить("КассаККМ", ДокументОснование.КассаККМ);
	СтруктураЗаполнения.Вставить("ВалютаДенежныхСредств", ДокументОснование.КассаККМ.ВалютаДенежныхСредств);
	СтруктураЗаполнения.Вставить("СуммаДокумента", Сумма);
	СтруктураЗаполнения.Вставить("ОтчетОРозничныхПродажах", ОтчетОРозничныхПродажах);
	
	Возврат СтруктураЗаполнения;
	
КонецФункции

&НаСервере
Функция СформироватьИПровестиДокумент(СтруктураЗаполнения)
	
	ВнесениеНаличных = Документы.ВнесениеНаличных.СоздатьДокумент();
	ВнесениеНаличных.Заполнить(СтруктураЗаполнения);
	ВнесениеНаличных.Записать(РежимЗаписиДокумента.Проведение);
	
	Возврат ВнесениеНаличных.Ссылка;
	
КонецФункции

&НаКлиенте
Процедура ПоказыватьВыемки(Команда)
	
	Элементы.ДенежныеСредстваКПоступлениюПоказыватьВыемки.Пометка = Не Элементы.ДенежныеСредстваКПоступлениюПоказыватьВыемки.Пометка;
	
	ДенежныеСредстваКПоступлению.Параметры.УстановитьЗначениеПараметра("ПоказатьВыемки", Элементы.ДенежныеСредстваКПоступлениюПоказыватьВыемки.Пометка);
	Элементы.ДенежныеСредстваКПоступлению.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// ИнтернетПоддержкаПользователей.Новости
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, "ПриОткрытии");
	
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.Новости

#КонецОбласти