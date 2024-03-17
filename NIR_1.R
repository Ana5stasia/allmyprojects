#Илькаева Анастасия, КМБО-03-23, Вариант 6
#Подключение библиотек, необходимых для работы
library("lmtest")
library("GGally")

#Добавление данных swiss
data=swiss

#Просмотр данных
data

#Структура таблицы
str(data)

#Среднее арифметическое величин
sum(data$Agriculture)/47
sum(data$Catholic)/47
sum(data$Infant.Mortality)/47

#Математическое ожидание величин
mean(data$Agriculture)
mean(data$Catholic)
mean(data$Infant.Mortality)

#Дисперсия величин
var(data$Agriculture)
var(data$Catholic)
var(data$Infant.Mortality)

#Стандартное квадратичное отклонение
sd(data$Agriculture)
sd(data$Catholic)
sd(data$Infant.Mortality)

#Построение линейной зависимости
model1=lm(Agriculture~Infant.Mortality, data)
model1
summary(model1)
#По результатам построения получаем: Agriculture = -0,47 * Infant.Mortality + 60,12
#Коэффициент перед  Infant.Mortality отрицательный.
#Коэффициент детерминации R^2=0.4%, следовательно, модель плохая, зависимости нет, модель плохо описывает динамику переменной.
#Зависимости Agriculture от Infant.Mortality нет, т.к. нет звездочек, регрессор не описывает поведение переменной.

model2=lm(Agriculture~Catholic, data)
model2
summary(model2)
#По результатам построения получаем: Agriculture = 0,22 * Catholic + 41,67
#Положительная зависимость (коэффициент перед  Catholic положительный).
#Коэффициент детерминации R^2=16%, следовательно, модель плохая, возможно, нужно построить другую, модель плохо описывает динамику переменной.
#Зависимость Agriculture от Catholic есть, т.к. есть две звездочки, регрессор хорошо описывает поведение переменной.
