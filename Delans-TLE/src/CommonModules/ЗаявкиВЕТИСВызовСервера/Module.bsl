/////////////////////////////////////////////////////////////////////
//
// Заявки (клиентские вызовы):
//  * Подготовка сообщений для сервиса ВетИС в формате XML
//  * Отправка полученных сообщений в очередь обмена
//

#Область ПрограммныйИнтерфейс

Функция ПодготовитьЗапросНаРегистрациюИзменениеХозяйствующегоСубъекта(Знач ХозяйствующийСубъект, ДанныеХозяйствующегоСубъекта, УникальныйИдентификатор) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	Если ХозяйствующийСубъект = Неопределено
		И ПараметрыОбмена.НастройкиОбмена.Количество() > 0 Тогда
		Для Каждого КлючИЗначение Из ПараметрыОбмена.НастройкиОбмена Цикл
			ХозяйствующийСубъект = КлючИЗначение.Ключ;
		КонецЦикла;
	КонецЕсли;
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросНаРегистрациюИзменениеХозяйствующегоСубъектаXML(
		ХозяйствующийСубъект, ДанныеХозяйствующегоСубъекта, ПараметрыОбмена);
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор, Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПодготовитьЗапросНаРегистрациюИзменениеПредприятия(Знач ХозяйствующийСубъект, ДанныеПредприятия, УникальныйИдентификатор) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	Если ХозяйствующийСубъект = Неопределено
		И ПараметрыОбмена.НастройкиОбмена.Количество() > 0 Тогда
		Для Каждого КлючИЗначение Из ПараметрыОбмена.НастройкиОбмена Цикл
			ХозяйствующийСубъект = КлючИЗначение.Ключ;
		КонецЦикла;
	КонецЕсли;
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросНаРегистрациюИзменениеПредприятияXML(
		ХозяйствующийСубъект, ДанныеПредприятия, ПараметрыОбмена);
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор, Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПодготовитьЗапросНаСозданиеУдалениеСвязиПредприятияИХозяйствующегоСубъекта(Знач ХозяйствующийСубъект, Предприятие, СпособИзменения, GLN, УникальныйИдентификатор) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросНаСозданиеУдалениеСвязиМеждуХозяйствующимСубъектомИПредприятиемXML(
		ХозяйствующийСубъект, Предприятие, СпособИзменения, GLN, ПараметрыОбмена);
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор, Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Подготовить запрос на создание изменение продукции
//
// Параметры:
//  ХозяйствующийСубъект - СправочникСсылка.ХозяйствующиеСубъектыВЕТИС - 
//  ДанныеПродукции - Структруа - см. функцию. ИнтеграцияВЕТИСКлиентСервер.СтруктураДанныеПродукции()
//  УникальныйИдентификатор - УникальныйИдентификатор - 
// 
// Возвращаемое значение:
//   - 
//
Функция ПодготовитьЗапросНаСозданиеИзменениеПродукции(Знач ХозяйствующийСубъект, ДанныеПродукции, УникальныйИдентификатор) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросНаСозданиеИзменениеПродукцииXML(
		ХозяйствующийСубъект, ДанныеПродукции, ПараметрыОбмена);
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор, Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПодготовитьЗапросПользователейХозяйствующегоСубъекта(Знач ХозяйствующийСубъект, КоличествоЭлементов, УникальныйИдентификатор, НастройкаОбмена = Неопределено) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	Если НастройкаОбмена <> Неопределено Тогда
		ИнтеграцияВЕТИС.ДобавитьНастройкуОбменаВПараметрыОбмена(ПараметрыОбмена, ХозяйствующийСубъект, НастройкаОбмена);
	КонецЕсли;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ХозяйствующийСубъект",   ХозяйствующийСубъект);
	ПараметрыЗапроса.Вставить("КоличествоЭлементов",    КоличествоЭлементов);
	ПараметрыЗапроса.Вставить("Смещение",               0);
	ПараметрыЗапроса.Вставить("ПервыйЗапрос",           Истина);
	ПараметрыЗапроса.Вставить("ПоследнийЗапрос",        Ложь);
	ПараметрыЗапроса.Вставить("СмещениеПервогоЗапроса", 0);
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросПользователейХозяйствующегоСубъектаXML(
		ХозяйствующийСубъект, ПараметрыЗапроса, ПараметрыОбмена);
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор, Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПодготовитьЗапросДоступныхДляНазначенияПрав(Знач ХозяйствующийСубъект, КоличествоЭлементов, УникальныйИдентификатор) Экспорт
	
	// Запрос выполняется от имени текущего пользователя
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ХозяйствующийСубъект",   ХозяйствующийСубъект);
	ПараметрыЗапроса.Вставить("КоличествоЭлементов",    КоличествоЭлементов);
	ПараметрыЗапроса.Вставить("Смещение",               0);
	ПараметрыЗапроса.Вставить("ПервыйЗапрос",           Истина);
	ПараметрыЗапроса.Вставить("ПоследнийЗапрос",        Ложь);
	ПараметрыЗапроса.Вставить("СмещениеПервогоЗапроса", 0);
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросДоступныхДляНазначенияПравXML(
		ПараметрыЗапроса.ХозяйствующийСубъект,
		ПараметрыЗапроса, ПараметрыОбмена);
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор, Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПодготовитьЗапросНаИзменениеПравПользователей(Знач ХозяйствующийСубъект, ДанныеПользователей, УникальныйИдентификатор) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ДанныеПользователей", ДанныеПользователей);
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросНаИзменениеПравПользователей(
		ХозяйствующийСубъект, ПараметрыЗапроса, ПараметрыОбмена);
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор, Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПодготовитьЗапросНаИзменениеЗонОтветственностиПользователей(Знач ХозяйствующийСубъект, ДанныеПользователей, УникальныйИдентификатор) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ДанныеПользователей", ДанныеПользователей);
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросНаИзменениеЗонОтветственностиПользователейXML(
		ХозяйствующийСубъект, ПараметрыЗапроса, ПараметрыОбмена);
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор, Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПодготовитьЗапросНаРегистрациюИПривязкуПользователейХозяйствующегоСубъекта(Знач ХозяйствующийСубъект, ДанныеПользователей, УникальныйИдентификатор) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ДанныеПользователей", ДанныеПользователей);
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросНаРегистрациюИПривязкуПользователейХозяйствующегоСубъектаXML(
		ХозяйствующийСубъект, ПараметрыЗапроса, ПараметрыОбмена);
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор, Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПодготовитьЗапросНаУдалениеСвязиПользователейСХозяйствующимСубъектом(Знач ХозяйствующийСубъект, ПользователиВЕТИС, УникальныйИдентификатор) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ПользователиВЕТИС", ПользователиВЕТИС);
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросНаУдалениеСвязиПользователейСХозяйствующимСубъектомXML(
		ХозяйствующийСубъект, ПараметрыЗапроса, ПараметрыОбмена);
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор, Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПодготовитьЗапросВетеринарноСопроводительногоДокументаПоUUID(Знач ХозяйствующийСубъект, Предприятие, Идентификаторы, УникальныйИдентификатор) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	Если ТипЗнч(Идентификаторы) = Тип("Строка") Тогда
		ИдентификаторыВСД = Новый Массив;
		ИдентификаторыВСД.Добавить(Идентификаторы);
	Иначе
		ИдентификаторыВСД = Идентификаторы;
	КонецЕсли;
	
	ВсеСообщенияXML = Новый Массив;
	Для Каждого ИдентификаторВСД Из ИдентификаторыВСД Цикл
		
		ПараметрыЗапроса = Новый Структура;
		ПараметрыЗапроса.Вставить("ХозяйствующийСубъект", ХозяйствующийСубъект);
		ПараметрыЗапроса.Вставить("Предприятие",          Предприятие);
		ПараметрыЗапроса.Вставить("Идентификатор",        ИдентификаторВСД);
		
		СообщенияXML = ЗаявкиВЕТИС.ЗапросВетеринарноСопроводительногоДокументаПоUUIDXML(
			ХозяйствующийСубъект, ПараметрыЗапроса, ПараметрыОбмена);
		
		Для Каждого СообщениеXML Из СообщенияXML Цикл
			ВсеСообщенияXML.Добавить(СообщениеXML);
		КонецЦикла;
		
	КонецЦикла;
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(ВсеСообщенияXML, ПараметрыОбмена, УникальныйИдентификатор, Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПодготовитьЗапросЗаписиСкладскогоЖурналаПоИдентификатору(Знач ХозяйствующийСубъект, Предприятие, Идентификатор, УникальныйИдентификатор) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ХозяйствующийСубъект", ХозяйствующийСубъект);
	ПараметрыЗапроса.Вставить("Предприятие",          Предприятие);
	ПараметрыЗапроса.Вставить("Идентификатор",        Идентификатор);
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросЗаписиСкладскогоЖурналаПоИдентификаторуXML(
		ХозяйствующийСубъект, ПараметрыЗапроса, ПараметрыОбмена);
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор, Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПодготовитьЗапросНаАннулированиеВетеринарногоСопроводительногоДокументаПоUUID(Знач ХозяйствующийСубъект, Идентификатор, ПричинаАннулирования, УникальныйИдентификатор) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ХозяйствующийСубъект", ХозяйствующийСубъект);
	ПараметрыЗапроса.Вставить("Идентификатор",        Идентификатор);
	ПараметрыЗапроса.Вставить("ПричинаАннулирования", ПричинаАннулирования);
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросНаАннулированиеВетеринарноСопроводительногоДокументаПоUUIDXML(
		ХозяйствующийСубъект, ПараметрыЗапроса, ПараметрыОбмена);
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор, Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПодготовитьЗапросВетеринарноСопроводительныхДокументов(Знач ХозяйствующийСубъект, Предприятие, ПараметрыОтбора, КоличествоЭлементов, УникальныйИдентификатор, НастройкаОбмена = Неопределено) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	Если НастройкаОбмена <> Неопределено Тогда
		ИнтеграцияВЕТИС.ДобавитьНастройкуОбменаВПараметрыОбмена(ПараметрыОбмена, ХозяйствующийСубъект, НастройкаОбмена);
	КонецЕсли;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ХозяйствующийСубъект",   ХозяйствующийСубъект);
	ПараметрыЗапроса.Вставить("Предприятие",            Предприятие);
	ПараметрыЗапроса.Вставить("ПараметрыОтбора",        ПараметрыОтбора);
	ПараметрыЗапроса.Вставить("КоличествоЭлементов",    КоличествоЭлементов);
	ПараметрыЗапроса.Вставить("Смещение",               0);
	ПараметрыЗапроса.Вставить("ПервыйЗапрос",           Истина);
	ПараметрыЗапроса.Вставить("ПоследнийЗапрос",        Ложь);
	ПараметрыЗапроса.Вставить("СмещениеПервогоЗапроса", 0);
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросВетеринарноСопроводительныхДокументовXML(
		ХозяйствующийСубъект, ПараметрыЗапроса, ПараметрыОбмена);
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор, Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПодготовитьЗапросНаВнесениеСведенийОВетеринарныхОперациях(Знач ХозяйствующийСубъект, ПараметрыЗапроса, УникальныйИдентификатор) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросНаВнесениеСведенийОВетеринарныхОперацияхXML(
		ХозяйствующийСубъект, ПараметрыЗапроса, ПараметрыОбмена);
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор, Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПодготовитьЗапросИзмененныхВетеринарноСопроводительныхДокументов(Знач ХозяйствующийСубъект, Предприятие, КоличествоЭлементов, УникальныйИдентификатор) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	ПустаяДата = '00010101';
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЕСТЬNULL(СинхронизацияКлассификаторовВЕТИС.ДатаСинхронизации, &ПустаяДата) КАК ДатаСинхронизации,
	|	ЕСТЬNULL(СинхронизацияКлассификаторовВЕТИС.Смещение, 0)                    КАК Смещение
	|ИЗ
	|	РегистрСведений.СинхронизацияКлассификаторовВЕТИС КАК СинхронизацияКлассификаторовВЕТИС
	|ГДЕ
	|	СинхронизацияКлассификаторовВЕТИС.ТипВЕТИС = &ТипВЕТИС
	|	И СинхронизацияКлассификаторовВЕТИС.ХозяйствующийСубъект = &ХозяйствующийСубъект
	|	И СинхронизацияКлассификаторовВЕТИС.Предприятие = &Предприятие
	|");
	
	Запрос.УстановитьПараметр("ТипВЕТИС",             Перечисления.ТипыВЕТИС.ВетеринарноСопроводительныеДокументы);
	Запрос.УстановитьПараметр("ХозяйствующийСубъект", ХозяйствующийСубъект);
	Запрос.УстановитьПараметр("Предприятие",          Предприятие);
	Запрос.УстановитьПараметр("ПустаяДата",           ПустаяДата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		НачалоПериода = Выборка.ДатаСинхронизации;
		Смещение      = Выборка.Смещение;
		
		Если ПараметрыОбмена.ИнтервалЗапросаИзмененныхДанных <> 0
			И НачалоПериода + ПараметрыОбмена.ИнтервалЗапросаИзмененныхДанных < ТекущаяДата() Тогда
			КонецПериода = НачалоПериода + ПараметрыОбмена.ИнтервалЗапросаИзмененныхДанных;
		Иначе
			КонецПериода = Неопределено;
		КонецЕсли;
		
	Иначе
		
		НачалоПериода = ПустаяДата;
		Смещение      = 0;
		
		КонецПериода  = Неопределено;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НачалоПериода) Тогда
		
		ПараметрыЗапроса = Новый Структура;
		ПараметрыЗапроса.Вставить("ХозяйствующийСубъект",   ХозяйствующийСубъект);
		ПараметрыЗапроса.Вставить("Предприятие",            Предприятие);
		ПараметрыЗапроса.Вставить("ПараметрыОтбора",        Неопределено);
		ПараметрыЗапроса.Вставить("КоличествоЭлементов",    КоличествоЭлементов);
		ПараметрыЗапроса.Вставить("Смещение",               Смещение);
		ПараметрыЗапроса.Вставить("Интервал",               ИнтеграцияВЕТИСКлиентСервер.СтруктураИнтервала(НачалоПериода, КонецПериода));
		ПараметрыЗапроса.Вставить("ПервыйЗапрос",           Истина);
		ПараметрыЗапроса.Вставить("ПоследнийЗапрос",        Ложь);
		ПараметрыЗапроса.Вставить("СмещениеПервогоЗапроса", Смещение);
		
		СообщенияXML = ЗаявкиВЕТИС.ЗапросИзмененныхВетеринарноСопроводительныхДокументовXML(
			ПараметрыЗапроса.ХозяйствующийСубъект,
			ПараметрыЗапроса, ПараметрыОбмена);
		
	Иначе
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("СтатусВСД", Перечисления.СтатусыВетеринарныхДокументовВЕТИС.Оформлен);
		ПараметрыОтбора.Вставить("ТипВСД",    Перечисления.ТипыВетеринарныхДокументовВЕТИС.Входящий);
		
		ПараметрыЗапроса = Новый Структура;
		ПараметрыЗапроса.Вставить("ХозяйствующийСубъект",   ХозяйствующийСубъект);
		ПараметрыЗапроса.Вставить("Предприятие",            Предприятие);
		ПараметрыЗапроса.Вставить("ПараметрыОтбора",        ПараметрыОтбора);
		ПараметрыЗапроса.Вставить("КоличествоЭлементов",    КоличествоЭлементов);
		ПараметрыЗапроса.Вставить("Смещение",               0);
		ПараметрыЗапроса.Вставить("ПервыйЗапрос",           Истина);
		ПараметрыЗапроса.Вставить("ПоследнийЗапрос",        Ложь);
		ПараметрыЗапроса.Вставить("СмещениеПервогоЗапроса", 0);
		
		СообщенияXML = ЗаявкиВЕТИС.ЗапросВетеринарноСопроводительныхДокументовXML(
			ХозяйствующийСубъект, ПараметрыЗапроса, ПараметрыОбмена);
		
	КонецЕсли;
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПодготовитьЗапросИзмененныхЗаписейСкладскогоЖурнала(Знач ХозяйствующийСубъект, Предприятие, КоличествоЭлементов, УникальныйИдентификатор) Экспорт
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(ХозяйствующийСубъект, УникальныйИдентификатор);
	
	ПустаяДата = '00010101';
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЕСТЬNULL(СинхронизацияКлассификаторовВЕТИС.ДатаСинхронизации, &ПустаяДата) КАК ДатаСинхронизации,
	|	ЕСТЬNULL(СинхронизацияКлассификаторовВЕТИС.Смещение, 0)                    КАК Смещение
	|ИЗ
	|	РегистрСведений.СинхронизацияКлассификаторовВЕТИС КАК СинхронизацияКлассификаторовВЕТИС
	|ГДЕ
	|	СинхронизацияКлассификаторовВЕТИС.ТипВЕТИС = &ТипВЕТИС
	|	И СинхронизацияКлассификаторовВЕТИС.ХозяйствующийСубъект = &ХозяйствующийСубъект
	|	И СинхронизацияКлассификаторовВЕТИС.Предприятие = &Предприятие
	|");
	
	Запрос.УстановитьПараметр("ТипВЕТИС",             Перечисления.ТипыВЕТИС.ЗаписиСкладскогоЖурнала);
	Запрос.УстановитьПараметр("ХозяйствующийСубъект", ХозяйствующийСубъект);
	Запрос.УстановитьПараметр("Предприятие",          Предприятие);
	Запрос.УстановитьПараметр("ПустаяДата",           ПустаяДата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		НачалоПериода = Выборка.ДатаСинхронизации;
		Смещение      = Выборка.Смещение;
		
		Если ПараметрыОбмена.ИнтервалЗапросаИзмененныхДанных <> 0
			И НачалоПериода + ПараметрыОбмена.ИнтервалЗапросаИзмененныхДанных < ТекущаяДата() Тогда
			КонецПериода = НачалоПериода + ПараметрыОбмена.ИнтервалЗапросаИзмененныхДанных;
		Иначе
			КонецПериода = Неопределено;
		КонецЕсли;
		
	Иначе
		
		НачалоПериода = ПустаяДата;
		Смещение      = 0;
		
		КонецПериода  = Неопределено;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НачалоПериода) Тогда
		
		ПараметрыЗапроса = Новый Структура;
		ПараметрыЗапроса.Вставить("ХозяйствующийСубъект",   ХозяйствующийСубъект);
		ПараметрыЗапроса.Вставить("Предприятие",            Предприятие);
		ПараметрыЗапроса.Вставить("КоличествоЭлементов",    КоличествоЭлементов);
		ПараметрыЗапроса.Вставить("Смещение",               Смещение);
		ПараметрыЗапроса.Вставить("Интервал",               ИнтеграцияВЕТИСКлиентСервер.СтруктураИнтервала(НачалоПериода, КонецПериода));
		ПараметрыЗапроса.Вставить("ПервыйЗапрос",           Истина);
		ПараметрыЗапроса.Вставить("ПоследнийЗапрос",        Ложь);
		ПараметрыЗапроса.Вставить("СмещениеПервогоЗапроса", Смещение);
		
		СообщенияXML = ЗаявкиВЕТИС.ЗапросИзмененныхЗаписейСкладскогоЖурналаXML(
			ПараметрыЗапроса.ХозяйствующийСубъект,
			ПараметрыЗапроса, ПараметрыОбмена);
		
	Иначе
		
		ПараметрыЗапроса = Новый Структура;
		ПараметрыЗапроса.Вставить("ХозяйствующийСубъект",   ХозяйствующийСубъект);
		ПараметрыЗапроса.Вставить("Предприятие",            Предприятие);
		ПараметрыЗапроса.Вставить("КоличествоЭлементов",    КоличествоЭлементов);
		ПараметрыЗапроса.Вставить("Смещение",               0);
		ПараметрыЗапроса.Вставить("ПервыйЗапрос",           Истина);
		ПараметрыЗапроса.Вставить("ПоследнийЗапрос",        Ложь);
		ПараметрыЗапроса.Вставить("СмещениеПервогоЗапроса", Смещение);
		ПараметрыЗапроса.Вставить("Документ",               Неопределено);
		ПараметрыЗапроса.Вставить("Версия",                 0);
		
		СообщенияXML = ЗаявкиВЕТИС.ЗапросЗаписейСкладскогоЖурналаXML(
			ПараметрыЗапроса.ХозяйствующийСубъект,
			ПараметрыЗапроса, ПараметрыОбмена);
		
	КонецЕсли;
	
	ВозвращаемоеЗначение = ИнтеграцияВЕТИС.ПодготовитьКПередачеСОжиданием(СообщенияXML, ПараметрыОбмена, УникальныйИдентификатор);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

