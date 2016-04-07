/**
 * simple-uploader v0.0.1
 * http://mycolorway.github.io/simple-uploader
 *
 * Copyright Mycolorway Design
 * Released under the MIT license
 * http://mycolorway.github.io/simple-uploader/license.html
 *
 * Date: 2016-03-28
 */

(function() {
  var SimpleModule, SimpleUploader, _, i18next, isNode,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  if ((isNode = typeof module === 'object' && module.exports)) {
    SimpleModule = require('simple-module');
    _ = require('lodash');
    i18next = require('i18next');
  } else {
    SimpleModule = window.SimpleModule;
    _ = window._;
    i18next = window.i18next;
  }

  SimpleUploader = (function(superClass) {
    extend(SimpleUploader, superClass);

    SimpleUploader.count = 0;

    SimpleUploader.opts = {
      url: '',
      params: null,
      fileKey: 'upload_file',
      connectionCount: 3
    };

    SimpleUploader.i18n = i18next.init({
      lng: 'en',
      fallbackLng: 'en'
    });

    function SimpleUploader(opts) {
      SimpleUploader.__super__.constructor.call(this);
      _.extend(this.opts, SimpleUploader.opts, opts);
      if (this.opts.lang) {
        SimpleUploader.changeLanguage(this.opts.lang);
      }
      this.files = [];
      this.queue = [];
      this.id = ++SimpleUploader.count;
      this._bind();
    }

    SimpleUploader.prototype._bind = function() {
      this.on('uploadcomplete', (function(_this) {
        return function(e, file) {
          _this.files.splice(_this.files.indexOf(file), 1);
          if (_this.queue.length > 0 && _this.files.length < _this.opts.connectionCount) {
            return _this.upload(_this.queue.shift());
          } else if (_this.files.length === 0) {
            _this.uploading = false;
            return _this.triger('uploadstop');
          }
        };
      })(this));
      return $(window).on('beforeunload.uploader-' + this.id, (function(_this) {
        return function(e) {
          if (!_this.uploading) {
            return;
          }
          e.originalEvent.returnValue = _this._t('leaveConfirm');
          return _this._t('leaveConfirm');
        };
      })(this));
    };

    SimpleUploader.prototype.generateId = (function() {
      var id;
      id = 0;
      return function() {
        return id += 1;
      };
    })();

    SimpleUploader.prototype.upload = function(file, opts) {
      var f, i, key, len;
      if (opts == null) {
        opts = {};
      }
      if (file == null) {
        return;
      }
      if (_.isArray(file) || file instanceof FileList) {
        for (i = 0, len = file.length; i < len; i++) {
          f = file[i];
          this.upload(f, opts);
        }
      } else if ($(file).is('input:file')) {
        key = $(file).attr('name');
        if (key) {
          opts.fileKey = key;
        }
        this.upload($.makeArray($(file)[0].files), opts);
      } else if (!file.id || !file.obj) {
        file = this.getFile(file);
      }
      if (!(file && file.obj)) {
        return;
      }
      _.extend(file, opts);
      if (this.files.length >= this.opts.connectionCount) {
        this.queue.push(file);
        return;
      }
      if (this.triggerHandler('beforeupload', [file]) === false) {
        return;
      }
      this.files.push(file);
      this._xhrUpload(file);
      return this.uploading = true;
    };

    SimpleUploader.prototype.getFile = function(fileObj) {
      var name, ref, ref1;
      if (fileObj instanceof window.File || fileObj instanceof window.Blob) {
        name = (ref = fileObj.fileName) != null ? ref : fileObj.name;
      } else {
        return null;
      }
      return {
        id: this.generateId(),
        url: this.opts.url,
        params: this.opts.params,
        fileKey: this.opts.fileKey,
        name: name,
        size: (ref1 = fileObj.fileSize) != null ? ref1 : fileObj.size,
        ext: name ? name.split('.').pop().toLowerCase() : '',
        obj: fileObj
      };
    };

    SimpleUploader.prototype._xhrUpload = function(file) {
      var formData, k, ref, v;
      formData = new FormData();
      formData.append(file.fileKey, file.obj);
      formData.append("original_filename", file.name);
      if (file.params) {
        ref = file.params;
        for (k in ref) {
          v = ref[k];
          formData.append(k, v);
        }
      }
      return file.xhr = $.ajax({
        url: file.url,
        data: formData,
        processData: false,
        contentType: false,
        type: 'POST',
        headers: {
          'X-File-Name': encodeURIComponent(file.name)
        },
        xhr: function() {
          var req;
          req = $.ajaxSettings.xhr();
          if (req) {
            req.upload.onprogress = (function(_this) {
              return function(e) {
                return _this.progress(e);
              };
            })(this);
          }
          return req;
        },
        progress: (function(_this) {
          return function(e) {
            if (!e.lengthComputable) {
              return;
            }
            return _this.trigger('uploadprogress', [file, e.loaded, e.total]);
          };
        })(this),
        error: (function(_this) {
          return function(xhr, status, err) {
            return _this.trigger('uploaderror', [file, xhr, status]);
          };
        })(this),
        success: (function(_this) {
          return function(result) {
            _this.trigger('uploadprogress', [file, file.size, file.size]);
            _this.trigger('uploadsuccess', [file, result]);
            return $(document).trigger('uploadsuccess', [file, result, _this]);
          };
        })(this),
        complete: (function(_this) {
          return function(xhr, status) {
            return _this.trigger('uploadcomplete', [file, xhr.responseText]);
          };
        })(this)
      });
    };

    SimpleUploader.prototype.cancel = function(file) {
      var f, i, len, ref;
      if (!file.id) {
        ref = this.files;
        for (i = 0, len = ref.length; i < len; i++) {
          f = ref[i];
          if (f.id === file * 1) {
            file = f;
            break;
          }
        }
      }
      this.trigger('uploadcancel', [file]);
      if (file.xhr) {
        file.xhr.abort();
      }
      return file.xhr = null;
    };

    SimpleUploader.prototype.readImageFile = function(fileObj, callback) {
      var fileReader, img;
      if (!_.isFunction(callback)) {
        return;
      }
      img = new Image();
      img.onload = function() {
        return callback(img);
      };
      img.onerror = function() {
        return callback();
      };
      if (window.FileReader && FileReader.prototype.readAsDataURL && /^image/.test(fileObj.type)) {
        fileReader = new FileReader();
        fileReader.onload = function(e) {
          return img.src = e.target.result;
        };
        return fileReader.readAsDataURL(fileObj);
      } else {
        return callback();
      }
    };

    SimpleUploader.prototype.destroy = function() {
      var file, i, len, ref;
      this.queue.length = 0;
      ref = this.files;
      for (i = 0, len = ref.length; i < len; i++) {
        file = ref[i];
        this.cancel(file);
      }
      $(window).off('.uploader-' + this.id);
      return $(document).off('.uploader-' + this.id);
    };

    return SimpleUploader;

  })(SimpleModule);

  if (isNode) {
    require('i18n/en');
    module.exports = SimpleUploader;
  } else {
    window.SimpleUploader = SimpleUploader;
  }

}).call(this);
