///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет дополнительные действия перед формированием печатной формы.
// 
// Параметры:
//  ПечатаемыеОбъекты    - Массив - ссылки на объекты, для которых выполняется команда печати;
//  СтандартнаяОбработка - Булево - признак необходимости проверки проведенности печатаемых документов,
//                                  если установить в Ложь, то проверка выполняться не будет.
Процедура ПередВыполнениемКомандыПечатиВнешнейПечатнойФормы(ПечатаемыеОбъекты, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь; // УНФ
	
КонецПроцедуры

#КонецОбласти