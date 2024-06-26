import QtQuick 		2.12
import JASP.Module 	1.0

Description
{
	name		: "jaspRaincloudPlots"
	title		: qsTr("Raincloud Plots")
	description	: qsTr("Create raincloud plots")
	version		: "0.1"
	author		: "Vincent Ott, JASP Team"
	maintainer	: "JASP Team <info@jasp-stats.org>"
	website		: "jasp-stats.org"
	license		: "GPL (>= 2)"
	icon		: "v1Raincloud.svg"
	hasWrappers	: false

	
	Analysis
	{
		title:	qsTr("Raincloud Plots")
		func:	"raincloudPlots"
	}
}
