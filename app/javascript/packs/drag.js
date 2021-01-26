function drag() {
  const items = [...document.querySelectorAll(".item")];

const handleDragStart = (e) => {
  e.target.classList.add("dragging");

  e.dataTransfer.effectAllowed = "move";

  const { id } = e.target;
  e.dataTransfer.setData("application/json", JSON.stringify({ id }));
};

const handleDragEnd = (e) => e.target.classList.remove("dragging");

for (const item of items) {
  item.addEventListener("dragstart", handleDragStart, false);
  item.addEventListener("dragend", handleDragEnd, false);
}

const handleDragEnter = (e) => {
  if ([...e.target.classList].includes("item")) {
    return;
  }

  e.target.classList.add("over");
};

const handleDragLeave = (e) => e.target.classList.remove("over");

const handleDragOver = (e) => {
  e.preventDefault();

  if ([...e.target.classList].includes("item")) {
    e.dataTransfer.dropEffect = "none";
    return;
  }

  e.dataTransfer.dropEffect = "move";
};

const handleDrop = (e) => {
  e.preventDefault();
  e.target.classList.remove("over");

  if (e.dataTransfer.files.length > 0) {
    return;
  }

  const { id } = JSON.parse(e.dataTransfer.getData("application/json"));

  e.target.appendChild(document.getElementById(id));
};

const boxes = [...document.querySelectorAll(".box")];

for (const box of boxes) {
  box.addEventListener("dragenter", handleDragEnter, false);
  box.addEventListener("dragleave", handleDragLeave, false);
  box.addEventListener("dragover", handleDragOver, false);
  box.addEventListener("drop", handleDrop, false);
}
}
window.addEventListener('load', drag);