#Область РучноеУказаниеТипов

Функция ПолучитьТипыКлассификаторов() Экспорт
	
	Массив = Новый Массив(2);
	Массив[0] = Тип("СправочникСсылка.СтавкиНДСМП");
	Массив[1] = Тип("СправочникСсылка.КассыККММП");
	
	Возврат Массив
	
КонецФункции

Функция ПолучитьТипыГдеСодержатсяКлассификаторы() Экспорт
	
	Массив = Новый Массив(1);
	Массив[0] = Тип("СправочникОбъект.ТоварыМП");
	
	Возврат Массив
	
КонецФункции

#КонецОбласти

#Область НайтиИЗаписатьНовыйИдентификатор

Функция НайтиКлассификаторы(ОбъектXDTOВыгрузки, ОбъектМетаданных) Экспорт
	
	Если ТипЗнч(ОбъектXDTOВыгрузки.Ref) = Тип("СправочникСсылка.КассыККММП") Тогда
		
		Если ОбъектXDTOВыгрузки.Description = "Касса ККМ" Тогда
			СсылкаВБазе = Справочники.КассыККММП.НайтиПоНаименованию(ОбъектXDTOВыгрузки.Description, Истина);
			Если ЗначениеЗаполнено(СсылкаВБазе) Тогда
				СохранитьИдентификаторы(ОбъектXDTOВыгрузки, СсылкаВБазе);
				ЗаменитьСсылкуВОбъектеXDTO(ОбъектXDTOВыгрузки, СсылкаВБазе);
			КонецЕсли;
		Иначе
			СсылкаВБазе = РегистрыСведений.ИдентификаторыСинхронизуемыхОбъектовМП.ПолучитьСсылкуПоУникальномуИдентификаторуНаЦентральномУзле(ОбъектXDTOВыгрузки.Ref.УникальныйИдентификатор());
			Если ЗначениеЗаполнено(СсылкаВБазе) Тогда
				Если СсылкаВБазе.УникальныйИдентификатор() <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
					СохранитьИдентификаторы(ОбъектXDTOВыгрузки, СсылкаВБазе);
					ЗаменитьСсылкуВОбъектеXDTO(ОбъектXDTOВыгрузки, СсылкаВБазе);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектXDTOВыгрузки.Ref) = Тип("СправочникСсылка.СтавкиНДСМП") Тогда
		
		Если ОбъектXDTOВыгрузки.Description = "0%"
			ИЛИ ОбъектXDTOВыгрузки.Description = "10%"
			ИЛИ ОбъектXDTOВыгрузки.Description = "10% / 110%"
			ИЛИ ОбъектXDTOВыгрузки.Description = "18%"
			ИЛИ ОбъектXDTOВыгрузки.Description = "18% / 118%"
			ИЛИ ОбъектXDTOВыгрузки.Description = "20%"
			ИЛИ ОбъектXDTOВыгрузки.Description = "20% / 120%"
			ИЛИ ОбъектXDTOВыгрузки.Description = "Без НДС" Тогда
			
			СсылкаВБазе = Справочники.СтавкиНДСМП.НайтиПоНаименованию(ОбъектXDTOВыгрузки.Description, Истина);
			Если ЗначениеЗаполнено(СсылкаВБазе) Тогда
				СохранитьИдентификаторы(ОбъектXDTOВыгрузки, СсылкаВБазе);
				ЗаменитьСсылкуВОбъектеXDTO(ОбъектXDTOВыгрузки, СсылкаВБазе);
			КонецЕсли;
		Иначе
			СсылкаВБазе = РегистрыСведений.ИдентификаторыСинхронизуемыхОбъектовМП.ПолучитьСсылкуПоУникальномуИдентификаторуНаЦентральномУзле(ОбъектXDTOВыгрузки.Ref.УникальныйИдентификатор());
			Если ЗначениеЗаполнено(СсылкаВБазе) Тогда
				Если СсылкаВБазе.УникальныйИдентификатор() <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
					СохранитьИдентификаторы(ОбъектXDTOВыгрузки, СсылкаВБазе);
					ЗаменитьСсылкуВОбъектеXDTO(ОбъектXDTOВыгрузки, СсылкаВБазе);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

Функция ЗаменитьСсылкуВОбъектеXDTO(ОбъектXDTOВыгрузки, СсылкаВБазе)
	
	ОбъектXDTOВыгрузки.Ref = СсылкаВБазе;
	
