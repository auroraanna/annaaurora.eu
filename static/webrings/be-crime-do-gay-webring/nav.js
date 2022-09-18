site = "https://annaaurora.eu/webrings/be-crime-do-gay-webring" // Use exactly what's in the JSON file

function add_links() {
	ring = JSON.parse(r.response);
	position = ring.indexOf(site);
	if (position + 1 == ring.length) {
		next_site = ring[0];
		prev_site = ring[position - 1];
	} else if (position == 0) {
		next_site = ring[position + 1];
		prev_site = ring[ring.length - 1];
	} else {
		next_site = ring[position + 1];
		prev_site = ring[position - 1];
	}
	document.getElementById("webring_prev").href = prev_site
	document.getElementById("webring_next").href = next_site
}
r = new XMLHttpRequest();
r.addEventListener("load", add_links);
r.open("GET", "https://artemislena.eu/services/downloads/beCrimeDoGay.json");
r.send();

