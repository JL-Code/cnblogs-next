function openDialog(msg) {
  linkObj.messageFromHtml(msg);
}

function loadData(body) {
  let el = document.getElementById("content");
  el.innerHTML = body;

  if (hljs) {
    hljs.highlightAll();
    console.log("highlightAll 调用完成")
  } else {
    alert("hljs 加载未完成")
  }
}
