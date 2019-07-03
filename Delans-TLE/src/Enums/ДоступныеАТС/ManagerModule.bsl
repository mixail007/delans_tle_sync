#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция СсылкиНаСтатьи() Экспорт
	
	Ссылки = Новый СписокЗначений;
	Ссылки.Добавить(Перечисления.ДоступныеАТС.MangoOffice,           "https://www.mango-office.ru/products/virtualnaya_ats");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.ДомRu,                 "https://b2b.domru.ru/products/oats-new?utm_source=1c_unf&utm_medium=button&utm_campaign=federal");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.Яндекс,                "https://telephony.yandex.ru/");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.ВестКоллСПб,           "http://oats.westcall.spb.ru?utm_source=1C&utm_medium=cpc&utm_campaign=instrukciya");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.ДеловаяСетьИркутск,    "http://ats.dsi.ru/");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.Энфорта,               "https://www.enforta.ru/services/enfortats/");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.Мегафон,               "https://vats.megafon.ru/");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.ТТК,                   "http://myttk.ru/business/services/virtualnaya_ats_/");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.ВестКоллМосква,        "http://westcall.ru/atc/");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.VirginConnect,         "http://virginconnect.ru/pbx/");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.ГарсТелеком,           "http://garstelecom.ru/for-business/all-solutions/virtualnaya-ats-ip-telefoniya/");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.НаукаСвязь,            "http://www.naukanet.ru/vpbx/");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.RiNet,                 "http://corp.rinet.ru/services/virtual_ats/");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.СибирскиеСети,         "https://b2b.sibset.ru/services/ip");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.Авантел,               "http://avantel.ru/services/telephony/");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.Гравител,              "https://www.gravitel.ru/services/virtual_ats/");
	Ссылки.Добавить(Перечисления.ДоступныеАТС.МГТС,                  "https://vats.mgts.ru/");
	Ссылки.Добавить("МобильнаяТелефония",                            "https://its.1c.ru/db/updinfo#content:479:1:issogl2_2");
	
	Возврат Ссылки;
	
КонецФункции

