
// This file is an automatically generated and should not be edited

'use strict';

const options = [{"name":"data","type":"Data"},{"name":"pid","title":"患者/参与者ID","suggested":["id","nominal"],"permitted":["numeric","factor","id"],"type":"Variable"},{"name":"bch","title":"病灶SOD最佳变化（%）","suggested":["continuous"],"permitted":["numeric"],"type":"Variable"},{"name":"barGP","title":"条形图中分组","suggested":["nominal"],"type":"Variable"},{"name":"borM","title":"最佳疗评（BOR）标记","suggested":["nominal"],"type":"Variable"},{"name":"confM","title":"确认的CR/PR标记","suggested":["nominal"],"type":"Variable"},{"name":"ongM","title":"是否在治标记","suggested":["nominal"],"type":"Variable"},{"name":"tilGP","title":"矩阵图中分组","suggested":["ordinal","nominal"],"type":"Variables"},{"name":"confS","title":"确认的CR/PR图例","type":"String","default":"C 确认的CR/PR"},{"name":"ongS","title":"在治标记图例","type":"String","default":"→ 治疗中，× 治疗终止"},{"name":"barThm","title":"配色风格1","type":"List","options":["AAAS","JAMA","JCO","Lancet","NEJM","Nature","UCSF","TRON","Simpsons","Accent","Dark2","Paired","Pastel1","Pastel2","Set1","Set2","Set3"],"default":"Nature"},{"name":"tilThm","title":"配色风格2","type":"List","options":["AAAS","JAMA","JCO","Lancet","NEJM","Nature","UCSF","TRON","Simpsons","Accent","Dark2","Paired","Pastel1","Pastel2","Set1","Set2","Set3"],"default":"AAAS"}];

const view = function() {
    
    this.handlers = { }

    View.extend({
        jus: "3.0",

        events: [

	]

    }).call(this);
}

view.layout = ui.extend({

    label: "Waterfall plot",
    jus: "3.0",
    type: "root",
    stage: 0, //0 - release, 1 - development, 2 - proposed
    controls: [
		{
			type: DefaultControls.VariableSupplier,
			typeName: 'VariableSupplier',
			persistentItems: false,
			stretchFactor: 1,
			controls: [
				{
					type: DefaultControls.TargetLayoutBox,
					typeName: 'TargetLayoutBox',
					label: "患者/参与者ID",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "pid",
							maxItemCount: 1,
							isTarget: true
						}
					]
				},
				{
					type: DefaultControls.TargetLayoutBox,
					typeName: 'TargetLayoutBox',
					label: "病灶SOD最佳变化（%）",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "bch",
							maxItemCount: 1,
							isTarget: true
						}
					]
				},
				{
					type: DefaultControls.TargetLayoutBox,
					typeName: 'TargetLayoutBox',
					label: "条形图中分组",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "barGP",
							maxItemCount: 1,
							isTarget: true
						}
					]
				},
				{
					type: DefaultControls.TargetLayoutBox,
					typeName: 'TargetLayoutBox',
					label: "最佳疗评（BOR）标记",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "borM",
							maxItemCount: 1,
							isTarget: true
						}
					]
				},
				{
					type: DefaultControls.TargetLayoutBox,
					typeName: 'TargetLayoutBox',
					label: "确认的CR/PR标记",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "confM",
							maxItemCount: 1,
							isTarget: true
						}
					]
				},
				{
					type: DefaultControls.TargetLayoutBox,
					typeName: 'TargetLayoutBox',
					label: "是否在治标记",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "ongM",
							maxItemCount: 1,
							isTarget: true
						}
					]
				},
				{
					type: DefaultControls.TargetLayoutBox,
					typeName: 'TargetLayoutBox',
					label: "矩阵图中分组",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "tilGP",
							isTarget: true
						}
					]
				}
			]
		},
		{
			type: DefaultControls.LayoutBox,
			typeName: 'LayoutBox',
			margin: "large",
			controls: [
				{
					type: DefaultControls.TextBox,
					typeName: 'TextBox',
					name: "confS",
					format: FormatDef.string
				}
			]
		},
		{
			type: DefaultControls.LayoutBox,
			typeName: 'LayoutBox',
			margin: "large",
			controls: [
				{
					type: DefaultControls.TextBox,
					typeName: 'TextBox',
					name: "ongS",
					format: FormatDef.string
				}
			]
		},
		{
			type: DefaultControls.LayoutBox,
			typeName: 'LayoutBox',
			margin: "large",
			controls: [
				{
					type: DefaultControls.ComboBox,
					typeName: 'ComboBox',
					name: "barThm"
				}
			]
		},
		{
			type: DefaultControls.LayoutBox,
			typeName: 'LayoutBox',
			margin: "large",
			controls: [
				{
					type: DefaultControls.ComboBox,
					typeName: 'ComboBox',
					name: "tilThm"
				}
			]
		}
	]
});

module.exports = { view : view, options: options };
