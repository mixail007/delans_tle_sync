////////////////////////////////////////////////////////////////////////////////
// Подсистема "Криптография".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает список криптопровайдеров, поддерживаемых 1С-Отчетностью.
//
// Параметры:
//  Алгоритм            - Строка       - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512",
//                                       при значении "" или Неопределено возвращаются описания для всех алгоритмов.
//  ЭтоLinux            - Булево.
//                        Неопределено - возвращать описания для каждой операционной системы.
//  ТипКриптопровайдера - Перечисления.ТипыКриптоПровайдеров, Строка.
//                        Неопределено - возвращать все типы.
//  Путь                - Строка       - путь модуля криптографии в nix-системах.
//
// Возвращаемое значение:
//  ФиксированныйМассив - массив с описаниями криптопровайдеров.
//    * Имя                 - Строка - имя криптопровайдера.
//    * Тип                 - Число  - тип криптопровайдера.
//    * Путь                - Строка - путь к модулю криптопровайдера в nix-системах.
//    * Представление       - Строка - представление типа криптопровайдера для отображения в интерфейсе.
//    * ТипКриптопровайдера - Перечисления.ТипыКриптоПровайдеров.
//    * Алгоритм            - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//    * Поддерживается      - Булево - Истина.
//
Функция ПоддерживаемыеКриптопровайдеры(
		Алгоритм = "",
		ЭтоLinux = Неопределено,
		ТипКриптопровайдера = Неопределено,
		Путь = "") Экспорт
	
	Возврат ИзвестныеКриптопровайдеры(Истина, Алгоритм, ЭтоLinux, ТипКриптопровайдера, Путь);
	
КонецФункции

// Возвращает свойства криптопровайдера, поддерживаемого 1С-Отчетностью, или криптопровайдера из массива.
//
// Параметры:
//  Имя                            - Строка - имя криптопровайдера.
//  Тип                            - Число  - тип криптопровайдера.
//  ПоддерживаемыеКриптопровайдеры - Неопределено - получить вызовом ПоддерживаемыеКриптопровайдеры().
//                                   ФиксированныйМассив - массив с описаниями криптопровайдеров.
//    * Имя                 - Строка - имя криптопровайдера.
//    * Тип                 - Число  - тип криптопровайдера.
//    * Путь                - Строка - путь к модулю криптопровайдера в nix-системах.
//    * Представление       - Строка - представление типа криптопровайдера для отображения в интерфейсе.
//    * ТипКриптопровайдера - Перечисления.ТипыКриптоПровайдеров, Строка.
//    * Алгоритм            - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//    * Поддерживается      - Булево - флаг поддержки криптопровайдера 1С-Отчетностью.
//  ИндексКриптопровайдеров        - Массив - имя, имя и тип или тип криптопровайдера, для ускорения поиска,
//                                            заполняется при первом и втором вызове автоматически,
//                                            при изменении заполненности параметров Имя, Тип
//                                            передать с Неопределено для перезаполнения.
//
// Возвращаемое значение:
//  Структура    - описание криптопровайдера:
//    * Имя                 - Строка - имя криптопровайдера.
//    * Тип                 - Число  - тип криптопровайдера.
//    * Путь                - Строка - путь к модулю криптопровайдера в nix-системах.
//    * Представление       - Строка - представление типа криптопровайдера для отображения в интерфейсе.
//    * ТипКриптопровайдера - Перечисления.ТипыКриптоПровайдеров, Строка.
//    * Алгоритм            - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//    * Поддерживается      - Булево - флаг поддержки криптопровайдера 1С-Отчетностью.
//  Неопределено - криптопровайдер не найден.
//
Функция СвойстваКриптопровайдера(
		Имя = Неопределено,
		Тип = Неопределено,
		ПоддерживаемыеКриптопровайдеры = Неопределено,
		ИндексКриптопровайдеров = Неопределено) Экспорт
	
	Криптопровайдеры = ПоддерживаемыеКриптопровайдеры;
	Если Криптопровайдеры = Неопределено Тогда
		Криптопровайдеры = ПоддерживаемыеКриптопровайдеры();
	КонецЕсли;
	
	Если ИндексКриптопровайдеров = Неопределено ИЛИ НЕ ЗначениеЗаполнено(Тип) И НЕ ЗначениеЗаполнено(Имя) Тогда
		Если ЗначениеЗаполнено(Тип) ИЛИ ЗначениеЗаполнено(Имя) Тогда
			ИндексКриптопровайдеров = Новый Массив;
		КонецЕсли;
		Для каждого Криптопровайдер Из Криптопровайдеры Цикл
			Если ЗначениеЗаполнено(Тип) ИЛИ ЗначениеЗаполнено(Имя) Тогда
				ТипИмя = ?(ЗначениеЗаполнено(Тип), Строка(Криптопровайдер.Тип) + ";", "")
					+ ?(ЗначениеЗаполнено(Имя), Строка(Криптопровайдер.Имя) + ";", "");
				ИндексКриптопровайдеров.Добавить(ТипИмя);
			КонецЕсли;
			
			Если (НЕ ЗначениеЗаполнено(Тип) ИЛИ Строка(Криптопровайдер.Тип) = Строка(Тип))
				И (НЕ ЗначениеЗаполнено(Имя) ИЛИ Криптопровайдер.Имя = Имя) Тогда
				
				Возврат Криптопровайдер;
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		Для ИндексЭлемента = ИндексКриптопровайдеров.Количество() По Криптопровайдеры.Количество() - 1 Цикл
			Криптопровайдер = Криптопровайдеры[ИндексЭлемента];
			ТипИмя = ?(ЗначениеЗаполнено(Тип), Строка(Криптопровайдер.Тип) + ";", "")
				+ ?(ЗначениеЗаполнено(Имя), Строка(Криптопровайдер.Имя) + ";", "");
			ИндексКриптопровайдеров.Добавить(ТипИмя);
		КонецЦикла;
		
		ТипИмя = ?(ЗначениеЗаполнено(Тип), Строка(Тип) + ";", "") + ?(ЗначениеЗаполнено(Имя), Строка(Имя) + ";", "");
		ИндексЭлемента = ИндексКриптопровайдеров.Найти(ТипИмя);
		Если ИндексЭлемента <> Неопределено Тогда
			Возврат Криптопровайдеры[ИндексЭлемента];
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает основной используемый отечественный криптографический алгоритм.
//
Функция АлгоритмПоУмолчанию() Экспорт
	
	Возврат "GOST R 34.10-2012-256";
	
