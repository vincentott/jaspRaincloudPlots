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
			name: 					"variables"
			title: 					qsTr("Dependent Variables")
			id: 					variables
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
			title:					qsTr("Subject (needs data in long format)")  // Extra spaces for alignment
			id: 					subject
			suggestedColumns: 		["nominal", "ordinal", "scale"]
			singleVariable: 		true
			enabled:				primaryFactor.count === 1
		}

	}


	Section
	{
		title: qsTr("General Settings")
		columns: 3

		// Start top 2 rows

		Group
		{
			columns: 2

			Label
			{
				text: qsTr("Color palette")
			}
			ColorPalette
			{
				name: 	"colorPalette"
				label: ""
			}

			Label
			{
				text: qsTr("Covariate palette")
				enabled: 	covariate.count === 1
			}
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
			checked:				secondaryFactor.count === 0
			enabled: 				secondaryFactor.count === 0
			Layout.columnSpan: 		2
		}

		// End top 2 rows
		
		CheckBox
		{
			name: 						"horizontal"
			label:						qsTr("Horizontal plot")
			checked: false
			Layout.columnSpan: 3
		}

	}  // End section General Settings


	Section
	{
		title: qsTr("Cloud Elements")
		columns: 3

		Group  // Start group Violin
		{
			title: qsTr("Violin")
			columns: 2

				Label
				{
					text: qsTr("Nudge")
				}
				DoubleField
				{
					name:				"vioNudge"
					defaultValue:		(customSides.value === "") ? 0.09 : 0.24
					negativeValues:		true
				}
				Label
				{
					text: qsTr("Height")
				}
				DoubleField
				{
					name:				"vioHeight"
					defaultValue:		0.7
				}
				Label
				{
					text: qsTr("Smoothing")
				}
				PercentField
				{
					name:				"vioSmoothing"
					fieldWidth: 40
					defaultValue:		100
				}
				Label
				{
					text: qsTr("Opacity")
				}
				PercentField
				{
					name: 		"vioOpacity"
					fieldWidth: 40
				}
				Label
				{
					text: qsTr("Outline")
				}
				DropDown
				{
					name: 	"vioOutline"
					values:	[
							{ label: qsTr("Color palette"), value: "palette" },
							{ label: qsTr("black"),        value: "black" },
							{ label: qsTr("none"),         value: "none" },
							]
				}
		}  // End group Violin


		Group  // Start group Box
		{
			title: qsTr("Box")
			columns: 2

			Label
			{
				text: qsTr("Nudge")
			}
			DoubleField
			{
				name:		"boxNudge"
				defaultValue:		(customSides.value === "") ? 0 : 0.15
				negativeValues:		true
			}
			Label
			{
				text: qsTr("Width")
			}
			DoubleField
			{
				name:				"boxWidth"
				defaultValue:		(secondaryFactor.count === 0) ? 0.1 : 0.2
			}
			Label
			{
				text: qsTr("Padding")
			}
			DoubleField
			{
				name:				"boxPadding"
				defaultValue:		(secondaryFactor.count === 0) ? 0.1 : 0.2
			}
			Label
			{
				text: qsTr("Opacity")
			}
			PercentField
			{
				name:		"boxOpacity"
				fieldWidth: 40
			}
			Label
			{
				text: qsTr("Outline")
			}
			DropDown
			{
				name: 	"boxOutline"
				values:	[
						{ label: qsTr("Color palette"), value: "palette" },
					   	{ label: qsTr("black"),        value: "black" },
					   	{ label: qsTr("none"),         value: "none" },
					   	]
			}

		}  // End group Box


		Group  // Start group Point
		{
			title: qsTr("Point")
			columns: 2

			Label	
			{
				text: qsTr("Nudge")
			}
			DoubleField
			{
				name:				"pointNudge"
				defaultValue:		(customSides.value === "") ? 0.15 : 0 // Is multiplied by -1 in the R script
				enabled:			(customSides.value === "") ? true : false
				negativeValues:		true
			}
			Label	
			{
				text: qsTr("Spread")
			}
			DoubleField
			{
				name:				"pointSpread"
				defaultValue:		0.065
			}
			Label	
			{
				text: qsTr("Size")
			}
			DoubleField
			{
				name:				"pointSize"
				defaultValue:		2.5
			}
			Label	
			{
				text: qsTr("Opacity")
			}
			PercentField
			{
				name: 					"pointOpacity"
				fieldWidth: 40
			}
			Label	
			{
				text: qsTr("Jitter")
			}
			CheckBox
			{
				name:	"jitter"
				id:		jitter
			}


		}  // End group Point

		PercentField
		{
			name:					"lineOpacity"
			label:					qsTr("Subject lines opacity")
			enabled:				subject.count === 1
			fieldWidth: 40
			defaultValue:			25
			Layout.columnSpan: 2
		}
		HelpButton
		{
			toolTip:	qsTr(
							"To remove an element, set the opacity to 0%.\n" +
							"Further, for violin and box, set the outline to 'none'."
						)
		}

	}  // End section Cloud Elements



	Section
	{
		title: qsTr("Axes, Legend, Caption, Plot size")
		columns: 3

		CheckBox
		{
			name: "showCaption"
			id: showCaption
			label: qsTr("Show Caption")
			checked: true
			Layout.columnSpan: 3
		}

		IntegerField
		{
			name: "widthPlot"
			label: qsTr("Plot width")
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
			label: qsTr("Plot height")
			defaultValue: (showCaption.checked) ? 550 : 450
		}

	}  // End section Axes, Legend, Caption, Plot size


	Section
	{
		title: qsTr("Advanced Settings")
		columns: 3

		CheckBox
		{
			name: "means"
			id: means
			label: qsTr("Show Means")
			Layout.columnSpan: 3

			CheckBox
			{
				name: "meanLines"
				label: qsTr("Connect Means")
				enabled: means.checked && secondaryFactor.count === 0
			}
		}

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
							"For each Axis level you can specify 'L' or 'R' for each Color level.\n" +
							"For example, with a 2 (Axis: Pre, Post) x 2 (Color: Experimental, Control) design, " +
							"enter 'LLRR' for flanking clouds (Pre-Exp, Pre-Control, Post-Exp, Post-Control).\n\n" +
							"If you enter too little or too many letters or anything but 'L' or 'R',\n"+
							"the orientation reverts to default (all 'R').\n" +
							"If there is any input, Point Nudge is set to 0."
						)
		}

	}  // End section Advanced Settings

}  // End Form