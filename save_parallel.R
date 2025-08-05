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
  list(input = './3.2_ds_by_stage.Rmd', output = './reports/3.2_ds_by_stage.html')
  # list(input = './3.3_ds_acc_by_gender.Rmd', output = './reports/3.3_ds_acc_by_gender.html'),
  # list(input = './3.3_ds_spd_by_gender.Rmd', output = './reports/3.3_ds_spd_by_gender.html'),
  # list(input = './3.4_ds_by_stage_and_gender.Rmd', output = './reports/3.4_ds_by_stage_and_gender.html')
)


## Кластерный анализ
files_ca <- list(
  list(input = './4.0.1_ca_acc.Rmd', output = './reports/4.0.1_ca_acc.html'),
  # list(input = './4.0.2_female_ca_acc.Rmd', output = './reports/4.0.2_female_ca_acc.html'),
  # list(input = './4.0.3_male_ca_acc.Rmd', output = './reports/4.0.3_male_ca_acc.html'),
  list(input = './4.0.4_ca_spd.Rmd', output = './reports/4.0.4_ca_spd.html'),
  # list(input = './4.0.5_female_ca_spd.Rmd', output = './reports/4.0.5_female_ca_spd.html'),
  # list(input = './4.0.6_male_ca_spd.Rmd', output = './reports/4.0.6_male_ca_spd.html'),
  list(input = './4.0.7_ca_acc_spd.Rmd', output = './reports/4.0.7_ca_acc_spd.html'),
  list(input = './4.0.8_ca_diff.Rmd', output = './reports/4.0.8_ca_diff.html')
)

sp_list.acc <- list.files()[grep("^[5].*.*ds_acc_by*", list.files())]
sp_list.spd <- list.files()[grep("^[5].*.*ds_spd_by*", list.files())]
sp_list.acc_spd <- list.files()[grep("^[5].*.*ds_acc_spd_by*", list.files())]
sp_list.diff <- list.files()[grep("^[5].*.*ds_diff_by*", list.files())]
sp_list.all <- c(sp_list.acc, sp_list.spd, sp_list.acc_spd, sp_list.diff)

files_sp <- lapply(sp_list.all, function(name) {
  list(
    input = paste0('./', name),
    output = paste0('./reports/', name, '.html')
  )
})

mclapply(files_ds, render_file, mc.cores = detectCores())
mclapply(files_ca, render_file, mc.cores = detectCores())
mclapply(files_sp, render_file, mc.cores = detectCores())
# mclapply(files_sp_hclust, render_file, mc.cores = detectCores())
# mclapply(files_sp_kmclust, render_file, mc.cores = detectCores())
# mclapply(files_sp_kmdclust, render_file, mc.cores = detectCores())


sd <- read.csv("./reports/sign_differences.csv")

files_ds <- gsub(pattern = "^5", replacement = "4", x = unique(sd$filename))
files_ds <- gsub(pattern = "_sp_ds_", replacement = "_ds_", x = files_ds)

files_ds.acc <- grep(pattern = "^[4].*.*ds_acc_by*", files_ds, value = T)
files_ds.spd <- grep(pattern = "^[4].*.*ds_spd_by*", files_ds, value = T)
files_ds.acc_spd <- grep(pattern = "^[4].*.*ds_acc_spd_by*", files_ds, value = T)
files_ds.diff <- grep(pattern = "^[4].*.*ds_diff_by*", files_ds, value = T)
files_ds.all <- c(files_ds.acc, files_ds.spd, files_ds.acc_spd, files_ds.diff)


files_ds <- lapply(c(files_ds.acc, files_ds.spd, files_ds.diff), function(name) {
  list(
    input = paste0('./', name, '.Rmd'),
    output = paste0('./reports/', name, '.html')
  )
})

mclapply(files_ds, render_file, mc.cores = detectCores())
# mclapply(files_ds_hclust, render_file, mc.cores = detectCores())
# mclapply(files_ds_kmclust, render_file, mc.cores = detectCores())
# mclapply(files_ds_kmdclust, render_file, mc.cores = detectCores())



# rmarkdown::render('./4.1.1_ds_acc_by_all_hclust2.Rmd', output_file = './reports/4.1.1_ds_acc_by_all_hclust2.html')
rmarkdown::render('./5.1.4_sp_ds_acc_by_all_hclust5.Rmd', output_file = './reports/5.1.4_sp_ds_acc_by_all_hclust5.html')