КонецФункции

// Возвращает свойства криптопровайдера с алгоритмом по умолчанию или заданным.
//
// Параметры:
//  ТипКриптопровайдера - Перечисления.ТипыКриптоПровайдеров.
//  Алгоритм            - Строка.
//  Путь                - Строка - путь модуля криптографии в nix-системах.
//
// Возвращаемое значение:
//  Структура    - описание криптопровайдера:
//    * Имя                 - Строка - имя криптопровайдера.
//    * Тип                 - Число  - тип криптопровайдера.
//    * Путь                - Строка - путь к модулю криптопровайдера в nix-системах.
//    * Представление       - Строка - представление типа криптопровайдера для отображения в интерфейсе.
//    * ТипКриптопровайдера - Перечисления.ТипыКриптоПровайдеров.
//    * Алгоритм            - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//    * Поддерживается      - Булево - флаг поддержки криптопровайдера 1С-Отчетностью.
//
Функция СвойстваКриптопровайдераПоУмолчанию(ТипКриптопровайдера, Алгоритм = Неопределено, Путь = Неопределено) Экспорт
	
	МассивСвойствКриптопровайдеров = Неопределено;
	Если ЗначениеЗаполнено(ТипКриптопровайдера) Тогда
		АлгоритмКриптопровайдера = ?(Алгоритм = Неопределено, АлгоритмПоУмолчанию(), Алгоритм);
		ЭтоLinux = ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент();
		МассивСвойствКриптопровайдеров = ПоддерживаемыеКриптопровайдеры(
			АлгоритмКриптопровайдера,
			ЭтоLinux,
			ТипКриптопровайдера,
			Путь);
	КонецЕсли;
	
	Если МассивСвойствКриптопровайдеров <> Неопределено И МассивСвойствКриптопровайдеров.Количество() >= 1 Тогда
		СвойстваКриптопровайдера = МассивСвойствКриптопровайдеров[0];
	Иначе
		СвойстваКриптопровайдера = Новый Структура;
		СвойстваКриптопровайдера.Вставить("Имя", 					"");
		СвойстваКриптопровайдера.Вставить("Тип", 					0);
		СвойстваКриптопровайдера.Вставить("Путь", 					"");
		СвойстваКриптопровайдера.Вставить("Представление", 			"");
		СвойстваКриптопровайдера.Вставить("ТипКриптопровайдера", 	ПредопределенноеЗначение("Перечисление.ТипыКриптоПровайдеров.ПустаяСсылка"));
		СвойстваКриптопровайдера.Вставить("Алгоритм", 				"");
		СвойстваКриптопровайдера.Вставить("Поддерживается", 		Ложь);
	КонецЕсли;
	
	Возврат СвойстваКриптопровайдера;
	
КонецФункции

