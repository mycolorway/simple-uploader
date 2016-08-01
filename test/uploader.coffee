expect = chai.expect
SimpleUploader = require '../src/uploader'

describe 'SimpleUploader', ->
  beforeEach ()->
    @server = sinon.fakeServer.create()

  afterEach ()->
    @server.restore();


  it 'should trigger several events while uploading', ->
    uploader = new SimpleUploader
      url: '/upload'
    expect(uploader).to.be.ok

    file = new Blob ['This is a test file'],
      type: 'text/plain'

    callback =
      beforeupload: sinon.spy()
      uploadprogress: sinon.spy()
      uploadsuccess: sinon.spy()

    uploader.on 'beforeupload', (e, file) ->
      callback.beforeupload()

    uploader.on 'uploadprogress', (e, file, loaded, total) ->
      callback.uploadprogress()

    uploader.on 'uploadsuccess', (e, file, result) ->
      callback.uploadsuccess()
      expect(result?.success).to.equal(true)

    @server.respondWith "POST", "/upload", [
      200,
      {"Content-Type": "application/json"},
      '{"success": true}'
    ]
    uploader.upload file

    expect(callback.beforeupload.called).to.be.true
    expect(callback.uploadprogress.called).to.be.false
    expect(callback.uploadsuccess.called).to.be.false

    @server.respond();

    expect(callback.uploadprogress.called).to.be.true
    expect(callback.uploadsuccess.called).to.be.true


