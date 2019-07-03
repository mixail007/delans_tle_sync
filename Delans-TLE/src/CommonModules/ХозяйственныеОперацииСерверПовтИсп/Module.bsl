Функция ПолучитьХозяйственнуюОперациюПоВидуОперацииДокумента(ВидОперации, СсылкаНаДокумент = Неопределено) Экспорт

	Если ТипЗнч(СсылкаНаДокумент) = Тип("ДокументСсылка.ЗакрытиеМесяца") Тогда
		
		ХозяйственнаяОперация = Справочники.ХозяйственныеОперации.ЗакрытиеМесяца;
		
	ИначеЕсли ТипЗнч(СсылкаНаДокумент) = Тип("ДокументСсылка.ДоговорКредитаИЗайма") Тогда
		
		Попытка
			ИмяЗначенияПеречисления = ВидОперации.Метаданные().ЗначенияПеречисления[Перечисления[ВидОперации.Метаданные().Имя].Индекс(ВидОперации)].Имя;
			ХозяйственнаяОперация = Справочники.ХозяйственныеОперации[ИмяЗначенияПеречисления];
		Исключение
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не удалось найти вид договора "+ВидОперации+" для документа "+СсылкаНаДокумент+".
				|Имя значения = "+ИмяЗначенияПеречисления;
			Сообщение.Сообщить();
			
			ХозяйственнаяОперация = Справочники.ХозяйственныеОперации.ПустаяСсылка();
		КонецПопытки;
		
	ИначеЕсли ТипЗнч(ВидОперации) = Тип("Строка") Тогда
		
		ХозяйственнаяОперация = Справочники.ХозяйственныеОперации[СокрЛП(ВидОперации)];
		
	ИначеЕсли Не (ВидОперации = Неопределено) Тогда // т.е. у документа есть реквизит ВидОперации.
		
		Если ЗначениеЗаполнено(ВидОперации) Тогда
			Попытка
				ИмяЗначенияПеречисления = ВидОперации.Метаданные().ЗначенияПеречисления[Перечисления[ВидОперации.Метаданные().Имя].Индекс(ВидОперации)].Имя;
				ХозяйственнаяОперация = Справочники.ХозяйственныеОперации[ИмяЗначенияПеречисления];
			Исключение
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Не удалось найти вид операции "+ВидОперации+" для документа "+СсылкаНаДокумент+".
					|Имя значения = "+ИмяЗначенияПеречисления;
				Сообщение.Сообщить();
				
				ХозяйственнаяОперация = Справочники.ХозяйственныеОперации.ПустаяСсылка();
			КонецПопытки;
		Иначе
			ХозяйственнаяОперация = Справочники.ХозяйственныеОперации.ПустаяСсылка();
		КонецЕсли;
		
	Иначе
		
		ХозяйственнаяОперация = Справочники.ХозяйственныеОперации.ПустаяСсылка();
		
	КонецЕсли;
	
	ХозяйственныеОперацииСерверПереопределяемый.УстанвоитьХозяйственнуюОперациюПоВидуОперацииДокумента(ВидОперации, ХозяйственнаяОперация, СсылкаНаДокумент);
	
	Возврат ХозяйственнаяОперация;
	
КонецФункции // ПолучитьХозяйственнуюОперациюПоВидуОперацииДокумента()
