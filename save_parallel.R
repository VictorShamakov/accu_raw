rm(list=ls())
library(parallel)
# Функция для рендеринга одного файла
render_file <- function(file) {
  rmarkdown::render(input = file$input, output_file = file$output)
}
"%+%" <- function(...){paste0(...)}


## Описательная статистика
### Параллельно
files_ds <- list(
  list(input = './3.1_ds_acc.Rmd', output = './reports/3.1_ds_acc.html'),
  list(input = './3.1_ds_spd.Rmd', output = './reports/3.1_ds_spd.html'),
  list(input = './3.2_ds_by_stage.Rmd', output = './reports/3.2_ds_by_stage.html'),
  list(input = './3.3_ds_acc_by_gender.Rmd', output = './reports/3.3_ds_acc_by_gender.html'),
  list(input = './3.3_ds_spd_by_gender.Rmd', output = './reports/3.3_ds_spd_by_gender.html'),
  list(input = './3.4_ds_by_stage_and_gender.Rmd', output = './reports/3.4_ds_by_stage_and_gender.html')
)


## Кластерный анализ
files_ca <- list(
  list(input = './4.0.1_ca_acc.Rmd', output = './reports/4.0.1_ca_acc.html'),
  # list(input = './4.0.2_female_ca_acc.Rmd', output = './reports/4.0.2_female_ca_acc.html'),
  # list(input = './4.0.3_male_ca_acc.Rmd', output = './reports/4.0.3_male_ca_acc.html'),
  list(input = './4.0.4_ca_spd.Rmd', output = './reports/4.0.4_ca_spd.html')
  # list(input = './4.0.5_female_ca_spd.Rmd', output = './reports/4.0.5_female_ca_spd.html'),
  # list(input = './4.0.6_male_ca_spd.Rmd', output = './reports/4.0.6_male_ca_spd.html')
)


files_ds_hclust <- list(
  ## Описательная статистика кластеров
  ## Все респонденты. Задание на точность.
  list(input = './4.1.1_ds_acc_by_all_hclust2.Rmd', output = './reports/4.1.1_ds_acc_by_all_hclust2.html'),
  list(input = './4.1.2_ds_acc_by_all_hclust3.Rmd', output = './reports/4.1.2_ds_acc_by_all_hclust3.html'),
  list(input = './4.1.3_ds_acc_by_all_hclust4.Rmd', output = './reports/4.1.3_ds_acc_by_all_hclust4.html'),
  list(input = './4.1.4_ds_acc_by_all_hclust5.Rmd', output = './reports/4.1.4_ds_acc_by_all_hclust5.html'),
  
  list(input = './4.1.1_ds_acc_by_notcorr_hclust2.Rmd', output = './reports/4.1.1_ds_acc_by_notcorr_hclust2.html'),
  list(input = './4.1.2_ds_acc_by_notcorr_hclust3.Rmd', output = './reports/4.1.2_ds_acc_by_notcorr_hclust3.html'),
  list(input = './4.1.3_ds_acc_by_notcorr_hclust4.Rmd', output = './reports/4.1.3_ds_acc_by_notcorr_hclust4.html'),
  list(input = './4.1.4_ds_acc_by_notcorr_hclust5.Rmd', output = './reports/4.1.4_ds_acc_by_notcorr_hclust5.html'),
  
  list(input = './4.1.1_ds_acc_by_tdm_hclust2.Rmd', output = './reports/4.1.1_ds_acc_by_tdm_hclust2.html'),
  list(input = './4.1.2_ds_acc_by_tdm_hclust3.Rmd', output = './reports/4.1.2_ds_acc_by_tdm_hclust3.html'),
  list(input = './4.1.3_ds_acc_by_tdm_hclust4.Rmd', output = './reports/4.1.3_ds_acc_by_tdm_hclust4.html'),
  list(input = './4.1.4_ds_acc_by_tdm_hclust5.Rmd', output = './reports/4.1.4_ds_acc_by_tdm_hclust5.html'),
  
  list(input = './4.1.1_ds_acc_by_pauses_hclust2.Rmd', output = './reports/4.1.1_ds_acc_by_pauses_hclust2.html'),
  list(input = './4.1.2_ds_acc_by_pauses_hclust3.Rmd', output = './reports/4.1.2_ds_acc_by_pauses_hclust3.html'),
  list(input = './4.1.3_ds_acc_by_pauses_hclust4.Rmd', output = './reports/4.1.3_ds_acc_by_pauses_hclust4.html'),
  list(input = './4.1.4_ds_acc_by_pauses_hclust5.Rmd', output = './reports/4.1.4_ds_acc_by_pauses_hclust5.html'),
  
  list(input = './4.1.1_ds_acc_by_tdmp_hclust2.Rmd', output = './reports/4.1.1_ds_acc_by_tdmp_hclust2.html'),
  list(input = './4.1.2_ds_acc_by_tdmp_hclust3.Rmd', output = './reports/4.1.2_ds_acc_by_tdmp_hclust3.html'),
  list(input = './4.1.3_ds_acc_by_tdmp_hclust4.Rmd', output = './reports/4.1.3_ds_acc_by_tdmp_hclust4.html'),
  list(input = './4.1.4_ds_acc_by_tdmp_hclust5.Rmd', output = './reports/4.1.4_ds_acc_by_tdmp_hclust5.html'),
  
  # ## Женщины acc
  # list(input = './4.2.1_ds_acc_female_by_all_hclust2.Rmd', output = './reports/4.2.1_ds_acc_female_by_all_hclust2.html'),
  # list(input = './4.2.2_ds_acc_female_by_all_hclust3.Rmd', output = './reports/4.2.2_ds_acc_female_by_all_hclust3.html'),
  # list(input = './4.2.3_ds_acc_female_by_all_hclust4.Rmd', output = './reports/4.2.3_ds_acc_female_by_all_hclust4.html'),
  # list(input = './4.2.4_ds_acc_female_by_all_hclust5.Rmd', output = './reports/4.2.4_ds_acc_female_by_all_hclust5.html'),
  # 
  # list(input = './4.2.1_ds_acc_female_by_notcorr_hclust2.Rmd', output = './reports/4.2.1_ds_acc_female_by_notcorr_hclust2.html'),
  # list(input = './4.2.2_ds_acc_female_by_notcorr_hclust3.Rmd', output = './reports/4.2.2_ds_acc_female_by_notcorr_hclust3.html'),
  # list(input = './4.2.3_ds_acc_female_by_notcorr_hclust4.Rmd', output = './reports/4.2.3_ds_acc_female_by_notcorr_hclust4.html'),
  # list(input = './4.2.4_ds_acc_female_by_notcorr_hclust5.Rmd', output = './reports/4.2.4_ds_acc_female_by_notcorr_hclust5.html'),
  # 
  # list(input = './4.2.1_ds_acc_female_by_tdm_hclust2.Rmd', output = './reports/4.2.1_ds_acc_female_by_tdm_hclust2.html'),
  # list(input = './4.2.2_ds_acc_female_by_tdm_hclust3.Rmd', output = './reports/4.2.2_ds_acc_female_by_tdm_hclust3.html'),
  # list(input = './4.2.3_ds_acc_female_by_tdm_hclust4.Rmd', output = './reports/4.2.3_ds_acc_female_by_tdm_hclust4.html'),
  # list(input = './4.2.4_ds_acc_female_by_tdm_hclust5.Rmd', output = './reports/4.2.4_ds_acc_female_by_tdm_hclust5.html'),
  # 
  # list(input = './4.2.1_ds_acc_female_by_pauses_hclust2.Rmd', output = './reports/4.2.1_ds_acc_female_by_pauses_hclust2.html'),
  # list(input = './4.2.2_ds_acc_female_by_pauses_hclust3.Rmd', output = './reports/4.2.2_ds_acc_female_by_pauses_hclust3.html'),
  # list(input = './4.2.3_ds_acc_female_by_pauses_hclust4.Rmd', output = './reports/4.2.3_ds_acc_female_by_pauses_hclust4.html'),
  # list(input = './4.2.4_ds_acc_female_by_pauses_hclust5.Rmd', output = './reports/4.2.4_ds_acc_female_by_pauses_hclust5.html'),
  # 
  # ## Мужчины acc
  # list(input = './4.3.1_ds_acc_male_by_all_hclust2.Rmd', output = './reports/4.3.1_ds_acc_male_by_all_hclust2.html'),
  # list(input = './4.3.2_ds_acc_male_by_all_hclust3.Rmd', output = './reports/4.3.2_ds_acc_male_by_all_hclust3.html'),
  # list(input = './4.3.3_ds_acc_male_by_all_hclust4.Rmd', output = './reports/4.3.3_ds_acc_male_by_all_hclust4.html'),
  # list(input = './4.3.4_ds_acc_male_by_all_hclust5.Rmd', output = './reports/4.3.4_ds_acc_male_by_all_hclust5.html'),
  # 
  # list(input = './4.3.1_ds_acc_male_by_notcorr_hclust2.Rmd', output = './reports/4.3.1_ds_acc_male_by_notcorr_hclust2.html'),
  # list(input = './4.3.2_ds_acc_male_by_notcorr_hclust3.Rmd', output = './reports/4.3.2_ds_acc_male_by_notcorr_hclust3.html'),
  # list(input = './4.3.3_ds_acc_male_by_notcorr_hclust4.Rmd', output = './reports/4.3.3_ds_acc_male_by_notcorr_hclust4.html'),
  # list(input = './4.3.4_ds_acc_male_by_notcorr_hclust5.Rmd', output = './reports/4.3.4_ds_acc_male_by_notcorr_hclust5.html'),
  # 
  # list(input = './4.3.1_ds_acc_male_by_tdm_hclust2.Rmd', output = './reports/4.3.1_ds_acc_male_by_tdm_hclust2.html'),
  # list(input = './4.3.2_ds_acc_male_by_tdm_hclust3.Rmd', output = './reports/4.3.2_ds_acc_male_by_tdm_hclust3.html'),
  # list(input = './4.3.3_ds_acc_male_by_tdm_hclust4.Rmd', output = './reports/4.3.3_ds_acc_male_by_tdm_hclust4.html'),
  # list(input = './4.3.4_ds_acc_male_by_tdm_hclust5.Rmd', output = './reports/4.3.4_ds_acc_male_by_tdm_hclust5.html'),
  # 
  # list(input = './4.3.1_ds_acc_male_by_pauses_hclust2.Rmd', output = './reports/4.3.1_ds_acc_male_by_pauses_hclust2.html'),
  # list(input = './4.3.2_ds_acc_male_by_pauses_hclust3.Rmd', output = './reports/4.3.2_ds_acc_male_by_pauses_hclust3.html'),
  # list(input = './4.3.3_ds_acc_male_by_pauses_hclust4.Rmd', output = './reports/4.3.3_ds_acc_male_by_pauses_hclust4.html'),
  # list(input = './4.3.4_ds_acc_male_by_pauses_hclust5.Rmd', output = './reports/4.3.4_ds_acc_male_by_pauses_hclust5.html'),
  
  ## Все респонденты. Задание на скорость
  list(input = './4.4.1_ds_spd_by_all_hclust2.Rmd', output = './reports/4.4.1_ds_spd_by_all_hclust2.html'),
  list(input = './4.4.2_ds_spd_by_all_hclust3.Rmd', output = './reports/4.4.2_ds_spd_by_all_hclust3.html'),
  list(input = './4.4.3_ds_spd_by_all_hclust4.Rmd', output = './reports/4.4.3_ds_spd_by_all_hclust4.html'),
  list(input = './4.4.4_ds_spd_by_all_hclust5.Rmd', output = './reports/4.4.4_ds_spd_by_all_hclust5.html'),
  
  list(input = './4.4.1_ds_spd_by_notcorr_hclust2.Rmd', output = './reports/4.4.1_ds_spd_by_notcorr_hclust2.html'),
  list(input = './4.4.2_ds_spd_by_notcorr_hclust3.Rmd', output = './reports/4.4.2_ds_spd_by_notcorr_hclust3.html'),
  list(input = './4.4.3_ds_spd_by_notcorr_hclust4.Rmd', output = './reports/4.4.3_ds_spd_by_notcorr_hclust4.html'),
  list(input = './4.4.4_ds_spd_by_notcorr_hclust5.Rmd', output = './reports/4.4.4_ds_spd_by_notcorr_hclust5.html'),
  
  list(input = './4.4.1_ds_spd_by_tdm_hclust2.Rmd', output = './reports/4.4.1_ds_spd_by_tdm_hclust2.html'),
  list(input = './4.4.2_ds_spd_by_tdm_hclust3.Rmd', output = './reports/4.4.2_ds_spd_by_tdm_hclust3.html'),
  list(input = './4.4.3_ds_spd_by_tdm_hclust4.Rmd', output = './reports/4.4.3_ds_spd_by_tdm_hclust4.html'),
  list(input = './4.4.4_ds_spd_by_tdm_hclust5.Rmd', output = './reports/4.4.4_ds_spd_by_tdm_hclust5.html'),
  
  list(input = './4.4.1_ds_spd_by_pauses_hclust2.Rmd', output = './reports/4.4.1_ds_spd_by_pauses_hclust2.html'),
  list(input = './4.4.2_ds_spd_by_pauses_hclust3.Rmd', output = './reports/4.4.2_ds_spd_by_pauses_hclust3.html'),
  list(input = './4.4.3_ds_spd_by_pauses_hclust4.Rmd', output = './reports/4.4.3_ds_spd_by_pauses_hclust4.html'),
  list(input = './4.4.4_ds_spd_by_pauses_hclust5.Rmd', output = './reports/4.4.4_ds_spd_by_pauses_hclust5.html'),
  
  list(input = './4.4.1_ds_spd_by_tdmp_hclust2.Rmd', output = './reports/4.4.1_ds_spd_by_tdmp_hclust2.html'),
  list(input = './4.4.2_ds_spd_by_tdmp_hclust3.Rmd', output = './reports/4.4.2_ds_spd_by_tdmp_hclust3.html'),
  list(input = './4.4.3_ds_spd_by_tdmp_hclust4.Rmd', output = './reports/4.4.3_ds_spd_by_tdmp_hclust4.html'),
  list(input = './4.4.4_ds_spd_by_tdmp_hclust5.Rmd', output = './reports/4.4.4_ds_spd_by_tdmp_hclust5.html')
  
  # ## Женщины spd
  # list(input = './4.5.1_ds_spd_female_by_all_hclust2.Rmd', output = './reports/4.5.1_ds_spd_female_by_all_hclust2.html'),
  # list(input = './4.5.2_ds_spd_female_by_all_hclust3.Rmd', output = './reports/4.5.2_ds_spd_female_by_all_hclust3.html'),
  # list(input = './4.5.3_ds_spd_female_by_all_hclust4.Rmd', output = './reports/4.5.3_ds_spd_female_by_all_hclust4.html'),
  # list(input = './4.5.4_ds_spd_female_by_all_hclust5.Rmd', output = './reports/4.5.4_ds_spd_female_by_all_hclust5.html'),
  # 
  # list(input = './4.5.1_ds_spd_female_by_notcorr_hclust2.Rmd', output = './reports/4.5.1_ds_spd_female_by_notcorr_hclust2.html'),
  # list(input = './4.5.2_ds_spd_female_by_notcorr_hclust3.Rmd', output = './reports/4.5.2_ds_spd_female_by_notcorr_hclust3.html'),
  # list(input = './4.5.3_ds_spd_female_by_notcorr_hclust4.Rmd', output = './reports/4.5.3_ds_spd_female_by_notcorr_hclust4.html'),
  # list(input = './4.5.4_ds_spd_female_by_notcorr_hclust5.Rmd', output = './reports/4.5.4_ds_spd_female_by_notcorr_hclust5.html'),
  # 
  # list(input = './4.5.1_ds_spd_female_by_tdm_hclust2.Rmd', output = './reports/4.5.1_ds_spd_female_by_tdm_hclust2.html'),
  # list(input = './4.5.2_ds_spd_female_by_tdm_hclust3.Rmd', output = './reports/4.5.2_ds_spd_female_by_tdm_hclust3.html'),
  # list(input = './4.5.3_ds_spd_female_by_tdm_hclust4.Rmd', output = './reports/4.5.3_ds_spd_female_by_tdm_hclust4.html'),
  # list(input = './4.5.4_ds_spd_female_by_tdm_hclust5.Rmd', output = './reports/4.5.4_ds_spd_female_by_tdm_hclust5.html'),
  # 
  # list(input = './4.5.1_ds_spd_female_by_pauses_hclust2.Rmd', output = './reports/4.5.1_ds_spd_female_by_pauses_hclust2.html'),
  # list(input = './4.5.2_ds_spd_female_by_pauses_hclust3.Rmd', output = './reports/4.5.2_ds_spd_female_by_pauses_hclust3.html'),
  # list(input = './4.5.3_ds_spd_female_by_pauses_hclust4.Rmd', output = './reports/4.5.3_ds_spd_female_by_pauses_hclust4.html'),
  # list(input = './4.5.4_ds_spd_female_by_pauses_hclust5.Rmd', output = './reports/4.5.4_ds_spd_female_by_pauses_hclust5.html'),
  # 
  # ## Мужчины spd
  # list(input = './4.6.1_ds_spd_male_by_all_hclust2.Rmd', output = './reports/4.6.1_ds_spd_male_by_all_hclust2.html'),
  # list(input = './4.6.2_ds_spd_male_by_all_hclust3.Rmd', output = './reports/4.6.2_ds_spd_male_by_all_hclust3.html'),
  # list(input = './4.6.3_ds_spd_male_by_all_hclust4.Rmd', output = './reports/4.6.3_ds_spd_male_by_all_hclust4.html'),
  # list(input = './4.6.4_ds_spd_male_by_all_hclust5.Rmd', output = './reports/4.6.4_ds_spd_male_by_all_hclust5.html'),
  # 
  # list(input = './4.6.1_ds_spd_male_by_notcorr_hclust2.Rmd', output = './reports/4.6.1_ds_spd_male_by_notcorr_hclust2.html'),
  # list(input = './4.6.2_ds_spd_male_by_notcorr_hclust3.Rmd', output = './reports/4.6.2_ds_spd_male_by_notcorr_hclust3.html'),
  # list(input = './4.6.3_ds_spd_male_by_notcorr_hclust4.Rmd', output = './reports/4.6.3_ds_spd_male_by_notcorr_hclust4.html'),
  # list(input = './4.6.4_ds_spd_male_by_notcorr_hclust5.Rmd', output = './reports/4.6.4_ds_spd_male_by_notcorr_hclust5.html'),
  # 
  # list(input = './4.6.1_ds_spd_male_by_tdm_hclust2.Rmd', output = './reports/4.6.1_ds_spd_male_by_tdm_hclust2.html'),
  # list(input = './4.6.2_ds_spd_male_by_tdm_hclust3.Rmd', output = './reports/4.6.2_ds_spd_male_by_tdm_hclust3.html'),
  # list(input = './4.6.3_ds_spd_male_by_tdm_hclust4.Rmd', output = './reports/4.6.3_ds_spd_male_by_tdm_hclust4.html'),
  # list(input = './4.6.4_ds_spd_male_by_tdm_hclust5.Rmd', output = './reports/4.6.4_ds_spd_male_by_tdm_hclust5.html'),
  # 
  # list(input = './4.6.1_ds_spd_male_by_pauses_hclust2.Rmd', output = './reports/4.6.1_ds_spd_male_by_pauses_hclust2.html'),
  # list(input = './4.6.2_ds_spd_male_by_pauses_hclust3.Rmd', output = './reports/4.6.2_ds_spd_male_by_pauses_hclust3.html'),
  # list(input = './4.6.3_ds_spd_male_by_pauses_hclust4.Rmd', output = './reports/4.6.3_ds_spd_male_by_pauses_hclust4.html'),
  # list(input = './4.6.4_ds_spd_male_by_pauses_hclust5.Rmd', output = './reports/4.6.4_ds_spd_male_by_pauses_hclust5.html')
)

