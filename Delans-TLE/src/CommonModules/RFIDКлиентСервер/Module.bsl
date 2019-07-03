
#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьФлагиРаботыСМеткой(ОбрабатываемаяСтрока, GTIN, ТекущаяМетка, НастройкиИспользованияСерий, ЭтоМаркировкаПерсонифицированнымиКиЗ) Экспорт
	Если ОбрабатываемаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущаяМетка <> Неопределено Тогда
		
		ОбрабатываемаяСтрока.RFIDEPC = ТекущаяМетка.EPC;
		
	КонецЕсли;
	
	ОбрабатываемаяСтрока.ЗаполненRFIDTID = ЗначениеЗаполнено(ОбрабатываемаяСтрока.RFIDTID);
	
	Если ЗначениеЗаполнено(GTIN)
		И Не ЭтоМаркировкаПерсонифицированнымиКиЗ Тогда
		
		ОбрабатываемаяСтрока.EPCGTIN = GTIN;
		
		Если ОбрабатываемаяСтрока.ЗаполненRFIDTID Тогда
			
			РезультатРасчетаНомера = МенеджерОборудованияКлиентСервер.ПолучитьСерийныйНомерПоTID(ОбрабатываемаяСтрока.RFIDTID, ОбрабатываемаяСтрока.RFIDEPC);	
			
			Если РезультатРасчетаНомера.Результат Тогда
				ОбрабатываемаяСтрока.НомерГИСМ = Формат(РезультатРасчетаНомера.СерийныйНомер, "ЧГ=0");
			Иначе
				ОбрабатываемаяСтрока.НомерГИСМ = "";
				
				ТекстСообщения = НСтр("ru = 'При маркировке непесонифицированными КиЗ номер серии должен быть сгенирирован по TID RFID-метки. При генерации произошла ошибка: %ТекстОшибки%. Обратитесь к администратору.'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТекстОшибки%", РезультатРасчетаНомера.ОписаниеОшибки); 
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
		КонецЕсли;
		
		ДанныеEPC = МенеджерОборудованияКлиентСервер.СформироватьДанныеSGTIN96(ОбрабатываемаяСтрока.EPCGTIN, ОбрабатываемаяСтрока.НомерГИСМ);
		
		Если Не МенеджерОборудованияКлиентСервер.ПустойEPC(ДанныеEPC)
			Или Не МенеджерОборудованияКлиентСервер.ПустойEPC(ОбрабатываемаяСтрока.RFIDEPC) Тогда
			ОбрабатываемаяСтрока.НужноЗаписатьМетку = ДанныеEPC <> ОбрабатываемаяСтрока.RFIDEPC;
		Иначе
			ОбрабатываемаяСтрока.НужноЗаписатьМетку = Ложь;
		КонецЕсли;
	Иначе
		ОбрабатываемаяСтрока.НужноЗаписатьМетку = Ложь;
	КонецЕсли;
	
	
	Если Не ОбрабатываемаяСтрока.ЗаполненRFIDTID Тогда
		ОбрабатываемаяСтрока.СтатусРаботыRFID = 0;
	ИначеЕсли ОбрабатываемаяСтрока.НужноЗаписатьМетку Тогда
		ОбрабатываемаяСтрока.СтатусРаботыRFID = 1;
	Иначе
		ОбрабатываемаяСтрока.СтатусРаботыRFID = 2;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти
