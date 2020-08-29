"""Скрипт для генерации имен, фамилий, email-ов, телефонных номеров, дат рождений,
пола (М, Ж), пароля, города.
Для получения списка имен, фамилий и городов использованы подвернувшиеся web страницы.
"""
import random
import requests
import datetime
from bs4 import BeautifulSoup
import translit #модуль, созданный для транслитерации кириллицы в латиницу. Необходим для создания email-адресов
import re

def generate_email(name, surname):
    domains = random.choice(['yandex', 'mail', 'bk', 'inbox', 'rambler'])
    email = (f'{translit.latinizator(name)}.{translit.latinizator(surname)}@{domains}.ru')
    return email

def generate_password():
    letters = 'qwertyuiopasdfghjklzxcvbnm0123456789'
    password = ''.join([random.sample(letters, 1)[0] for _ in range(random.randint(5, 10))])
    return password

def generate_name_surname_gender():
    """Функция для генерации имен, фамилий и выбора соответв. пола. Результатом работы функции является список вида: ['Имя', 'Фамилия', 'М/Ж']"""
    #выбраны сайты, на которых была обнаружена необх. информация:
    url_women = 'https://kakzovut.ru/woman.html'  # женские имена
    url_men = 'https://kakzovut.ru/man.html'  # мужские имена
    url_surname = 'http://chelny-izvest.ru/news/top5/54557-top-250-samykh-rasprostranennykh-familiy-naydi-svoyu' # фамилии

    #обработка страницы с фамилиями:
    all_surnames = BeautifulSoup(requests.get(url_surname).text, 'html.parser')
    surname_list = [(str(surname).split())[1][:-5] for surname in all_surnames.find_all('td') if
                    len((str(surname).split(' '))[1]) < 15] #создан список фамилий

    #рандомом выбираем один из двух url с именами
    url = random.choice([url_men, url_women])
    #обработка страницы с именами:
    all_names = BeautifulSoup(requests.get(url).text, 'html.parser')
    name_list = [tag.text for tag in all_names.find_all('div') if len(tag.text) >= 4 and len(tag.text) <= 7] #создан список имен

    #если был выбран url с женскими именами, то добавляем в результирующий список фамилию с дорисованной буквой "а" и полом Ж
    if url == url_women:
        return [random.choice(name_list), random.choice(surname_list) + 'a', 'Ж']
    #если был выбран второй url (c муж.именами), то оставляем фамлию без имз. и указываем пол М
    else:
        return [random.choice(name_list), random.choice(surname_list), 'М']

def generate_phone_number():
    code = ['903', '905', '985', '915', '926', '999']
    return f'+7({random.choice(code)}){random.randint(100, 999)}-{random.randint(10, 99)}-{random.randint(10, 99)}'

def generate_b_day():
    min_date = datetime.date(1960, 1, 1)
    max_date = datetime.date(2002, 1, 1)
    b_day = min_date + datetime.timedelta(days=random.randrange((max_date - min_date).days))
    birthday = f'{b_day.year}-{b_day.month}-{b_day.day}'
    return birthday

def generate_city():
    url = 'https://zen.yandex.ru/media/newsment/spisok-gorodovmillionnikov-rossii-na-2020-god-16-naselennyh-punktov-5e42af3e5e0d7416b977e030'
    page = BeautifulSoup(requests.get(url).text, 'html.parser')
    city_find = re.findall(r'[А-Я]\w+\s-\s\d', str(page))
    city_list = [city[:-4] for city in city_find if city[:-4] != 'Дону']
    return random.choice(city_list)

def get_user_data():
    """Функция, которая собирает готовый словарь, ктр. будет использоваться для загрузки данных в БД"""
    name_surname_gender = generate_name_surname_gender()

    user_data = {
        'email': generate_email(name_surname_gender[0], name_surname_gender[1]),
        'pass': generate_password(),
        'name': name_surname_gender[0],
        'surname': name_surname_gender[1],
        'gender': name_surname_gender[2],
        'phone': generate_phone_number(),
        'birthday': generate_b_day(),
        'hometown': generate_city(),
    }
    return user_data

if __name__ == '__main__':
    a = generate_name_surname_gender()
    print(get_user_data())
