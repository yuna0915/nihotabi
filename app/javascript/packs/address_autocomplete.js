document.addEventListener("DOMContentLoaded", function () {
  const input = document.getElementById("autocomplete");
  if (!input) return;

  // Googleの自動補完（オートコンプリート）を使う
  const autocomplete = new google.maps.places.Autocomplete(input, {
    types: ["geocode"],
    componentRestrictions: { country: "jp" } // 日本の住所だけ
  });

  // 補完で選ばれたら、自動で住所を入力欄に反映してくれる
});
