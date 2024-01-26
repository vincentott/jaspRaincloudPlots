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
			name: 					"id"
			title:					qsTr("ID (feature requires data in Long format)")
			id: 					id
			suggestedColumns: 		["nominal", "ordinal", "scale"]
			singleVariable: 		true
		}

	}

	Section
	{
		title: 						qsTr("Colors and Opacity")
		columns: 3

		ColorPalette
		{
			name: 					"paletteFill"
			label:					qsTr("Color palette")
			Layout.columnSpan: 1

		}

		CheckBox
		{
			name: 					"colorAnyway"
			label:					qsTr("Apply color to Axis")
			id: 					colorAnyway
			enabled: 				factorFill.count === 0
			Layout.columnSpan: 2
		}

		PercentField
		{
			name: 					"vioOpacity"
			label:					qsTr("       Violin opacity")
			//enabled: 				factorFill.count === 1 || colorAnyway.checked
			Layout.columnSpan: 1
		}

		DropDown
		{
			name: 					"vioEdges"
			label:					qsTr("       Violin outline")
			//enabled: 				factorFill.count === 1 || colorAnyway.checked
			values:	[
				   	{ label: qsTr("black"), value: "black" },
				   	{ label: qsTr("none"), value: "none" },
			       	]
			Layout.columnSpan: 1
		}

		HelpButton
		{
			toolTip:				qsTr("0% opacity & no edges hide Violin or Box")
		}

		PercentField
		{
			name: 					"boxOpacity"
			label:					qsTr("       Box opacity   ")  // Additional spaces for neat line up in GUI with vioOpacity
			//enabled: 				factorFill.count === 1 || colorAnyway.checked
			Layout.columnSpan: 1
		}

		DropDown
		{
			name: 					"boxEdges"
			label:					qsTr("       Box outline   ")  // Additional spaces for neat line up in GUI with vioEdge
			//enabled: 				factorFill.count === 1 || colorAnyway.checked
			values:	[
				   	{ label: qsTr("black"), value: "black" },
				   	{ label: qsTr("none"), value: "none" },
				   	]
			Layout.columnSpan: 2
		}

		PercentField
		{
			name: 					"pointOpacity"
			label:					qsTr("       Point opacity")
		}

		ColorPalette
		{
			name:					"palettePoints"
			label:					qsTr("       Point palette")
			enabled: 				covariate.count === 1
			Layout.columnSpan: 1
		}

		HelpButton
		{
			toolTip:				qsTr("0% opacity to hide Points")
		}

	}

	Section
	{
		title: 						qsTr("Element Fine-tuning")
		columns: 1

		Group
		{
			title:					qsTr("Violin")
			columns: 3

			DoubleField
			{
				name:				"vioWidth"
				label:				qsTr("Width")
				defaultValue:		0.7
			}

			DoubleField
			{
				name:				"vioNudge"
				label:				qsTr("Nudge")
				defaultValue:		0.075
				negativeValues:		true
			}

			DoubleField
			{
				name:				"vioSmoothing"
				label:				qsTr("Smoothing")
				defaultValue:		1
				min:				0
				max:				1
			}
		}

		Group
		{
			title:					qsTr("Box")
			columns: 3

			DoubleField
			{
				name:				"boxWidth"
				label:				qsTr("Width")
				defaultValue:		0.075
			}

			DoubleField
			{
				name:				"boxNudge"
				label:				qsTr("Nudge")
				defaultValue:		0
				negativeValues:		true
			}

			DoubleField
			{
				name:				"boxDodge"
				label:				qsTr("Dodge")
				defaultValue:		0.15
			}
		}

		Group
		{
			title:					qsTr("Points")
			columns: 2

			DoubleField
			{
				name:				"pointWidth"
				label:				qsTr("Width")
				defaultValue:		0.065
			}

			DoubleField
			{
				name:				"pointNudge"
				label:				qsTr("Nudge")
				defaultValue:		-0.14
				negativeValues:		true
			}
		}


	}

	Section
	{
		title: 						qsTr("Settings for ID feature")
	}

		CheckBox
	{
		name: 						"horizontal"
		label:						qsTr("Horizontal plot")
		checked: false
	}

}