КонецФункции

Процедура СохранитьИдентификаторы(ОбъектXDTOВыгрузки, СсылкаВБазе)
	
	Если ПланыОбмена.СинхронизацияМП.ЭтотУзел().Код <> "001" Тогда
		
		СтруктураЗаписи = Новый Структура("ИдентификаторНаЦентральномУзле, ИдентификаторНаКлиентскомУзле, Ссылка", ОбъектXDTOВыгрузки.Ref.УникальныйИдентификатор(), СсылкаВБазе.УникальныйИдентификатор(), СсылкаВБазе );
		РегистрыСведений.ИдентификаторыСинхронизуемыхОбъектовМП.ДобавитьЗапись(СтруктураЗаписи);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПриЗагрузкеПакета

Функция ПоискСсылокНаКлассификаторыВОбъектеXDTOДляСправочникаИлиДокумента(ОбъектXDTOВыгрузки, ОбъектМетаданных, Тип) Экспорт
	
	МассивТиповКлассификаторов = ПолучитьТипыКлассификаторов();
	МассивТиповВКоторыхЕстьКлассификатор = ПолучитьТипыГдеСодержатсяКлассификаторы();
	
	НайденныйТип = МассивТиповВКоторыхЕстьКлассификатор.Найти(Тип);
	
	Если НайденныйТип <> Неопределено Тогда
		
		Если Метаданные.Справочники.Содержит(ОбъектМетаданных) Тогда
			Реквизиты = Метаданные.Справочники[ОбъектМетаданных.Имя].Реквизиты;
			ТабличныеЧасти = Метаданные.Справочники[ОбъектМетаданных.Имя].ТабличныеЧасти;
		Иначе
			Реквизиты = Метаданные.Документы[ОбъектМетаданных.Имя].Реквизиты;
			ТабличныеЧасти = Метаданные.Документы[ОбъектМетаданных.Имя].ТабличныеЧасти;
		КонецЕсли;
		
		Для каждого Реквизит Из Реквизиты Цикл
			
			НайденныйТипОбъекта = МассивТиповКлассификаторов.Найти(ТипЗнч(ОбъектXDTOВыгрузки[Реквизит.Имя]));
			Если НайденныйТипОбъекта <> Неопределено Тогда
				СсылкаНаКлассификатор = ПолучитьСсылкуНаКлассификатор(ОбъектXDTOВыгрузки[Реквизит.Имя].УникальныйИдентификатор());
				Если СсылкаНаКлассификатор <> Неопределено Тогда
					ОбъектXDTOВыгрузки[Реквизит.Имя] = СсылкаНаКлассификатор;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Для каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
			Для каждого Строка Из ОбъектXDTOВыгрузки[ТабличнаяЧасть.Имя] Цикл
				Для каждого Реквизит Из ТабличнаяЧасть.Реквизиты Цикл
					НайденныйТип = МассивТиповКлассификаторов.Найти(ТипЗнч(Строка[Реквизит.Имя]));
					Если НайденныйТип <> Неопределено Тогда
						СсылкаНаКлассификатор = ПолучитьСсылкуНаКлассификатор(Строка[Реквизит.Имя].УникальныйИдентификатор());
						Если СсылкаНаКлассификатор <> Неопределено Тогда
							Строка[Реквизит.Имя] = СсылкаНаКлассификатор;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
	
КонецФункции

