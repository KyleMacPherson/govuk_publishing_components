require "rails_helper"
require "rails_translation_manager"

RSpec.describe "locales files" do
  it "should meet all locale validation requirements" do
    checker = RailsTranslationManager::LocaleChecker.new("config/locales/*.yml")
    expect(checker.validate_locales).to be_truthy
  end
end
