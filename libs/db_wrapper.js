// Generated by CoffeeScript 1.7.1
var ResultsQuery, async, db, fs, sqlite3;

sqlite3 = require('sqlite3').verbose();

fs = require('fs');

async = require('async');

db = new sqlite3.Database('../results.sqlite');

ResultsQuery = (function() {
  function ResultsQuery() {}

  ResultsQuery.prototype.profileAll = function(cb) {
    return db.all('select DISTINCT "profile" from env_list order by c_time DESC', function(err, rows) {
      return cb.json({
        ret: rows
      });
    });
  };

  ResultsQuery.prototype.summaryByProfile = function(cb, profile) {
    return db.all("SELECT session_id, description, additional_kargs, c_time, (SUM(is_success) <> COUNT(belong_to_session)) as state FROM env_list, results where profile=\"" + profile + "\" and session_id=belong_to_session group by session_id order by c_time DESC", function(err, rows) {
      return cb.json({
        ret: rows
      });
    });
  };

  ResultsQuery.prototype.detailBySessionID = function(cb, session_id) {
    return db.all("select rowid, testcase, is_success, annotations from results where belong_to_session=\"" + session_id + "\"", function(err, rows) {
      return cb.json({
        ret: rows
      });
    });
  };

  return ResultsQuery;

})();

module.exports = ResultsQuery;
