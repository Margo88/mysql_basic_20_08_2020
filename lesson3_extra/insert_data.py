"""Скрипт для записи сгенерированных данных в таблицу БД mysql
"""

import pymysql
import generate_dataV2 as gd #скрипт, созданный для генерации данных

#подключаемся к БД
connection = pymysql.connect(
    host = 'localhost',
    user = 'root',
    password = 'введите пароль',
    db = 'введите название БД'
)

#спросим максимальный id из существующих
with connection.cursor() as cursor:
    cursor.execute('SELECT max(id) FROM users')
    answer = cursor.fetchone() #type(anwer) >>> tuple

#если записи есть, запишем в интератор максимальный id
if answer[0]: #ответ от БД был получен в tuple, поэтому забираем его единственное значение
    i = answer[0]
else:
    i = 0 #если БД пустая, запишем в итератор 0

n = int(input('Сколько строк будем вносить? ')) + i #получаем от пользователя количество строк n, ктр запишем в БД

while i < n:
    values = gd.get_user_data() #генерируем данные с помощью созданного модуля. type(values) >>> dict
    sql = 'INSERT INTO users (id, email, pass, name, surname, phone, gender, birthday, hometown) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)'
    with connection.cursor() as cursor:
        i += 1
        #подставляем значения в sql запрос последовательно. Сгенерированный словарь данных имеет одноименные ключи:
        cursor.execute(sql, (i, values['email'], values['pass'], values['name'], values['surname'], values['phone'], values['gender'], values['birthday'], values['hometown']))
        connection.commit()

connection.close()