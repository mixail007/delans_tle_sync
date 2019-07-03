// Определяет включение режима отладки обмена со штрих-м
//
// Возвращаемое значение:
//  Булево - Истина, если включен режим отладки
//
Функция РежимОтладкиОбменаШтрихМ() Экспорт
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		ПараметрЗапускаПриложения = ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить("ПараметрЗапуска");
	#Иначе
		ПараметрЗапускаПриложения = ПараметрЗапуска;
	#КонецЕсли
	
	Возврат УправлениеНебольшойФирмойУправлениеДоступомПовтИсп.ЭтоПолноправныйПользователь()
		И СтрНайти(ПараметрЗапускаПриложения, "РежимОтладкиОбменаШтрихМ") > 0;
	
КонецФункции
