// ecosystem.config.js
module.exports = {
  apps: [{
    name: "Évaluation",
    script: "./server.js",
    watch: true,
    env: {
      "NODE_ENV": "development",
    },
  }],
};
