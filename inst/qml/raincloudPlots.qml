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
	VariablesForm
	{
		AvailableVariablesList	{ name: "allVariablesList"; }
		AssignedVariablesList
		{ 
			name: "variables";
			title: qsTr("Variables")
		}
		AssignedVariablesList
		{
			name: "splitBy";
			title: qsTr("Split");
			id: splitBy;
			singleVariable: true;
			suggestedColumns: ["nominal", "ordinal"]
		}
		AssignedVariablesList
		{
			name: "covariate"
			title: qsTr("Covariate")
			id: covariate
			singleVariable: true
			suggestedColumns: ["scale", "ordinal"] 
		}
	}

	ColorPalette{}

	Section
	{
		title: qsTr("Simple Plots")
		columns: 1

		CheckBox
		{
			name: "simplePlots";
			label: qsTr("Show simple plots")

			Group
			{
				CheckBox
				{
					name: "horizontal"
					label: qsTr("Horizontal plots");
					checked: true
				}
			}

		}
	}

	Section
	{
		title: qsTr("Twofactorial design: One of the factors has two levels")
		columns: 1
	}
}