
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если РольДоступна("ES_Логист") Тогда
		
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("КассаНаложенныхПлатежей"));
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ДопКассаНП"));
		
	КонецЕсли;
	
КонецПроцедуры
