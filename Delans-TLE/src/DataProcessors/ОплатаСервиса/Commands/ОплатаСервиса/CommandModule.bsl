
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
    
    ОткрытьФорму("Обработка.ОплатаСервиса.Форма",, 
        ПараметрыВыполненияКоманды.Источник,
        ПараметрыВыполненияКоманды.Уникальность, 
        ПараметрыВыполненияКоманды.Окно, 
        ПараметрыВыполненияКоманды.НавигационнаяСсылка);
    
КонецПроцедуры

#КонецОбласти 
