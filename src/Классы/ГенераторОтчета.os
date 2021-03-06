///////////////////////////////////////////////////////////////////////////////
//
// Служебный модуль с реализацией работы <ГенераторОтчета>
//
// (с) BIA Technologies, LLC
//
///////////////////////////////////////////////////////////////////////////////

// Сохраняет результат сравнения
// 
// Параметры:
//   РезультатСравнения - Структура - Результат сравнения конфигураций и расширения
//   ИмяФайлаРезультата - Строка - Полное имя файла, в который будет записан результат сравнения
//   Лог - log-manager - Экземпляр класса логирования
//   ФорматРезультата - Строка - Необязательный, пока реализован только "HTML" формат
//
Процедура СохранитьРезультат(РезультатСравнения, ИмяФайлаРезультата, Лог, ФорматРезультата = "HTML") Экспорт

	Если ФорматРезультата = "HTML" Тогда

		Попытка
			ГенераторОтчетаHTML.СохранитьРезультат(РезультатСравнения, ИмяФайлаРезультата, Лог);
		Исключение
			ОбработкаИсключенияЗаписи(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), ИмяФайлаРезультата, Лог);
		КонецПопытки;

	ИначеЕсли ФорматРезультата = "TXT" Тогда

		ТекстРезультат = Новый ТекстовыйДокумент();
		ТекстРезультат.ДобавитьСтроку(СтрШаблон("Результат сравнения изменений в структуре объектов:
			|%1
			|%2
			|
			|", РезультатСравнения.РодительПуть, РезультатСравнения.ПоставкаПуть));

		Для каждого ЭлементПроекта Из РезультатСравнения.Типы Цикл

			ТекстРезультат.ДобавитьСтроку(ЭлементПроекта);
			
		КонецЦикла;

		Если ЗначениеЗаполнено(ИмяФайлаРезультата) Тогда

			Попытка
				ТекстРезультат.Записать(ИмяФайлаРезультата, КодировкаТекста.UTF8NoBOM);
			Исключение
				ОбработкаИсключенияЗаписи(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), ИмяФайлаРезультата, Лог);
			КонецПопытки;

		Иначе

			Лог.Информация(ТекстРезультат.ПолучитьТекст());

		КонецЕсли;
	
	Иначе

		Лог.Ошибка("Неверный формат результата");

	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаИсключенияЗаписи(ПредставлениеОшибки, ИмяФайлаРезультата, Лог)

	ТекстОшибки = СтрШаблон("Не удалось сохранить результат в '%1' по причине:
		|%3", ИмяФайлаРезультата, ПредставлениеОшибки);

	Лог.Ошибка(ТекстОшибки);

	ВызватьИсключение ТекстОшибки;

КонецПроцедуры