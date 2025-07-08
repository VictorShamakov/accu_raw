rm(list=ls())
library(parallel)
# Функция для рендеринга одного файла
render_file <- function(file) {
  rmarkdown::render(input = file$input, output_file = file$output)
}
"%+%" <- function(...){paste0(...)}
test_id <- 84
user_id <- 3449

dir.create(file.path("data", "users", user_id))
dir.create(file.path("data", "users", user_id, test_id))
rmarkdown::render('./1_preprocessing_files.Rmd', output_file = file.path("data", "users", user_id, test_id, "userid_" %+% user_id %+% "_testid_" %+% test_id %+% "_personal_report.html"), params = list(user_id = user_id, test_id = test_id, data_from_db = T))

user_ids <- c(3437, 3438, 3439, 3486, 3440, 3441, 3442, 3443, 3444, 3445)

for (user_id in user_ids) {
  print(user_id)
  rm(list=ls()[-grep("user_id|test_id|user_ids|%", ls())])
    # dir.create(file.path("data", "users", user_id))
    # dir.create(file.path("data", "users", user_id, test_id))
    rmarkdown::render('./1_preprocessing_files.Rmd', output_file = file.path("data", "users", user_id, test_id, "userid_" %+% user_id %+% "_testid_" %+% test_id %+% "_personal_report.html"), params = list(user_id = user_id, test_id = test_id, data_from_db = T))
}

ast_results <- read_xlsx("../Accu/results/ast_impersonal_results.xlsx") # Валидные данные  теста
ast_results <- ast_results[order(as.numeric(ast_results$user_id)),]
ast_results$test_id <- test_id

accu_data <- readRDS("./data/raw/2024-10-21 - accu.rds") # Результаты эксперимента компромисс скорость-точность
accu_data <- merge(accu_data, select(ast_results, user_id, test_id), by = c("user_id", "test_id"), all.y = F)

users <- readRDS("./data/raw/2024-10-21 - users.rds")
users <- merge(users, select(accu_data, user_id), by = "user_id")

sessions <- readRDS("./data/raw/2024-10-21 - sessions.rds") # Сессии mouse tracker'a
sessions <- merge(sessions, select(users, user_id), by = "user_id")

event_tracks <- readRDS("./data/raw/2024-10-21 - event_tracks.rds") # Треки событий
event_tracks <- merge(event_tracks, select(sessions, session_id), by = "session_id")

mouse_tracks <- readRDS("./data/raw/2024-10-21 - mouse_tracks.rds") # Треки мыши
mouse_tracks <- merge(mouse_tracks, select(sessions, session_id), by = "session_id")

for (user_id in ast_results$user_id[1:length(ast_results$user_id)]) {
  print(user_id)
  dir.create(paste0("./data/users/", user_id))
  rmarkdown::render('./1_preprocessing_files.Rmd', output_file = file.path("data", "users", user_id, test_id, "userid_" %+% user_id %+% "_testid_" %+% test_id %+% "_personal_report.html"), params = list(user_id = user_id, test_id = test_id, data_from_db = F))
}

## Генерация статистических отчетов параллельно
files <- list(
  list(input = './3.1_ds_acc.Rmd', output = './reports/3.1_ds_acc.html'),
  list(input = './3.1_ds_spd.Rmd', output = './reports/3.1_ds_spd.html'),
  list(input = './3.2_ds_by_stage.Rmd', output = './reports/3.2_ds_by_stage.html'),
  list(input = './3.3_ds_acc_by_gender.Rmd', output = './reports/3.3_ds_acc_by_gender.html'),
  list(input = './3.3_ds_spd_by_gender.Rmd', output = './reports/3.3_ds_spd_by_gender.html'),
  list(input = './3.4_ds_by_stage_and_gender.Rmd', output = './reports/3.4_ds_by_stage_and_gender.html')
)

# Запуск параллельно на всех ядрах (или укажите нужное число)
mclapply(files, render_file, mc.cores = detectCores())

