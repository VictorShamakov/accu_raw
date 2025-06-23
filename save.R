rm(list=ls())
"%+%" <- function(...){paste0(...)}
test_id <- 84
user_id <- 3447

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


## Генерация статистических отчетов
rmarkdown::render('./3.1_desc_stat_accuracy.Rmd', output_file = './reports/3.1_desc_stat_accuracy.html')
rmarkdown::render('./3.2_desc_stat_speed.Rmd', output_file = './reports/3.2_desc_stat_speed.html')
rmarkdown::render('./3.3_desc_stat_by_stage.Rmd', output_file = './reports/3.3_desc_stat_by_stage.html')
rmarkdown::render('./3.4_desc_stat_acc_by_gender.Rmd', output_file = './reports/3.4_desc_stat_acc_by_gender.html')
rmarkdown::render('./3.5_desc_stat_spd_by_gender.Rmd', output_file = './reports/3.5_desc_stat_spd_by_gender.html')
rmarkdown::render('./3.6_desc_stat_by_stage_and_gender.Rmd', output_file = './reports/3.6_desc_stat_by_stage_and_gender.html')

# Описательная статистика кластеров
## Все респонденты
rmarkdown::render('./4.1_desc_stat_by_all_hclust2.Rmd', output_file = './reports/4.1_desc_stat_by_all_hclust2.html')
rmarkdown::render('./4.2_desc_stat_by_all_hclust3.Rmd', output_file = './reports/4.2_desc_stat_by_all_hclust3.html')
rmarkdown::render('./4.3_desc_stat_by_all_hclust4.Rmd', output_file = './reports/4.3_desc_stat_by_all_hclust4.html')
rmarkdown::render('./4.4_desc_stat_by_all_hclust5.Rmd', output_file = './reports/4.4_desc_stat_by_all_hclust5.html')
rmarkdown::render('./4.5_desc_stat_by_all_hclust6.Rmd', output_file = './reports/4.5_desc_stat_by_all_hclust6.html')
rmarkdown::render('./4.6_desc_stat_by_all_hclust7.Rmd', output_file = './reports/4.6_desc_stat_by_all_hclust7.html')
rmarkdown::render('./4.7_desc_stat_by_all_hclust8.Rmd', output_file = './reports/4.7_desc_stat_by_all_hclust8.html')
rmarkdown::render('./4.8_desc_stat_by_all_hclust9.Rmd', output_file = './reports/4.8_desc_stat_by_all_hclust9.html')

rmarkdown::render('./4.1_desc_stat_by_notcorr_hclust2.Rmd', output_file = './reports/4.1_desc_stat_by_notcorr_hclust2.html')
rmarkdown::render('./4.2_desc_stat_by_notcorr_hclust3.Rmd', output_file = './reports/4.2_desc_stat_by_notcorr_hclust3.html')
rmarkdown::render('./4.3_desc_stat_by_notcorr_hclust4.Rmd', output_file = './reports/4.3_desc_stat_by_notcorr_hclust4.html')
rmarkdown::render('./4.4_desc_stat_by_notcorr_hclust5.Rmd', output_file = './reports/4.4_desc_stat_by_notcorr_hclust5.html')
rmarkdown::render('./4.5_desc_stat_by_notcorr_hclust6.Rmd', output_file = './reports/4.5_desc_stat_by_notcorr_hclust6.html')
rmarkdown::render('./4.6_desc_stat_by_notcorr_hclust7.Rmd', output_file = './reports/4.6_desc_stat_by_notcorr_hclust7.html')
rmarkdown::render('./4.7_desc_stat_by_notcorr_hclust8.Rmd', output_file = './reports/4.7_desc_stat_by_notcorr_hclust8.html')
rmarkdown::render('./4.8_desc_stat_by_notcorr_hclust9.Rmd', output_file = './reports/4.8_desc_stat_by_notcorr_hclust9.html')

rmarkdown::render('./4.1_desc_stat_by_tdm_hclust2.Rmd', output_file = './reports/4.1_desc_stat_by_tdm_hclust2.html')
rmarkdown::render('./4.2_desc_stat_by_tdm_hclust3.Rmd', output_file = './reports/4.2_desc_stat_by_tdm_hclust3.html')
rmarkdown::render('./4.3_desc_stat_by_tdm_hclust4.Rmd', output_file = './reports/4.3_desc_stat_by_tdm_hclust4.html')
rmarkdown::render('./4.4_desc_stat_by_tdm_hclust5.Rmd', output_file = './reports/4.4_desc_stat_by_tdm_hclust5.html')
rmarkdown::render('./4.5_desc_stat_by_tdm_hclust6.Rmd', output_file = './reports/4.5_desc_stat_by_tdm_hclust6.html')
rmarkdown::render('./4.6_desc_stat_by_tdm_hclust7.Rmd', output_file = './reports/4.6_desc_stat_by_tdm_hclust7.html')
rmarkdown::render('./4.7_desc_stat_by_tdm_hclust8.Rmd', output_file = './reports/4.7_desc_stat_by_tdm_hclust8.html')
rmarkdown::render('./4.8_desc_stat_by_tdm_hclust9.Rmd', output_file = './reports/4.8_desc_stat_by_tdm_hclust9.html')

