
# This file is a generated template, your changes will not be overwritten

samplesizeClass <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
    "samplesizeClass",
    inherit = samplesizeBase,
    private = list(
        .run = function() {

            # `self$data` contains the data
            # `self$options` contains the options
            # `self$results` contains the results object (to populate)
            study_length <- self$options$enroll+self$options$followup
            design_ph <- gs_design_ahr( #fixed_design_ahr
                alpha = self$options$alpha/2,           # 单侧检验
                beta = 1-self$options$power,           # 10% II类错误（90%功效）
                info_frac = c(self$options$interm/100, 1),  # 信息比例
                analysis_time = study_length,  # 三次分析的时间点（月）
                enroll_rate = define_enroll_rate(       
                    duration = self$options$enroll,  # 入组期12个月，后续随访期
                    rate = self$options$permonth # 前12个月每月入组25人，之后停止入组
                    ),
                fail_rate = define_fail_rate(
                    duration = study_length,
                    fail_rate = log(2) / self$options$control,
                    hr = self$options$hazardratio,
                    dropout_rate = self$options$dropout/12
                    ),
                ratio = self$options$ratio
            )
            analysis_result <- design_ph$analysis[c("analysis", "time","n","event","info_frac","ahr")]
            result_table <- self$results$res_table
            result_table$addColumn(name = "time", title = "时间（月）", type = 'number')
            result_table$addColumn(name = "n", title = "样本量", type = 'number')
            result_table$addColumn(name = "event", title = "事件数", type = 'number')
            result_table$addColumn(name = "info_frac", title = "事件百分比", type = 'number')
            result_table$addColumn(name = "ahr", title = "风险比（HR）", type = 'number')
            for (i in seq_len(nrow(analysis_result))) {
                result_table$addRow(
                    rowKey = analysis_result$analysis[[i]], 
                    values = list(
                        var = analysis_result$analysis[[i]],
                        time = analysis_result$time[[i]],
                        n = analysis_result$n[[i]],
                        event = analysis_result$event[[i]],
                        info_frac = analysis_result$info_frac[[i]]*100,
                        ahr = analysis_result$ahr[[i]]
                    )
                )
            }

            # for (grp in self$options$tilGP) {
            #     tab_df <- table(self$data[grp])
            #     for (col_name in names(tab_df)) {
            #         #self$results$res_debug$setContent(tab_df[[col_name]])
            #         result_table$addRow(
            #             rowKey=paste(grp,col_name), 
            #             values=list(个数=tab_df[[col_name]])
            #         ) 
            #     }
            # }
        }
    )
)