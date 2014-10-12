(function() {
  describe('simple uploader', function() {
    beforeEach(function() {
      return jasmine.Ajax.install();
    });
    afterEach(function() {
      return jasmine.Ajax.uninstall();
    });
    return it('should trigger several events while uploading', function() {
      var callback, file, request, uploader;
      uploader = simple.uploader({
        url: '/upload'
      });
      file = new Blob(['This is a test file'], {
        type: 'text/plain'
      });
      callback = {
        beforeupload: jasmine.createSpy('beforeupload'),
        uploadprogress: jasmine.createSpy('uploadprogress'),
        uploadsuccess: jasmine.createSpy('uploadsuccess')
      };
      uploader.on('beforeupload', function(e, file) {
        return callback.beforeupload();
      });
      uploader.on('uploadprogress', function(e, file, loaded, total) {
        return callback.uploadprogress();
      });
      uploader.on('uploadsuccess', function(e, file, result) {
        callback.uploadsuccess();
        return expect(result != null ? result.success : void 0).toBe(true);
      });
      uploader.upload(file);
      request = jasmine.Ajax.requests.mostRecent();
      expect(request.url).toBe('/upload');
      expect(callback.beforeupload).toHaveBeenCalled();
      expect(callback.uploadprogress).not.toHaveBeenCalled();
      expect(callback.uploadsuccess).not.toHaveBeenCalled();
      request.response({
        status: 200,
        contentType: 'application/json',
        responseText: '{"success": true}'
      });
      expect(callback.uploadprogress).toHaveBeenCalled();
      return expect(callback.uploadsuccess).toHaveBeenCalled();
    });
  });

}).call(this);