files_sp_hclust <- list(
  # Психодиагностика и кластеры
  ## Все респонденты. Задание на точность
  list(input = './5.1.1_sp_ds_acc_by_all_hclust2.Rmd', output = './reports/5.1.1_sp_ds_acc_by_all_hclust2.html'),
  list(input = './5.1.2_sp_ds_acc_by_all_hclust3.Rmd', output = './reports/5.1.2_sp_ds_acc_by_all_hclust3.html'),
  list(input = './5.1.3_sp_ds_acc_by_all_hclust4.Rmd', output = './reports/5.1.3_sp_ds_acc_by_all_hclust4.html'),
  list(input = './5.1.4_sp_ds_acc_by_all_hclust5.Rmd', output = './reports/5.1.4_sp_ds_acc_by_all_hclust5.html'),
  
  list(input = './5.1.1_sp_ds_acc_by_notcorr_hclust2.Rmd', output = './reports/5.1.1_sp_ds_acc_by_notcorr_hclust2.html'),
  list(input = './5.1.2_sp_ds_acc_by_notcorr_hclust3.Rmd', output = './reports/5.1.2_sp_ds_acc_by_notcorr_hclust3.html'),
  list(input = './5.1.3_sp_ds_acc_by_notcorr_hclust4.Rmd', output = './reports/5.1.3_sp_ds_acc_by_notcorr_hclust4.html'),
  list(input = './5.1.4_sp_ds_acc_by_notcorr_hclust5.Rmd', output = './reports/5.1.4_sp_ds_acc_by_notcorr_hclust5.html'),
  
  list(input = './5.1.1_sp_ds_acc_by_tdm_hclust2.Rmd', output = './reports/5.1.1_sp_ds_acc_by_tdm_hclust2.html'),
  list(input = './5.1.2_sp_ds_acc_by_tdm_hclust3.Rmd', output = './reports/5.1.2_sp_ds_acc_by_tdm_hclust3.html'),
  list(input = './5.1.3_sp_ds_acc_by_tdm_hclust4.Rmd', output = './reports/5.1.3_sp_ds_acc_by_tdm_hclust4.html'),
  list(input = './5.1.4_sp_ds_acc_by_tdm_hclust5.Rmd', output = './reports/5.1.4_sp_ds_acc_by_tdm_hclust5.html'),
  
  list(input = './5.1.1_sp_ds_acc_by_pauses_hclust2.Rmd', output = './reports/5.1.1_sp_ds_acc_by_pauses_hclust2.html'),
  list(input = './5.1.2_sp_ds_acc_by_pauses_hclust3.Rmd', output = './reports/5.1.2_sp_ds_acc_by_pauses_hclust3.html'),
  list(input = './5.1.3_sp_ds_acc_by_pauses_hclust4.Rmd', output = './reports/5.1.3_sp_ds_acc_by_pauses_hclust4.html'),
  list(input = './5.1.4_sp_ds_acc_by_pauses_hclust5.Rmd', output = './reports/5.1.4_sp_ds_acc_by_pauses_hclust5.html'),
  
  list(input = './5.1.1_sp_ds_acc_by_tdmp_hclust2.Rmd', output = './reports/5.1.1_sp_ds_acc_by_tdmp_hclust2.html'),
  list(input = './5.1.2_sp_ds_acc_by_tdmp_hclust3.Rmd', output = './reports/5.1.2_sp_ds_acc_by_tdmp_hclust3.html'),
  list(input = './5.1.3_sp_ds_acc_by_tdmp_hclust4.Rmd', output = './reports/5.1.3_sp_ds_acc_by_tdmp_hclust4.html'),
  list(input = './5.1.4_sp_ds_acc_by_tdmp_hclust5.Rmd', output = './reports/5.1.4_sp_ds_acc_by_tdmp_hclust5.html'),
  
  # ## Женщины acc
  # list(input = './5.2.1_sp_ds_acc_female_by_all_hclust2.Rmd', output = './reports/5.2.1_sp_ds_acc_female_by_all_hclust2.html'),
  # list(input = './5.2.2_sp_ds_acc_female_by_all_hclust3.Rmd', output = './reports/5.2.2_sp_ds_acc_female_by_all_hclust3.html'),
  # list(input = './5.2.3_sp_ds_acc_female_by_all_hclust4.Rmd', output = './reports/5.2.3_sp_ds_acc_female_by_all_hclust4.html'),
  # list(input = './5.2.4_sp_ds_acc_female_by_all_hclust5.Rmd', output = './reports/5.2.4_sp_ds_acc_female_by_all_hclust5.html'),
  # 
  # list(input = './5.2.1_sp_ds_acc_female_by_notcorr_hclust2.Rmd', output = './reports/5.2.1_sp_ds_acc_female_by_notcorr_hclust2.html'),
  # list(input = './5.2.2_sp_ds_acc_female_by_notcorr_hclust3.Rmd', output = './reports/5.2.2_sp_ds_acc_female_by_notcorr_hclust3.html'),
  # list(input = './5.2.3_sp_ds_acc_female_by_notcorr_hclust4.Rmd', output = './reports/5.2.3_sp_ds_acc_female_by_notcorr_hclust4.html'),
  # list(input = './5.2.4_sp_ds_acc_female_by_notcorr_hclust5.Rmd', output = './reports/5.2.4_sp_ds_acc_female_by_notcorr_hclust5.html'),
  # 
  # list(input = './5.2.1_sp_ds_acc_female_by_tdm_hclust2.Rmd', output = './reports/5.2.1_sp_ds_acc_female_by_tdm_hclust2.html'),
  # list(input = './5.2.2_sp_ds_acc_female_by_tdm_hclust3.Rmd', output = './reports/5.2.2_sp_ds_acc_female_by_tdm_hclust3.html'),
  # list(input = './5.2.3_sp_ds_acc_female_by_tdm_hclust4.Rmd', output = './reports/5.2.3_sp_ds_acc_female_by_tdm_hclust4.html'),
  # list(input = './5.2.4_sp_ds_acc_female_by_tdm_hclust5.Rmd', output = './reports/5.2.4_sp_ds_acc_female_by_tdm_hclust5.html'),
  # 
  # list(input = './5.2.1_sp_ds_acc_female_by_pauses_hclust2.Rmd', output = './reports/5.2.1_sp_ds_acc_female_by_pauses_hclust2.html'),
  # list(input = './5.2.2_sp_ds_acc_female_by_pauses_hclust3.Rmd', output = './reports/5.2.2_sp_ds_acc_female_by_pauses_hclust3.html'),
  # list(input = './5.2.3_sp_ds_acc_female_by_pauses_hclust4.Rmd', output = './reports/5.2.3_sp_ds_acc_female_by_pauses_hclust4.html'),
  # list(input = './5.2.4_sp_ds_acc_female_by_pauses_hclust5.Rmd', output = './reports/5.2.4_sp_ds_acc_female_by_pauses_hclust5.html'),
  # 
  # 
  # ## Мужчины acc
  # list(input = './5.3.1_sp_ds_acc_male_by_all_hclust2.Rmd', output = './reports/5.3.1_sp_ds_acc_male_by_all_hclust2.html'),
  # list(input = './5.3.2_sp_ds_acc_male_by_all_hclust3.Rmd', output = './reports/5.3.2_sp_ds_acc_male_by_all_hclust3.html'),
  # list(input = './5.3.3_sp_ds_acc_male_by_all_hclust4.Rmd', output = './reports/5.3.3_sp_ds_acc_male_by_all_hclust4.html'),
  # list(input = './5.3.4_sp_ds_acc_male_by_all_hclust5.Rmd', output = './reports/5.3.4_sp_ds_acc_male_by_all_hclust5.html'),
  # 
  # list(input = './5.3.1_sp_ds_acc_male_by_notcorr_hclust2.Rmd', output = './reports/5.3.1_sp_ds_acc_male_by_notcorr_hclust2.html'),
  # list(input = './5.3.2_sp_ds_acc_male_by_notcorr_hclust3.Rmd', output = './reports/5.3.2_sp_ds_acc_male_by_notcorr_hclust3.html'),
  # list(input = './5.3.3_sp_ds_acc_male_by_notcorr_hclust4.Rmd', output = './reports/5.3.3_sp_ds_acc_male_by_notcorr_hclust4.html'),
  # list(input = './5.3.4_sp_ds_acc_male_by_notcorr_hclust5.Rmd', output = './reports/5.3.4_sp_ds_acc_male_by_notcorr_hclust5.html'),
  # 
  # list(input = './5.3.1_sp_ds_acc_male_by_tdm_hclust2.Rmd', output = './reports/5.3.1_sp_ds_acc_male_by_tdm_hclust2.html'),
  # list(input = './5.3.2_sp_ds_acc_male_by_tdm_hclust3.Rmd', output = './reports/5.3.2_sp_ds_acc_male_by_tdm_hclust3.html'),
  # list(input = './5.3.3_sp_ds_acc_male_by_tdm_hclust4.Rmd', output = './reports/5.3.3_sp_ds_acc_male_by_tdm_hclust4.html'),
  # list(input = './5.3.4_sp_ds_acc_male_by_tdm_hclust5.Rmd', output = './reports/5.3.4_sp_ds_acc_male_by_tdm_hclust5.html'),
  # 
  # list(input = './5.3.1_sp_ds_acc_male_by_pauses_hclust2.Rmd', output = './reports/5.3.1_sp_ds_acc_male_by_pauses_hclust2.html'),
  # list(input = './5.3.2_sp_ds_acc_male_by_pauses_hclust3.Rmd', output = './reports/5.3.2_sp_ds_acc_male_by_pauses_hclust3.html'),
  # list(input = './5.3.3_sp_ds_acc_male_by_pauses_hclust4.Rmd', output = './reports/5.3.3_sp_ds_acc_male_by_pauses_hclust4.html'),
  # list(input = './5.3.4_sp_ds_acc_male_by_pauses_hclust5.Rmd', output = './reports/5.3.4_sp_ds_acc_male_by_pauses_hclust5.html'),
  
  ## Все респонденты. Задание на скорость
  list(input = './5.4.1_sp_ds_spd_by_all_hclust2.Rmd', output = './reports/5.4.1_sp_ds_spd_by_all_hclust2.html'),
  list(input = './5.4.2_sp_ds_spd_by_all_hclust3.Rmd', output = './reports/5.4.2_sp_ds_spd_by_all_hclust3.html'),
  list(input = './5.4.3_sp_ds_spd_by_all_hclust4.Rmd', output = './reports/5.4.3_sp_ds_spd_by_all_hclust4.html'),
  list(input = './5.4.4_sp_ds_spd_by_all_hclust5.Rmd', output = './reports/5.4.4_sp_ds_spd_by_all_hclust5.html'),
  
  list(input = './5.4.1_sp_ds_spd_by_notcorr_hclust2.Rmd', output = './reports/5.4.1_sp_ds_spd_by_notcorr_hclust2.html'),
  list(input = './5.4.2_sp_ds_spd_by_notcorr_hclust3.Rmd', output = './reports/5.4.2_sp_ds_spd_by_notcorr_hclust3.html'),
  list(input = './5.4.3_sp_ds_spd_by_notcorr_hclust4.Rmd', output = './reports/5.4.3_sp_ds_spd_by_notcorr_hclust4.html'),
  list(input = './5.4.4_sp_ds_spd_by_notcorr_hclust5.Rmd', output = './reports/5.4.4_sp_ds_spd_by_notcorr_hclust5.html'),
  
  list(input = './5.4.1_sp_ds_spd_by_tdm_hclust2.Rmd', output = './reports/5.4.1_sp_ds_spd_by_tdm_hclust2.html'),
  list(input = './5.4.2_sp_ds_spd_by_tdm_hclust3.Rmd', output = './reports/5.4.2_sp_ds_spd_by_tdm_hclust3.html'),
  list(input = './5.4.3_sp_ds_spd_by_tdm_hclust4.Rmd', output = './reports/5.4.3_sp_ds_spd_by_tdm_hclust4.html'),
  list(input = './5.4.4_sp_ds_spd_by_tdm_hclust5.Rmd', output = './reports/5.4.4_sp_ds_spd_by_tdm_hclust5.html'),
  
  list(input = './5.4.1_sp_ds_spd_by_pauses_hclust2.Rmd', output = './reports/5.4.1_sp_ds_spd_by_pauses_hclust2.html'),
  list(input = './5.4.2_sp_ds_spd_by_pauses_hclust3.Rmd', output = './reports/5.4.2_sp_ds_spd_by_pauses_hclust3.html'),
  list(input = './5.4.3_sp_ds_spd_by_pauses_hclust4.Rmd', output = './reports/5.4.3_sp_ds_spd_by_pauses_hclust4.html'),
  list(input = './5.4.4_sp_ds_spd_by_pauses_hclust5.Rmd', output = './reports/5.4.4_sp_ds_spd_by_pauses_hclust5.html'),
  
  list(input = './5.4.1_sp_ds_spd_by_tdmp_hclust2.Rmd', output = './reports/5.4.1_sp_ds_spd_by_tdmp_hclust2.html'),
  list(input = './5.4.2_sp_ds_spd_by_tdmp_hclust3.Rmd', output = './reports/5.4.2_sp_ds_spd_by_tdmp_hclust3.html'),
  list(input = './5.4.3_sp_ds_spd_by_tdmp_hclust4.Rmd', output = './reports/5.4.3_sp_ds_spd_by_tdmp_hclust4.html'),
  list(input = './5.4.4_sp_ds_spd_by_tdmp_hclust5.Rmd', output = './reports/5.4.4_sp_ds_spd_by_tdmp_hclust5.html')
  
  # ## Женщины spd
  # list(input = './5.5.1_sp_ds_spd_female_by_all_hclust2.Rmd', output = './reports/5.5.1_sp_ds_spd_female_by_all_hclust2.html'),
  # list(input = './5.5.2_sp_ds_spd_female_by_all_hclust3.Rmd', output = './reports/5.5.2_sp_ds_spd_female_by_all_hclust3.html'),
  # list(input = './5.5.3_sp_ds_spd_female_by_all_hclust4.Rmd', output = './reports/5.5.3_sp_ds_spd_female_by_all_hclust4.html'),
  # list(input = './5.5.4_sp_ds_spd_female_by_all_hclust5.Rmd', output = './reports/5.5.4_sp_ds_spd_female_by_all_hclust5.html'),
  # 
  # list(input = './5.5.1_sp_ds_spd_female_by_notcorr_hclust2.Rmd', output = './reports/5.5.1_sp_ds_spd_female_by_notcorr_hclust2.html'),
  # list(input = './5.5.2_sp_ds_spd_female_by_notcorr_hclust3.Rmd', output = './reports/5.5.2_sp_ds_spd_female_by_notcorr_hclust3.html'),
  # list(input = './5.5.3_sp_ds_spd_female_by_notcorr_hclust4.Rmd', output = './reports/5.5.3_sp_ds_spd_female_by_notcorr_hclust4.html'),
  # list(input = './5.5.4_sp_ds_spd_female_by_notcorr_hclust5.Rmd', output = './reports/5.5.4_sp_ds_spd_female_by_notcorr_hclust5.html'),
  # 
  # list(input = './5.5.1_sp_ds_spd_female_by_tdm_hclust2.Rmd', output = './reports/5.5.1_sp_ds_spd_female_by_tdm_hclust2.html'),
  # list(input = './5.5.2_sp_ds_spd_female_by_tdm_hclust3.Rmd', output = './reports/5.5.2_sp_ds_spd_female_by_tdm_hclust3.html'),
  # list(input = './5.5.3_sp_ds_spd_female_by_tdm_hclust4.Rmd', output = './reports/5.5.3_sp_ds_spd_female_by_tdm_hclust4.html'),
  # list(input = './5.5.4_sp_ds_spd_female_by_tdm_hclust5.Rmd', output = './reports/5.5.4_sp_ds_spd_female_by_tdm_hclust5.html'),
  # 
  # list(input = './5.5.1_sp_ds_spd_female_by_pauses_hclust2.Rmd', output = './reports/5.5.1_sp_ds_spd_female_by_pauses_hclust2.html'),
  # list(input = './5.5.2_sp_ds_spd_female_by_pauses_hclust3.Rmd', output = './reports/5.5.2_sp_ds_spd_female_by_pauses_hclust3.html'),
  # list(input = './5.5.3_sp_ds_spd_female_by_pauses_hclust4.Rmd', output = './reports/5.5.3_sp_ds_spd_female_by_pauses_hclust4.html'),
  # list(input = './5.5.4_sp_ds_spd_female_by_pauses_hclust5.Rmd', output = './reports/5.5.4_sp_ds_spd_female_by_pauses_hclust5.html'),
  # 
  # ## Мужчины spd
  # list(input = './5.6.1_sp_ds_spd_male_by_all_hclust2.Rmd', output = './reports/5.6.1_sp_ds_spd_male_by_all_hclust2.html'),
  # list(input = './5.6.2_sp_ds_spd_male_by_all_hclust3.Rmd', output = './reports/5.6.2_sp_ds_spd_male_by_all_hclust3.html'),
  # list(input = './5.6.3_sp_ds_spd_male_by_all_hclust4.Rmd', output = './reports/5.6.3_sp_ds_spd_male_by_all_hclust4.html'),
  # list(input = './5.6.4_sp_ds_spd_male_by_all_hclust5.Rmd', output = './reports/5.6.4_sp_ds_spd_male_by_all_hclust5.html'),
  # 
  # list(input = './5.6.1_sp_ds_spd_male_by_notcorr_hclust2.Rmd', output = './reports/5.6.1_sp_ds_spd_male_by_notcorr_hclust2.html'),
  # list(input = './5.6.2_sp_ds_spd_male_by_notcorr_hclust3.Rmd', output = './reports/5.6.2_sp_ds_spd_male_by_notcorr_hclust3.html'),
  # list(input = './5.6.3_sp_ds_spd_male_by_notcorr_hclust4.Rmd', output = './reports/5.6.3_sp_ds_spd_male_by_notcorr_hclust4.html'),
  # list(input = './5.6.4_sp_ds_spd_male_by_notcorr_hclust5.Rmd', output = './reports/5.6.4_sp_ds_spd_male_by_notcorr_hclust5.html'),
  # 
  # list(input = './5.6.1_sp_ds_spd_male_by_tdm_hclust2.Rmd', output = './reports/5.6.1_sp_ds_spd_male_by_tdm_hclust2.html'),
  # list(input = './5.6.2_sp_ds_spd_male_by_tdm_hclust3.Rmd', output = './reports/5.6.2_sp_ds_spd_male_by_tdm_hclust3.html'),
  # list(input = './5.6.3_sp_ds_spd_male_by_tdm_hclust4.Rmd', output = './reports/5.6.3_sp_ds_spd_male_by_tdm_hclust4.html'),
  # list(input = './5.6.4_sp_ds_spd_male_by_tdm_hclust5.Rmd', output = './reports/5.6.4_sp_ds_spd_male_by_tdm_hclust5.html'),
  # 
  # list(input = './5.6.1_sp_ds_spd_male_by_pauses_hclust2.Rmd', output = './reports/5.6.1_sp_ds_spd_male_by_pauses_hclust2.html'),
  # list(input = './5.6.2_sp_ds_spd_male_by_pauses_hclust3.Rmd', output = './reports/5.6.2_sp_ds_spd_male_by_pauses_hclust3.html'),
  # list(input = './5.6.3_sp_ds_spd_male_by_pauses_hclust4.Rmd', output = './reports/5.6.3_sp_ds_spd_male_by_pauses_hclust4.html'),
  # list(input = './5.6.4_sp_ds_spd_male_by_pauses_hclust5.Rmd', output = './reports/5.6.4_sp_ds_spd_male_by_pauses_hclust5.html')
)
 
