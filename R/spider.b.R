
# This file is a generated template, your changes will not be overwritten

spiderClass <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
    "spiderClass",
    inherit = spiderBase,
    private = list(
        .run = function() {

            # `self$data` contains the data
            # `self$options` contains the options
            # `self$results` contains the results object (to populate)
            if (!is.null(self$options$pid)) {
                patient_ids <- self$data[[self$options$pid]]
                # self$results$text$setContent(time_seriers)
            } else {
                patient_ids <- NA
            }
            if (!is.null(self$options$timeS)) {
                date_seriers <- as.Date(self$data[[self$options$timeS]])
                # self$results$text$setContent(time_seriers)
            }
            if (!is.null(self$options$lch)) {
                lesion_changes <- self$data[[self$options$lch]]
                # self$results$text$setContent(time_seriers)
            }
            if (!is.null(self$options$clrG)) {
                color_group <- self$data[[self$options$clrG]]
                # self$results$text$setContent(time_seriers)
            } else {
                color_group <- patient_ids
            }
            
            inputdata <- data.frame(pids = patient_ids, dates = date_seriers, lesionchgs = lesion_changes, colorgp = color_group)
            inputdata_list <- split(inputdata, inputdata$pids)
            result_list <- lapply(inputdata_list, function(x) {
                x$min_date <- min(x$dates)
                x$days_from_min <- as.numeric(x$dates - x$min_date)
                x$min_date <- NULL 
                return(x)
            })
            newdata <- do.call(rbind, result_list)
            #self$results$text$setContent(newdata)
            image <- self$results$res_plot # 绘图数据传导
            image$setState(newdata)       # 绘图数据传导
        },
        .plot = function(image, ...) { 
            plotData <- image$state        # 绘图数据传导
            if (is.null(plotData)) {                
            } else {
                last_points <- aggregate(days_from_min ~ pids, plotData, max)
                last_data <- merge(last_points, plotData, by = c("pids", "days_from_min"))
                plotLines <- ggplot(data=plotData, aes(x=days_from_min, y=lesionchgs, group=pids, color=colorgp)) +
                    geom_line(linewidth = 0.8, alpha = 0.7) +
                    geom_point(size = 2) +
                    geom_hline(yintercept = 0, color = "gray50", linewidth = 1) +
                    # 添加-30%线（部分响应阈值）
                    geom_hline(yintercept = -30, linetype = "dotted", color = "green", alpha = 0.7, linewidth = 1) +
                    # 添加+20%线（疾病进展阈值）
                    geom_hline(yintercept = 20, linetype = "dotted", color = "red", alpha = 0.7, linewidth = 1)
                if (self$options$ynM == "是") {
                   plotLines <- plotLines +
                    geom_text_repel(
                        data = last_data,
                        aes(label = pids),
                        size = 6,
                        color = "black",
                        fontface = "bold",
                        direction = "x",        # 主要水平方向
                        nudge_x = 2,          # 初始偏移
                        nudge_y = 2,          # 初始偏移
                        segment.size = 0.1,    # 连接线粗细
                        segment.color = "gray50",  # 连接线颜色
                        min.segment.length = 0.1,  # 最小连接线长度
                        box.padding = 0.5,     # 标签内边距
                        point.padding = 0.5    # 点与标签间距
                    ) 
                } 
                plotLines <- plotLines +    # 美化主题
                    theme_classic() +
                    theme(
                        axis.text.x = element_text(size = 14, face = "bold"), #, angle = 0, hjust = 1, vjust = 1
                        axis.text.y = element_text(size = 14, face = "bold"),
                        axis.title.x = element_text(size = 16, margin = margin(t = 10)),
                        axis.title.y = element_text(size = 16, margin = margin(r = 10)),
                        panel.grid.major = element_blank(), #element_line(color = "gray90"),
                        panel.grid.minor = element_blank(),
                        legend.position = "bottom",
                        legend.title = element_blank(), # element_text(size = 20, face = "bold"),  # 图例标题加粗
                        legend.text = element_text(size = 18)
                    ) +
                    # 坐标轴标签
                    labs(
                        title = "肿瘤大小变化蜘蛛图（Spider Plot）",
                        subtitle = "各例肿瘤随时间变化百分比轨迹",
                        x = self$options$timeM,
                        y = "肿瘤大小变化百分比（%）",
                    ) +
                    scale_x_continuous(
                        expand = expansion(add = c(1, 5))  # c(左侧加, 右侧加)具体数值
                    ) +
                    # y轴范围
                    scale_y_continuous(
                        breaks = function(limits) {
                            # 基于limits生成合适的breaks
                            lower <- floor(limits[1] / 20) * 20
                            upper <- ceiling(limits[2] / 20) * 20
                            seq(lower, upper, by = 20)
                        }
                    ) 
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
                plotLines <- pick_theme_color(self$options$linThm, plotLines) 
                print(plotLines)
                TRUE
            }
        }
    )
)