rmarkdown::render('./4.1_desc_stat_by_pauses_hclust2.Rmd', output_file = './reports/4.1_desc_stat_by_pauses_hclust2.html')
rmarkdown::render('./4.2_desc_stat_by_pauses_hclust3.Rmd', output_file = './reports/4.2_desc_stat_by_pauses_hclust3.html')
rmarkdown::render('./4.3_desc_stat_by_pauses_hclust4.Rmd', output_file = './reports/4.3_desc_stat_by_pauses_hclust4.html')
rmarkdown::render('./4.4_desc_stat_by_pauses_hclust5.Rmd', output_file = './reports/4.4_desc_stat_by_pauses_hclust5.html')
rmarkdown::render('./4.5_desc_stat_by_pauses_hclust6.Rmd', output_file = './reports/4.5_desc_stat_by_pauses_hclust6.html')
rmarkdown::render('./4.6_desc_stat_by_pauses_hclust7.Rmd', output_file = './reports/4.6_desc_stat_by_pauses_hclust7.html')
rmarkdown::render('./4.7_desc_stat_by_pauses_hclust8.Rmd', output_file = './reports/4.7_desc_stat_by_pauses_hclust8.html')
rmarkdown::render('./4.8_desc_stat_by_pauses_hclust9.Rmd', output_file = './reports/4.8_desc_stat_by_pauses_hclust9.html')

## Женщины
rmarkdown::render('./4.1_female_desc_stat_by_all_hclust2.Rmd', output_file = './reports/4.1_female_desc_stat_by_all_hclust2.html')
rmarkdown::render('./4.2_female_desc_stat_by_all_hclust3.Rmd', output_file = './reports/4.2_female_desc_stat_by_all_hclust3.html')
rmarkdown::render('./4.3_female_desc_stat_by_all_hclust4.Rmd', output_file = './reports/4.3_female_desc_stat_by_all_hclust4.html')
rmarkdown::render('./4.4_female_desc_stat_by_all_hclust5.Rmd', output_file = './reports/4.4_female_desc_stat_by_all_hclust5.html')
rmarkdown::render('./4.5_female_desc_stat_by_all_hclust6.Rmd', output_file = './reports/4.5_female_desc_stat_by_all_hclust6.html')
rmarkdown::render('./4.6_female_desc_stat_by_all_hclust7.Rmd', output_file = './reports/4.6_female_desc_stat_by_all_hclust7.html')
rmarkdown::render('./4.7_female_desc_stat_by_all_hclust8.Rmd', output_file = './reports/4.7_female_desc_stat_by_all_hclust8.html')
rmarkdown::render('./4.8_female_desc_stat_by_all_hclust9.Rmd', output_file = './reports/4.8_female_desc_stat_by_all_hclust9.html')

rmarkdown::render('./4.1_female_desc_stat_by_notcorr_hclust2.Rmd', output_file = './reports/4.1_female_desc_stat_by_notcorr_hclust2.html')
rmarkdown::render('./4.2_female_desc_stat_by_notcorr_hclust3.Rmd', output_file = './reports/4.2_female_desc_stat_by_notcorr_hclust3.html')
rmarkdown::render('./4.3_female_desc_stat_by_notcorr_hclust4.Rmd', output_file = './reports/4.3_female_desc_stat_by_notcorr_hclust4.html')
rmarkdown::render('./4.4_female_desc_stat_by_notcorr_hclust5.Rmd', output_file = './reports/4.4_female_desc_stat_by_notcorr_hclust5.html')
rmarkdown::render('./4.5_female_desc_stat_by_notcorr_hclust6.Rmd', output_file = './reports/4.5_female_desc_stat_by_notcorr_hclust6.html')
rmarkdown::render('./4.6_female_desc_stat_by_notcorr_hclust7.Rmd', output_file = './reports/4.6_female_desc_stat_by_notcorr_hclust7.html')
rmarkdown::render('./4.7_female_desc_stat_by_notcorr_hclust8.Rmd', output_file = './reports/4.7_female_desc_stat_by_notcorr_hclust8.html')
rmarkdown::render('./4.8_female_desc_stat_by_notcorr_hclust9.Rmd', output_file = './reports/4.8_female_desc_stat_by_notcorr_hclust9.html')

