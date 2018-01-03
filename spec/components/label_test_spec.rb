require 'rails_helper'

describe "Label", type: :view do
  def render_component(locals)
    render file: "components/_label", locals: locals
  end

  it "does not render label when no data is given" do
    assert_raises do
      render_component({})
    end
  end

  it "renders label with text" do
    render_component(text: "National Insurance number")

    assert_select ".gem-c-label__text", text: "National Insurance number"
  end

  it "renders label with text and hint text" do
    render_component(
      text: "National Insurance number",
      hint_id: "should-match-aria-describedby-input",
      hint_text: "It’s on your National Insurance card, benefit letter, payslip or P60. For example, ‘QQ 12 34 56 C’."
    )

    assert_select ".gem-c-label__text", text: "National Insurance number"
    assert_select ".gem-c-label__hint", text: "It’s on your National Insurance card, benefit letter, payslip or P60. For example, ‘QQ 12 34 56 C’."
    assert_select ".gem-c-label__hint[id=should-match-aria-describedby-input]"
  end

  it "renders label with bold text" do
    render_component(text: "National Insurance number", bold: true)

    assert_select ".gem-c-label__text", text: "National Insurance number"
    assert_select ".gem-c-label--bold"
  end
end
