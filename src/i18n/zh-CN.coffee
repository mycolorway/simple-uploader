
if typeof module == 'object' and module.exports
  SimpleUploader = require '../simple-uploader'
else
  SimpleUploader = window.SimpleUploader

SimpleUploader.i18n.addResources 'zh-CN', 'translation',
  leaveConfirm: "有文件正在上传，确定要离开页面吗？"
