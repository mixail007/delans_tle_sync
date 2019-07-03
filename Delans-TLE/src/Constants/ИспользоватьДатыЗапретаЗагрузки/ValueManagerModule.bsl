///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем НастройкаВключена; // Флажок изменения значения константы с Ложь на Истина.
                         // Используется в обработчике события ПриЗаписи.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаВключена = Значение И НЕ Константы.ИспользоватьДатыЗапретаЗагрузки.Получить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	// В режиме ОбменДанными.Загрузка необходимо обновлять УИД в константе ВерсияДатЗапретаИзменения,
	// который позволять сеансам определить, что нужно обновить кэш дат запрета изменения в памяти.
	Если Не ДополнительныеСвойства.Свойство("ПропуститьОбновлениеВерсииДатЗапретаИзменения") Тогда
		ДатыЗапретаИзмененияСлужебный.ОбновитьВерсиюДатЗапретаИзменения();
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НастройкаВключена Тогда
		СвойстваРазделов = ДатыЗапретаИзмененияСлужебный.СвойстваРазделов();
		Если Не СвойстваРазделов.ДатыЗапретаЗагрузкиВнедрены Тогда
			ВызватьИсключение ДатыЗапретаИзмененияСлужебный.ТекстОшибкиДатыЗапретаЗагрузкиНеВнедрены();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли