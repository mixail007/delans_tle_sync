////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с номенклатурой".
// ОбщийМодуль.РаботаСНоменклатуройСлужебныйВызовСервера.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область РаботаСКатегориями

// Получение пути к категории.
//
// Параметры:
//  Идентификатор			 - Строка - идентификатор категории.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьКатегорииНаПутиКЭлементуВФоне(Идентификатор, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = '1С:Номенклатура. Получение списка категорий от выбранной до корневой.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.ПолучитьКатегорииНаПутиКЭлементу";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, Идентификатор, ПараметрыВыполнения);
	
КонецФункции

// Получение пути к категории с корневыми.
//
// Параметры:
//  Идентификатор			 - Строка - идентификатор категории.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьКатегорииНаПутиКЭлементуСКорневымиКатегориямиВФоне(Идентификатор, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = '1С:Номенклатура. Получение списка категорий от выбранной до корневой.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.ПолучитьКатегорииНаПутиКЭлементуСКорневымиКатегориями";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, Идентификатор, ПараметрыВыполнения);
	
КонецФункции

// Поиск категории по строке.
//
// Параметры:
//  ТекстПоиска			     - Строка - строка поиска.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция НайтиКатегорииПоСтрокеПоискаВФоне(ТекстПоиска, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = '1С:Номенклатура. Поиск категорий.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.НайтиКатегорииПоСтрокеПоиска";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ТекстПоиска, ПараметрыВыполнения);
	
КонецФункции

// Получение корневых категорий.
//
// Параметры:
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьКорневыеКатегорииВФоне(УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Получение списка категорий.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.ПолучитьКорневыеКатегории";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, Неопределено, ПараметрыВыполнения);
	
КонецФункции

// Получение дочерних категорий.
//
// Параметры:
//  Идентификатор			 - Строка - идентификатор категории.
//  НаборПолей	             - Число - код набора полей: 1 - минимальный, 2 - стандартный, 3 - максимальный.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьДочерниеКатегорииВФоне(Идентификатор, НаборПолей, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Получение списка категорий.'");
	
	Если НаборПолей = 1 Тогда 
		ИмяПроцедуры = "РаботаСНоменклатурой.ПолучитьПредставлениеДочернихКатегорий";
	ИначеЕсли НаборПолей = 2 Тогда 
		ИмяПроцедуры = "РаботаСНоменклатурой.ПолучитьКраткоеОписаниеДочернихКатегорий";
	Иначе
		ИмяПроцедуры = "РаботаСНоменклатурой.ПолучитьПолноеОписаниеДочернихКатегорий";
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, Идентификатор, ПараметрыВыполнения);
	
КонецФункции

// Получение данных по категории.
//
// Параметры:
//  Идентификатор			 - Строка - идентификатор категории.
//  НаборПолей	             - Число - код набора полей: 1 - минимальный, 2 - стандартный, 3 - максимальный.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьКатегориюПоИдентификаторуВФоне(Идентификатор, НаборПолей, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Получение списка категорий.'");
	
	Если НаборПолей = 1 Тогда 
		ИмяПроцедуры = "РаботаСНоменклатурой.ПолучитьПредставлениеКатегорииПоИдентификатору";
	ИначеЕсли НаборПолей = 2 Тогда 
		ИмяПроцедуры = "РаботаСНоменклатурой.ПолучитьОписаниеКатегорииПоИдентификатору";
	Иначе
		ИмяПроцедуры = "РаботаСНоменклатурой.ПолучитьПолноеОписаниеКатегорииПоИдентификатору";
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, Идентификатор, ПараметрыВыполнения);
	
КонецФункции

// Получение данных по категории с дополнительными реквизитами и характеристиками.
//
// Параметры:
//  ИдентификаторыКатегорий	 - Массив (Строка) - идентификаторы категорий.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьДанныеКатегорийСервиса(ИдентификаторыКатегорий, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Получение данных по категориям.'");
	
	ИмяПроцедуры = "РаботаСНоменклатурой.ПолучитьДанныеКатегорийСервиса";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ИдентификаторыКатегорий, ПараметрыВыполнения);
	
КонецФункции