files_ds_kmclust <- list( 
  # kmclust
  ## Все респонденты. Задание на точность.
  list(input = './4.7.1_ds_acc_by_all_kmclust2.Rmd', output = './reports/4.7.1_ds_acc_by_all_kmclust2.html'),
  list(input = './4.7.2_ds_acc_by_all_kmclust3.Rmd', output = './reports/4.7.2_ds_acc_by_all_kmclust3.html'),
  list(input = './4.7.3_ds_acc_by_all_kmclust4.Rmd', output = './reports/4.7.3_ds_acc_by_all_kmclust4.html'),
  list(input = './4.7.4_ds_acc_by_all_kmclust5.Rmd', output = './reports/4.7.4_ds_acc_by_all_kmclust5.html'),
  list(input = './4.7.1_ds_acc_by_notcorr_kmclust2.Rmd', output = './reports/4.7.1_ds_acc_by_notcorr_kmclust2.html'),
  list(input = './4.7.2_ds_acc_by_notcorr_kmclust3.Rmd', output = './reports/4.7.2_ds_acc_by_notcorr_kmclust3.html'),
  list(input = './4.7.3_ds_acc_by_notcorr_kmclust4.Rmd', output = './reports/4.7.3_ds_acc_by_notcorr_kmclust4.html'),
  list(input = './4.7.4_ds_acc_by_notcorr_kmclust5.Rmd', output = './reports/4.7.4_ds_acc_by_notcorr_kmclust5.html'),
  list(input = './4.7.1_ds_acc_by_tdm_kmclust2.Rmd', output = './reports/4.7.1_ds_acc_by_tdm_kmclust2.html'),
  list(input = './4.7.2_ds_acc_by_tdm_kmclust3.Rmd', output = './reports/4.7.2_ds_acc_by_tdm_kmclust3.html'),
  list(input = './4.7.3_ds_acc_by_tdm_kmclust4.Rmd', output = './reports/4.7.3_ds_acc_by_tdm_kmclust4.html'),
  list(input = './4.7.4_ds_acc_by_tdm_kmclust5.Rmd', output = './reports/4.7.4_ds_acc_by_tdm_kmclust5.html'),
  list(input = './4.7.1_ds_acc_by_pauses_kmclust2.Rmd', output = './reports/4.7.1_ds_acc_by_pauses_kmclust2.html'),
  list(input = './4.7.2_ds_acc_by_pauses_kmclust3.Rmd', output = './reports/4.7.2_ds_acc_by_pauses_kmclust3.html'),
  list(input = './4.7.3_ds_acc_by_pauses_kmclust4.Rmd', output = './reports/4.7.3_ds_acc_by_pauses_kmclust4.html'),
  list(input = './4.7.4_ds_acc_by_pauses_kmclust5.Rmd', output = './reports/4.7.4_ds_acc_by_pauses_kmclust5.html'),
  
  list(input = './4.7.1_ds_acc_by_tdmp_kmclust2.Rmd', output = './reports/4.7.1_ds_acc_by_tdmp_kmclust2.html'),
  list(input = './4.7.2_ds_acc_by_tdmp_kmclust3.Rmd', output = './reports/4.7.2_ds_acc_by_tdmp_kmclust3.html'),
  list(input = './4.7.3_ds_acc_by_tdmp_kmclust4.Rmd', output = './reports/4.7.3_ds_acc_by_tdmp_kmclust4.html'),
  list(input = './4.7.4_ds_acc_by_tdmp_kmclust5.Rmd', output = './reports/4.7.4_ds_acc_by_tdmp_kmclust5.html'),
  
  # ## Женщины acc
  # list(input = './4.8.1_ds_acc_female_by_all_kmclust2.Rmd', output = './reports/4.8.1_ds_acc_female_by_all_kmclust2.html'),
  # list(input = './4.8.2_ds_acc_female_by_all_kmclust3.Rmd', output = './reports/4.8.2_ds_acc_female_by_all_kmclust3.html'),
  # list(input = './4.8.3_ds_acc_female_by_all_kmclust4.Rmd', output = './reports/4.8.3_ds_acc_female_by_all_kmclust4.html'),
  # list(input = './4.8.4_ds_acc_female_by_all_kmclust5.Rmd', output = './reports/4.8.4_ds_acc_female_by_all_kmclust5.html'),
  # list(input = './4.8.1_ds_acc_female_by_notcorr_kmclust2.Rmd', output = './reports/4.8.1_ds_acc_female_by_notcorr_kmclust2.html'),
  # list(input = './4.8.2_ds_acc_female_by_notcorr_kmclust3.Rmd', output = './reports/4.8.2_ds_acc_female_by_notcorr_kmclust3.html'),
  # list(input = './4.8.3_ds_acc_female_by_notcorr_kmclust4.Rmd', output = './reports/4.8.3_ds_acc_female_by_notcorr_kmclust4.html'),
  # list(input = './4.8.4_ds_acc_female_by_notcorr_kmclust5.Rmd', output = './reports/4.8.4_ds_acc_female_by_notcorr_kmclust5.html'),
  # list(input = './4.8.1_ds_acc_female_by_tdm_kmclust2.Rmd', output = './reports/4.8.1_ds_acc_female_by_tdm_kmclust2.html'),
  # list(input = './4.8.2_ds_acc_female_by_tdm_kmclust3.Rmd', output = './reports/4.8.2_ds_acc_female_by_tdm_kmclust3.html'),
  # list(input = './4.8.3_ds_acc_female_by_tdm_kmclust4.Rmd', output = './reports/4.8.3_ds_acc_female_by_tdm_kmclust4.html'),
  # list(input = './4.8.4_ds_acc_female_by_tdm_kmclust5.Rmd', output = './reports/4.8.4_ds_acc_female_by_tdm_kmclust5.html'),
  # list(input = './4.8.1_ds_acc_female_by_pauses_kmclust2.Rmd', output = './reports/4.8.1_ds_acc_female_by_pauses_kmclust2.html'),
  # list(input = './4.8.2_ds_acc_female_by_pauses_kmclust3.Rmd', output = './reports/4.8.2_ds_acc_female_by_pauses_kmclust3.html'),
  # list(input = './4.8.3_ds_acc_female_by_pauses_kmclust4.Rmd', output = './reports/4.8.3_ds_acc_female_by_pauses_kmclust4.html'),
  # list(input = './4.8.4_ds_acc_female_by_pauses_kmclust5.Rmd', output = './reports/4.8.4_ds_acc_female_by_pauses_kmclust5.html'),
  # ## Мужчины acc
  # list(input = './4.9.1_ds_acc_male_by_all_kmclust2.Rmd', output = './reports/4.9.1_ds_acc_male_by_all_kmclust2.html'),
  # list(input = './4.9.2_ds_acc_male_by_all_kmclust3.Rmd', output = './reports/4.9.2_ds_acc_male_by_all_kmclust3.html'),
  # list(input = './4.9.3_ds_acc_male_by_all_kmclust4.Rmd', output = './reports/4.9.3_ds_acc_male_by_all_kmclust4.html'),
  # list(input = './4.9.4_ds_acc_male_by_all_kmclust5.Rmd', output = './reports/4.9.4_ds_acc_male_by_all_kmclust5.html'),
  # list(input = './4.9.1_ds_acc_male_by_notcorr_kmclust2.Rmd', output = './reports/4.9.1_ds_acc_male_by_notcorr_kmclust2.html'),
  # list(input = './4.9.2_ds_acc_male_by_notcorr_kmclust3.Rmd', output = './reports/4.9.2_ds_acc_male_by_notcorr_kmclust3.html'),
  # list(input = './4.9.3_ds_acc_male_by_notcorr_kmclust4.Rmd', output = './reports/4.9.3_ds_acc_male_by_notcorr_kmclust4.html'),
  # list(input = './4.9.4_ds_acc_male_by_notcorr_kmclust5.Rmd', output = './reports/4.9.4_ds_acc_male_by_notcorr_kmclust5.html'),
  # list(input = './4.9.1_ds_acc_male_by_tdm_kmclust2.Rmd', output = './reports/4.9.1_ds_acc_male_by_tdm_kmclust2.html'),
  # list(input = './4.9.2_ds_acc_male_by_tdm_kmclust3.Rmd', output = './reports/4.9.2_ds_acc_male_by_tdm_kmclust3.html'),
  # list(input = './4.9.3_ds_acc_male_by_tdm_kmclust4.Rmd', output = './reports/4.9.3_ds_acc_male_by_tdm_kmclust4.html'),
  # list(input = './4.9.4_ds_acc_male_by_tdm_kmclust5.Rmd', output = './reports/4.9.4_ds_acc_male_by_tdm_kmclust5.html'),
  # list(input = './4.9.1_ds_acc_male_by_pauses_kmclust2.Rmd', output = './reports/4.9.1_ds_acc_male_by_pauses_kmclust2.html'),
  # list(input = './4.9.2_ds_acc_male_by_pauses_kmclust3.Rmd', output = './reports/4.9.2_ds_acc_male_by_pauses_kmclust3.html'),
  # list(input = './4.9.3_ds_acc_male_by_pauses_kmclust4.Rmd', output = './reports/4.9.3_ds_acc_male_by_pauses_kmclust4.html'),
  # list(input = './4.9.4_ds_acc_male_by_pauses_kmclust5.Rmd', output = './reports/4.9.4_ds_acc_male_by_pauses_kmclust5.html'),
  
  ## Все респонденты. Задание на скорость
  list(input = './4.10.1_ds_spd_by_all_kmclust2.Rmd', output = './reports/4.10.1_ds_spd_by_all_kmclust2.html'),
  list(input = './4.10.2_ds_spd_by_all_kmclust3.Rmd', output = './reports/4.10.2_ds_spd_by_all_kmclust3.html'),
  list(input = './4.10.3_ds_spd_by_all_kmclust4.Rmd', output = './reports/4.10.3_ds_spd_by_all_kmclust4.html'),
  list(input = './4.10.4_ds_spd_by_all_kmclust5.Rmd', output = './reports/4.10.4_ds_spd_by_all_kmclust5.html'),
  list(input = './4.10.1_ds_spd_by_notcorr_kmclust2.Rmd', output = './reports/4.10.1_ds_spd_by_notcorr_kmclust2.html'),
  list(input = './4.10.2_ds_spd_by_notcorr_kmclust3.Rmd', output = './reports/4.10.2_ds_spd_by_notcorr_kmclust3.html'),
  list(input = './4.10.3_ds_spd_by_notcorr_kmclust4.Rmd', output = './reports/4.10.3_ds_spd_by_notcorr_kmclust4.html'),
  list(input = './4.10.4_ds_spd_by_notcorr_kmclust5.Rmd', output = './reports/4.10.4_ds_spd_by_notcorr_kmclust5.html'),
  list(input = './4.10.1_ds_spd_by_tdm_kmclust2.Rmd', output = './reports/4.10.1_ds_spd_by_tdm_kmclust2.html'),
  list(input = './4.10.2_ds_spd_by_tdm_kmclust3.Rmd', output = './reports/4.10.2_ds_spd_by_tdm_kmclust3.html'),
  list(input = './4.10.3_ds_spd_by_tdm_kmclust4.Rmd', output = './reports/4.10.3_ds_spd_by_tdm_kmclust4.html'),
  list(input = './4.10.4_ds_spd_by_tdm_kmclust5.Rmd', output = './reports/4.10.4_ds_spd_by_tdm_kmclust5.html'),
  list(input = './4.10.1_ds_spd_by_pauses_kmclust2.Rmd', output = './reports/4.10.1_ds_spd_by_pauses_kmclust2.html'),
  list(input = './4.10.2_ds_spd_by_pauses_kmclust3.Rmd', output = './reports/4.10.2_ds_spd_by_pauses_kmclust3.html'),
  list(input = './4.10.3_ds_spd_by_pauses_kmclust4.Rmd', output = './reports/4.10.3_ds_spd_by_pauses_kmclust4.html'),
  list(input = './4.10.4_ds_spd_by_pauses_kmclust5.Rmd', output = './reports/4.10.4_ds_spd_by_pauses_kmclust5.html'),
  list(input = './4.10.1_ds_spd_by_tdmp_kmclust2.Rmd', output = './reports/4.10.1_ds_spd_by_tdmp_kmclust2.html'),
  list(input = './4.10.2_ds_spd_by_tdmp_kmclust3.Rmd', output = './reports/4.10.2_ds_spd_by_tdmp_kmclust3.html'),
  list(input = './4.10.3_ds_spd_by_tdmp_kmclust4.Rmd', output = './reports/4.10.3_ds_spd_by_tdmp_kmclust4.html'),
  list(input = './4.10.4_ds_spd_by_tdmp_kmclust5.Rmd', output = './reports/4.10.4_ds_spd_by_tdmp_kmclust5.html')
  
  # ## Женщины spd
  # list(input = './4.11.1_ds_spd_female_by_all_kmclust2.Rmd', output = './reports/4.11.1_ds_spd_female_by_all_kmclust2.html'),
  # list(input = './4.11.2_ds_spd_female_by_all_kmclust3.Rmd', output = './reports/4.11.2_ds_spd_female_by_all_kmclust3.html'),
  # list(input = './4.11.3_ds_spd_female_by_all_kmclust4.Rmd', output = './reports/4.11.3_ds_spd_female_by_all_kmclust4.html'),
  # list(input = './4.11.4_ds_spd_female_by_all_kmclust5.Rmd', output = './reports/4.11.4_ds_spd_female_by_all_kmclust5.html'),
  # list(input = './4.11.1_ds_spd_female_by_notcorr_kmclust2.Rmd', output = './reports/4.11.1_ds_spd_female_by_notcorr_kmclust2.html'),
  # list(input = './4.11.2_ds_spd_female_by_notcorr_kmclust3.Rmd', output = './reports/4.11.2_ds_spd_female_by_notcorr_kmclust3.html'),
  # list(input = './4.11.3_ds_spd_female_by_notcorr_kmclust4.Rmd', output = './reports/4.11.3_ds_spd_female_by_notcorr_kmclust4.html'),
  # list(input = './4.11.4_ds_spd_female_by_notcorr_kmclust5.Rmd', output = './reports/4.11.4_ds_spd_female_by_notcorr_kmclust5.html'),
  # list(input = './4.11.1_ds_spd_female_by_tdm_kmclust2.Rmd', output = './reports/4.11.1_ds_spd_female_by_tdm_kmclust2.html'),
  # list(input = './4.11.2_ds_spd_female_by_tdm_kmclust3.Rmd', output = './reports/4.11.2_ds_spd_female_by_tdm_kmclust3.html'),
  # list(input = './4.11.3_ds_spd_female_by_tdm_kmclust4.Rmd', output = './reports/4.11.3_ds_spd_female_by_tdm_kmclust4.html'),
  # list(input = './4.11.4_ds_spd_female_by_tdm_kmclust5.Rmd', output = './reports/4.11.4_ds_spd_female_by_tdm_kmclust5.html'),
  # list(input = './4.11.1_ds_spd_female_by_pauses_kmclust2.Rmd', output = './reports/4.11.1_ds_spd_female_by_pauses_kmclust2.html'),
  # list(input = './4.11.2_ds_spd_female_by_pauses_kmclust3.Rmd', output = './reports/4.11.2_ds_spd_female_by_pauses_kmclust3.html'),
  # list(input = './4.11.3_ds_spd_female_by_pauses_kmclust4.Rmd', output = './reports/4.11.3_ds_spd_female_by_pauses_kmclust4.html'),
  # list(input = './4.11.4_ds_spd_female_by_pauses_kmclust5.Rmd', output = './reports/4.11.4_ds_spd_female_by_pauses_kmclust5.html'),
  # 
  # ## Мужчины spd
  # list(input = './4.12.1_ds_spd_male_by_all_kmclust2.Rmd', output = './reports/4.12.1_ds_spd_male_by_all_kmclust2.html'),
  # list(input = './4.12.2_ds_spd_male_by_all_kmclust3.Rmd', output = './reports/4.12.2_ds_spd_male_by_all_kmclust3.html'),
  # list(input = './4.12.3_ds_spd_male_by_all_kmclust4.Rmd', output = './reports/4.12.3_ds_spd_male_by_all_kmclust4.html'),
  # list(input = './4.12.4_ds_spd_male_by_all_kmclust5.Rmd', output = './reports/4.12.4_ds_spd_male_by_all_kmclust5.html'),
  # list(input = './4.12.1_ds_spd_male_by_notcorr_kmclust2.Rmd', output = './reports/4.12.1_ds_spd_male_by_notcorr_kmclust2.html'),
  # list(input = './4.12.2_ds_spd_male_by_notcorr_kmclust3.Rmd', output = './reports/4.12.2_ds_spd_male_by_notcorr_kmclust3.html'),
  # list(input = './4.12.3_ds_spd_male_by_notcorr_kmclust4.Rmd', output = './reports/4.12.3_ds_spd_male_by_notcorr_kmclust4.html'),
  # list(input = './4.12.4_ds_spd_male_by_notcorr_kmclust5.Rmd', output = './reports/4.12.4_ds_spd_male_by_notcorr_kmclust5.html'),
  # list(input = './4.12.1_ds_spd_male_by_tdm_kmclust2.Rmd', output = './reports/4.12.1_ds_spd_male_by_tdm_kmclust2.html'),
  # list(input = './4.12.2_ds_spd_male_by_tdm_kmclust3.Rmd', output = './reports/4.12.2_ds_spd_male_by_tdm_kmclust3.html'),
  # list(input = './4.12.3_ds_spd_male_by_tdm_kmclust4.Rmd', output = './reports/4.12.3_ds_spd_male_by_tdm_kmclust4.html'),
  # list(input = './4.12.4_ds_spd_male_by_tdm_kmclust5.Rmd', output = './reports/4.12.4_ds_spd_male_by_tdm_kmclust5.html'),
  # list(input = './4.12.1_ds_spd_male_by_pauses_kmclust2.Rmd', output = './reports/4.12.1_ds_spd_male_by_pauses_kmclust2.html'),
  # list(input = './4.12.2_ds_spd_male_by_pauses_kmclust3.Rmd', output = './reports/4.12.2_ds_spd_male_by_pauses_kmclust3.html'),
  # list(input = './4.12.3_ds_spd_male_by_pauses_kmclust4.Rmd', output = './reports/4.12.3_ds_spd_male_by_pauses_kmclust4.html'),
  # list(input = './4.12.4_ds_spd_male_by_pauses_kmclust5.Rmd', output = './reports/4.12.4_ds_spd_male_by_pauses_kmclust5.html')
)