Функция ПоискСсылокНаКлассификаторыВОбъектеXDTOДляРегистраСведенийИлиРегистраНакопления(ОбъектXDTOВыгрузки, ОбъектМетаданных, Тип) Экспорт
	
	МассивТиповКлассификаторов = ПолучитьТипыКлассификаторов();
	МассивТиповВКоторыхЕстьКлассификатор = ПолучитьТипыГдеСодержатсяКлассификаторы();
	
	НайденныйТип = МассивТиповВКоторыхЕстьКлассификатор.Найти(Тип);
	
	Если НайденныйТип <> Неопределено Тогда
		
		Если Метаданные.РегистрыСведений.Содержит(ОбъектМетаданных) Тогда
			Измерения = Метаданные.РегистрыСведений[ОбъектМетаданных.Имя].Измерения;
			Ресурсы = Метаданные.РегистрыСведений[ОбъектМетаданных.Имя].Ресурсы;
			Реквизиты = Метаданные.РегистрыСведений[ОбъектМетаданных.Имя].Реквизиты;
		Иначе
			Измерения = Метаданные.РегистрыНакопления[ОбъектМетаданных.Имя].Измерения;
			Ресурсы = Метаданные.РегистрыНакопления[ОбъектМетаданных.Имя].Ресурсы;
			Реквизиты = Метаданные.РегистрыНакопления[ОбъектМетаданных.Имя].Реквизиты;
		КонецЕсли;
		
		Для каждого ЗаписьВыгрузки Из ОбъектXDTOВыгрузки.Record Цикл
			Для каждого Измерение Из Измерения Цикл
				НайденныйТипRecord = МассивТиповКлассификаторов.Найти(ТипЗнч(ЗаписьВыгрузки[Измерение.Имя]));
				Если НайденныйТипRecord <> Неопределено Тогда
					СсылкаНаКлассификатор = ПолучитьСсылкуНаКлассификатор(ЗаписьВыгрузки[Измерение.Имя].УникальныйИдентификатор());
					Если СсылкаНаКлассификатор <> Неопределено Тогда
						ЗаписьВыгрузки[Измерение.Имя] = СсылкаНаКлассификатор;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Для каждого ЗаписьВыгрузки Из ОбъектXDTOВыгрузки.Record Цикл
			Для каждого Ресурс Из Ресурсы Цикл
				НайденныйТипRecord = МассивТиповКлассификаторов.Найти(ТипЗнч(ЗаписьВыгрузки[Ресурс.Имя]));
				Если НайденныйТипRecord <> Неопределено Тогда
					СсылкаНаКлассификатор = ПолучитьСсылкуНаКлассификатор(ЗаписьВыгрузки[Ресурс.Имя].УникальныйИдентификатор());
					Если СсылкаНаКлассификатор <> Неопределено Тогда
						ЗаписьВыгрузки[Ресурс.Имя] = СсылкаНаКлассификатор;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Для каждого ЗаписьВыгрузки Из ОбъектXDTOВыгрузки.Record Цикл
			Для каждого Реквизит Из Реквизиты Цикл
				НайденныйТипRecord = МассивТиповКлассификаторов.Найти(ТипЗнч(ЗаписьВыгрузки[Реквизит.Имя]));
				Если НайденныйТипRecord <> Неопределено Тогда
					СсылкаНаКлассификатор = ПолучитьСсылкуНаКлассификатор(ЗаписьВыгрузки[Реквизит.Имя].УникальныйИдентификатор());
					Если СсылкаНаКлассификатор <> Неопределено Тогда
						ЗаписьВыгрузки[Реквизит.Имя] = СсылкаНаКлассификатор;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Для каждого FilterItemВыгрузки Из ОбъектXDTOВыгрузки.Filter.FilterItem Цикл
			НайденныйТипFilterItem = МассивТиповКлассификаторов.Найти(ТипЗнч(FilterItemВыгрузки.Value));
			Если НайденныйТипFilterItem <> Неопределено Тогда
				СсылкаНаКлассификатор = ПолучитьСсылкуНаКлассификатор(FilterItemВыгрузки.Value.УникальныйИдентификатор());
				Если СсылкаНаКлассификатор <> Неопределено Тогда
					FilterItemВыгрузки.Value = СсылкаНаКлассификатор;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецФункции

Функция ПоискСсылокНаКлассификаторыВОбъектеXDTOДляКонстанты(ОбъектXDTOВыгрузки, ОбъектМетаданных, Тип) Экспорт
	
	МассивТиповКлассификаторов = ПолучитьТипыКлассификаторов();
	МассивТиповВКоторыхЕстьКлассификатор = ПолучитьТипыГдеСодержатсяКлассификаторы();
	
	НайденныйТип = МассивТиповВКоторыхЕстьКлассификатор.Найти(Тип);
	
	Если НайденныйТип <> Неопределено Тогда
		
		НайденныйТипОбъекта = МассивТиповКлассификаторов.Найти(ТипЗнч(ОбъектXDTOВыгрузки.Value));
		Если НайденныйТипОбъекта <> Неопределено Тогда
			СсылкаНаКлассификатор = ПолучитьСсылкуНаКлассификатор(ОбъектXDTOВыгрузки.Value.УникальныйИдентификатор());
			Если СсылкаНаКлассификатор <> Неопределено Тогда
				ОбъектXDTOВыгрузки.Value = СсылкаНаКлассификатор;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли
	