// Получение списка дополнительных реквизитов категории.
//
// Параметры:
//  Идентификатор			 - Строка - идентификатор категории.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьДополнительныеРеквизитыКатегорийВФоне(Идентификатор, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Получение дополнительных реквизитов категории.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.ПолучитьДополнительныеРеквизитыКатегорий";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, Идентификатор, ПараметрыВыполнения);
	
КонецФункции

// Получение списка значений дополнительных реквизитов категории.
//
// Параметры:
//  ПараметрыПоиска			 - Структура - идентификатор категории.
//  Ключи:
//    * ИдентификаторДополнительногоРеквизита - Строка - идентификатор реквизита.
//    * ИдентификаторКатегории - Строка - идентификатор категории.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьЗначенияДополнительногоРеквизитаКатегорииВФоне(ПараметрыПоиска, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Получение списка значений дополнительных реквизитов категории.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.ПолучитьЗначенияДополнительногоРеквизитаКатегории";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПоиска, ПараметрыВыполнения);
	
КонецФункции

// Получение фильтров категории.
//
// Параметры:
//  Идентификатор			 - Строка - идентификатор категории.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьФильтрыКатегорииВФоне(Идентификатор, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Получение фильтров категории.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.ПолучитьФильтрыКатегории";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, Идентификатор, ПараметрыВыполнения);
	
КонецФункции

// Получение списка производителей категории.
//
// Параметры:
//  Идентификатор			 - Строка - идентификатор категории.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьПроизводителейКатегорииВФоне(Идентификатор, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Получение списка производителей категории.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.ПолучитьПроизводителейКатегории";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, Идентификатор, ПараметрыВыполнения);
	
КонецФункции

// Формирование представления категории.
//
// Параметры:
//  Идентификатор			 - Строка - идентификатор категории.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция СформироватьПредставлениеКарточкиКатегорииВФоне(Идентификатор, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Формирование представления категории.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.СформироватьПредставлениеКарточкиКатегории";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, Идентификатор, ПараметрыВыполнения);
	
КонецФункции

// Загрузка категорий.
//
// Параметры:
//  КатегорииКЗагрузке	     - Массив (Строка) - массив строк идентификаторов категорий.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ЗагрузитьКатегорииВФоне(КатегорииКЗагрузке, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Загрузка категорий в базу данных.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.ЗагрузитьКатегории";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, КатегорииКЗагрузке, ПараметрыВыполнения);
	
КонецФункции

// См. РаботаСНоменклатуройКлиент.ПолучитьЗначенияСоответствующиеЗаданным
//
// Параметры:
//  ПараметрыЗапроса		 - Структура - параметры запроса.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьЗначенияСоответствующиеЗаданнымВФоне(ПараметрыЗапроса, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Поиск значений соответствующих заданным.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.ПолучитьЗначенияСоответствующиеЗаданным";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыЗапроса, ПараметрыВыполнения);
	
КонецФункции

#КонецОбласти

#Область РаботаСНоменклатурой

// Получение данных по номенклатуре с дополнительными реквизитами, значениями и характеристиками.
//
// Параметры:
//  ИдентификаторыНоменклатуры - Массив (Строка) - идентификаторы номенклатуры.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьДанныеНоменклатурыСервиса(ИдентификаторыНоменклатуры, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Получение данных по номенклатуре.'");
	
	ИмяПроцедуры = "РаботаСНоменклатурой.ПолучитьДанныеНоменклатурыСервиса";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	ПараметрыВызова = Новый Структура;
	
	ПараметрыВызова.Вставить("РежимПроверкиПередЗагрузкой", Ложь);
	ПараметрыВызова.Вставить("ИдентификаторыНоменклатуры", ИдентификаторыНоменклатуры);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыВызова, ПараметрыВыполнения);
	
КонецФункции

// Получение списка номенклатуры.
//
// Параметры:
//  ПараметрыПоиска			 - Структура - см. РаботаСНоменклатурой.СформироватьПараметрыПоиска.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьПереченьНоменклатурыВФоне(ПараметрыПоиска, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Получение списка номенклатуры.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.ПолучитьПереченьНоменклатуры";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПоиска, ПараметрыВыполнения);
	
КонецФункции

