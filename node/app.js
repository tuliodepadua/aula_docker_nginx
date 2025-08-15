import express from "express";
const app = express();

app.get("/node", (req, res) => {
  res.json({
    service: "node",
    message: "Hello from Node + Express!",
    timestamp: new Date().toISOString(),
  });
});

app.get("/", (req, res) => {
  res.send("Node service is up. Try GET /node");
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Node listening on port ${PORT}`);
});