files_sp_kmclust <- list(
  # Психодиагностика и кластеры
  ## Все респонденты. Задание на точность
  list(input = './5.7.1_sp_ds_acc_by_all_kmclust2.Rmd', output = './reports/5.7.1_sp_ds_acc_by_all_kmclust2.html'),
  list(input = './5.7.2_sp_ds_acc_by_all_kmclust3.Rmd', output = './reports/5.7.2_sp_ds_acc_by_all_kmclust3.html'),
  list(input = './5.7.3_sp_ds_acc_by_all_kmclust4.Rmd', output = './reports/5.7.3_sp_ds_acc_by_all_kmclust4.html'),
  list(input = './5.7.4_sp_ds_acc_by_all_kmclust5.Rmd', output = './reports/5.7.4_sp_ds_acc_by_all_kmclust5.html'),
  list(input = './5.7.1_sp_ds_acc_by_notcorr_kmclust2.Rmd', output = './reports/5.7.1_sp_ds_acc_by_notcorr_kmclust2.html'),
  list(input = './5.7.2_sp_ds_acc_by_notcorr_kmclust3.Rmd', output = './reports/5.7.2_sp_ds_acc_by_notcorr_kmclust3.html'),
  list(input = './5.7.3_sp_ds_acc_by_notcorr_kmclust4.Rmd', output = './reports/5.7.3_sp_ds_acc_by_notcorr_kmclust4.html'),
  list(input = './5.7.4_sp_ds_acc_by_notcorr_kmclust5.Rmd', output = './reports/5.7.4_sp_ds_acc_by_notcorr_kmclust5.html'),
  list(input = './5.7.1_sp_ds_acc_by_tdm_kmclust2.Rmd', output = './reports/5.7.1_sp_ds_acc_by_tdm_kmclust2.html'),
  list(input = './5.7.2_sp_ds_acc_by_tdm_kmclust3.Rmd', output = './reports/5.7.2_sp_ds_acc_by_tdm_kmclust3.html'),
  list(input = './5.7.3_sp_ds_acc_by_tdm_kmclust4.Rmd', output = './reports/5.7.3_sp_ds_acc_by_tdm_kmclust4.html'),
  list(input = './5.7.4_sp_ds_acc_by_tdm_kmclust5.Rmd', output = './reports/5.7.4_sp_ds_acc_by_tdm_kmclust5.html'),
  list(input = './5.7.1_sp_ds_acc_by_pauses_kmclust2.Rmd', output = './reports/5.7.1_sp_ds_acc_by_pauses_kmclust2.html'),
  list(input = './5.7.2_sp_ds_acc_by_pauses_kmclust3.Rmd', output = './reports/5.7.2_sp_ds_acc_by_pauses_kmclust3.html'),
  list(input = './5.7.3_sp_ds_acc_by_pauses_kmclust4.Rmd', output = './reports/5.7.3_sp_ds_acc_by_pauses_kmclust4.html'),
  list(input = './5.7.4_sp_ds_acc_by_pauses_kmclust5.Rmd', output = './reports/5.7.4_sp_ds_acc_by_pauses_kmclust5.html'),
  list(input = './5.7.1_sp_ds_acc_by_tdmp_kmclust2.Rmd', output = './reports/5.7.1_sp_ds_acc_by_tdmp_kmclust2.html'),
  list(input = './5.7.2_sp_ds_acc_by_tdmp_kmclust3.Rmd', output = './reports/5.7.2_sp_ds_acc_by_tdmp_kmclust3.html'),
  list(input = './5.7.3_sp_ds_acc_by_tdmp_kmclust4.Rmd', output = './reports/5.7.3_sp_ds_acc_by_tdmp_kmclust4.html'),
  list(input = './5.7.4_sp_ds_acc_by_tdmp_kmclust5.Rmd', output = './reports/5.7.4_sp_ds_acc_by_tdmp_kmclust5.html'),
  
  # ## Женщины acc
  # list(input = './5.8.1_sp_ds_acc_female_by_all_kmclust2.Rmd', output = './reports/5.8.1_sp_ds_acc_female_by_all_kmclust2.html'),
  # list(input = './5.8.2_sp_ds_acc_female_by_all_kmclust3.Rmd', output = './reports/5.8.2_sp_ds_acc_female_by_all_kmclust3.html'),
  # list(input = './5.8.3_sp_ds_acc_female_by_all_kmclust4.Rmd', output = './reports/5.8.3_sp_ds_acc_female_by_all_kmclust4.html'),
  # list(input = './5.8.4_sp_ds_acc_female_by_all_kmclust5.Rmd', output = './reports/5.8.4_sp_ds_acc_female_by_all_kmclust5.html'),
  # list(input = './5.8.1_sp_ds_acc_female_by_notcorr_kmclust2.Rmd', output = './reports/5.8.1_sp_ds_acc_female_by_notcorr_kmclust2.html'),
  # list(input = './5.8.2_sp_ds_acc_female_by_notcorr_kmclust3.Rmd', output = './reports/5.8.2_sp_ds_acc_female_by_notcorr_kmclust3.html'),
  # list(input = './5.8.3_sp_ds_acc_female_by_notcorr_kmclust4.Rmd', output = './reports/5.8.3_sp_ds_acc_female_by_notcorr_kmclust4.html'),
  # list(input = './5.8.4_sp_ds_acc_female_by_notcorr_kmclust5.Rmd', output = './reports/5.8.4_sp_ds_acc_female_by_notcorr_kmclust5.html'),
  # list(input = './5.8.1_sp_ds_acc_female_by_tdm_kmclust2.Rmd', output = './reports/5.8.1_sp_ds_acc_female_by_tdm_kmclust2.html'),
  # list(input = './5.8.2_sp_ds_acc_female_by_tdm_kmclust3.Rmd', output = './reports/5.8.2_sp_ds_acc_female_by_tdm_kmclust3.html'),
  # list(input = './5.8.3_sp_ds_acc_female_by_tdm_kmclust4.Rmd', output = './reports/5.8.3_sp_ds_acc_female_by_tdm_kmclust4.html'),
  # list(input = './5.8.4_sp_ds_acc_female_by_tdm_kmclust5.Rmd', output = './reports/5.8.4_sp_ds_acc_female_by_tdm_kmclust5.html'),
  # list(input = './5.8.1_sp_ds_acc_female_by_pauses_kmclust2.Rmd', output = './reports/5.8.1_sp_ds_acc_female_by_pauses_kmclust2.html'),
  # list(input = './5.8.2_sp_ds_acc_female_by_pauses_kmclust3.Rmd', output = './reports/5.8.2_sp_ds_acc_female_by_pauses_kmclust3.html'),
  # list(input = './5.8.3_sp_ds_acc_female_by_pauses_kmclust4.Rmd', output = './reports/5.8.3_sp_ds_acc_female_by_pauses_kmclust4.html'),
  # list(input = './5.8.4_sp_ds_acc_female_by_pauses_kmclust5.Rmd', output = './reports/5.8.4_sp_ds_acc_female_by_pauses_kmclust5.html'),
  # 
  # 
  # ## Мужчины acc
  # list(input = './5.9.1_sp_ds_acc_male_by_all_kmclust2.Rmd', output = './reports/5.9.1_sp_ds_acc_male_by_all_kmclust2.html'),
  # list(input = './5.9.2_sp_ds_acc_male_by_all_kmclust3.Rmd', output = './reports/5.9.2_sp_ds_acc_male_by_all_kmclust3.html'),
  # list(input = './5.9.3_sp_ds_acc_male_by_all_kmclust4.Rmd', output = './reports/5.9.3_sp_ds_acc_male_by_all_kmclust4.html'),
  # list(input = './5.9.4_sp_ds_acc_male_by_all_kmclust5.Rmd', output = './reports/5.9.4_sp_ds_acc_male_by_all_kmclust5.html'),
  # list(input = './5.9.1_sp_ds_acc_male_by_notcorr_kmclust2.Rmd', output = './reports/5.9.1_sp_ds_acc_male_by_notcorr_kmclust2.html'),
  # list(input = './5.9.2_sp_ds_acc_male_by_notcorr_kmclust3.Rmd', output = './reports/5.9.2_sp_ds_acc_male_by_notcorr_kmclust3.html'),
  # list(input = './5.9.3_sp_ds_acc_male_by_notcorr_kmclust4.Rmd', output = './reports/5.9.3_sp_ds_acc_male_by_notcorr_kmclust4.html'),
  # list(input = './5.9.4_sp_ds_acc_male_by_notcorr_kmclust5.Rmd', output = './reports/5.9.4_sp_ds_acc_male_by_notcorr_kmclust5.html'),
  # list(input = './5.9.1_sp_ds_acc_male_by_tdm_kmclust2.Rmd', output = './reports/5.9.1_sp_ds_acc_male_by_tdm_kmclust2.html'),
  # list(input = './5.9.2_sp_ds_acc_male_by_tdm_kmclust3.Rmd', output = './reports/5.9.2_sp_ds_acc_male_by_tdm_kmclust3.html'),
  # list(input = './5.9.3_sp_ds_acc_male_by_tdm_kmclust4.Rmd', output = './reports/5.9.3_sp_ds_acc_male_by_tdm_kmclust4.html'),
  # list(input = './5.9.4_sp_ds_acc_male_by_tdm_kmclust5.Rmd', output = './reports/5.9.4_sp_ds_acc_male_by_tdm_kmclust5.html'),
  # list(input = './5.9.1_sp_ds_acc_male_by_pauses_kmclust2.Rmd', output = './reports/5.9.1_sp_ds_acc_male_by_pauses_kmclust2.html'),
  # list(input = './5.9.2_sp_ds_acc_male_by_pauses_kmclust3.Rmd', output = './reports/5.9.2_sp_ds_acc_male_by_pauses_kmclust3.html'),
  # list(input = './5.9.3_sp_ds_acc_male_by_pauses_kmclust4.Rmd', output = './reports/5.9.3_sp_ds_acc_male_by_pauses_kmclust4.html'),
  # list(input = './5.9.4_sp_ds_acc_male_by_pauses_kmclust5.Rmd', output = './reports/5.9.4_sp_ds_acc_male_by_pauses_kmclust5.html'),
  
  ## Все респонденты. Задание на скорость
  list(input = './5.10.1_sp_ds_spd_by_all_kmclust2.Rmd', output = './reports/5.10.1_sp_ds_spd_by_all_kmclust2.html'),
  list(input = './5.10.2_sp_ds_spd_by_all_kmclust3.Rmd', output = './reports/5.10.2_sp_ds_spd_by_all_kmclust3.html'),
  list(input = './5.10.3_sp_ds_spd_by_all_kmclust4.Rmd', output = './reports/5.10.3_sp_ds_spd_by_all_kmclust4.html'),
  list(input = './5.10.4_sp_ds_spd_by_all_kmclust5.Rmd', output = './reports/5.10.4_sp_ds_spd_by_all_kmclust5.html'),
  list(input = './5.10.1_sp_ds_spd_by_notcorr_kmclust2.Rmd', output = './reports/5.10.1_sp_ds_spd_by_notcorr_kmclust2.html'),
  list(input = './5.10.2_sp_ds_spd_by_notcorr_kmclust3.Rmd', output = './reports/5.10.2_sp_ds_spd_by_notcorr_kmclust3.html'),
  list(input = './5.10.3_sp_ds_spd_by_notcorr_kmclust4.Rmd', output = './reports/5.10.3_sp_ds_spd_by_notcorr_kmclust4.html'),
  list(input = './5.10.4_sp_ds_spd_by_notcorr_kmclust5.Rmd', output = './reports/5.10.4_sp_ds_spd_by_notcorr_kmclust5.html'),
  list(input = './5.10.1_sp_ds_spd_by_tdm_kmclust2.Rmd', output = './reports/5.10.1_sp_ds_spd_by_tdm_kmclust2.html'),
  list(input = './5.10.2_sp_ds_spd_by_tdm_kmclust3.Rmd', output = './reports/5.10.2_sp_ds_spd_by_tdm_kmclust3.html'),
  list(input = './5.10.3_sp_ds_spd_by_tdm_kmclust4.Rmd', output = './reports/5.10.3_sp_ds_spd_by_tdm_kmclust4.html'),
  list(input = './5.10.4_sp_ds_spd_by_tdm_kmclust5.Rmd', output = './reports/5.10.4_sp_ds_spd_by_tdm_kmclust5.html'),
  list(input = './5.10.1_sp_ds_spd_by_pauses_kmclust2.Rmd', output = './reports/5.10.1_sp_ds_spd_by_pauses_kmclust2.html'),
  list(input = './5.10.2_sp_ds_spd_by_pauses_kmclust3.Rmd', output = './reports/5.10.2_sp_ds_spd_by_pauses_kmclust3.html'),
  list(input = './5.10.3_sp_ds_spd_by_pauses_kmclust4.Rmd', output = './reports/5.10.3_sp_ds_spd_by_pauses_kmclust4.html'),
  list(input = './5.10.4_sp_ds_spd_by_pauses_kmclust5.Rmd', output = './reports/5.10.4_sp_ds_spd_by_pauses_kmclust5.html'),
  list(input = './5.10.1_sp_ds_spd_by_tdmp_kmclust2.Rmd', output = './reports/5.10.1_sp_ds_spd_by_tdmp_kmclust2.html'),
  list(input = './5.10.2_sp_ds_spd_by_tdmp_kmclust3.Rmd', output = './reports/5.10.2_sp_ds_spd_by_tdmp_kmclust3.html'),
  list(input = './5.10.3_sp_ds_spd_by_tdmp_kmclust4.Rmd', output = './reports/5.10.3_sp_ds_spd_by_tdmp_kmclust4.html'),
  list(input = './5.10.4_sp_ds_spd_by_tdmp_kmclust5.Rmd', output = './reports/5.10.4_sp_ds_spd_by_tdmp_kmclust5.html')
  
  # ## Женщины spd
  # list(input = './5.11.1_sp_ds_spd_female_by_all_kmclust2.Rmd', output = './reports/5.11.1_sp_ds_spd_female_by_all_kmclust2.html'),
  # list(input = './5.11.2_sp_ds_spd_female_by_all_kmclust3.Rmd', output = './reports/5.11.2_sp_ds_spd_female_by_all_kmclust3.html'),
  # list(input = './5.11.3_sp_ds_spd_female_by_all_kmclust4.Rmd', output = './reports/5.11.3_sp_ds_spd_female_by_all_kmclust4.html'),
  # list(input = './5.11.4_sp_ds_spd_female_by_all_kmclust5.Rmd', output = './reports/5.11.4_sp_ds_spd_female_by_all_kmclust5.html'),
  # list(input = './5.11.1_sp_ds_spd_female_by_notcorr_kmclust2.Rmd', output = './reports/5.11.1_sp_ds_spd_female_by_notcorr_kmclust2.html'),
  # list(input = './5.11.2_sp_ds_spd_female_by_notcorr_kmclust3.Rmd', output = './reports/5.11.2_sp_ds_spd_female_by_notcorr_kmclust3.html'),
  # list(input = './5.11.3_sp_ds_spd_female_by_notcorr_kmclust4.Rmd', output = './reports/5.11.3_sp_ds_spd_female_by_notcorr_kmclust4.html'),
  # list(input = './5.11.4_sp_ds_spd_female_by_notcorr_kmclust5.Rmd', output = './reports/5.11.4_sp_ds_spd_female_by_notcorr_kmclust5.html'),
  # list(input = './5.11.1_sp_ds_spd_female_by_tdm_kmclust2.Rmd', output = './reports/5.11.1_sp_ds_spd_female_by_tdm_kmclust2.html'),
  # list(input = './5.11.2_sp_ds_spd_female_by_tdm_kmclust3.Rmd', output = './reports/5.11.2_sp_ds_spd_female_by_tdm_kmclust3.html'),
  # list(input = './5.11.3_sp_ds_spd_female_by_tdm_kmclust4.Rmd', output = './reports/5.11.3_sp_ds_spd_female_by_tdm_kmclust4.html'),
  # list(input = './5.11.4_sp_ds_spd_female_by_tdm_kmclust5.Rmd', output = './reports/5.11.4_sp_ds_spd_female_by_tdm_kmclust5.html'),
  # list(input = './5.11.1_sp_ds_spd_female_by_pauses_kmclust2.Rmd', output = './reports/5.11.1_sp_ds_spd_female_by_pauses_kmclust2.html'),
  # list(input = './5.11.2_sp_ds_spd_female_by_pauses_kmclust3.Rmd', output = './reports/5.11.2_sp_ds_spd_female_by_pauses_kmclust3.html'),
  # list(input = './5.11.3_sp_ds_spd_female_by_pauses_kmclust4.Rmd', output = './reports/5.11.3_sp_ds_spd_female_by_pauses_kmclust4.html'),
  # list(input = './5.11.4_sp_ds_spd_female_by_pauses_kmclust5.Rmd', output = './reports/5.11.4_sp_ds_spd_female_by_pauses_kmclust5.html'),
  # 
  # ## Мужчины spd
  # list(input = './5.12.1_sp_ds_spd_male_by_all_kmclust2.Rmd', output = './reports/5.12.1_sp_ds_spd_male_by_all_kmclust2.html'),
  # list(input = './5.12.2_sp_ds_spd_male_by_all_kmclust3.Rmd', output = './reports/5.12.2_sp_ds_spd_male_by_all_kmclust3.html'),
  # list(input = './5.12.3_sp_ds_spd_male_by_all_kmclust4.Rmd', output = './reports/5.12.3_sp_ds_spd_male_by_all_kmclust4.html'),
  # list(input = './5.12.4_sp_ds_spd_male_by_all_kmclust5.Rmd', output = './reports/5.12.4_sp_ds_spd_male_by_all_kmclust5.html'),
  # list(input = './5.12.1_sp_ds_spd_male_by_notcorr_kmclust2.Rmd', output = './reports/5.12.1_sp_ds_spd_male_by_notcorr_kmclust2.html'),
  # list(input = './5.12.2_sp_ds_spd_male_by_notcorr_kmclust3.Rmd', output = './reports/5.12.2_sp_ds_spd_male_by_notcorr_kmclust3.html'),
  # list(input = './5.12.3_sp_ds_spd_male_by_notcorr_kmclust4.Rmd', output = './reports/5.12.3_sp_ds_spd_male_by_notcorr_kmclust4.html'),
  # list(input = './5.12.4_sp_ds_spd_male_by_notcorr_kmclust5.Rmd', output = './reports/5.12.4_sp_ds_spd_male_by_notcorr_kmclust5.html'),
  # list(input = './5.12.1_sp_ds_spd_male_by_tdm_kmclust2.Rmd', output = './reports/5.12.1_sp_ds_spd_male_by_tdm_kmclust2.html'),
  # list(input = './5.12.2_sp_ds_spd_male_by_tdm_kmclust3.Rmd', output = './reports/5.12.2_sp_ds_spd_male_by_tdm_kmclust3.html'),
  # list(input = './5.12.3_sp_ds_spd_male_by_tdm_kmclust4.Rmd', output = './reports/5.12.3_sp_ds_spd_male_by_tdm_kmclust4.html'),
  # list(input = './5.12.4_sp_ds_spd_male_by_tdm_kmclust5.Rmd', output = './reports/5.12.4_sp_ds_spd_male_by_tdm_kmclust5.html'),
  # list(input = './5.12.1_sp_ds_spd_male_by_pauses_kmclust2.Rmd', output = './reports/5.12.1_sp_ds_spd_male_by_pauses_kmclust2.html'),
  # list(input = './5.12.2_sp_ds_spd_male_by_pauses_kmclust3.Rmd', output = './reports/5.12.2_sp_ds_spd_male_by_pauses_kmclust3.html'),
  # list(input = './5.12.3_sp_ds_spd_male_by_pauses_kmclust4.Rmd', output = './reports/5.12.3_sp_ds_spd_male_by_pauses_kmclust4.html'),
  # list(input = './5.12.4_sp_ds_spd_male_by_pauses_kmclust5.Rmd', output = './reports/5.12.4_sp_ds_spd_male_by_pauses_kmclust5.html')
)
  