КонецФункции

Функция ПоискСсылокНаКлассификаторыВОбъектеXDTOПриУдалении(ОбъектXDTOВыгрузки, ОбъектМетаданных, Тип) Экспорт
	
	Если ОбъектXDTOВыгрузки.Ref.ПолучитьОбъект() = Неопределено Тогда
		СсылкаНаКлассификатор = ПолучитьСсылкуНаКлассификатор(ОбъектXDTOВыгрузки.Ref.УникальныйИдентификатор());
		Если СсылкаНаКлассификатор <> Неопределено Тогда
			ОбъектXDTOВыгрузки = СсылкаНаКлассификатор;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСсылкуНаКлассификатор(УникальныйИдентификаторНаЦентральномУзле)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИдентификаторыСинхронизуемыхОбъектовМП.Ссылка КАК Ссылка
	|ИЗ
	|	РегистрСведений.ИдентификаторыСинхронизуемыхОбъектовМП КАК ИдентификаторыСинхронизуемыхОбъектовМП
	|ГДЕ
	|	ИдентификаторыСинхронизуемыхОбъектовМП.ИдентификаторНаЦентральномУзле = &ИдентификаторНаЦентральномУзле";
	
	Запрос.УстановитьПараметр("ИдентификаторНаЦентральномУзле", УникальныйИдентификаторНаЦентральномУзле);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Ссылка = ВыборкаДетальныеЗаписи.Ссылка;
		Возврат Ссылка
	КонецЦикла;
	
	Возврат Неопределено
	
КонецФункции

#КонецОбласти

#Область ПриВыгрузкеПакета

Функция НачатьПоискКлассификаторов(ЗаписьXML, ТекОбъектОбмена, СтруктураПредопределенныхДанных) Экспорт
	
	ЗавершитьВыгрузкуОбъекта = ЗаменаИдентификатораУКлассификатора(ЗаписьXML, ТекОбъектОбмена, СтруктураПредопределенныхДанных);
	Если ЗавершитьВыгрузкуОбъекта Тогда
		Возврат Истина;
	КонецЕсли;
	ЗавершитьВыгрузкуОбъекта = ЗаменаИдентификатораВОбъектеСодержащемКлассификатор(ЗаписьXML, ТекОбъектОбмена, СтруктураПредопределенныхДанных);
	Если ЗавершитьВыгрузкуОбъекта Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь
	
КонецФункции

Функция ЗаменаИдентификатораУКлассификатора(ЗаписьXML, ТекОбъектОбмена, СтруктураПредопределенныхДанных)
	
	Результат = Ложь;
	
	МассивКлассификаторов = ПолучитьТипыКлассификаторов();
	
	Если ТипЗнч(ТекОбъектОбмена) = Тип("УдалениеОбъекта") ИЛИ Метаданные.Справочники.Содержит(Метаданные.НайтиПоТипу(ТипЗнч(ТекОбъектОбмена))) Тогда
		
		Тип = МассивКлассификаторов.Найти(ТипЗнч(ТекОбъектОбмена.Ссылка));
		
		Если Тип <> Неопределено ИЛИ ТипЗнч(ТекОбъектОбмена) = Тип("УдалениеОбъекта") Тогда
			
			ИдентификаторНаКлиентскомУзле = ТекОбъектОбмена.Ссылка.УникальныйИдентификатор();
			
			ИдентификаторНаЦентральномУзле = ЗапросКРегиструСКлассификаторами(ИдентификаторНаКлиентскомУзле);
			Если ИдентификаторНаЦентральномУзле <> Неопределено Тогда
				МассивИдентификаторов = Новый Массив();
				МассивИдентификаторов.Добавить(ИдентификаторНаКлиентскомУзле);
				СереализацияОбъектаСИзменениемИдентификаторовУКлассификаторов(ТекОбъектОбмена, ЗаписьXML, МассивИдентификаторов);
				Результат = Истина
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат
	
КонецФункции

