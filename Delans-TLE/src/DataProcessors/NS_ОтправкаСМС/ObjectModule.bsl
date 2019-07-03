Перем SessionId;

&НаСервере
Процедура БалансНаСервере()  Экспорт 
	SMSUser = "global_delivery";
	SMSPass = "HnO(ytb!s4";
	SMSServer = "integrationapi.net/rest";
	Баланс = SMS_УзнатьБаланс(SMSServer,SMSUser,SMSPass);
	Сообщить(Баланс);
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Процедура ПолучитьSessionId(SMS_Server,SMS_User,SMS_Pass, Отказ)
	
	//новый запрос
    Адрес = "https://"+ SMS_Server + "/User/SessionId?";
    ТекстОтвет = "";

    ПараметрыЗапроса = "";
	ПараметрыЗапроса = ПараметрыЗапроса + "login=" 		+ SMS_User;
    ПараметрыЗапроса = ПараметрыЗапроса + "&password=" 	+ SMS_Pass;

    Попытка
        ХМЛХТТП = ПолучитьCOMОбъект("", "MSXML2.XMLHTTP");
        ХМЛХТТП.Open("POST", Адрес, Ложь);
        ХМЛХТТП.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        ХМЛХТТП.Send(ПараметрыЗапроса);
        ТекстОтвет = ХМЛХТТП.ResponseText();
		
		Если СтрДлина(ТекстОтвет) = 38 Тогда
			SessionId = Сред(ТекстОтвет,2,36);
		Иначе
			Отказ = Истина;
		КонецЕсли;
	Исключение
		Отказ = Истина;
	КонецПопытки;	
	
КонецПроцедуры

&НаСервере
Функция SMS_УзнатьБаланс(SMS_Server,SMS_User,SMS_Pass) Экспорт
	
	Вернуть="Error";

	Отказ = Ложь;
	ПолучитьSessionId(SMS_Server,SMS_User,SMS_Pass,Отказ);
	
	Если Отказ Тогда
		Возврат Вернуть;
	КонецЕсли;
	
	Адрес = "https://"+ SMS_Server + "/User/Balance?";//ВидСервераИзАПИКлюча(АПИКлюч) + ".api.mailchimp.com/1.3/?method=templateAdd";
	ПараметрыЗапроса = "sessionId=" + SessionId;

	Попытка
		ХМЛХТТП = ПолучитьCOMОбъект("", "MSXML2.XMLHTTP");
	    ХМЛХТТП.Open("POST", Адрес, Ложь);
	    ХМЛХТТП.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	    ХМЛХТТП.Send(ПараметрыЗапроса);
	    ТекстОтвет = ХМЛХТТП.ResponseText();
		
		//проверка через преобразование (возврат ошибки ввиде HTML, или строка баланса)
		А = Число(ТекстОтвет);
		Возврат ТекстОтвет;
		
    Исключение
        Сообщить("Ошибка отправки:");
        Сообщить(ОписаниеОшибки());
    КонецПопытки;
	
	Возврат Вернуть;	
	
КонецФункции


&НаСервере
Процедура ОтправитьМассовоНаСервере()  Экспорт
	
МассоваяОтправка(0);	
КонецПроцедуры

