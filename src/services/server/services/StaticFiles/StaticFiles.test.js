import express from 'express'
import request from 'supertest'

import StaticFiles from './StaticFiles'

describe('StaticFiles', () => {
  let app, get, req

  beforeEach(() => {
    app = express()
    app.use(StaticFiles)
    req = request(app)
    get = req.get
  })

  it('GET /public/favicon.ico', () => get('/public/favicon.ico').expect(200))

  it('GET /public/FILE_THAT_DOESNT_EXIST', () => get('/public/FILE_THAT_DOESNT_EXIST').expect(404))
})