rmarkdown::render('./4.1_female_desc_stat_by_tdm_hclust2.Rmd', output_file = './reports/4.1_female_desc_stat_by_tdm_hclust2.html')
rmarkdown::render('./4.2_female_desc_stat_by_tdm_hclust3.Rmd', output_file = './reports/4.2_female_desc_stat_by_tdm_hclust3.html')
rmarkdown::render('./4.3_female_desc_stat_by_tdm_hclust4.Rmd', output_file = './reports/4.3_female_desc_stat_by_tdm_hclust4.html')
rmarkdown::render('./4.4_female_desc_stat_by_tdm_hclust5.Rmd', output_file = './reports/4.4_female_desc_stat_by_tdm_hclust5.html')
rmarkdown::render('./4.5_female_desc_stat_by_tdm_hclust6.Rmd', output_file = './reports/4.5_female_desc_stat_by_tdm_hclust6.html')
rmarkdown::render('./4.6_female_desc_stat_by_tdm_hclust7.Rmd', output_file = './reports/4.6_female_desc_stat_by_tdm_hclust7.html')
rmarkdown::render('./4.7_female_desc_stat_by_tdm_hclust8.Rmd', output_file = './reports/4.7_female_desc_stat_by_tdm_hclust8.html')
rmarkdown::render('./4.8_female_desc_stat_by_tdm_hclust9.Rmd', output_file = './reports/4.8_female_desc_stat_by_tdm_hclust9.html')

rmarkdown::render('./4.1_female_desc_stat_by_pauses_hclust2.Rmd', output_file = './reports/4.1_female_desc_stat_by_pauses_hclust2.html')
rmarkdown::render('./4.2_female_desc_stat_by_pauses_hclust3.Rmd', output_file = './reports/4.2_female_desc_stat_by_pauses_hclust3.html')
rmarkdown::render('./4.3_female_desc_stat_by_pauses_hclust4.Rmd', output_file = './reports/4.3_female_desc_stat_by_pauses_hclust4.html')
rmarkdown::render('./4.4_female_desc_stat_by_pauses_hclust5.Rmd', output_file = './reports/4.4_female_desc_stat_by_pauses_hclust5.html')
rmarkdown::render('./4.5_female_desc_stat_by_pauses_hclust6.Rmd', output_file = './reports/4.5_female_desc_stat_by_pauses_hclust6.html')
rmarkdown::render('./4.6_female_desc_stat_by_pauses_hclust7.Rmd', output_file = './reports/4.6_female_desc_stat_by_pauses_hclust7.html')
rmarkdown::render('./4.7_female_desc_stat_by_pauses_hclust8.Rmd', output_file = './reports/4.7_female_desc_stat_by_pauses_hclust8.html')
rmarkdown::render('./4.8_female_desc_stat_by_pauses_hclust9.Rmd', output_file = './reports/4.8_female_desc_stat_by_pauses_hclust9.html')

## Мужчины
rmarkdown::render('./4.1_male_desc_stat_by_all_hclust2.Rmd', output_file = './reports/4.1_male_desc_stat_by_all_hclust2.html')
rmarkdown::render('./4.2_male_desc_stat_by_all_hclust3.Rmd', output_file = './reports/4.2_male_desc_stat_by_all_hclust3.html')
rmarkdown::render('./4.3_male_desc_stat_by_all_hclust4.Rmd', output_file = './reports/4.3_male_desc_stat_by_all_hclust4.html')
rmarkdown::render('./4.4_male_desc_stat_by_all_hclust5.Rmd', output_file = './reports/4.4_male_desc_stat_by_all_hclust5.html')
rmarkdown::render('./4.5_male_desc_stat_by_all_hclust6.Rmd', output_file = './reports/4.5_male_desc_stat_by_all_hclust6.html')
rmarkdown::render('./4.6_male_desc_stat_by_all_hclust7.Rmd', output_file = './reports/4.6_male_desc_stat_by_all_hclust7.html')
rmarkdown::render('./4.7_male_desc_stat_by_all_hclust8.Rmd', output_file = './reports/4.7_male_desc_stat_by_all_hclust8.html')
rmarkdown::render('./4.8_male_desc_stat_by_all_hclust9.Rmd', output_file = './reports/4.8_male_desc_stat_by_all_hclust9.html')

