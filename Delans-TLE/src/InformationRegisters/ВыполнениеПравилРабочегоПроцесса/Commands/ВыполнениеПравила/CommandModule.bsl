
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Правило",			ПараметрКоманды);
	ПараметрыФормы.Вставить("ТолькоПросмотр",	Истина);
	
	ОткрытьФорму("РегистрСведений.ВыполнениеПравилРабочегоПроцесса.Форма.ВыполнениеПравила",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка
	);
	
КонецПроцедуры
