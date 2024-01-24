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
			name: "variables"
			id: variables
			title: qsTr("Dependent Variables")
			suggestedColumns: ["scale"]
		}
		AssignedVariablesList
		{
			name: "factorAxis"
			title: qsTr("Axis")
			id: factorAxis;
			singleVariable: true
			suggestedColumns: ["nominal", "ordinal"]
		}
		AssignedVariablesList
		{
			name: "factorFill"
			title: qsTr("Color")
			id: factorFill
			singleVariable: true
			suggestedColumns: ["nominal", "ordinal"]
		}

		AssignedVariablesList
		{
			name: "covariate"
			title: qsTr("Points")
			id: covariate
			singleVariable: true
			suggestedColumns: ["nominal", "ordinal", "scale"] 
		}

		AssignedVariablesList
		{
			name: "id"
			title: qsTr("ID (feature requires data in Long format)")
			id: id
			singleVariable: true
			suggestedColumns: ["nominal", "ordinal", "scale"]
		}

	}

	Section
	{
		title: qsTr("Colors and Opacity")
		columns: 3

		ColorPalette
		{
			name: "paletteFill"
			label: qsTr("Color palette")
			//enabled: factorFill.count === 1 || colorAnyway.checked
			Layout.columnSpan: 3

		}

		CheckBox
		{
			name: "colorAnyway"
			id: colorAnyway
			label: qsTr("Apply color palette even without Color input")
			enabled: factorFill.count === 0
			Layout.columnSpan: 3
		}

		PercentField
		{
			name: "vioOpacity"
			label: qsTr("       Violin opacity")
			enabled: factorFill.count === 1 || colorAnyway.checked
			Layout.columnSpan: 3
		}

/* 		DropDown
		{
			name: "vioEdges"
			label: qsTr("       Violin edge")
			enabled: factorFill.count === 1 || colorAnyway.checked
			values:
			[
				{ label: qsTr("as palette"), value: "as palette" },
				{ label: qsTr("black"), value: "black" },
				{ label: qsTr("none"), value: "none" },
			]
			Layout.columnSpan: 2
		} */

		PercentField
		{
			name: "boxOpacity"
			label: qsTr("       Box opacity   ")  // Additional spaces for neat line up in GUI with vioOpacity
			enabled: factorFill.count === 1 || colorAnyway.checked
			Layout.columnSpan: 3
		}

/* 		DropDown
		{
			name: "boxEdges"
			label: qsTr("       Box edge   ")  // Additional spaces for neat line up in GUI with vioEdge
			enabled: factorFill.count === 1 || colorAnyway.checked
			values:
			[
				{ label: qsTr("as palette"), value: "as palette" },
				{ label: qsTr("black"), value: "black" },
				{ label: qsTr("none"), value: "none" },
			]
			Layout.columnSpan: 2
		} */

		PercentField
		{
			name: "pointOpacity"
			label: qsTr("Point opacity")
		}

		ColorPalette
		{
			name: "palettePoints"
			label: qsTr("Point palette")
			enabled: covariate.count === 1
		}

	}

	Section
	{
		title: qsTr("Element Fine-tuning")

		CheckBox
	{
		name: "customLimits"
		label: qsTr("Custom variable axis:")
		childrenOnSameRow: true
		DoubleField
		{
			name: "lowerLimit"
			label: qsTr("Start:")
			negativeValues: true
		}
		IntegerField
		{
			name: "customBreaks"
			label: qsTr("Number of breaks:")
		}
		DoubleField
		{
			name: "upperLimit"
			label: qsTr("End:")
		}
	}
	}

	Section
	{
		title: qsTr("Settings for ID feature")
	}

		CheckBox
	{
		name: "horizontal"
		label: qsTr("Horizontal plot")
		checked: false
		//enabled: factorAxis.count === 0 || factorFill.count === 0
	}

}