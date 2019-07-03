&НаКлиенте                                                                                                
&НаКлиенте
Перем АктивнаяСтрокаИдОрганизации;
&НаКлиенте
Перем АктивнаяСтрокаИдВнешнейОрганизации;
&НаКлиенте
Перем ИмяАккаунта;


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Состояние("Прогресс",25);
	
	Если ВладелецФормы.ПользовательМенеджер = Ложь Тогда
		Элементы.Доступы.Доступность			= Ложь; 
		Элементы.ОрганизацииКнопки.Доступность	= Ложь;
		Элементы.ЭкспортОрганизаций.Доступность	= Ложь;
		Элементы.Организации.ТолькоПросмотр		= Истина;
		Элементы.ГруппаОбщая.ТолькоПросмотр		= Истина;
	КонецЕсли;
				
	Организации.Очистить();
	
	ЗаполнениеСпискаПользователейАккаунта();

	СтрокаЗапроса = "/api_v2/Accounts/GetAccountCaption?accountID=" + ВладелецФормы.ESDLИДАккаунта;
	ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLCoreHTTP", СтрокаЗапроса);                  	
	Если ПараметрыОтвета.КодОтвета = 200 Тогда
		ИмяАккаунта = ПараметрыОтвета.СтруктураОтвета.AccountCaption;
	Иначе
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
		СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		СообщениеПользователю.Сообщить()
	КонецЕсли;
	
	Состояние("Прогресс",50);
	
	Элементы.ДобавитьОрганизациюПоиск.Заголовок = "Добавить организацию для аккаунта "+ИмяАккаунта;
	Элементы.ДобавитьДоступ.Заголовок = "Дать доступ пользователям аккаунта " + ИмяАккаунта;
	
	СтрокаЗапроса = "/adl42/hs/api_v1/AccOrgAccess/GetTableByAccountID?AccountID=" + ВладелецФормы.ESDLИДАккаунта;
	ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLADLHTTP", СтрокаЗапроса);         
	Если ПараметрыОтвета.КодОтвета = 200 Тогда
		ТаблицаОрганизаций = ПараметрыОтвета.СтруктураОтвета.TableAccOrgAccess;
	Иначе
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
		СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		СообщениеПользователю.Сообщить()

	КонецЕсли;
	
	Состояние("Прогресс",75);
	
	Если ТаблицаОрганизаций.Количество() = 0 Тогда
		Элементы.Удалить.Доступность = Ложь;
		Элементы.Доступы.Доступность = Ложь;
	Иначе
		Для Каждого СтрокаДоступа ИЗ ТаблицаОрганизаций Цикл
			МассивСтрок = Организации.НайтиСтроки(Новый Структура("ИНН", СтрокаДоступа.OrganizationINN));
			Если МассивСтрок.Количество() = 0 Тогда
				НоваяСтрока = Организации.Добавить();
				Новаястрока.ИДОрганизации	= СтрокаДоступа.AccountOrganizationID;
				Новаястрока.Наименование	= СтрокаДоступа.OrganizationName;
				НоваяСтрока.ИНН				= СтрокаДоступа.OrganizationINN;
				НоваяСтрока.КПП				= СтрокаДоступа.OrganizationKPP;
				НоваяСтрока.Аккаунт			= СтрокаДоступа.OrganizationAccountCaption;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Организации.Сортировать("Наименование возр");

	Элементы.ИНН.ТолькоПросмотр = Истина;
	Элементы.КПП.ТолькоПросмотр = Истина;
	Элементы.ОрганизацииАккаунт.ТолькоПросмотр = Истина;
	
	Состояние("Прогресс",100);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнениеСпискаПользователейАккаунта()
	
	Элементы.ДобавитьДоступ.СписокВыбора.Очистить();
	
	СтрокаЗапроса = "/api_v2/AccountUsers/GetIDs?accountID=" + ВладелецФормы.ESDLИДАккаунта;
	ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLCoreHTTP", СтрокаЗапроса);	
	Если ПараметрыОтвета.КодОтвета = 200 Тогда
		СписокИДПользователей = ПараметрыОтвета.СтруктураОтвета.AccountUserIDs;
		Для Каждого ПользовательИД ИЗ СписокИДПользователей Цикл
			
			СтрокаЗапроса = "/api_v2/AccountUsers/GetProperties?accountUserID=" + ПользовательИД;
			ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLCoreHTTP", СтрокаЗапроса);                   
			Если ПараметрыОтвета.КодОтвета = 200 Тогда
				FirstName = ПараметрыОтвета.СтруктураОтвета.FirstName;
				LastName = ПараметрыОтвета.СтруктураОтвета.LastName;
				MiddleName = ПараметрыОтвета.СтруктураОтвета.MiddleName;
				ИмяПользователя = LastName + " " + FirstName + " "+ MiddleName;
				ИмяПользователя = ?(ЗначениеЗаполнено(ИмяПользователя), ИмяПользователя, ПараметрыОтвета.СтруктураОтвета.Login);
				Элементы.ДобавитьДоступ.СписокВыбора.Добавить(ПользовательИД, СокрЛП(ИмяПользователя));
				
				Если ПользовательИД = ВладелецФормы.ESDLИДПользователя Тогда
					ПользовательМенеджер = ПараметрыОтвета.СтруктураОтвета.IsManager = "true";
				КонецЕсли;
				
			Иначе
				СообщениеПользователю = Новый СообщениеПользователю;
				СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
				СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
				СообщениеПользователю.Сообщить()

			КонецЕсли;
			
		КонецЦикла;
	
		Элементы.ДобавитьДоступ.СписокВыбора.СортироватьПоПредставлению(НаправлениеСортировки.Возр);

	Иначе
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Ошибка при получении списка пользователей аккаунта: " + ПараметрыОтвета.СтруктураОтвета.Description;
		СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		СообщениеПользователю.Сообщить()

	КонецЕсли;
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацииПриАктивизацииЯчейки(Элемент)
	
	Если НЕ Организации.Количество() = 0	Тогда
		Состояние("Прогресс",25);
		Элементы.ПользователиАккаунта.Доступность	= Истина;
		Элементы.Наименование.ТолькоПросмотр		= Ложь;
		Элементы.Удалить.Доступность				= Истина;
		
		Состояние("Прогресс",50);
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			ИдОрганизации = Элемент.ТекущиеДанные.ИдОрганизации;		
			ДобавитьОрганизациюПоиск = "";
			ДобавитьИННПоиск = "";
			ДобавитьКПППоиск = "";
			ДобавитьДоступ = "";
			Если Организации.Количество() > 0 И НЕ Элемент.ТекущиеДанные = Неопределено Тогда
				
				ИмяОрганизации = Элемент.ТекущиеДанные.Наименование;
				Элементы.ДоступыКОрганизации.Заголовок = "Доступ к организации "+""""+ ИмяОрганизации+"""";
				ЗаполнениеТаблицыПользователей(ИДОрганизации);
				
			КонецЕсли;
		КонецЕсли;
		Состояние("Прогресс",75);
		Элементы.УдалитьДоступ.Доступность = (НЕ ТаблицаДоступов.Количество() = 0);
		Состояние("Прогресс",100);
	Иначе
		Элементы.ПользователиАккаунта.Доступность	= Ложь;
		Элементы.Наименование.ТолькоПросмотр		= Истина;
		Элементы.Удалить.Доступность				= Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ЗаполнениеТаблицыПользователей(ИДОрганизации)Экспорт
	
	Элементы.УдалитьДоступ.Доступность = (НЕ ТаблицаДоступов.Количество() = 1);
	ТаблицаДоступов.Сортировать("Пользователь возр");
	
	ТаблицаДоступов.Очистить();
	
	СтрокаЗапроса = "/adl42/hs/api_v1/AccOrgAccess/GetTableByAccountOrganizationID?AccountOrganizationID=" + ИДОрганизации;
	ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLADLHTTP", СтрокаЗапроса);          	
	Если ПараметрыОтвета.КодОтвета = 200 Тогда
		ТаблицаВсеДоступы = ПараметрыОтвета.СтруктураОтвета.TableAccOrgAccess;  
	Иначе
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
		СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		СообщениеПользователю.Сообщить()

	КонецЕсли;
	
	Если НЕ ТаблицаВсеДоступы = Неопределено Тогда
			
		Для Каждого СтрокаДоступа ИЗ ТаблицаВсеДоступы Цикл
			Если НЕ СтрокаДоступа.UserFullName="" Тогда
				Если Элементы.Организации.ТекущиеДанные.Аккаунт = ИмяАккаунта тогда
					НоваяСтрока = ТаблицаДоступов.Добавить();
					НоваяСтрока.Пользователь = СтрокаДоступа.UserFullName; 
					НоваяСтрока.Аккаунт=СтрокаДоступа.CaptionOfUserAccount;
					НоваяСтрока.ИдПользователя =СтрокаДоступа.UserID; 
					НоваяСтрока.ИдДоступа = СтрокаДоступа.AccOrgAccesID;
					НоваяСтрока.Email = СтрокаДоступа.UserEmail;
				ИначеЕсли СтрокаДоступа.CaptionOfUserAccount = ИмяАккаунта тогда
					НоваяСтрока = ТаблицаДоступов.Добавить();
					НоваяСтрока.Пользователь = СтрокаДоступа.UserFullName; 
					НоваяСтрока.Аккаунт=СтрокаДоступа.CaptionOfUserAccount;
					НоваяСтрока.ИдПользователя = СтрокаДоступа.UserID; 
					НоваяСтрока.ИдДоступа = СтрокаДоступа.AccOrgAccesID;
					НоваяСтрока.Email = СтрокаДоступа.UserEmail;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		ТаблицаДоступов.Сортировать("Пользователь возр");
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура ДобавитьОрганизацию(Команда) 
	
	Организация = Элементы.ДобавитьОрганизациюПоиск.ТекстРедактирования;
	ИНН = Элементы.ДобавитьИННПоиск.ТекстРедактирования;
	КПП = Элементы.ДобавитьКПППоиск.ТекстРедактирования;
	
	Если  Организация = "" Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Введите наименование организации.";
		СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		СообщениеПользователю.Сообщить();
		
		Возврат;
	ИначеЕсли ИНН = "" Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Введите ИНН организации.";
		СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		СообщениеПользователю.Сообщить();

		Возврат;
	КонецЕсли;
	
	Если ВладелецФормы.ВерныйИНН(ИНН) Тогда
		                                                                                                                                  
		СтруктураНаименований = ВладелецФормы.ОбработкаНаименованияЭлемента(ВладелецФормы.ESDLСтруктураОПФ, Организация);
		
		СтруктураПараметров = Новый Структура("OrganizationName, OrganizationINN, OrganizationKPP", СтруктураНаименований.ПолноеНаименование, ИНН, КПП);
		СтрокаЗапроса = "/adl42/hs/api_v1/AccountOrganizations/Add";
		ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLADLHTTP", СтрокаЗапроса, "Post", СтруктураПараметров);
		Если ПараметрыОтвета.КодОтвета = 200 Тогда
			ОргИД = ПараметрыОтвета.СтруктураОтвета.AccountOrganizationID;
			
			НоваяСтрока = Организации.Добавить();
			Новаястрока.Наименование = СтруктураНаименований.ПолноеНаименование;
			НоваяСтрока.ИНН = ИНН;
			НоваяСтрока.КПП = КПП;
			НоваяСтрока.ИДОрганизации = ОргИд;
			НоваяСтрока.Аккаунт=ИмяАккаунта;
			Элементы.Организации.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
			Элементы.Организации.ЗакончитьРедактированиеСтроки(Истина);
			Элементы.Доступы.Доступность			= Истина;
		Иначе
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
			СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
			СообщениеПользователю.Сообщить()
		КонецЕсли;
	Иначе
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
		СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		СообщениеПользователю.Сообщить()
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацииПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Элемент.ТекущиеДанные.ИДОрганизации = "" ИЛИ  Элемент.ТекущиеДанные.ИНН = "" Тогда
		Элементы.ИНН.ТолькоПросмотр = Ложь;
		Элементы.КПП.ТолькоПросмотр = Ложь;
		Если Элемент.ТекущиеДанные.Наименование = "" Тогда
			Элементы.Наименование.РежимРедактирования = РежимРедактированияКолонки.Непосредственно;
		КонецЕсли;
	Иначе
		Элементы.ИНН.ТолькоПросмотр = Истина;
		Элементы.КПП.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацииПриИзменении(Элемент)
	
	Перем ТекстВопроса;
	
	Если Элемент.ТекущиеДанные.ИДОрганизации = "" Тогда
		Если НЕ (Элемент.ТекущиеДанные.Наименование = "" ИЛИ Элемент.ТекущиеДанные.Инн = "") Тогда
			ТекстВопроса = "Добавить организацию?";
			ЗаголовокОкнаВопроса = "Добавление организации";
			ДопПараметры = Элемент.ТекущаяСтрока;
		КонецЕсли;
	Иначе 
		ТекстВопроса = "Сохранить измененное наименование?";
		ЗаголовокОкнаВопроса = "Сохранение изменений";
		ДопПараметры = Элемент.ТекущаяСтрока;
	КонецЕсли;
	
	Если ТекстВопроса <> Неопределено Тогда	
		#Если ТолстыйКлиентОбычноеПриложение Тогда	
			Результат = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, ЗаголовокОкнаВопроса);
			ДобавитьИзменитьОрганизациюОтветНаВопрос(Результат, ДопПараметры);
		#Иначе
			Оповещение = Новый ОписаниеОповещения("ДобавитьИзменитьОрганизациюОтветНаВопрос", ЭтаФорма, ДопПараметры);
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, ЗаголовокОкнаВопроса);
		#КонецЕсли
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацииПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НЕ Элемент.ТекущиеДанные.ИДОрганизации = "" И Элемент.ТекущиеДанные.Наименование = ""  Тогда
			ОтменаРедактирования = Истина;
		КонецЕсли;	

