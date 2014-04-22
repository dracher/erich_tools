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

module.exports = router