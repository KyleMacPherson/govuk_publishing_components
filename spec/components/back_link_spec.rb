require "rails_helper"

describe "Back Link", type: :view do
  def component_name
    "back_link"
  end

  it "fails to render a back link when no href is given" do
    assert_raises do
      render_component({})
    end
  end

  it "renders a back link correctly" do
    render_component(href: "/back-me")
    assert_select '.govuk-back-link[href="/back-me"]', text: "Back"
  end

  it "can render in welsh" do
    I18n.with_locale(:cy) { render_component(href: "/back-me") }
    assert_select '.govuk-back-link[href="/back-me"]', text: "Nôl"
  end

  it "renders a back link with data attributes" do
    render_component(href: "/back-me", data_attributes: { tracking: "GT-123" })
    assert_select '.govuk-back-link[data-tracking="GT-123"]'
  end
end
