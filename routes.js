const routes = require("next-routes")();

routes
  .add("/bounties/new", "/bounties/new")
  .add("/bounties/:address", "/bounties/show");

module.exports = routes;
