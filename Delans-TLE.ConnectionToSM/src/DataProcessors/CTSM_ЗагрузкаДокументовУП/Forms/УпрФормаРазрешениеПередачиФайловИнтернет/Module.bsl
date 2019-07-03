// Процедура - обработчик события формы "ПриСозданииНаСервере"
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтотОбъектРеквизит = РеквизитФормыВЗначение("Объект");
	Макет = ЭтотОбъектРеквизит.ПолучитьМакет("СоглашениеОРазрешенииРаботыССервисом"); 
	СоглашениеОРазрешенииРаботыССервисом = Макет.ПолучитьТекст();

КонецПроцедуры

// Процедура - обработчик события формы "ПриЗакрытии"
//
&НаКлиенте
Процедура ПриЗакрытии()
	ВладелецФормы.ПриОткрытииПолученоРазрешение();
КонецПроцедуры

// Процедура - обработчик события элемента  РазрешениеПередачиФайловИнтернет "ПриИзменении"
//
&НаКлиенте
Процедура РазрешениеПередачиФайловИнтернетПриИзменении(Элемент)
	
	ВладелецФормы.РазрешениеПередачиФайловИнтернет = Истина;	
	ПередЗакрытиемВызовНаСервер();
	Закрыть();
	
КонецПроцедуры

// Процедура сохраняет разрешения пользователя
//
&НаСервере
Процедура ПередЗакрытиемВызовНаСервер()
	
	ХранилищеНастроекДанныхФорм.Сохранить("ESDLРазрешения", "РазрешениеПередачиФайловИнтернет", Истина);
			
КонецПроцедуры	
	


// Процедура - обработчик события формы "ОбработкаОповещения"
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "УпрОсновнаяФормаБудетЗакрыта"  И ЭтаФорма.Открыта() Тогда
		
		ЭтаФорма.Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры
