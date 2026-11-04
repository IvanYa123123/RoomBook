document.addEventListener("DOMContentLoaded", () => {
  const dates = document.querySelectorAll("input[type='date']");
  const today = new Date().toISOString().split("T")[0];
  dates.forEach((input) => input.setAttribute("min", today));
});
