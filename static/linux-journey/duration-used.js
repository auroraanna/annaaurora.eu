var table = document.getElementById('linux-journey');
var rows = table.children[1].children;
console.log('rows:', rows);

let i = 0;
for (var row of rows) {
	console.log('i:', i)

	const dateInstalled = Date.parse(row.children[0].innerHTML.trim().slice(1));
	let dateInstalledNext = 0;
	if (i == (rows.length - 1)) {
		dateInstalledNext = Date.now();
	} else {
		dateInstalledNext = Date.parse(rows[i + 1].children[0].innerHTML.trim().slice(1));
	};

	const durationUsedMilsecs = (dateInstalledNext - dateInstalled);
	const durationUsedDays = Math.trunc(durationUsedMilsecs / 1000 / 60 / 60 / 24);
	row.children[1].innerHTML = durationUsedDays;

	console.log('dateInstalled:', dateInstalled);
	console.log('dateInstalledNext:', dateInstalledNext);
	console.log('durationUsedMilsecs:', durationUsedMilsecs);
	console.log('durationUsedDays:', durationUsedDays);

	i += 1;
}