Функция ЗаменаИдентификатораВОбъектеСодержащемКлассификатор(ЗаписьXML, ТекОбъектОбмена, СтруктураПредопределенныхДанных)
	
	Результат = Ложь;
	
	МассивТиповКлассификаторов = ПолучитьТипыКлассификаторов();
	МассивТиповВКоторыхЕстьКлассификатор = ПолучитьТипыГдеСодержатсяКлассификаторы();
	
	Тип = МассивТиповВКоторыхЕстьКлассификатор.Найти(ТипЗнч(ТекОбъектОбмена));
	
	Если Тип <> Неопределено Тогда
		
		Результат = Истина;
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(ТекОбъектОбмена));
		
		СериализацияПредопределенныхДанных(ОбъектМетаданных, ЗаписьXML, СтруктураПредопределенныхДанных);
		
		Если Метаданные.Справочники.Содержит(ОбъектМетаданных) Тогда
			
			Реквизиты = Метаданные.Справочники[ОбъектМетаданных.Имя].Реквизиты;
			ТабличныеЧасти = Метаданные.Справочники[ОбъектМетаданных.Имя].ТабличныеЧасти;
			МассивИдентификаторов = ПоискКлассификаторовВСправочникеИлиДокументе(ТекОбъектОбмена, Реквизиты, ТабличныеЧасти, МассивТиповВКоторыхЕстьКлассификатор, МассивТиповКлассификаторов);
			СереализацияОбъектаСИзменениемИдентификаторовУКлассификаторов(ТекОбъектОбмена, ЗаписьXML, МассивИдентификаторов);
			
		ИначеЕсли Метаданные.Документы.Содержит(ОбъектМетаданных) Тогда
			
			Реквизиты = Метаданные.Документы[ОбъектМетаданных.Имя].Реквизиты;
			ТабличныеЧасти = Метаданные.Документы[ОбъектМетаданных.Имя].ТабличныеЧасти;
			МассивИдентификаторов = ПоискКлассификаторовВСправочникеИлиДокументе(ТекОбъектОбмена, Реквизиты, ТабличныеЧасти, МассивТиповВКоторыхЕстьКлассификатор, МассивТиповКлассификаторов);
			СереализацияОбъектаСИзменениемИдентификаторовУКлассификаторов(ТекОбъектОбмена, ЗаписьXML, МассивИдентификаторов);
			
		ИначеЕсли Метаданные.РегистрыСведений.Содержит(ОбъектМетаданных) Тогда
			
			Измерения = Метаданные.РегистрыСведений[ОбъектМетаданных.Имя].Измерения;
			Ресурсы = Метаданные.РегистрыСведений[ОбъектМетаданных.Имя].Ресурсы;
			Реквизиты = Метаданные.РегистрыСведений[ОбъектМетаданных.Имя].Реквизиты;
			МассивИдентификаторов = ПоискКлассификаторовВРегистреСведенийИлиРегистреНакопления(Измерения, Ресурсы, Реквизиты, ТекОбъектОбмена, МассивТиповВКоторыхЕстьКлассификатор, МассивТиповКлассификаторов);
			СереализацияОбъектаСИзменениемИдентификаторовУКлассификаторов(ТекОбъектОбмена, ЗаписьXML, МассивИдентификаторов);
			
		ИначеЕсли Метаданные.РегистрыНакопления.Содержит(ОбъектМетаданных) Тогда
			
			Измерения = Метаданные.РегистрыНакопления[ОбъектМетаданных.Имя].Измерения;
			Ресурсы = Метаданные.РегистрыНакопления[ОбъектМетаданных.Имя].Ресурсы;
			Реквизиты = Метаданные.РегистрыНакопления[ОбъектМетаданных.Имя].Реквизиты;
			МассивИдентификаторов = ПоискКлассификаторовВРегистреСведенийИлиРегистреНакопления(Измерения, Ресурсы, Реквизиты, ТекОбъектОбмена, МассивТиповВКоторыхЕстьКлассификатор, МассивТиповКлассификаторов);
			СереализацияОбъектаСИзменениемИдентификаторовУКлассификаторов(ТекОбъектОбмена, ЗаписьXML, МассивИдентификаторов);
			
		ИначеЕсли Метаданные.Константы.Содержит(ОбъектМетаданных) Тогда
			
			МассивИдентификаторов = ПоискКлассификатораВКонстанте(ТекОбъектОбмена, МассивТиповКлассификаторов);
			СереализацияОбъектаСИзменениемИдентификаторовУКлассификаторов(ТекОбъектОбмена, ЗаписьXML, МассивИдентификаторов);
			
		КонецЕсли;
		
		
	КонецЕсли;
	
	Возврат Результат
	