rmarkdown::render('./4.1_male_desc_stat_by_notcorr_hclust2.Rmd', output_file = './reports/4.1_male_desc_stat_by_notcorr_hclust2.html')
rmarkdown::render('./4.2_male_desc_stat_by_notcorr_hclust3.Rmd', output_file = './reports/4.2_male_desc_stat_by_notcorr_hclust3.html')
rmarkdown::render('./4.3_male_desc_stat_by_notcorr_hclust4.Rmd', output_file = './reports/4.3_male_desc_stat_by_notcorr_hclust4.html')
rmarkdown::render('./4.4_male_desc_stat_by_notcorr_hclust5.Rmd', output_file = './reports/4.4_male_desc_stat_by_notcorr_hclust5.html')
rmarkdown::render('./4.5_male_desc_stat_by_notcorr_hclust6.Rmd', output_file = './reports/4.5_male_desc_stat_by_notcorr_hclust6.html')
rmarkdown::render('./4.6_male_desc_stat_by_notcorr_hclust7.Rmd', output_file = './reports/4.6_male_desc_stat_by_notcorr_hclust7.html')
rmarkdown::render('./4.7_male_desc_stat_by_notcorr_hclust8.Rmd', output_file = './reports/4.7_male_desc_stat_by_notcorr_hclust8.html')
rmarkdown::render('./4.8_male_desc_stat_by_notcorr_hclust9.Rmd', output_file = './reports/4.8_male_desc_stat_by_notcorr_hclust9.html')

rmarkdown::render('./4.1_male_desc_stat_by_tdm_hclust2.Rmd', output_file = './reports/4.1_male_desc_stat_by_tdm_hclust2.html')
rmarkdown::render('./4.2_male_desc_stat_by_tdm_hclust3.Rmd', output_file = './reports/4.2_male_desc_stat_by_tdm_hclust3.html')
rmarkdown::render('./4.3_male_desc_stat_by_tdm_hclust4.Rmd', output_file = './reports/4.3_male_desc_stat_by_tdm_hclust4.html')
rmarkdown::render('./4.4_male_desc_stat_by_tdm_hclust5.Rmd', output_file = './reports/4.4_male_desc_stat_by_tdm_hclust5.html')
rmarkdown::render('./4.5_male_desc_stat_by_tdm_hclust6.Rmd', output_file = './reports/4.5_male_desc_stat_by_tdm_hclust6.html')
rmarkdown::render('./4.6_male_desc_stat_by_tdm_hclust7.Rmd', output_file = './reports/4.6_male_desc_stat_by_tdm_hclust7.html')
rmarkdown::render('./4.7_male_desc_stat_by_tdm_hclust8.Rmd', output_file = './reports/4.7_male_desc_stat_by_tdm_hclust8.html')
rmarkdown::render('./4.8_male_desc_stat_by_tdm_hclust9.Rmd', output_file = './reports/4.8_male_desc_stat_by_tdm_hclust9.html')

rmarkdown::render('./4.1_male_desc_stat_by_pauses_hclust2.Rmd', output_file = './reports/4.1_male_desc_stat_by_pauses_hclust2.html')
rmarkdown::render('./4.2_male_desc_stat_by_pauses_hclust3.Rmd', output_file = './reports/4.2_male_desc_stat_by_pauses_hclust3.html')
rmarkdown::render('./4.3_male_desc_stat_by_pauses_hclust4.Rmd', output_file = './reports/4.3_male_desc_stat_by_pauses_hclust4.html')
rmarkdown::render('./4.4_male_desc_stat_by_pauses_hclust5.Rmd', output_file = './reports/4.4_male_desc_stat_by_pauses_hclust5.html')
rmarkdown::render('./4.5_male_desc_stat_by_pauses_hclust6.Rmd', output_file = './reports/4.5_male_desc_stat_by_pauses_hclust6.html')
rmarkdown::render('./4.6_male_desc_stat_by_pauses_hclust7.Rmd', output_file = './reports/4.6_male_desc_stat_by_pauses_hclust7.html')
rmarkdown::render('./4.7_male_desc_stat_by_pauses_hclust8.Rmd', output_file = './reports/4.7_male_desc_stat_by_pauses_hclust8.html')
rmarkdown::render('./4.8_male_desc_stat_by_pauses_hclust9.Rmd', output_file = './reports/4.8_male_desc_stat_by_pauses_hclust9.html')