Функция ДоступныеАТСУниверсальногоВиджетаItoolabs() Экспорт
	
	Ссылки = Новый ТаблицаЗначений;
	Ссылки.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Ссылки.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Ссылки.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("Строка"));
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Altegro";
	Ссылка.Представление = "Altegro";
	Ссылка.Ссылка = "http://altegrocloud.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "АльянсТелеком";
	Ссылка.Представление = "АльянсТелеком";
	Ссылка.Ссылка = "http://inetvl.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "ВАМтел";
	Ссылка.Представление = "ВАМтел";
	Ссылка.Ссылка = "http://vamtel.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "ВекторТел";
	Ссылка.Представление = "ВекторТел";
	Ссылка.Ссылка = "http://vectortel.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "КорпорацияVoIP";
	Ссылка.Представление = "Корпорация VoIP";
	Ссылка.Ссылка = "http://corpvoip.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "ИнтИнформ";
	Ссылка.Представление = "Инт-Информ";
	Ссылка.Ссылка = "http://intinform.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Интеграл";
	Ссылка.Представление = "Интеграл";
	Ссылка.Ссылка = "http://i-t.spb.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Кловертел";
	Ссылка.Представление = "Кловертел";
	Ссылка.Ссылка = "https://clovertel.pulscen.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Comiten";
	Ссылка.Представление = "Comiten";
	Ссылка.Ссылка = "http://comiten.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "SipVip";
	Ссылка.Представление = "SipVip";
	Ссылка.Ссылка = "https://sipvip.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Комфинанс";
	Ссылка.Представление = "Комфинанс";
	Ссылка.Ссылка = "http://www.comfinance.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "КонтинентКоннект";
	Ссылка.Представление = "Континент Коннект";
	Ссылка.Ссылка = "http://kkont.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "КРОК";
	Ссылка.Представление = "КРОК";
	Ссылка.Ссылка = "http://www.croc.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "КТелеком";
	Ссылка.Представление = "К Телеком";
	Ссылка.Ссылка = "https://ekaterinburg.k-telecom.org/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "МАТРИКСмобайл";
	Ссылка.Представление = "МАТРИКС мобайл";
	Ссылка.Ссылка = "http://matrixmobile.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Миран";
	Ссылка.Представление = "Миран";
	Ссылка.Ссылка = "http://miran.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "МортонТелеком";
	Ссылка.Представление = "Мортон Телеком";
	Ссылка.Ссылка = "http://www.mtel.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "САЛЬВАДОРтелефония";
	Ссылка.Представление = "САЛЬВАДОР телефония";
	Ссылка.Ссылка = "http://sip-melt.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Новотелс";
	Ссылка.Представление = "Новотелс";
	Ссылка.Ссылка = "http://novotels.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "TelefonCo";
	Ссылка.Представление = "TelefonCo";
	Ссылка.Ссылка = "http://telefonco.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Омскиекабельныесети";
	Ссылка.Представление = "Омские кабельные сети";
	Ссылка.Ссылка = "http://www.omkc.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Мегатон";
	Ссылка.Представление = "Мегатон";
	Ссылка.Ссылка = "http://megaton-net.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "CLOUDGATES";
	Ссылка.Представление = "CLOUDGATES";
	Ссылка.Ссылка = "https://cloudgates.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "РЕНЕТКОМ";
	Ссылка.Представление = "РЕНЕТ КОМ";
	Ссылка.Ссылка = "http://renet.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "РУКОМТЕХ";
	Ссылка.Представление = "РУКОМТЕХ";
	Ссылка.Ссылка = "http://www.rucom.tech/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Русскиесистемы";
	Ссылка.Представление = "Русские системы";
	Ссылка.Ссылка = "http://www.ru-sys.com/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "СвязьХолдинг";
	Ссылка.Представление = "Связь-Холдинг";
	Ссылка.Ссылка = "http://govorit.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "АОНорильскТелеком";
	Ссылка.Представление = "АО ""Норильск-Телеком""";
	Ссылка.Ссылка = "http://norcom.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "SMARTCARD";
	Ссылка.Представление = "SMARTCARD";
	Ссылка.Ссылка = "http://smcard.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "ТВИНГОтелеком";
	Ссылка.Представление = "ТВИНГО телеком";
	Ссылка.Ссылка = "http://tvingo.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Tekmi";
	Ссылка.Представление = "Tekmi";
	Ссылка.Ссылка = "http://tekmi.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "EVO";
	Ссылка.Представление = "EVO";
	Ссылка.Ссылка = "https://www.evo73.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Телемир";
	Ссылка.Представление = "Телемир";
	Ссылка.Ссылка = "http://telemir.net/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Телетай";
	Ссылка.Представление = "Телетай";
	Ссылка.Ссылка = "http://www.teletie.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "TelefonN";
	Ссылка.Представление = "TelefonN";
	Ссылка.Ссылка = "http://telefonn.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "OpenSpeak";
	Ссылка.Представление = "OpenSpeak";
	Ссылка.Ссылка = "http://openspeak.kz/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Ультрамарин";
	Ссылка.Представление = "Ультрамарин";
	Ссылка.Ссылка = "http://www.ul.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Щелковоnet";
	Ссылка.Представление = "Щелково•net";
	Ссылка.Ссылка = "http://www.schelkovo-net.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Эконотел";
	Ссылка.Представление = "Эконотел";
	Ссылка.Ссылка = "http://econotel.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "ЮГТЕЛЕКОМ";
	Ссылка.Представление = "ЮГ-ТЕЛЕКОМ";
	Ссылка.Ссылка = "http://www.southtel.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "DreamNet";
	Ссылка.Представление = "DreamNet";
	Ссылка.Ссылка = "https://dreamnet.su/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Easytel";
	Ссылка.Представление = "Easytel";
	Ссылка.Ссылка = "http://easytel.top/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Finenumbers";
	Ссылка.Представление = "Finenumbers";
	Ссылка.Ссылка = "http://finenumbers.com/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "НовыеТелефонныеСистемы";
	Ссылка.Представление = "Новые Телефонные Системы";
	Ссылка.Ссылка = "http://www.newtehno.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "PowerTelecom";
	Ссылка.Представление = "Power Telecom";
	Ссылка.Ссылка = "http://powertelecom.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Spacetel";
	Ссылка.Представление = "Spacetel";
	Ссылка.Ссылка = "http://spacetel.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "COMLINK";
	Ссылка.Представление = "COMLINK";
	Ссылка.Ссылка = "http://comlink.su/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "Экомобайл";
	Ссылка.Представление = "Экомобайл";
	Ссылка.Ссылка = "http://www.ekomobile.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "TASHIRTELECOM";
	Ссылка.Представление = "TASHIR TELECOM";
	Ссылка.Ссылка = "https://tashirtelecom.ru/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "TELEPRO";
	Ссылка.Представление = "TELEPRO";
	Ссылка.Ссылка = "http://www.telepro.pro/";
	
	Ссылка = Ссылки.Добавить();
	Ссылка.Идентификатор = "NETBYNET";
	Ссылка.Представление = "NETBYNET";
	Ссылка.Ссылка = "http://www.netbynet.ru/";
	
	Возврат Ссылки;
	
КонецФункции

#КонецОбласти

#КонецЕсли