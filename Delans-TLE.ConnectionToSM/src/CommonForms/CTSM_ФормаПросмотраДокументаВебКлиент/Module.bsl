&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ESDLТокен = Параметры.ESDLТокен;
	ИД = Параметры.ИД;
	beta = Параметры.beta;
	ТипФайла = Параметры.ТипФайла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
			
	Если НЕ ТипФайла = "JPG" Тогда
		HTMLФайлДокумента = "https://docs.google.com/viewer?embedded=true&url=http://" + ?(beta, "beta-", "") + "adl.42clouds.com/adl42/hs/api_v1/AccountEDocuments/GetDocumentFile/" + ИД + "?TID=" + ESDLТокен;
	Иначе
		src = "http://" + ?(beta, "beta-", "") + "adl.42clouds.com/adl42/hs/api_v1/AccountEDocuments/GetDocumentFile/" + ИД + "?TID=" + ESDLТокен;
		HTMLФайлСтраницы = 
		HTMLФайлДокумента =
		"<HTML>
		|<BODY>
		|<P><IMG "" src=" + src + " hspace=5 vspace=5 width=100% height=auto></IMG></P>
		|</BODY>
		|</HTML>";
	КонецЕсли;
	
КонецПроцедуры
