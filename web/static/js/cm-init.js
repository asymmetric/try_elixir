let div = document.getElementById("editor");
let cm = CodeMirror(div, {
  lineNumbers: true,
  theme: "material",
  mode: "elixir",
  autofocus: true
});

$("#indent").click(() => cm.execCommand("indentAuto"));
$("#run").click(() => {
  content = cm.getValue();
  $.post("/api/run", { content: content})
  // TODO do something when call fails
  .fail(() => console.log("ajax call failed"));
});
