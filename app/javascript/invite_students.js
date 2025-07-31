function toggleStudent(studentId) {
  const checkbox = document.getElementById(`student_${studentId}`);
  checkbox.checked = !checkbox.checked;
  updateCardStyle(studentId);
  updateSelectedCount();
}

function updateCardStyle(studentId) {
  const checkbox = document.getElementById(`student_${studentId}`);
  if (!checkbox) return; // <-- Prevent error if checkbox not found

  const card = checkbox.closest(".student-card");
  if (!card) return; // extra safety check

  if (checkbox.checked) {
    card.classList.add("bg-emerald-50", "border-emerald-300");
    card.classList.remove("bg-slate-50", "border-slate-200");
  } else {
    card.classList.add("bg-slate-50", "border-slate-200");
    card.classList.remove("bg-emerald-50", "border-emerald-300");
  }
}

function selectAll() {
  const checkboxes = document.querySelectorAll(
    'input[name="course[student_ids][]"]'
  );
  checkboxes.forEach((checkbox) => {
    if (!checkbox.checked) {
      checkbox.checked = true;
      updateCardStyle(checkbox.value);
    }
  });
  updateSelectedCount();
}

function clearAll() {
  const checkboxes = document.querySelectorAll(
    'input[name="course[student_ids][]"]'
  );
  checkboxes.forEach((checkbox) => {
    if (checkbox.checked) {
      checkbox.checked = false;
      updateCardStyle(checkbox.value);
    }
  });
  updateSelectedCount();
}

function updateSelectedCount() {
  const checkedBoxes = document.querySelectorAll(
    'input[name="course[student_ids][]"]:checked'
  );
  const count = checkedBoxes.length;
  const countElement = document.getElementById("selected-count");
  const submitBtn = document.getElementById("submit-btn");

  countElement.textContent = `${count} student${
    count !== 1 ? "s" : ""
  } selected`;

  if (count > 0) {
    submitBtn.disabled = false;
    submitBtn.classList.remove("opacity-50", "cursor-not-allowed");
  } else {
    submitBtn.disabled = true;
    submitBtn.classList.add("opacity-50", "cursor-not-allowed");
  }
}

document.addEventListener("DOMContentLoaded", function () {
  updateSelectedCount();
});
