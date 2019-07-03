///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Выполняет асинхронную обработку оповещения о закрытии форм мастера настройки разрешений на
// использование внешних ресурсов при вызове через подключение обработчика ожидания.
// В качестве результата в обработчик передается значение КодВозвратаДиалога.ОК.
//
// Процедура не предназначена для непосредственного вызова.
//
Процедура ЗавершитьНастройкуРазрешенийНаИспользованиеВнешнихРесурсов() Экспорт
	
	НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент.ЗавершитьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовСинхронно(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

// Выполняет асинхронную обработку оповещения о закрытии форм мастера настройки разрешений на
// использование внешних ресурсов при вызове через подключение обработчика ожидания.
// В качестве результата в обработчик передается значение КодВозвратаДиалога.Отмена.
//
// Процедура не предназначена для непосредственного вызова.
//
Процедура ПрерватьНастройкуРазрешенийНаИспользованиеВнешнихРесурсов() Экспорт
	
	НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент.ЗавершитьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовСинхронно(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

#КонецОбласти