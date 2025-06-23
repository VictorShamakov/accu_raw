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
suppressMessages(library("scales")) # для задания формата подписей на осях координат
suppressMessages(library("readxl")) 
suppressMessages(library("writexl")) 
suppressMessages(library("gridExtra")) 

logger <- logger("DEBUG", 
                 appenders = list(file_appender("ast.log")
                                  # console_appender()
                                  ))

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
  mouse_tracks <- unique(mouse_tracks) # удаление дубликатов, чтобы не повторялись event_type == click
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
  # debug(logger, "get_pause")
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


get_velocity <- function(x, y, timestamp, units = "ms") {
  d <- get_distance(x, y)
  t <- c(0, timestamp[-1] - timestamp[-length(timestamp)])

  v <- c(d/t)
  v[is.nan(v)] <- 0
  
  # Конвертация единиц, если требуется
  if (units == "s") {
    v <- v * 1000
  } else if (units != "ms") {
    stop("Неверная единица измерения. Используйте 'ms' или 's'")
  }

  return(v)
}


get_acceleration <- function(timestamp, velocity) {
  # Проверка на одинаковую длину векторов
  if (length(timestamp) != length(velocity)) {
    stop("Векторы timestamp и velocity должны иметь одинаковую длину")
  }
  
  delta_v <- velocity[-1] - velocity[-length(velocity)]
  delta_t <- timestamp[-1] - timestamp[-length(timestamp)]
  
  a <- c(0, delta_v/delta_t)
  
  # Замена бесконечных значений на NA
  a[is.infinite(a)] <- max(a)
  
  return(a)
}


# velocity_harmonic_mean <- function(speeds, distances, units = "ms") {
#   if (length(speeds) != length(distances)) {
#     stop("Длины векторов скоростей и расстояний должны быть равны")
#   }
#   total_distance <- sum(distances)
#   weighted <- distances / speeds
#   weighted[is.nan(weighted)] <- 0
#   weighted_sum <- sum(weighted)
# 
#   if (units == "s") {
#     weighted_sum <- weighted_sum / 1000
#   }
# 
#   return(total_distance / weighted_sum)
# }


velocity_harmonic_mean <- function(speeds, distances, units = "origin") {
  # Проверяем длины векторов
  if (length(speeds) != length(distances)) {
    stop("Длины векторов скоростей и расстояний должны быть равны")
  }

  # Проверяем на наличие нулевых или отрицательных скоростей
  if (any(speeds < 0)) {
    stop("Скорости должны быть положительными")
  }

  # Вычисляем общую дистанцию
  total_distance <- sum(distances)

  # Вычисляем взвешенную сумму
  weighted <- distances / speeds
  weighted[is.nan(weighted)] <- 0
  weighted_sum <- sum(weighted)

  # Конвертация единиц, если требуется
  if (units == "s") {
    weighted_sum <- weighted_sum / 1000
  } else if (units == "ms") {
    weighted_sum <- weighted_sum  * 1000
  }

  # Возвращаем среднее гармоническое значение скорости
  return(total_distance / weighted_sum)
}


calculate_scaled_curvature <- function(time, x, y) {
  # Сортировка данных по времени
  ord <- order(time)
  time <- time[ord]
  x <- x[ord]
  y <- y[ord]
  
  if (length(time) < 3) return(0)
  
  # Инициализация векторов
  n <- length(time)
  curvature <- rep(NA, n)
  
  # Вычисление центральных разностей
  for (i in 2:(n-1)) {
    dt_prev <- time[i] - time[i-1]
    dt_next <- time[i+1] - time[i]
    
    # Первые производные
    x_prime <- (x[i+1] - x[i-1]) / (dt_prev + dt_next)
    y_prime <- (y[i+1] - y[i-1]) / (dt_prev + dt_next)
    
    # Вторые производные
    x_dbl_prime <- (x[i+1] - 2*x[i] + x[i-1]) / (mean(c(dt_prev, dt_next))^2)
    y_dbl_prime <- (y[i+1] - 2*y[i] + y[i-1]) / (mean(c(dt_prev, dt_next))^2)
    
    # Расчет кривизны
    numerator <- abs(x_prime * y_dbl_prime - y_prime * x_dbl_prime)
    denominator <- (x_prime^2 + y_prime^2)^1.5
    
    curvature[i] <- ifelse(denominator != 0, numerator / denominator, 0)
  }
  
  # Нормализация к шкале 0-100
  valid_curv <- curvature[!is.na(curvature)]
  if (all(valid_curv == 0)) return(rep(0, n))
  
  max_curv <- max(valid_curv, na.rm = TRUE)
  scaled_curvature <- round(curvature / max_curv * 100, 2)
  
  return(scaled_curvature)
}

## Graphics
draw_tracks <- function(mt, events=NULL, velocity=NULL, acceleration=NULL, title=NULL, facet=NULL, labels=NULL, line_color="magenta", point_color="black", canvas_width=800, canvas_height=800, canvas_coords_x=0, canvas_coords_y=0, ideal_coords=NULL, fix_size = T) {
  plot <- ggplot(data = mt, aes(x_mouse_pos, y_mouse_pos)) + 
    scale_y_reverse() +
    ggtitle(title) + xlab("x") + ylab("y") + theme_bw() + 
    theme(plot.title = element_text(size=22),
          axis.text.x = element_text(size = 16),
          axis.text.y = element_text(size = 16),
          axis.title.x = element_text(size = 20),
          axis.title.y = element_text(size = 20))
  
  if (fix_size == T) {
    plot <-  plot + xlim(canvas_coords_x, canvas_coords_x + canvas_width) +
      ylim(canvas_height + canvas_coords_y, canvas_coords_y)
    labels_position_x <- canvas_coords_x 
  } else {
    plot <-  plot + xlim(ast$canvas_coords_x - 600, ast$canvas_coords_x + ast$canvas_width + 600) +
      ylim(ast$canvas_height + ast$canvas_coords_y + 100, ast$canvas_coords_y - 100)
    labels_position_x <- 0
  }
  
  if (!missing(velocity)) {
    mt$velocity_smoothed <- get_velocity_smoothed(mt$velocity, velocity_limit = 4000)
    plot <- plot + geom_path(data = mt, alpha = I(0.5), linewidth=0.5, aes(col=velocity_smoothed)) +
      scale_colour_gradient2(low="chartreuse", mid="yellow", high="red", midpoint = 2000, name = "Скорость")
  }
  
  if (!missing(acceleration)) {
    mt$acceleration <- get_acceleration_smoothed(mt$acceleration, acceleration_limit = 0.05)
    plot <- plot + geom_path(data = mt, alpha = I(0.5), linewidth=0.5, aes(col=acceleration)) +
      scale_colour_gradient2(low="chartreuse", mid="yellow", high="red", midpoint = 0, name = "Ускорение")
  }
  
  if (!missing(ideal_coords)) {
    ideal_coords$x_mouse_pos <- ideal_coords$x_mouse_pos + canvas_coords_x
    ideal_coords$y_mouse_pos <- ideal_coords$y_mouse_pos + canvas_coords_y
    plot <- plot + geom_point(data=ideal_coords, color=I(point_color), shape=21, size=22, alpha=0.8, fill="white") +
    geom_text(data=ideal_coords, aes(label=row.names(ideal_coords)), hjust=0.5, vjust=0.5, alpha=0.7, check_overlap = T, size=4)
  }
  
  if (!missing(events)) {
    colors <- c("red", "chartreuse")
    labels_legend <- c("Промахи", "Попадания")
    
    if (length(unique(events$hits)) == 1 & unique(events$hits) == T) {
      colors <- c("chartreuse")
      labels_legend <- c("Попадания")
    } else if (length(unique(events$hits)) == 1 & unique(events$hits) == F) {
      colors <- c("red")
      labels_legend <- c("Промахи")
    }
    
    plot <- plot + geom_point(data=events, color=I(point_color), shape=21, size=11, alpha=0.5, aes(fill=hits)) +
    scale_fill_manual(values = colors, labels = labels_legend)  +
    geom_text(data=events, aes(label=row.names(events)), hjust=0.5, vjust=0.5, alpha=0.7, check_overlap = T, size=4) +
    labs(fill = "Цели")
    # geom_label(data=events, aes(label=row.names(events)), hjust=0.5, vjust=0.5, label.padding = unit(15, "pt"), label.r = unit(15, "pt"), label.size = .1, size=2.5)
  }
  
  
  if (!missing(facet)) {
    plot <- plot + facet_wrap(~part, nrow=1)
  }
  
  if (!missing(labels)) {
    plot <- plot + geom_text(
      label=labels, 
      x=labels_position_x, #зависит от fix_size
      y=-canvas_coords_y,
      size=5,
      hjust = "left", vjust = "top",
    )
  }
  
  return(plot)
}


draw_action <- function(ast_long, ast_mt, ast, ideal_coords, title="") {
  ideal_coords$x_mouse_pos <- ideal_coords$x_mouse_pos + ast$canvas_coords_x
  ideal_coords$y_mouse_pos <- ideal_coords$y_mouse_pos + ast$canvas_coords_y
  
  for (n in unique(ast_mt$target_numbers)) {
    
    slice <- ast_mt[ast_mt$target_numbers == n, ]
    
    if (nrow(slice) == 0) {
      next
    }
    
    slice$velocity_smd <- get_velocity_smoothed(slice$velocity, velocity_limit = 4000)
    curvature <- round(mean(calculate_scaled_curvature(slice$timestamp, slice$x_mouse_pos, slice$y_mouse_pos), na.rm = T), 3)
    line_distance <- round(ast_long$distance[n])
    time_interval <- round(ast_long$time_intervals[n], 2)
    miss_distance <- round(ast_long$miss_distance[n], 2)
    velocity <- round(ast_long$velocity[n], 2)
    
    if (ast_long$hits[n]) {
      target_color <- "chartreuse"
    } else {
      target_color <- "red"
    }
    
    p <- ggplot(data = slice) + 
      geom_rect(aes(xmin=ast$canvas_coords_x, xmax=ast$canvas_coords_x + ast$canvas_width, ymin=ast$canvas_coords_y, ymax=ast$canvas_coords_y + ast$canvas_height), color="black", fill="white") +
      geom_path(aes(x_mouse_pos, y_mouse_pos, col=velocity_smd), alpha = I(0.5), linewidth=0.5) + 
      scale_colour_gradient2(low="chartreuse", mid="yellow", high="red", midpoint = 2000, name = "Скорость") +
      geom_point(data = ideal_coords[n,], aes(x_mouse_pos, y_mouse_pos), shape=21, size=10, alpha=0.5, fill="white") +
      geom_point(data = ast_long[n,], aes(x_mouse_pos, y_mouse_pos), shape=21, size=2, fill=target_color) +
      scale_y_reverse(limits=c(ast$canvas_height + ast$canvas_coords_y + 100, ast$canvas_coords_y - 100)) +
      xlim(ast$canvas_coords_x - 600, ast$canvas_coords_x + ast$canvas_width + 600) +
      annotate("text", x = ast$canvas_coords_x - 600, y = 0, label = paste0("Кривизна линии: ", curvature, "\n", "Время: ", time_interval, " сек.\n", "Дистанция: ", line_distance, " px.\n", "Ср. скорость: ", velocity, " px/s.\n", "Промах: ", miss_distance, " px.\n"), size = 4, hjust = 0, vjust = 1) +
      ggtitle(paste(title, "Цель:", n))
    
    print(p)
  }
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


draw_time_barplot <- function(ast_long, user_id, test_id, accuracy_time_total, speed_time_total, ylimit=3, fix_size=T) {
  ast_long$time_intervals_smd <-  sleek(ast_long$time_intervals)
  
  if (fix_size == T) {
    ast_long$time_intervals[ast_long$time_intervals_smd >= ylimit] <- ylimit
    margin_left <- 3
  } else {
    ylimit <- max(ast_long$time_intervals)
    margin_left <- 0
  }
  
  time_barplot <- ggplot(ast_long, aes(seq_along(ast_long$timestamp), time_intervals)) + 
    geom_bar(stat = "identity", aes(fill=hits), col="grey90") + 
    geom_line(aes(y = time_intervals_smd)) +
    scale_fill_manual(breaks = c(T, F), values=c("#00bfc4", "#f8766d")) +
    geom_vline(xintercept = (nrow(ast_long) / 2) + 1, col = "black", alpha=0.5) +
    scale_y_continuous(breaks = seq(0, ylimit, 0.5)) +
    ylim(0, ylimit) +
    scale_x_continuous(breaks = seq(0, nrow(ast_long) + 10, 10), expand = c(0, 0), labels = number_format(accuracy = 1)) +
    xlab("") + ylab("Time, s") +
    theme(axis.text.x = element_text(size = 7, angle = 0, hjust = .5, vjust = .5),
          axis.text.y = element_text(size = 9, angle = 0, hjust = .5, vjust = .5),
          plot.margin=unit(c(0,0,0,margin_left), "mm")) + guides(fill = "none") + 
    annotate("label", x = 1, y = ylimit, label = paste0("T1: ", accuracy_time_total, " s."), size = 4, hjust = -0.5, vjust = 1.5) +
    annotate("label", x = 129, y = ylimit, label = paste0("T2: ", speed_time_total, " s."), size = 4, hjust = -0.5, vjust = 1.5) + 
    ggtitle(paste0("Диаграмма соотношения времени и точности попаданий. User ID: ", user_id, ", TEST: ", test_id))
  
  return(time_barplot)
}

draw_missings_barplot <- function(ast_long, accuracy_missings_distance, speed_missings_distance, ylimit=100, fix_size=T) {
  ast_long$miss_distance_smd <-  sleek(ast_long$miss_distance)
  
  if (fix_size == T) {
    ast_long$miss_distance[ast_long$miss_distance >= ylimit] <- ylimit
    margin_left <- 0
  } else {
    ylimit <- max(ast_long$miss_distance)
    margin_left <- 1
  }
  
  missings_barplot <- ggplot(ast_long, aes(seq_along(ast_long$timestamp), miss_distance)) + 
    geom_bar(stat = "identity", aes(fill=hits), col="grey90") + 
    geom_line(aes(y = miss_distance_smd)) +
    scale_fill_manual(breaks = c(T, F), values=c("#00bfc4", "#f8766d")) +
    geom_vline(xintercept= (nrow(ast_long) / 2) + 1, col = "black", alpha=0.5) +
    scale_x_continuous(breaks = seq(0, nrow(ast_long) + 10, 10), expand = c(0, 0)) +
    scale_y_reverse(limits=c(ylimit, 0)) +
    xlab("Target") + ylab("Missings distance, px") +
    theme(axis.text.x = element_blank(), axis.ticks.x=element_blank(),
          axis.text.y = element_text(size = 9, angle = 0, hjust = .5, vjust = .5),
          legend.position = "bottom", 
          plot.margin=unit(c(-3,0,0,margin_left), "mm")) +
    annotate("label", x = 1, y = ylimit, label = paste0("M1: ", accuracy_missings_distance, " px."), size = 4, hjust = -0.5, vjust = -1) +
    annotate("label", x = 129, y = ylimit, label = paste0("M2: ", speed_missings_distance, " px."), size = 4, hjust = -0.5, vjust = -1)
  
  return(missings_barplot)
}


draw_distance_barplot <- function(ast_long, user_id, test_id, accuracy_distance_total, speed_distance_total, ylimit=1000, fix_size=T) {
  ast_long$distance_smd <-  sleek(ast_long$distance)
  
  if (fix_size == T) {
    ast_long$distance[ast_long$distance_smd >= ylimit] <- ylimit
    margin_left <- 0
  } else {
    ylimit <- max(ast_long$distance)
    margin_left <- 0
  }
  
  distance_barplot <- ggplot(ast_long, aes(seq_along(ast_long$timestamp), distance)) + 
    geom_bar(stat = "identity", aes(fill=hits), col="grey90") + 
    geom_line(aes(y = distance_smd)) +
    scale_fill_manual(breaks = c(T, F), values=c("#00bfc4", "#f8766d")) +
    geom_vline(xintercept = (nrow(ast_long) / 2) + 1, col = "black", alpha=0.5) +
    scale_y_continuous(breaks = seq(0, ylimit, 0.5)) +
    ylim(0, ylimit) +
    scale_x_continuous(breaks = seq(0, nrow(ast_long) + 10, 10), expand = c(0, 0), labels = number_format(accuracy = 1)) +
    xlab("") + ylab("Distance, px.") +
    theme(axis.text.x = element_text(size = 7, angle = 0, hjust = .5, vjust = .5),
          axis.text.y = element_text(size = 9, angle = 0, hjust = .5, vjust = .5),
          plot.margin=unit(c(0,0,0,margin_left), "mm")) + guides(fill = "none") + 
    annotate("label", x = 1, y = ylimit, label = paste0("D1: ", accuracy_distance_total, " px."), size = 4, hjust = -0.1, vjust = 1) +
    annotate("label", x = 129, y = ylimit, label = paste0("D2: ", speed_distance_total, " px."), size = 4, hjust = -0.1, vjust = 1) + 
    ggtitle(paste0("Диаграмма соотношения амплитуды и точности попаданий. User ID: ", user_id, ", TEST: ", test_id))
  
  return(distance_barplot)
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
  df <- describe(distances_vector[-1], quant = c(0.25, 0.75)) #Первое значение всегда 0
  df <- select(df, -vars, -n)
  names(df) <- paste0("distance", "_", names(df))
  df$distance_total <- sum(distances_vector)
  df <- select(df, distance_total, everything())
  
  tryCatch(expr = {
    model <- lm(distances_vector ~ n, data = data.frame(n=seq_along(distances_vector), distances_vector=distances_vector))
    df$distance_trend <- model$coefficients[2]
  },
  error = function(err) {
    df$distance_trend <- NA
  })
  
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

get_accuracy_rate <- function(miss_distance) {
  miss_distance_percent <- 100 - miss_distance * 100 / 38
  miss_distance_percent[miss_distance_percent < 0] <- 0
  
  return(miss_distance_percent)
}


get_pauses_features <- function(pauses) {
  if (length(pauses) == 0) {pauses <- 0}  # если пользователь не сделал ни одной паузы
  
  df <- describe(pauses, quant = c(0.25, 0.75))
  df <- select(df, -vars, -n)
  names(df) <- paste0("pause", "_", names(df))
  df$pause_total <- sum(pauses)
  df$pause_number <- length(pauses)
  df <- select(df, pause_total, pause_number, everything())
  
  tryCatch(expr = {
    model <- lm(pauses ~ n, data = data.frame(n=seq_along(pauses), pauses=pauses))
    df$pause_trend <- model$coefficients[2]
  },
  error = function(err) {
    df$pause_trend <- 0
  })
  
  df <- round(df, 2)
  return(as.list(df))
}

get_velocity_smoothed <- function(velocity, velocity_limit=4) {
  # debug(logger, "get_velocity_smoothed")
  #Скорость для каждого участка пути
  
  # if (min(velocity) < 0) {next} #добавить проверку, если минимальная скорость ниже нуля, это артефакт
  if (length(velocity) > 2) {
    velocity[velocity > velocity_limit] <- velocity_limit
    velocity_smoothed <- sleek(velocity)
    # Если двигать слишком быстро, почему-то возникают NaN 
    velocity_smoothed[1] <- 0 # устанавливаем нижнюю границу скорости для построения графиков
    velocity_smoothed[length(velocity_smoothed)] <- velocity_limit # устанавливаем верхнюю границу скорости для построения графиков
    
  } else {
    return(0)
  }
  
  return(velocity_smoothed)
}

get_velocity_by_target <- function(ast_merged) {
  target_speeds <- vector()
  
  for (target in unique(ast_merged$target_numbers)) {
    ast_by_target <- ast_merged[ast_merged$target_numbers == target, ]
    velocity <- get_velocity(ast_by_target$x_mouse_pos, ast_by_target$y_mouse_pos, ast_by_target$timestamp, units = "s")
    distance_for_velocity <- get_distance(ast_by_target$x_mouse_pos, ast_by_target$y_mouse_pos)
    velocity_mean <- round(velocity_harmonic_mean(velocity, distance_for_velocity), 2)
    
    target_speeds <- c(target_speeds, velocity_mean)
  }
  
  target_speeds[is.nan(target_speeds)] <- 0
  return(target_speeds)
}

get_velocity_features <- function(velocity_vector) {
  df <- describe(velocity_vector[-1], quant = c(0.25, 0.75)) #Начальная скорость всегда равна 0
  df <- select(df, -vars, -n, -mean, -median, -trimmed)
  names(df) <- paste0("velocity", "_", names(df))
  df <- select(df, everything())
  
  model <- lm(velocity_vector ~ n, data = data.frame(n=seq_along(velocity_vector), velocity_vector=velocity_vector))
  df$velocity_trend <- model$coefficients[2]
  
  df <- round(df, 2)
  return(as.list(df))
}

get_acceleration_features <- function(acceleration_vector, prefix) {
  tryCatch(expr = {
    df <- describe(acceleration_vector, quant = c(0.25, 0.75))
    df <- select(df, -vars)
    names(df) <- paste0(prefix, "_", names(df))
    df <- select(df, everything())
  },
  error = function(err) {
    df <- data.frame()
    names(df) <- paste0(prefix, "_", c("n", "mean", "sd", "median", "trimmed", "mad", "min", "max", "range", "skew", "kurtosis", "se", "Q0.25", "Q0.75"))
  })
  
  if (prefix == "acc") {
    df$jerk_line <- sort(boxplot.stats(acceleration_vector)$out, decreasing = T)[4]
    df$n_jerk <- length(boxplot.stats(acceleration_vector)$out)
  } else {
    df$braking_line <- sort(boxplot.stats(acceleration_vector)$out, decreasing = F)[4]
    df$n_braking <- length(boxplot.stats(acceleration_vector)$out)
  }
  
  df <- round(df, 2)
  return(as.list(df))
}

#' Merge acceleration vector and decceleration vector
#'
#' Данная функция возвращает data frame с значениями ускорений и замедлений
#'
#' @param acceleration list
#' @param deceleration list
#' @return Dataframe
#' @examples
#' merge_acc_dec(acceleration, deceleration)
#' @export
merge_acc_dec <- function(acceleration, deceleration) {
  acc_dec <- vector()
  acc_dec_time <- vector()
  
  for (i in seq_along(acceleration$values)) {
    acc_dec <- c(acc_dec, acceleration$values[i], deceleration$values[i])
    acc_dec_time <- c(acc_dec_time, acceleration$time[i], deceleration$time[i])
  }
  
  acc_dec <- na.omit(acc_dec)
  acc_dec_time <- na.omit(acc_dec_time)
  
  df <- data.frame(time=0, acceleration=0)
  df <- rbind(df, data.frame(time=acc_dec_time, acceleration=acc_dec))
  df$acceleration_smd <- sleek(df$acceleration)
  
  return(df)
}

get_acceleration_smoothed <- function(acceleration, acceleration_limit=0.05) {
  acceleration_smoothed <- sleek(acceleration) #сглаживание
  acceleration_smoothed[acceleration_smoothed > acceleration_limit] <- acceleration_limit
  acceleration_smoothed[acceleration_smoothed < -acceleration_limit] <- -acceleration_limit
  acceleration_smoothed[1] <- -acceleration_limit # устанавливаем нижнюю границу ускорения для построения графиков
  acceleration_smoothed[length(acceleration_smoothed)] <- acceleration_limit # устанавливаем верхнюю границу ускорения для построения графиков
  
  return(acceleration_smoothed)
}

get_acceleration_by_target <- function(target_numbers, acceleration, last_target_number = 128, dec = NULL) {
  target_mean_acceleration <- vector()
  
  for (target_number in unique(target_numbers)) {
    acc_by_target <- acceleration[target_numbers == target_number]
    
    if (is.null(dec)) {
      sequences <- extract_true_sequences(acc_by_target >= 0)
      
      if (target_number != last_target_number) {
        tryCatch(expr = {
          mean_acc <- mean(acc_by_target[sequences[[1]]])
        },
        error = function(err) { 
          mean_acc <- 0
        })
      } else {
        mean_acc <- 0
      }
    } else {
      sequences <- extract_true_sequences(acc_by_target < 0)
      if (target_number == 1 | target_number == last_target_number) {
        mean_acc <- 0
      } else {
        tryCatch(expr = {
          mean_acc <- mean(acc_by_target[sequences[[length(sequences)]]])
        },
        error = function(err) { 
          mean_acc <- 0
        })
      }
    }
    
    target_mean_acceleration[target_number] <- mean_acc
  }
  
  return(target_mean_acceleration)
}

get_fitts_coefs <- function(time_intervals, ideal_distance, target_size) {
  df <- data.frame(time_intervals, ideal_distance)
  df <- df[-1, ]
  
  model <- lm(time_intervals ~ log2(ideal_distance / 76 + 1), data = df)
  
  return(model$coefficients)
}

get_fitts_time <- function(distance, target_size = 76, a = 0, b = 0.1) {
  if (b != 0 & target_size > 0) {
    time <- ifelse(distance != 0, a + b * log2(distance / target_size + 1), 0)
    return(time)
  } else {
    return("Коэффициент b, либо размер мишени меньше 0, либо равно 0")
  }
}

#' Число ускорений за определенное время
#'
#' Данная функция возвращает вектор количеством ускорений за единицу времени. (по умолчанию: за секунду)
#'
#' @param acceleration vector
#' @param time vector
#' @return вектор с количеством ускорений за каждую секунду
#' @examples
#' get_number_accelerations_per_time(acceleration, time)
#' @export
get_number_accelerations_per_time <- function(acceleration, time) {
  n_acc_sec <- vector()
  for (i in 0:floor(max(time))) {
    n <- length(acceleration[time >= i & time < i + 1])
    n_acc_sec <- c(n_acc_sec, n)
  }
  
  return(n_acc_sec)
}


get_acceleration_features_per_time <- function(acceleration_per_time) {
  df <- describe(acceleration_per_time, quant = c(0.25, 0.75))
  df <- select(df, -vars, -n)
  df$max_pos <- which.max(acceleration_per_time) - 1 # секунда, на которой случилось максимальное количество ускорений в секунду
  df$min_pos <- which.min(acceleration_per_time) - 1 # секунда, на которой случилось минимальное количество ускорений в секунду
  names(df) <- paste0("acc_per_sec", "_", names(df))
  df <- select(df, everything())
  
  df <- round(df, 2)
  return(as.list(df))
  
}


collect_features <- function(ast, ...) {
  debug(logger, "collect_features")
  features <- data.frame(user_id=ast$user_id, session_id=ast$session_id, test_id=ast$test_id, ratio=ast$ratio, ...)
  return(features)
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

#' Вектор с нумерацией мишеней для треков движений
#'
#' Данная функция возвращает вектор с номерами мишеней для треков движений основываясь на временных метках
#'
#' @param target_timestamps vector
#' @param movement_timestamps vector
#' @return Вектор с номерами мишеней
#' @examples
#' get_target_numbers_by_timestamp(target_timestamps, movement_timestamps)
#' @export
get_target_numbers_by_timestamp <- function(target_timestamps, movement_timestamps) {
  target_n <- vector()
  
  for (n in seq_along(target_timestamps)) {
    if (n == 1) {
      numbers <- movement_timestamps[movement_timestamps == target_timestamps[n]]
    } else {
      numbers <- movement_timestamps[movement_timestamps > target_timestamps[n - 1] & movement_timestamps <= target_timestamps[n]]
    }
    target_n <- c(target_n, rep(n, length(numbers)))
  }

  return(target_n)
}



extract_true_sequences <- function(vec) {
  # Определяем, где начинается и заканчивается каждая группа TRUE
  starts <- which(diff(c(FALSE, vec)) == 1) # Начала последовательностей TRUE
  ends <- which(diff(c(vec, FALSE)) == -1)  # Концы последовательностей TRUE
  
  # Извлекаем индексы для каждой последовательности
  sequences <- mapply(function(start, end) c(start, end), starts, ends, SIMPLIFY = FALSE)
  
  return(sequences)
}

#' Преобразования ускорения
#'
#' Данная функция преобразовывает объединяет последовательность ускорений
#'
#' @param acceleration vector
#' @param timestamp vector
#' @param velocity vector
#' @param time vector
#' @return Вектор с ускорениями, либо список со временем и ускорениями
#' @examples
#' convert_acceleration(sequences, timestamp, velocity, time)
#' @export
convert_acceleration <- function(acceleration, timestamp, velocity, time = NULL, deceleration = NULL) {
  if (is.null(deceleration)) {
    acc_logical <- acceleration >= 0
    acc_logical[1] <- FALSE # переводим первое значение FALSE для корректного нахождения самого первого ускорения
  } else {
    acc_logical <- acceleration < 0
    acc_logical[length(acceleration)] <- TRUE 
  }
  
  sequences <- extract_true_sequences(acc_logical)
  
  vec <- vector()
  for (sequence in sequences) {
    delta_time <- timestamp[sequence[2]] - (timestamp[sequence[1] - 1])
    delta_velocity <- velocity[sequence[2]] - (velocity[sequence[1] - 1])
    vec <- c(vec, delta_velocity / delta_time)
  }
  
  if(!is.null(time)) {
    time <- time[sapply(sequences, `[`, 2)]
    
    return(list(time=time, values=vec))
  }
  
  return(vec)
}


get_combo_targets <- function(hits) {
  max_hits <- vector()
  
  if (length(extract_true_sequences(hits)) == 0) {
    return(0)
  }
  
  for (i in extract_true_sequences(hits)) {
    max_hits <- c(max_hits, i[2] - i[1] + 1)
  }
  
  return(max_hits)
}


draw_comparisons <- function(sample_feature, personal_feature, title, units = "") {
  ecdf_func <- ecdf(sample_feature)
  percentile <- round((ecdf_func(personal_feature)) * 100, 1)
  
  df <- data.frame(sample_feature)
  
  # plot_hist <- ggplot(df, aes(sample_feature)) + geom_histogram(fill="skyblue", color="black", alpha=0.5) +
  #   geom_vline(xintercept=personal_feature, col = "red") +
  #   annotate("text", x = personal_feature, y = 0, label = paste0(100 - percentile, "% "), size = 3, hjust = -0.1, vjust = 1.4) +
  #   annotate("text", x = personal_feature, y = 0, label = paste0(percentile, "%"), size = 3, hjust = 1.1, vjust = 1.4) +
  #   xlab(title) + 
  #   ggtitle(paste0(title, ". Ваш результат: ", personal_feature, " ", units))
  
  plot_dens <- ggplot(df, aes(sample_feature)) + geom_density(fill="skyblue", alpha=0.5) +
    geom_vline(xintercept=personal_feature, col = "red") +
    annotate("text", x = personal_feature, y = 0, label = paste0(100 - percentile, "% "), size = 3, hjust = -0.1, vjust = 1.4) +
    annotate("text", x = personal_feature, y = 0, label = paste0(percentile, "%"), size = 3, hjust = 1.1, vjust = 1.4) +
    xlab(title) + 
    ggtitle(paste0(title, ". Ваш результат: ", personal_feature, " ", units))
  
  return(plot_dens)
}


get_all_datasets <- function(db=NULL, ast, ast_data, mouse_tracks=NULL, ideal_coords) {
  debug(logger, "get_all_datasets")
  ast_long <- get_ast_long(ast_data)
  
  ast_long <- ast_long[order(ast_long$timestamp),]
  
  ast_long$miss_distance <- round(get_distance_a_b(ideal_coords$x_mouse_pos + ast$canvas_coords_x, ast_long$x_mouse_pos,
                                                   ideal_coords$y_mouse_pos + ast$canvas_coords_y, ast_long$y_mouse_pos), 2)
  
  ast_long$hits <- ifelse(ast_long$miss_distance > 38, F, T)
  ast_long$time_intervals <- get_time_intervals(ast_long$timestamp, units = "s")
  ast_long$time <- cumsum(ast_long$time_intervals)
  time <- get_time_features(ast_long, units = "s")
  
  ast_long$ideal_distance <- get_distance(ideal_coords$x_mouse_pos, ideal_coords$y_mouse_pos)
  fitts_coef <- get_fitts_coefs(ast_long$time_intervals, ast_long$ideal_distance, 76)
  ast_long$fitts_time_invervals <- get_fitts_time(distance = ast_long$ideal_distance, a = fitts_coef[1], b = fitts_coef[2])
  ast_long$fitts_time <- cumsum(ast_long$fitts_time_invervals)
  
  missings <- get_missings_features(ast, ast_long, ast_data, ideal_coords = ideal_coords) # промахи
  miss_distance <- get_distance_a_b(ideal_coords$x_mouse_pos + ast$canvas_coords_x, ast_long$x_mouse_pos,
                                    ideal_coords$y_mouse_pos + ast$canvas_coords_y, ast_long$y_mouse_pos)
  ast_long$accuracy_rate <- get_accuracy_rate(miss_distance)
  missings$accuracy_rate <- round(mean(ast_long$accuracy_rate), 2)
  
  combo_hits <- max(get_combo_targets(ast_long$hits))
  combo_missings <- max(get_combo_targets(!ast_long$hits))
  
  if (!missing(db) & missing(mouse_tracks)) {
    ast_mt <- get_mouse_tracks(db, session_id = ast$session_id)
  } else {
    ast_mt <- get_mouse_tracks_from_file(mouse_tracks, session_id = ast$session_id)
  }
  
  # Добавляем в треки мыши данные первой и последней мишени, чтобы успешно проставить номера мишеней для треков мыши.
  ast_mt <- rbind(ast_mt, ast_long[c(1, nrow(ast_long)), 1:3]) 
  ast_mt <- ast_mt[order(ast_mt$timestamp), ] 
  ast_mt <- unique(ast_mt)
  
  # Выбираем треки мыши, которые были совершены во время прохождения теста
  ast_mt <- ast_mt[ast_mt$timestamp >= ast_long$timestamp[1] & ast_mt$timestamp <= ast_long$timestamp[nrow(ast_long)], ]

  # Если нет треков движений мыши
  if (nrow(ast_mt) == 0) {
    ast_mt <- select(ast_long, timestamp, x_mouse_pos, y_mouse_pos)
  }
  
  ast_mt$time_intervals <- get_time_intervals(ast_mt$timestamp, units = "s")
  ast_mt$time <- cumsum(ast_mt$time_intervals)
  
  ast_mt$target_numbers <- get_target_numbers_by_timestamp(ast_long$timestamp, ast_mt$timestamp)
  
  ast_merged <- merge(ast_mt, ast_long, by = c("timestamp", "x_mouse_pos", "y_mouse_pos"), all = T) # треки мыши + попадания
  click_positions <- which(ast_merged$event_type == "click") # обрезка датасета, чтобы не было движений после последнего клика
  ast_merged <- ast_merged[click_positions[1]:click_positions[length(click_positions)], ]
  ast_merged$target_numbers <- get_target_numbers(ast_merged$event_type, "click")
  
  ast_long$distance <- get_distances_points(ast_merged$x_mouse_pos, ast_merged$y_mouse_pos, which(!is.na(ast_merged$event_type)))
  
  distance <- get_distance_features(ast_merged) # пройденное расстояние мышью
  
  point_to_point_distance <- get_distance(ast_merged$x_mouse_pos, ast_merged$y_mouse_pos) #вектор со всеми отрезками пройденного расстояния
  pauses <- get_pauses(ast_merged, point_to_point_distance, 1, units = "ms") #вектор с паузами
  pauses_features <- get_pauses_features(pauses) # признаки пауз
  
  ast_mt$velocity <- get_velocity(ast_mt$x_mouse_pos, ast_mt$y_mouse_pos, ast_mt$timestamp, units = "s")
  ast_mt$acceleration <- get_acceleration(ast_mt$timestamp, ast_mt$velocity)
  stops <- sum(ast_mt$velocity[-1] == 0)
  
  acceleration <- convert_acceleration(ast_mt$acceleration, timestamp = ast_mt$timestamp, velocity = ast_mt$velocity, time = ast_mt$time)
  acceleration_features <- get_acceleration_features(acceleration$values, "acc")

  decceleration <- convert_acceleration(ast_mt$acceleration, timestamp = ast_mt$timestamp, velocity = ast_mt$velocity, time = ast_mt$time, deceleration = T)
  decceleration_features <- get_acceleration_features(decceleration$values, "dec")

  df.acceleration <- merge_acc_dec(acceleration, decceleration)
  number_acceleration_per_second <- get_number_accelerations_per_time(df.acceleration$acceleration, df.acceleration$time)
  acceleration_per_second <- get_acceleration_features_per_time(number_acceleration_per_second)

  ast_long$acceleration <- get_acceleration_by_target(ast_mt$target_numbers, ast_mt$acceleration, last_target_number = nrow(ast_long))
  ast_long$decceleration <- get_acceleration_by_target(ast_mt$target_numbers, ast_mt$acceleration, last_target_number = nrow(ast_long), dec = T)
  
  ast_long$clicked_through_targets <- ast_long$hits == F & ast_long$distance <= 200
  combo_clicked_through_targets <- max(get_combo_targets(ast_long$clicked_through_targets))
  clicked_through_targets <- sum(ast_long$clicked_through_targets)
  
  distance_for_velocity <- get_distance(ast_mt$x_mouse_pos, ast_mt$y_mouse_pos)
  velocity_mean <- round(velocity_harmonic_mean(ast_mt$velocity, distance_for_velocity), 2)
  
  ast_long$velocity <- get_velocity_by_target(ast_merged)
  velocity <- get_velocity_features(ast_long$velocity)
  
  corr_sat <- round(cor(ast_long$miss_distance, ast_long$velocity), 3)
  
  features <- collect_features(ast, time, fitts_a = fitts_coef[1], fitts_b = fitts_coef[2], distance, pauses_features, stops, velocity_mean, velocity, acceleration_features, decceleration_features, acceleration_per_second, missings, combo_hits, combo_missings, clicked_through_targets, combo_clicked_through_targets, corr_sat)
  
  return(list(features=features, ast_mt=ast_mt, ast_long=ast_long, ast_merged=ast_merged))
}

