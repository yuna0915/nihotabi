document.addEventListener("turbolinks:load", () => {
  const fileInput = document.getElementById("image_upload");
  const nameList = document.getElementById("image-name-list");
  const clearButton = document.getElementById("clear-images");

  if (!fileInput || !nameList) return;

  fileInput.addEventListener("change", (e) => {
    const files = Array.from(e.target.files);

    if (files.length === 0) {
      nameList.innerHTML = "";
      return;
    }

    if (files.length > 5) {
      alert("画像は最大5枚までしか選べません。選び直してください。");
      fileInput.value = "";
      nameList.innerHTML = "";
      return;
    }

    updateFileList(nameList, files);
  });

  if (clearButton) {
    clearButton.addEventListener("click", () => {
      fileInput.value = "";
      nameList.innerHTML = "";
    });
  }
});

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