// Возвращает список всех известных криптопровайдеров, поддерживающих отечественные алгоритмы.
//
// Параметры:
//  Поддерживается      - Булево       - поддерживается 1С-Отчетностью.
//                        Неопределено - возврат и поддерживаемых, и неподдерживаемых.
//  Алгоритм            - Строка       - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512",
//                                       при значении "" или Неопределено возвращаются описания для всех алгоритмов.
//  ЭтоLinux            - Булево.
//                        Неопределено - возвращать описания для каждой операционной системы.
//  ТипКриптопровайдера - Перечисления.ТипыКриптоПровайдеров, Строка.
//                        Неопределено - возвращать все типы.
//  Путь                - Строка       - путь модуля криптографии в nix-системах.
//
// Возвращаемое значение:
//  ФиксированныйМассив - массив с описаниями криптопровайдеров.
//    * Имя                 - Строка - имя криптопровайдера.
//    * Тип                 - Число  - тип криптопровайдера.
//    * Путь                - Строка - путь к модулю криптопровайдера в nix-системах.
//    * Представление       - Строка - представление типа криптопровайдера для отображения в интерфейсе.
//    * ТипКриптопровайдера - Перечисления.ТипыКриптоПровайдеров, Строка.
//    * Алгоритм            - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//    * Поддерживается      - Булево - флаг поддержки криптопровайдера 1С-Отчетностью.
//
Функция ИзвестныеКриптопровайдеры(
		Поддерживается = Неопределено,
		Алгоритм = "",
		ЭтоLinux = Неопределено,
		ТипКриптопровайдера = Неопределено,
		Путь = "") Экспорт
	
	СписокКриптопровайдеров = Новый Массив;
	
	НачальныйИндексТипаКриптопровайдера = 1;
	КонечныйИндексТипаКриптопровайдера 	= 4;
	
	Если ЗначениеЗаполнено(ТипКриптопровайдера) Тогда
		ИндексЗаданногоТипаКриптопровайдера = 0;
		Если ТипКриптопровайдера = ПредопределенноеЗначение("Перечисление.ТипыКриптоПровайдеров.CryptoPro")
			ИЛИ ТипКриптопровайдера = "CryptoPro" Тогда
			ИндексЗаданногоТипаКриптопровайдера = 1;
		ИначеЕсли ТипКриптопровайдера = ПредопределенноеЗначение("Перечисление.ТипыКриптоПровайдеров.VipNet")
			ИЛИ ТипКриптопровайдера = "VipNet" Тогда
			ИндексЗаданногоТипаКриптопровайдера = 2;
		ИначеЕсли ТипКриптопровайдера = "SignalCOM" Тогда
			ИндексЗаданногоТипаКриптопровайдера = 3;
		ИначеЕсли ТипКриптопровайдера = "LISSI" Тогда
			ИндексЗаданногоТипаКриптопровайдера = 4;
		КонецЕсли;
		НачальныйИндексТипаКриптопровайдера = ИндексЗаданногоТипаКриптопровайдера;
		КонечныйИндексТипаКриптопровайдера 	= ИндексЗаданногоТипаКриптопровайдера;
	КонецЕсли;
	
	Для ИндексТипаКриптопровайдера = НачальныйИндексТипаКриптопровайдера По КонечныйИндексТипаКриптопровайдера Цикл
		МассивСвойств = Неопределено;
		
		Если ИндексТипаКриптопровайдера = 1 И Поддерживается <> Ложь Тогда
			МассивСвойств = КриптопровайдерCryptoPro(Алгоритм, ЭтоLinux, 0);
			
		ИначеЕсли ИндексТипаКриптопровайдера = 2 И Поддерживается <> Ложь И ЭтоLinux <> Истина Тогда
			МассивСвойств = КриптопровайдерViPNet(Алгоритм);
			
		ИначеЕсли ИндексТипаКриптопровайдера = 3 И Поддерживается <> Истина И ЭтоLinux <> Истина Тогда
			МассивСвойств = КриптопровайдерSignalCOM(Алгоритм);
			
		ИначеЕсли ИндексТипаКриптопровайдера = 4 И Поддерживается <> Истина И ЭтоLinux <> Истина Тогда
			МассивСвойств = КриптопровайдерЛИССИ(Алгоритм);
		КонецЕсли;
		
		Если МассивСвойств <> Неопределено Тогда
			Если ТипЗнч(МассивСвойств) <> Тип("Массив") И ТипЗнч(МассивСвойств) <> Тип("ФиксированныйМассив") Тогда
				МассивСвойств = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(МассивСвойств);
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СписокКриптопровайдеров, МассивСвойств);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(СписокКриптопровайдеров);
	
КонецФункции