&НаСервере
Функция МассоваяОтправка(Отложить) Экспорт
//	Если НЕ ПроверитьВозможностьОтправки() Тогда Возврат ""; КонецЕсли;
		SMSFrom = ""; 
	SMSText = "";
	SMSUser = "global_delivery";
	SMSPass = "HnO(ytb!s4";
	SMSServer = "integrationapi.net/rest";

	Выборка = ПолучитьВыборкуОтправки();
	Пока Выборка.Следующий() Цикл 
		//
		НаборЗаписей = РегистрыСведений.NS_СМСОповещение.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.ЗаказПокупателя.Установить(Выборка.ЗаказПокупателя); 
		НаборЗаписей.Отбор.ТипСМС.Установить(Выборка.ТипСМС); 
		НаборЗаписей.Отбор.СтатусЗаказа.Установить(Выборка.СтатусЗаказа); 
		НаборЗаписей.Прочитать();
		Для Каждого СтрокаТаблицы Из НаборЗаписей Цикл 
			
			СтрокаТаблицы.ДатаИзменения = ТекущаяДата(); 
			СтрокаТаблицы.ВРаботе = Истина; 
			
		КонецЦикла; 
		
		НаборЗаписей.Записать();
		//
		
		SMSFrom = "GD_LOGISTIC"; 
		SMSText = "Заказ: "+ строка(Выборка.ES_НомерНакладной) + " зарегистрирован.";
		SMSTo  = Выборка.КонтактныйТелефон;  //номерПолучателя
		SMSFlash  	=  0;
		Если Отложить = 0 Тогда
			SMSID=SMS_Отправка(SMSServer,SMSUser,SMSPass,SMSTo,SMSFrom,SMSFlash,SMSText, Выборка.ЗаказПокупателя,Выборка.ТипСМС, Выборка.СтатусЗаказа);
		Иначе
			SMSID = "";//SMSID=SMS_Отправка_Отложенная(SMSServer,SMSUser,SMSPass,"&destinationAddress="+SMSTo,SMSFrom,SMSFlash,SMSText,SMSTimeTest)
		КонецЕсли;
	КонецЦикла;
	Возврат SMSID;
КонецФункции

&НаСервере
Функция ПолучитьВыборкуОтправки()
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 199
	                      |	NS_СМСОповещение.ЗаказПокупателя как ЗаказПокупателя,
	                      |	NS_СМСОповещение.ЗаказПокупателя.ES_НомерНакладной КАК ES_НомерНакладной,
	                      |	NS_СМСОповещение.ЗаказПокупателя.ES_ПолучательТелефон КАК КонтактныйТелефон,
	                      |	NS_СМСОповещение.ТипСМС как ТипСМС,
	                      |	NS_СМСОповещение.СтатусЗаказа как СтатусЗаказа
	                      |ИЗ
	                      |	РегистрСведений.NS_СМСОповещение КАК NS_СМСОповещение
	                      |ГДЕ
	                      |	НЕ NS_СМСОповещение.ВРаботе");
	Выборка =  Запрос.Выполнить().Выбрать();
	
	Возврат Выборка;
КонецФункции
&НаСервере
Процедура СформироватьСписокНомеровПоМассиву(Строки,Num_From,Num_To,SMS_List) Экспорт
	Разделитель = "";
	SMS_List = "";
	//Для НомерСтроки = Num_From ПО Num_To  Цикл
	//	SMS_List = SMS_List + Разделитель + "&destinationAddresses="+Строки[НомерСтроки-1].НомерАбонента;
	//	//Разделитель = ",";
	//КонецЦикла;	
КонецПроцедуры

