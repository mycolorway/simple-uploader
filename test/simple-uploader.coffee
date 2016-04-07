describe 'SimpleUploader', ->

  it 'should inherit from SimpleModule', ->
    module = new SimpleUploader()
    expect(module instanceof SimpleModule).to.be.equal(true)
