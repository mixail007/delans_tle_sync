#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ОтформатироватьИсходныйФайл(ИсходныйТекст) Экспорт
	
	РабочийДокумент = ПодготовитьЗаголовок();
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ИсходныйТекст);
	
	РабочийДокумент = РабочийДокумент + ПолучитьФорматированнуюОбластьДанных(ТекстовыйДокумент);
	
	РабочийДокумент = РабочийДокумент + ПодготовитьПодвал();
	
	Возврат РабочийДокумент;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// вспомогательные процедуры

//-----------------------------------------------------------------------------
// функции логики работы

Функция ПолучитьФорматированнуюОбластьДанных(ИсходныйДокумент)
	
	БуферЛеваяЧасть = "<td><pre class=""LeftSide"">";
	БуферПраваяЧасть = "<td width=""100%""><pre class=""FormattedText"">";
	СчетчикСекций =  0;
	МаксимальнаяШиринаТэга = 0;
	БылПостСепаратор = Ложь;
	
	Для К = 1 по ИсходныйДокумент.КоличествоСтрок() Цикл
		
		ИсходнаяСтрока = ИсходныйДокумент.ПолучитьСтроку(к);
		ВРегИсходнаяСтрока = ВРег(ИсходнаяСтрока);
		ТребуетсяНумерация = Ложь;
		ФорматСтрокаЛевая = "";
		ФорматСтрокаПравая = "";
		
		
		Если ЭтоНачалоСекции(ВРегИсходнаяСтрока, ТребуетсяНумерация) Тогда
			
			МаксимальнаяШиринаТэга = РассчитатьМаксимальнуюШиринуТэгаСекции(ИсходныйДокумент, К);
			Если ТребуетсяНумерация Тогда
				СчетчикСекций = СчетчикСекций + 1;
			КонецЕсли;
			
			ТекстНачалаСекции(ИсходнаяСтрока, СчетчикСекций, ТребуетсяНумерация, МаксимальнаяШиринаТэга, ФорматСтрокаЛевая, ФорматСтрокаПравая);
			
		ИначеЕсли НЕ СодержитРазделители(ВРегИсходнаяСтрока) Тогда
			
			МаксимальнаяШиринаТэга = РассчитатьМаксимальнуюШиринуТэгаСекции(ИсходныйДокумент, К);
			ТекстКлючевойОбласти(ИсходнаяСтрока, ФорматСтрокаЛевая, ФорматСтрокаПравая);
			
			
		ИначеЕсли ЭтоКонецСекции(ВРегИсходнаяСтрока) Тогда
			
			ТекстКонцаСекции(ИсходнаяСтрока, ФорматСтрокаЛевая, ФорматСтрокаПравая);
			
		Иначе
			
			ТекстОбычнойСтроки(ИсходнаяСтрока, МаксимальнаяШиринаТэга, ФорматСтрокаЛевая, ФорматСтрокаПравая);
			
		КонецЕсли;
		
		ПостСепаратор = ТребуетсяПостСепаратор(ВРегИсходнаяСтрока);
		
		ТекстСепаратора(
			ТребуетсяПредСепаратор(ВРегИсходнаяСтрока) И НЕ БылПостСепаратор,
			ПостСепаратор,
			ФорматСтрокаЛевая,
			ФорматСтрокаПравая);
		
		БуферЛеваяЧасть = БуферЛеваяЧасть + ФорматСтрокаЛевая;
		БуферПраваяЧасть = БуферПраваяЧасть + ФорматСтрокаПравая;
		
		БылПостСепаратор = ПостСепаратор;
	КонецЦикла;
	
	БуферЛеваяЧасть = БуферЛеваяЧасть + "</pre></td>";
	БуферПраваяЧасть = БуферПраваяЧасть + "</pre></td>";
	
	Возврат БуферЛеваяЧасть + БуферПраваяЧасть;
	
КонецФункции

Функция ПолучитьТэгСтроки(Строка)
	
	ПозРавно = Найти(Строка, "=");
	Если ПозРавно = 0 Тогда
		Возврат СокрЛП(Строка);
	Иначе
		Возврат СокрЛП(Лев(Строка, ПозРавно-1));
	КонецЕсли;
	
КонецФункции

Функция ПолучитьЗначениеСтроки(Строка, ВключатьРавно = Истина)
	
	ПозРавно = Найти(Строка, "=");
	Если ПозРавно = 0 Тогда
		Возврат СокрЛП(Строка);
	Иначе
		Возврат ?(ВключатьРавно, "= ","") + СокрЛП(Сред(Строка, ПозРавно+1));
	КонецЕсли;
	
	
КонецФункции