files_ds_kmdclust <- list(
  # kmdclust
  ## Все респонденты. Задание на точность.
  list(input = './4.13.1_ds_acc_by_all_kmdclust2.Rmd', output = './reports/4.13.1_ds_acc_by_all_kmdclust2.html'),
  list(input = './4.13.2_ds_acc_by_all_kmdclust3.Rmd', output = './reports/4.13.2_ds_acc_by_all_kmdclust3.html'),
  list(input = './4.13.3_ds_acc_by_all_kmdclust4.Rmd', output = './reports/4.13.3_ds_acc_by_all_kmdclust4.html'),
  list(input = './4.13.4_ds_acc_by_all_kmdclust5.Rmd', output = './reports/4.13.4_ds_acc_by_all_kmdclust5.html'),
  list(input = './4.13.1_ds_acc_by_notcorr_kmdclust2.Rmd', output = './reports/4.13.1_ds_acc_by_notcorr_kmdclust2.html'),
  list(input = './4.13.2_ds_acc_by_notcorr_kmdclust3.Rmd', output = './reports/4.13.2_ds_acc_by_notcorr_kmdclust3.html'),
  list(input = './4.13.3_ds_acc_by_notcorr_kmdclust4.Rmd', output = './reports/4.13.3_ds_acc_by_notcorr_kmdclust4.html'),
  list(input = './4.13.4_ds_acc_by_notcorr_kmdclust5.Rmd', output = './reports/4.13.4_ds_acc_by_notcorr_kmdclust5.html'),
  list(input = './4.13.1_ds_acc_by_tdm_kmdclust2.Rmd', output = './reports/4.13.1_ds_acc_by_tdm_kmdclust2.html'),
  list(input = './4.13.2_ds_acc_by_tdm_kmdclust3.Rmd', output = './reports/4.13.2_ds_acc_by_tdm_kmdclust3.html'),
  list(input = './4.13.3_ds_acc_by_tdm_kmdclust4.Rmd', output = './reports/4.13.3_ds_acc_by_tdm_kmdclust4.html'),
  list(input = './4.13.4_ds_acc_by_tdm_kmdclust5.Rmd', output = './reports/4.13.4_ds_acc_by_tdm_kmdclust5.html'),
  list(input = './4.13.1_ds_acc_by_pauses_kmdclust2.Rmd', output = './reports/4.13.1_ds_acc_by_pauses_kmdclust2.html'),
  list(input = './4.13.2_ds_acc_by_pauses_kmdclust3.Rmd', output = './reports/4.13.2_ds_acc_by_pauses_kmdclust3.html'),
  list(input = './4.13.3_ds_acc_by_pauses_kmdclust4.Rmd', output = './reports/4.13.3_ds_acc_by_pauses_kmdclust4.html'),
  list(input = './4.13.4_ds_acc_by_pauses_kmdclust5.Rmd', output = './reports/4.13.4_ds_acc_by_pauses_kmdclust5.html'),
  list(input = './4.13.1_ds_acc_by_tdmp_kmdclust2.Rmd', output = './reports/4.13.1_ds_acc_by_tdmp_kmdclust2.html'),
  list(input = './4.13.2_ds_acc_by_tdmp_kmdclust3.Rmd', output = './reports/4.13.2_ds_acc_by_tdmp_kmdclust3.html'),
  list(input = './4.13.3_ds_acc_by_tdmp_kmdclust4.Rmd', output = './reports/4.13.3_ds_acc_by_tdmp_kmdclust4.html'),
  list(input = './4.13.4_ds_acc_by_tdmp_kmdclust5.Rmd', output = './reports/4.13.4_ds_acc_by_tdmp_kmdclust5.html'),
  
  # ## Женщины acc
  # list(input = './4.14.1_ds_acc_female_by_all_kmdclust2.Rmd', output = './reports/4.14.1_ds_acc_female_by_all_kmdclust2.html'),
  # list(input = './4.14.2_ds_acc_female_by_all_kmdclust3.Rmd', output = './reports/4.14.2_ds_acc_female_by_all_kmdclust3.html'),
  # list(input = './4.14.3_ds_acc_female_by_all_kmdclust4.Rmd', output = './reports/4.14.3_ds_acc_female_by_all_kmdclust4.html'),
  # list(input = './4.14.4_ds_acc_female_by_all_kmdclust5.Rmd', output = './reports/4.14.4_ds_acc_female_by_all_kmdclust5.html'),
  # list(input = './4.14.1_ds_acc_female_by_notcorr_kmdclust2.Rmd', output = './reports/4.14.1_ds_acc_female_by_notcorr_kmdclust2.html'),
  # list(input = './4.14.2_ds_acc_female_by_notcorr_kmdclust3.Rmd', output = './reports/4.14.2_ds_acc_female_by_notcorr_kmdclust3.html'),
  # list(input = './4.14.3_ds_acc_female_by_notcorr_kmdclust4.Rmd', output = './reports/4.14.3_ds_acc_female_by_notcorr_kmdclust4.html'),
  # list(input = './4.14.4_ds_acc_female_by_notcorr_kmdclust5.Rmd', output = './reports/4.14.4_ds_acc_female_by_notcorr_kmdclust5.html'),
  # list(input = './4.14.1_ds_acc_female_by_tdm_kmdclust2.Rmd', output = './reports/4.14.1_ds_acc_female_by_tdm_kmdclust2.html'),
  # list(input = './4.14.2_ds_acc_female_by_tdm_kmdclust3.Rmd', output = './reports/4.14.2_ds_acc_female_by_tdm_kmdclust3.html'),
  # list(input = './4.14.3_ds_acc_female_by_tdm_kmdclust4.Rmd', output = './reports/4.14.3_ds_acc_female_by_tdm_kmdclust4.html'),
  # list(input = './4.14.4_ds_acc_female_by_tdm_kmdclust5.Rmd', output = './reports/4.14.4_ds_acc_female_by_tdm_kmdclust5.html'),
  # list(input = './4.14.1_ds_acc_female_by_pauses_kmdclust2.Rmd', output = './reports/4.14.1_ds_acc_female_by_pauses_kmdclust2.html'),
  # list(input = './4.14.2_ds_acc_female_by_pauses_kmdclust3.Rmd', output = './reports/4.14.2_ds_acc_female_by_pauses_kmdclust3.html'),
  # list(input = './4.14.3_ds_acc_female_by_pauses_kmdclust4.Rmd', output = './reports/4.14.3_ds_acc_female_by_pauses_kmdclust4.html'),
  # list(input = './4.14.4_ds_acc_female_by_pauses_kmdclust5.Rmd', output = './reports/4.14.4_ds_acc_female_by_pauses_kmdclust5.html'),
  # ## Мужчины acc
  # list(input = './4.15.1_ds_acc_male_by_all_kmdclust2.Rmd', output = './reports/4.15.1_ds_acc_male_by_all_kmdclust2.html'),
  # list(input = './4.15.2_ds_acc_male_by_all_kmdclust3.Rmd', output = './reports/4.15.2_ds_acc_male_by_all_kmdclust3.html'),
  # list(input = './4.15.3_ds_acc_male_by_all_kmdclust4.Rmd', output = './reports/4.15.3_ds_acc_male_by_all_kmdclust4.html'),
  # list(input = './4.15.4_ds_acc_male_by_all_kmdclust5.Rmd', output = './reports/4.15.4_ds_acc_male_by_all_kmdclust5.html'),
  # list(input = './4.15.1_ds_acc_male_by_notcorr_kmdclust2.Rmd', output = './reports/4.15.1_ds_acc_male_by_notcorr_kmdclust2.html'),
  # list(input = './4.15.2_ds_acc_male_by_notcorr_kmdclust3.Rmd', output = './reports/4.15.2_ds_acc_male_by_notcorr_kmdclust3.html'),
  # list(input = './4.15.3_ds_acc_male_by_notcorr_kmdclust4.Rmd', output = './reports/4.15.3_ds_acc_male_by_notcorr_kmdclust4.html'),
  # list(input = './4.15.4_ds_acc_male_by_notcorr_kmdclust5.Rmd', output = './reports/4.15.4_ds_acc_male_by_notcorr_kmdclust5.html'),
  # list(input = './4.15.1_ds_acc_male_by_tdm_kmdclust2.Rmd', output = './reports/4.15.1_ds_acc_male_by_tdm_kmdclust2.html'),
  # list(input = './4.15.2_ds_acc_male_by_tdm_kmdclust3.Rmd', output = './reports/4.15.2_ds_acc_male_by_tdm_kmdclust3.html'),
  # list(input = './4.15.3_ds_acc_male_by_tdm_kmdclust4.Rmd', output = './reports/4.15.3_ds_acc_male_by_tdm_kmdclust4.html'),
  # list(input = './4.15.4_ds_acc_male_by_tdm_kmdclust5.Rmd', output = './reports/4.15.4_ds_acc_male_by_tdm_kmdclust5.html'),
  # list(input = './4.15.1_ds_acc_male_by_pauses_kmdclust2.Rmd', output = './reports/4.15.1_ds_acc_male_by_pauses_kmdclust2.html'),
  # list(input = './4.15.2_ds_acc_male_by_pauses_kmdclust3.Rmd', output = './reports/4.15.2_ds_acc_male_by_pauses_kmdclust3.html'),
  # list(input = './4.15.3_ds_acc_male_by_pauses_kmdclust4.Rmd', output = './reports/4.15.3_ds_acc_male_by_pauses_kmdclust4.html'),
  # list(input = './4.15.4_ds_acc_male_by_pauses_kmdclust5.Rmd', output = './reports/4.15.4_ds_acc_male_by_pauses_kmdclust5.html'),
  
  ## Все респонденты. Задание на скорость
  list(input = './4.16.1_ds_spd_by_all_kmdclust2.Rmd', output = './reports/4.16.1_ds_spd_by_all_kmdclust2.html'),
  list(input = './4.16.2_ds_spd_by_all_kmdclust3.Rmd', output = './reports/4.16.2_ds_spd_by_all_kmdclust3.html'),
  list(input = './4.16.3_ds_spd_by_all_kmdclust4.Rmd', output = './reports/4.16.3_ds_spd_by_all_kmdclust4.html'),
  list(input = './4.16.4_ds_spd_by_all_kmdclust5.Rmd', output = './reports/4.16.4_ds_spd_by_all_kmdclust5.html'),
  list(input = './4.16.1_ds_spd_by_notcorr_kmdclust2.Rmd', output = './reports/4.16.1_ds_spd_by_notcorr_kmdclust2.html'),
  list(input = './4.16.2_ds_spd_by_notcorr_kmdclust3.Rmd', output = './reports/4.16.2_ds_spd_by_notcorr_kmdclust3.html'),
  list(input = './4.16.3_ds_spd_by_notcorr_kmdclust4.Rmd', output = './reports/4.16.3_ds_spd_by_notcorr_kmdclust4.html'),
  list(input = './4.16.4_ds_spd_by_notcorr_kmdclust5.Rmd', output = './reports/4.16.4_ds_spd_by_notcorr_kmdclust5.html'),
  list(input = './4.16.1_ds_spd_by_tdm_kmdclust2.Rmd', output = './reports/4.16.1_ds_spd_by_tdm_kmdclust2.html'),
  list(input = './4.16.2_ds_spd_by_tdm_kmdclust3.Rmd', output = './reports/4.16.2_ds_spd_by_tdm_kmdclust3.html'),
  list(input = './4.16.3_ds_spd_by_tdm_kmdclust4.Rmd', output = './reports/4.16.3_ds_spd_by_tdm_kmdclust4.html'),
  list(input = './4.16.4_ds_spd_by_tdm_kmdclust5.Rmd', output = './reports/4.16.4_ds_spd_by_tdm_kmdclust5.html'),
  list(input = './4.16.1_ds_spd_by_pauses_kmdclust2.Rmd', output = './reports/4.16.1_ds_spd_by_pauses_kmdclust2.html'),
  list(input = './4.16.2_ds_spd_by_pauses_kmdclust3.Rmd', output = './reports/4.16.2_ds_spd_by_pauses_kmdclust3.html'),
  list(input = './4.16.3_ds_spd_by_pauses_kmdclust4.Rmd', output = './reports/4.16.3_ds_spd_by_pauses_kmdclust4.html'),
  list(input = './4.16.4_ds_spd_by_pauses_kmdclust5.Rmd', output = './reports/4.16.4_ds_spd_by_pauses_kmdclust5.html'),
  list(input = './4.16.1_ds_spd_by_tdmp_kmdclust2.Rmd', output = './reports/4.16.1_ds_spd_by_tdmp_kmdclust2.html'),
  list(input = './4.16.2_ds_spd_by_tdmp_kmdclust3.Rmd', output = './reports/4.16.2_ds_spd_by_tdmp_kmdclust3.html'),
  list(input = './4.16.3_ds_spd_by_tdmp_kmdclust4.Rmd', output = './reports/4.16.3_ds_spd_by_tdmp_kmdclust4.html'),
  list(input = './4.16.4_ds_spd_by_tdmp_kmdclust5.Rmd', output = './reports/4.16.4_ds_spd_by_tdmp_kmdclust5.html')
  
  # ## Женщины spd
  # list(input = './4.17.1_ds_spd_female_by_all_kmdclust2.Rmd', output = './reports/4.17.1_ds_spd_female_by_all_kmdclust2.html'),
  # list(input = './4.17.2_ds_spd_female_by_all_kmdclust3.Rmd', output = './reports/4.17.2_ds_spd_female_by_all_kmdclust3.html'),
  # list(input = './4.17.3_ds_spd_female_by_all_kmdclust4.Rmd', output = './reports/4.17.3_ds_spd_female_by_all_kmdclust4.html'),
  # list(input = './4.17.4_ds_spd_female_by_all_kmdclust5.Rmd', output = './reports/4.17.4_ds_spd_female_by_all_kmdclust5.html'),
  # list(input = './4.17.1_ds_spd_female_by_notcorr_kmdclust2.Rmd', output = './reports/4.17.1_ds_spd_female_by_notcorr_kmdclust2.html'),
  # list(input = './4.17.2_ds_spd_female_by_notcorr_kmdclust3.Rmd', output = './reports/4.17.2_ds_spd_female_by_notcorr_kmdclust3.html'),
  # list(input = './4.17.3_ds_spd_female_by_notcorr_kmdclust4.Rmd', output = './reports/4.17.3_ds_spd_female_by_notcorr_kmdclust4.html'),
  # list(input = './4.17.4_ds_spd_female_by_notcorr_kmdclust5.Rmd', output = './reports/4.17.4_ds_spd_female_by_notcorr_kmdclust5.html'),
  # list(input = './4.17.1_ds_spd_female_by_tdm_kmdclust2.Rmd', output = './reports/4.17.1_ds_spd_female_by_tdm_kmdclust2.html'),
  # list(input = './4.17.2_ds_spd_female_by_tdm_kmdclust3.Rmd', output = './reports/4.17.2_ds_spd_female_by_tdm_kmdclust3.html'),
  # list(input = './4.17.3_ds_spd_female_by_tdm_kmdclust4.Rmd', output = './reports/4.17.3_ds_spd_female_by_tdm_kmdclust4.html'),
  # list(input = './4.17.4_ds_spd_female_by_tdm_kmdclust5.Rmd', output = './reports/4.17.4_ds_spd_female_by_tdm_kmdclust5.html'),
  # list(input = './4.17.1_ds_spd_female_by_pauses_kmdclust2.Rmd', output = './reports/4.17.1_ds_spd_female_by_pauses_kmdclust2.html'),
  # list(input = './4.17.2_ds_spd_female_by_pauses_kmdclust3.Rmd', output = './reports/4.17.2_ds_spd_female_by_pauses_kmdclust3.html'),
  # list(input = './4.17.3_ds_spd_female_by_pauses_kmdclust4.Rmd', output = './reports/4.17.3_ds_spd_female_by_pauses_kmdclust4.html'),
  # list(input = './4.17.4_ds_spd_female_by_pauses_kmdclust5.Rmd', output = './reports/4.17.4_ds_spd_female_by_pauses_kmdclust5.html'),
  # 
  # ## Мужчины spd
  # list(input = './4.18.1_ds_spd_male_by_all_kmdclust2.Rmd', output = './reports/4.18.1_ds_spd_male_by_all_kmdclust2.html'),
  # list(input = './4.18.2_ds_spd_male_by_all_kmdclust3.Rmd', output = './reports/4.18.2_ds_spd_male_by_all_kmdclust3.html'),
  # list(input = './4.18.3_ds_spd_male_by_all_kmdclust4.Rmd', output = './reports/4.18.3_ds_spd_male_by_all_kmdclust4.html'),
  # list(input = './4.18.4_ds_spd_male_by_all_kmdclust5.Rmd', output = './reports/4.18.4_ds_spd_male_by_all_kmdclust5.html'),
  # list(input = './4.18.1_ds_spd_male_by_notcorr_kmdclust2.Rmd', output = './reports/4.18.1_ds_spd_male_by_notcorr_kmdclust2.html'),
  # list(input = './4.18.2_ds_spd_male_by_notcorr_kmdclust3.Rmd', output = './reports/4.18.2_ds_spd_male_by_notcorr_kmdclust3.html'),
  # list(input = './4.18.3_ds_spd_male_by_notcorr_kmdclust4.Rmd', output = './reports/4.18.3_ds_spd_male_by_notcorr_kmdclust4.html'),
  # list(input = './4.18.4_ds_spd_male_by_notcorr_kmdclust5.Rmd', output = './reports/4.18.4_ds_spd_male_by_notcorr_kmdclust5.html'),
  # list(input = './4.18.1_ds_spd_male_by_tdm_kmdclust2.Rmd', output = './reports/4.18.1_ds_spd_male_by_tdm_kmdclust2.html'),
  # list(input = './4.18.2_ds_spd_male_by_tdm_kmdclust3.Rmd', output = './reports/4.18.2_ds_spd_male_by_tdm_kmdclust3.html'),
  # list(input = './4.18.3_ds_spd_male_by_tdm_kmdclust4.Rmd', output = './reports/4.18.3_ds_spd_male_by_tdm_kmdclust4.html'),
  # list(input = './4.18.4_ds_spd_male_by_tdm_kmdclust5.Rmd', output = './reports/4.18.4_ds_spd_male_by_tdm_kmdclust5.html'),
  # list(input = './4.18.1_ds_spd_male_by_pauses_kmdclust2.Rmd', output = './reports/4.18.1_ds_spd_male_by_pauses_kmdclust2.html'),
  # list(input = './4.18.2_ds_spd_male_by_pauses_kmdclust3.Rmd', output = './reports/4.18.2_ds_spd_male_by_pauses_kmdclust3.html'),
  # list(input = './4.18.3_ds_spd_male_by_pauses_kmdclust4.Rmd', output = './reports/4.18.3_ds_spd_male_by_pauses_kmdclust4.html'),
  # list(input = './4.18.4_ds_spd_male_by_pauses_kmdclust5.Rmd', output = './reports/4.18.4_ds_spd_male_by_pauses_kmdclust5.html')
)  
  
