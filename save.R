rm(list=ls())
library(parallel)
# Функция для рендеринга одного файла
render_file <- function(file) {
  rmarkdown::render(input = file$input, output_file = file$output)
}
"%+%" <- function(...){paste0(...)}

## Персональный отчет
test_id <- 85
user_id <- 3451

dir.create(file.path("data", "users", user_id))
dir.create(file.path("data", "users", user_id, test_id))
rmarkdown::render('./1_preprocessing_files.Rmd', output_file = file.path("data", "users", user_id, test_id, "userid_" %+% user_id %+% "_testid_" %+% test_id %+% "_personal_report.html"), params = list(user_id = user_id, test_id = test_id, data_from_db = T))


## Персональные отчеты
user_ids <- c(3437, 3438, 3439, 3486, 3440, 3441, 3442, 3443, 3444, 3445)

for (user_id in user_ids) {
  print(user_id)
  rm(list=ls()[-grep("user_id|test_id|user_ids|%", ls())])
    # dir.create(file.path("data", "users", user_id))
    # dir.create(file.path("data", "users", user_id, test_id))
    rmarkdown::render('./1_preprocessing_files.Rmd', output_file = file.path("data", "users", user_id, test_id, "userid_" %+% user_id %+% "_testid_" %+% test_id %+% "_personal_report.html"), params = list(user_id = user_id, test_id = test_id, data_from_db = T))
}


## Персональные отчеты (файлы)
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

## Описательная статистика

### Последовательно
rmarkdown::render('./3.1_ds_acc.Rmd', output_file = './reports/3.1_ds_acc.html')
rmarkdown::render('./3.1_ds_spd.Rmd', output_file = './reports/3.1_ds_spd.html')
rmarkdown::render('./3.2_ds_by_stage.Rmd', output_file = './reports/3.2_ds_by_stage.html')
# rmarkdown::render('./3.3_ds_acc_by_gender.Rmd', output_file = './reports/3.3_ds_acc_by_gender.html')
# rmarkdown::render('./3.3_ds_spd_by_gender.Rmd', output_file = './reports/3.3_ds_spd_by_gender.html')
# rmarkdown::render('./3.4_ds_by_stage_and_gender.Rmd', output_file = './reports/3.4_ds_by_stage_and_gender.html')


## Кластерный анализ
rmarkdown::render('./4.0.1_ca_acc.Rmd', output_file = './reports/4.0.1_ca_acc.html')
rmarkdown::render('./4.0.4_ca_spd.Rmd', output_file = './reports/4.0.4_ca_spd.html')
rmarkdown::render('./4.0.7_ca_acc_spd.Rmd', output_file = './reports/4.0.7_ca_acc_spd.html')
rmarkdown::render('./4.0.8_ca_diff.Rmd', output_file = './reports/4.0.8_ca_diff.html')
# rmarkdown::render('./4.0.2_female_ca_acc.Rmd', output_file = './reports/4.0.2_female_ca_acc.html')
# rmarkdown::render('./4.0.3_male_ca_acc.Rmd', output_file = './reports/4.0.3_male_ca_acc.html')
# rmarkdown::render('./4.0.5_female_ca_spd.Rmd', output_file = './reports/4.0.5_female_ca_spd.html')
# rmarkdown::render('./4.0.6_male_ca_spd.Rmd', output_file = './reports/4.0.6_male_ca_spd.html')






