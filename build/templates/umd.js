;(function(root, factory) {
  if (typeof module === 'object' && module.exports) {
    module.exports = factory(<%= dependencies.cjs %>);
  } else {
    root.<%= name %> = factory(<%= dependencies.global %>);
  }
}(this, function (<%= dependencies.params %>) {
var define, module, exports;
var b = <%= contents %>
return b('<%= filename %>');
}));