// Возвращает описание криптопровайдера CryptoPro CSP.
//
// Параметры:
//  Алгоритм    - Строка       - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512",
//                               при значении "" или Неопределено возвращается массив свойств криптопровайдеров всех алгоритмов
//                               и классов защиты.
//  ЭтоLinux    - Булево.
//              - Неопределено - при пустых значениях Алгоритм или КлассЗащиты возвращаются массив свойств криптопровайдеров
//                               для каждой операционной системы, иначе возвращаются свойства криптопровайдера для текущей.
//  КлассЗащиты - Число        - 1, 2 или 3,
//                               при значении 0 или Неопределено возвращается массив свойств криптопровайдеров всех классов защиты.
//  Путь        - Строка       - путь модуля криптографии в nix-системах.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура или ФиксированныйМассив из ФиксированнаяСтруктура (при Алгоритм = Неопределено) - описание криптопровайдера.
//    * Имя                 - Строка - имя криптопровайдера.
//    * Тип                 - Число  - тип криптопровайдера.
//    * Путь                - Строка - путь к модулю криптопровайдера в nix-системах.
//    * Представление       - Строка - представление типа криптопровайдера для отображения в интерфейсе.
//    * ТипКриптопровайдера - Перечисления.ТипыКриптоПровайдеров.CryptoPro.
//    * Алгоритм            - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//    * Поддерживается      - Булево - Истина.
//
Функция КриптопровайдерCryptoPro(
		Алгоритм = "GOST R 34.10-2012-256",
		ЭтоLinux = Неопределено,
		КлассЗащиты = 1,
		Путь = "") Экспорт
	
	Если НЕ ЗначениеЗаполнено(Алгоритм) ИЛИ НЕ ЗначениеЗаполнено(КлассЗащиты) Тогда
		МассивСвойств = Новый Массив;
		
		Если ЗначениеЗаполнено(Алгоритм) Тогда
			МассивАлгоритмов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Алгоритм);
		Иначе
			МассивАлгоритмов = ПоддерживаемыеАлгоритмы();
		КонецЕсли;
		
		Если ЭтоLinux = Неопределено Тогда
			ЭтоКриптопровайдерLinuxПервыйВариант 	= 0;
			ЭтоКриптопровайдерLinuxПоследнийВариант = 1;
		Иначе
			ЭтоКриптопровайдерLinuxПервыйВариант 	= ?(ЭтоLinux, 1, 0);
			ЭтоКриптопровайдерLinuxПоследнийВариант = ?(ЭтоLinux, 1, 0);
		КонецЕсли;
		
		Для каждого ПроверяемыйАлгоритм Из МассивАлгоритмов Цикл
			Для ЭтоКриптопровайдерLinux = ЭтоКриптопровайдерLinuxПервыйВариант По ЭтоКриптопровайдерLinuxПоследнийВариант Цикл
				ПоследнийПроверяемыйКлассЗащиты = ?(ЭтоКриптопровайдерLinux = 1, 3, 1);
				Для ПроверяемыйКлассЗащиты = 1 По ПоследнийПроверяемыйКлассЗащиты Цикл
					Свойства = КриптопровайдерCryptoPro(ПроверяемыйАлгоритм, ЭтоКриптопровайдерLinux = 1, ПроверяемыйКлассЗащиты, Путь);
					МассивСвойств.Добавить(Свойства);
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		
		Возврат Новый ФиксированныйМассив(МассивСвойств);
	КонецЕсли;
	
	ЭтоКриптопровайдерLinux = ЭтоLinux;
	Если ЭтоКриптопровайдерLinux = Неопределено Тогда
		ЭтоКриптопровайдерLinux = ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент();
	КонецЕсли;
	
	Если Алгоритм = "GOST R 34.10-2012-256" Тогда
		Если ЭтоКриптопровайдерLinux Тогда
			ИмяКриптопровайдера = СтрШаблон(
				"Crypto-Pro GOST R 34.10-2012 KC%1 CSP",
				Строка(КлассЗащиты));
			
		Иначе
			ИмяКриптопровайдера = "Crypto-Pro GOST R 34.10-2012 Cryptographic Service Provider";
		КонецЕсли;
		
		ТипКриптопровайдера 		= 80;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2012-256";
		
	ИначеЕсли Алгоритм = "GOST R 34.10-2012-512" Тогда
		Если ЭтоКриптопровайдерLinux Тогда
			ИмяКриптопровайдера = СтрШаблон(
				"Crypto-Pro GOST R 34.10-2012 KC%1 Strong CSP",
				Строка(КлассЗащиты));
			
		Иначе
			ИмяКриптопровайдера = "Crypto-Pro GOST R 34.10-2012 Strong Cryptographic Service Provider";
		КонецЕсли;
		
		ТипКриптопровайдера 		= 81;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2012-512";
		
	Иначе // Алгоритм "GOST R 34.10-2001"
		Если ЭтоКриптопровайдерLinux Тогда
			ИмяКриптопровайдера = СтрШаблон(
				"Crypto-Pro GOST R 34.10-2001 KC%1 CSP",
				Строка(КлассЗащиты));
			
		Иначе
			ИмяКриптопровайдера = "Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider";
		КонецЕсли;
		
		ТипКриптопровайдера 		= 75;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2001";
	КонецЕсли;
	
	Свойства = Новый Структура();
	Свойства.Вставить("Имя", 					ИмяКриптопровайдера);
	Свойства.Вставить("Путь", 					Путь);
	Свойства.Вставить("Тип", 					ТипКриптопровайдера);
	Свойства.Вставить("Представление", 			"CryptoPro CSP");
	Свойства.Вставить("ТипКриптопровайдера", 	ПредопределенноеЗначение("Перечисление.ТипыКриптоПровайдеров.CryptoPro"));
	Свойства.Вставить("Алгоритм", 				АлгоритмКриптопровайдера);
	Свойства.Вставить("Поддерживается", 		Истина);
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