// Получение представление номенклатуры.
//
// Параметры:
//  ИдентификаторыНоменклатуры - Массив - идентификаторов номенклатуры.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция СформироватьПредставленияКарточекНоменклатурыВФоне(ИдентификаторыНоменклатуры, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Формирование представления карточек номенклатуры.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.СформироватьПредставленияКарточекНоменклатуры";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	ХранилищеКэшей = Новый Соответствие;
	Для каждого Идентификатор Из ИдентификаторыНоменклатуры Цикл
		
		ХранилищеКэшей.Вставить(Идентификатор,
			ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор));
		
	КонецЦикла;
	
	ПараметрыПроцедуры = Новый Структура("ИдентификаторыНоменклатуры, ХранилищеКэшей", ИдентификаторыНоменклатуры, ХранилищеКэшей);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

// Создание номенклатуры.
//
// Параметры:
//  ИдентификаторыНоменклатуры - Массив - идентификаторов номенклатуры.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция СоздатьНоменклатуруВФоне(ИдентификаторыНоменклатуры, Знач УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = '1С:Номенклатура. Загрузка и создание номенклатуры.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.СоздатьНоменклатуру";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ДополнительныйРезультат = Истина;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ИдентификаторыНоменклатуры, ПараметрыВыполнения);
	
КонецФункции

// Создание номенклатуры с условиями.
//
// Параметры:
//  ПараметрыПроцедуры - Структура - параметры создания.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция СоздатьНоменклатуруСУсловиямиВФоне(ПараметрыПроцедуры, Знач УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = '1С:Номенклатура. Загрузка и создание номенклатуры.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.СоздатьНоменклатуруСУсловиями";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ДополнительныйРезультат = Истина;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

// Получение количества карточек номенклатуры по строке поиска.
//
// Параметры:
//  СтрокаПоиска			 - Строка - строка поиска.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьКоличествоКарточекНоменклатурыПоСтрокеПоискаВФоне(СтрокаПоиска, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = '1С:Номенклатура. Получение списка карточек номенклатуры по строке поиска.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.КоличествоНоменклатурыПоСтрокеПоиска";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, СтрокаПоиска, ПараметрыВыполнения);
	
КонецФункции

// Получение данных номенклатуры по штрихкоду.
//
// Параметры:
//  ШтрихКод - Строка - штрихкод.
// 
// Возвращаемое значение:
//  Массив - идентификаторы номенклатуры.
//
Функция ПолучитьДанныеПоНоменклатуреПоШтрихкоду(ШтрихКод) Экспорт
	
	Если НЕ РаботаСНоменклатурой.ПравоЧтенияДанных() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеПоНоменклатуре = РаботаСНоменклатурой.ПолучитьДанныеПоНоменклатуреПоШтрихкоду(ШтрихКод);
	
	Если ДанныеПоНоменклатуре = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ДанныеПоНоменклатуре.ВыгрузитьКолонку("Идентификатор");
		
КонецФункции

// Покупка карточки номенклатуры.
//
// Параметры:
//  ИдентификаторыНоменклатуры - Массив - идентификаторов номенклатуры.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция КупитьКарточкиНоменклатурыВФоне(ИдентификаторыНоменклатуры, Знач УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Получение списка номенклатуры.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.КупитьКарточкиНоменклатуры";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ИдентификаторыНоменклатуры, ПараметрыВыполнения);
	
КонецФункции

#КонецОбласти

#Область РаботаСРекламнымиЗаписями

// Кэширование изображения баннеров для отображения на формах.
//
// Параметры:
//  ИдентификаторыИсточников - Массив - идентификаторы рекламных записей.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ЗакэшироватьИзображенияБаннеровФоне(ИдентификаторыИсточников, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = '1С:Номенклатура. Получение изображения рекламных баннеров поставщиков информации.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.ЗакэшироватьИзображенияБаннеров";
	
	ХранилищеКэшей = Новый Соответствие;
	Для каждого ИдентификаторИсточника Из ИдентификаторыИсточников Цикл
		ДанныеБаннера = Новый Структура("ПутьКДаннымБаннера, СсылкаПереходаПоБаннеру, АдресИзображения");
		ДанныеБаннера.ПутьКДаннымБаннера = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		ХранилищеКэшей.Вставить(ИдентификаторИсточника, ДанныеБаннера);
	КонецЦикла;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ХранилищеКэшей, ПараметрыВыполнения);
	
КонецФункции

#КонецОбласти

