suppressMessages(library("ggplot2"))
suppressMessages(library("RColorBrewer"))
suppressMessages(library("psych"))
suppressMessages(library("GGally"))
suppressMessages(library("dplyr"))
suppressMessages(library("knitr"))
suppressMessages(library("rstatix"))
# suppressMessages(library("car"))
suppressMessages(library("plotly")) #интерактивные графики
suppressMessages(library("corrplot"))
suppressMessages(library("rlang")) # для использования переменных в функциях ggplot
suppressMessages(library(readxl))
suppressMessages(library(VIM))
suppressMessages(library(lattice))
suppressMessages(library(naniar))
suppressMessages(library(mice))
suppressMessages(library(haven)) # для открытия файлов .sov
suppressMessages(library(sjlabelled)) # для работы с метками
suppressMessages(library("emmeans"))
suppressMessages(library("ez"))
suppressMessages(library("writexl"))
suppressMessages(library("ggstatsplot")) # для таблиц сопряженности
suppressMessages(library("forcats")) #для сортировки geom_bar()
suppressMessages(library("factoextra")) #для визуализации факторного анализа
suppressMessages(library("FactoMineR")) #для визуализации факторного анализа
suppressMessages(library("reshape2")) #для визуализации факторного анализа
suppressMessages(library("ggforce")) #geom_mark_hull
suppressMessages(library("purrr")) #для выбора численных данных
suppressMessages(library("kableExtra")) #для красивых таблиц
suppressMessages(library("biosurvey")) # для определения мультимодальности
suppressMessages(library("stringr")) # работа со строками
suppressMessages(library("fpc")) # dbscan

main_color <- "chartreuse"
color_1 <- "deepskyblue" 
color_2 <- "coral"
color_3 <- "blue"

# main_color <- "gray"
# color_1 <- "gray10"
# color_2 <- "gray20"

alpha <- 0.5
theme_set(theme_bw()) #тема по умолчанию
ggplot <- function(...) ggplot2::ggplot(...) 
# + scale_fill_manual(values = c(color_1, color_2, color_3)) + scale_color_manual(values = c(color_1, color_2, color_3))


create_tabs <- function(list, names=NULL) {
  if (is.null(names)) {
    for (p in list) {
      cat("####", p$labels$tabname, "\n\n")
      print(p)
      cat("\n\n")
    }
  } else {
    for (p in seq_along(list)) {
      cat("####", names[p], "\n\n")
      print(list[[p]])
      cat("\n\n")
    }
  }
}



clear_dir <- function(list, path) {
  for (p in list) {
    suppressMessages(file.remove(paste0(path, p)))
  }
}


check_normal_distribution <- function(result, alpha_level=0.05) {
  if (result$p.value >= alpha_level) {
    cat("Проверка на нормальность для:", result$data.name, "пройдена\r\n")
  } else {
    cat("Проверка на нормальность для:", result$data.name, "не пройдена\r\n")
  } 
}


apa_post_hoc <- function(post_hoc, p_level=0.05) {
  for (i in 1:nrow(post_hoc)) {
    if (post_hoc$p.value[i] <= 0.05) {
      cat(paste0(post_hoc$contrast[i], ": ", "[t(", post_hoc$df[i], ") = ", round(post_hoc$t.ratio[i], 2), ", p<=", p_level, "]", "\r\n"))
    }
  }
}


corFn <- function(data, mapping, ...) {
  p <- ggally_cor(data = data, mapping = mapping, method = "spearman", digits = 2, title = "corr", size = 4)
  return (p)
}


scatterFn <- function(data, mapping, method = "lm", ...) {
  p <- ggplot(data = data, mapping = mapping) +
    geom_point(fill = "#696969", size = 1, alpha=alpha) + 
  geom_smooth(method = method, size = 0.5, color = "blue", alpha=0.3, formula = y ~ x, ...)
  return (p)
}


diagFn <- function(data, mapping, ...) {
  p <- ggplot(data = data, mapping = mapping) +
    geom_density(alpha=.5, color="black", aes(fill = ma_level))
  return (p)
}


get_outliers <- function(data, var, coef=1.5) {
  outliers <- boxplot.stats(var, coef = coef)$out
  data[which(var %in% outliers),]
}


save_ggplot <- function(list, path="./img/", ext=".jpg", isNumbered=F) {
  for (p in list) {
    if (isNumbered) {
      suppressMessages(ggsave(paste0(path, paste0(length(dir(path)) + 1,"_", p$labels$filename), ext), p, width = 1920, height = 1080, units = "px", dpi = 150))
    } else {
      suppressMessages(ggsave(paste0(path, p$labels$filename, ext), p, width = 1920, height = 1080, units = "px", dpi = 150))
    }
  }
}


