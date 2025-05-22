document.addEventListener("turbolinks:load", () => {
  const postMapEl = document.getElementById("post-map");
  const location = window.postLocation;

  if (!postMapEl || !window.google || !location) return;

  const map = new google.maps.Map(postMapEl, {
    center: { lat: location.lat, lng: location.lng },
    zoom: 14,
  });

  new google.maps.Marker({
    position: { lat: location.lat, lng: location.lng },
    map,
    title: location.title || "スポット",
  });
});
