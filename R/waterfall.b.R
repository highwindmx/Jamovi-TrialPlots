
# This file is a generated template, your changes will not be overwritten

waterfallClass <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
    "waterfallClass",
    inherit = waterfallBase,
    private = list(
        .run = function() {

            # self$results$text$setContent(results)
            # # `self$data` contains the data
            # # `self$options` contains the options
            # # `self$results` contains the results object (to populate)
            
            # 总体计数与重复值查询
            if (is.null(self$options$pid)) {
                self$results$res_text$setContent("请选择参与者ID")
            } else {
                pid_data <- self$data[[self$options$pid]]
                pid_dup <- any(duplicated(pid_data))
                pid_uni_num <- length(unique(pid_data))
                pid_uni_info1 <- paste0('下方绘图共计 ',pid_uni_num,' 个参与者')
                pid_uni_info2 <- paste0('下方绘图共计 ',pid_uni_num,' 个参与者，发现重复参与者：', unique(pid_data[duplicated(pid_data)]))
                if (pid_dup) {
                    self$results$res_text$setContent(pid_uni_info2)
                } else {
                    self$results$res_text$setContent(pid_uni_info1)
                }
            }  
            # 制作绘图数据

            participants <- self$data[[self$options$pid]]
            lesion_changes <- self$data[[self$options$bch]]
            bar_group <- if (!is.null(self$options$barGP)) self$data[[self$options$barGP]] else rep(NA, length(participants))
            bor_marker <- if (!is.null(self$options$borM)) self$data[[self$options$borM]] else rep(NA, length(participants))
            cfm_marker <- if (!is.null(self$options$confM)) self$data[[self$options$confM]] else rep(NA, length(participants))
            ogt_marker <- if (!is.null(self$options$ongM)) self$data[[self$options$ongM]] else rep(NA, length(participants))
            plotData <- data.frame(pids=participants, sodcg=lesion_changes, bargp=bar_group, bormk=bor_marker, cfmmk=cfm_marker, ogtmk=ogt_marker)
            for (item in self$options$tilGP) {
                plotData <- cbind(plotData,self$data[item])
            }
            # self$results$res_debug$setContent(plotData) # debug绘图数据
            image <- self$results$res_plot # 绘图数据传导
            image$setState(plotData)       # 绘图数据传导

            # 表格显示分组计数
            result_table <- self$results$res_table
            for (grp in self$options$tilGP) {
                tab_df <- table(self$data[grp])
                for (col_name in names(tab_df)) {
                    #self$results$res_debug$setContent(tab_df[[col_name]])
                    result_table$addRow(
                        rowKey=paste(grp,col_name), 
                        values=list(个数=tab_df[[col_name]])
                    ) 
                }
            }
        },
        .plot = function(image, ...) { 
            plotData <- image$state        # 绘图数据传导
            if (is.null(plotData)) {                
            } else {
                grp_count <- table(plotData$bargp) # 图例样本量计算
                if (!is.null(self$options$barGP)) {
                    new_labels <- paste0(names(grp_count), " (N=", grp_count, ")")
                } else {
                    new_labels <- paste0(names(grp_count), " N=", length(plotData$pids))
                }
                
                # self$results$res_debug$setContent(new_labels)
                # y_axis_ratio = 1.35
                # if (!is.null(self$options$bch)) {
                #     ulim <- ifelse(max(plotData$sodcg * y_axis_ratio)>=100,100,max(plotData$sodcg * y_axis_ratio))
                #     llim <- ifelse(min(plotData$sodcg * y_axis_ratio)<=-100,-100,min(plotData$sodcg * y_axis_ratio))
                # } else {
                #     ulim <- 100
                #     llim <- -100
                # }
                
                plotBar <- ggplot(data = plotData, aes(x = reorder(pids,-sodcg), y = sodcg, fill = bargp)) + 
                        geom_bar(stat = "identity", width = 0.8) + #以bar图形式展示，以后可以研究下geom_column
                        geom_hline(yintercept = -30, linetype = "dashed", color = "green", alpha = 0.3, size = 1) + # PR判断线
                        geom_hline(yintercept = 20, linetype = "dashed", color = "red", alpha = 0.3, size = 1) +    # PD判断线
                        geom_hline(yintercept = 0, color = "black", size = 0.5) +                                   # 基线
                        geom_text(aes(x = reorder(pids,-sodcg),  #BOR文字标记
                                      y = ifelse(sodcg >= 0, sodcg + 1.0, sodcg - 1.0),
                                      vjust = ifelse(sodcg >= 0, -0.5, 1.5),
                                      label = bormk),
                                  size = 6) +
                        geom_text(aes(x = reorder(pids,-sodcg), y = 0, label = cfmmk),  vjust = -1, size = 6) +  #confirmed CR/PR文字标记
                        geom_text(aes(x = reorder(pids,-sodcg),  #on-going/off-going文字标记
                                      y = ifelse(sodcg >= 0, sodcg + 1.0, sodcg - 1.0),
                                      vjust = ifelse(sodcg >= 0, 
                                                ifelse(!is.na(bormk), -1.5, -0.5), 
                                                ifelse(!is.na(bormk), 2.0, 1.0)),
                                      label = ogtmk), 
                                  size = 8) + 
                        scale_y_continuous( #Y轴修饰
                            #limits = c(llim, ulim), 
                            breaks = function(limits) {
                                # 基于limits生成合适的breaks
                                lower <- floor(limits[1] / 20) * 20
                                upper <- ceiling(limits[2] / 20) * 20
                                seq(lower, upper, by = 20)
                            }) +
                            # ,sec.axis = sec_axis( #右侧副Y轴修饰
                            # ~ . * 1,  # 相同比例
                            #     breaks = c(-30, 0, 20),  # 只显示关键阈值
                            # )) +
                        labs(title=paste0('瀑布图（按',self$options$barGP,'分组）'), x="试验参与者编号", y="靶病灶较基线最佳变化（%）") + #标签
                        theme_classic() + #极简，白色背景
                        theme(plot.title = element_text(size = 20, hjust = 0.5, margin = margin(b = 20)),  #标题居中
                              axis.text.x = element_text(size = 14, angle = 45, hjust = 1, vjust = 1),  #X轴文字标记
                              axis.text.y = element_text(size = 14),
                              axis.title.x = element_text(size = 16),
                              axis.title.y = element_text(size = 16),
                              # legend.position = c(1, 1),  # 右上角位置（x, y坐标）
                              # legend.justification = c(1, 1),   # 图例的锚点在右上角
                              # legend.box.background = element_rect(  # 图例外边框
                              #   color = "grey80",
                              #   fill = "white",
                              #   linewidth = 0.5
                              # ),
                              # legend.box.margin = margin(1, 1, 1, 1),  # 边框内边距
                              legend.key.height = unit(2, "lines"),
                              legend.key.width = unit(2, "lines"),
                              legend.title = element_text(size = 20, face = "bold"),  # 图例标题加粗
                              legend.text = element_text(size = 18)
                        ) +
                        scale_fill_discrete(name = self$options$barGP, labels = new_labels) # 控制在最多2行显示图例, 含样本量计算的图例信息更新
                                            #guide = guide_legend(nrow = 6)

                if (!is.null(self$options$ongM)) { # 手工标记在组状态图例
                    plotBar <- plotBar + annotate("text", x = -Inf, y = -Inf, label = self$options$ongS, hjust = -0.1, vjust = -2, size = 5)
                }
                if (!is.null(self$options$confM)) { # 手工标记确认CR/PR图例
                    plotBar <- plotBar + annotate("text", x = -Inf, y = -Inf, label = self$options$confS, hjust = -0.1, vjust = -4, size = 5)
                }    

                # 绘制下方色块图
                if (!is.null(self$options$tilGP)) {
                    plotBar <- plotBar + # 上方bar图形的预处理
                                theme(
                                    axis.text.x = element_blank(),      # 隐藏x轴标签
                                    axis.title.x = element_blank(),     # 隐藏x轴标题
                                    axis.ticks.x = element_blank(),     # 隐藏x轴刻度
                                    plot.margin = margin(b = 0)       # 底部无外边距
                                    # legend.position = "none"
                                )
                    features <- self$options$tilGP     
                    plotTile <- ggplot(data = plotData) + 
                                lapply(seq_along(features), function(i) {
                                    geom_tile(aes(x = reorder(pids,-sodcg), y = features[i], fill = .data[[features[i]]]), width = 0.9, height = 0.9) #.data[[]]的写法别问我，我也是问的deepseek
                                })
                    plotTile <- plotTile +
                                 # scale_color_brewer(palette = "Set2", name = "特征") +
                                 theme_minimal() +
                                 theme(
                                        axis.text.x = element_text(size = 14, angle = 45, hjust = 1, vjust = 1),
                                        axis.text.y = element_text(size = 14, face = "bold"),
                                        axis.title.x = element_text(size = 16, margin = margin(t = 10)),
                                        axis.title.y = element_blank(),
                                        plot.margin = margin(t = 0),        # 顶部无外边距
                                        legend.position = "bottom",
                                        legend.title = element_blank(),  # 图例标题加粗
                                        legend.text = element_text(size = 18),
                                        panel.grid = element_blank()
                                 ) +
                                 coord_fixed(ratio = 1) +
                                 labs(x = "试验参与者编号") +
                                 scale_fill_discrete() #guide = guide_legend(nrow = 3)

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
                    plotBar <- pick_theme_color(self$options$barThm, plotBar) 
                    plotTile <- pick_theme_color(self$options$tilThm, plotTile) 
                    # 拼合两图
                    tile_height = ceiling(length(features)/2)/10
                    plotMe <- plotBar / plotTile + 
                        plot_layout(axes = "collect_x") #heights = c(1-tile_height, tile_height),
                    print(plotMe)
                } else {
                    print(plotBar)
                }
                TRUE
            }
        }
    )
)

# 上面图的图例没了怎么办
# 下面图的图例能不能分组