&НаСервере
Функция SMS_Отправка(SMS_Server,SMS_User,SMS_Pass,SMS_To,SMS_From,SMS_Flash,SMS_Text, ЗаказПокупателя,ТипСМС, СтатусЗаказа) Экспорт
	
	Ответ = "";                         
	Вернуть = "-1"; // SMS_ID - не удалось получить
	
	Отказ = Ложь;
	ПолучитьSessionId(SMS_Server,SMS_User,SMS_Pass, Отказ);
	
	Если Отказ Тогда
		Возврат Вернуть;
	КонецЕсли;
	
	SMS_Text_ToGo = ОбработатьТекстСМСПередОтправкой(SMS_Text);
	
	Адрес = "https://"+ SMS_Server + "/Sms/Send?";
	ТекстОтвет = "";

	ПараметрыЗапроса = "";
	ПараметрыЗапроса = ПараметрыЗапроса + "sessionId=" 		+ SessionId;
	ПараметрыЗапроса = ПараметрыЗапроса + "&destinationAddress=" 	+ SMS_To;
	ПараметрыЗапроса = ПараметрыЗапроса + "&sourceAddress=" + SMS_From;
	ПараметрыЗапроса = ПараметрыЗапроса + "&data=" + SMS_Text_ToGo;

    Попытка
        ХМЛХТТП = ПолучитьCOMОбъект("", "MSXML2.XMLHTTP");
        ХМЛХТТП.Open("POST", Адрес, Ложь);
	Исключение
		Сообщить("Неудачная попытка интернет-соединения.");
		Сообщить(ОписаниеОшибки());
		
		Возврат Вернуть;
	КонецПопытки;
	
	ХМЛХТТП.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	ХМЛХТТП.Send(ПараметрыЗапроса);
	ТекстОтвет = ХМЛХТТП.ResponseText();
	Если Найти(ТекстОтвет, "{""Code"":") Тогда
		Сообщить("Сообщение не удалось отправить! 
		|" + ТекстОтвет);
		
		НаборЗаписей = РегистрыСведений.NS_СМСОповещение.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.ЗаказПокупателя.Установить(ЗаказПокупателя); 
		НаборЗаписей.Отбор.ТипСМС.Установить(ТипСМС); 
		НаборЗаписей.Отбор.СтатусЗаказа.Установить(СтатусЗаказа); 
		НаборЗаписей.Прочитать();
		Для Каждого СтрокаТаблицы Из НаборЗаписей Цикл 
			
			СтрокаТаблицы.ДатаИзменения = ТекущаяДата(); 
			СтрокаТаблицы.ВРаботе = Ложь; 
			СтрокаТаблицы.Комментарий ="Запрос: "+ПараметрыЗапроса+ "Ответ: "+ТекстОтвет;
		КонецЦикла; 
		
		НаборЗаписей.Записать();

		
		Возврат Вернуть;
	КонецЕсли;
	
	//Если Не Найти(ТекстОтвет, "SAR") Тогда
	ТекстОтвет = СтрЗаменить(СтрЗаменить(ТекстОтвет, "[""",""),"""]","");
	// Выделить SMS_ID и вернуть
	Вернуть = ТекстОтвет; // Выделение SMS_ID
	Сообщить("Сообщение успешно отправлено! ID: " + Вернуть);
	НаборЗаписей = РегистрыСведений.NS_СМСОповещение.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.ЗаказПокупателя.Установить(ЗаказПокупателя); 
		НаборЗаписей.Отбор.ТипСМС.Установить(ТипСМС); 
		НаборЗаписей.Отбор.СтатусЗаказа.Установить(СтатусЗаказа); 
		НаборЗаписей.Прочитать();
		Для Каждого СтрокаТаблицы Из НаборЗаписей Цикл 

			СтрокаТаблицы.ДатаИзменения = ТекущаяДата(); 
			СтрокаТаблицы.ОтправленоУспешно = Истина; 
			СтрокаТаблицы.Комментарий ="Запрос: "+ПараметрыЗапроса+ " Ответ: "+ТекстОтвет+" ID: " + Вернуть;
		КонецЦикла; 
		
		НаборЗаписей.Записать();

	Возврат Вернуть;
	//КонецЕсли;
	
	
КонецФункции

&НаСервере
Функция ОбработатьТекстСМСПередОтправкой(Text) Экспорт
	Text1 = Text;
	CrLf = Символ(13) + Символ(10);
	
	// Подготовка текста SMS к отправке - преобразование к HTML форме
	Text1=СтрЗаменить(Text1,"&"     ,"%26" ); // Обработка  &
	Text1=СтрЗаменить(Text1,"<"     ,"%3C"  ); // Обработка  <
	Text1=СтрЗаменить(Text1,">"     ,"%3E"  ); // Обработка  >
	Text1=СтрЗаменить(Text1,Символы.ПС    ,"%0A"  ); // Обработка символов переноса
	Возврат  Text1;            
КонецФункции

