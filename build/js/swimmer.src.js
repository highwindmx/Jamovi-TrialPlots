
// This file is an automatically generated and should not be edited

'use strict';

const options = [{"name":"data","type":"Data"},{"name":"pid","title":"患者/参与者ID","suggested":["id","nominal"],"permitted":["numeric","factor","id"],"type":"Variable"},{"name":"lableM","title":"标签组","suggested":["nominal"],"permitted":["factor"],"type":"Variable"},{"name":"timeS","title":"标签时间（%Y-%m-%d格式）","suggested":["nominal"],"permitted":["factor"],"type":"Variable"},{"name":"statusM","title":"状态组","suggested":["nominal"],"permitted":["factor"],"type":"Variable"},{"name":"colorG","title":"分色组","suggested":["nominal"],"permitted":["factor"],"type":"Variable"},{"name":"ynG","title":"是否分组排序","type":"List","options":["否","是"],"default":"否"},{"name":"timeM","title":"x轴标题","type":"String","default":"天数"},{"name":"linThm","title":"配色风格","type":"List","options":["AAAS","JAMA","JCO","Lancet","NEJM","Nature","UCSF","TRON","Simpsons","Accent","Dark2","Paired","Pastel1","Pastel2","Set1","Set2","Set3"],"default":"Nature"}];

const view = function() {
    
    this.handlers = { }

    View.extend({
        jus: "3.0",

        events: [

	]

    }).call(this);
}

view.layout = ui.extend({

    label: "Swimmer Plot",
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
					label: "标签组",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "lableM",
							maxItemCount: 1,
							isTarget: true
						}
					]
				},
				{
					type: DefaultControls.TargetLayoutBox,
					typeName: 'TargetLayoutBox',
					label: "标签时间（%Y-%m-%d格式）",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "timeS",
							maxItemCount: 1,
							isTarget: true
						}
					]
				},
				{
					type: DefaultControls.TargetLayoutBox,
					typeName: 'TargetLayoutBox',
					label: "状态组",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "statusM",
							maxItemCount: 1,
							isTarget: true
						}
					]
				},
				{
					type: DefaultControls.TargetLayoutBox,
					typeName: 'TargetLayoutBox',
					label: "分色组",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "colorG",
							maxItemCount: 1,
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
					type: DefaultControls.ComboBox,
					typeName: 'ComboBox',
					name: "ynG"
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
					name: "timeM",
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
					name: "linThm"
				}
			]
		}
	]
});

module.exports = { view : view, options: options };
