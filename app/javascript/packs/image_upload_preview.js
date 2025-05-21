let selectedFiles = [];

document.addEventListener("turbolinks:load", () => {
  const fileInput = document.getElementById("image_upload");
  const nameList = document.getElementById("image-name-list");

  if (!fileInput || !nameList) return;

  fileInput.addEventListener("change", (e) => {
    const files = Array.from(e.target.files);

    // 最大5枚まで制限
    if (selectedFiles.length + files.length > 5) {
      alert("画像は最大5枚まで選択できます。");
      return;
    }

    // ファイルを追加
    selectedFiles.push(...files);

    // ファイル名リストを更新
    nameList.innerHTML = "";
    selectedFiles.forEach((file, index) => {
      const li = document.createElement("li");
      li.textContent = `画像${index + 1}: ${file.name}`;
      li.className = "mb-1";
      nameList.appendChild(li);
    });

    // inputのfilesを再構築
    const dataTransfer = new DataTransfer();
    selectedFiles.forEach(file => dataTransfer.items.add(file));
    fileInput.files = dataTransfer.files;
  });
});
