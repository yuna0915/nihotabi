// 画像を選んだときにファイル名を画面に表示する処理
document.addEventListener("turbolinks:load", () => {

  // 画像アップロード用の入力欄と表示エリアを取得
  const fileInput = document.getElementById("image_upload");
  const nameList = document.getElementById("image-name-list");

  // 入力欄か表示エリアがなければ処理しない
  if (!fileInput || !nameList) return;

  // 画像を選んだときの動き
  fileInput.addEventListener("change", (e) => {
    // 選んだファイルを配列に変換
    const files = Array.from(e.target.files);

    // ファイルを選んでなければリストを空にする
    if (files.length === 0) {
      nameList.innerHTML = "";
      return;
    }

    // 画像が5枚より多いと警告を表示して選択をリセット
    if (files.length > 5) {
      alert("画像は最大5枚までしか選べません。選び直してください。");
      fileInput.value = "";
      nameList.innerHTML = "";
      return;
    }

    // ファイル名リストを画面に表示
    updateFileList(nameList, files);
  });
});

// ファイル名を画面にリスト表示する処理
function updateFileList(nameList, files) {
  // リストを空にする
  nameList.innerHTML = "";
  files.forEach((file, index) => {
    // ファイル名を1つずつ<li>タグで作成
    const li = document.createElement("li");
    // レイアウト用のクラス設定
    li.className = "mb-2 d-flex justify-content-center align-items-center gap-3";

    // ファイル名を表示する<span>作成
    const span = document.createElement("span");
    span.textContent = `画像${index + 1}: ${file.name}`;
    span.className = "text-dark";

    // <li>の中に<span>を入れてからリストに追加
    li.appendChild(span);
    nameList.appendChild(li);
  });
}