draw_plots_ordinal <- function(data, var, group = NULL, group_lab = NULL, x_lab = NULL, title = NULL, legend_title = NULL, filename = NULL, alpha = 0.5, angle = 0, hjust = 1, flip = F) {
  if (!is.null(title)) {
    filename <- title
  }
  
  p1 <- ggplot(data, aes({{var}})) + 
    geom_bar(bg = main_color, alpha = alpha) + 
    labs(title = ifelse(!is.null(title), title, ""), x = x_lab, y = "Частота", tabname="Barplot 1", filename = paste0(filename, ", Barplot 1")) + 
    theme(axis.text.x = element_text(angle = angle, hjust=hjust))
  
  if (flip) {
    p1 <- p1 + coord_flip()
  }
  
  if (!is.null(group)) {
    group_lab <- paste0(" ~ ", group_lab)
    
    p2 <- ggplot(data, aes(var, fill = {{group}})) + 
      geom_bar(position="dodge", alpha = alpha) + 
      labs(title = ifelse(!is.null(title), paste0(title, group_lab), ""), x = x_lab, y = "Частота", 
           tabname="Barplot 2", filename = paste0(filename, group_lab, ", Barplot 2")) + 
      guides(fill = guide_legend(legend_title)) + 
      theme(axis.text.x = element_text(angle = angle, hjust=hjust))
    
    p3 <- ggplot(data, aes(var, fill = {{group}})) + 
      geom_bar(position = "stack", alpha = alpha) + 
      labs(title = ifelse(!is.null(title), paste0(title, group_lab), ""), x = x_lab, y = "Частота", 
           tabname="Barplot 3", filename = paste0(filename, group_lab, ", Barplot 3")) + 
      guides(fill = guide_legend(legend_title)) + 
      theme(axis.text.x = element_text(angle = angle, hjust=hjust))
    
    p4 <- ggplot(data, aes({{var}}, fill={{var}})) + 
      geom_bar(alpha = alpha) + 
      labs(title=ifelse(!is.null(title), paste0(title, group_lab), ""), x = x_lab, y = "Частота",
           tabname="Barplot 4", filename = paste0(filename, group_lab, ", Barplot 4")) +
      facet_grid(. ~ faculty) +
      guides(fill = guide_legend(legend_title)) +
      theme(axis.text.x = element_text(angle = angle, hjust=hjust))
    
      if (flip) {
        p2 <- p2 + coord_flip()
        p3 <- p3 + coord_flip()
        p4 <- p4 + coord_flip()
      }
    
    return(list(p1, p2, p3, p4))
  }
  
  return(list(p1))
}



draw_plots_continuous <- function(data, var, group = NULL, group_lab = NULL, x_lab = NULL, title = NULL, legend_title = NULL, filename = NULL, binwidth = NULL, bins = NULL, alpha = 0.5, angle = 0) {
  
  if (!is.null(title)) {
    filename <- title
  }
  
  p1 <- ggplot(data, aes({{var}})) + 
    geom_histogram(binwidth = binwidth, bins = bins, fill = main_color, alpha = alpha) + 
    labs(title = ifelse(!is.null(title), title, ""), filename = paste0(filename, ", Histogram"), x = x_lab, y = "Частота", tabname = "Histogram") + 
    theme(axis.text.x = element_text(angle = angle))
  p2 <- ggplot(data, aes({{var}})) + 
    geom_density(fill = main_color, alpha = alpha) + 
    labs(title = ifelse(!is.null(title), title, ""), filename = paste0(filename, ", Density"), x = x_lab, y = "Плотность", tabname = "Density") + 
    theme(axis.text.x = element_text(angle = angle))
  
  p3 <- ggplot(data, aes({{var}})) + 
    geom_boxplot(fill = main_color, alpha = alpha) + 
    labs(title = ifelse(!is.null(title), title, ""), filename = paste0(filename, ", Boxplot"), x = x_lab, tabname = "Boxplot") + 
    coord_flip() + 
    theme(axis.text.x = element_text(angle = angle))
  
  
  if (!is.null(group)) {
    group_lab <- paste0(" ~ ", group_lab)
    
    p4 <- ggplot(data, aes({{var}}, fill={{group}})) + 
      geom_histogram(binwidth=binwidth, bins = bins,  alpha=alpha, position = "identity") + 
      labs(title=ifelse(!is.null(title), paste0(title, group_lab), ""), 
           filename = paste0(filename, group_lab, ", Histogram"), x = x_lab, y = "Частота", tabname=paste0("Histogram", group_lab)) + 
       facet_wrap(. ~ faculty, ncol = 6, strip.position = "bottom") +
       guides(fill = "none") +
       theme(axis.text.x = element_text(angle = angle))

    p5 <- ggplot(data, aes({{var}}, fill={{group}})) + 
      geom_density(alpha=alpha) + 
      labs(title=ifelse(!is.null(title), paste0(title, group_lab), ""), 
           filename = paste(title, group_lab, "Density"), x = x_lab, y = "Плотность", tabname=paste0("Density", group_lab)) +
      facet_wrap(. ~ faculty, ncol = 6, strip.position = "bottom") +
      guides(fill = "none") +
      theme(axis.text.x = element_text(angle = angle))
    
    p6 <- ggplot(data, aes({{group}}, {{var}}, fill={{group}})) + 
      geom_boxplot(alpha=alpha) + 
      labs(title=ifelse(!is.null(title), paste0(title, group_lab), ""), 
           filename = paste(title, group_lab, "Boxplot"), y = x_lab, tabname=paste0("Boxplot", group_lab)) + 
      guides(fill="none") +
      theme(axis.text.x = element_text(angle = angle))
    
    return(list(p1, p2, p3, p4, p5, p6))
  }
  
  return(list(p1, p2, p3))
}


