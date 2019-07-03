
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	//ЭР Несторук С.И. 22.03.2017 12:01:24 {
	Если ПометкаУдаления Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ES_Приемка.Ссылка
		|ИЗ
		|	Документ.ES_Приемка КАК ES_Приемка
		|ГДЕ
		|	ES_Приемка.ДокументОснование = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Сообщение = "На оновании документа созданы документы:";
			Пока Выборка.Следующий() Цикл 
				Сообщение = Сообщение + Символы.ПС + Выборка.Ссылка;
			КонецЦикла;
			Сообщить(Сообщение);
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	//}ЭР Несторук С.И.
	
	Если ВидОперации = Перечисления.ES_ВидыОперацийПеремещение.Заказы
		ИЛИ ВидОперации = Перечисления.ES_ВидыОперацийПеремещение.Курьер Тогда
		
		Если Заказы.Количество() = 0 Тогда
			Отказ = ИСтина;
			Сообщить("В документе отсутствуют заказы");
			Возврат;
		КонецЕсли;
		
		
		ТабИзменяемыеРеквизитыЗаказа = ES_ФормированиеДвиженийПоРегистрамДоставки.СоздатьТабДляИзменяемыхРеквизитов();
		ТабСведенияОЗаказе 			= ES_ФормированиеДвиженийПоРегистрамДоставки.СоздатьТаблицуСведенийОЗаказах();
		
		ТабИзменяемыеРеквизитыЗабора = ES_ФормированиеДвиженийПоРегистрамДоставки.СоздатьТабДляИзменяемыхРеквизитовЗаборов();

		
		Движения.ES_ЗаказыНаСкладе.Записывать = Истина;
		Движения.ES_СтатусыЗаказов.Записывать = Истина;
		Движения.ES_ЗаказыВПути.Записывать = Истина;
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ES_ПеремещениеЗаказовЗаказы.Заказ КАК Заказ,
		|	ES_ПеремещениеЗаказовЗаказы.ДатаВремяДобавленияЗаказа КАК ДатаВремяДобавленияЗаказа,
		|	ES_ПеремещениеЗаказовЗаказы.СвязанныйДокумент КАК СвязанныйДокумент,
		|	ВЫРАЗИТЬ(ES_ПеремещениеЗаказовЗаказы.СвязанныйДокумент КАК Документ.ES_ЗаборГруза).НомерНакладной КАК НомерНакладнойЗабор
		|ПОМЕСТИТЬ ВТ_Заказы
		|ИЗ
		|	Документ.ES_ПеремещениеЗаказов.Заказы КАК ES_ПеремещениеЗаказовЗаказы
		|ГДЕ
		|	ES_ПеремещениеЗаказовЗаказы.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВТ_Заказы.Заказ КАК Заказ,
		|	ES_СтатусыЗаказовСрезПоследних.СтатусЗаказа КАК СтатусЗаказа,
		|	ЕСТЬNULL(ES_ЗаказыНаСкладеОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
		|	ВТ_Заказы.ДатаВремяДобавленияЗаказа КАК ДатаВремяДобавленияЗаказа,
		|	ЕСТЬNULL(ES_ЗаказыНаСкладеОстатки.Курьер, ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка)) КАК Курьер,
		|	ES_ДанныеПоЗаказамСрезПоследних.ВидДоставки КАК ВидДоставки,
		|	ВТ_Заказы.СвязанныйДокумент КАК СвязанныйДокумент,
		|	ВТ_Заказы.НомерНакладнойЗабор КАК НомерНакладнойЗабор
		|ИЗ
		|	ВТ_Заказы КАК ВТ_Заказы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ES_СтатусыЗаказов.СрезПоследних(
		|				&МоментВремени,
		|				Заказ В
		|					(ВЫБРАТЬ
		|						ВТ_Заказы.Заказ
		|					ИЗ
		|						ВТ_Заказы КАК ВТ_Заказы)) КАК ES_СтатусыЗаказовСрезПоследних
		|		ПО ВТ_Заказы.Заказ = ES_СтатусыЗаказовСрезПоследних.Заказ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ES_ЗаказыНаСкладе.Остатки(
		|				&МоментВремени,
		|				Заказ В
		|						(ВЫБРАТЬ
		|							ВТ_Заказы.Заказ
		|						ИЗ
		|							ВТ_Заказы КАК ВТ_Заказы)
		|					И Склад = &СкладОтправитель) КАК ES_ЗаказыНаСкладеОстатки
		|		ПО ВТ_Заказы.Заказ = ES_ЗаказыНаСкладеОстатки.Заказ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ES_ДанныеПоЗаказам.СрезПоследних(
		|				,
		|				Заказ В
		|					(ВЫБРАТЬ
		|						ВТ_Заказы.Заказ
		|					ИЗ
		|						ВТ_Заказы КАК ВТ_Заказы)) КАК ES_ДанныеПоЗаказамСрезПоследних
		|		ПО ВТ_Заказы.Заказ = ES_ДанныеПоЗаказамСрезПоследних.Заказ";
		
		Запрос.УстановитьПараметр("СкладОтправитель", СкладОтправитель);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		//проверяем, есть ли заказы в данный момент на складе.
		Запрос.УстановитьПараметр("МоментВремени", Новый Граница(Дата,ВидГраницы.Включая));//МоментВремени(); 
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		 
		Пока Выборка.Следующий() Цикл
			Если ТипЗнч(Выборка.Заказ) = Тип("ДокументСсылка.ES_ЗаборГруза") Тогда
				
				// ДоставкаПартнером
				Если ЗначениеЗаполнено(СкладПолучатель.ES_Партнер) Тогда
					НоваяСтрока = ТабИзменяемыеРеквизитыЗабора.Добавить();
					НоваяСтрока.Движения 		= Движения.ES_ИзменяемыеРеквизитыЗаборов;
					НоваяСтрока.Период 			= Дата;//ПериодПроведения;
					НоваяСтрока.Регистратор 	= Ссылка;
					НоваяСтрока.Забор 			= Выборка.Заказ;
					НоваяСтрока.РеквизитЗабора 	= Перечисления.ES_ИзменяемыеРеквизитыЗабора.ДоставкаПартнером;
					НоваяСтрока.Значение 		= Истина;
					
					НоваяСтрока = ТабИзменяемыеРеквизитыЗабора.Добавить();
					НоваяСтрока.Движения 		= Движения.ES_ИзменяемыеРеквизитыЗаборов;
					НоваяСтрока.Период 			= Дата;//ПериодПроведения;
					НоваяСтрока.Регистратор 	= Ссылка;
					НоваяСтрока.Забор 			= Выборка.Заказ;
					НоваяСтрока.РеквизитЗабора 	= Перечисления.ES_ИзменяемыеРеквизитыЗабора.Партнер;
					НоваяСтрока.Значение 		= СкладПолучатель.ES_Партнер;
				КонецЕсли;
				
			Иначе
				
				Если ВидОперации = Перечисления.ES_ВидыОперацийПеремещение.Заказы Тогда
					Если Выборка.ВидДоставки = Перечисления.ES_ВидыДоставки.СкладСклад И ЗначениеЗаполнено(СкладПолучатель.ES_Партнер) Тогда
						Отказ = Истина;
						Сообщить(НСтр("ru='"+Выборка.Заказ + " не может быть перемещен на партнерский склад. Причина - вид доставки: "+ Перечисления.ES_ВидыДоставки.СкладСклад+"'"));		
					КонецЕсли;
					
					Если Подтвержден = Истина Тогда
						КонтрольОстатков = Истина;
						//ЭР Несторук С.И. 25.10.2017 9:54:30 {
						//Проверка Заказа ДД и в статусе ОжидаетГруз на присутствие забора в тч
						Если Выборка.ВидДоставки = Перечисления.ES_ВидыДоставки.ДвериДвери
							И (Выборка.СтатусЗаказа = Перечисления.ES_СтатусыЗаказов.ОжидаетГруз
							ИЛИ Выборка.СтатусЗаказа = Перечисления.ES_СтатусыЗаказов.ОжидаетГрузНазначен) Тогда
							НайтиСтроки = Заказы.НайтиСтроки(Новый Структура("Заказ", Выборка.СвязанныйДокумент));
							КонтрольОстатков = Ложь;
							Если НайтиСтроки.Количество() = 0 Тогда
								Отказ = Истина;
								Сообщение = "" + Выборка.Заказ + "("+Выборка.ВидДоставки+")"+ " не может перемещаться без своего сбора " + Выборка.НомерНакладнойЗабор;	
							КонецЕсли;
						КонецЕсли;
						//}ЭР Несторук С.И.
						
						//Если Выборка.СтатусЗаказа = Перечисления.ES_СтатусыЗаказов.ПодготовленПринят Тогда
						
						Движение= Движения.ES_СтатусыЗаказов.Добавить();
						Движение.Заказ 			= Выборка.Заказ;
						//Движение.Период			= Выборка.ДатаВремяДобавленияЗаказа;
						Движение.Период			= ДатаПодтверждения;
						Движение.СтатусЗаказа 	= Перечисления.ES_СтатусыЗаказов.МеждуСкладами;
						Движение.Ответственный	= Ответственный;			
						//Иначе
						//	Сообщить(НСтр("ru = ' "+ Выборка.Заказ+" в статусе "+ Выборка.СтатусЗаказа + " не может быть перемещен между складами!'"));
						//	Отказ = Истина;
						//КонецЕсли;
						
						Если КонтрольОстатков Тогда
							ДвижениеВПУти= Движения.ES_ЗаказыВПути.Добавить();
							ДвижениеВПУти.Период = ДатаПодтверждения;
							ДвижениеВПУти.Заказ = Выборка.Заказ; 
							ДвижениеВПУти.СкладОтправитель = СкладОтправитель;
							ДвижениеВПУти.СкладПолучатель = СкладПолучатель;
							ДвижениеВПУти.Количество = Выборка.КоличествоОстаток; 
							
							Если Выборка.КоличествоОстаток > 0 Тогда
								Движение = Движения.ES_ЗаказыНаСкладе.ДобавитьРасход();
								Движение.Заказ			= Выборка.Заказ;
								//Движение.Период			= Выборка.ДатаВремяДобавленияЗаказа;
								Движение.Период			= ДатаПодтверждения;
								Движение.Количество		= Выборка.КоличествоОстаток;
								Движение.Склад			= СкладОтправитель; 
							Иначе
								Сообщить(НСтр("ru = 'На складе "+ СкладОтправитель+" "+ Выборка.Заказ + " отсутсвует!'"));
								Отказ = Истина;
							КонецЕсли;
						КонецЕсли;
						// РС ES_ИзменяемыеРеквизитыЗаказов
						// ДоставкаПартнером
						Если ЗначениеЗаполнено(СкладПолучатель.ES_Партнер) Тогда
							НоваяСтрока = ТабИзменяемыеРеквизитыЗаказа.Добавить();
							НоваяСтрока.Движения 		= Движения.ES_ИзменяемыеРеквизитыЗаказов;
							НоваяСтрока.Период 			= Дата;//ПериодПроведения;
							НоваяСтрока.Регистратор 	= Ссылка;
							НоваяСтрока.Заказ 			= Выборка.Заказ;
							НоваяСтрока.РеквизитЗаказа 	= Перечисления.ES_ИзменяемыеРеквизитыЗаказа.ДоставкаПартнером;
							НоваяСтрока.Значение 		= Истина;
							
							НоваяСтрока = ТабИзменяемыеРеквизитыЗаказа.Добавить();
							НоваяСтрока.Движения 		= Движения.ES_ИзменяемыеРеквизитыЗаказов;
							НоваяСтрока.Период 			= Дата;//ПериодПроведения;
							НоваяСтрока.Регистратор 	= Ссылка;
							НоваяСтрока.Заказ 			= Выборка.Заказ;
							НоваяСтрока.РеквизитЗаказа 	= Перечисления.ES_ИзменяемыеРеквизитыЗаказа.Партнер;
							НоваяСтрока.Значение 		= СкладПолучатель.ES_Партнер;
						КонецЕсли;
						
						
					Иначе
						Движение= Движения.ES_СтатусыЗаказов.Добавить();
						Движение.Заказ 			= Выборка.Заказ;
						Движение.Период			= Выборка.ДатаВремяДобавленияЗаказа;
						Движение.СтатусЗаказа 	= ?(Выборка.СтатусЗаказа = Перечисления.ES_СтатусыЗаказов.ОжидаетГруз,Перечисления.ES_СтатусыЗаказов.ОжидаетГрузНазначен, Перечисления.ES_СтатусыЗаказов.Назначен);
						Движение.Ответственный	= Ответственный;
					КонецЕсли;
					// РС ES_ИзменяемыеРеквизитыЗаказов
					// Курьер
					//Если ЗначениеЗаполнено(Курьер) Тогда
					//	
					//	НоваяСтрока = ТабИзменяемыеРеквизитыЗаказа.Добавить();
					//	НоваяСтрока.Движения 		= Движения.ES_ИзменяемыеРеквизитыЗаказов;
					//	НоваяСтрока.Период 			= Дата;//ПериодПроведения;
					//	НоваяСтрока.Регистратор 	= Ссылка;
					//	НоваяСтрока.Заказ 			= Выборка.Заказ;
					//	НоваяСтрока.РеквизитЗаказа 	= Перечисления.ES_ИзменяемыеРеквизитыЗаказа.Курьер;
					//	НоваяСтрока.Значение 		= Курьер;
					//КонецЕсли;
					
					Если ЗначениеЗаполнено(Подрядчик) Тогда
						// Подрядчик
						НоваяСтрока = ТабИзменяемыеРеквизитыЗаказа.Добавить();
						НоваяСтрока.Движения 		= Движения.ES_ИзменяемыеРеквизитыЗаказов;
						НоваяСтрока.Период 			= Дата;//ПериодПроведения;
						НоваяСтрока.Регистратор 	= Ссылка;
						НоваяСтрока.Заказ 			= Выборка.Заказ;
						НоваяСтрока.РеквизитЗаказа 	= Перечисления.ES_ИзменяемыеРеквизитыЗаказа.Подрядчик;
						НоваяСтрока.Значение 		= Подрядчик;
					КонецЕсли;
					
					// РС ES_СведенияОЗаказах - заполнение таблицы
					НоваяСтрока = ТабСведенияОЗаказе.Добавить();
					НоваяСтрока.Движения 		= Движения.ES_СведенияОЗаказах;
					//ЕФСОЛ Несторук 21-11-16 +
					//НоваяСтрока.Период 			= Выборка.ДатаВремяДобавленияЗаказа;//ПериодПроведения; закомментированно
					НоваяСтрока.Период			= Дата; //добавлено
					//ЕФСОЛ Несторук 21-11-16 -
					НоваяСтрока.Регистратор 	= Ссылка;
					НоваяСтрока.Заказ 			= Выборка.Заказ;
					НоваяСтрока.ПеремещениеЗаказов 	= Ссылка;
				ИначеЕсли ВидОперации = Перечисления.ES_ВидыОперацийПеремещение.Курьер Тогда
					Если Выборка.КоличествоОстаток > 0 И НЕ ЗначениеЗаполнено(выборка.Курьер) Тогда
						Движение = Движения.ES_ЗаказыНаСкладе.ДобавитьРасход();
						Движение.Заказ			= Выборка.Заказ;
						Движение.Период			= Выборка.ДатаВремяДобавленияЗаказа;
						//Движение.Период			= ДатаПодтверждения;
						Движение.Количество		= Выборка.КоличествоОстаток;
						Движение.Склад			= СкладОтправитель; 
						
						Движение = Движения.ES_ЗаказыНаСкладе.ДобавитьПриход();
						Движение.Заказ			= Выборка.Заказ;
						Движение.Период			= Выборка.ДатаВремяДобавленияЗаказа;
						//Движение.Период			= ДатаПодтверждения;
						Движение.Количество		= Выборка.КоличествоОстаток;
						Движение.Склад			= СкладОтправитель;
						Движение.Курьер			= Курьер;
						
						// Ячейку очищать
						НоваяСтрока = ТабИзменяемыеРеквизитыЗаказа.Добавить();
						НоваяСтрока.Движения 		= Движения.ES_ИзменяемыеРеквизитыЗаказов;
						НоваяСтрока.Период 			= Дата;//ПериодПроведения;
						НоваяСтрока.Регистратор 	= Ссылка;
						НоваяСтрока.Заказ 			= Выборка.Заказ;
						НоваяСтрока.РеквизитЗаказа 	= Перечисления.ES_ИзменяемыеРеквизитыЗаказа.Ячейка;
						НоваяСтрока.Значение 		= Справочники.Ячейки.ПустаяСсылка();
						
					ИначеЕсли ЗначениеЗаполнено(выборка.Курьер) Тогда
						Отказ = Истина;
						Сообщить(НСтр("ru = '"+ Выборка.Заказ + "уже выдан курьеру "+ Курьер+"'"));
						
					Иначе
						
						Отказ = Истина;
						Сообщить(НСтр("ru = 'На складе "+ СкладОтправитель+" "+ Выборка.Заказ + " отсутсвует!'"));
					КонецЕсли;	
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		//ЭР Несторук С.И. 03.10.2017 19:05:26 {
		Если ВидОперации = Перечисления.ES_ВидыОперацийПеремещение.Заказы И Подтвержден И НЕ Отказ  Тогда
			Для каждого стр Из Заказы Цикл
				Стр.ДатаВремяДобавленияЗаказа = ДатаПодтверждения;
			КонецЦикла;
		КонецЕсли;
		
		//}ЭР Несторук С.И.
		Если ТабИзменяемыеРеквизитыЗаказа.Количество() > 0 Тогда
			// РС ES_ИзменяемыеРеквизитыЗаказов
			ES_ФормированиеДвиженийПоРегистрамДоставки.СделатьЗаписьВРегистрСведенийИзменяемыеРеквизитыЗаказа(ТабИзменяемыеРеквизитыЗаказа, Ссылка);
		КонецЕсли;
		если ТабСведенияОЗаказе.Количество() > 0 Тогда
			// РС ES_СведенияОЗаказах
			ES_ФормированиеДвиженийПоРегистрамДоставки.СделатьЗаписьВРССведенияОЗаказах(ТабСведенияОЗаказе, Дата);//ПериодПроведения);
		КонецЕсли;
		Если ТабИзменяемыеРеквизитыЗабора.Количество() > 0 Тогда
			// РС ES_ИзменяемыеРеквизитыЗаказов
			ES_ФормированиеДвиженийПоРегистрамДоставки.СделатьЗаписьВРегистрСведенийИзменяемыеРеквизитыЗабора(ТабИзменяемыеРеквизитыЗабора, Ссылка);
		КонецЕсли;
	
			
		
	ИначеЕсли  ВидОперации = Перечисления.ES_ВидыОперацийПеремещение.НаложенныеПлатежи Тогда
		
		Если Платежи.Количество() = 0 Тогда
			Отказ = ИСтина;
			Сообщить("В документе отсутствуют заказы");
			Возврат;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ES_ПеремещениеЗаказовПлатежи.Заказ,
		|	ES_ПеремещениеЗаказовПлатежи.КОтправке,
		|	ES_ПеремещениеЗаказовПлатежи.Ссылка.Партнер
		|ПОМЕСТИТЬ ВТ_Заказы
		|ИЗ
		|	Документ.ES_ПеремещениеЗаказов.Платежи КАК ES_ПеремещениеЗаказовПлатежи
		|ГДЕ
		|	ES_ПеремещениеЗаказовПлатежи.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(ES_НаложенныеПлатежиПартнеровОбороты.ОтправленоОборот, 0) КАК ОтправленоОборот,
		|	ВТ_Заказы.Заказ,
		|	ВТ_Заказы.КОтправке
		|ИЗ
		|	ВТ_Заказы КАК ВТ_Заказы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ES_НаложенныеПлатежиПартнеров.Обороты(
		|				,
		|				,
		|				,
		|				Заказ В
		|					(ВЫБРАТЬ
		|						ВТ_Заказы.Заказ
		|					ИЗ
		|						ВТ_Заказы КАК ВТ_Заказы)) КАК ES_НаложенныеПлатежиПартнеровОбороты
		|		ПО ВТ_Заказы.Заказ = ES_НаложенныеПлатежиПартнеровОбороты.Заказ
		|			И ВТ_Заказы.Партнер = ES_НаложенныеПлатежиПартнеровОбороты.Партнер";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ОтправленоОборот > 0 Тогда
				Сообщить(НСтр("ru='"+Выборка.Заказ+ " уже назначено к отправке НП на сумму "+Выборка.ОтправленоОборот+"'"));
				Отказ = Истина;
				Продолжить;
			КонецЕсли;
			
			Если Выборка.КОтправке > 0 Тогда
				ES_ОбщегоНазначения.СформироватьДвижения_ES_НаложенныеПлатежиПартнеров(Движения,Дата,Ссылка,Партнер,Выборка.Заказ,0,0,0,Выборка.КОтправке,0);
			КонецЕсли;
			
		КонецЦикла;
		
		
	//ИначеЕсли  Тогда
		
		
		
		
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВидОперации = Перечисления.ES_ВидыОперацийПеремещение.Заказы Тогда
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты,"Партнер");
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты,"ВидОплаты");
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты,"Курьер");
		
	ИначеЕсли ВидОперации = Перечисления.ES_ВидыОперацийПеремещение.НаложенныеПлатежи Тогда
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты,"СкладОтправитель");
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты,"СкладПолучатель");
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты,"Курьер");
		

	ИначеЕсли ВидОперации = Перечисления.ES_ВидыОперацийПеремещение.Курьер Тогда
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты,"Партнер");
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты,"ВидОплаты");
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты,"СкладПолучатель");
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ES_Приемка") Тогда
		
		Если ДанныеЗаполнения.ВидОперации = Перечисления.ES_ВидыОперацийПриемки.Заказы Тогда
			ВидОперации = Перечисления.ES_ВидыОперацийПеремещение.Заказы;
			СкладОтправитель = ДанныеЗаполнения.Склад;
			ДокументОснование = ДанныеЗаполнения;
			Для каждого Стр Из ДанныеЗаполнения.Заказы Цикл
				НовСтр = Заказы.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтр,Стр);
				НовСтр.ДокументОснование = ДанныеЗаполнения;
				НовСтр.ДатаВремяДобавленияЗаказа = ТекущаяДатаСеанса();
			КонецЦикла;
			
			Для каждого Стр Из ДанныеЗаполнения.Грузы Цикл
				НовСтр = Грузы.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтр,Стр);	
			КонецЦикла;

		ИначеЕсли ДанныеЗаполнения.ВидОперации = Перечисления.ES_ВидыОперацийПриемки.НаложенныеПлатежи Тогда
			ВидОперации = Перечисления.ES_ВидыОперацийПеремещение.НаложенныеПлатежи;
			Партнер = ДанныеЗаполнения.Партнер;
			ВидОплаты = ДанныеЗаполнения.ВидОплаты;
			Для каждого Стр Из ДанныеЗаполнения.Платежи Цикл
				НовСтр = Платежи.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтр,Стр);
				НовСтр.КОтправке = Стр.Принято;
			КонецЦикла;
			
			
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ES_ПланДоставки") Тогда
		
		//Если НЕ ДанныеЗаполнения.Подтвержден Тогда
		//	ВызватьИсключение НСтр("ru = 'Создать ""Перемещение на курьера"" можно только на основании утвержденного Плана!'");
		//КонецЕсли;
		СкладОтправитель = ДанныеЗаполнения.Склад;
		Если НЕ ЗначениеЗаполнено(СкладОтправитель) Тогда
			ВызватьИсключение НСтр("ru = 'Склад не заполнен'");
		КонецЕсли;
		//МассивЗаказов = ДанныеЗаполнения.Заказы.ВыгрузитьКолонку("ДокументДоставки");
		МассивЗаказов = Новый Массив;
		МассивЗаказовСоСвязанныйЗабором = Новый Массив;
		Для каждого Стр ИЗ ДанныеЗаполнения.Заказы Цикл
			Если типЗнч(Стр.ДокументДоставки) <> Тип("ДокументСсылка.ЗаказПокупателя") Тогда Продолжить; КонецЕсли;
			НайтиЗабор = ДанныеЗаполнения.Заказы.НайтиСтроки(Новый Структура("СвязанныйДокумент",Стр.ДокументДоставки));
			Если НайтиЗабор.Количество() = 0 Тогда
				МассивЗаказов.Добавить(Стр.ДокументДоставки);
			Иначе
				//МассивЗаказовСоСвязанныйЗабором.Добавить(Стр.ДокументДоставки);
			КонецЕсли;
			
		КонецЦикла;
		
		//ЗаполнитьТЧЗаказами(МассивЗаказов);
		ВидОперации = Перечисления.ES_ВидыОперацийПеремещение.Курьер;
		ДокументОснование = ДанныеЗаполнения;
		ES_ОбщегоНазначения.СоздатьПеремещениеЗаказовНаСервере(ЭтотОбъект,МассивЗаказов,,Истина,СкладОтправитель);
		Если МассивЗаказовСоСвязанныйЗабором.Количество() > 0 Тогда
		//ES_ОбщегоНазначения.СоздатьПеремещениеЗаказовНаСервере(ЭтотОбъект,МассивЗаказовСоСвязанныйЗабором,,Ложь,СкладОтправитель);	
		КонецЕсли;
		
		
		Курьер 		= ДанныеЗаполнения.Курьер;
		СкладОтправитель = ДанныеЗаполнения.Склад;
				
	КонецЕсли;
	
	
		
