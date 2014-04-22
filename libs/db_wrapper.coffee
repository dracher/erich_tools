sqlite3 = require('sqlite3').verbose()
fs = require('fs')
async = require('async')
db = new sqlite3.Database('../results.sqlite')

class ResultsQuery

  profileAll: (cb) ->
    db.all('select DISTINCT "profile" from env_list order by c_time DESC',
      (err, rows) ->
        cb.json({ret: rows})
    )

  summaryByProfile: (cb, profile) ->
    db.all("SELECT session_id, description, additional_kargs, c_time, (SUM(is_success) <> COUNT(belong_to_session)) as state \
      FROM env_list, results \
      where profile=\"#{profile}\" and session_id=belong_to_session \
      group by session_id \
      order by c_time \
      DESC",
      (err, rows) ->
#        console.log(err)
#        console.log(rows)
        cb.json({ret: rows})
    )


module.exports = ResultsQuery