files <- list(
  # Описательная статистика кластеров
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
  
  ## Женщины acc
  list(input = './4.2.1_ds_acc_female_by_all_hclust2.Rmd', output = './reports/4.2.1_ds_acc_female_by_all_hclust2.html'),
  list(input = './4.2.2_ds_acc_female_by_all_hclust3.Rmd', output = './reports/4.2.2_ds_acc_female_by_all_hclust3.html'),
  list(input = './4.2.3_ds_acc_female_by_all_hclust4.Rmd', output = './reports/4.2.3_ds_acc_female_by_all_hclust4.html'),
  list(input = './4.2.4_ds_acc_female_by_all_hclust5.Rmd', output = './reports/4.2.4_ds_acc_female_by_all_hclust5.html'),
  
  list(input = './4.2.1_ds_acc_female_by_notcorr_hclust2.Rmd', output = './reports/4.2.1_ds_acc_female_by_notcorr_hclust2.html'),
  list(input = './4.2.2_ds_acc_female_by_notcorr_hclust3.Rmd', output = './reports/4.2.2_ds_acc_female_by_notcorr_hclust3.html'),
  list(input = './4.2.3_ds_acc_female_by_notcorr_hclust4.Rmd', output = './reports/4.2.3_ds_acc_female_by_notcorr_hclust4.html'),
  list(input = './4.2.4_ds_acc_female_by_notcorr_hclust5.Rmd', output = './reports/4.2.4_ds_acc_female_by_notcorr_hclust5.html'),
  
  list(input = './4.2.1_ds_acc_female_by_tdm_hclust2.Rmd', output = './reports/4.2.1_ds_acc_female_by_tdm_hclust2.html'),
  list(input = './4.2.2_ds_acc_female_by_tdm_hclust3.Rmd', output = './reports/4.2.2_ds_acc_female_by_tdm_hclust3.html'),
  list(input = './4.2.3_ds_acc_female_by_tdm_hclust4.Rmd', output = './reports/4.2.3_ds_acc_female_by_tdm_hclust4.html'),
  list(input = './4.2.4_ds_acc_female_by_tdm_hclust5.Rmd', output = './reports/4.2.4_ds_acc_female_by_tdm_hclust5.html'),
  
  list(input = './4.2.1_ds_acc_female_by_pauses_hclust2.Rmd', output = './reports/4.2.1_ds_acc_female_by_pauses_hclust2.html'),
  list(input = './4.2.2_ds_acc_female_by_pauses_hclust3.Rmd', output = './reports/4.2.2_ds_acc_female_by_pauses_hclust3.html'),
  list(input = './4.2.3_ds_acc_female_by_pauses_hclust4.Rmd', output = './reports/4.2.3_ds_acc_female_by_pauses_hclust4.html'),
  list(input = './4.2.4_ds_acc_female_by_pauses_hclust5.Rmd', output = './reports/4.2.4_ds_acc_female_by_pauses_hclust5.html'),
  
  ## Мужчины acc
  list(input = './4.3.1_ds_acc_male_by_all_hclust2.Rmd', output = './reports/4.3.1_ds_acc_male_by_all_hclust2.html'),
  list(input = './4.3.2_ds_acc_male_by_all_hclust3.Rmd', output = './reports/4.3.2_ds_acc_male_by_all_hclust3.html'),
  list(input = './4.3.3_ds_acc_male_by_all_hclust4.Rmd', output = './reports/4.3.3_ds_acc_male_by_all_hclust4.html'),
  list(input = './4.3.4_ds_acc_male_by_all_hclust5.Rmd', output = './reports/4.3.4_ds_acc_male_by_all_hclust5.html'),
  
  list(input = './4.3.1_ds_acc_male_by_notcorr_hclust2.Rmd', output = './reports/4.3.1_ds_acc_male_by_notcorr_hclust2.html'),
  list(input = './4.3.2_ds_acc_male_by_notcorr_hclust3.Rmd', output = './reports/4.3.2_ds_acc_male_by_notcorr_hclust3.html'),
  list(input = './4.3.3_ds_acc_male_by_notcorr_hclust4.Rmd', output = './reports/4.3.3_ds_acc_male_by_notcorr_hclust4.html'),
  list(input = './4.3.4_ds_acc_male_by_notcorr_hclust5.Rmd', output = './reports/4.3.4_ds_acc_male_by_notcorr_hclust5.html'),
  
  list(input = './4.3.1_ds_acc_male_by_tdm_hclust2.Rmd', output = './reports/4.3.1_ds_acc_male_by_tdm_hclust2.html'),
  list(input = './4.3.2_ds_acc_male_by_tdm_hclust3.Rmd', output = './reports/4.3.2_ds_acc_male_by_tdm_hclust3.html'),
  list(input = './4.3.3_ds_acc_male_by_tdm_hclust4.Rmd', output = './reports/4.3.3_ds_acc_male_by_tdm_hclust4.html'),
  list(input = './4.3.4_ds_acc_male_by_tdm_hclust5.Rmd', output = './reports/4.3.4_ds_acc_male_by_tdm_hclust5.html'),
  
  list(input = './4.3.1_ds_acc_male_by_pauses_hclust2.Rmd', output = './reports/4.3.1_ds_acc_male_by_pauses_hclust2.html'),
  list(input = './4.3.2_ds_acc_male_by_pauses_hclust3.Rmd', output = './reports/4.3.2_ds_acc_male_by_pauses_hclust3.html'),
  list(input = './4.3.3_ds_acc_male_by_pauses_hclust4.Rmd', output = './reports/4.3.3_ds_acc_male_by_pauses_hclust4.html'),
  list(input = './4.3.4_ds_acc_male_by_pauses_hclust5.Rmd', output = './reports/4.3.4_ds_acc_male_by_pauses_hclust5.html'),
  
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
  
  ## Женщины spd
  list(input = './4.5.1_ds_spd_female_by_all_hclust2.Rmd', output = './reports/4.5.1_ds_spd_female_by_all_hclust2.html'),
  list(input = './4.5.2_ds_spd_female_by_all_hclust3.Rmd', output = './reports/4.5.2_ds_spd_female_by_all_hclust3.html'),
  list(input = './4.5.3_ds_spd_female_by_all_hclust4.Rmd', output = './reports/4.5.3_ds_spd_female_by_all_hclust4.html'),
  list(input = './4.5.4_ds_spd_female_by_all_hclust5.Rmd', output = './reports/4.5.4_ds_spd_female_by_all_hclust5.html'),
  
  list(input = './4.5.1_ds_spd_female_by_notcorr_hclust2.Rmd', output = './reports/4.5.1_ds_spd_female_by_notcorr_hclust2.html'),
  list(input = './4.5.2_ds_spd_female_by_notcorr_hclust3.Rmd', output = './reports/4.5.2_ds_spd_female_by_notcorr_hclust3.html'),
  list(input = './4.5.3_ds_spd_female_by_notcorr_hclust4.Rmd', output = './reports/4.5.3_ds_spd_female_by_notcorr_hclust4.html'),
  list(input = './4.5.4_ds_spd_female_by_notcorr_hclust5.Rmd', output = './reports/4.5.4_ds_spd_female_by_notcorr_hclust5.html'),
  
  list(input = './4.5.1_ds_spd_female_by_tdm_hclust2.Rmd', output = './reports/4.5.1_ds_spd_female_by_tdm_hclust2.html'),
  list(input = './4.5.2_ds_spd_female_by_tdm_hclust3.Rmd', output = './reports/4.5.2_ds_spd_female_by_tdm_hclust3.html'),
  list(input = './4.5.3_ds_spd_female_by_tdm_hclust4.Rmd', output = './reports/4.5.3_ds_spd_female_by_tdm_hclust4.html'),
  list(input = './4.5.4_ds_spd_female_by_tdm_hclust5.Rmd', output = './reports/4.5.4_ds_spd_female_by_tdm_hclust5.html'),
  
  list(input = './4.5.1_ds_spd_female_by_pauses_hclust2.Rmd', output = './reports/4.5.1_ds_spd_female_by_pauses_hclust2.html'),
  list(input = './4.5.2_ds_spd_female_by_pauses_hclust3.Rmd', output = './reports/4.5.2_ds_spd_female_by_pauses_hclust3.html'),
  list(input = './4.5.3_ds_spd_female_by_pauses_hclust4.Rmd', output = './reports/4.5.3_ds_spd_female_by_pauses_hclust4.html'),
  list(input = './4.5.4_ds_spd_female_by_pauses_hclust5.Rmd', output = './reports/4.5.4_ds_spd_female_by_pauses_hclust5.html'),
  
  ## Мужчины spd
  list(input = './4.6.1_ds_spd_male_by_all_hclust2.Rmd', output = './reports/4.6.1_ds_spd_male_by_all_hclust2.html'),
  list(input = './4.6.2_ds_spd_male_by_all_hclust3.Rmd', output = './reports/4.6.2_ds_spd_male_by_all_hclust3.html'),
  list(input = './4.6.3_ds_spd_male_by_all_hclust4.Rmd', output = './reports/4.6.3_ds_spd_male_by_all_hclust4.html'),
  list(input = './4.6.4_ds_spd_male_by_all_hclust5.Rmd', output = './reports/4.6.4_ds_spd_male_by_all_hclust5.html'),
  
  list(input = './4.6.1_ds_spd_male_by_notcorr_hclust2.Rmd', output = './reports/4.6.1_ds_spd_male_by_notcorr_hclust2.html'),
  list(input = './4.6.2_ds_spd_male_by_notcorr_hclust3.Rmd', output = './reports/4.6.2_ds_spd_male_by_notcorr_hclust3.html'),
  list(input = './4.6.3_ds_spd_male_by_notcorr_hclust4.Rmd', output = './reports/4.6.3_ds_spd_male_by_notcorr_hclust4.html'),
  list(input = './4.6.4_ds_spd_male_by_notcorr_hclust5.Rmd', output = './reports/4.6.4_ds_spd_male_by_notcorr_hclust5.html'),
  
  list(input = './4.6.1_ds_spd_male_by_tdm_hclust2.Rmd', output = './reports/4.6.1_ds_spd_male_by_tdm_hclust2.html'),
  list(input = './4.6.2_ds_spd_male_by_tdm_hclust3.Rmd', output = './reports/4.6.2_ds_spd_male_by_tdm_hclust3.html'),
  list(input = './4.6.3_ds_spd_male_by_tdm_hclust4.Rmd', output = './reports/4.6.3_ds_spd_male_by_tdm_hclust4.html'),
  list(input = './4.6.4_ds_spd_male_by_tdm_hclust5.Rmd', output = './reports/4.6.4_ds_spd_male_by_tdm_hclust5.html'),
  
  list(input = './4.6.1_ds_spd_male_by_pauses_hclust2.Rmd', output = './reports/4.6.1_ds_spd_male_by_pauses_hclust2.html'),
  list(input = './4.6.2_ds_spd_male_by_pauses_hclust3.Rmd', output = './reports/4.6.2_ds_spd_male_by_pauses_hclust3.html'),
  list(input = './4.6.3_ds_spd_male_by_pauses_hclust4.Rmd', output = './reports/4.6.3_ds_spd_male_by_pauses_hclust4.html'),
  list(input = './4.6.4_ds_spd_male_by_pauses_hclust5.Rmd', output = './reports/4.6.4_ds_spd_male_by_pauses_hclust5.html'),
  
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
  
  ## Женщины acc
  list(input = './5.2.1_sp_ds_acc_female_by_all_hclust2.Rmd', output = './reports/5.2.1_sp_ds_acc_female_by_all_hclust2.html'),
  list(input = './5.2.2_sp_ds_acc_female_by_all_hclust3.Rmd', output = './reports/5.2.2_sp_ds_acc_female_by_all_hclust3.html'),
  list(input = './5.2.3_sp_ds_acc_female_by_all_hclust4.Rmd', output = './reports/5.2.3_sp_ds_acc_female_by_all_hclust4.html'),
  list(input = './5.2.4_sp_ds_acc_female_by_all_hclust5.Rmd', output = './reports/5.2.4_sp_ds_acc_female_by_all_hclust5.html'),
  
  list(input = './5.2.1_sp_ds_acc_female_by_notcorr_hclust2.Rmd', output = './reports/5.2.1_sp_ds_acc_female_by_notcorr_hclust2.html'),
  list(input = './5.2.2_sp_ds_acc_female_by_notcorr_hclust3.Rmd', output = './reports/5.2.2_sp_ds_acc_female_by_notcorr_hclust3.html'),
  list(input = './5.2.3_sp_ds_acc_female_by_notcorr_hclust4.Rmd', output = './reports/5.2.3_sp_ds_acc_female_by_notcorr_hclust4.html'),
  list(input = './5.2.4_sp_ds_acc_female_by_notcorr_hclust5.Rmd', output = './reports/5.2.4_sp_ds_acc_female_by_notcorr_hclust5.html'),
  
  list(input = './5.2.1_sp_ds_acc_female_by_tdm_hclust2.Rmd', output = './reports/5.2.1_sp_ds_acc_female_by_tdm_hclust2.html'),
  list(input = './5.2.2_sp_ds_acc_female_by_tdm_hclust3.Rmd', output = './reports/5.2.2_sp_ds_acc_female_by_tdm_hclust3.html'),
  list(input = './5.2.3_sp_ds_acc_female_by_tdm_hclust4.Rmd', output = './reports/5.2.3_sp_ds_acc_female_by_tdm_hclust4.html'),
  list(input = './5.2.4_sp_ds_acc_female_by_tdm_hclust5.Rmd', output = './reports/5.2.4_sp_ds_acc_female_by_tdm_hclust5.html'),
  
  list(input = './5.2.1_sp_ds_acc_female_by_pauses_hclust2.Rmd', output = './reports/5.2.1_sp_ds_acc_female_by_pauses_hclust2.html'),
  list(input = './5.2.2_sp_ds_acc_female_by_pauses_hclust3.Rmd', output = './reports/5.2.2_sp_ds_acc_female_by_pauses_hclust3.html'),
  list(input = './5.2.3_sp_ds_acc_female_by_pauses_hclust4.Rmd', output = './reports/5.2.3_sp_ds_acc_female_by_pauses_hclust4.html'),
  list(input = './5.2.4_sp_ds_acc_female_by_pauses_hclust5.Rmd', output = './reports/5.2.4_sp_ds_acc_female_by_pauses_hclust5.html'),
  
  
  ## Мужчины acc
  list(input = './5.3.1_sp_ds_acc_male_by_all_hclust2.Rmd', output = './reports/5.3.1_sp_ds_acc_male_by_all_hclust2.html'),
  list(input = './5.3.2_sp_ds_acc_male_by_all_hclust3.Rmd', output = './reports/5.3.2_sp_ds_acc_male_by_all_hclust3.html'),
  list(input = './5.3.3_sp_ds_acc_male_by_all_hclust4.Rmd', output = './reports/5.3.3_sp_ds_acc_male_by_all_hclust4.html'),
  list(input = './5.3.4_sp_ds_acc_male_by_all_hclust5.Rmd', output = './reports/5.3.4_sp_ds_acc_male_by_all_hclust5.html'),
  
  list(input = './5.3.1_sp_ds_acc_male_by_notcorr_hclust2.Rmd', output = './reports/5.3.1_sp_ds_acc_male_by_notcorr_hclust2.html'),
  list(input = './5.3.2_sp_ds_acc_male_by_notcorr_hclust3.Rmd', output = './reports/5.3.2_sp_ds_acc_male_by_notcorr_hclust3.html'),
  list(input = './5.3.3_sp_ds_acc_male_by_notcorr_hclust4.Rmd', output = './reports/5.3.3_sp_ds_acc_male_by_notcorr_hclust4.html'),
  list(input = './5.3.4_sp_ds_acc_male_by_notcorr_hclust5.Rmd', output = './reports/5.3.4_sp_ds_acc_male_by_notcorr_hclust5.html'),
  
  list(input = './5.3.1_sp_ds_acc_male_by_tdm_hclust2.Rmd', output = './reports/5.3.1_sp_ds_acc_male_by_tdm_hclust2.html'),
  list(input = './5.3.2_sp_ds_acc_male_by_tdm_hclust3.Rmd', output = './reports/5.3.2_sp_ds_acc_male_by_tdm_hclust3.html'),
  list(input = './5.3.3_sp_ds_acc_male_by_tdm_hclust4.Rmd', output = './reports/5.3.3_sp_ds_acc_male_by_tdm_hclust4.html'),
  list(input = './5.3.4_sp_ds_acc_male_by_tdm_hclust5.Rmd', output = './reports/5.3.4_sp_ds_acc_male_by_tdm_hclust5.html'),
  
  list(input = './5.3.1_sp_ds_acc_male_by_pauses_hclust2.Rmd', output = './reports/5.3.1_sp_ds_acc_male_by_pauses_hclust2.html'),
  list(input = './5.3.2_sp_ds_acc_male_by_pauses_hclust3.Rmd', output = './reports/5.3.2_sp_ds_acc_male_by_pauses_hclust3.html'),
  list(input = './5.3.3_sp_ds_acc_male_by_pauses_hclust4.Rmd', output = './reports/5.3.3_sp_ds_acc_male_by_pauses_hclust4.html'),
  list(input = './5.3.4_sp_ds_acc_male_by_pauses_hclust5.Rmd', output = './reports/5.3.4_sp_ds_acc_male_by_pauses_hclust5.html'),
  
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
  
  ## Женщины spd
  list(input = './5.5.1_sp_ds_spd_female_by_all_hclust2.Rmd', output = './reports/5.5.1_sp_ds_spd_female_by_all_hclust2.html'),
  list(input = './5.5.2_sp_ds_spd_female_by_all_hclust3.Rmd', output = './reports/5.5.2_sp_ds_spd_female_by_all_hclust3.html'),
  list(input = './5.5.3_sp_ds_spd_female_by_all_hclust4.Rmd', output = './reports/5.5.3_sp_ds_spd_female_by_all_hclust4.html'),
  list(input = './5.5.4_sp_ds_spd_female_by_all_hclust5.Rmd', output = './reports/5.5.4_sp_ds_spd_female_by_all_hclust5.html'),
  
  list(input = './5.5.1_sp_ds_spd_female_by_notcorr_hclust2.Rmd', output = './reports/5.5.1_sp_ds_spd_female_by_notcorr_hclust2.html'),
  list(input = './5.5.2_sp_ds_spd_female_by_notcorr_hclust3.Rmd', output = './reports/5.5.2_sp_ds_spd_female_by_notcorr_hclust3.html'),
  list(input = './5.5.3_sp_ds_spd_female_by_notcorr_hclust4.Rmd', output = './reports/5.5.3_sp_ds_spd_female_by_notcorr_hclust4.html'),
  list(input = './5.5.4_sp_ds_spd_female_by_notcorr_hclust5.Rmd', output = './reports/5.5.4_sp_ds_spd_female_by_notcorr_hclust5.html'),
  
  list(input = './5.5.1_sp_ds_spd_female_by_tdm_hclust2.Rmd', output = './reports/5.5.1_sp_ds_spd_female_by_tdm_hclust2.html'),
  list(input = './5.5.2_sp_ds_spd_female_by_tdm_hclust3.Rmd', output = './reports/5.5.2_sp_ds_spd_female_by_tdm_hclust3.html'),
  list(input = './5.5.3_sp_ds_spd_female_by_tdm_hclust4.Rmd', output = './reports/5.5.3_sp_ds_spd_female_by_tdm_hclust4.html'),
  list(input = './5.5.4_sp_ds_spd_female_by_tdm_hclust5.Rmd', output = './reports/5.5.4_sp_ds_spd_female_by_tdm_hclust5.html'),
  
  list(input = './5.5.1_sp_ds_spd_female_by_pauses_hclust2.Rmd', output = './reports/5.5.1_sp_ds_spd_female_by_pauses_hclust2.html'),
  list(input = './5.5.2_sp_ds_spd_female_by_pauses_hclust3.Rmd', output = './reports/5.5.2_sp_ds_spd_female_by_pauses_hclust3.html'),
  list(input = './5.5.3_sp_ds_spd_female_by_pauses_hclust4.Rmd', output = './reports/5.5.3_sp_ds_spd_female_by_pauses_hclust4.html'),
  list(input = './5.5.4_sp_ds_spd_female_by_pauses_hclust5.Rmd', output = './reports/5.5.4_sp_ds_spd_female_by_pauses_hclust5.html'),
  
  ## Мужчины spd
  list(input = './5.6.1_sp_ds_spd_male_by_all_hclust2.Rmd', output = './reports/5.6.1_sp_ds_spd_male_by_all_hclust2.html'),
  list(input = './5.6.2_sp_ds_spd_male_by_all_hclust3.Rmd', output = './reports/5.6.2_sp_ds_spd_male_by_all_hclust3.html'),
  list(input = './5.6.3_sp_ds_spd_male_by_all_hclust4.Rmd', output = './reports/5.6.3_sp_ds_spd_male_by_all_hclust4.html'),
  list(input = './5.6.4_sp_ds_spd_male_by_all_hclust5.Rmd', output = './reports/5.6.4_sp_ds_spd_male_by_all_hclust5.html'),
  
  list(input = './5.6.1_sp_ds_spd_male_by_notcorr_hclust2.Rmd', output = './reports/5.6.1_sp_ds_spd_male_by_notcorr_hclust2.html'),
  list(input = './5.6.2_sp_ds_spd_male_by_notcorr_hclust3.Rmd', output = './reports/5.6.2_sp_ds_spd_male_by_notcorr_hclust3.html'),
  list(input = './5.6.3_sp_ds_spd_male_by_notcorr_hclust4.Rmd', output = './reports/5.6.3_sp_ds_spd_male_by_notcorr_hclust4.html'),
  list(input = './5.6.4_sp_ds_spd_male_by_notcorr_hclust5.Rmd', output = './reports/5.6.4_sp_ds_spd_male_by_notcorr_hclust5.html'),
  
  list(input = './5.6.1_sp_ds_spd_male_by_tdm_hclust2.Rmd', output = './reports/5.6.1_sp_ds_spd_male_by_tdm_hclust2.html'),
  list(input = './5.6.2_sp_ds_spd_male_by_tdm_hclust3.Rmd', output = './reports/5.6.2_sp_ds_spd_male_by_tdm_hclust3.html'),
  list(input = './5.6.3_sp_ds_spd_male_by_tdm_hclust4.Rmd', output = './reports/5.6.3_sp_ds_spd_male_by_tdm_hclust4.html'),
  list(input = './5.6.4_sp_ds_spd_male_by_tdm_hclust5.Rmd', output = './reports/5.6.4_sp_ds_spd_male_by_tdm_hclust5.html'),
  
  list(input = './5.6.1_sp_ds_spd_male_by_pauses_hclust2.Rmd', output = './reports/5.6.1_sp_ds_spd_male_by_pauses_hclust2.html'),
  list(input = './5.6.2_sp_ds_spd_male_by_pauses_hclust3.Rmd', output = './reports/5.6.2_sp_ds_spd_male_by_pauses_hclust3.html'),
  list(input = './5.6.3_sp_ds_spd_male_by_pauses_hclust4.Rmd', output = './reports/5.6.3_sp_ds_spd_male_by_pauses_hclust4.html'),
  list(input = './5.6.4_sp_ds_spd_male_by_pauses_hclust5.Rmd', output = './reports/5.6.4_sp_ds_spd_male_by_pauses_hclust5.html')
)

# Запуск параллельно на всех ядрах (или укажите нужное число)
mclapply(files, render_file, mc.cores = detectCores() - 1)



