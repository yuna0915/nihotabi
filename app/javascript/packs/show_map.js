// ページ読み込み時に投稿の地図を表示する処理
document.addEventListener("turbolinks:load", () => {
  // 地図を表示する要素を取得
  const postMapEl = document.getElementById("post-map");
  // 投稿の位置情報を取得
  const location = window.postLocation;

  // 必要な要素やAPIがなければ処理を終了
  if (!postMapEl || !window.google || !location) return;

  // 地図を作成し、指定の位置・ズームで中心を設定
  const map = new google.maps.Map(postMapEl, {
    center: { lat: location.lat, lng: location.lng },
    zoom: 14,
  });

  // 地図上にマーカーを設置
  new google.maps.Marker({
    position: { lat: location.lat, lng: location.lng },
    map,
    title: location.title || "スポット",  // ピンのタイトル
  });
});