КонецПроцедуры
	
&НаКлиенте
Процедура ДобавитьИзменитьОрганизациюОтветНаВопрос(Результат, ИдентификаторСтроки)Экспорт 
	
	СтрокаОрганизации = Организации.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если Результат = КодВозвратаДиалога.Да Тогда 	
		Если СтрокаОрганизации.ИДОрганизации = "" Тогда
			//Добавить организацию	
			СтруктураПараметров = Новый Структура("OrganizationName, OrganizationINN, OrganizationKPP", СтрокаОрганизации.Наименование, СтрокаОрганизации.ИНН, СтрокаОрганизации.КПП);
			СтрокаЗапроса = "/adl42/hs/api_v1/AccountOrganizations/Add";
			ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLADLHTTP", СтрокаЗапроса, "Post", СтруктураПараметров);
			Если ПараметрыОтвета.КодОтвета = 200 Тогда
				ИДОрганизации = ПараметрыОтвета.СтруктураОтвета.AccountOrganizationID;
				СтрокаОрганизации.ИДорганизации = ИДОрганизации;
				АктивнаяСтрокаИдОрганизации=Неопределено;
				ОрганизацииПриАктивизацииЯчейки(Элементы.Организации);
			Иначе
				СообщениеПользователю = Новый СообщениеПользователю;
				СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
				СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
				СообщениеПользователю.Сообщить()
			КонецЕсли;
	
		Иначе
			//Установить свойства					
			СтруктураПараметров = Новый Структура(" AccountOrganizationID, OrganizationName", СтрокаОрганизации.ИДОрганизации, СтрокаОрганизации.Наименование);
			СтрокаЗапроса = "/adl42/hs/api_v1/AccountOrganizations/SetAccountOrganizationProperties";
			ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLADLHTTP", СтрокаЗапроса, "Post", СтруктураПараметров);          
			Если ПараметрыОтвета.КодОтвета = 200 Тогда
				УстановитьСвойства = Истина;
				
				СтрокаЗапроса = "/adl42/hs/api_v1/AccountOrganizations/GetAccountOrganizationProperties?AccountOrganizationID=" + СтрокаОрганизации.ИДОрганизации;
				ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLADLHTTP", СтрокаЗапроса);
				Если ПараметрыОтвета.КодОтвета = 200 Тогда
					СвойстваОрганизации = ПараметрыОтвета.СтруктураОтвета;  
				Иначе
					СообщениеПользователю = Новый СообщениеПользователю;
					СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
					СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
					СообщениеПользователю.Сообщить()
					
				КонецЕсли;	
			Иначе
				СообщениеПользователю = Новый СообщениеПользователю;
				СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
				СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
				СообщениеПользователю.Сообщить()

			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацииПередУдалением(Элемент, Отказ)
	
	УдалитьОрганизацию(Неопределено);	
	Отказ = Истина;

