function initAutocomplete() {
  const input = document.getElementById("autocomplete");
  if (!input) return;

  // Googleの自動補完（オートコンプリート）を使う
  const autocomplete = new google.maps.places.Autocomplete(input, {
    types: ["geocode"],
    componentRestrictions: { country: "jp" } // 日本の住所だけに制限
  });

  // 補完で選ばれたら、place_changedイベントが発火する
  autocomplete.addListener("place_changed", function () {
    const place = autocomplete.getPlace();
    // ここで住所を整形したり、必要なカスタム処理を追加することも可能
    console.log(place); // デバッグ用
  });
}

// Google Maps APIの callback=initAutocomplete に対応
window.initAutocomplete = initAutocomplete;
