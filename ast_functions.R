suppressMessages(library("dotenv"))
suppressMessages(library("DBI"))
suppressMessages(library("RMySQL"))
suppressMessages(library("dplyr"))
suppressMessages(library("ggplot2"))
suppressMessages(library("sleekts")) # для сглаживание временных рядов
suppressMessages(library("zeallot")) # для множественного присваивания
suppressMessages(library("stringi"))
suppressMessages(library("jsonlite"))
suppressMessages(library("log4r"))
suppressMessages(library("plotly"))
suppressMessages(library("psych"))

logger <- logger("DEBUG", 
                 appenders = list(file_appender("ast.log"), 
                                  console_appender()))

"%+%" <- function(...){paste0(...)}


get_names <- function(names, prefix=NULL) {
  v <- vector()
  for (name in 1:length(names)) {
    v <- c(v, paste0(prefix, name))
  }
  return(v)
}


get_ast_long <- function(row) {
  debug(logger, "get_ast_long")
  df <- data.frame(
    timestamp = as.vector(t(row[, grep("^timestamp", names(row))])), 
    x_mouse_pos = as.vector(t(row[, grep("^x_mouse_pos", names(row))])),
    y_mouse_pos = as.vector(t(row[, grep("^y_mouse_pos", names(row))]))
  )
  df$event_type <- "click"
  return(df)
}

