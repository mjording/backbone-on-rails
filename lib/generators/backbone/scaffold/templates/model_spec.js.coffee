describe "<%= model_namespace %>", ->
  describe "when instantiated", ->
    it "should return cid", ->
      model_instance = new <%= model_namespace %>(title: "Rake leaves")
      expect(model_instance.get("cid")).toBeDefined();