// Возвращает описание криптопровайдера ViPNet CSP.
//
// Параметры:
//  Алгоритм - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//                      при значении "" или Неопределено возвращается массив свойств криптопровайдеров всех алгоритмов.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура или ФиксированныйМассив из ФиксированнаяСтруктура (при Алгоритм = Неопределено) - описание криптопровайдера.
//    * Имя                 - Строка - имя криптопровайдера.
//    * Тип                 - Число  - тип криптопровайдера.
//    * Путь                - Строка - путь к модулю криптопровайдера в nix-системах.
//    * Представление       - Строка - представление типа криптопровайдера для отображения в интерфейсе.
//    * ТипКриптопровайдера - Перечисления.ТипыКриптоПровайдеров.VipNet.
//    * Алгоритм            - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//    * Поддерживается      - Булево - Истина.
//
Функция КриптопровайдерViPNet(Алгоритм = "GOST R 34.10-2012-256") Экспорт
	
	Если НЕ ЗначениеЗаполнено(Алгоритм) Тогда
		МассивСвойств = Новый Массив;
		МассивАлгоритмов = ПоддерживаемыеАлгоритмы();
		
		Для каждого ПроверяемыйАлгоритм Из МассивАлгоритмов Цикл
			Свойства = КриптопровайдерViPNet(ПроверяемыйАлгоритм);
			МассивСвойств.Добавить(Свойства);
		КонецЦикла;
		
		Возврат Новый ФиксированныйМассив(МассивСвойств);
	КонецЕсли;
	
	Если Алгоритм = "GOST R 34.10-2012-256" Тогда
		ИмяКриптопровайдера 		= "Infotecs GOST 2012/512 Cryptographic Service Provider";
		ТипКриптопровайдера 		= 77;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2012-256";
		
	ИначеЕсли Алгоритм = "GOST R 34.10-2012-512" Тогда
		ИмяКриптопровайдера 		= "Infotecs GOST 2012/1024 Cryptographic Service Provider";
		ТипКриптопровайдера 		= 78;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2012-512";
		
	Иначе // Алгоритм "GOST R 34.10-2001"
		ИмяКриптопровайдера 		= "Infotecs Cryptographic Service Provider";
		ТипКриптопровайдера			= 2;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2001";
	КонецЕсли;
	
	Свойства = Новый Структура();
	Свойства.Вставить("Имя", 					ИмяКриптопровайдера);
	Свойства.Вставить("Путь", 					"");
	Свойства.Вставить("Тип", 					ТипКриптопровайдера);
	Свойства.Вставить("Представление", 			"ViPNet CSP");
	Свойства.Вставить("ТипКриптопровайдера", 	ПредопределенноеЗначение("Перечисление.ТипыКриптоПровайдеров.VipNet"));
	Свойства.Вставить("Алгоритм", 				АлгоритмКриптопровайдера);
	Свойства.Вставить("Поддерживается", 		Истина);
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

// Возвращает описание криптопровайдера Signal-COM CSP.
//
// Параметры:
//   Алгоритм - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//                       при значении "" или Неопределено возвращается массив свойств криптопровайдеров всех алгоритмов.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура или ФиксированныйМассив из ФиксированнаяСтруктура (при Алгоритм = Неопределено) - описание криптопровайдера.
//    * Имя                 - Строка - имя криптопровайдера.
//    * Тип                 - Число  - тип криптопровайдера.
//    * Путь                - Строка - путь к модулю криптопровайдера в nix-системах.
//    * Представление       - Строка - представление типа криптопровайдера для отображения в интерфейсе.
//    * ТипКриптопровайдера - Строка - "SignalCOM".
//    * Алгоритм            - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//    * Поддерживается      - Булево - Ложь.
//
Функция КриптопровайдерSignalCOM(Алгоритм = "GOST R 34.10-2012-256") Экспорт
	
	Если НЕ ЗначениеЗаполнено(Алгоритм) Тогда
		МассивСвойств = Новый Массив;
		МассивАлгоритмов = ПоддерживаемыеАлгоритмы();
		
		Для каждого ПроверяемыйАлгоритм Из МассивАлгоритмов Цикл
			Свойства = КриптопровайдерSignalCOM(ПроверяемыйАлгоритм);
			МассивСвойств.Добавить(Свойства);
		КонецЦикла;
		
		Возврат Новый ФиксированныйМассив(МассивСвойств);
	КонецЕсли;
	
	Если Алгоритм = "GOST R 34.10-2012-256" Тогда
		ИмяКриптопровайдера 		= "Signal-COM GOST R 34.10-2012 (256) Cryptographic Provider";
		ТипКриптопровайдера 		= 80;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2012-256";
		
	ИначеЕсли Алгоритм = "GOST R 34.10-2012-512" Тогда
		ИмяКриптопровайдера 		= "Signal-COM GOST R 34.10-2012 (512) Cryptographic Provider";
		ТипКриптопровайдера 		= 81;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2012-512";
		
	Иначе // Алгоритм "GOST R 34.10-2001"
		ИмяКриптопровайдера 		= "Signal-COM CPGOST Cryptographic Provider";
		ТипКриптопровайдера			= 75;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2001";
	КонецЕсли;
	
	Свойства = Новый Структура();
	Свойства.Вставить("Имя", 					ИмяКриптопровайдера);
	Свойства.Вставить("Путь", 					"");
	Свойства.Вставить("Тип", 					ТипКриптопровайдера);
	Свойства.Вставить("Представление", 			"Signal-COM CSP");
	Свойства.Вставить("ТипКриптопровайдера", 	"SignalCOM");
	Свойства.Вставить("Алгоритм", 				АлгоритмКриптопровайдера);
	Свойства.Вставить("Поддерживается", 		Ложь);
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

