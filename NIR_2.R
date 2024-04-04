library("lmtest")
library("GGally")
library("sandwich")
library("dplyr")
library("car")

#Очистка от записей с недостающими данными
data = na.omit(airquality)

#Проверка регрессоров на линейную зависимость
model1 = lm(Solar.R~Wind, data)  
summary(model1) #R^2=1% < 80% =>  линейно независимые регрессоры

model2 = lm(Wind ~ Temp, data)
summary(model2) #R^2=24%< 80% =>  линейно независимые регрессоры

model3 = lm(Temp ~ Solar.R, data)
summary(model3) #R^2=8%< 80% =>  линейно независимые регрессоры

#Все регрессоры подходят для построения моделей

#Построение модели
model4=lm(Ozone ~ Solar.R+Temp+Wind, data)
summary(model4)
#R^2 = 59%, P-статистика у всех регрессоров небольшая

#Добавление квадратов, логарифмов и произведений регрессоров
model5=lm(Ozone ~ Solar.R+Temp+Wind+I(Solar.R^2)+I(Temp^2)+I(Wind^2)+I(Solar.R*Temp)+I(Wind*Temp)+I(Solar.R*Wind)+log(Solar.R)+log(Temp)+log(Wind), data)
summary(model5)
vif(model5)

#Поочередное удаление регрессоров с высоким VIF
model5.1=lm(Ozone ~ Solar.R+Wind+I(Solar.R^2)+I(Temp^2)+I(Wind^2)+I(Solar.R*Temp)+I(Wind*Temp)+I(Solar.R*Wind)+log(Solar.R)+log(Temp)+log(Wind), data)
summary(model5.1)
vif(model5.1)

model5.2=lm(Ozone ~ Solar.R+I(Solar.R^2)+I(Temp^2)+I(Wind^2)+I(Solar.R*Temp)+I(Wind*Temp)+I(Solar.R*Wind)+log(Solar.R)+log(Temp)+log(Wind), data)
summary(model5.2)
vif(model5.2)

model5.3=lm(Ozone ~ I(Solar.R^2)+I(Temp^2)+I(Wind^2)+I(Solar.R*Temp)+I(Wind*Temp)+I(Solar.R*Wind)+log(Solar.R)+log(Temp)+log(Wind), data)
summary(model5.3)
vif(model5.3)

model5.4=lm(Ozone ~ I(Solar.R^2)+I(Temp^2)+I(Wind^2)+I(Solar.R*Temp)+I(Solar.R*Wind)+log(Solar.R)+log(Temp)+log(Wind), data)
summary(model5.4)
vif(model5.4)

model5.5=lm(Ozone ~ I(Solar.R^2)+I(Wind^2)+I(Solar.R*Temp)+I(Solar.R*Wind)+log(Solar.R)+log(Temp)+log(Wind), data)
summary(model5.5)
vif(model5.5)

model5.6=lm(Ozone ~ I(Solar.R^2)+I(Wind^2)+I(Solar.R*Wind)+log(Solar.R)+log(Temp)+log(Wind), data)
summary(model5.6)
vif(model5.6)

model5.7=lm(Ozone ~ I(Solar.R^2)+I(Wind^2)+log(Solar.R)+log(Temp)+log(Wind), data)
summary(model5.7)
vif(model5.7)
#R^2=66%

#Выбор лучшей модели (по результатам это model5.7)
waldtest(model5.6, model5.7)

#Построение парных регрессий с использованием подходящих регрессоров
modelka1=lm(Ozone~I(Solar.R^2), data)
summary(modelka1)
#Ozone=2.868e-04(I(Solar.R^2)+2.994e+01 
#Коэффициент преред I(Solar.R^2) положительный
#R^2=7% => модель плохо описывает динамику переменной
#Регрессор хорошо описывает поведение перерменной, т.к. две звездочки

modelka2=lm(Ozone~I(Wind^2), data)
summary(modelka2)
#Ozone=-0.22(I(Wind^2)+66.26
#Коэффициент преред I(Wind^2) отрицательный
#R^2=26% => модель плохо описывает динамику переменной
#Регрессор хорошо описывает поведение перерменной, т.к. три звездочки 

modelka3=lm(Ozone~log(Solar.R), data)
summary(modelka3)
#Ozone=14.94(log(Solar.R))-32.30
#Коэффициент преред log(Solar.R) положительный
#R^2=15% => модель плохо описывает динамику переменной
#Регрессор хорошо описывает поведение перерменной, т.к. три звездочки 

modelka4=lm(Ozone~log(Temp), data)
summary(modelka4)
#Ozone=179.56(log(Temp))-738.34
#Коэффициент преред log(Temp) положительный
#R^2=46% => модель хорошо описывает динамику переменной
#Регрессор хорошо описывает поведение перерменной, т.к. три звездочки 

modelka5=lm(Ozone~log(Wind), data)
summary(modelka5)
#Ozone=-57.92(log(Wind))+171.05
#Коэффициент преред log(Wind) отрицательный
#R^2=47% => модель хорошо описывает динамику переменной
#Регрессор хорошо описывает поведение перерменной, т.к. три звездочки 

