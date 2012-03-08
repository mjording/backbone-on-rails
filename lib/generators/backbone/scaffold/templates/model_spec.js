describe("<%= model_namespace %>", function () {
  describe('when instantiated', function() {
    it('should return cid', function() {
      var model_instance = new <%= model_namespace %>();
      expect(model_instance.get('cid')).toBeDefined();
    });
  });
});
