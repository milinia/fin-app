//
//  Strings.swift
//  fin-app
//
//  Created by Evelina on 13.06.2025.
//

import Foundation

enum Strings {
    
    enum TabBar {
        static let income = "Доходы"
        static let outcome = "Расходы"
        static let balance = "Счет"
        static let category = "Статьи"
        static let settings = "Настройки"
    }
    
    enum TransactionsListView {
        static let incomeTitle = "Доходы сегодня"
        static let outcomeTitle = "Расходы сегодня"
        static let total = "Всего"
        static let operations = "Операции"
    }
    
    enum HistoryView {
        static let title = "Моя история"
        static let start = "Начало"
        static let end = "Конец"
        static let sum = "Сумма"
        static let done = "Готово"
        static let back = "Назад"
        static let sort = "Сортировка"
        static let byDate = "По дате"
        static let byAmount = "По сумме"
    }
    
    enum MyBalanceView {
        static let title = "Мой счет"
        static let balance = "Баланс"
        static let currency = "Валюта"
        static let edit = "Редактировать"
        static let save = "Сохранить"
        static let moneyEmoji = "💰"
    }
    
    enum MyCategoriesView {
        static let title = "Мои статьи"
        static let category = "Cтатьи"
    }
    
    enum AnalysisView {
        static let title = "Анализ"
        static let periodBegin = "Период: начало"
        static let periodEnd = "Период: конец"
        static let sum = "Сумма"
        static let operations = "Операции"
    }
    
    enum ManageTransactionView {
        static let titleIncome = "Мои Доходы"
        static let titleOutcome = "Мои Расходы"
        static let save = "Сохранить"
        static let create = "Создать"
        static let cancel = "Отмена"
        static let categories = "Статья"
        static let sum = "Сумма"
        static let date = "Дата"
        static let time = "Время"
        static let deleteIncome = "Удалить доход"
        static let deleteOutcome = "Удалить расход"
        static let error = "Ошибка"
        static let ok = "Oк"
        static let emptyFields = "Заполните, пожалуйста, все поля"
    }
}