// Возвращает описание криптопровайдера ЛИССИ-CSP.
//
// Параметры:
//   Алгоритм - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//                       при значении "" или Неопределено возвращается массив свойств криптопровайдеров всех алгоритмов.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура или ФиксированныйМассив из ФиксированнаяСтруктура (при Алгоритм = Неопределено) - описание криптопровайдера.
//    * Имя                 - Строка - имя криптопровайдера.
//    * Тип                 - Число  - тип криптопровайдера.
//    * Путь                - Строка - путь к модулю криптопровайдера в nix-системах.
//    * Представление       - Строка - представление типа криптопровайдера для отображения в интерфейсе.
//    * ТипКриптопровайдера - Строка - "LISSI".
//    * Алгоритм            - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//    * Поддерживается      - Булево - Ложь.
//
Функция КриптопровайдерЛИССИ(Алгоритм = "GOST R 34.10-2012-256") Экспорт
	
	Если НЕ ЗначениеЗаполнено(Алгоритм) Тогда
		МассивСвойств = Новый Массив;
		МассивАлгоритмов = ПоддерживаемыеАлгоритмы();
		
		Для каждого ПроверяемыйАлгоритм Из МассивАлгоритмов Цикл
			Свойства = КриптопровайдерЛИССИ(ПроверяемыйАлгоритм);
			МассивСвойств.Добавить(Свойства);
		КонецЦикла;
		
		Возврат Новый ФиксированныйМассив(МассивСвойств);
	КонецЕсли;
	
	Если Алгоритм = "GOST R 34.10-2012-256" Тогда
		ИмяКриптопровайдера 		= "LISSI GOST R 34.10-2012 (256) CSP";
		ТипКриптопровайдера 		= 80;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2012-256";
		
	ИначеЕсли Алгоритм = "GOST R 34.10-2012-512" Тогда
		ИмяКриптопровайдера 		= "LISSI GOST R 34.10-2012 (512) CSP";
		ТипКриптопровайдера 		= 81;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2012-512";
		
	Иначе // Алгоритм "GOST R 34.10-2001"
		ИмяКриптопровайдера 		= "LISSI-CSP";
		ТипКриптопровайдера			= 75;
		АлгоритмКриптопровайдера 	= "GOST R 34.10-2001";
	КонецЕсли;
	
	Свойства = Новый Структура();
	Свойства.Вставить("Имя", 					ИмяКриптопровайдера);
	Свойства.Вставить("Путь", 					"");
	Свойства.Вставить("Тип", 					ТипКриптопровайдера);
	Свойства.Вставить("Представление", 			"ЛИССИ-CSP");
	Свойства.Вставить("ТипКриптопровайдера", 	"LISSI");
	Свойства.Вставить("Алгоритм", 				АлгоритмКриптопровайдера);
	Свойства.Вставить("Поддерживается", 		Ложь);
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

// Возвращает описание криптопровайдера Microsoft Base Cryptographic Provider v1.0.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура - описание криптопровайдера.
//    * Имя                 - Строка - имя криптопровайдера.
//    * Тип                 - Число  - тип криптопровайдера.
//    * Путь                - Строка - путь к модулю криптопровайдера в *nix-системах.
//    * Представление       - Строка - представление типа криптопровайдера для отображения в интерфейсе.
//    * ТипКриптопровайдера - Строка - "MSRSA".
//    * Алгоритм            - Строка - "RSA".
//    * Поддерживается      - Булево - Ложь.
//
Функция КриптопровайдерMicrosoftBaseCryptographicProvider() Экспорт
	
	Свойства = Новый Структура();
	Свойства.Вставить("Имя", 					"Microsoft Base Cryptographic Provider v1.0");
	Свойства.Вставить("Путь", 					"");
	Свойства.Вставить("Тип", 					1);
	Свойства.Вставить("Представление", 			"Microsoft Base Cryptographic Provider v1.0");
	Свойства.Вставить("ТипКриптопровайдера", 	"MSRSA");
	Свойства.Вставить("Алгоритм", 				"RSA");
	Свойства.Вставить("Поддерживается", 		Ложь);
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

// Возвращает свойства алгоритма.
//
// Параметры:
//  Алгоритм - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//
// Возвращаемое значение:
//  ФиксированныйМассив - массив с описаниями криптопровайдеров.
//    * Имя                 - Строка.
//    * Алгоритм            - Строка - "GOST R 34.10-2001", "GOST R 34.10-2012-256", "GOST R 34.10-2012-512".
//    * АлгоритмХеширования - Число.
//    * АлгоритмХешированияВМоделиСервиса - Строка.
//
Функция СвойстваАлгоритма(Алгоритм = "GOST R 34.10-2012-256") Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Имя", 								Алгоритм);
	Результат.Вставить("Алгоритм", 							Алгоритм);
	Результат.Вставить("АлгоритмХеширования", 				0);
	Результат.Вставить("АлгоритмХешированияВМоделиСервиса", "");
	
	Если Алгоритм = "GOST R 34.10-2012-256" Тогда
		Результат.Имя = НСтр("ru = 'ГОСТ Р 34.10-2012 с ключом 256 бит'");
		Результат.АлгоритмХеширования = 32801;
		Результат.АлгоритмХешированияВМоделиСервиса = "GOST R 34.11-2012 256";
		
	ИначеЕсли Алгоритм = "GOST R 34.10-2012-512" Тогда
		Результат.Имя = НСтр("ru = 'ГОСТ Р 34.10-2012 с ключом 512 бит'");
		Результат.АлгоритмХеширования = 32802;
		Результат.АлгоритмХешированияВМоделиСервиса = "GOST R 34.11-2012 512";
		
	Иначе // Aлгоритм "GOST R 34.10-2001"
		Результат.Имя = НСтр("ru = 'ГОСТ Р 34.10-2001'");
		Результат.АлгоритмХеширования = 32798;
		Результат.АлгоритмХешированияВМоделиСервиса = "GOST R 34.11-94";
	КонецЕсли;
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

