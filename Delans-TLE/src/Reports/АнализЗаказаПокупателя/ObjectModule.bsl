#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.ПоказыватьГруппуСтрокиНаФормеОтчета = Ложь;
	НастройкиОтчета.ПоказыватьГруппуКолонкиНаФормеОтчета = Ложь;
	НастройкиОтчета.ПоказыватьНастройкиДиаграммыНаФормеОтчета = Ложь;
	
	НастройкиВариантов["Основной"].Рекомендуемый = Истина;
	
	ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов);
	УстановитьТегиВариантов(НастройкиВариантов);
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов)
	
	МассивПолейСумм = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("Оплачено,ОсталосьОплатить,СуммаДокумента,Оплата,ОплатаПлан,Предоплата");
	МассивПолейКоличеств = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("ЗарезервированоНаСкладе,ОсталосьОбеспечить,ОсталосьОтгрузить,Отгружено,РазмещеноВЗаказах,СвободныйОстаток,Заказано");
	
	Для каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		
		ВариантыОформления = НастройкиТекВарианта.Значение.ВариантыОформления;
		ОтчетыУНФ.ДобавитьВариантыОформленияСумм(ВариантыОформления, МассивПолейСумм);
		ОтчетыУНФ.ДобавитьВариантыОформленияКоличества(ВариантыОформления, МассивПолейКоличеств);
			
	КонецЦикла; 
	
КонецПроцедуры

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Основной"].Теги = НСТР("ru = 'Номенклатура,Заказы,Оплаты,Отгрузки,Запасы,Закупки,Остатки,Резервы,Продажи'");
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Основной"].СвязанныеПоля, "Заказ", "Документ.ЗаказПокупателя",,, Истина);
	
КонецПроцедуры
 
#КонецОбласти 

ЭтоОтчетУНФ = Истина;

#КонецЕсли