if typeof module == 'object' and module.exports
  SimpleUploader = require '../simple-uploader'
else
  SimpleUploader = window.SimpleUploader

SimpleUploader.i18n.addResources 'en', 'translation',
  leaveConfirm: "There is files being uploaded on this page. \
    Are you sure to leave?"