files_sp_kmdclust <- list(
  # Психодиагностика и кластеры
  ## Все респонденты. Задание на точность
  list(input = './5.13.1_sp_ds_acc_by_all_kmdclust2.Rmd', output = './reports/5.13.1_sp_ds_acc_by_all_kmdclust2.html'),
  list(input = './5.13.2_sp_ds_acc_by_all_kmdclust3.Rmd', output = './reports/5.13.2_sp_ds_acc_by_all_kmdclust3.html'),
  list(input = './5.13.3_sp_ds_acc_by_all_kmdclust4.Rmd', output = './reports/5.13.3_sp_ds_acc_by_all_kmdclust4.html'),
  list(input = './5.13.4_sp_ds_acc_by_all_kmdclust5.Rmd', output = './reports/5.13.4_sp_ds_acc_by_all_kmdclust5.html'),
  list(input = './5.13.1_sp_ds_acc_by_notcorr_kmdclust2.Rmd', output = './reports/5.13.1_sp_ds_acc_by_notcorr_kmdclust2.html'),
  list(input = './5.13.2_sp_ds_acc_by_notcorr_kmdclust3.Rmd', output = './reports/5.13.2_sp_ds_acc_by_notcorr_kmdclust3.html'),
  list(input = './5.13.3_sp_ds_acc_by_notcorr_kmdclust4.Rmd', output = './reports/5.13.3_sp_ds_acc_by_notcorr_kmdclust4.html'),
  list(input = './5.13.4_sp_ds_acc_by_notcorr_kmdclust5.Rmd', output = './reports/5.13.4_sp_ds_acc_by_notcorr_kmdclust5.html'),
  list(input = './5.13.1_sp_ds_acc_by_tdm_kmdclust2.Rmd', output = './reports/5.13.1_sp_ds_acc_by_tdm_kmdclust2.html'),
  list(input = './5.13.2_sp_ds_acc_by_tdm_kmdclust3.Rmd', output = './reports/5.13.2_sp_ds_acc_by_tdm_kmdclust3.html'),
  list(input = './5.13.3_sp_ds_acc_by_tdm_kmdclust4.Rmd', output = './reports/5.13.3_sp_ds_acc_by_tdm_kmdclust4.html'),
  list(input = './5.13.4_sp_ds_acc_by_tdm_kmdclust5.Rmd', output = './reports/5.13.4_sp_ds_acc_by_tdm_kmdclust5.html'),
  list(input = './5.13.1_sp_ds_acc_by_pauses_kmdclust2.Rmd', output = './reports/5.13.1_sp_ds_acc_by_pauses_kmdclust2.html'),
  list(input = './5.13.2_sp_ds_acc_by_pauses_kmdclust3.Rmd', output = './reports/5.13.2_sp_ds_acc_by_pauses_kmdclust3.html'),
  list(input = './5.13.3_sp_ds_acc_by_pauses_kmdclust4.Rmd', output = './reports/5.13.3_sp_ds_acc_by_pauses_kmdclust4.html'),
  list(input = './5.13.4_sp_ds_acc_by_pauses_kmdclust5.Rmd', output = './reports/5.13.4_sp_ds_acc_by_pauses_kmdclust5.html'),
  list(input = './5.13.1_sp_ds_acc_by_tdmp_kmdclust2.Rmd', output = './reports/5.13.1_sp_ds_acc_by_tdmp_kmdclust2.html'),
  list(input = './5.13.2_sp_ds_acc_by_tdmp_kmdclust3.Rmd', output = './reports/5.13.2_sp_ds_acc_by_tdmp_kmdclust3.html'),
  list(input = './5.13.3_sp_ds_acc_by_tdmp_kmdclust4.Rmd', output = './reports/5.13.3_sp_ds_acc_by_tdmp_kmdclust4.html'),
  list(input = './5.13.4_sp_ds_acc_by_tdmp_kmdclust5.Rmd', output = './reports/5.13.4_sp_ds_acc_by_tdmp_kmdclust5.html'),
  
  # ## Женщины acc
  # list(input = './5.14.1_sp_ds_acc_female_by_all_kmdclust2.Rmd', output = './reports/5.14.1_sp_ds_acc_female_by_all_kmdclust2.html'),
  # list(input = './5.14.2_sp_ds_acc_female_by_all_kmdclust3.Rmd', output = './reports/5.14.2_sp_ds_acc_female_by_all_kmdclust3.html'),
  # list(input = './5.14.3_sp_ds_acc_female_by_all_kmdclust4.Rmd', output = './reports/5.14.3_sp_ds_acc_female_by_all_kmdclust4.html'),
  # list(input = './5.14.4_sp_ds_acc_female_by_all_kmdclust5.Rmd', output = './reports/5.14.4_sp_ds_acc_female_by_all_kmdclust5.html'),
  # list(input = './5.14.1_sp_ds_acc_female_by_notcorr_kmdclust2.Rmd', output = './reports/5.14.1_sp_ds_acc_female_by_notcorr_kmdclust2.html'),
  # list(input = './5.14.2_sp_ds_acc_female_by_notcorr_kmdclust3.Rmd', output = './reports/5.14.2_sp_ds_acc_female_by_notcorr_kmdclust3.html'),
  # list(input = './5.14.3_sp_ds_acc_female_by_notcorr_kmdclust4.Rmd', output = './reports/5.14.3_sp_ds_acc_female_by_notcorr_kmdclust4.html'),
  # list(input = './5.14.4_sp_ds_acc_female_by_notcorr_kmdclust5.Rmd', output = './reports/5.14.4_sp_ds_acc_female_by_notcorr_kmdclust5.html'),
  # list(input = './5.14.1_sp_ds_acc_female_by_tdm_kmdclust2.Rmd', output = './reports/5.14.1_sp_ds_acc_female_by_tdm_kmdclust2.html'),
  # list(input = './5.14.2_sp_ds_acc_female_by_tdm_kmdclust3.Rmd', output = './reports/5.14.2_sp_ds_acc_female_by_tdm_kmdclust3.html'),
  # list(input = './5.14.3_sp_ds_acc_female_by_tdm_kmdclust4.Rmd', output = './reports/5.14.3_sp_ds_acc_female_by_tdm_kmdclust4.html'),
  # list(input = './5.14.4_sp_ds_acc_female_by_tdm_kmdclust5.Rmd', output = './reports/5.14.4_sp_ds_acc_female_by_tdm_kmdclust5.html'),
  # list(input = './5.14.1_sp_ds_acc_female_by_pauses_kmdclust2.Rmd', output = './reports/5.14.1_sp_ds_acc_female_by_pauses_kmdclust2.html'),
  # list(input = './5.14.2_sp_ds_acc_female_by_pauses_kmdclust3.Rmd', output = './reports/5.14.2_sp_ds_acc_female_by_pauses_kmdclust3.html'),
  # list(input = './5.14.3_sp_ds_acc_female_by_pauses_kmdclust4.Rmd', output = './reports/5.14.3_sp_ds_acc_female_by_pauses_kmdclust4.html'),
  # list(input = './5.14.4_sp_ds_acc_female_by_pauses_kmdclust5.Rmd', output = './reports/5.14.4_sp_ds_acc_female_by_pauses_kmdclust5.html'),
  # 
  # 
  # ## Мужчины acc
  # list(input = './5.15.1_sp_ds_acc_male_by_all_kmdclust2.Rmd', output = './reports/5.15.1_sp_ds_acc_male_by_all_kmdclust2.html'),
  # list(input = './5.15.2_sp_ds_acc_male_by_all_kmdclust3.Rmd', output = './reports/5.15.2_sp_ds_acc_male_by_all_kmdclust3.html'),
  # list(input = './5.15.3_sp_ds_acc_male_by_all_kmdclust4.Rmd', output = './reports/5.15.3_sp_ds_acc_male_by_all_kmdclust4.html'),
  # list(input = './5.15.4_sp_ds_acc_male_by_all_kmdclust5.Rmd', output = './reports/5.15.4_sp_ds_acc_male_by_all_kmdclust5.html'),
  # list(input = './5.15.1_sp_ds_acc_male_by_notcorr_kmdclust2.Rmd', output = './reports/5.15.1_sp_ds_acc_male_by_notcorr_kmdclust2.html'),
  # list(input = './5.15.2_sp_ds_acc_male_by_notcorr_kmdclust3.Rmd', output = './reports/5.15.2_sp_ds_acc_male_by_notcorr_kmdclust3.html'),
  # list(input = './5.15.3_sp_ds_acc_male_by_notcorr_kmdclust4.Rmd', output = './reports/5.15.3_sp_ds_acc_male_by_notcorr_kmdclust4.html'),
  # list(input = './5.15.4_sp_ds_acc_male_by_notcorr_kmdclust5.Rmd', output = './reports/5.15.4_sp_ds_acc_male_by_notcorr_kmdclust5.html'),
  # list(input = './5.15.1_sp_ds_acc_male_by_tdm_kmdclust2.Rmd', output = './reports/5.15.1_sp_ds_acc_male_by_tdm_kmdclust2.html'),
  # list(input = './5.15.2_sp_ds_acc_male_by_tdm_kmdclust3.Rmd', output = './reports/5.15.2_sp_ds_acc_male_by_tdm_kmdclust3.html'),
  # list(input = './5.15.3_sp_ds_acc_male_by_tdm_kmdclust4.Rmd', output = './reports/5.15.3_sp_ds_acc_male_by_tdm_kmdclust4.html'),
  # list(input = './5.15.4_sp_ds_acc_male_by_tdm_kmdclust5.Rmd', output = './reports/5.15.4_sp_ds_acc_male_by_tdm_kmdclust5.html'),
  # list(input = './5.15.1_sp_ds_acc_male_by_pauses_kmdclust2.Rmd', output = './reports/5.15.1_sp_ds_acc_male_by_pauses_kmdclust2.html'),
  # list(input = './5.15.2_sp_ds_acc_male_by_pauses_kmdclust3.Rmd', output = './reports/5.15.2_sp_ds_acc_male_by_pauses_kmdclust3.html'),
  # list(input = './5.15.3_sp_ds_acc_male_by_pauses_kmdclust4.Rmd', output = './reports/5.15.3_sp_ds_acc_male_by_pauses_kmdclust4.html'),
  # list(input = './5.15.4_sp_ds_acc_male_by_pauses_kmdclust5.Rmd', output = './reports/5.15.4_sp_ds_acc_male_by_pauses_kmdclust5.html'),
  
  ## Все респонденты. Задание на скорость
  list(input = './5.16.1_sp_ds_spd_by_all_kmdclust2.Rmd', output = './reports/5.16.1_sp_ds_spd_by_all_kmdclust2.html'),
  list(input = './5.16.2_sp_ds_spd_by_all_kmdclust3.Rmd', output = './reports/5.16.2_sp_ds_spd_by_all_kmdclust3.html'),
  list(input = './5.16.3_sp_ds_spd_by_all_kmdclust4.Rmd', output = './reports/5.16.3_sp_ds_spd_by_all_kmdclust4.html'),
  list(input = './5.16.4_sp_ds_spd_by_all_kmdclust5.Rmd', output = './reports/5.16.4_sp_ds_spd_by_all_kmdclust5.html'),
  list(input = './5.16.1_sp_ds_spd_by_notcorr_kmdclust2.Rmd', output = './reports/5.16.1_sp_ds_spd_by_notcorr_kmdclust2.html'),
  list(input = './5.16.2_sp_ds_spd_by_notcorr_kmdclust3.Rmd', output = './reports/5.16.2_sp_ds_spd_by_notcorr_kmdclust3.html'),
  list(input = './5.16.3_sp_ds_spd_by_notcorr_kmdclust4.Rmd', output = './reports/5.16.3_sp_ds_spd_by_notcorr_kmdclust4.html'),
  list(input = './5.16.4_sp_ds_spd_by_notcorr_kmdclust5.Rmd', output = './reports/5.16.4_sp_ds_spd_by_notcorr_kmdclust5.html'),
  list(input = './5.16.1_sp_ds_spd_by_tdm_kmdclust2.Rmd', output = './reports/5.16.1_sp_ds_spd_by_tdm_kmdclust2.html'),
  list(input = './5.16.2_sp_ds_spd_by_tdm_kmdclust3.Rmd', output = './reports/5.16.2_sp_ds_spd_by_tdm_kmdclust3.html'),
  list(input = './5.16.3_sp_ds_spd_by_tdm_kmdclust4.Rmd', output = './reports/5.16.3_sp_ds_spd_by_tdm_kmdclust4.html'),
  list(input = './5.16.4_sp_ds_spd_by_tdm_kmdclust5.Rmd', output = './reports/5.16.4_sp_ds_spd_by_tdm_kmdclust5.html'),
  list(input = './5.16.1_sp_ds_spd_by_pauses_kmdclust2.Rmd', output = './reports/5.16.1_sp_ds_spd_by_pauses_kmdclust2.html'),
  list(input = './5.16.2_sp_ds_spd_by_pauses_kmdclust3.Rmd', output = './reports/5.16.2_sp_ds_spd_by_pauses_kmdclust3.html'),
  list(input = './5.16.3_sp_ds_spd_by_pauses_kmdclust4.Rmd', output = './reports/5.16.3_sp_ds_spd_by_pauses_kmdclust4.html'),
  list(input = './5.16.4_sp_ds_spd_by_pauses_kmdclust5.Rmd', output = './reports/5.16.4_sp_ds_spd_by_pauses_kmdclust5.html'),
  list(input = './5.16.1_sp_ds_spd_by_tdmp_kmdclust2.Rmd', output = './reports/5.16.1_sp_ds_spd_by_tdmp_kmdclust2.html'),
  list(input = './5.16.2_sp_ds_spd_by_tdmp_kmdclust3.Rmd', output = './reports/5.16.2_sp_ds_spd_by_tdmp_kmdclust3.html'),
  list(input = './5.16.3_sp_ds_spd_by_tdmp_kmdclust4.Rmd', output = './reports/5.16.3_sp_ds_spd_by_tdmp_kmdclust4.html'),
  list(input = './5.16.4_sp_ds_spd_by_tdmp_kmdclust5.Rmd', output = './reports/5.16.4_sp_ds_spd_by_tdmp_kmdclust5.html')
  
  # ## Женщины spd
  # list(input = './5.17.1_sp_ds_spd_female_by_all_kmdclust2.Rmd', output = './reports/5.17.1_sp_ds_spd_female_by_all_kmdclust2.html'),
  # list(input = './5.17.2_sp_ds_spd_female_by_all_kmdclust3.Rmd', output = './reports/5.17.2_sp_ds_spd_female_by_all_kmdclust3.html'),
  # list(input = './5.17.3_sp_ds_spd_female_by_all_kmdclust4.Rmd', output = './reports/5.17.3_sp_ds_spd_female_by_all_kmdclust4.html'),
  # list(input = './5.17.4_sp_ds_spd_female_by_all_kmdclust5.Rmd', output = './reports/5.17.4_sp_ds_spd_female_by_all_kmdclust5.html'),
  # list(input = './5.17.1_sp_ds_spd_female_by_notcorr_kmdclust2.Rmd', output = './reports/5.17.1_sp_ds_spd_female_by_notcorr_kmdclust2.html'),
  # list(input = './5.17.2_sp_ds_spd_female_by_notcorr_kmdclust3.Rmd', output = './reports/5.17.2_sp_ds_spd_female_by_notcorr_kmdclust3.html'),
  # list(input = './5.17.3_sp_ds_spd_female_by_notcorr_kmdclust4.Rmd', output = './reports/5.17.3_sp_ds_spd_female_by_notcorr_kmdclust4.html'),
  # list(input = './5.17.4_sp_ds_spd_female_by_notcorr_kmdclust5.Rmd', output = './reports/5.17.4_sp_ds_spd_female_by_notcorr_kmdclust5.html'),
  # list(input = './5.17.1_sp_ds_spd_female_by_tdm_kmdclust2.Rmd', output = './reports/5.17.1_sp_ds_spd_female_by_tdm_kmdclust2.html'),
  # list(input = './5.17.2_sp_ds_spd_female_by_tdm_kmdclust3.Rmd', output = './reports/5.17.2_sp_ds_spd_female_by_tdm_kmdclust3.html'),
  # list(input = './5.17.3_sp_ds_spd_female_by_tdm_kmdclust4.Rmd', output = './reports/5.17.3_sp_ds_spd_female_by_tdm_kmdclust4.html'),
  # list(input = './5.17.4_sp_ds_spd_female_by_tdm_kmdclust5.Rmd', output = './reports/5.17.4_sp_ds_spd_female_by_tdm_kmdclust5.html'),
  # list(input = './5.17.1_sp_ds_spd_female_by_pauses_kmdclust2.Rmd', output = './reports/5.17.1_sp_ds_spd_female_by_pauses_kmdclust2.html'),
  # list(input = './5.17.2_sp_ds_spd_female_by_pauses_kmdclust3.Rmd', output = './reports/5.17.2_sp_ds_spd_female_by_pauses_kmdclust3.html'),
  # list(input = './5.17.3_sp_ds_spd_female_by_pauses_kmdclust4.Rmd', output = './reports/5.17.3_sp_ds_spd_female_by_pauses_kmdclust4.html'),
  # list(input = './5.17.4_sp_ds_spd_female_by_pauses_kmdclust5.Rmd', output = './reports/5.17.4_sp_ds_spd_female_by_pauses_kmdclust5.html'),
  # 
  # ## Мужчины spd
  # list(input = './5.18.1_sp_ds_spd_male_by_all_kmdclust2.Rmd', output = './reports/5.18.1_sp_ds_spd_male_by_all_kmdclust2.html'),
  # list(input = './5.18.2_sp_ds_spd_male_by_all_kmdclust3.Rmd', output = './reports/5.18.2_sp_ds_spd_male_by_all_kmdclust3.html'),
  # list(input = './5.18.3_sp_ds_spd_male_by_all_kmdclust4.Rmd', output = './reports/5.18.3_sp_ds_spd_male_by_all_kmdclust4.html'),
  # list(input = './5.18.4_sp_ds_spd_male_by_all_kmdclust5.Rmd', output = './reports/5.18.4_sp_ds_spd_male_by_all_kmdclust5.html'),
  # list(input = './5.18.1_sp_ds_spd_male_by_notcorr_kmdclust2.Rmd', output = './reports/5.18.1_sp_ds_spd_male_by_notcorr_kmdclust2.html'),
  # list(input = './5.18.2_sp_ds_spd_male_by_notcorr_kmdclust3.Rmd', output = './reports/5.18.2_sp_ds_spd_male_by_notcorr_kmdclust3.html'),
  # list(input = './5.18.3_sp_ds_spd_male_by_notcorr_kmdclust4.Rmd', output = './reports/5.18.3_sp_ds_spd_male_by_notcorr_kmdclust4.html'),
  # list(input = './5.18.4_sp_ds_spd_male_by_notcorr_kmdclust5.Rmd', output = './reports/5.18.4_sp_ds_spd_male_by_notcorr_kmdclust5.html'),
  # list(input = './5.18.1_sp_ds_spd_male_by_tdm_kmdclust2.Rmd', output = './reports/5.18.1_sp_ds_spd_male_by_tdm_kmdclust2.html'),
  # list(input = './5.18.2_sp_ds_spd_male_by_tdm_kmdclust3.Rmd', output = './reports/5.18.2_sp_ds_spd_male_by_tdm_kmdclust3.html'),
  # list(input = './5.18.3_sp_ds_spd_male_by_tdm_kmdclust4.Rmd', output = './reports/5.18.3_sp_ds_spd_male_by_tdm_kmdclust4.html'),
  # list(input = './5.18.4_sp_ds_spd_male_by_tdm_kmdclust5.Rmd', output = './reports/5.18.4_sp_ds_spd_male_by_tdm_kmdclust5.html'),
  # list(input = './5.18.1_sp_ds_spd_male_by_pauses_kmdclust2.Rmd', output = './reports/5.18.1_sp_ds_spd_male_by_pauses_kmdclust2.html'),
  # list(input = './5.18.2_sp_ds_spd_male_by_pauses_kmdclust3.Rmd', output = './reports/5.18.2_sp_ds_spd_male_by_pauses_kmdclust3.html'),
  # list(input = './5.18.3_sp_ds_spd_male_by_pauses_kmdclust4.Rmd', output = './reports/5.18.3_sp_ds_spd_male_by_pauses_kmdclust4.html'),
  # list(input = './5.18.4_sp_ds_spd_male_by_pauses_kmdclust5.Rmd', output = './reports/5.18.4_sp_ds_spd_male_by_pauses_kmdclust5.html')
)

