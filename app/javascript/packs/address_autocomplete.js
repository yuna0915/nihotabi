// Googleマップの住所自動補完機能を初期化
function initAutocomplete() {
  // 入力フォームを取得
  const input = document.getElementById("autocomplete");
  if (!input) return;

  // Google Places Autocompleteを設定（日本の住所に限定）
  const autocomplete = new google.maps.places.Autocomplete(input, {
    types: ["geocode"],
    componentRestrictions: { country: "jp" }  // 日本国内限定
  });

  // 場所が選択された際のイベント処理
  autocomplete.addListener("place_changed", function () {
    const place = autocomplete.getPlace();
  });
}

// Google Maps APIロード完了時に自動で実行
window.initAutocomplete = initAutocomplete;
