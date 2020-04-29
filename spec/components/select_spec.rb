require "rails_helper"

describe "Select", type: :view do
  def component_name
    "select"
  end

  it "does not render anything if no data is passed" do
    assert_empty render_component({})
  end

  it "does not render if items are passed but no id is passed" do
    assert_empty render_component(
      label: "My label",
      options: [
        {
          value: "government-gateway",
          text: "Use Government Gateway",
        },
      ],
    )
  end

  it "does not render if items are passed but no label is passed" do
    assert_empty render_component(
      id: "mydropdown",
      options: [
        {
          value: "government-gateway",
          text: "Use Government Gateway",
        },
      ],
    )
  end

  it "does not render if no items are passed" do
    assert_empty render_component(id: "mydropdown", label: "My label", options: [])
  end

  it "renders a select box with one item" do
    render_component(
      id: "mydropdown",
      label: "My dropdown",
      options: [
        {
          value: "government-gateway",
          text: "Use Government Gateway",
        },
      ],
    )

    assert_select "select[name=mydropdown][id=mydropdown]"
    assert_select ".govuk-label[for=mydropdown]", text: "My dropdown"
    assert_select ".govuk-select option[value=government-gateway]"
  end

  it "renders a select box with multiple items" do
    render_component(
      id: "mydropdown",
      label: "My dropdown",
      options: [
        {
          value: "big",
          text: "Big",
        },
        {
          value: "medium",
          text: "Medium",
        },
        {
          value: "small",
          text: "Small",
        },
      ],
    )

    assert_select ".govuk-select option[value=big]"
    assert_select ".govuk-select option[value=small]"
    assert_select ".govuk-select option[value=medium]"
  end

  it "can accept an id and a name" do
    render_component(
      id: "mydropdown",
      label: "My dropdown",
      name: "somethingelse",
      options: [
        {
          value: "government-gateway",
          text: "Use Government Gateway",
        },
      ],
    )

    assert_select "select[name=somethingelse][id=mydropdown]"
  end

  it "renders a select a preselected item" do
    render_component(
      id: "mydropdown",
      label: "My dropdown",
      options: [
        {
          value: "big",
          text: "Big",
        },
        {
          value: "medium",
          text: "Medium",
          selected: true,
        },
        {
          value: "small",
          text: "Small",
        },
      ],
    )

    assert_select ".govuk-select option[value=medium][selected]"
  end

  it "enables tracking if track_category and track_action passed" do
    render_component(
      id: "mydropdown",
      label: "attributes",
      options: [
        {
          value: 1,
          text: "One",
          data_attributes: {
            track_category: "category",
            track_action: "action",
            track_options: {
              dimension28: 28,
              dimension29: "twentynine",
            },
          },
        },
      ],
    )

    assert_select ".gem-c-select [data-module=track-select-change]"
  end

  it "renders a select with data attributes" do
    render_component(
      id: "mydropdown",
      label: "attributes",
      options: [
        {
          value: 1,
          text: "One",
          data_attributes: {
            track_category: "category",
            track_action: "action",
            track_options: {
              dimension28: 28,
              dimension29: "twentynine",
            },
          },
        },
      ],
    )

    assert_select ".govuk-select option[value=1][data-track-category='category'][data-track-action='action'][data-track-options='{\"dimension28\":28,\"dimension29\":\"twentynine\"}']"
  end

  it "does not enable tracking for other data attributes" do
    render_component(
      id: "mydropdown",
      label: "attributes",
      options: [
        {
          value: 1,
          text: "One",
          data_attributes: {
            another_attribute: "test1",
            second_item: "item1",
            option: "option1",
          },
        },
      ],
    )

    assert_select ".gem-c-select [data-module=track-select-change]", false
    assert_select ".gem-c-select [data-another-attribute=test1][data-second-item=item1][data-option=option1]"
  end

  it "renders a select box in an error state" do
    render_component(
      id: "mydropdown",
      label: "My dropdown",
      error_message: "Please choose an option",
      error_id: "error_id",
      options: [
        {
          value: "government-gateway",
          text: "Use Government Gateway",
        },
      ],
    )

    assert_select ".govuk-form-group.gem-c-select.govuk-form-group--error"
    assert_select ".gem-c-error-message.govuk-error-message", text: "Error: Please choose an option"
    assert_select ".govuk-select.govuk-select--error[aria-describedby=error_id]"
  end

  it "applies aria-describedby if an error is is given" do
    render_component(
      id: "mydropdown",
      label: "My dropdown",
      error_id: "error_id",
      options: [
        {
          value: "government-gateway",
          text: "Use Government Gateway",
        },
      ],
    )

    assert_select ".gem-c-error-message.govuk-error-message", false
    assert_select ".govuk-select.govuk-select--error[aria-describedby=error_id]"
  end

  it "renders a select box full width" do
    render_component(
      id: "mydropdown",
      label: "My dropdown",
      full_width: true,
      options: [
        {
          value: "government-gateway",
          text: "Use Government Gateway",
        },
      ],
    )

    assert_select "select[name=mydropdown]"
    assert_select ".gem-c-select .gem-c-select__select--full-width"
  end

  it "renders a select box with a custom label size" do
    render_component(
      id: "mydropdown",
      label: "My dropdown",
      heading_size: "s",
      options: [
        {
          value: "government-gateway",
          text: "Use Government Gateway",
        },
      ],
    )

    assert_select ".govuk-label.govuk-label--s"
  end
end
