var fs = require('fs');

function collectCoverage(page) {
  var coverage = page.evaluate(function() {
    return window.__coverage__;
  });

  if (!coverage) {
    return;
  }

  var json = JSON.stringify(coverage);
  fs.write('coverage/coverage.json', json);
}

// beforeStart and afterEnd hooks for mocha-phantomjs
module.exports = {
  afterEnd: function(data) {
    collectCoverage(data.page);
  }
};