# Психодиагностика и кластеры
rmarkdown::render('./5.1_sp_desc_stat_by_all_hclust2.Rmd', output_file = './reports/5.1_sp_desc_stat_by_all_hclust2.html')
rmarkdown::render('./5.2_sp_desc_stat_by_all_hclust3.Rmd', output_file = './reports/5.2_sp_desc_stat_by_all_hclust3.html')
rmarkdown::render('./5.3_sp_desc_stat_by_all_hclust4.Rmd', output_file = './reports/5.3_sp_desc_stat_by_all_hclust4.html')
rmarkdown::render('./5.4_sp_desc_stat_by_all_hclust5.Rmd', output_file = './reports/5.4_sp_desc_stat_by_all_hclust5.html')
rmarkdown::render('./5.5_sp_desc_stat_by_all_hclust6.Rmd', output_file = './reports/5.5_sp_desc_stat_by_all_hclust6.html')
rmarkdown::render('./5.6_sp_desc_stat_by_all_hclust7.Rmd', output_file = './reports/5.6_sp_desc_stat_by_all_hclust7.html')
rmarkdown::render('./5.7_sp_desc_stat_by_all_hclust8.Rmd', output_file = './reports/5.7_sp_desc_stat_by_all_hclust8.html')
rmarkdown::render('./5.8_sp_desc_stat_by_all_hclust9.Rmd', output_file = './reports/5.8_sp_desc_stat_by_all_hclust9.html')

rmarkdown::render('./5.1_sp_desc_stat_by_notcorr_hclust2.Rmd', output_file = './reports/5.1_sp_desc_stat_by_notcorr_hclust2.html')
rmarkdown::render('./5.2_sp_desc_stat_by_notcorr_hclust3.Rmd', output_file = './reports/5.2_sp_desc_stat_by_notcorr_hclust3.html')
rmarkdown::render('./5.3_sp_desc_stat_by_notcorr_hclust4.Rmd', output_file = './reports/5.3_sp_desc_stat_by_notcorr_hclust4.html')
rmarkdown::render('./5.4_sp_desc_stat_by_notcorr_hclust5.Rmd', output_file = './reports/5.4_sp_desc_stat_by_notcorr_hclust5.html')
rmarkdown::render('./5.5_sp_desc_stat_by_notcorr_hclust6.Rmd', output_file = './reports/5.5_sp_desc_stat_by_notcorr_hclust6.html')
rmarkdown::render('./5.6_sp_desc_stat_by_notcorr_hclust7.Rmd', output_file = './reports/5.6_sp_desc_stat_by_notcorr_hclust7.html')
rmarkdown::render('./5.7_sp_desc_stat_by_notcorr_hclust8.Rmd', output_file = './reports/5.7_sp_desc_stat_by_notcorr_hclust8.html')
rmarkdown::render('./5.8_sp_desc_stat_by_notcorr_hclust9.Rmd', output_file = './reports/5.8_sp_desc_stat_by_notcorr_hclust9.html')

rmarkdown::render('./5.1_sp_desc_stat_by_tdm_hclust2.Rmd', output_file = './reports/5.1_sp_desc_stat_by_tdm_hclust2.html')
rmarkdown::render('./5.2_sp_desc_stat_by_tdm_hclust3.Rmd', output_file = './reports/5.2_sp_desc_stat_by_tdm_hclust3.html')
rmarkdown::render('./5.3_sp_desc_stat_by_tdm_hclust4.Rmd', output_file = './reports/5.3_sp_desc_stat_by_tdm_hclust4.html')
rmarkdown::render('./5.4_sp_desc_stat_by_tdm_hclust5.Rmd', output_file = './reports/5.4_sp_desc_stat_by_tdm_hclust5.html')
rmarkdown::render('./5.5_sp_desc_stat_by_tdm_hclust6.Rmd', output_file = './reports/5.5_sp_desc_stat_by_tdm_hclust6.html')
rmarkdown::render('./5.6_sp_desc_stat_by_tdm_hclust7.Rmd', output_file = './reports/5.6_sp_desc_stat_by_tdm_hclust7.html')
rmarkdown::render('./5.7_sp_desc_stat_by_tdm_hclust8.Rmd', output_file = './reports/5.7_sp_desc_stat_by_tdm_hclust8.html')
rmarkdown::render('./5.8_sp_desc_stat_by_tdm_hclust9.Rmd', output_file = './reports/5.8_sp_desc_stat_by_tdm_hclust9.html')

rmarkdown::render('./5.1_sp_desc_stat_by_pauses_hclust2.Rmd', output_file = './reports/5.1_sp_desc_stat_by_pauses_hclust2.html')
rmarkdown::render('./5.2_sp_desc_stat_by_pauses_hclust3.Rmd', output_file = './reports/5.2_sp_desc_stat_by_pauses_hclust3.html')
rmarkdown::render('./5.3_sp_desc_stat_by_pauses_hclust4.Rmd', output_file = './reports/5.3_sp_desc_stat_by_pauses_hclust4.html')
rmarkdown::render('./5.4_sp_desc_stat_by_pauses_hclust5.Rmd', output_file = './reports/5.4_sp_desc_stat_by_pauses_hclust5.html')
rmarkdown::render('./5.5_sp_desc_stat_by_pauses_hclust6.Rmd', output_file = './reports/5.5_sp_desc_stat_by_pauses_hclust6.html')
rmarkdown::render('./5.6_sp_desc_stat_by_pauses_hclust7.Rmd', output_file = './reports/5.6_sp_desc_stat_by_pauses_hclust7.html')
rmarkdown::render('./5.7_sp_desc_stat_by_pauses_hclust8.Rmd', output_file = './reports/5.7_sp_desc_stat_by_pauses_hclust8.html')
rmarkdown::render('./5.8_sp_desc_stat_by_pauses_hclust9.Rmd', output_file = './reports/5.8_sp_desc_stat_by_pauses_hclust9.html')

## Женщины
rmarkdown::render('./5.1_female_sp_desc_stat_by_all_hclust2.Rmd', output_file = './reports/5.1_female_sp_desc_stat_by_all_hclust2.html')
rmarkdown::render('./5.2_female_sp_desc_stat_by_all_hclust3.Rmd', output_file = './reports/5.2_female_sp_desc_stat_by_all_hclust3.html')
rmarkdown::render('./5.3_female_sp_desc_stat_by_all_hclust4.Rmd', output_file = './reports/5.3_female_sp_desc_stat_by_all_hclust4.html')
rmarkdown::render('./5.4_female_sp_desc_stat_by_all_hclust5.Rmd', output_file = './reports/5.4_female_sp_desc_stat_by_all_hclust5.html')
rmarkdown::render('./5.5_female_sp_desc_stat_by_all_hclust6.Rmd', output_file = './reports/5.5_female_sp_desc_stat_by_all_hclust6.html')
rmarkdown::render('./5.6_female_sp_desc_stat_by_all_hclust7.Rmd', output_file = './reports/5.6_female_sp_desc_stat_by_all_hclust7.html')
rmarkdown::render('./5.7_female_sp_desc_stat_by_all_hclust8.Rmd', output_file = './reports/5.7_female_sp_desc_stat_by_all_hclust8.html')
rmarkdown::render('./5.8_female_sp_desc_stat_by_all_hclust9.Rmd', output_file = './reports/5.8_female_sp_desc_stat_by_all_hclust9.html')

rmarkdown::render('./5.1_female_sp_desc_stat_by_notcorr_hclust2.Rmd', output_file = './reports/5.1_female_sp_desc_stat_by_notcorr_hclust2.html')
rmarkdown::render('./5.2_female_sp_desc_stat_by_notcorr_hclust3.Rmd', output_file = './reports/5.2_female_sp_desc_stat_by_notcorr_hclust3.html')
rmarkdown::render('./5.3_female_sp_desc_stat_by_notcorr_hclust4.Rmd', output_file = './reports/5.3_female_sp_desc_stat_by_notcorr_hclust4.html')
rmarkdown::render('./5.4_female_sp_desc_stat_by_notcorr_hclust5.Rmd', output_file = './reports/5.4_female_sp_desc_stat_by_notcorr_hclust5.html')
rmarkdown::render('./5.5_female_sp_desc_stat_by_notcorr_hclust6.Rmd', output_file = './reports/5.5_female_sp_desc_stat_by_notcorr_hclust6.html')
rmarkdown::render('./5.6_female_sp_desc_stat_by_notcorr_hclust7.Rmd', output_file = './reports/5.6_female_sp_desc_stat_by_notcorr_hclust7.html')
rmarkdown::render('./5.7_female_sp_desc_stat_by_notcorr_hclust8.Rmd', output_file = './reports/5.7_female_sp_desc_stat_by_notcorr_hclust8.html')
rmarkdown::render('./5.8_female_sp_desc_stat_by_notcorr_hclust9.Rmd', output_file = './reports/5.8_female_sp_desc_stat_by_notcorr_hclust9.html')

