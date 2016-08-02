expect = chai.expect
SimpleUploader = require '../src/simple-uploader'

describe 'SimpleUploader', ->
  beforeEach ->
    @server = sinon.fakeServer.create()
    @server.respondWith "POST", "/upload", [
      200,
      {"Content-Type": "application/json"},
      '{"success": true}'
    ]

    @uploader = new SimpleUploader
      url: '/upload'
    @file = new Blob ['This is a test file'],
      type: 'text/plain'


  afterEach ->
    @server.restore()
    @server = null
    @uploader.destroy()
    @uploader = null
    @file = null

  it 'should set instance variables when initializing', ->
    expect(@uploader).to.be.instanceof SimpleUploader
    expect(@uploader.files).to.be.instanceof(Array)
    expect(@uploader.files).to.be.empty
    expect(@uploader.queue).to.be.instanceof(Array)
    expect(@uploader.queue).to.be.empty
    expect(@uploader.uploading).to.be.false

  it 'should trigger several events during uploading process', ->
    beforeUploadSpy = sinon.spy()
    uploadProgressSpy = sinon.spy()
    uploadSuccessSpy = sinon.spy()
    uploadCompleteSpy = sinon.spy()
    @uploader.on 'beforeupload', beforeUploadSpy
    @uploader.on 'uploadprogress', uploadProgressSpy
    @uploader.on 'uploadsuccess', uploadSuccessSpy
    @uploader.on 'uploadcomplete', uploadCompleteSpy

    @uploader.upload @file
    @server.respond()

    matchFile = sinon.match(url: '/upload')
    expect(beforeUploadSpy.calledWith(sinon.match.object, matchFile))
      .to.be.true
    expect(uploadProgressSpy.called).to.be.true
    expect(uploadSuccessSpy.calledWith(sinon.match.object, matchFile, sinon.match(success: true)))
      .to.be.true
    expect(uploadCompleteSpy.calledWith(sinon.match.object, matchFile, '{"success": true}'))
      .to.be.true

  it 'should trigger uploaderror event when uploading fails', ->
    uploadErrorSpy = sinon.spy()
    @uploader.on 'uploaderror', uploadErrorSpy

    @server.respondWith "POST", "/upload", [
      500,
      {"Content-Type": "application/json"},
      '{"success": false}'
    ]

    @uploader.upload [@file]
    @server.respond()

    matchFile = sinon.match(url: '/upload')
    expect(uploadErrorSpy.calledWith(sinon.match.object, matchFile, sinon.match.object, sinon.match.string))
      .to.be.true

  it 'should cancel uploading if beforeupload event returns false', ->
    xhrUploadSpy = sinon.spy @uploader, '_xhrUpload'
    beforeUploadStub = sinon.stub()
    beforeUploadStub.returns false
    @uploader.on 'beforeupload', beforeUploadStub

    @uploader.upload @file
    expect(@uploader.files).to.be.empty
    expect(@uploader.uploading).to.be.false
    expect(xhrUploadSpy.called).to.be.false

  it 'can cancel uploading during uploading process', ->
    uploadCancelSpy = sinon.spy()
    @uploader.on 'uploadcancel', uploadCancelSpy

    @uploader.upload @file
    expect(@uploader.files.length).to.be.equal 1

    file = @uploader.files[0]
    @uploader.cancel file.id
    expect(@uploader.files).to.be.empty
    expect(uploadCancelSpy.calledWith sinon.match.object, file).to.be.true

  it 'can read image file', (done) ->
    spy = sinon.spy()
    file = new Blob ['This is a image file'],
      type: 'image/png'

    @uploader.readImageFile file, (img) ->
      expect(img).to.be.false
      done()