get_mouse_tracks <- function(db, session_id) {
  debug(logger, "get_mouse_tracks")
  if (is.null(session_id)) {
    return("Session_id is empty")
  }

  sql_query <- dbGetQuery(db,'SELECT mouse_tracks.timestamp, 
                               mouse_tracks.x_mouse_pos, 
                               mouse_tracks.y_mouse_pos
                        FROM sessions INNER JOIN mouse_tracks
                        ON sessions.session_id = mouse_tracks.session_id
                        WHERE sessions.session_id = "' %+% session_id %+% '";')
  sql_query$timestamp <- as.numeric(sql_query$timestamp)
  sql_query <- unique(sql_query) # удаление дубликатов, чтобы не повторялись event_type == click
  return(sql_query)
}

get_mouse_tracks_from_file <- function(mouse_tracks, session_id) {
  debug(logger, "get_mouse_tracks")
  if (is.null(session_id)) {
    return("Session_id is empty")
  }
  
  mouse_tracks <- mouse_tracks[mouse_tracks$session_id == session_id, c("timestamp", "x_mouse_pos", "y_mouse_pos")] 
  mouse_tracks$timestamp <- as.numeric(mouse_tracks$timestamp)
  mouse_tracks <- unique(mouse_tracks)
  mouse_tracks <- mouse_tracks[order(mouse_tracks$timestamp),]
  #добавить удаление дубликатов
  return(mouse_tracks)
}


get_distance <- function(x, y) {
  # debug(logger, "get_distance")
  distance <- 0
  for (i in seq_along(x[-1])) {
    a <- x[i + 1] - x[i]
    b <- y[i + 1] - y[i]
    c <- sqrt(a**2 + b**2)
    distance <- c(distance, c)
  }
  return(distance)
}


get_distances_points <- function(x, y, clicks) {
  distances <- 0
  
  for (p in seq_along(clicks[-1])) {
    distance <- sum(get_distance(x[clicks[p]:clicks[p+1]], y[clicks[p]:clicks[p+1]]))
    distances <- c(distances, distance)
  }
  
  return(distances)
}


get_pauses <- function(df, distance, treshhold=1, units="ms") {
  debug(logger, "get_pause")
  zero_distance <- (distance==0)
  counter <- 0
  pauses <- numeric()
  
  for (position in seq_along(zero_distance)) {
    if (zero_distance[position]) {
      counter <- counter + 1
    } else {
      if (counter != 0) {
        pause <- df$timestamp[position] - df$timestamp[position - counter]
        if (pause >= treshhold) {pauses <- c(pauses, pause)}
      }
      counter <- 0
    }
  }
  
  if (units == "s") {
    pauses <- pauses / 1000
  }
  
  return (pauses)
}


get_distance_a_b <- function(x1, x2, y1, y2) {
  distance <- vector()
  for (i in seq_along(x1)) {
    a <- x2[i] - x1[i]
    b <- y2[i] - y1[i]
    c <- sqrt(a**2 + b**2)
    distance <- c(distance, c)
  }
  return(distance)
}


get_velocity <- function(x, y, timestamp) {
  d <- get_distance(x, y)
  t <- c(0, timestamp[-1] - timestamp[-length(timestamp)])

  v <- c(d/t)
  v[is.nan(v)] <- 0

  return(v)
}


get_acceleration <- function(timestamp, velocity) {
  delta_v <- velocity[-1] - velocity[-length(velocity)]
  delta_t <- timestamp[-1] - timestamp[-length(timestamp)]
  
  a <- c(0, delta_v/delta_t)
  return(a)
}


velocity_harmonic_mean <- function(speeds, distances, units = "ms") {
  if (length(speeds) != length(distances)) {
    stop("Длины векторов скоростей и расстояний должны быть равны")
  }
  total_distance <- sum(distances)
  weighted <- distances / speeds
  weighted[is.nan(weighted)] <- 0
  weighted_sum <- sum(weighted)
  
  if (units == "s") {
    weighted_sum <- weighted_sum / 1000
  }
  
  return(total_distance / weighted_sum)
}


draw_tracks <- function(mt, events=NULL, velocity=NULL, acceleration=NULL, title=NULL, facet=NULL, labels=NULL, line_color="magenta", point_color="black", canvas_width=800, canvas_height=800, canvas_coords_x=0, canvas_coords_y=0, ideal_coords=NULL) {
  plot <- ggplot(data = mt, aes(x_mouse_pos, y_mouse_pos)) + 
    xlim(canvas_coords_x, canvas_coords_x + canvas_width) + 
    # ylim(canvas_height + canvas_coords_y, canvas_coords_y) +
    scale_y_reverse(limits=c(canvas_height + canvas_coords_y, canvas_coords_y)) +
    ggtitle(title) + xlab("x") + ylab("y") + theme_bw() + 
    theme(plot.title = element_text(size=22),
          axis.text.x = element_text(size = 16),
          axis.text.y = element_text(size = 16),
          axis.title.x = element_text(size = 20),
          axis.title.y = element_text(size = 20))
  
  if (!missing(velocity)) {
    mt$velocity_smoothed <- get_velocity_smoothed(mt$velocity)
    plot <- plot + geom_path(data = mt, alpha = I(1), linewidth=0.5, aes(col=velocity_smoothed)) +
      scale_colour_gradient2(low="chartreuse", mid="yellow", high="red", midpoint = 2)
  }
  
  if (!missing(acceleration)) {
    plot <- plot + geom_path(data = mt, alpha = I(1), linewidth=0.5, aes(col=acceleration)) +
      scale_colour_gradient2(low="chartreuse", mid="yellow", high="red", midpoint = 0)
  }
  
  if (!missing(ideal_coords)) {
    ideal_coords$x_mouse_pos <- ideal_coords$x_mouse_pos + canvas_coords_x
    ideal_coords$y_mouse_pos <- ideal_coords$y_mouse_pos + canvas_coords_y
    plot <- plot + geom_point(data=ideal_coords, color=I(point_color), shape=21, size=22, alpha=0.8, fill="white") +
    geom_text(data=ideal_coords, aes(label=row.names(ideal_coords)), hjust=0.5, vjust=0.5, alpha=0.7, check_overlap = T, size=4)
  }
  
  if (!missing(events)) {
    colors <- c("red", "chartreuse")
    
    if (length(unique(events$hits)) == 1 & unique(events$hits) == T) {
      colors <- c("chartreuse")
    } else if (length(unique(events$hits)) == 1 & unique(events$hits) == F) {
      colors <- c("red")
    }
    
    plot <- plot + geom_point(data=events, color=I(point_color), shape=21, size=11, alpha=0.5, aes(fill=hits)) +
    scale_fill_manual(values = colors)  +
    geom_text(data=events, aes(label=row.names(events)), hjust=0.5, vjust=0.5, alpha=0.7, check_overlap = T, size=4)
    # geom_label(data=events, aes(label=row.names(events)), hjust=0.5, vjust=0.5, label.padding = unit(15, "pt"), label.r = unit(15, "pt"), label.size = .1, size=2.5)
  }
  
  
  if (!missing(facet)) {
    plot <- plot + facet_wrap(~part, nrow=1)
  }
  
  if (!missing(labels)) {
    plot <- plot + geom_text(
      label=labels, 
      x=canvas_coords_x,
      y=-canvas_coords_y,
      size=5,
      hjust = "left", vjust = "top",
    )
  }
  
  return(plot)
}


draw_composition <- function(plot_list, title) {
  for (n in seq_along(plot_list)) {
    plot_list[[n]]$layers[[3]] <- NULL
    plot_list[[n]]$labels$title <- NULL
    plot_list[[n]]$labels$x <- NULL
    plot_list[[n]]$labels$y <- NULL
  }
  
  plot <- grid.arrange(plot_list[[1]], plot_list[[2]], plot_list[[3]], plot_list[[4]],
                       nrow = 2, ncol = 2, 
                       top = textGrob(title, gp = gpar(fontsize=32)), 
                       bottom = textGrob("X", gp = gpar(fontsize=21)), 
                       left = textGrob("Y", rot = 90, gp = gpar(fontsize=21)), newpage=F)
  return(plot)
}


#Processing
create_ast <- function(ast_raw) {
  ast <- data.frame(user_id=ast_raw$userid, tracker_id=ast_raw$tracker_id, test_id=ast_raw$testid, firstname=ast_raw$firstname, lastname=ast_raw$lastname, ratio=ast_raw$ratio, canvas_coords_x=ast_raw$canvas_coords_x, canvas_coords_y=ast_raw$canvas_coords_y, canvas_width=ast_raw$canvas_width, canvas_height=ast_raw$canvas_height, stringsAsFactors = F)
  numeric <- !grepl("^firstname$|^lastname$", names(ast))
  ast[numeric] <- data.frame(lapply(ast[numeric], as.numeric), stringsAsFactors = F)
  debug(logger, "create_ast")
  return(ast)
}


form_ast_data <- function(ast_raw_data) {
  ast_data <- data.frame(t(strsplit(ast_raw_data, ";", fixed = TRUE)[[1]]), stringsAsFactors = F)
  click_features <- names(ast_data)
  click_features[rep(c(T, F, F), length(click_features) / 3)] <- get_names(1:(length(click_features) / 3), "timestamp")
  click_features[rep(c(F, T, F), length(click_features) / 3)] <- get_names(1:(length(click_features) / 3), "x_mouse_pos")
  click_features[rep(c(F, F, T), length(click_features) / 3)] <- get_names(1:(length(click_features) / 3), "y_mouse_pos")
  names(ast_data) <- click_features
  ast_data <- data.frame(lapply(ast_data, as.numeric), stringsAsFactors = F)
  debug(logger, "form_ast_data")
  return(ast_data)
}


get_session <- function(db, ast, ast_data) {
  sessions <- dbGetQuery(db, "SELECT DISTINCT sessions.session_id FROM sessions 
  INNER JOIN event_tracks ON sessions.session_id = event_tracks.session_id
  WHERE event_tracks.url LIKE '%/mod/accu/view1.php?id=" %+% ast$test_id %+% "%' AND event_tracks.timestamp >= " %+% ast_data$timestamp1 %+% " AND event_tracks.timestamp <= " %+% ast_data$timestamp2 %+% " AND sessions.tracker_id=" %+% ast$tracker_id %+% " AND sessions.user_id=" %+% ast$user_id %+% ";")
  ast <- dplyr::mutate(ast, session_id=sessions$session_id, .after=tracker_id)
  debug(logger, "get_session")
  return(ast)
}

get_session_from_file <- function(ast, ast_data, sessions, event_tracks) {
  sessions <- sessions[sessions$user_id == ast$user_id & sessions$tracker_id == ast$tracker_id, ]
  
  if (is.null(sessions)) {
    return("Session_id is empty")
  }
  
  session <- event_tracks$session_id[event_tracks$session_id %in% sessions$session_id & grepl("/mod/accu/view1.php\\?id=" %+% ast$test_id %+% "$", event_tracks$url) & event_tracks$timestamp >= ast_data$timestamp1 & event_tracks$timestamp <= ast_data$timestamp2][1]
  ast <- dplyr::mutate(ast, session_id=session, .after=tracker_id)
  return(ast)
}

get_time_features <- function(ast_long, units = "ms") {
  debug(logger, "get_time_features")
  time_vector <- ast_long$timestamp[-1] - ast_long$timestamp[-nrow(ast_long)]
  df <- describe(time_vector, quant = c(0.25, 0.75))
  df <- select(df, -vars, -n)
  names(df) <- paste0("time", "_", names(df))
  df$time_total <- sum(time_vector)
  df <- select(df, time_total, everything())
  
  model <- lm(time_vector ~ n, data = data.frame(n=seq_along(time_vector), time_vector=time_vector))
  df$time_trend <- model$coefficients[2]
  
  if (units == "s") {
    df[, -grep("skew|kurtosis|trend", names(df))] <- df[, -grep("skew|kurtosis|trend", names(df))] / 1000
  }
  
  df <- round(df, 2)
  return(as.list(df))
}

#' Временные интервалы
#'
#' Данная функция возвращает вектор с интервалами времени
#'
#' @param timestamps
#' @param units В каких единицах времени вернуть результат: "ms" - миллисекунды (по умолчанию), "s" - секунды.
#' @return Вектор с временными интервалами
#' @examples
#' get_time_intervals(timestamps, "s")
#' @export
get_time_intervals <- function(timestamps, units = "ms") {
  time_intervals <- timestamps[-1] - timestamps[-length(timestamps)]
  time_intervals <- c(0, time_intervals) # добавляем первую точку
  
  if (units == "s") {
    time_intervals <- time_intervals / 1000
  }
  
  return(time_intervals)
}


get_distance_features <- function(ast_merged) {
  debug(logger, "get_distance_features")
  #Добавить проверку на дистанцию, если пользователь прошел 0 или сильно меньше идеальной дистанции, то выдавать ошибку
  
  distances_vector <- get_distances_points(ast_merged$x_mouse_pos, ast_merged$y_mouse_pos, which(!is.na(ast_merged$event_type)))
  
  df <- describe(distances_vector, quant = c(0.25, 0.75))
  df <- select(df, -vars, -n)
  names(df) <- paste0("distance", "_", names(df))
  df$distance_total <- sum(distances_vector)
  df <- select(df, distance_total, everything())
  
  model <- lm(distances_vector ~ n, data = data.frame(n=seq_along(distances_vector), distances_vector=distances_vector))
  df$distance_trend <- model$coefficients[2]
  
  df <- round(df, 2)
  
  return(as.list(df))
}


get_missings_features <- function(ast, ast_long, ast_data, radius=38, ideal_coords) {
  debug(logger, "get_missings_features")
  
  miss_distance <- get_distance_a_b(ideal_coords$x_mouse_pos + ast$canvas_coords_x, ast_long$x_mouse_pos,
                                    ideal_coords$y_mouse_pos + ast$canvas_coords_y, ast_long$y_mouse_pos)
  
  ## Количество промахов
  missings <- sum(ifelse(miss_distance > radius, T, F))
  ## Количество попаданий
  hits <- nrow(ast_long) - missings
  
  df <- describe(miss_distance, quant = c(0.25, 0.75))
  df <- select(df, -vars, -n)
  names(df) <- paste0("missings", "_", names(df))
  df$missings <- missings
  df$hits <- hits
  df$missings_distance <- sum(miss_distance)
  df <- select(df, missings_distance, everything())
  
  model <- lm(miss_distance ~ n, data = data.frame(n=seq_along(miss_distance), miss_distance=miss_distance))
  df$missings_trend <- model$coefficients[2]
  
  df <- round(df, 2)
  
  return(as.list(df))
}


get_pauses_features <- function(pauses) {
  df <- describe(pauses, quant = c(0.25, 0.75))
  df <- select(df, -vars, -n)
  names(df) <- paste0("pause", "_", names(df))
  df$pause_total <- sum(pauses)
  df$pause_number <- length(pauses)
  df <- select(df, pause_total, pause_number, everything())
  
  model <- lm(pauses ~ n, data = data.frame(n=seq_along(pauses), pauses=pauses))
  df$pause_trend <- model$coefficients[2]
  
  df <- round(df, 2)
  return(as.list(df))
}


get_vel_acc_features <- function(ast_mt, velocity_limit=4, acceleration_limit=0.05) {
  debug(logger, "get_vel_acc_features")
  #Скорость и ускорение для каждого участка пути
  ast_mt$velocity <- round(get_velocity(ast_mt), 2)
  ast_mt$acceleration <- round(get_acceleration(ast_mt$timestamp, ast_mt$velocity), 2)
  
  # if (min(ast_mt$velocity) < 0) {next} #добавить проверку, если минимальная скорость ниже нуля, это артефакт
  ast_mt$velocity[ast_mt$velocity > velocity_limit] <- velocity_limit
  ast_mt$velocity <- sleek(ast_mt$velocity)
  # velocity_mean <- round(exp(mean(log(ast_mt$velocity[!is.infinite(ast_mt$velocity)]))), 2) # гармоническое среднее
  # Если двигать слишком быстро, почему-то возникают NaN 
  ast_mt$velocity[1] <- 0 # устанавливаем нижнюю границу скорости для построения графиков
  ast_mt$velocity[length(ast_mt$velocity)] <- velocity_limit # устанавливаем верхнюю границу скорости для построения графиков
  
  ast_mt$acceleration <- sleek(ast_mt$acceleration) #сглаживание
  ast_mt$acceleration[ast_mt$acceleration > acceleration_limit] <- acceleration_limit
  ast_mt$acceleration[ast_mt$acceleration < -acceleration_limit] <- -acceleration_limit
  ast_mt$acceleration[1] <- -acceleration_limit # устанавливаем нижнюю границу ускорения для построения графиков
  ast_mt$acceleration[length(ast_mt$acceleration)] <- acceleration_limit # устанавливаем верхнюю границу ускорения для построения графиков
  
  return(list(ast_mt=ast_mt))
}


get_velocity_smoothed <- function(velocity, velocity_limit=4) {
  debug(logger, "get_velocity_features")
  #Скорость для каждого участка пути
  
  # if (min(velocity) < 0) {next} #добавить проверку, если минимальная скорость ниже нуля, это артефакт
  velocity[velocity > velocity_limit] <- velocity_limit
  velocity_smoothed <- sleek(velocity)
  # Если двигать слишком быстро, почему-то возникают NaN 
  velocity_smoothed[1] <- 0 # устанавливаем нижнюю границу скорости для построения графиков
  velocity_smoothed[length(velocity_smoothed)] <- velocity_limit # устанавливаем верхнюю границу скорости для построения графиков
  
  return(velocity_smoothed)
}


get_fitts_time <- function(distance, target_size = 76, a = 0, b = 1) {
  if (b > 0 & target_size > 0) {
    time <- a + b * log2(distance / target_size + 1)
    return(time)
  } else {
    return("b, либо размер цели меньше, либо равно 0")
  }
}


collect_features <- function(ast, ...) {
  debug(logger, "collect_features")
  features <- data.frame(user_id=ast$user_id, session_id=ast$session_id, test_id=ast$test_id, ratio=ast$ratio, ...)
  return(features)
}


get_all_datasets <- function(db=NULL, ast, ast_data, mouse_tracks=NULL, ideal_coords) {
  debug(logger, "get_all_datasets")
  ast_long <- get_ast_long(ast_data)
  ast_long$miss_distance <- round(get_distance_a_b(ideal_coords$x_mouse_pos + ast$canvas_coords_x, ast_long$x_mouse_pos,
                                             ideal_coords$y_mouse_pos + ast$canvas_coords_y, ast_long$y_mouse_pos), 2)
  
  ast_long$hits <- ifelse(ast_long$miss_distance > 38, F, T)
  ast_long$time_intervals <- get_time_intervals(ast_long$timestamp, units = "s")
  ast_long$time <- cumsum(ast_long$time_intervals)
  
  if (!missing(db) & missing(mouse_tracks)) {
    ast_mt <- get_mouse_tracks(db, session_id = ast$session_id)
  } else {
    ast_mt <- get_mouse_tracks_from_file(mouse_tracks, session_id = ast$session_id)
  }
  
  ast_mt <- ast_mt[ast_mt$timestamp >= ast_long$timestamp[1] & ast_mt$timestamp <= ast_long$timestamp[nrow(ast_long)],]
  ast_mt$time_intervals <- get_time_intervals(ast_mt$timestamp, units = "s")
  ast_mt$time <- cumsum(ast_mt$time_intervals)
  
  if (nrow(ast_mt) == 0) {warning("No mouse tracks")}
  ast_merged <- merge(ast_mt, ast_long, by = c("timestamp", "x_mouse_pos", "y_mouse_pos"), all = T) # треки мыши + попадания
  click_positions <- which(ast_merged$event_type == "click") # обрезка датасета, чтобы не было движений после последнего клика
  ast_merged <- ast_merged[click_positions[1]:click_positions[length(click_positions)], ]
  ast_merged$target_numbers <- get_target_numbers(ast_merged$event_type, "click")
  
  time <- get_time_features(ast_long, units = "s")
  
  ast_long$distance <- get_distances_points(ast_merged$x_mouse_pos, ast_merged$y_mouse_pos, which(!is.na(ast_merged$event_type)))
  distance <- get_distance_features(ast_merged) # пройденное расстояние мышью
  
  point_to_point_distance <- get_distance(ast_merged$x_mouse_pos, ast_merged$y_mouse_pos) #вектор со всеми отрезками пройденного расстояния
  pauses <- get_pauses(ast_merged, point_to_point_distance, 1, units = "ms") #вектор с паузами
  pauses_features <- get_pauses_features(pauses) # признаки пауз
  
  missings <- get_missings_features(ast, ast_long, ast_data, ideal_coords = ideal_coords) # промахи
  
  ast_mt$velocity <- get_velocity(ast_mt$x_mouse_pos, ast_mt$y_mouse_pos, ast_mt$timestamp)
  
  distance_for_velocity <- get_distance(ast_mt$x_mouse_pos, ast_mt$y_mouse_pos)
  velocity_mean <- round(velocity_harmonic_mean(ast_mt$velocity, distance_for_velocity, units = "s"), 2)
  
  features <- collect_features(ast, time, distance, pauses_features, velocity_mean, missings)
  return(list(ast_mt=ast_mt, features=features, ast_long=ast_long, ast_merged=ast_merged))
}


#' Вектор с нумерацией мишеней для mouse tracking
#'
#' Данная функция возвращает вектор с номерами мишеней для данных mouse tracking
#'
#' @param event_type vector
#' @param event_name string
#' @return Вектор с номерами мишеней
#' @examples
#' get_target_numbers(event_type)
#' @export
get_target_numbers <- function(event_type, event_name) {
  clicks_positions <- which(event_type == event_name)
  
  target_n <- 1
  for (n in seq_along(clicks_positions)) {
    if (n < length(clicks_positions)) {
      target_n <- c(target_n, rep(n + 1, clicks_positions[n+1] - clicks_positions[n]))
    } 
  }
  
  return(target_n)
}

