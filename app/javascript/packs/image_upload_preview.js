document.addEventListener("turbolinks:load", () => {
  const fileInput = document.getElementById("image_upload");
  const nameList = document.getElementById("image-name-list");
  const clearButton = document.getElementById("clear-images");

  if (!fileInput || !nameList) return;

  fileInput.addEventListener("change", (e) => {
    const existingImageCount = getExistingImageCount();
    const files = Array.from(e.target.files);

    const maxSelectable = 5 - existingImageCount;

    if (files.length === 0) {
      alert("画像を1枚以上選択してください。");
      fileInput.value = "";
      nameList.innerHTML = "";
      return;
    }

    if (maxSelectable <= 0) {
      alert("すでに5枚の画像が設定されています。新たに追加できません。");
      fileInput.value = "";
      nameList.innerHTML = "";
      return;
    }

    const acceptedFiles = files.slice(0, maxSelectable);
    if (files.length > maxSelectable) {
      alert(`画像は最大5枚までです。うち ${files.length - maxSelectable} 枚は追加できませんでした。`);
    }

    updateFileList(nameList, acceptedFiles);
  });

  if (clearButton) {
    clearButton.addEventListener("click", () => {
      fileInput.value = "";
      nameList.innerHTML = "";
    });
  }
});

function getExistingImageCount() {
  const existingImageInput = document.getElementById("existing-image-count");
  if (!existingImageInput) return 0;
  const count = parseInt(existingImageInput.value, 10);
  return isNaN(count) ? 0 : count;
}

function updateFileList(nameList, files) {
  nameList.innerHTML = "";
  files.forEach((file, index) => {
    const li = document.createElement("li");
    li.className = "mb-2 d-flex justify-content-center align-items-center gap-3";

    const span = document.createElement("span");
    span.textContent = `画像${index + 1}: ${file.name}`;
    span.className = "text-dark";

    li.appendChild(span);
    nameList.appendChild(li);
  });
}
