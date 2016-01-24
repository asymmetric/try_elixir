let div = document.getElementById("editor");
let cm = CodeMirror(div, {
  lineNumbers: true,
  theme: "material",
  mode: "elixir",
  autofocus: true
});

$("#indent")._.addEventListener("click", () => cm.execCommand("indentAuto"));
$("#run")._.addEventListener("click", () => {
  let content = cm.getValue();
  $.fetch("/api/run", {
    method: "POST",
    data: {
      content: content
    },
    responseType: "json"
  })
  .then(xhr => $("#result").innerHTML = xhr.response.resp)
  .catch(() => console.log("ajax call failed"))
}, false);