КонецФункции

Функция ПоискКлассификаторовВСправочникеИлиДокументе(ТекОбъектОбмена, Реквизиты, ТабличныеЧасти, МассивТиповВКоторыхЕстьКлассификатор, МассивТиповКлассификаторов)
	
	МассивИдентификаторов = Новый Массив;
	
	Для каждого Реквизит Из Реквизиты Цикл
		НайденныйТип = МассивТиповКлассификаторов.Найти(ТипЗнч(ТекОбъектОбмена[Реквизит.Имя]));
		Если НайденныйТип <> Неопределено Тогда
			МассивИдентификаторов.Добавить(ТекОбъектОбмена[Реквизит.Имя].УникальныйИдентификатор());
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
		Для каждого Строка Из ТекОбъектОбмена[ТабличнаяЧасть.Имя] Цикл
			Для каждого Реквизит Из ТабличнаяЧасть.Реквизиты Цикл
				НайденныйТип = МассивТиповКлассификаторов.Найти(ТипЗнч(Строка[Реквизит.Имя]));
				Если НайденныйТип <> Неопределено Тогда
					МассивИдентификаторов.Добавить(ТекОбъектОбмена[Реквизит.Имя].УникальныйИдентификатор());
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Возврат МассивИдентификаторов
	
КонецФункции

Функция ПоискКлассификаторовВРегистреСведенийИлиРегистреНакопления(Измерения, Ресурсы, Реквизиты, ТекОбъектОбмена, МассивТиповВКоторыхЕстьКлассификатор, МассивТиповКлассификаторов)
	
	МассивИдентификаторов = Новый Массив;
	ТаблицаЗначений = ТекОбъектОбмена.Выгрузить();
	
	Для каждого Измерение Из Измерения Цикл
		Колонка = ТаблицаЗначений.ВыгрузитьКолонку(Измерение.Имя);
		Если Колонка.Количество() > 0 Тогда
			НайденныйТип = МассивТиповКлассификаторов.Найти(ТипЗнч(Колонка[0]));
			Если НайденныйТип <> Неопределено Тогда
				МассивИдентификаторов.Добавить(ТаблицаЗначений[0][Измерение.Имя].УникальныйИдентификатор());
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого Ресурс Из Ресурсы Цикл
		Колонка = ТаблицаЗначений.ВыгрузитьКолонку(Ресурс.Имя);
		Если Колонка.Количество() > 0 Тогда
			НайденныйТип = МассивТиповКлассификаторов.Найти(ТипЗнч(Колонка[0]));
			Если НайденныйТип <> Неопределено Тогда
				МассивИдентификаторов.Добавить(ТаблицаЗначений[0][Ресурс.Имя].УникальныйИдентификатор());
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого Реквизит Из Реквизиты Цикл
		Колонка = ТаблицаЗначений.ВыгрузитьКолонку(Реквизит.Имя);
		Если Колонка.Количество() > 0 Тогда
			НайденныйТип = МассивТиповКлассификаторов.Найти(ТипЗнч(Колонка[0]));
			Если НайденныйТип <> Неопределено Тогда
				МассивИдентификаторов.Добавить(ТаблицаЗначений[0][Реквизит.Имя].УникальныйИдентификатор());
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивИдентификаторов
	
КонецФункции

Функция ПоискКлассификатораВКонстанте(ТекОбъектОбмена, МассивТиповКлассификаторов)
	
	МассивИдентификаторов = Новый Массив;
	НайденныйТип = МассивТиповКлассификаторов.Найти(ТипЗнч( ТекОбъектОбмена.Значение));
	Если НайденныйТип <> Неопределено Тогда
		МассивИдентификаторов.Добавить(ТекОбъектОбмена.Значение.УникальныйИдентификатор());
	КонецЕсли;
	
	Возврат МассивИдентификаторов
	
КонецФункции