rmarkdown::render('./5.1_female_sp_desc_stat_by_tdm_hclust2.Rmd', output_file = './reports/5.1_female_sp_desc_stat_by_tdm_hclust2.html')
rmarkdown::render('./5.2_female_sp_desc_stat_by_tdm_hclust3.Rmd', output_file = './reports/5.2_female_sp_desc_stat_by_tdm_hclust3.html')
rmarkdown::render('./5.3_female_sp_desc_stat_by_tdm_hclust4.Rmd', output_file = './reports/5.3_female_sp_desc_stat_by_tdm_hclust4.html')
rmarkdown::render('./5.4_female_sp_desc_stat_by_tdm_hclust5.Rmd', output_file = './reports/5.4_female_sp_desc_stat_by_tdm_hclust5.html')
rmarkdown::render('./5.5_female_sp_desc_stat_by_tdm_hclust6.Rmd', output_file = './reports/5.5_female_sp_desc_stat_by_tdm_hclust6.html')
rmarkdown::render('./5.6_female_sp_desc_stat_by_tdm_hclust7.Rmd', output_file = './reports/5.6_female_sp_desc_stat_by_tdm_hclust7.html')
rmarkdown::render('./5.7_female_sp_desc_stat_by_tdm_hclust8.Rmd', output_file = './reports/5.7_female_sp_desc_stat_by_tdm_hclust8.html')
rmarkdown::render('./5.8_female_sp_desc_stat_by_tdm_hclust9.Rmd', output_file = './reports/5.8_female_sp_desc_stat_by_tdm_hclust9.html')

rmarkdown::render('./5.1_female_sp_desc_stat_by_pauses_hclust2.Rmd', output_file = './reports/5.1_female_sp_desc_stat_by_pauses_hclust2.html')
rmarkdown::render('./5.2_female_sp_desc_stat_by_pauses_hclust3.Rmd', output_file = './reports/5.2_female_sp_desc_stat_by_pauses_hclust3.html')
rmarkdown::render('./5.3_female_sp_desc_stat_by_pauses_hclust4.Rmd', output_file = './reports/5.3_female_sp_desc_stat_by_pauses_hclust4.html')
rmarkdown::render('./5.4_female_sp_desc_stat_by_pauses_hclust5.Rmd', output_file = './reports/5.4_female_sp_desc_stat_by_pauses_hclust5.html')
rmarkdown::render('./5.5_female_sp_desc_stat_by_pauses_hclust6.Rmd', output_file = './reports/5.5_female_sp_desc_stat_by_pauses_hclust6.html')
rmarkdown::render('./5.6_female_sp_desc_stat_by_pauses_hclust7.Rmd', output_file = './reports/5.6_female_sp_desc_stat_by_pauses_hclust7.html')
rmarkdown::render('./5.7_female_sp_desc_stat_by_pauses_hclust8.Rmd', output_file = './reports/5.7_female_sp_desc_stat_by_pauses_hclust8.html')
rmarkdown::render('./5.8_female_sp_desc_stat_by_pauses_hclust9.Rmd', output_file = './reports/5.8_female_sp_desc_stat_by_pauses_hclust9.html')


## Мужчины
rmarkdown::render('./5.1_male_sp_desc_stat_by_all_hclust2.Rmd', output_file = './reports/5.1_male_sp_desc_stat_by_all_hclust2.html')
rmarkdown::render('./5.2_male_sp_desc_stat_by_all_hclust3.Rmd', output_file = './reports/5.2_male_sp_desc_stat_by_all_hclust3.html')
rmarkdown::render('./5.3_male_sp_desc_stat_by_all_hclust4.Rmd', output_file = './reports/5.3_male_sp_desc_stat_by_all_hclust4.html')
rmarkdown::render('./5.4_male_sp_desc_stat_by_all_hclust5.Rmd', output_file = './reports/5.4_male_sp_desc_stat_by_all_hclust5.html')
rmarkdown::render('./5.5_male_sp_desc_stat_by_all_hclust6.Rmd', output_file = './reports/5.5_male_sp_desc_stat_by_all_hclust6.html')
rmarkdown::render('./5.6_male_sp_desc_stat_by_all_hclust7.Rmd', output_file = './reports/5.6_male_sp_desc_stat_by_all_hclust7.html')
rmarkdown::render('./5.7_male_sp_desc_stat_by_all_hclust8.Rmd', output_file = './reports/5.7_male_sp_desc_stat_by_all_hclust8.html')
rmarkdown::render('./5.8_male_sp_desc_stat_by_all_hclust9.Rmd', output_file = './reports/5.8_male_sp_desc_stat_by_all_hclust9.html')

