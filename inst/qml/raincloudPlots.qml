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
			name: 					"factorAxis"
			title:					qsTr("Axis")
			id: 					factorAxis;
			suggestedColumns: 		["nominal", "ordinal"]
			singleVariable: 		true
		}
		AssignedVariablesList
		{
			name: 					"factorFill"
			title:					qsTr("Color")
			id: 					factorFill
			suggestedColumns: 		["nominal", "ordinal"]
			singleVariable: 		true
		}

		AssignedVariablesList
		{
			name: 					"covariate"
			title:					qsTr("Points")
			id: 					covariate
			suggestedColumns: 		["nominal", "ordinal", "scale"]
			singleVariable: 		true
		}

		AssignedVariablesList
		{
			name: 					"subject"
			title:					qsTr("Subject (needs long data & Axis)")  // Extra spaces for alignment
			id: 					subject
			suggestedColumns: 		["nominal", "ordinal", "scale"]
			singleVariable: 		true
			enabled:				factorAxis.count === 1
		}

	}



	Section
	{
		title: qsTr("Color and Opacity")
		columns: 3

		ColorPalette
		{
			name: 					"paletteFill"
			label:					qsTr("Color palette")
		}

		CheckBox
		{
			name: 					"colorAnyway"
			label:					qsTr("Apply color palette to Axis")
			id: 					colorAnyway
			checked:				factorFill.count === 0
			enabled: 				factorFill.count === 0
			Layout.columnSpan: 		2
		}

		Group  // First Column of the section: Opacities
		{
			PercentField
			{
				name: 					"vioOpacity"
				label:					qsTr("Violin opacity")
			}

			PercentField
			{
				name: 					"boxOpacity"
				label:					qsTr("Box opacity")
			}

			PercentField
			{
				name: 					"pointOpacity"
				label:					qsTr("Point opacity")
			}

			PercentField
			{
				name:					"lineOpacity"
				label:					qsTr("Subject Line Opacity")
				enabled:				subject.count === 1
				defaultValue:			25
			}
		}  // End First Column

		Group  // Second Column of the section: Outlines & Point palette
		{
			columns: 2

			Label
			{
				text: qsTr("Violin Outline")
			}
			DropDown
			{
				name: 					"vioOutline"
				values:	[
						{ label: qsTr("like palette"), value: "likePalette" },
						{ label: qsTr("black"),        value: "black" },
						{ label: qsTr("none"),         value: "none" },
						]
				Layout.columnSpan: 1
			}

			Label
			{
				text: qsTr("Box outline")
			}
			DropDown
			{
				name: 					"boxOutline"
				values:	[
						{ label: qsTr("like palette"), value: "likePalette" },
					   	{ label: qsTr("black"),        value: "black" },
					   	{ label: qsTr("none"),         value: "none" },
					   	]
				Layout.columnSpan: 1
			}

			Label
			{
				text: qsTr("Point palette")
			}
			DropDown  // adapted from: jasp´s ColorPalette.qml
			{
				name:					"palettePoints"
				label:					""  // No qsTr() as this will stay the same across languages
				enabled: 				covariate.count === 1
				values:
				[
					// { label: qsTr("Colorblind"),		value: "colorblind"		},  // Disabled to not match paletteFill

					{ label: qsTr("Viridis"),			value: "viridis"		},  // useful for discrete & continuous
					{ label: qsTr("Colorblind #2"),		value: "colorblind2"	},
					{ label: qsTr("Colorblind #3"),		value: "colorblind3"	},
					{ label: qsTr("ggplot2"),			value: "ggplot2"		},
					{ label: qsTr("Gray"),				value: "gray"			},
					{ label: qsTr("Blue"),				value: "blue"			},
					{ label: qsTr("Sports teams: NBA"),	value: "sportsTeamsNBA"	},
					{ label: qsTr("Grand Budapest"),	value: "grandBudapest"	}
				]
				Layout.columnSpan: 1
			}
		}  // End Second Column

		Group  // Third Column of the section: HelpButtons
		{
			HelpButton
			{
				toolTip: qsTr("0% opacity & no outline to hide Violin or Box")
			}

			Label
			{
				// Empty placeholder
			}

			HelpButton
			{
				toolTip: qsTr("0% opacity to hide Points")
			}
		}  // End Third Column

	}  // End section Color and Opacity



	Section
	{
		title: 						qsTr("Position and Shape")
		columns: 3

		// Start Top Row Position and Shape Section --------------------------------------------------------------------
		Group  // First Column Position and Shape section
		{
			CheckBox
			{
				name: 						"horizontal"
				label:						qsTr("Horizontal plot")
				checked: false
			}

			TextField
			{
				name:					"customSides"
				id:						customSides
				label:				qsTr("Custom orientation for each cloud:")
				placeholderText:	"Enter 'L' or 'R' for each cloud."
			}
		}

		Group  // Second Column Position and Shape section
		{
			Label
			{
				// Empty for neat line-up
			}
			Label
			{
				// Empty for neat line-up
			}
		}

		Group  // Third Column Position and Shape section
		{
			Label
			{
				// Empty for neat line-up
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
		}
		// End Top Row Position and Shape Section ----------------------------------------------------------------------

		GridLayout
		{
			rowSpacing: 5
			columnSpacing: 15
			columns: 7
			Label
			{
				// Empty placeholder
			}
			Label
			{
				text: qsTr("Nudge")
			}
			Label
			{
				text: qsTr("Width")
			}
			Label
			{
				// Empty placeholder
			}
			Label
			{
				text: qsTr("Element-Specific")
				Layout.columnSpan: 2

			}
			Label
			{
				// Empty placeholder
			}

			// End first row of GridLayout

			Label
			{
				text: qsTr("Violin")
			}
			DoubleField
			{
				name:				"vioNudge"
				defaultValue:		(customSides.value === "") ? 0.09 : 0.24
				negativeValues:		true
			}
			DoubleField
			{
				name:				"vioWidth"
				defaultValue:		0.7
			}
			Label
			{
				// Empty placeholder
			}
			Label
			{
				text: qsTr("Smoothing")
			}
			DoubleField
			{
				name:				"vioSmoothing"
				defaultValue:		1
				min:				0
				max:				1
			}
			Label
			{
				// Empty placeholder
			}

			// End second row of GridLayout

			Label
			{
				text: qsTr("Box")
			}
			DoubleField
			{
				name:				"boxNudge"
				defaultValue:		(customSides.value === "") ? 0 : 0.15
				negativeValues:		true
			}
			DoubleField
			{
				name:				"boxWidth"
				defaultValue:		(factorFill.count === 0) ? 0.1 : 0.2
			}
			Label
			{
				// Empty placeholder
			}
			Label
			{
				text: qsTr("Padding")
			}
			DoubleField
			{
				name:				"boxPadding"
				defaultValue:		(factorFill.count === 0) ? 0.1 : 0.2
			}
			Label
			{
				// Empty placeholder
			}

			// End third row of GridLayout

			Label
			{
				text: qsTr("Point")
			}
			DoubleField
			{
				name:				"pointNudge"
				defaultValue:		(customSides.value === "") ? 0.15 : 0 // Is multiplied by -1 in the R script
				enabled:			(customSides.value === "") ? true : false
				negativeValues:		true
			}
			DoubleField
			{
				name:				"pointWidth"
				defaultValue:		0.065
			}
			Label
			{
				// Empty placeholder
			}
			Label
			{
				text: qsTr("y-Jitter")
			}
			CheckBox
			{
				name:				"yJitter"
				id:					yJitter
			}
			Label
			{
				text: qsTr("See caption!")
				visible: yJitter.checked
			}

			// End fourth row of GridLayout

		}

	}  // End Section Position and Shape



	Section
	{
		title: qsTr("Axes, Legend, and Caption")
		columns: 3

		CheckBox
		{
			name: "showCaption"
			label: qsTr("Show Caption")
			checked: true
		}

	}  // End Section Axes, Legend, and Caption


	Section
	{
		title: qsTr("Advanced: Means and Intervals")
		columns: 3

		CheckBox
		{
			name: "means"
			label: qsTr("Show Means instead of Boxes")
		}


	}  // End Section Advanced: Means and Intervals

}  // End Form