#Область Универсальные

// Кэширование изображений перед отображением на форме.
//
// Параметры:
//  АдресаИзображений		 - Массив - адреса изображений.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ЗакэшироватьИзображенияФоне(АдресаИзображений, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = '1С:Номенклатура. Получение изображений.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.ЗакэшироватьИзображения";
	
	ХранилищеКэшей = Новый Массив;
	Для каждого АдресИзображения Из АдресаИзображений Цикл
		
		ЗаписьХранилищаКэшей = Новый Структура("ПутьКДаннымИзображения, АдресИзображения");
		ЗаписьХранилищаКэшей.АдресИзображения   = АдресИзображения;
		ЗаписьХранилищаКэшей.ПутьКДаннымИзображения = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		
		ХранилищеКэшей.Добавить(ЗаписьХранилищаКэшей);
	КонецЦикла;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ХранилищеКэшей, ПараметрыВыполнения);
	
КонецФункции

// Проверка состояния сервиса.
//
// Параметры:
//  ИдентификаторФормы   - УникальныйИдентификатор - Уникальный идентификатор формы.
//  ИдентификаторЗадания - УникальныйИдентификатор - Уникальный идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПроверитьСостояниеСервисаВФоне(ИдентификаторФормы, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания   = НСтр("ru = '1С:Номенклатура. Проверка состояния подключения сервиса'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.ПроверитьСостояниеСервиса";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, Неопределено, ПараметрыВыполнения);
	
КонецФункции

// Проверка доступности подсистемы и права чтения.
// 
// Возвращаемое значение:
//  Булево - Истина если доступно.
//
Функция ДоступенФункционалПодсистемы() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьСервисРаботаСНоменклатурой") 
		И РаботаСНоменклатурой.ПравоЧтенияДанных(); 
	
КонецФункции

#КонецОбласти

#Область ОбновлениеДанных

Функция ПолучитьОбновленияВидовНоменклатурыВФоне(ОбновляемыеОбъекты, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = '1С:Номенклатура. Получение обновлений видов номенклатуры.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.ПолучитьОбновленияВидовНоменклатуры";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ОбновляемыеОбъекты, ПараметрыВыполнения);
	
КонецФункции

Функция ПолучитьОбновленияНоменклатурыВФоне(ОбновляемыеОбъекты, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = '1С:Номенклатура. Получение списка категорий от выбранной до корневой.'");
	ИмяПроцедуры        = "РаботаСНоменклатурой.ПолучитьОбновленияНоменклатуры";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ОбновляемыеОбъекты, ПараметрыВыполнения);
	
КонецФункции
	
#КонецОбласти

// Обновление объектов данных, вызванное из форм заполнения.
//
// Параметры:
//  СсылкаНаОбъект	 - Ссылка - ссылка на обновляемый объект.
//  Идентификатор	 - Строка - идентификатор привязанного объекта.
//
Процедура ОбновитьОбъектИнформационнойБазы(СсылкаНаОбъект, Идентификатор) Экспорт
		                                                                                 
	Если Метаданные.ОпределяемыеТипы.НоменклатураРаботаСНоменклатурой.Тип.СодержитТип(ТипЗнч(СсылкаНаОбъект)) Тогда
		
		// Номенклатура
		
		РаботаСНоменклатуройСлужебный.ОбновитьНоменклатуру(СсылкаНаОбъект, Идентификатор);
		РаботаСНоменклатурой.УстановитьРежимОбновленияНоменклатуры(СсылкаНаОбъект, Идентификатор, Истина);
		
	ИначеЕсли Метаданные.ОпределяемыеТипы.ВидНоменклатурыРаботаСНоменклатурой.Тип.СодержитТип(ТипЗнч(СсылкаНаОбъект)) Тогда		
		
		// Вид номенклатуры
		
		РаботаСНоменклатуройСлужебный.ОбновитьВидНоменклатуры(СсылкаНаОбъект, Идентификатор);
		РаботаСНоменклатурой.УстановитьРежимОбновленияВидаНоменклатуры(СсылкаНаОбъект, Идентификатор, Истина);
		
	КонецЕсли; 
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Отмена выполнения регламентного задания.
//
// Параметры:
//  ИдентификаторЗадания - УникальныйИдентификатор - идентификатор задания.
//
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

