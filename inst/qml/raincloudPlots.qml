//
// Copyright (C) 2013-2024 University of Amsterdam
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//

import QtQuick
import QtQuick.Layouts
import JASP
import JASP.Controls
import JASP.Widgets

Form
{
	columns: 1

	VariablesForm
	{
		AvailableVariablesList	{ name: "allVariablesListOne" }
		AssignedVariablesList
		{ 
			name: 					"dependentVariables"
			title: 					qsTr("Dependent Variables")
			suggestedColumns: 		["scale"]
		}
		AssignedVariablesList
		{
			name: 					"primaryFactor"
			title:					qsTr("Primary Factor")
			id: 					primaryFactor;
			suggestedColumns: 		["nominal", "ordinal"]
			singleVariable: 		true
		}
		AssignedVariablesList
		{
			name: 					"secondaryFactor"
			title:					qsTr("Secondary Factor")
			id: 					secondaryFactor
			suggestedColumns: 		["nominal", "ordinal"]
			singleVariable: 		true
		}

		AssignedVariablesList
		{
			name: 					"covariate"
			title:					qsTr("Covariate")
			id: 					covariate
			suggestedColumns: 		["nominal", "ordinal", "scale"]
			singleVariable: 		true
		}

		AssignedVariablesList
		{
			name: 					"subject"
			title:					qsTr("Subject")  // Extra spaces for alignment
			id: 					subject
			suggestedColumns: 		["nominal", "ordinal", "scale"]
			singleVariable: 		true
			enabled:				primaryFactor.count === 1
		}

	}  // End variables form

	Label{text: qsTr("Note: This module requires data in long format.")}

	Section
	{
		title: qsTr("General")
		columns: 3

		// Start top 2 rows

		Group
		{
			columns: 2

			Label{text: qsTr("Color palette")}
			ColorPalette{name: "colorPalette"; label: ""}

			Label{text: qsTr("Covariate palette"); enabled: covariate.count === 1}
			ColorPalette
			{
				name: "covariatePalette"
				label: "" // No qsTr() as this will stay the same across languages
				enabled: 	covariate.count === 1
				indexDefaultValue: 3
			}
		}

		CheckBox
		{
			name: 					"colorAnyway"
			label:					qsTr("Apply color palette")
			id: 					colorAnyway
			enabled: 				secondaryFactor.count === 0
			checked:				secondaryFactor.count === 0
			Layout.columnSpan: 		2
		}

		// End top 2 rows
		
		CheckBox
		{
			name: 					"horizontal"
			label:					qsTr("Horizontal plot")
			Layout.columnSpan: 3
		}

		CheckBox
		{
			name: "table"
			label: qsTr("Table with statistics")

			CheckBox
			{
				name: "tableBoxStatistics"
				label: qsTr("Box Statistics")
				checked: true
			}
		}

	}  // End section General



	Section
	{
		title: qsTr("Cloud Elements")
		columns: 3

		CheckBox{name: "showVio";   id: showVio;   text: qsTr("Show violin"); checked: true}
		CheckBox{name: "showBox";   id: showBox;   text: qsTr("Show box");    checked: true}
		CheckBox{name: "showPoint"; id: showPoint; text: qsTr("Show point");  checked: true}
		// Label{text: ""; Layout.columnSpan: 3}  // Placeholder


		Group  // Start group Violin
		{
			title: qsTr("Violin")
			columns: 2
			enabled: showVio.checked

				Label{text: qsTr("Nudge")}
				DoubleField
				{
					name:				"vioNudge"
					defaultValue:		(customSides.value === "") ? 0.09 : 0.24
					negativeValues:		true
				}

				Label
				{text: qsTr("Height")}
				DoubleField{name: "vioHeight"; defaultValue: 0.7}

				// Placeholder Start
				Label{text: "empty"; opacity: 0}
				DoubleField{name: "placeholder1"; opacity: 0}
				Label{text: "empty"; opacity: 0}
				DoubleField{name: "placeholder2"; opacity: 0}
				// Placeholder End

				Label{text: qsTr("Opacity")}
				PercentField
				{
					name:				"vioOpacity"
					fieldWidth: 		40
					defaultValue: 		(showVio.checked) ? 50 : 0
				}

				Label{text: qsTr("Outline")}
				DropDown
				{
					name: 	"vioOutline"
					indexDefaultValue: (showVio.checked) ? 0 : 2
					values:	[
							{label: qsTr("Color palette"), value: "colorPalette"},
							{label: qsTr("black"),         value: "black"},
							{label: qsTr("none"),          value: "none"},
							]
				}

				Label{text: qsTr("Outline width")}
				DoubleField{name: "vioOutlineWidth"; defaultValue: 1}

				// Placeholder Start
				Label{text: "empty"; opacity: 0}
				DoubleField{name: "placeholder3"; opacity: 0}
				// Placeholder End

				Label{text: qsTr("Smoothing")}
				PercentField
				{
					name:				"vioSmoothing"
					fieldWidth: 40
					defaultValue:		100
				}
		}  // End group Violin


		Group  // Start group Box
		{
			title: qsTr("Box")
			columns: 2
			enabled: showBox.checked

			Label{text: qsTr("Nudge")}
			DoubleField
			{
				name:				"boxNudge"
				defaultValue:		(customSides.value === "") ? 0 : 0.15
				negativeValues:		true
			}

			Label{text: qsTr("Width")}
			DoubleField
			{
				name:				"boxWidth"
				defaultValue:		(secondaryFactor.count === 0) ? 0.1 : 0.2
			}

			Label{text: qsTr("Padding")}
			DoubleField
			{
				name:				"boxPadding"
				defaultValue:		(secondaryFactor.count === 0) ? 0.1 : 0.2
			}

			// Placeholder Start
			Label{text: "empty"; opacity: 0}
			DoubleField{name: "placeholder4"; opacity: 0}
			// Placeholder End

			Label{text: qsTr("Opacity")}
			PercentField
			{
				name:		"boxOpacity"
				fieldWidth: 40
				defaultValue: (showBox.checked) ? 50 : 0
			}

			Label{text: qsTr("Outline")}
			DropDown
			{
				name: 	"boxOutline"
				indexDefaultValue: (showBox.checked) ? 0 : 2
				values:	[
						{label: qsTr("Color palette"), value: "colorPalette"},
					   	{label: qsTr("black"),         value: "black"},
					   	{label: qsTr("none"),          value: "none"},
					   	]
			}

			Label{text: qsTr("Outline width")}
			DoubleField{name: "boxOutlineWidth"; defaultValue: 1}
		}  // End group Box


		Group  // Start group Point
		{
			title: qsTr("Point")
			columns: 2
			enabled: showPoint.checked

			Label{text: qsTr("Nudge")}
			DoubleField
			{
				name:				"pointNudge"
				defaultValue:		(customSides.value === "") ? 0.15 : 0 // Is multiplied by -1 in the R script
				enabled:			(customSides.value === "") ? true : false
				negativeValues:		true
			}

			Label{text: qsTr("Spread")}
			DoubleField{name: "pointSpread"; defaultValue: 0.065}

			Label{text: qsTr("Size")}
			DoubleField{name: "pointSize"; defaultValue: 2.5}

			// Placeholder Start
			Label{text: "empty"; opacity: 0}
			DoubleField{name: "placeholder5"; opacity: 0}
			// Placeholder End

			Label	
			{text: qsTr("Opacity")}
			PercentField
			{
				name: "pointOpacity"
				fieldWidth: 40
				defaultValue: (showPoint.checked) ? 50 : 0
			}

			Label{text: "empty"; opacity: 0}
			DoubleField{name: "placeholder6"; opacity: 0}
			Label{text: "empty"; opacity: 0}
			DoubleField{name: "placeholder7"; opacity: 0}
			Label{text: "empty"; opacity: 0}
			DoubleField{name: "placeholder8"; opacity: 0}

			Label{text: qsTr("Jitter")}
			CheckBox{name:	"jitter"; id: jitter}
		}  // End group Point


		Label{text: ""; Layout.columnSpan: 3}  // Placeholder


		PercentField
		{
			name:					"lineOpacity"
			label:					qsTr("Subject lines opacity")
			enabled:				subject.count === 1
			fieldWidth: 			40
			defaultValue:			25
			Layout.columnSpan: 		2
		}
	}  // End section Cloud Elements



	Section
	{
		title: qsTr("Axes, Legend, Caption, Plot Size")
		columns: 3

		CheckBox
		{
			name: "customAxisLimits"
			label: qsTr("Custom limits for dependent variable axis:")
			Layout.columnSpan: 2
			childrenOnSameRow: true
			
			IntegerField{name: "lowerAxisLimit"; label: qsTr("from"); negativeValues: true; defaultValue: 0}
			IntegerField{name: "upperAxisLimit"; label: qsTr("to");   negativeValues: true; defaultValue: 1000}
		}  // End CheckBox customAxisLimits
		HelpButton
		{
			toolTip:	qsTr(
							"Limits may not be applied exactly.\n" +
							"For further fine-tuning of the axis, click the title of the plot\n" +
							"where it says the name of dependent variable.\n" +
							"Then select 'Edit Image' in the drop down menu and\n" +
							"then go to the headers 'x-axis' or 'y-axis'."
						)
		}

		CheckBox
		{name: "showCaption"; id: showCaption; label: qsTr("Show caption"); checked: true; Layout.columnSpan: 3}

		Group
		{
			title: qsTr("Plot Size")
			columns: 2

			IntegerField
			{
				name: "widthPlot"
				label: qsTr("Width")
				defaultValue: if (
					secondaryFactor.count === 1 ||
					covariate.count       === 1 ||
					(colorAnyway.checked && primaryFactor.count === 1) ||
					showCaption.checked
					) {
						675
					} else {
						550
					}
			}
			IntegerField
			{
				name: "heightPlot"
				label: qsTr("Height")
				defaultValue: (showCaption.checked) ? 550 : 450
			}
		}
	}  // End section Axes, Legend, Caption, Plot Size



	Section
	{
		title: qsTr("Advanced")
		columns: 3

		TextField
		{
			name:				"customSides"
			id:					customSides
			label:				qsTr("Custom orientation for each cloud:")
			placeholderText:	"Enter 'L' or 'R' for each cloud."
			Layout.columnSpan: 2
		}

		HelpButton
		{
			toolTip:	qsTr(
							"Per default, all violins are right of the boxes.\n" +
							"For each level of the Primary Factor,\n" +
							"specify 'L' or 'R' for per level of the Secondary Factor.\n" +
							"For example, with a 2 (Primary: A, B) x 2 (Secondary: i, ii) design,\n" +
							"enter 'LLRR' for flanking clouds (Ai, Aii, Bi, Bii).\n\n" +
							"If you enter too little or too many letters or anything but 'L' or 'R',\n"+
							"the orientation reverts to default (all 'R').\n" +
							"If there is any input, Point Nudge is set to 0."
						)
		}


		CheckBox
		{
			name: "mean"
			id: mean
			label: qsTr("Mean")
			Layout.columnSpan: 2

			RadioButtonGroup
			{
			  name: "meanPosition"
			  title: qsTr("Position")
			  RadioButton { value: "likeBox"; label: qsTr("like box"); checked: true }
			  RadioButton { value: "onAxisTicks"; label: qsTr("on axis ticks") }
			}

			DoubleField{name: "meanSize"; label: qsTr("Size"); defaultValue: 6}

			CheckBox
			{
				name: "meanLines"
				label: qsTr("Connect means with lines")
				enabled: mean.checked
				childrenOnSameRow: true

				DoubleField{name: "meanLinesWidth"; label: qsTr("Width"); defaultValue: 1}

				PercentField{name: "meanLinesOpacity"; label: qsTr("Opacity"); defaultValue: 50; fieldWidth: 40}
			}
		}  // End CheckBox Means


		HelpButton
		{
			toolTip:	qsTr(
							"If you position the mean 'like Box',\n"+
							"then the position depends on box nudge and width.\n" +
							"Thus, if you do not want to show the box, first set its nudge and width as desired."
						)
		}

		CheckBox
		{
			name: "meanInterval"
			label: qsTr("Interval around mean")
			enabled: mean.checked
			Layout.columnSpan: 3

			RadioButtonGroup
			{
				name: "meanIntervalOption"
			  	enabled: meanInterval.checked

				RadioButton
				{
					label: qsTr("± 1 standard deviation")
					value: "sd"
					checked: true
				}

				RadioButton
				{
					label: qsTr("Confidence interval")
					value: "ci"

					CheckBox
					{
						name: "meanCiAssumption"
						label: qsTr("Assume that all groups are independent of each other.")

						Group    // Start group ci settings
						{
							columns: 2

							Label {text: qsTr("Width")}
							CIField
							{
								name: "meanCiWidth"
							}

							Label {text: qsTr("Method")}
							DropDown
							{
								name: 	"meanCiMethod"
								id: ciMethod
								values:	[
										{label: qsTr("Normal model"), value: "normalModel"},
									   	{label: qsTr("T model"),      value: "oneSampleTTest"},
									   	{label: qsTr("Bootstrap"),    value: "bootstrap"},
									   	]
							}
						}  // End group ci settings

						Group  // Start group bootstrap settings
						{
							columns: 2

							Label {text: qsTr("Bootstrap samples"); enabled: ciMethod.value == "bootstrap"}
							IntegerField
							{
								name: "meanCiBootstrapSamples"
								enabled: ciMethod.value == "bootstrap"
								defaultValue: 1000
								min: 1
								max: 50000
							}

							CheckBox
							{
								name: "setSeed"
								id: setSeed
								enabled: ciMethod.value == "bootstrap"
								label: qsTr("Seed for reproducibility")
							}
							IntegerField
							{
								name: "seed"
								enabled: setSeed.checked
								defaultValue: 1
								negativeValues: true
							}

						}    // End group bootstrap settings


					}  // End ciAssumption CheckBox
				}  // End RadioButton Confidence interval

				RadioButton
				{
					label: qsTr("Custom interval limits")
					value: "custom"
					id: meanIntervalCustom
				}

			}  // End RadioButtonGroup intervalOption
		}  // End CheckBox interval

		Group
		{
			visible: meanIntervalCustom.checked

			IntegerField
			{
				id: numberOfClouds
				name: "numberOfClouds"
				label: qsTr("Number of clouds")
				min: 1
				defaultValue: 1
			}

			TableView
			{

				id: meanIntervalCustomTable
				modelType			: JASP.Simple

				implicitWidth		: 350 //  form.implicitWidth
				implicitHeight		: 140 * preferencesModel.uiScale // about 3 rows

				initialRowCount		: numberOfClouds.value
				initialColumnCount	: 2
				rowCount			: numberOfClouds.value
				columnCount			: 2

				name				: "meanIntervalCustomTable"
				cornerText			: qsTr("Cloud")
				columnNames			: [qsTr("Lower Limit"), qsTr("Upper Limit")]

				// isFirstColEditable	: false


				itemType			: JASP.Double
				// itemTypePerColumn	: [JASP.String] // first column is string, all others are double

				function getRowHeaderText(headerText, rowIndex)	 { return String.fromCharCode(65 + rowIndex);	}

				// function getDefaultValue(columnIndex, rowIndex)	 { return columnIndex === 0 ? String.fromCharCode(65 + rowIndex) : 2 * columnIndex - 3;	}

				function getDefaultValue(columnIndex, rowIndex)	 { return columnIndex === 0 ? String.fromCharCode(65 + rowIndex) : 0	}



				JASPDoubleValidator			{ id: doubleValidator; decimals: 3	}
				RegularExpressionValidator	{ id: stringValidator				}
				function getValidator(columnIndex, rowIndex) 	 { return columnIndex === 0 ? stringValidator : doubleValidator							}
			}



		}  // End group with custom table

	}  // End section Advanced

}  // End Form