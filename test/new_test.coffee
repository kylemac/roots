rimraf        = require 'rimraf'
test_tpl_path = 'https://github.com/jenius/sprout-test-template.git'
new_path      = path.join(base_path, 'new/testing')

describe 'new', ->

  afterEach -> rimraf.sync(new_path)

  it 'should reject if not given a path', (done) ->
    Roots.new().should.be.rejected.notify(done)

  it 'should create a project', (done) ->
    spy = sinon.spy()

    Roots.new
      path: new_path
      overrides: { name: 'testing', description: 'wow' }
    .progress(spy)
    .catch(done)
    .done (proj) ->
      proj.root.should.exist
      spy.should.have.callCount(4)
      spy.should.have.been.calledWith('base template added')
      spy.should.have.been.calledWith('project created')
      spy.should.have.been.calledWith('dependencies installing')
      spy.should.have.been.calledWith('dependencies finished installing')
      done()

  it 'should create a project with another template if provided', (done) ->
    Roots.template.add(name: 'foobar', uri: test_tpl_path)
      .then ->
        Roots.new(path: new_path, overrides: { foo: 'bar' }, template: 'foobar')
      .then ->
        util.file.exists('new/testing/index.html').should.be.true
      .then ->
        Roots.template.remove(name: 'foobar')
      .catch(done)
      .done(done.bind(null, null))