КонецПроцедуры

Процедура ЗаполнитьТЧЗаказами(МассивЗаказов)
	
	РезультатЗапроса = ES_ОбщегоНазначения.ПолучитьДанныеПоЗаказам(МассивЗаказов);
	
	Если РезультатЗапроса.Пустой() Тогда Возврат; КонецЕсли;
	
	ВыборкаДокументыДоставки = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаДокументыДоставки.Следующий() Цикл
		
		ВыборкаДетальныеЗаписи = ВыборкаДокументыДоставки.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Если Не ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ЗапасНоменклатура)  Тогда
				Продолжить;
			КонецЕсли;
			//ЭР Несторук С.И. 09.02.2017 17:10:45 }
			
			НовыйМесто = Грузы.Добавить();
			НовыйМесто.ДокументДоставки 	= ВыборкаДокументыДоставки.ДокументДоставки;
			НовыйМесто.Номенклатура 		= ВыборкаДетальныеЗаписи.ЗапасНоменклатура;
			НовыйМесто.ТипНоменклатурыЗапас = ВыборкаДетальныеЗаписи.ЗапасТипНоменклатурыЗапас;
			НовыйМесто.Характеристика 		= ВыборкаДетальныеЗаписи.ЗапасХарактеристика;
			НовыйМесто.Партия 				= ВыборкаДетальныеЗаписи.ЗапасПартия;
			НовыйМесто.КоличествоПлан 		= ВыборкаДетальныеЗаписи.ЗапасКоличество;
			НовыйМесто.КоличествоФакт 		= ВыборкаДетальныеЗаписи.ЗапасКоличество;
			НовыйМесто.ЕдиницаИзмерения 	= ВыборкаДетальныеЗаписи.ЗапасЕдиницаИзмерения;
			НовыйМесто.Цена 				= ВыборкаДетальныеЗаписи.ЗапасЦена;
			НовыйМесто.ПроцентСкидкиНаценки = ВыборкаДетальныеЗаписи.ЗапасПроцентСкидкиНаценки;
			НовыйМесто.НППлан 				= ВыборкаДетальныеЗаписи.ЗапасНППлан;
			НовыйМесто.НПФакт 				= ВыборкаДетальныеЗаписи.ЗапасНППлан;
			НовыйМесто.Содержание 			= ВыборкаДетальныеЗаписи.ЗапасСодержание;
			НовыйМесто.Вес 					= ВыборкаДетальныеЗаписи.ЗапасВес;
			НовыйМесто.Объем 				= ВыборкаДетальныеЗаписи.ЗапасОбъем;
			НовыйМесто.ОбъемныйВес 			= ВыборкаДетальныеЗаписи.ЗапасОбъемныйВес;
			НовыйМесто.ОбьявленнаяСтоимость = ВыборкаДетальныеЗаписи.ЗапасОбьявленнаяСтоимость;
			НовыйМесто.Опасность 			= ВыборкаДетальныеЗаписи.ЗапасОпасность;
			НовыйМесто.Артикул				= ВыборкаДетальныеЗаписи.ЗапасАртикул;
			НовыйМесто.Штрихкод				= ВыборкаДетальныеЗаписи.ЗапасШтрихкод;
			
			
		КонецЦикла;
				
	КонецЦикла;
	
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ПометкаУдаления ИЛИ РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		
		// Нельзя пометить на удаление и отменить проведение документа, если он проходит по другим документам
		МассивСсылок = Новый Массив;
		МассивСсылок.Добавить(Ссылка);
		
		УстановитьПривилегированныйРежим(Истина);
		ТабНайденныхСсылок = НайтиПоСсылкам(МассивСсылок);
		УстановитьПривилегированныйРежим(Ложь);
		
		Для каждого Строка Из ТабНайденныхСсылок Цикл
			Если Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Строка.Данные)) Тогда
				//ЭР Несторук С.И. 13.10.2017 14:44:41 {
				//Смотрим ссылаются ли на документ проведенные документы, а не помеченные на удаление
				//Если НЕ Строка.Данные.ПометкаУдаления и НЕ Ссылка = Строка.Данные Тогда
				Если Строка.Данные.Проведен и НЕ Ссылка = Строка.Данные Тогда
					//}ЭР Несторук С.И.
					Сообщить("На документ ссылается " + Строка.Данные);
					Отказ = Истина;
					Возврат;
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла; 
		
	КонецЕсли; 

КонецПроцедуры

