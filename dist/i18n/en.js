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
  var SimpleUploader;

  if (typeof module === 'object' && module.exports) {
    SimpleUploader = require('../simple-uploader');
  } else {
    SimpleUploader = window.SimpleUploader;
  }

  SimpleUploader.i18n.addResources('en', 'translation', {
    leaveConfirm: "There is files being uploaded on this page. Are you sure to leave?"
  });

}).call(this);