change_names <- function(df, from, to, prefix) {
  names(df)[from:to] <- paste0(prefix, 1:length(names(df)[from:to]))
  return(df)
}


imputeNAs <- function(x, value) {
  x[is.na(x)] <- value
  return(x)
}


draw_plots_continuous_by_cluster <- function(data, var, group = NULL, group_lab = NULL, x_lab = NULL, title = NULL, legend_title = NULL, filename = NULL, binwidth = NULL, bins = NULL, alpha = 0.5, angle = 0) {
  
  if (!is.null(title)) {
    filename <- title
  }
  
  p1 <- ggplot(data, aes({{var}})) + 
    geom_histogram(binwidth = binwidth, bins = bins, fill = main_color, alpha = alpha) + 
    labs(title = ifelse(!is.null(title), title, ""), filename = paste0(filename, ", Histogram"), x = x_lab, y = "Частота", tabname = "Histogram") + 
    theme(axis.text.x = element_text(angle = angle))
  p2 <- ggplot(data, aes({{var}})) + 
    geom_density(fill = main_color, alpha = alpha) + 
    labs(title = ifelse(!is.null(title), title, ""), filename = paste0(filename, ", Density"), x = x_lab, y = "Плотность", tabname = "Density") + 
    theme(axis.text.x = element_text(angle = angle))
  
  p3 <- ggplot(data, aes({{var}})) + 
    geom_boxplot(fill = main_color, alpha = alpha) + 
    labs(title = ifelse(!is.null(title), title, ""), filename = paste0(filename, ", Boxplot"), x = x_lab, tabname = "Boxplot") + 
    coord_flip() + 
    theme(axis.text.x = element_text(angle = angle))
  
  
  if (!is.null(group)) {
    group_lab <- paste0(" ~ ", group_lab)
    
    p4 <- ggplot(data, aes({{var}}, fill={{group}})) + 
      geom_histogram(binwidth=binwidth, bins = bins,  alpha=alpha, position = "identity") + 
      labs(title=ifelse(!is.null(title), paste0(title, group_lab), ""), 
           filename = paste0(filename, group_lab, ", Histogram"), x = x_lab, y = "Частота", tabname=paste0("Histogram", group_lab)) + 
      facet_wrap(. ~ AST_cluster, ncol = 6, strip.position = "bottom") +
      guides(fill = "none") +
      theme(axis.text.x = element_text(angle = angle))
    
    p5 <- ggplot(data, aes({{var}}, fill={{group}})) + 
      geom_density(alpha=alpha) + 
      labs(title=ifelse(!is.null(title), paste0(title, group_lab), ""), 
           filename = paste(title, group_lab, "Density"), x = x_lab, y = "Плотность", tabname=paste0("Density", group_lab)) +
      facet_wrap(. ~ AST_cluster, ncol = 6, strip.position = "bottom") +
      guides(fill = "none") +
      theme(axis.text.x = element_text(angle = angle))
    
    p6 <- ggplot(data, aes({{group}}, {{var}}, fill={{group}})) + 
      geom_boxplot(alpha=alpha) + 
      labs(title=ifelse(!is.null(title), paste0(title, group_lab), ""), 
           filename = paste(title, group_lab, "Boxplot"), y = x_lab, tabname=paste0("Boxplot", group_lab)) + 
      guides(fill="none") +
      theme(axis.text.x = element_text(angle = angle))
    
    return(list(p1, p2, p3, p4, p5, p6))
  }
  
  return(list(p1, p2, p3))
}


draw_corrplots <- function(df, method, tl.cex = 1, number.cex = 1) {
  corr_matrix <- cor(df, method = method)
  
  corr_col <- colorRampPalette(c("deepskyblue2", "white", "darkorange"))
  
  cat("#### Matrix \n\n")
  corrplot(corr_matrix, method="circle", col=corr_col(200), order = "original", type="full", tl.col = "black", tl.cex = tl.cex, tl.srt = 45)
  cat("\n\n")
  
  cat("#### Number \n\n")
  corrplot(corr_matrix, method="number", col=corr_col(200), order = "original", type="full", tl.col = "black", tl.cex = tl.cex, number.cex = number.cex, tl.srt = 45)
  cat("\n\n")
  
  testRes <- cor.mtest(df, conf.level = 0.95)
  
  cat("#### Significance\n\n")
  corrplot(corr_matrix, p.mat = testRes$p, method = 'color', col=corr_col(200), type = 'full', tl.col = "black", sig.level = c(0.001, 0.01, 0.05), pch.cex = 1.5, insig = 'label_sig', pch.col = 'grey20', order = 'original', tl.cex = tl.cex, tl.srt = 45)
  cat("\n\n")
}