Функция ПовторитьСимволы(Символ, Раз)
	
	Если НЕ (Раз > 0) Тогда
		Возврат "";
	КонецЕсли;
	
	Результат = "";
	
	Для К = 1 по Раз Цикл
		
		Результат = Результат + Символ;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция РассчитатьМаксимальнуюШиринуТэгаСекции(ИсходныйДокумент, Знач К)
	
	МаксШирина = 
		СтрДлина(
			ПолучитьТэгСтроки(
				ИсходныйДокумент.ПолучитьСтроку(к)));
	
	Если к = ИсходныйДокумент.КоличествоСтрок() Тогда
		Возврат МаксШирина;
	КонецЕсли;
	
	Для м = к+1 по ИсходныйДокумент.КоличествоСтрок() Цикл
		
		Строка = ВРег(ИсходныйДокумент.ПолучитьСтроку(м));
		
		Если ЭтоНачалоСекции(Строка)
			ИЛИ ЭтоКонецСекции(Строка) Тогда
			
			Возврат МаксШирина;
		КонецЕсли;
		
		Если НЕ СодержитРазделители(Строка) Тогда
			Продолжить;
		КонецЕсли;
		
		МаксШирина = Макс(МаксШирина, СтрДлина(ПолучитьТэгСтроки(Строка)));
		
	КонецЦикла;
	
	Возврат МаксШирина;
	
КонецФункции

Функция ОтформатироватьПоШирине(ИсходнаяСтрока, ШиринаСекции)
	
	Тэг = ПолучитьТэгСтроки(ИсходнаяСтрока);
	
	Если СодержитРазделители(ИсходнаяСтрока) Тогда
		Значение = ПолучитьЗначениеСтроки(ИсходнаяСтрока);
	Иначе
		Значение = "";
	КонецЕсли;
	
	Возврат Тэг + ПовторитьСимволы(" ", ШиринаСекции-СтрДлина(Тэг)+1) + Значение;
	
КонецФункции

//-----------------------------------------------------------------------------
// функции проверок

Функция СодержитРазделители(Строка)
	
	Возврат Найти(Строка, "=") > 0;
	
КонецФункции

Функция ЭтоНачалоСекции(Строка, ТребуетсяНумерация=Ложь)
	
	Тэг = ПолучитьТэгСтроки(Строка);
	
	Если Тэг = "СЕКЦИЯРАСЧСЧЕТ" Тогда
		ТребуетсяНумерация = Ложь;
		Возврат Истина;
	ИначеЕсли Тэг = "СЕКЦИЯДОКУМЕНТ" Тогда
		ТребуетсяНумерация = Истина;
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция ЭтоКонецСекции(Строка)
	
	Тэг = ПолучитьТэгСтроки(Строка);
	
	Если Тэг = "КОНЕЦРАСЧСЧЕТ"
		ИЛИ Тэг = "КОНЕЦДОКУМЕНТА" Тогда
		
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция ТребуетсяПредСепаратор(Строка)
	
	Тэг = ПолучитьТэгСтроки(Строка);
	
	Если Тэг = "СЕКЦИЯРАСЧСЧЕТ"
		ИЛИ Тэг = "СЕКЦИЯДОКУМЕНТ"
		ИЛИ Тэг = "КОНЕЦФАЙЛА" Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция ТребуетсяПостСепаратор(Строка)
	
	Тэг = ПолучитьТэгСтроки(Строка);
	
	Если Тэг = "1CCLIENTBANKEXCHANGE" Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции


//-----------------------------------------------------------------------------
// функции форматирования

