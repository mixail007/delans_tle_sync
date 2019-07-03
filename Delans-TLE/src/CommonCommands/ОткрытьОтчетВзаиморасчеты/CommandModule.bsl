&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СтруктураОтбора = Новый Структура("Контрагент", ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура("КлючВарианта, КлючНазначенияИспользования, Отбор, СформироватьПриОткрытии, ВидимостьКомандВариантовОтчетов", 
		"ВедомостьКраткоКонтекст",
		"ВедомостьКраткоКонтекстПоКонтрагенту",
		СтруктураОтбора, 
		Истина, 
		Ложь);
	
	ОткрытьФорму("Отчет.Взаиморасчеты.Форма",
		ПараметрыФормы,
		,
		"Контрагент=" + ПараметрКоманды,
		ПараметрыВыполненияКоманды.Окно
	);
	
КонецПроцедуры
