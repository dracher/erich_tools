sqlite3 = require('sqlite3').verbose()
fs = require('fs')
log4js = require('log4js')
async = require('async')

db = new sqlite3.Database('../results.sqlite')
logger = log4js.getLogger('dbWrapper')


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

  detailBySessionID: (cb, session_id) ->
    db.all("select rowid, testcase, is_success, annotations from results where belong_to_session=\"#{session_id}\"",
      (err, rows) ->
        cb.json({ret: rows})
    )

  fullLogBySessionIDCaseName: (cb, sid, name) ->
    db.all("select artifacts from artifacts where belong_to_session=\"#{sid}\" and file_name like \"%#{name}%\"",
      (err, rows) ->
#        console.log(err)
#        console.log(rows)
        try
          cb.set('Content-Type', 'text/plain')
          cb.send(rows[0]['artifacts'])
        catch err
          logger.warn("With #{sid}/#{name} do not have a corresponding artifact in database")
          cb.set('Content-Type', 'text/plain')
          cb.send("No log found")
    )


module.exports = ResultsQuery

#rq = new ResultsQuery()
#rq.fullLogBySessionIDCaseName(null, 'icHBUuMVc2', 'set_admin_password.py')