КонецПроцедуры

&НаКлиенте
Процедура УдалитьОрганизацию(Команда)
	
	Если Элементы.Организации.ТекущиеДанные.ИДОрганизации = "" Тогда	
		Организации.Удалить(Элементы.Организации.ТекущиеДанные);
	Иначе
		ТекстВопроса = "Удалить организацию?";
		ЗаголовокОкнаВопроса = "Удаление организации";
		ДопПараметры = Элементы.Организации.ТекущаяСтрока;
		Если ТекстВопроса <> Неопределено Тогда	
			#Если ТолстыйКлиентОбычноеПриложение Тогда	
				Результат = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, ЗаголовокОкнаВопроса);
				УдалитьОрганизациюОтветНаВопрос(Результат, ДопПараметры);
			#Иначе
				Оповещение = Новый ОписаниеОповещения("УдалитьОрганизациюОтветНаВопрос", ЭтаФорма, ДопПараметры);
				ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, ЗаголовокОкнаВопроса);
			#КонецЕсли
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьОрганизациюОтветНаВопрос(Результат, ИдентификаторСтроки) Экспорт 
	
	СтрокаОрганизации = Организации.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если Результат = КодВозвратаДиалога.Да Тогда 	
		СтруктураПараметров = Новый Структура("AccountOrganizationID", СтрокаОрганизации.ИДОрганизации);
		СтрокаЗапроса = "/adl42/hs/api_v1/AccountOrganizations/Delete";
		ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLADLHTTP", СтрокаЗапроса, "Post", СтруктураПараметров);
		Если ПараметрыОтвета.КодОтвета = 200 Тогда
			Организации.Удалить(СтрокаОрганизации);
			ТаблицаДоступов.Очистить();
			Элементы.Доступы.Доступность			= Ложь;
			
		Иначе
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
			СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
			СообщениеПользователю.Сообщить()

		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДоступ(Команда)
	
	ИДпользователя = ДобавитьДоступ;
	Если НЕ ПустаяСтрока(ИДпользователя) Тогда
		Если ТаблицаДоступов.НайтиСтроки(Новый Структура("ИдПользователя", ИДпользователя)).Количество() = 0 Тогда
			ИДОрганизации = Элементы.Организации.ТекущиеДанные.ИдОрганизации;
			
			СтруктураПараметров = Новый Структура("AccountOrganizationID, UserID", ИДОрганизации, ИДПользователя);
			СтрокаЗапроса = "/adl42/hs/api_v1/AccOrgAccess/Add";	
			ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLADLHTTP", СтрокаЗапроса, "Post", СтруктураПараметров);
			Если ПараметрыОтвета.КодОтвета = 200 Тогда
				Доступ = ПараметрыОтвета.СтруктураОтвета.AccOrgAccesID;
				
				НоваяСтрока = ТаблицаДоступов.Добавить();
				НоваяСтрока.Пользователь = Элементы.ДобавитьДоступ.СписокВыбора.НайтиПоЗначению(ИДпользователя).Представление;
				НоваяСтрока.ИдПользователя = ИДПользователя; 
				НоваяСтрока.ИдДоступа = Доступ;
				НоваяСтрока.Аккаунт=ИмяАккаунта;
				
				СтрокаПараметры = "AccountUsers/GetEmail?accountUserID=" + ИДпользователя;
				СтрокаЗапроса = "/api_v2/" + СтрокаПараметры;
				ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLCoreHTTP", СтрокаЗапроса);                   
				Если ПараметрыОтвета.КодОтвета = 200 Тогда
					EMail = ПараметрыОтвета.СтруктураОтвета.Email;
					НоваяСтрока.EMail=EMail;
					ДобавитьДоступ = "";
				Иначе
					СообщениеПользователю = Новый СообщениеПользователю;
					СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
					СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
					СообщениеПользователю.Сообщить()
					
				КонецЕсли;
			Иначе
				СообщениеПользователю = Новый СообщениеПользователю;
				СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
				СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
				СообщениеПользователю.Сообщить()

			КонецЕсли;
		Иначе
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = "Пользователь " + Элементы.ДобавитьДоступ.СписокВыбора.НайтиПоЗначению(ИДпользователя).Представление + " уже имеет доступ к огранизации";
			СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
			СообщениеПользователю.Сообщить();
			ДобавитьДоступ = "";
		КонецЕсли;
		Элементы.УдалитьДоступ.Доступность = (НЕ ТаблицаДоступов.Количество() = 0);
	Иначе
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Не выбран пользователь аккаунта для которого нужно предоставить доступ!";
		СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		СообщениеПользователю.Сообщить()

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьДоступ(Команда)
	
	СтрокаДоступа = Элементы.ТаблицаДоступов.ТекущиеДанные;

	СтруктураПараметров = Новый Структура("AccOrgAccesID", СтрокаДоступа.ИдДоступа);
	СтрокаЗапроса = "/adl42/hs/api_v1/AccOrgAccess/Delete";	
	ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLADLHTTP", СтрокаЗапроса, "Post", СтруктураПараметров);
	Если ПараметрыОтвета.КодОтвета = 200 Тогда
		ТаблицаДоступов.Удалить(СтрокаДоступа);
	Иначе
		
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
		СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		СообщениеПользователю.Сообщить()

	КонецЕсли;
	
	Элементы.УдалитьДоступ.Доступность = (НЕ ТаблицаДоступов.Количество() = 0);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДоступДляЧужихПользователей(Команда)
	
	Если Не ПустаяСтрока(ДобавитьДоступВнешнихАккаунтов) Тогда
		
		ТекстПоиска = Элементы.ДобавитьДоступВнешнихАккаунтов.ТекстРедактирования;
		Если Найти(ТекстПоиска, "@") > 0 Тогда
			СтрокаПараметры = "AccountUsers/GetIDByEmail?email=" + СокрЛП(ТекстПоиска);
			СтрокаЗапроса = "/api_v2/" + СтрокаПараметры;
			ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLCoreHTTP", СтрокаЗапроса);                   
			Если ПараметрыОтвета.КодОтвета = 200 Тогда
				ИДПользователя = ПараметрыОтвета.СтруктураОтвета.AccountUserID;
				ДобавитьДоступВнешнихАккаунтов = "";
				
				СтруктураПараметров = Новый Структура("AccountOrganizationID, UserID", Элементы.Организации.ТекущиеДанные.ИдОрганизации, ИДПользователя);
				СтрокаЗапроса = "/adl42/hs/api_v1/AccOrgAccess/Add";
				ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLADLHTTP", СтрокаЗапроса, "Post", СтруктураПараметров);
				Если ПараметрыОтвета.КодОтвета = 200 Тогда
					ИДДоступа = ПараметрыОтвета.СтруктураОтвета.AccOrgAccesID; 
					
					СтрокаЗапроса = "/adl42/hs/api_v1/AccOrgAccess/GetAccOrgAccesProperties?AccOrgAccesID=" + ИДДоступа;
					ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLADLHTTP", СтрокаЗапроса);
					Если ПараметрыОтвета.КодОтвета = 200 Тогда
						СвойстваДоступа = ПараметрыОтвета.СтруктураОтвета;			
						НоваяСтрока = ТаблицаДоступов.Добавить();
						НоваяСтрока.Пользователь = СвойстваДоступа.UserFullName; 
						НоваяСтрока.ИдПользователя = ИДПользователя; 
						НоваяСтрока.ИдДоступа = ИДДоступа;
						НоваяСтрока.Аккаунт=СвойстваДоступа.AccountCaption;
						НоваяСтрока.Email=СокрЛП(ТекстПоиска);  
					Иначе
						
						СообщениеПользователю = Новый СообщениеПользователю;
						СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
						СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
						СообщениеПользователю.Сообщить();

					КонецЕсли;
				Иначе
					
					СообщениеПользователю = Новый СообщениеПользователю;
					СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
					СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
					СообщениеПользователю.Сообщить();

				КонецЕсли;
			ИначеЕсли ТекстПоиска = "" Тогда
			Отказ = Ложь;
			Возврат;
			Иначе
				
				СообщениеПользователю = Новый СообщениеПользователю;
				СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
				СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
				СообщениеПользователю.Сообщить();

			КонецЕсли;
		Элементы.УдалитьДоступ.Доступность = (НЕ ТаблицаДоступов.Количество() = 0);
	Иначе
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Не указан e-mail пользователя внешнего аккаунта для которого нужно предоставить доступ!";
		СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		СообщениеПользователю.Сообщить()

	КонецЕсли;
	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЭкспортОрг(Команда)
	
	ОрганизацииЗапрос = ВладелецФормы.ПолучитьОрганизации();	
	
	Для Каждого ЭлементМассива из ОрганизацииЗапрос Цикл		
		СтруктураПараметров = Новый Структура("OrganizationName, OrganizationINN, OrganizationKPP", ЭлементМассива.Наименование, ЭлементМассива.ИНН, ЭлементМассива.КПП);
		СтрокаЗапроса = "/adl42/hs/api_v1/AccountOrganizations/Add";
		ПараметрыОтвета = ВладелецФормы.ВыполнитьЗапрос("ESDLADLHTTP", СтрокаЗапроса, "Post", СтруктураПараметров);
		Если ПараметрыОтвета.КодОтвета = 200 Тогда
			НоваяСтрока = Организации.Добавить();
			Новаястрока.ИДОрганизации	= ПараметрыОтвета.СтруктураОтвета.AccountOrganizationID;
			Новаястрока.Наименование	= ЭлементМассива.Наименование;
			НоваяСтрока.ИНН				= ЭлементМассива.ИНН;
			НоваяСтрока.КПП				= ЭлементМассива.КПП;
			НоваяСтрока.Аккаунт			= ИмяАккаунта;
		Иначе
			
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = ПараметрыОтвета.СтруктураОтвета.Description;
			СообщениеПользователю.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
			СообщениеПользователю.Сообщить()

		КонецЕсли;  
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ВладелецФормы.ЗаполнитьСписокОрганизаций();
	
КонецПроцедуры



// Процедура - обработчик события формы "ОбработкаОповещения"
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "УпрОсновнаяФормаБудетЗакрыта"  И ЭтаФорма.Открыта() Тогда
		
		ЭтаФорма.Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры
