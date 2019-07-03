
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипСобытия", ПредопределенноеЗначение("Перечисление.ТипыСобытий.ЭлектронноеПисьмо"));
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "ЭлектронныеПисьма");
	
	ОткрытьФорму("Документ.Событие.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка
	);
	
КонецПроцедуры
