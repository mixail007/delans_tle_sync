&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПолноеИмяФайла") Тогда
		ПутьКФайлу = Параметры.ПолноеИмяФайла;
	КонецЕсли;
	Если Параметры.Свойство("НаименованиеДокумента") Тогда
		НаименованиеДокумента = Параметры.НаименованиеДокумента;
		ЭтаФорма.АвтоЗаголовок = Ложь;
		ЭтаФорма.Заголовок = НаименованиеДокумента;
	КонецЕсли;
	Если Параметры.Свойство("ТипФайла") Тогда
		ТипФайла = Параметры.ТипФайла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПутьКФайлу <> "" И (ТипФайла = "PDF" ИЛИ ТипФайла = "JPG" ИЛИ ТипФайла = "XLS" ИЛИ ТипФайла = "XLSX") Тогда
		ИмяВрФайла = ПолучитьИмяВременногоФайла(ТипФайла); 
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеНачатьКопированиеФайла", ЭтаФорма, ТипФайла);
		НачатьКопированиеФайла(ОписаниеОповещения, ПутьКФайлу, ИмяВрФайла);
	Иначе
		Отказ = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеНачатьКопированиеФайла(ПолныйПутьКФайлу, ТипФайла) Экспорт
	
	Если ПолныйПутьКФайлу <> Неопределено И ПолныйПутьКФайлу <> "" Тогда
		Если ТипФайла = "PDF" ИЛИ ТипФайла = "JPG" Тогда
			Элементы.ПолеДокумента.Видимость = Истина;
			ПолеДокумента = ПолныйПутьКФайлу;	
		ИначеЕсли ТипФайла = "XLS" ИЛИ ТипФайла = "XLSX" Тогда
			Элементы.ПолеТабличногоДокумента.Видимость = Истина;
			ПрочитатьФайлНаСервере(ПолныйПутьКФайлу);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПрочитатьФайлНаСервере(ПутьКФайлу)
	ПолеТабличногоДокумента.Прочитать(ПутьКФайлу);
КонецПроцедуры
		

// Процедура - обработчик события формы "ОбработкаОповещения"
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "УпрОсновнаяФормаБудетЗакрыта"  И ЭтаФорма.Открыта() Тогда
		
		ЭтаФорма.Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры
