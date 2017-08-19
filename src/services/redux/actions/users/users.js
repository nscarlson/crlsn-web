import { API1_HOST } from 'liiist-config'

class userApi {
  static async getCurrentSession () {
    const json = await (await fetch(`${API1_HOST}/users/me`, {
      credentials: 'include',
    })).json()

    return json
  }
}

const getCurrentSession = () => (dispatch) => userApi.getCurrentSession().then(session => {
  dispatch(loadSessionSuccess(session))
}).catch(() => {
  dispatch(loadSessionFail())
})

const loadSessionSuccess = (session) => ({
  session,
  type: 'LOAD_SESSION_SUCCESS',
})

const loadSessionFail = () => ({
  type: 'LOAD_SESSION_FAIL',
})

export { getCurrentSession, loadSessionFail, loadSessionSuccess }
