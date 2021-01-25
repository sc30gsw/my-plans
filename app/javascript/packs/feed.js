function feed() {
  const trend = document.getElementById("trend-feed");
  trend.addEventListener('click', (e) => {
    trend.setAttribute('style', 'background-color:rgb(87, 154, 255);');
  });
  const asc = document.getElementById("asc-feed");
  asc.addEventListener('mouseover', () => {
    trend.removeAttribute('style', 'background-color:rgb(87, 154, 255);');
  });
  asc.addEventListener('click', (e) => {
    asc.setAttribute('style', 'background-color:rgb(87, 154, 255);');
  });
  trend.addEventListener('mouseover', () => {
    asc.removeAttribute('style', 'background-color:rgb(87, 154, 255);');
  })
}
window.addEventListener('load', feed);