// generate HTML page to plot chart, serve over HTTP & launch a browser
.md.plot:{[t]
		h:.h.htac[`script;enlist[`src]!enlist"https://cdn.plot.ly/plotly-latest.min.js";""];
		h,:.h.htac[`div;(1#`id)!enlist"kdb-graph";""];
		j:.j.j select x:date,y:balance by name:`balance from t;
		h,:.h.htac[`script;`type`id!("application/json";"plot-data");j];
		h,:.h.htc[`script;"window.onload = function(){Plotly.react('kdb-graph',JSON.parse(document.getElementById('plot-data').innerHTML));};"];
		.z.ph:{[x;y].h.hy[`htm;x]}[.h.htc[`html]h];

		// make sure a port is set & open a browser to it
		if[0=system"p";system"p 0W"];
		system"xdg-open http://localhost:",string system"p";
	}