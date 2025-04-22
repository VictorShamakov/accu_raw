rm(list=ls())
library("readxl")
library("dplyr")
test_id <- 66

# user_id <- 31
# rmarkdown::render('./1_preprocessing_files.Rmd', output_file = paste0('./data/users/', user_id, '/', "userid_", user_id, "_testid_", test_id, '_personal_report.html'), params = list(user_id = user_id, data_from_db = T))

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

for (user_id in ast_results$user_id[433:length(ast_results$user_id)]) {
  print(user_id)
  dir.create(paste0("./data/users/", user_id))
  rmarkdown::render('./1_preprocessing_files.Rmd', output_file = paste0('./data/users/', user_id, '/', "userid_", user_id, "_testid_", test_id, '_personal_report.html'), params = list(user_id = user_id, data_from_db = FALSE))
}

rmarkdown::render('./3.1_desc_stat_accuracy.Rmd', output_file = './reports/3.1_desc_stat_accuracy.html')
rmarkdown::render('./3.1_desc_stat_speed.Rmd', output_file = './reports/3.1_desc_stat_speed.html')


