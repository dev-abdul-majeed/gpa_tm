function toggleAccordion(targetId) {
  const target = document.getElementById(targetId);
  const chevron = document.getElementById("chevron-" + targetId.split("-")[1]);

  if (target.classList.contains("hidden")) {
    // Show accordion
    target.classList.remove("hidden");
    target.classList.add("animate-fadeIn");
    chevron.style.transform = "rotate(180deg)";
  } else {
    // Hide accordion
    target.classList.add("hidden");
    target.classList.remove("animate-fadeIn");
    chevron.style.transform = "rotate(0deg)";
  }
}

function toggleDropdown(studentId) {
  const dropdown = document.getElementById(`dropdown-${studentId}`);
  const allDropdowns = document.querySelectorAll('[id^="dropdown-student-"]');

  // Close all other dropdowns
  allDropdowns.forEach((d) => {
    if (d.id !== `dropdown-${studentId}`) {
      d.classList.add("hidden");
    }
  });

  // Toggle current dropdown
  dropdown.classList.toggle("hidden");
}

// Close dropdown when clicking outside
document.addEventListener("click", function (e) {
  if (!e.target.closest("[data-dropdown]")) {
    const allDropdowns = document.querySelectorAll('[id^="dropdown-student-"]');
    allDropdowns.forEach((d) => d.classList.add("hidden"));
  }
});
