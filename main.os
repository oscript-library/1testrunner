﻿//////////////////////////////////////////////////////////////////
// 
// Объект-запускатель приемочного и юнит-тестирования
//
//////////////////////////////////////////////////////////////////

#Использовать "."

Тестер = Новый Тестер;
Тестер.ВыполнитьКоманду(АргументыКоманднойСтроки);
ЗавершитьРаботу(Тестер.ПолучитьРезультатТестирования());