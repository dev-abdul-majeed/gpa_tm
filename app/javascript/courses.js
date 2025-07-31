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