#Область Сертификаты

// Возвращает признак хранения сертификата в защищенном хранилище на сервере.
//
// Параметры:
//	Сертификат - Структура - Сведения о сертификате.
//
// Возвращаемое значение:
//	Булево - Истина, если сертификат хранииться в защищенном хранилище на сервере.
//
Функция СертификатВЗащищенномХранилищеНаСервере(Сертификат) Экспорт
	
	Возврат ЗначениеЗаполнено(Сертификат) 
			И (Сертификат.Свойство("ЭтоЭлектроннаяПодписьВМоделиСервиса") И Сертификат.ЭтоЭлектроннаяПодписьВМоделиСервиса = Истина
			ИЛИ Сертификат.Свойство("ЭлектроннаяПодписьВМоделиСервиса") И Сертификат.ЭлектроннаяПодписьВМоделиСервиса = Истина);
	
КонецФункции   

#КонецОбласти

#Область ОбработкаРезультатовВызова

// Возвращает описание результата выполнения действия.
//
// Параметры:
//	Выполнено - Булево - Истина, если действие выполнено успешно, иначе Ложь.
//	ИмяПоляРезультат - Строка, Неопределено - Имя поля со значением результата.
//	ЗначениеРезультат - Строка, Неопределено - Значение результата.
//	ВходящийКонтекст - Структура, Неопределено - Контекст выполнения.
//
// Возвращаемое значение:
//	Структура - Содержит как минимум ключ:
//		* Выполнено - Булево - признак выполнения.
//
Функция ПодготовитьРезультат(Выполнено, ИмяПоляРезультат = Неопределено, ЗначениеРезультат = Неопределено, ВходящийКонтекст = Неопределено) Экспорт
	
	Результат = Новый Структура("Выполнено", Выполнено);
	
	Если ВходящийКонтекст <> Неопределено Тогда
		Если ВходящийКонтекст.Свойство("МенеджерКриптографии") Тогда
			Результат.Вставить("МенеджерКриптографии", ВходящийКонтекст.МенеджерКриптографии);
		КонецЕсли;
		Если ВходящийКонтекст.Свойство("Алгоритм") Тогда
			Результат.Вставить("Алгоритм", ВходящийКонтекст.Алгоритм);
		КонецЕсли;
		Если ВходящийКонтекст.Свойство("ДвоичныеДанные") Тогда
			Результат.Вставить("ДвоичныеДанные", ВходящийКонтекст.ДвоичныеДанные);
		КонецЕсли;
		Если ВходящийКонтекст.Свойство("ОписаниеОшибки") Тогда
			Результат.Вставить("ОписаниеОшибки", ВходящийКонтекст.ОписаниеОшибки);
		КонецЕсли;
		Если ВходящийКонтекст.Свойство("ИнформацияОбОшибке") И Не ВходящийКонтекст.Свойство("ОписаниеОшибки") Тогда
			Результат.Вставить("ОписаниеОшибки", КраткоеПредставлениеОшибкиКриптосервиса(ВходящийКонтекст.ИнформацияОбОшибке));
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяПоляРезультат) Тогда
		Результат.Вставить(ИмяПоляРезультат, ЗначениеРезультат);
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

