
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВызватьИсключение НСтр("ru='Обработка не предназначена для непосредственного использования.'");
		
КонецПроцедуры

#КонецОбласти