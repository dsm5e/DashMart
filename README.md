# DashMart 
![Preview](https://github.com/MaximGoryachkin/NewsToDay/assets/89079058/a908800a-c864-4ee8-bdb3-b6af426e1d1c)

### Development Team: 
[![Viktor Balkonskiy](https://img.shields.io/badge/Viktor%20Balkonskiy-06969F?style=for-the-badge&logo=github)](https://github.com/viktorporch)
[![Ivan Naumenko](https://img.shields.io/badge/Ivan%20Naumenko-065D8E?style=for-the-badge&logo=github)](https://github.com/NaumenkoVanya)
[![Ilya Paddubny](https://img.shields.io/badge/Ivan%20Naumenko-065D8E?style=for-the-badge&logo=github)](https://github.com/ilyapaddubny)
[![Vladislav Golyakov](https://img.shields.io/badge/dsm5e-red)](https://github.com/dsm5e)

https://github.com/ilyapaddubny


# CHALLENGE №2 “NewsToDay” [(Swift Marathon 11)](https://t.me/devrush_community/13663)
* Проект на Swift 5, SwiftUI
* Минимальная поддерживаемая iOS – 15
* Только iPhone и портретная ориентация экрана.

---

## Базовое задание:

### Главный экран

* На главном экране получаем данные по популярным новостям в разных категориях.
* Реализовали Search-Bar и поиск по запросу из API
* Реализовали горизонтальный скролл с категориями (тэгами).
* Реализовали возможность добавления новостей в “Избранное”.

### Экран "Избранное"

* При переходе на данный экран, пользователь может управлять статьями, которые добавил в Избранное.

### Экран со статьей

* На данном экране отображается картинка статьи (если она есть), также все известные данные: имя автора, заголовок, категория (тэг), издание, из которого эта статья взята.
* Из данного экрана можно вернуться назад, а также сохранить статью в Избранное, либо удалить из Избранного повторным нажатие на кнопку, отвечающую за добавление/удаление.

### Экран "Личный кабинет"

* Данные пользователя: персональное фото, имя, почта (рандомные данные).
* Реализована вкладка с Положениями и условиями (отдельный экран).
* Возможность выйти из личного кабинета, при её нажатии пользователь попадает на экран Onboarding’а.

 ### UITabBarController

 * В UITabBarController реализация как на макете, с переходом по каждой вкладке ТабБара (вкладка “Категорий” относится к Продвинутому заданию).

---
## Продвинутое задание

### Экран "Личный кабинет"

* Реализована возможность регистрации и входа по почте и паролю.

### Экран с выбором категорий (при первом входе в приложение)

* Данный экран предоставляется пользователю после регистрации в приложении.
* Пользователю представляется сетка с вариантами категорий, предлагаемых API. Пользователь имеет возможность выбрать те категории, которые его интересуют больше всего.
* В зависимости от интересов пользователя в главном экране выстраивается сетка с категориями новостей, а также выводиться рекомендации для пользователя.

### Главный экран

* Реализована отдельная категория “Рекомендации для Вас”, чтобы пользователю выводились лучшие статьи в категориях, которые он выбрал на экране с категориями.

### Экран категорий (переход в ТабБаре)

* На данном экране пользователь может сменить выбор предпочитаемых тем, на основании которых формируется список для отдельной категорий на главном экране “Рекомендации для Вас”.

### Личный кабинет

* Подключена локализация с возможностью смены языка приложения.
* Реализована переключение между русским и английским языками.

### Избранное

* Реализовано сохранение данных в “Избранном”, чтобы после закрытия/открытия приложения “Избранное” сохраняло выбор новостей пользователя.

---
