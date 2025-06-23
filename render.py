import pandas as pd
from jinja2 import Environment, FileSystemLoader, select_autoescape


def get_template(filepath):
    env = Environment(
        loader=FileSystemLoader('.'),
        autoescape=select_autoescape(['html', 'xml'])
    )

    template = env.get_template(filepath)

    return template


def render_and_save_pages(template, data_dictionary, dataset, file_name, cluster_name, number):
    for n in range(2, 10):
        rendered_page = template.render(data_dictionary=data_dictionary, group=cluster_name + str(n), dataset=dataset)
        filename = f"./{number}.{n - 1}_{file_name}_{cluster_name}{n}.Rmd"
        with open(filename, 'w', encoding="utf8") as file:
            file.write(rendered_page)



def main():
    data_dictionary = pd.read_excel("./data/data_dictionary.xlsx").to_dict(orient='records')
    template = get_template('./templates/desc_stat_template.Rmd')
    
    dataset = open("./templates/dataset.Rmd", "r", encoding="utf8").read()

    rendered_page = template.render(data_dictionary=data_dictionary, stage="acc", dataset=dataset)

    # accuracy
    with open("./3.1_desc_stat_accuracy.Rmd", 'w', encoding="utf8") as file:
        file.write(rendered_page)

    # speed
    rendered_page = template.render(data_dictionary=data_dictionary, stage="spd", dataset=dataset)

    with open("./3.2_desc_stat_speed.Rmd", 'w', encoding="utf8") as file:
        file.write(rendered_page)


    template_group = get_template('./templates/desc_stat_by_group_template.Rmd')
    rendered_page = template_group.render(data_dictionary=data_dictionary, group="stage", dataset=dataset)

    with open("./3.3_desc_stat_by_stage.Rmd", 'w', encoding="utf8") as file:
        file.write(rendered_page)



    template_gender = get_template('./templates/desc_stat_template_by_gender.Rmd')
    rendered_page = template_gender.render(data_dictionary=data_dictionary, stage="acc", group="gender", dataset=dataset)

    with open("./3.4_desc_stat_acc_by_gender.Rmd", 'w', encoding="utf8") as file:
        file.write(rendered_page)


    template_gender = get_template('./templates/desc_stat_template_by_gender.Rmd')
    rendered_page = template_gender.render(data_dictionary=data_dictionary, stage="spd", group="gender", dataset=dataset)

    with open("./3.5_desc_stat_spd_by_gender.Rmd", 'w', encoding="utf8") as file:
        file.write(rendered_page)


    template_two_groups = get_template('./templates/desc_stat_template_by_two_groups.Rmd')
    rendered_page = template_two_groups.render(data_dictionary=data_dictionary, group="gender", group2="stage", dataset=dataset)

    with open("./3.6_desc_stat_by_stage_and_gender.Rmd", 'w', encoding="utf8") as file:
        file.write(rendered_page)


    ## DS hclusters
    template_group2 = get_template('./templates/desc_stat_by_group_template2.Rmd')
    dataset_ca = open("./templates/dataset_ca.Rmd", "r", encoding="utf8").read()

    render_and_save_pages(template_group2, data_dictionary, dataset_ca, "desc_stat_by", "all_hclust", 4)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca, "desc_stat_by", "notcorr_hclust", 4)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca, "desc_stat_by", "tdm_hclust", 4)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca, "desc_stat_by", "pauses_hclust", 4)

    ## Female
    dataset_ca_female = open("./templates/dataset_ca_female.Rmd", "r", encoding="utf8").read()
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_female, "female_desc_stat_by", "all_hclust", 4)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_female, "female_desc_stat_by", "notcorr_hclust", 4)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_female, "female_desc_stat_by", "tdm_hclust", 4)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_female, "female_desc_stat_by", "pauses_hclust", 4)

    ## Male
    dataset_ca_male = open("./templates/dataset_ca_male.Rmd", "r", encoding="utf8").read()
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_male, "male_desc_stat_by", "all_hclust", 4)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_male, "male_desc_stat_by", "notcorr_hclust", 4)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_male, "male_desc_stat_by", "tdm_hclust", 4)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_male, "male_desc_stat_by", "pauses_hclust", 4)



    ## Psy.test and AST clusters
    sp_data_dictionary = pd.read_excel("./data/sp_data_dictionary.xlsx").to_dict(orient='records')
    ast_template = get_template('./templates/ast_template.Rmd')
    dataset_sp = open("./templates/dataset_sp.Rmd", "r", encoding="utf8").read()

    for n in range(2, 10):
        rendered_page = ast_template.render(data_dictionary=sp_data_dictionary, dataset=dataset_sp, group="all_hclust" + str(n))
        with open("./5." + str((n - 1)) + "_sp_desc_stat_by_all_hclust" + str(n) + ".Rmd", 'w', encoding="utf8") as file:
            file.write(rendered_page)

    for n in range(2, 10):
        rendered_page = ast_template.render(data_dictionary=sp_data_dictionary, dataset=dataset_sp, group="notcorr_hclust" + str(n))
        with open("./5." + str((n - 1)) + "_sp_desc_stat_by_notcorr_hclust" + str(n) + ".Rmd", 'w', encoding="utf8") as file:
            file.write(rendered_page)

    for n in range(2, 10):
        rendered_page = ast_template.render(data_dictionary=sp_data_dictionary, dataset=dataset_sp, group="tdm_hclust" + str(n))
        with open("./5." + str((n - 1)) + "_sp_desc_stat_by_tdm_hclust" + str(n) + ".Rmd", 'w', encoding="utf8") as file:
            file.write(rendered_page)

    for n in range(2, 10):
        rendered_page = ast_template.render(data_dictionary=sp_data_dictionary, dataset=dataset_sp, group="pauses_hclust" + str(n))
        with open("./5." + str((n - 1)) + "_sp_desc_stat_by_pauses_hclust" + str(n) + ".Rmd", 'w', encoding="utf8") as file:
            file.write(rendered_page)

    #Female
    dataset_sp_female = open("./templates/dataset_sp_female.Rmd", "r", encoding="utf8").read()
    for n in range(2, 10):
        rendered_page = ast_template.render(data_dictionary=sp_data_dictionary, dataset=dataset_sp_female, group="all_hclust" + str(n))
        with open("./5." + str((n - 1)) + "_female_sp_desc_stat_by_all_hclust" + str(n) + ".Rmd", 'w', encoding="utf8") as file:
            file.write(rendered_page)

    for n in range(2, 10):
        rendered_page = ast_template.render(data_dictionary=sp_data_dictionary, dataset=dataset_sp_female, group="notcorr_hclust" + str(n))
        with open("./5." + str((n - 1)) + "_female_sp_desc_stat_by_notcorr_hclust" + str(n) + ".Rmd", 'w', encoding="utf8") as file:
            file.write(rendered_page)

    for n in range(2, 10):
        rendered_page = ast_template.render(data_dictionary=sp_data_dictionary, dataset=dataset_sp_female, group="tdm_hclust" + str(n))
        with open("./5." + str((n - 1)) + "_female_sp_desc_stat_by_tdm_hclust" + str(n) + ".Rmd", 'w', encoding="utf8") as file:
            file.write(rendered_page)

    for n in range(2, 10):
        rendered_page = ast_template.render(data_dictionary=sp_data_dictionary, dataset=dataset_sp_female, group="pauses_hclust" + str(n))
        with open("./5." + str((n - 1)) + "_female_sp_desc_stat_by_pauses_hclust" + str(n) + ".Rmd", 'w', encoding="utf8") as file:
            file.write(rendered_page)

    #Male
    dataset_sp_male = open("./templates/dataset_sp_male.Rmd", "r", encoding="utf8").read()
    for n in range(2, 10):
        rendered_page = ast_template.render(data_dictionary=sp_data_dictionary, dataset=dataset_sp_male, group="all_hclust" + str(n))
        with open("./5." + str((n - 1)) + "_male_sp_desc_stat_by_all_hclust" + str(n) + ".Rmd", 'w', encoding="utf8") as file:
            file.write(rendered_page)

    for n in range(2, 10):
        rendered_page = ast_template.render(data_dictionary=sp_data_dictionary, dataset=dataset_sp_male, group="notcorr_hclust" + str(n))
        with open("./5." + str((n - 1)) + "_male_sp_desc_stat_by_notcorr_hclust" + str(n) + ".Rmd", 'w', encoding="utf8") as file:
            file.write(rendered_page)

    for n in range(2, 10):
        rendered_page = ast_template.render(data_dictionary=sp_data_dictionary, dataset=dataset_sp_male, group="tdm_hclust" + str(n))
        with open("./5." + str((n - 1)) + "_male_sp_desc_stat_by_tdm_hclust" + str(n) + ".Rmd", 'w', encoding="utf8") as file:
            file.write(rendered_page)

    for n in range(2, 10):
        rendered_page = ast_template.render(data_dictionary=sp_data_dictionary, dataset=dataset_sp_male, group="pauses_hclust" + str(n))
        with open("./5." + str((n - 1)) + "_male_sp_desc_stat_by_pauses_hclust" + str(n) + ".Rmd", 'w', encoding="utf8") as file:
            file.write(rendered_page)


if __name__ == '__main__':
    main()