///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыСервер.УстановкаПараметровСеанса(ИменаПараметровСеанса);
	// Конец СтандартныеПодсистемы
	
	// ТехнологияСервиса
	ТехнологияСервиса.ВыполнитьДействияПриУстановкеПараметровСеанса(ИменаПараметровСеанса);
	// Конец ТехнологияСервиса
	
	// EFSOL
	ПараметрыСеанса.EfsolИДАккаунта = "";
	ПараметрыСеанса.EfsolИДПользователя = "";
	ПараметрыСеанса.EfsolТокен = "";
	ПараметрыСеанса.EfsolФИОПользователя = "";
	ПараметрыСеанса.EfsolЛогин					= "";
	ПараметрыСеанса.EfsolПароль					= "";
	ПараметрыСеанса.EfsolEmailПользователя = "";
	ПараметрыСеанса.EfsolPhoneNumberПользователя = "";
	
	НастройкиПодключения = ХранилищеСистемныхНастроек.Загрузить("EfsolНастройкиПодключения", "НастройкиПодключения");
	Если НастройкиПодключения <> Неопределено И ТипЗнч(НастройкиПодключения) = Тип("Структура") Тогда
		Если НастройкиПодключения.Свойство("EfsolТокен") Тогда
			ПараметрыСеанса.EfsolТокен = НастройкиПодключения.EfsolТокен;
		КонецЕсли;
		Если НастройкиПодключения.Свойство("EfsolЛогин") Тогда
			ПараметрыСеанса.EfsolЛогин = НастройкиПодключения.EfsolЛогин;
		КонецЕсли;
	КонецЕсли; 
	//ЭР Несторук С.И. 21.05.2019 10:54:51 {
	Если НЕ ОбщегоНазначения.РазделениеВключено() ИЛИ НЕ ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных()
		Тогда
		АпиКлючКартЯндекса = "apikey=e2b034f7-f42a-47dd-b007-e84288d87bff&";
	Иначе
		АпиКлючКартЯндекса = Константы.ES_APIКлючYandexКарт.Получить();
		Если НЕ ПустаяСтрока(АпиКлючКартЯндекса) Тогда
			АпиКлючКартЯндекса = "apikey="+СокрЛП(АпиКлючКартЯндекса) + "&";
		Иначе
			АпиКлючКартЯндекса = "apikey=e2b034f7-f42a-47dd-b007-e84288d87bff&";
		КонецЕсли;
	КонецЕсли;
	ПараметрыСеанса.ES_APIКлючЯндекса = АпиКлючКартЯндекса;
	//}ЭР Несторук С.И.
	// EFSOL

КонецПроцедуры

#КонецОбласти

#КонецЕсли