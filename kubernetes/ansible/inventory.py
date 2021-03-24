#!/usr/bin/env python3
import os
import sys
import json as j
import subprocess
import click

def get_yc_json() -> str:
    """
    Запускает установленный и настроенный yc кли
    интерфейс для яндекс облока, получает на выходе json.
    """
    command_get_nodes = ['yc', 'compute', 'instance', 'list', '--format', 'json']
    result = subprocess.run(command_get_nodes, stdout=subprocess.PIPE)
    return j.loads(result.stdout)


def get_group_list(json) -> list:
    """
    Получает на вход json от yc
    Возвращает list со списком групп из json yc
    Имя группы берется из тега ansible_group
    """
    group_list = []
    for host_data in json:
        name = host_data['labels']['ansible_group']
        group_list.append(name)
    return group_list

def get_name_list(json) -> list:
    """
    Получает на вход json от yc
    Возвращает list со списком всех имен хостов из json yc
    Имя группы берется из тега ansible_name
    """
    name_list = []
    for host_data in json:
        name = host_data['labels']['ansible_name']
        name_list.append(name)
    return name_list

def get_ip_host(name, json) -> str:
    """
    Получает на вход json от yc и имя хоста
    Возвращает  NAT IP адрес с 1 интерфейса хоста
    """
    for host_data in json:
        host_name =  host_data['labels']['ansible_name']
        host_ip = host_data['network_interfaces'][0]['primary_v4_address']['one_to_one_nat']['address']
        if host_name == name:
            return host_ip
    return "127.0.0.1"

def get_list_host_to_group(group, json) -> list:
    """
    Получает на вход json от yc и имя группы
    Возвращает  list со списком хостов в группе
    """
    host_list = []
    for host_data in json:
        host_group = host_data['labels']['ansible_group']
        host_name = host_data['labels']['ansible_name']
        if host_group == group:
            host_list.append(host_name)
    return host_list


def get_vars_group(group, json) -> dict:
    """
    Принимает имя группы и json от  YC
    возвращает dict с переменными которые находятся в метках lable
    во всех хостах из группы с маской ansible_group_var_
    """
    ansible_var_template = 'ansible_group_var_'
    group_vars = dict()
    for host_data in json:
        host_lables = host_data['labels']
        group_name = host_data['labels']['ansible_group']
        if group_name == group:
            for key, value in host_lables.items():
                if key.startswith(ansible_var_template):
                    ansible_var_name = key.replace(ansible_var_template,'')
                    group_vars[ansible_var_name] = value
    return group_vars

def get_vars_host(host, json) -> dict:
    """
    Возвращает 'dict' все переменные в тегах c название включающим себя значение ansible_var_template
    по умолчанию 'ansible_host_var_'
    """
    ansible_var_template = 'ansible_host_var_'
    host_vars = dict()
    for host_data in json:
        host_lables = host_data['labels']
        host_name = host_data['labels']['ansible_name']
        if host_name == host:
            for key, value in host_lables.items():
                if key.startswith(ansible_var_template):
                    ansible_var_name = key.replace(ansible_var_template,'')
                    host_vars[ansible_var_name] = value
    return host_vars

def get_inventory_json(json) -> dict:
    """
    Получает на вход json от yc
    Возвращает  json c inventry для ansible
    """
    inventory = {}
    # добавляем группу all
    inventory['all'] = {}
    inventory['all']['children'] = []
    inventory['all']['children'].extend(["ungrouped"])
    inventory['all']['children'].extend(get_group_list(json))
    # Добавляем _meta
    inventory['_meta'] = {}
    inventory['_meta']['hostvars'] = {}
    for host in get_name_list(json=json):
        inventory['_meta']['hostvars'][host] = {}
        inventory['_meta']['hostvars'][host]['ansible_host'] = get_ip_host(name=host, json=json)
        inventory['_meta']['hostvars'][host].update(get_vars_host(host=host,json=json))
    for group in get_group_list(json):
        inventory[group] = {}
        inventory[group]['hosts'] = get_list_host_to_group( group=group, json=json)
        inventory[group]['vars'] = get_vars_group(group=group, json=json)

    return inventory

@click.command()
@click.option('--list', is_flag=True, help="print inventory")
def main(list) -> str:
    # create_parser.set_defaults(func=main )
    json = get_yc_json()
    inventory = get_inventory_json(json=json)
    print(j.dumps(inventory, sort_keys=True, indent=4))
    # get_vars_host(host="dbserver", json=json)

    sys.exit(0)

if __name__== "__main__":
    main()
