
# This file is a generated template, your changes will not be overwritten

AEplotClass <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
    "AEplotClass",
    inherit = AEplotBase,
    private = list(
        .run = function() {

            # `self$data` contains the data
            # `self$options` contains the options
            # `self$results` contains the results object (to populate)
        ae_term <- self$data[[self$options$aeTerm]]
        test_arm_all <- self$data[[self$options$testGA]]
        test_arm_g3 <- self$data[[self$options$testG3]]
        if (!is.null(self$options$controlGA)) {
            control_arm_all <- self$data[[self$options$controlGA]]
            control_arm_g3 <- self$data[[self$options$controlG3]]
            if(self$options$barShp == 'Outside') { #不同形式用不同的数据结构实现，outside使用堆叠图，inside使用图堆叠
                plotData <- rbind(
                        data.frame(ae=ae_term, freqM="试验组 - 3级及以上", freq=-test_arm_g3),
                        data.frame(ae=ae_term, freqM="试验组 - 1~2级", freq=-test_arm_all+test_arm_g3), 
                        data.frame(ae=ae_term, freqM="对照组 - 3级及以上", freq=control_arm_g3), 
                        data.frame(ae=ae_term, freqM="对照组 - 1~2级", freq=control_arm_all-control_arm_g3)   
                    )
                plotData$freqM <- factor(plotData$freqM, levels = c("对照组 - 3级及以上","对照组 - 1~2级","试验组 - 3级及以上","试验组 - 1~2级"))
                data_order <- data.frame(ae=ae_term, freqM="试验组 - 所有等级", freq=-test_arm_all)
                ae_order <- data_order$ae[order(-data_order$freq)]
                plotData$ae <- factor(plotData$ae, levels = ae_order)
            } else {
                plotData <- data.frame(ae=ae_term, testall=test_arm_all, testg3=test_arm_g3, ctrlall=control_arm_all, ctrlg3=control_arm_g3)
            }
        } else {
            if(self$options$barShp == 'Outside') {
                plotData <- rbind(  
                        data.frame(ae=ae_term, freqM="试验组 - 3级及以上", freq=test_arm_g3),                 
                        data.frame(ae=ae_term, freqM="试验组 - 1~2级", freq=test_arm_all-test_arm_g3)    
                    )
                plotData$freqM <- factor(plotData$freqM, levels = c("试验组 - 3级及以上","试验组 - 1~2级"))
                data_order <- data.frame(ae=ae_term, freqM="试验组 - 所有等级", freq=-test_arm_all)
                ae_order <- data_order$ae[order(-data_order$freq)]
                plotData$ae <- factor(plotData$ae, levels = ae_order)                
            } else {
                plotData <- data.frame(ae=ae_term, testall=test_arm_all, testg3=test_arm_g3)
            }
        }
        image <- self$results$res_plot # 绘图数据传导
        image$setState(plotData)       # 绘图数据传导
        },
        .plot = function(image, ...) { 
            plotData <- image$state        # 绘图数据传导
            #self$results$text$setContent(plotData)
            pick_theme_color <- function(operation) { # 选择不同ggsci配色主题的函数
                switch(operation,
                    "JAMA" = pal_jama()(2)[1], # 空配色分组灰度显示
                    "NEJM" = pal_nejm()(2)[1],
                    "Lancet" = pal_lancet()(2)[1],
                    "Nature" = pal_npg()(2)[1],
                    "AAAS" = pal_aaas()(2)[1],
                    "UCSF" = pal_ucscgb()(2)[1],
                    "JCO" = pal_jco()(2)[1],
                    "TRON" = pal_tron()(2)[1],
                    "Simpsons" = pal_simpsons()(2)[1],
                    #"Accent" = scale_fill_brewer(palette = "Accent", na.value = na_color),
                    #"Dark2" = scale_fill_brewer(palette = "Dark2", na.value = na_color),
                    #"Paired" = scale_fill_brewer(palette = "Paired", na.value = na_color),
                    #"Pastel1" = scale_fill_brewer(palette = "Pastel1", na.value = na_color),
                    #"Pastel2" = scale_fill_brewer(palette = "Pastel2", na.value = na_color),
                    #"Set1" = scale_fill_brewer(palette = "Set1", na.value = na_color),
                    #"Set2" = scale_fill_brewer(palette = "Set2", na.value = na_color),
                    #"Set3" = scale_fill_brewer(palette = "Set3", na.value = na_color),
                    stop("未知操作类型")
                )
            }
            color_fill <- pick_theme_color(self$options$barThm) 
            if (self$options$barShp == 'Outside') {
                if (!is.null(self$options$controlGA)) {
                    plotBar <- ggplot(data = plotData, aes(x = ae, y = freq, fill=freqM)) +
                        geom_bar(stat = 'identity', size = 0.8) +
                        scale_fill_manual(name="分组",
                            values = c(
                                "试验组 - 1~2级" = alpha(color_fill, 0.5),
                                "试验组 - 3级及以上" = alpha(color_fill, 0.9),
                                "对照组 - 1~2级" = alpha("grey60", 0.5),
                                "对照组 - 3级及以上" = alpha("grey60", 0.9)
                            ),
                            guide = guide_legend(reverse = TRUE)
                        )
                } else {
                    plotBar <- ggplot(data = plotData, aes(x = ae, y = freq, fill=freqM)) +
                        geom_bar(stat = 'identity', size = 0.8) +
                        scale_fill_manual(name="分组",
                            values = c(
                                "试验组 - 1~2级" = alpha(color_fill, 0.5),
                                "试验组 - 3级及以上" = alpha(color_fill, 0.9),
                            ),
                            guide = guide_legend(reverse = TRUE)
                        )
                }
            } else {
                text_size <- 5
                hgt_ajust <- 0.5
                if (!is.null(self$options$controlGA)) {
                    plotBar <- ggplot() +
                        geom_bar(data = plotData, aes(x = reorder(ae, testall), y = ctrlall, fill="对照组 - 所有等级"), stat = 'identity', alpha = 0.6, size = 0.8) +
                        geom_bar(data = plotData, aes(x = reorder(ae, testall), y = ctrlg3, fill="对照组 - 3级及以上"), stat = 'identity', alpha = 1, size = 0.8) +
                        geom_bar(data = plotData, aes(x = reorder(ae, testall), y = -testall, fill="试验组 - 所有等级"), stat = 'identity', alpha = 0.6, size = 0.8) +
                        geom_bar(data = plotData, aes(x = reorder(ae, testall), y = -testg3, fill="试验组 - 3级及以上"), stat = 'identity', alpha = 1, size = 0.8) +
                        scale_fill_manual(name="分组",
                            values = c(
                                "试验组 - 所有等级" = color_fill,
                                "试验组 - 3级及以上" = color_fill,
                                "对照组 - 所有等级" = "grey60",
                                "对照组 - 3级及以上" = "grey60"
                            ),
                            guide = guide_legend(reverse = TRUE)
                        )
                        if (self$options$shText == '是') {
                            plotBar <- plotBar +
                                geom_text(data = plotData, aes(x = reorder(ae, testall), y = ctrlall, label = ctrlall),  hjust = hgt_ajust+1, size = text_size) +
                                geom_text(data = plotData, aes(x = reorder(ae, testall), y = ctrlg3, label = ctrlg3),  hjust = hgt_ajust+1, size = text_size) +
                                geom_text(data = plotData, aes(x = reorder(ae, testall), y = -testall, label = testall),  hjust = -hgt_ajust, size = text_size) +
                                geom_text(data = plotData, aes(x = reorder(ae, testall), y = -testg3, label = testg3),  hjust = -hgt_ajust, size = text_size) 
                        }
                } else {
                    plotBar <- ggplot() +
                        geom_bar(data = plotData, aes(x = reorder(ae, testall), y = testall, fill="试验组 - 所有等级"), stat = 'identity', alpha = 0.6, size = 0.8) +
                        geom_bar(data = plotData, aes(x = reorder(ae, testall), y = testg3, fill="试验组 - 3级及以上"), stat = 'identity', alpha = 1, size = 0.8) +
                        scale_fill_manual(name="分组",
                            values = c(
                                "试验组 - 所有等级" = color_fill,
                                "试验组 - 3级及以上" = color_fill
                            ),
                            guide = guide_legend(reverse = TRUE)
                        )
                        if (self$options$shText == '是') {
                            plotBar <- plotBar +
                                geom_text(data = plotData, aes(x = reorder(ae, testall), y = testall, label = testall),  hjust = hgt_ajust+1, size = text_size) +
                                geom_text(data = plotData, aes(x = reorder(ae, testall), y = testg3, label = testg3),  hjust = hgt_ajust+1, size = text_size)
                        }
                }
            }
            plotBar <- plotBar +
                geom_hline(yintercept = 0, color = 'black', size = 0.5) +
                coord_flip() +
                scale_y_continuous( #Y轴修饰
                    labels = function(y) abs(y),
                    breaks = function(limits) {
                        # 基于limits生成合适的breaks
                        lower <- floor(limits[1] / 20) * 20
                        upper <- ceiling(limits[2] / 20) * 20
                        seq(lower, upper, by = 20)
                    }
                ) +
                labs(x="不良事件术语", y="不良事件发生百分化（%）") +
                theme_classic() +
                theme(
                    axis.text.x = element_text(size = 14, face = "bold"),
                    axis.text.y = element_text(size = 14, face = "bold"),
                    axis.title.x = element_text(size = 16),
                    axis.title.y = element_text(size = 16),
                    axis.line.y = element_blank(),
                    axis.ticks.y = element_blank(),
                    legend.position = "bottom",
                    legend.title = element_text(size = 16, face = "bold"),  # 图例标题加粗
                    legend.text = element_text(size = 16)
                )    
            print(plotBar)
            TRUE
        } 
    )
)
