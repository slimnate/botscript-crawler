require 'test_helper'

class ScriptCrawlerTest < ActiveSupport::TestCase
  test "self.use_browser is defined" do
    assert defined? self.use_browser == "method"
  end

  test "self.use_browser is defined" do
    assert definedself.use_browser
  end
end
