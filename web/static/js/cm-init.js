let div = document.getElementById("editor");
let cm = CodeMirror(div, {
  lineNumbers: true,
  theme: "material",
  mode: "elixir",
  autofocus: true
});

document.getElementById("run").addEventListener("click", () => {
  let content = cm.getValue();
  fetch("/api/commands", {
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
  .then(json => document.getElementById("result").innerHTML = json.resp)
  .catch(() => console.log("ajax call failed"))
});