// Возвращает текстовое представление ошибки.
//
// Параметры:
//	ИнформацияОбОшибке - Строка, ИнформацияОбОшибке, Структура - Содержит информацию об ошибке.
//
// Возвращаемое значение:
//	Строка - Текстовое представление ошибки.
//
Функция КраткоеПредставлениеОшибкиКриптосервиса(Знач ИнформацияОбОшибке, Знач ИнформацияОбОшибкеКомпоненты = Неопределено) Экспорт
	
	ПредставлениеОшибки = "";
	ПредставлениеОшибкиКомпоненты = "";
	
	Если ИнформацияОбОшибкеКомпоненты <> Неопределено Тогда 
		ПредставлениеОшибкиКомпоненты = КраткоеПредставлениеОшибкиКриптосервиса(ИнформацияОбОшибкеКомпоненты);
	КонецЕсли;
		
	Если ТипЗнч(ИнформацияОбОшибке) = Тип("ИнформацияОбОшибке") Тогда 
		ПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	ИначеЕсли ТипЗнч(ИнформацияОбОшибке) = Тип("Строка") Тогда 
		ПредставлениеОшибки = ИнформацияОбОшибке;
	ИначеЕсли ТипЗнч(ИнформацияОбОшибке) = Тип("Структура") Тогда 
		Если ИнформацияОбОшибке.Свойство("ИнформацияОбОшибке") Тогда
			ПредставлениеОшибки = КраткоеПредставлениеОшибкиКриптосервиса(ИнформацияОбОшибке.ИнформацияОбОшибке);
		ИначеЕсли ИнформацияОбОшибке.Свойство("ОписаниеОшибки") Тогда
			ПредставлениеОшибки = ИнформацияОбОшибке.ОписаниеОшибки;
		Иначе
			ПредставлениеОшибки = "";
			Для Каждого Пара Из ИнформацияОбОшибке Цикл 
				Если СтрНайти(НРег(Пара.Ключ), "ошибк") > 0 Тогда 
					ПредставлениеОшибки = Пара.Значение;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	Иначе
		ПредставлениеОшибки = "";
	КонецЕсли;
	
	Возврат ПредставлениеОшибки + ?(ПредставлениеОшибки = "", "", ?(ПредставлениеОшибкиКомпоненты = "", "", "
	|Ошибка криптокомпоненты: ")) + ПредставлениеОшибкиКомпоненты;
	
КонецФункции

// Проверяет, является ли переданная строка адресом во временном хранилище.
//
// Параметры:
//	Адрес - Строка - Проверяемая строка.
//
// Возвращаемое значение:
//	Булево - Истина, если строка является адресом во временном хранилище.
//
Функция ЭтоАдресВоВременномХранилище(Адрес) Экспорт
	
	Если СтрНайти(Адрес, "e1cib/tempstorage/") = 1 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#Область ОписанияОшибок

// Возвращает описание ошибки, в случае, если не удалось проверить подпись.
//
Функция ОписаниеОшибкиНеУдалосьПроверитьПодпись() Экспорт

	Возврат НСтр("ru = 'Не удалось проверить подпись.'");
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПереместитьВоВременномХранилище(Знач ОткудаАдрес, Знач КудаАдрес, Знач ОчиститьИсходный = Ложь, Знач ПолучатьАдрес = Ложь) Экспорт
	
	Если Не ЭтоАдресВременногоХранилища(ОткудаАдрес) Или 
		Не ПолучатьАдрес И Не ЭтоАдресВременногоХранилища(КудаАдрес) Тогда 
		Возврат Ложь;
	КонецЕсли;
		
	ДанныеСодержимое = ПолучитьИзВременногоХранилища(ОткудаАдрес);
	Результат = ПоместитьВоВременноеХранилище(ДанныеСодержимое, КудаАдрес);
	
	Если ОчиститьИсходный Тогда 
		УдалитьИзВременногоХранилища(ОткудаАдрес);
	КонецЕсли;
	
	Возврат ?(ПолучатьАдрес, Результат, Истина);
	
КонецФункции

Процедура ЗаписатьСобытиеВЖурнал(Имя, Уровень = "Ошибка", Комментарий) Экспорт
	
	КриптографияЭДКОСлужебныйВызовСервера.ЗаписатьСобытиеВЖурнал(Имя, Уровень, Комментарий);
	
КонецПроцедуры

Функция ПоддерживаемыеАлгоритмы()
	
	МассивАлгоритмов = Новый Массив;
	
	ОсновнойАлгоритм = АлгоритмПоУмолчанию();
	
	Если ОсновнойАлгоритм = "GOST R 34.10-2012-256" Тогда
		МассивАлгоритмов.Добавить("GOST R 34.10-2012-256");
		МассивАлгоритмов.Добавить("GOST R 34.10-2012-512");
		МассивАлгоритмов.Добавить("GOST R 34.10-2001");
		
	ИначеЕсли ОсновнойАлгоритм = "GOST R 34.10-2012-512" Тогда
		МассивАлгоритмов.Добавить("GOST R 34.10-2012-512");
		МассивАлгоритмов.Добавить("GOST R 34.10-2012-256");
		МассивАлгоритмов.Добавить("GOST R 34.10-2001");
		
	Иначе
		МассивАлгоритмов.Добавить("GOST R 34.10-2001");
		МассивАлгоритмов.Добавить("GOST R 34.10-2012-256");
		МассивАлгоритмов.Добавить("GOST R 34.10-2012-512");
	КонецЕсли;
	
	Возврат МассивАлгоритмов;
	
КонецФункции

Функция ПроверитьПодписьPKCS7ВМоделиСервиса(ФайлПодписи, ФайлДанных) Экспорт
	
	ИзвлеченныеСертификаты = Неопределено;
	ИзвлеченныеПодписанты = Неопределено;
	КомментарийПоОшибке = "";
	ПодписьВалидна = КриптографияЭДКОСлужебныйВызовСервера.ПроверитьПодписьPKCS7(
		ФайлПодписи, ФайлДанных, ИзвлеченныеСертификаты, ИзвлеченныеПодписанты, КомментарийПоОшибке);
		
	Если НЕ ПодписьВалидна И ЗначениеЗаполнено(КомментарийПоОшибке) Тогда
		Результат = ПодготовитьРезультат(Ложь, "ОписаниеОшибки", КомментарийПоОшибке);
	Иначе
		Результат = ПодготовитьРезультат(Истина, "ПодписьВалидна", ПодписьВалидна);
		Результат.Вставить("Подписанты", ИзвлеченныеПодписанты);
		Для ИндексПодписанта = 0 По Результат.Подписанты.Количество() - 1 Цикл
			Результат.Подписанты[ИндексПодписанта] = Новый ФиксированнаяСтруктура(Результат.Подписанты[ИндексПодписанта]);
		КонецЦикла;
		Результат.Подписанты = Новый ФиксированныйМассив(Результат.Подписанты);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти