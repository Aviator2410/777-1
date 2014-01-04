var fctl_canvas = {};

var aileronPosLeft = {};
var elevonPosLeft = {};
var aileronPosRight = {};
var elevonPosRight = {};
var rudderPos = {};
var elevPosLeft = {};
var elevPosRight = {};
var elevatorTrim = {};
var rudderTrim = {};
var rudderTrimDirection = {};
var spoilers = {};
var spoilers_scale = {};

var canvas_fctl = {
	new : func(canvas_group)
	{
		var m = { parents: [canvas_fctl] };
		var fctl = canvas_group;
		var font_mapper = func(family, weight)
		{
			if( family == "Liberation Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		canvas.parsesvg(fctl, "Aircraft/777/Models/Instruments/MFD/fctl.svg", {'font-mapper': font_mapper});
		me.initSvgIds(fctl);
		return m;
	},
	initSvgIds: func(group)
	{
		aileronPosLeft = group.getElementById("aileronPosLeft");
		elevonPosLeft = group.getElementById("flaperonPosLeft");
		aileronPosRight = group.getElementById("aileronPosRight");
		elevonPosRight = group.getElementById("flaperonPosRight");
		rudderPos = group.getElementById("rudderPos");
		elevPosLeft = group.getElementById("elevPosLeft");
		elevPosRight = group.getElementById("elevPosRight");
		elevatorTrim = group.getElementById("elevatorTrim");
		rudderTrim = group.getElementById("rudderTrim");
		rudderTrimDirection = group.getElementById("rudderTrimDirection");
		spoilers = group.getElementById("spoilers").updateCenter();

		var c1 = spoilers.getCenter();
		spoilers.createTransform().setTranslation(-c1[0], -c1[1]);
		spoilers_scale = spoilers.createTransform();
		spoilers.createTransform().setTranslation(c1[0], c1[1]);

	},
	updateRudderTrim: func()
	{
		var rdTrim = getprop("controls/flight/rudder-trim");
		var rdTrimDir = "L";
		if (rdTrim > 0) rdTrimDir = "R";
		rdTrim = math.abs(rdTrim * 15);
		rudderTrim.setText(sprintf("%2.1f",rdTrim));
		rudderTrimDirection.setText(rdTrimDir);
	},
	updateSpoilers: func()
	{
		var spoilerTotalHeight = 77.5;
		var spbangle = getprop("controls/flight/speedbrake-angle") or 0.00;
		var spoilerCurrentHeight = spbangle*spoilerTotalHeight;
		spoilers_scale.setScale(1,spbangle);
		spoilers_scale.setTranslation(0,(spoilerCurrentHeight-spoilerTotalHeight)/2);
	},
	update: func()
	{
		rudderPos.setTranslation(130*getprop("controls/flight/rudder"),0);
		aileronPosLeft.setTranslation(0,62*getprop("controls/flight/aileron"));
		aileronPosRight.setTranslation(0,-62*getprop("controls/flight/aileron"));
		elevonPosLeft.setTranslation(0,62*getprop("controls/flight/aileron"));
		elevonPosRight.setTranslation(0,-62*getprop("controls/flight/aileron"));
		elevPosLeft.setTranslation(0,62*getprop("controls/flight/elevator"));
		elevPosRight.setTranslation(0,62*getprop("controls/flight/elevator"));
		elevatorTrim.setText(sprintf("%3.2f",getprop("controls/flight/elevator-trim")));

		me.updateRudderTrim();
		me.updateSpoilers();

		settimer(func me.update(), 0);
	}
};