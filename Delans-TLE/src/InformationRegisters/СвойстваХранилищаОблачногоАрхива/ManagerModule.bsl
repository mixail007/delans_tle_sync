///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список доступных значений для поля "Свойство".
//
// Возвращаемое значение:
//   Массив - список доступных значений.
//
Функция ПолучитьЗначенияДопустимыхСвойств() Экспорт

	Результат = Новый Массив;

	Результат.Добавить("Аккаунт активирован"); // activated
	Результат.Добавить("Логин Агента копирования"); // acronisLogin
	Результат.Добавить("Пароль Агента копирования"); // acronisPassword
	Результат.Добавить("Количество купленных агентов копирования"); // countAgents
	Результат.Добавить("Объем байт, куплено"); // total
	Результат.Добавить("Объем байт, занято"); // occupied
	Результат.Добавить("Объем байт, доступно"); // Рассчитывается как "куплено" - "занято".
	Результат.Добавить("Время обновления статистики"); // Нельзя вызывать метод updateAccountStats чаще, чем 1 раз в 30 секунд.

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли