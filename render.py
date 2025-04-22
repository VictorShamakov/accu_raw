import pandas as pd
from jinja2 import Environment, FileSystemLoader, select_autoescape


def get_template(filepath):
    env = Environment(
        loader=FileSystemLoader('.'),
        autoescape=select_autoescape(['html', 'xml'])
    )

    template = env.get_template(filepath)

    return template


def main():
    data_dictionary = pd.read_excel("./data/data_dictionary.xlsx").to_dict(orient='records')
    template = get_template('./templates/desc_stat_template.Rmd')

    rendered_page = template.render(data_dictionary=data_dictionary, stage="acc")

    # accuracy
    with open("./3.1_desc_stat_accuracy.Rmd", 'w', encoding="utf8") as file:
        file.write(rendered_page)

    # speed
    rendered_page = template.render(data_dictionary=data_dictionary, stage="spd")

    with open("./3.1_desc_stat_speed.Rmd", 'w', encoding="utf8") as file:
        file.write(rendered_page)

if __name__ == '__main__':
    main()