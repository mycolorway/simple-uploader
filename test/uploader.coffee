expect = chai.expect
SimpleUploader = require '../src/uploader'

describe 'SimpleUploader', ->

  it 'should trigger several events while uploading', ->
    uploader = new SimpleUploader
      url: '/upload'
    expect(uploader).to.be.ok
    return

    file = new Blob ['This is a test file'],
      type: 'text/plain'

    callback =
      beforeupload: jasmine.createSpy 'beforeupload'
      uploadprogress: jasmine.createSpy 'uploadprogress'
      uploadsuccess: jasmine.createSpy 'uploadsuccess'

    uploader.on 'beforeupload', (e, file) ->
      callback.beforeupload()

    uploader.on 'uploadprogress', (e, file, loaded, total) ->
      callback.uploadprogress()

    uploader.on 'uploadsuccess', (e, file, result) ->
      callback.uploadsuccess()
      expect(result?.success).to.equal(true)

    uploader.upload file
    request = jasmine.Ajax.requests.mostRecent()

    expect(request.url).to.equal('/upload')
    expect(callback.beforeupload).toHaveBeenCalled()
    expect(callback.uploadprogress).not.toHaveBeenCalled()
    expect(callback.uploadsuccess).not.toHaveBeenCalled()

    request.response
      status: 200
      contentType: 'application/json'
      responseText: '{"success": true}'

    expect(callback.uploadprogress).toHaveBeenCalled()
    expect(callback.uploadsuccess).toHaveBeenCalled()