Функция ПодготовитьЗаголовок()
	
	Возврат //
	"<!DOCTYPE html PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">
	|<HTML>
	|<head>
	|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type></META>
	|<META name=GENERATOR content=""MSHTML 8.00.7600.16766""></META>
	|<BASE href=""v8config://ef7bc0c3-17c7-4192-8d80-dd139205fb7f/mdobject/id3622edb0-8786-48e4-a6eb-bcc6557b17a4/8eb4fad1-1fa6-403e-970f-2c12dbb43e23"">
	|
	|<style type=""text/css"">
	|html {
	|	height: 100%;
	|}

	|body {
	|	font-family:'Courier New', Courier, monospace;
	|	font-size: 10pt;
	|	color: black;
	|	height: 100%;
	|	margin: 0px;
	|}
	|table{
	|	margin:0;
	|	padding:0;
	|	display: table;
	|	border-collapse: separate;
	|	border-color: #BDB79B;
	|	font-size:12px;
	|	line-height: 16px;
	|	word-wrap: break-word;
	|	background-color: transparent;
	|}
	|
	|tr {
	|	margin: 0;
	|	padding: 0;
	|	display: table-row;
	|	vertical-align: inherit;
	|	border-color: inherit;
	|}
	|
	|td, th {
	|	display: table-cell;
	|	vertical-align: inherit;
	|	overflow-x: visible;
	|	overflow-y: visible;
	|	font-size:12px;
	|}
	|
	|.LeftSide
	|{
	|
	|	width: 30px;
	|	color: red;
	|	background-color: #E8E5D0;
	|	color: FireBrick;
	|	padding-top: 1em;
	|	padding-right: 0.5em;
	|	border-right-width: 1px;
	|	border-right-style: solid;
	|	border-right-color: #B3AC86;
	|	text-align: center;
	|	font-family:'Courier New',monospace;
	|	line-height: 16px;
	|	font-size: 12px;
	|	display: block;
	|	margin: 0px;
	|	padding-bottom: 12px;
	|	padding-left: 6px;
	|	padding-right: 6px;
	|	padding-top: 12px;
	|}
	|
	|.FormattedText
	|{
	|	font-family:'Courier New',monospace;
	|	font-size: 12px;
	|	margin: 0;
	|	padding: 0;
	|	line-height: 16px;
	|	border: none;
	|	padding: 1em 0;
	|	padding-left: 12px;
	|
	|}
	|
	|.ImportantSection 
	|{
	|	font-weight: bold;
	|	
	|}
	|.TagWord {
	|	color: #536AC2;
	|}
	|</style>
	|</head><body><table cols = 2 cellpadding=""0"" cellspacing=""0""><tr>";
	
КонецФункции

Функция ПодготовитьПодвал()
	
	Возврат
	"</tr></table></body></HTML>";
	
КонецФункции

Процедура ТекстКлючевойОбласти(ИсходнаяСтрока, ЛеваяЧасть, ПраваяЧасть)
	
	ЛеваяЧасть = ЛеваяЧасть  + "<span class=""ImportantSection"">•</span>"+Символы.ПС;
	ПраваяЧасть = ПраваяЧасть + "<span class=""ImportantSection"">"+ИсходнаяСтрока+"</span>"+Символы.ПС;
	
	
КонецПроцедуры

Процедура ТекстНачалаСекции(ИсходнаяСтрока, НомерСекции, ТребуетсяНумерация, ШиринаСекции, ЛеваяЧасть, ПраваяЧасть)
	
	СтрокаКВыводу = ОтформатироватьПоШирине(ИсходнаяСтрока, ШиринаСекции);
	
	ЛеваяЧасть = ЛеваяЧасть + "<span class=""ImportantSection"">" + ?(ТребуетсяНумерация,Формат(НомерСекции, "ЧЦ=3"), "•")+"</span>"+Символы.ПС;
	ПраваяЧасть = ПраваяЧасть + "<span class=""ImportantSection"">"+СтрокаКВыводу+"</span>"+Символы.ПС;
	
КонецПроцедуры

Процедура ТекстКонцаСекции(ИсходнаяСтрока, ЛеваяЧасть, ПраваяЧасть)
	
	ЛеваяЧасть = ЛеваяЧасть +"."+Символы.ПС;
	ПраваяЧасть = ПраваяЧасть + "<span class=""ImportantSection"">"+ИсходнаяСтрока+"</span>"+Символы.ПС;
	
КонецПроцедуры

Процедура ТекстОбычнойСтроки(ИсходнаяСтрока,ШиринаСекции, ЛеваяЧасть, ПраваяЧасть)
	
	Тэг = ПолучитьТэгСтроки(ИсходнаяСтрока);
	Значение = ПолучитьЗначениеСтроки(ИсходнаяСтрока);
	
	ЛеваяЧасть = ЛеваяЧасть + Символы.ПС;
	ПраваяЧасть = ПраваяЧасть + "<span class=""TagWord"">" + Тэг 
		+ ?(ШиринаСекции > 0, ПовторитьСимволы(" ", ШиринаСекции-СтрДлина(Тэг)),"") + "</span>" 
		+ "<span class=""MainText""> "+ Значение+"</span>"
		+Символы.ПС;
	
КонецПроцедуры

Процедура ТекстСепаратора(ПредСепаратор, ПостСепаратор, ЛеваяЧасть, ПраваяЧасть)
	
	ЛеваяЧасть = ?(ПредСепаратор, Символы.ПС, "") + ЛеваяЧасть + ?(ПостСепаратор, Символы.ПС, "");
	ПраваяЧасть = ?(ПредСепаратор, Символы.ПС, "") + ПраваяЧасть + ?(ПостСепаратор, Символы.ПС, "");
	
КонецПроцедуры

#КонецЕсли