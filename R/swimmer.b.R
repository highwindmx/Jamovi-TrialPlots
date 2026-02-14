
# This file is a generated template, your changes will not be overwritten

swimmerClass <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
    "swimmerClass",
    inherit = swimmerBase,
    private = list(
        .run = function() {

            # `self$data` contains the data
            # `self$options` contains the options
            # `self$results` contains the results object (to populate)
            if (!is.null(self$options$pid)) {
                patient_ids <- self$data[[self$options$pid]]
            } else {
                patient_ids <- NA
            }
            if (!is.null(self$options$timeS)) {
                date_seriers <- as.Date(self$data[[self$options$timeS]])
                # self$results$text$setContent(time_seriers)
            }
            if (!is.null(self$options$lableM)) {
                label_markers <- self$data[[self$options$lableM]]
            }
            if (!is.null(self$options$statusM)) {
                status_markers <- self$data[[self$options$statusM]]
            }
            if (!is.null(self$options$colorG)) {
                color_groups <- self$data[[self$options$colorG]]
            } else {
                color_groups <- rep(NA, length(patient_ids))
            }
            
            inputdata <- data.frame(pids = patient_ids, dates = date_seriers, labelmk = label_markers, statusmk = status_markers, colorgp = color_groups)
            inputdata_list <- split(inputdata, inputdata$pids)
            result_list <- lapply(inputdata_list, function(x) {
                x$min_date <- min(x$dates)
                x$days_from_min <- as.numeric(x$dates - x$min_date)
                x$min_date <- NULL 
                return(x)
            })
            newdata <- do.call(rbind, result_list)
            image <- self$results$res_plot # 绘图数据传导
            image$setState(newdata)       # 绘图数据传导
        },
        .plot = function(image, ...) { 
            plotData <- image$state        # 绘图数据传导
            if (is.null(plotData)) {                
            } else {
                arm_data <- plotData[plotData$labelmk == "End", ]
                color_mapping <- c("on" = "black", "off" = "black")
                marker_mapping <- c("➔ 治疗中", "× 治疗结束")
                if (self$options$ynG == "否") {
                    plotSwim <- ggplot(data = arm_data, aes(x=reorder(pids, days_from_min), y=days_from_min))  +
                        geom_bar(aes(fill=colorgp), stat = 'identity',width = 0.8, alpha=0.9) +
                        geom_point(data = plotData, aes(shape=labelmk), size=4, alpha=0.7)
                } else {
                    plotSwim <- ggplot(data = arm_data, aes(x=interaction(reorder(pids, days_from_min), colorgp, sep=" | "), y=days_from_min)) +
                        geom_bar(aes(fill=colorgp), stat = 'identity',width = 0.8, alpha=0.9) +
                        geom_point(data = plotData, aes(shape=labelmk), size=4, alpha=0.7)
                }
                plotSwim <- plotSwim +
                    #geom_text(data = arm_data[arm_data$statusmk == "on", ], aes(label = "➤"), hjust = -0.2, size=5) +
                    #geom_text(data = arm_data[arm_data$statusmk == "off", ], aes(label = "×"), hjust = -0.3, size=6) + 
                    geom_text(aes(label = ifelse(statusmk == "on", "➔", "×"), color=colorgp), hjust = -0.2, size=5) + 
                    coord_flip() +
                    labs(title=paste0('泳道图（按',self$options$colorG,'分组）'), x="试验参与者编号", y=self$options$timeM) + #标签
                    theme_classic() + #极简，白色背景
                    theme(plot.title = element_text(size = 20, hjust = 0.5, margin = margin(b = 20)),  #标题居中
                        axis.text.x = element_text(size = 14),  #angle = 45, hjust = 1, vjust = 1),  #X轴文字标记
                        axis.text.y = element_text(size = 14),
                        axis.title.x = element_text(size = 16),
                        axis.title.y = element_text(size = 16),
                        #legend.key.height = unit(2, "lines"),
                        #legend.key.width = unit(2, "lines"),
                        legend.title = element_text(size = 12, face = "bold"),  # 图例标题加粗
                        legend.text = element_text(size = 12) 
                    )+
                    scale_y_continuous(
                        expand = expansion(add = c(1, 10))  # c(左侧加, 右侧加)具体数值
                    )+
                    scale_shape_manual(values = c("CR"=18,"PR"=17,"SD"=16,"PD"=15,"NE"=13))
     
                na_color <- "gray80"
                pick_theme_color <- function(operation, p) { # 选择不同ggsci配色主题的函数
                    switch(operation,
                            "JAMA" = p + scale_color_jama() + scale_fill_jama(na.value = ), # 空配色分组灰度显示
                            "NEJM" = p + scale_color_nejm() + scale_fill_nejm(na.value = na_color),
                            "Lancet" = p + scale_color_lancet() + scale_fill_lancet(na.value = na_color),
                            "Nature" = p + scale_color_npg() + scale_fill_npg(na.value = na_color),
                            "AAAS" = p + scale_color_aaas() + scale_fill_aaas(na.value = na_color),
                            "UCSF" = p + scale_color_ucscgb() + scale_fill_ucscgb(na.value = na_color),
                            "JCO" = p + scale_color_jco() + scale_fill_jco(na.value = na_color),
                            "TRON" = p + scale_color_tron() + scale_fill_tron(na.value = na_color),
                            "Simpsons" = p + scale_color_simpsons() + scale_fill_simpsons(na.value = na_color),
                            "Accent" = p + scale_fill_brewer(palette = "Accent", na.value = na_color),
                            "Dark2" = p + scale_fill_brewer(palette = "Dark2", na.value = na_color),
                            "Paired" = p + scale_fill_brewer(palette = "Paired", na.value = na_color),
                            "Pastel1" = p + scale_fill_brewer(palette = "Pastel1", na.value = na_color),
                            "Pastel2" = p + scale_fill_brewer(palette = "Pastel2", na.value = na_color),
                            "Set1" = p + scale_fill_brewer(palette = "Set1", na.value = na_color),
                            "Set2" = p + scale_fill_brewer(palette = "Set2", na.value = na_color),
                            "Set3" = p + scale_fill_brewer(palette = "Set3", na.value = na_color),
                            stop("未知操作类型")
                    )
                }
                # 选择不同ggsci配色
                y_labels <- ggplot_build(plotSwim)$layout$panel_params[[1]]$y$get_labels()
                self$results$text$setContent(rev(y_labels)) # 输出排序的pid，方便手工配合Excel手工作图
                plotSwim <- pick_theme_color(self$options$linThm, plotSwim) 
                print(plotSwim)
                TRUE
            }
        }
    )    
)
