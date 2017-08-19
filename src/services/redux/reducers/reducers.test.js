import reducers from './reducers'

describe('reducers', () => {
  it('combines the correct reducers', () => {
    const state = reducers(undefined, { type: 'FAKE' })

    expect(Object.keys(state)).toEqual(['apollo', 'form', 'lists', 'modals', 'routing', 'users'])
  })
})
