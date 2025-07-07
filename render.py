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
    template = get_template('./templates/3.1_ds_template.Rmd')
    
    dataset = open("./templates/3_dataset.Rmd", "r", encoding="utf8").read()

    rendered_page = template.render(data_dictionary=data_dictionary, stage="acc", dataset=dataset)

    # accuracy
    with open("./3.1_ds_acc.Rmd", 'w', encoding="utf8") as file:
        file.write(rendered_page)

    # speed
    rendered_page = template.render(data_dictionary=data_dictionary, stage="spd", dataset=dataset)

    with open("./3.1_ds_spd.Rmd", 'w', encoding="utf8") as file:
        file.write(rendered_page)


    template_group = get_template('./templates/3.2_ds_by_group_template.Rmd')
    rendered_page = template_group.render(data_dictionary=data_dictionary, group="stage", dataset=dataset)

    with open("./3.2_ds_by_stage.Rmd", 'w', encoding="utf8") as file:
        file.write(rendered_page)



    template_gender = get_template('./templates/3.3_ds_template_by_gender.Rmd')
    rendered_page = template_gender.render(data_dictionary=data_dictionary, stage="acc", group="gender", dataset=dataset)

    with open("./3.3_ds_acc_by_gender.Rmd", 'w', encoding="utf8") as file:
        file.write(rendered_page)


    template_gender = get_template('./templates/3.3_ds_template_by_gender.Rmd')
    rendered_page = template_gender.render(data_dictionary=data_dictionary, stage="spd", group="gender", dataset=dataset)

    with open("./3.3_ds_spd_by_gender.Rmd", 'w', encoding="utf8") as file:
        file.write(rendered_page)


    template_two_groups = get_template('./templates/3.4_ds_template_by_two_groups.Rmd')
    rendered_page = template_two_groups.render(data_dictionary=data_dictionary, group="gender", group2="stage", dataset=dataset)

    with open("./3.4_ds_by_stage_and_gender.Rmd", 'w', encoding="utf8") as file:
        file.write(rendered_page)


    ## DS hclusters acc
    template_group2 = get_template('./templates/4_ds_by_group_template2.Rmd')
    dataset_ca_acc = open("./templates/4_dataset_ca_acc.Rmd", "r", encoding="utf8").read()

    render_and_save_pages(template_group2, data_dictionary, dataset_ca_acc, "ds_acc_by", "all_hclust", 4.1)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_acc, "ds_acc_by", "notcorr_hclust", 4.1)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_acc, "ds_acc_by", "tdm_hclust", 4.1)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_acc, "ds_acc_by", "pauses_hclust", 4.1)

    ## Female acc
    dataset_ca_acc_female = open("./templates/4_dataset_ca_acc_female.Rmd", "r", encoding="utf8").read()
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_acc_female, "ds_acc_female_by", "all_hclust", 4.2)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_acc_female, "ds_acc_female_by", "notcorr_hclust", 4.2)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_acc_female, "ds_acc_female_by", "tdm_hclust", 4.2)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_acc_female, "ds_acc_female_by", "pauses_hclust", 4.2)

    ## Male acc
    dataset_ca_acc_male = open("./templates/4_dataset_ca_acc_male.Rmd", "r", encoding="utf8").read()
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_acc_male, "ds_acc_male_by", "all_hclust", 4.3)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_acc_male, "ds_acc_male_by", "notcorr_hclust", 4.3)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_acc_male, "ds_acc_male_by", "tdm_hclust", 4.3)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_acc_male, "ds_acc_male_by", "pauses_hclust", 4.3)


    # DS hclusters spd
    dataset_ca_spd = open("./templates/4_dataset_ca_spd.Rmd", "r", encoding="utf8").read()

    render_and_save_pages(template_group2, data_dictionary, dataset_ca_spd, "ds_spd_by", "all_hclust", 4.4)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_spd, "ds_spd_by", "notcorr_hclust", 4.4)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_spd, "ds_spd_by", "tdm_hclust", 4.4)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_spd, "ds_spd_by", "pauses_hclust", 4.4)

    ## Female spd
    dataset_ca_spd_female = open("./templates/4_dataset_ca_spd_female.Rmd", "r", encoding="utf8").read()
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_spd_female, "ds_spd_female_by", "all_hclust", 4.5)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_spd_female, "ds_spd_female_by", "notcorr_hclust", 4.5)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_spd_female, "ds_spd_female_by", "tdm_hclust", 4.5)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_spd_female, "ds_spd_female_by", "pauses_hclust", 4.5)

    ## Male spd
    dataset_ca_spd_male = open("./templates/4_dataset_ca_spd_male.Rmd", "r", encoding="utf8").read()
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_spd_male, "ds_spd_male_by", "all_hclust", 4.6)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_spd_male, "ds_spd_male_by", "notcorr_hclust", 4.6)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_spd_male, "ds_spd_male_by", "tdm_hclust", 4.6)
    render_and_save_pages(template_group2, data_dictionary, dataset_ca_spd_male, "ds_spd_male_by", "pauses_hclust", 4.6)


    ## Psy.test and AST clusters
    ### acc
    sp_data_dictionary = pd.read_excel("./data/sp_data_dictionary.xlsx").to_dict(orient='records')
    sp_template = get_template('./templates/5_sp_template.Rmd')
    dataset_sp_acc = open("./templates/5_dataset_sp_acc.Rmd", "r", encoding="utf8").read()

    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_acc, "sp_ds_acc_by", "all_hclust", 5.1)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_acc, "sp_ds_acc_by", "notcorr_hclust", 5.1)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_acc, "sp_ds_acc_by", "tdm_hclust", 5.1)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_acc, "sp_ds_acc_by", "pauses_hclust", 5.1)

    ### Female acc
    dataset_sp_acc_female = open("./templates/5_dataset_sp_acc_female.Rmd", "r", encoding="utf8").read()
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_acc_female, "sp_ds_acc_female_by", "all_hclust", 5.2)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_acc_female, "sp_ds_acc_female_by", "notcorr_hclust", 5.2)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_acc_female, "sp_ds_acc_female_by", "tdm_hclust", 5.2)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_acc_female, "sp_ds_acc_female_by", "pauses_hclust", 5.2)

    ### Male acc
    dataset_sp_acc_male = open("./templates/5_dataset_sp_acc_male.Rmd", "r", encoding="utf8").read()
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_acc_male, "sp_ds_acc_male_by", "all_hclust", 5.3)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_acc_male, "sp_ds_acc_male_by", "notcorr_hclust", 5.3)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_acc_male, "sp_ds_acc_male_by", "tdm_hclust", 5.3)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_acc_male, "sp_ds_acc_male_by", "pauses_hclust", 5.3)

    ### spd
    sp_data_dictionary = pd.read_excel("./data/sp_data_dictionary.xlsx").to_dict(orient='records')
    sp_template = get_template('./templates/5_sp_template.Rmd')
    dataset_sp_spd = open("./templates/5_dataset_sp_spd.Rmd", "r", encoding="utf8").read()

    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_spd, "sp_ds_spd_by", "all_hclust", 5.4)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_spd, "sp_ds_spd_by", "notcorr_hclust", 5.4)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_spd, "sp_ds_spd_by", "tdm_hclust", 5.4)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_spd, "sp_ds_spd_by", "pauses_hclust", 5.4)

    ### Female spd
    dataset_sp_spd_female = open("./templates/5_dataset_sp_spd_female.Rmd", "r", encoding="utf8").read()
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_spd_female, "sp_ds_spd_female_by", "all_hclust", 5.5)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_spd_female, "sp_ds_spd_female_by", "notcorr_hclust", 5.5)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_spd_female, "sp_ds_spd_female_by", "tdm_hclust", 5.5)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_spd_female, "sp_ds_spd_female_by", "pauses_hclust", 5.5)

    ### Male spd
    dataset_sp_spd_male = open("./templates/5_dataset_sp_spd_male.Rmd", "r", encoding="utf8").read()
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_spd_male, "sp_ds_spd_male_by", "all_hclust", 5.6)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_spd_male, "sp_ds_spd_male_by", "notcorr_hclust", 5.6)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_spd_male, "sp_ds_spd_male_by", "tdm_hclust", 5.6)
    render_and_save_pages(sp_template, sp_data_dictionary, dataset_sp_spd_male, "sp_ds_spd_male_by", "pauses_hclust", 5.6)

if __name__ == '__main__':
    main()