function openDialog(msg) {
  linkObj.messageFromHtml(msg);
}

function loadData(body) {
  let el = document.getElementById("content");
  el.innerHTML = body;
}
