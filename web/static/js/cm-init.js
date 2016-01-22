let div = document.getElementById("editor");
let cm = CodeMirror(div, {
  lineNumbers: true,
  theme: "material",
  mode: "elixir",
  autofocus: true
});

$("#indent").click(() => cm.execCommand("indentAuto"));
