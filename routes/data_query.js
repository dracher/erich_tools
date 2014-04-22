// Generated by CoffeeScript 1.7.1
var ResultQuery, express, router, rq;

express = require('express');

router = express.Router();

ResultQuery = require('../libs/db_wrapper');

rq = new ResultQuery;

router.get('/profile/all', function(req, res) {
  return rq.profileAll(res);
});

router.get('/profile/by/:name', function(req, res) {
  return rq.summaryByProfile(res, req.params.name);
});

module.exports = router;
