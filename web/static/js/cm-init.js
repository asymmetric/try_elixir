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
  fetch("/api/run", {
    method: "POST",
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      content: content
    }),
    responseType: "json"
  })
  .then(response => response.json())
  .then(json => $("#result").innerHTML = json.resp)
  .catch(() => console.log("ajax call failed"))
}, false);
