function check() {
  const memos = document.querySelectorAll(".memo");
  memos.forEach(function (memo) {
    if (memo.getAttribute("data-load") != null) {
      return null;
    }
    memo.setAttribute("data-load", "true");
    memo.addEventListener('click', () => {
      const memoId = memo.getAttribute("data-id");
      const XHR = new XMLHttpRequest();
      XHR.open("GET", `/memos/${memoId}`, true)
      XHR.responseType = "json";
      XHR.send();
      XHR.onload = () => {
        if (XHR.status != 200) {
          alert(`Error ${XHR.status}: ${XHR.statusText}`);
          return null;
        }
        const item = XHR.response.memo;
        if (item.checked === true) {
          memo.setAttribute("data-check", "true");
        } else if (item.checked === false) {
          memo.removeAttribute("data-check");
        }
      };
    });
  })
}
setInterval(check, 1000);