rmarkdown::render('./5.1_male_sp_desc_stat_by_notcorr_hclust2.Rmd', output_file = './reports/5.1_male_sp_desc_stat_by_notcorr_hclust2.html')
rmarkdown::render('./5.2_male_sp_desc_stat_by_notcorr_hclust3.Rmd', output_file = './reports/5.2_male_sp_desc_stat_by_notcorr_hclust3.html')
rmarkdown::render('./5.3_male_sp_desc_stat_by_notcorr_hclust4.Rmd', output_file = './reports/5.3_male_sp_desc_stat_by_notcorr_hclust4.html')
rmarkdown::render('./5.4_male_sp_desc_stat_by_notcorr_hclust5.Rmd', output_file = './reports/5.4_male_sp_desc_stat_by_notcorr_hclust5.html')
rmarkdown::render('./5.5_male_sp_desc_stat_by_notcorr_hclust6.Rmd', output_file = './reports/5.5_male_sp_desc_stat_by_notcorr_hclust6.html')
rmarkdown::render('./5.6_male_sp_desc_stat_by_notcorr_hclust7.Rmd', output_file = './reports/5.6_male_sp_desc_stat_by_notcorr_hclust7.html')
rmarkdown::render('./5.7_male_sp_desc_stat_by_notcorr_hclust8.Rmd', output_file = './reports/5.7_male_sp_desc_stat_by_notcorr_hclust8.html')
rmarkdown::render('./5.8_male_sp_desc_stat_by_notcorr_hclust9.Rmd', output_file = './reports/5.8_male_sp_desc_stat_by_notcorr_hclust9.html')

rmarkdown::render('./5.1_male_sp_desc_stat_by_tdm_hclust2.Rmd', output_file = './reports/5.1_male_sp_desc_stat_by_tdm_hclust2.html')
rmarkdown::render('./5.2_male_sp_desc_stat_by_tdm_hclust3.Rmd', output_file = './reports/5.2_male_sp_desc_stat_by_tdm_hclust3.html')
rmarkdown::render('./5.3_male_sp_desc_stat_by_tdm_hclust4.Rmd', output_file = './reports/5.3_male_sp_desc_stat_by_tdm_hclust4.html')
rmarkdown::render('./5.4_male_sp_desc_stat_by_tdm_hclust5.Rmd', output_file = './reports/5.4_male_sp_desc_stat_by_tdm_hclust5.html')
rmarkdown::render('./5.5_male_sp_desc_stat_by_tdm_hclust6.Rmd', output_file = './reports/5.5_male_sp_desc_stat_by_tdm_hclust6.html')
rmarkdown::render('./5.6_male_sp_desc_stat_by_tdm_hclust7.Rmd', output_file = './reports/5.6_male_sp_desc_stat_by_tdm_hclust7.html')
rmarkdown::render('./5.7_male_sp_desc_stat_by_tdm_hclust8.Rmd', output_file = './reports/5.7_male_sp_desc_stat_by_tdm_hclust8.html')
rmarkdown::render('./5.8_male_sp_desc_stat_by_tdm_hclust9.Rmd', output_file = './reports/5.8_male_sp_desc_stat_by_tdm_hclust9.html')

rmarkdown::render('./5.1_male_sp_desc_stat_by_pauses_hclust2.Rmd', output_file = './reports/5.1_male_sp_desc_stat_by_pauses_hclust2.html')
rmarkdown::render('./5.2_male_sp_desc_stat_by_pauses_hclust3.Rmd', output_file = './reports/5.2_male_sp_desc_stat_by_pauses_hclust3.html')
rmarkdown::render('./5.3_male_sp_desc_stat_by_pauses_hclust4.Rmd', output_file = './reports/5.3_male_sp_desc_stat_by_pauses_hclust4.html')
rmarkdown::render('./5.4_male_sp_desc_stat_by_pauses_hclust5.Rmd', output_file = './reports/5.4_male_sp_desc_stat_by_pauses_hclust5.html')
rmarkdown::render('./5.5_male_sp_desc_stat_by_pauses_hclust6.Rmd', output_file = './reports/5.5_male_sp_desc_stat_by_pauses_hclust6.html')
rmarkdown::render('./5.6_male_sp_desc_stat_by_pauses_hclust7.Rmd', output_file = './reports/5.6_male_sp_desc_stat_by_pauses_hclust7.html')
rmarkdown::render('./5.7_male_sp_desc_stat_by_pauses_hclust8.Rmd', output_file = './reports/5.7_male_sp_desc_stat_by_pauses_hclust8.html')
rmarkdown::render('./5.8_male_sp_desc_stat_by_pauses_hclust9.Rmd', output_file = './reports/5.8_male_sp_desc_stat_by_pauses_hclust9.html')

