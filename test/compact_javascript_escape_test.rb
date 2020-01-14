require 'test_helper'
require 'angular-rails-templates/compact_javascript_escape'

describe AngularRailsTemplates::CompactJavaScriptEscape do
  let(:instance) do
    Class.new { include AngularRailsTemplates::CompactJavaScriptEscape }.new
  end

  it "responds to :escape_javascript" do
    _(instance).must_respond_to :escape_javascript
  end

  describe "#escape_javascript" do

    it "returns strings" do
      _(instance.escape_javascript("hello")).must_be_kind_of String
      _(instance.escape_javascript("")).     must_be_kind_of String
      _(instance.escape_javascript(nil)).    must_be_kind_of String
    end

    it "uses double quotes to wrap strings without quotes" do
      str = instance.escape_javascript("hello")
      _(str[0]).must_equal str[-1]
      _(str[0]).must_equal %(")
    end

    it "uses double quotes to wrap strings with many single quotes" do
      str = instance.escape_javascript(%{'hello'})
      _(str[0]).must_equal str[-1]
      _(str[0]).must_equal %(")
    end

    it "uses single quotes to wrap strings with many double quotes" do
      str = instance.escape_javascript(%{"hello"})
      _(str[0]).must_equal str[-1]
      _(str[0]).must_equal %(')
    end

    it "escapes single quotes when double quotes are used to wrap strings" do
      str = instance.escape_javascript(%{'h'e"l'lo'})
      _(str[0]).must_equal %(")
      _(str).must_match %{\\"}
      _(str).wont_match %{\\'}
    end

    it "escapes double quotes when single quotes are used to wrap strings" do
      str = instance.escape_javascript(%{"h"e'l"lo"})
      _(str[0]).must_equal %(')
      _(str).must_match %{\\'}
      _(str).wont_match %{\\"}
    end

    it "escapes backslashes" do
      str = instance.escape_javascript(%{a\\z})
      _(str).must_match %{a\\\\z}
    end
  end
end