# system.time({mclapply(files_ds, render_file, mc.cores = detectCores())})
mclapply(files_ca, render_file, mc.cores = detectCores())
mclapply(files_sp_hclust, render_file, mc.cores = detectCores() - 1)
mclapply(files_sp_kmclust, render_file, mc.cores = detectCores() - 1)
mclapply(files_sp_kmdclust, render_file, mc.cores = detectCores())


sd <- read.csv("./reports/sign_differences.csv")

files_sp <- gsub(pattern = "^5", replacement = "4", x = unique(sd$filename))
files_sp <- gsub(pattern = "_sp_ds_", replacement = "_ds_", x = files_sp)

files_ds <- lapply(files_sp, function(name) {
  list(
    input = paste0('./', name, '.Rmd'),
    output = paste0('./reports/', name, '.html')
  )
})

# mclapply(files_ds, render_file, mc.cores = detectCores())
mclapply(files_ds_hclust, render_file, mc.cores = detectCores())
mclapply(files_ds_kmclust, render_file, mc.cores = detectCores())
mclapply(files_ds_kmdclust, render_file, mc.cores = detectCores())



# rmarkdown::render('./4.1.1_ds_acc_by_all_hclust2.Rmd', output_file = './reports/4.1.1_ds_acc_by_all_hclust2.html')
rmarkdown::render('./5.10.3_sp_ds_spd_by_pauses_kmclust4.Rmd', output_file = './reports/5.10.3_sp_ds_spd_by_pauses_kmclust4.html')
