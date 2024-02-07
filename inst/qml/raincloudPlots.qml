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
			title:					qsTr("Subject     (requires long data & Axis input)")  // Extra spaces for alignment
			id: 					subject
			suggestedColumns: 		["nominal", "ordinal", "scale"]
			singleVariable: 		true
			enabled:				factorAxis.count === 1
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
			checked:				factorFill.count === 0
			enabled: 				factorFill.count === 0
			Layout.columnSpan: 2
		}

		PercentField
		{
			name: 					"vioOpacity"
			label:					qsTr("Violin opacity")
			Layout.columnSpan: 1
		}

		DropDown
		{
			name: 					"vioEdges"
			label:					qsTr("Violin outline")
			values:	[
					{ label: qsTr("like palette"), value: "likePalette" },
				   	{ label: qsTr("black"),        value: "black" },
				   	{ label: qsTr("none"),         value: "none" },
				   	]
			Layout.columnSpan: 1
		}

		HelpButton
		{
			toolTip:				qsTr("0% opacity & no outline to hide Violin or Box")
		}

		PercentField
		{
			name: 					"boxOpacity"
			label:					qsTr("Box opacity   ")  // Additional spaces for neat line up in GUI with vioOpacity
			Layout.columnSpan: 1
		}

		DropDown
		{
			name: 					"boxEdges"
			label:					qsTr("Box outline   ")  // Additional spaces for neat line up in GUI with vioEdge
			values:	[
					{ label: qsTr("like palette"), value: "likePalette" },
				   	{ label: qsTr("black"),        value: "black" },
				   	{ label: qsTr("none"),         value: "none" },
				   	]
			Layout.columnSpan: 2
		}

		PercentField
		{
			name: 					"pointOpacity"
			label:					qsTr("Point opacity")
		}

		ColorPalette
		{
			name:					"palettePoints"
			label:					qsTr("Point palette")
			enabled: 				covariate.count === 1
			indexDefaultValue:		3  // viridis works good for both discrete and continous
			Layout.columnSpan: 1
		}

		HelpButton
		{
			toolTip:				qsTr("0% opacity to hide Points")
		}

		PercentField
		{
			name:					"lineOpacity"
			label:					qsTr("Subject Line Opacity")
			enabled:				subject.count === 1
			defaultValue:			25
		}

	}

	Section
	{
		title: 						qsTr("Element Fine-tuning")
		columns: 3

		CheckBox
		{
			name:					"customSides"
			id:						customSides
			label:					qsTr("Custom orientation for each cloud:")
			Layout.columnSpan: 		2
			childrenOnSameRow:		true

			TextField
			{
				name:				"sidesInput"
				label:				qsTr("")
				placeholderText:	"Enter 'L' or 'R' for each cloud."
			}
		}
		HelpButton
		{
			toolTip:				qsTr("Per default, all violins are right of the boxes.\nFor each Axis level you can specify 'L' or 'R' for each Color level.\nFor example, with a 2 (Axis: Pre, Post) x 2 (Color: Experimental, Control) design, enter 'LLRR' for flanking clouds.\n\nIf you enter too little or too many letters or anything but 'L' or 'R',\nthe orientation reverts to default.\nIf the Custom orientation box is ticked, Points Nudge is fixed to 0.")
		}

		Group
		{
			title:					qsTr("Violin")
			columns: 3
			Layout.columnSpan: 		3

			DoubleField
			{
				name:				"vioNudge"
				label:				qsTr("Nudge")
				defaultValue:		!(customSides.checked) ? 0.075 : 0.215
				negativeValues:		true
			}

			DoubleField
			{
				name:				"vioWidth"
				label:				qsTr("Width")
				defaultValue:		0.7
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
			Layout.columnSpan: 		3

			DoubleField
			{
				name:				"boxNudge"
				label:				qsTr("Nudge")
				defaultValue:		!(customSides.checked) ? 0 : 0.14
				negativeValues:		true
			}

			DoubleField
			{
				name:				"boxWidth"
				label:				qsTr("Width")
				defaultValue:		0.075
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
			Layout.columnSpan: 		3

			DoubleField
			{
				name:				"pointNudge"
				label:				qsTr("Nudge")
				defaultValue:		!(customSides.checked) ? 0.14 : 0 // Is multiplied by -1 in the R script
				enabled:			!(customSides.checked) ? true : false
				negativeValues:		true
			}

			DoubleField
			{
				name:				"pointWidth"
				label:				qsTr("Width")
				defaultValue:		0.065
			}

		}


	}

		CheckBox
	{
		name: 						"horizontal"
		label:						qsTr("Horizontal plot")
		checked: false
	}

}

