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
			name: "variables";
			title: qsTr("Dependent Variables")
			suggestedColumns: ["scale"]
		}
		AssignedVariablesList
		{
			name: "factorAxis";
			title: qsTr("Axis");
			id: factorAxis;
			singleVariable: true;
			suggestedColumns: ["nominal", "ordinal"]
		}
		AssignedVariablesList
		{
			name: "factorFill";
			title: qsTr("Fill Color");
			id: factorFill;
			singleVariable: true;
			suggestedColumns: ["nominal", "ordinal"]
		}

		AssignedVariablesList
		{
			name: "covariate"
			title: qsTr("Point Color")
			id: covariate
			singleVariable: true
			suggestedColumns: ["nominal", "ordinal", "scale"] 
		}

	}


	CheckBox
	{
		name: "horizontal";
		label: qsTr("Horizontal plot");
		checked: true;
		enabled: factorAxis.count === 0 || factorFill.count === 0
	}

	ColorPalette
	{
		name: "paletteFill";
		label: qsTr("Fill color palette")
	}

	ColorPalette
	{
		name: "palettePoints";
		label: qsTr("Points color palette")
	}

}