
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Если ПараметрыВыполненияКоманды.Источник=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыВыполненияКоманды.Источник)=Тип("УправляемаяФорма") И ПараметрыВыполненияКоманды.Источник.Модифицированность Тогда
		ПараметрыВыполненияКоманды.Источник.Записать();
	КонецЕсли; 
	
	Если ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаЭлемента" Тогда
		НоменклатураВДокументахКлиент.ПодготовитьРеквизитыСтрокиПоЭлементу(ПараметрыВыполненияКоманды, "СчетНаОплату");
	Иначе
		НоменклатураВДокументахКлиент.ПодготовитьРеквизитыСтрокСписка(ПараметрыВыполненияКоманды, "СчетНаОплату");
	КонецЕсли;
	
КонецПроцедуры