Функция СереализацияОбъектаСИзменениемИдентификаторовУКлассификаторов(ТекОбъектОбмена, ЗаписьXML, МассивИдентификаторов)
	
	ЗаписьКлассификатораXML = Новый ЗаписьXML();
	ЗаписьКлассификатораXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьКлассификатораXML, ТекОбъектОбмена, НазначениеТипаXML.Явное);
	СформированнаяСтрока = ЗаписьКлассификатораXML.Закрыть();
	
	Для каждого ИдентификаторНаКлиентскомУзле Из МассивИдентификаторов Цикл
		ИдентификаторНаЦентральномУзле = ЗапросКРегиструСКлассификаторами(ИдентификаторНаКлиентскомУзле);
		Если ИдентификаторНаЦентральномУзле <> Неопределено И ИдентификаторНаКлиентскомУзле <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
			СформированнаяСтрока = СтрЗаменить(СформированнаяСтрока, Строка(ИдентификаторНаКлиентскомУзле), Строка(ИдентификаторНаЦентральномУзле));
		КонецЕсли;
	КонецЦикла;
	
	СтрокаXML = "";
	СтрокаXML = Символы.ПС + СформированнаяСтрока;
	
	//СтрокаXML = "";
	//Для Индекс = 1 По СтрЧислоСтрок(СформированнаяСтрока) Цикл
	//	Если Лев(СокрЛП(СтрПолучитьСтроку(СформированнаяСтрока, Индекс)), 1) = "<" Тогда
	//		СтрокаXML = СтрокаXML + Символы.ПС + Символы.Таб + Символы.Таб + СтрПолучитьСтроку(СформированнаяСтрока, Индекс);
	//	Иначе
	//		СтрокаXML = СтрокаXML + Символы.ПС + СтрПолучитьСтроку(СформированнаяСтрока, Индекс);
	//	КонецЕсли;
	//КонецЦикла;
	
	//ЗаписьXML.ЗаписатьБезОбработки(СтрокаXML);
	ЗаписьXML.ЗаписатьБезОбработки(СтрокаXML);

КонецФункции

Функция СериализацияПредопределенныхДанных(ОбъектМетаданных, ЗаписьXML, СтруктураПредопределенныхДанных)
	
	Если Метаданные.Справочники.Содержит(ОбъектМетаданных) ИЛИ Метаданные.Документы.Содержит(ОбъектМетаданных) Тогда
		Если СтруктураПредопределенныхДанных.МассивПредопределенныхРеквизитовВТЧ.Количество() > 0 ИЛИ СтруктураПредопределенныхДанных.СтруктураПредопределенныхРеквизитов.Количество() > 0 Тогда
			ЗаписьXML.ЗаписатьНачалоЭлемента("PredefinedData");
			СериализаторXDTO.ЗаписатьXML(ЗаписьXML, СтруктураПредопределенныхДанных, НазначениеТипаXML.Явное);
			ЗаписьXML.ЗаписатьКонецЭлемента();
		КонецЕсли;
	Иначе
		Если СтруктураПредопределенныхДанных.Количество() > 0 Тогда
			ЗаписьXML.ЗаписатьНачалоЭлемента("PredefinedData");
			СериализаторXDTO.ЗаписатьXML(ЗаписьXML, СтруктураПредопределенныхДанных, НазначениеТипаXML.Явное);
			ЗаписьXML.ЗаписатьКонецЭлемента();
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Функция ЗапросКРегиструСКлассификаторами(ИдентификаторНаКлиентскомУзле)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИдентификаторыСинхронизуемыхОбъектовМП.ИдентификаторНаЦентральномУзле КАК ИдентификаторНаЦентральномУзле
	|ИЗ
	|	РегистрСведений.ИдентификаторыСинхронизуемыхОбъектовМП КАК ИдентификаторыСинхронизуемыхОбъектовМП
	|ГДЕ
	|	ИдентификаторыСинхронизуемыхОбъектовМП.ИдентификаторНаКлиентскомУзле = &ИдентификаторНаКлиентскомУзле";
	
	Запрос.УстановитьПараметр("ИдентификаторНаКлиентскомУзле", ИдентификаторНаКлиентскомУзле);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ИдентификаторНаЦентральномУзле = ВыборкаДетальныеЗаписи.ИдентификаторНаЦентральномУзле;
		Возврат ИдентификаторНаЦентральномУзле;
	КонецЦикла;
	
	Возврат Неопределено
	
КонецФункции

#КонецОбласти