express = require('express')
router = express.Router()

ResultQuery = require('../libs/db_wrapper')

rq = new ResultQuery


router.get('/profile/all', (req, res)->
  rq.profileAll(res)
)

router.get('/profile/by/:name', (req, res)->
  rq.summaryByProfile(res, req.params.name)
)

router.get('/details/by/:session_id', (req, res)->
  rq.detailBySessionID(res, req.params.session_id)
)

router.get('/log/by/:session_id/:name', (req, res)->
  rq.fullLogBySessionIDCaseName(res,
                                req.params.session_id,
                                req.params.name)
)

module.exports = router