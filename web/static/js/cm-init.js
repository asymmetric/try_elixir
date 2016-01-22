let div = document.getElementById("editor");
let cm = CodeMirror(div, {
  lineNumbers: true,
  theme: "elegant",
  mode: "elixir"
});

$("#indent").click(() => cm.execCommand("indentAuto"));
