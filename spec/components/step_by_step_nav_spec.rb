require 'rails_helper'

describe "step nav", type: :view do
  def render_component(locals)
    render file: "govuk_publishing_components/components/_step_by_step_nav", locals: locals
  end

  def stepnav
    [
      {
        title: 'Step 1',
        show_help_link: true,
        optional: true,
        contents: [
          {
            type: 'paragraph',
            text: 'Step 1 paragraph'
          },
          {
            type: 'list',
            contents: [
              {
                href: '/link1',
                text: 'Link 1.1.1',
              },
              {
                href: 'http://www.gov.uk',
                text: 'Link 1.1.2',
                context: '£0 to £300'
              },
            ]
          },
          {
            type: 'substep',
            optional: false
          },
          {
            type: 'paragraph',
            text: 'This paragraph is inside a required substep'
          },
          {
            type: 'list',
            style: 'choice',
            contents: [
              {
                href: '/link3',
                text: 'Link 1.1.3',
              },
              {
                href: '/link4',
                text: 'Link 1.1.4'
              }
            ]
          },
        ]
      },
      {
        title: 'Step 1 and',
        optional: false,
        logic: "and",
        contents: [
          {
            type: 'paragraph',
            text: 'Step 1 and paragraph'
          }
        ]
      },
      {
        title: 'Step 2',
        contents: [
          {
            type: 'paragraph',
            text: 'Step 2 paragraph'
          },
          {
            type: 'list',
            style: 'choice',
            contents: [
              {
                href: '/link5',
                text: 'Link 2.1.1',
              },
              {
                href: '/link6',
                active: true,
                text: 'Link 2.1.2',
              },
            ]
          },
          {
            type: 'substep',
            optional: true
          },
          {
            type: 'paragraph',
            text: 'This paragraph is inside an optional substep'
          },
        ]
      },
      {
        title: 'Step 2 or',
        logic: 'or',
        contents: [
          {
            type: 'paragraph',
            text: 'test'
          },
          {
            type: 'list',
            contents: [
              {
                href: '/link7',
                text: 'Link 2.2.1'
              },
              {
                text: 'or'
              },
              {
                href: '/link8',
                text: 'Link 2.2.2'
              }
            ]
          },
          {
            type: 'heading',
            text: 'This is a heading'
          }
        ]
      },
      {
        title: 'Step 3?"`_!',
        contents: [
          {
            type: 'paragraph',
            text: 'test'
          }
        ]
      }
    ]
  end

  step1 = ".gem-c-step-nav__step:nth-of-type(1)"
  step1and = ".gem-c-step-nav__step:nth-of-type(2)"
  step2 = ".gem-c-step-nav__step:nth-of-type(3)"
  step2or = ".gem-c-step-nav__step:nth-of-type(4)"
  step3 = ".gem-c-step-nav__step:nth-of-type(5)"

  it "renders nothing without passed content" do
    assert_empty render_component({})
  end

  it "renders paragraphs" do
    render_component(steps: stepnav)
    assert_select ".gem-c-step-nav"

    assert_select ".gem-c-step-nav__step#step-1"
    assert_select step1 + " .gem-c-step-nav__title .js-step-title", text: "Step 1"
    assert_select step1 + " .gem-c-step-nav__paragraph", text: "Step 1 paragraph"

    assert_select ".gem-c-step-nav__step#step-2"
    assert_select step2 + " .gem-c-step-nav__title .js-step-title", text: "Step 2"
    assert_select step2 + " .gem-c-step-nav__paragraph", text: "Step 2 paragraph"
  end

  it "renders headings" do
    render_component(steps: stepnav)

    assert_select step2or + " h3.gem-c-step-nav__heading", text: "This is a heading"
  end

  it "renders a stepnav with different heading levels" do
    render_component(steps: stepnav, heading_level: 4)

    assert_select step1 + " h4.gem-c-step-nav__title .js-step-title", text: "Step 1"
    assert_select step2 + " h4.gem-c-step-nav__title .js-step-title", text: "Step 2"
  end

  it "renders headings correctly if the heading level is changed" do
    render_component(steps: stepnav, heading_level: 4)

    assert_select step2or + " h5.gem-c-step-nav__heading", text: "This is a heading"
  end

  it "opens a step by default" do
    render_component(steps: stepnav, show_step: 2)

    assert_select ".gem-c-step-nav__step#step-1-and[data-show]"
  end

  it "remembers last opened step" do
    render_component(steps: stepnav, remember_last_step: true)

    assert_select ".gem-c-step-nav[data-remember]"
  end

  it "generates IDs for steps correctly" do
    render_component(steps: stepnav)

    assert_select step1 + " #step-panel-step-1-1.gem-c-step-nav__panel"
    assert_select step1and + " #step-panel-step-1-and-2.gem-c-step-nav__panel"
    assert_select step3 + "#step-3"
  end

  it "renders correct list elements and includes length of lists" do
    render_component(steps: stepnav)

    assert_select step1 + " ul.gem-c-step-nav__links--choice[data-length='2']"
    assert_select step2or + " ol.gem-c-step-nav__links[data-length='3']"
  end

  it "renders links and link attributes correctly" do
    render_component(steps: stepnav)

    assert_select step1 + " .gem-c-step-nav__link-item[href='/link1'][data-position='1.1']", text: "Link 1.1.1"
    assert_select step1 + " .gem-c-step-nav__link-item[href='/link1'][rel='external']", false
    assert_select step1 + " .gem-c-step-nav__link-item[href='http://www.gov.uk'][rel='external'][data-position='1.2']", text: "Link 1.1.2 £0 to £300"
    assert_select step1 + " .gem-c-step-nav__link-item[href='http://www.gov.uk'] .gem-c-step-nav__context", text: "£0 to £300"
    assert_select step1 + " .gem-c-step-nav__link-item[href='/link3'][data-position='1.3']", text: "Link 1.1.3"
    assert_select step1 + " .gem-c-step-nav__link-item[href='/link4'][data-position='1.4']", text: "Link 1.1.4"
    assert_select step2or + " .gem-c-step-nav__link-item[href='/link8'][data-position='4.2']", text: "Link 2.2.2"
  end

  it "renders links without hrefs" do
    render_component(steps: stepnav)

    assert_select step2or + " .gem-c-step-nav__link .gem-c-step-nav__link-item[href='/link7'][data-position='4.1']", text: "Link 2.2.1"
    assert_select step2or + " .gem-c-step-nav__link", text: "or"
    assert_select step2or + " .gem-c-step-nav__link .gem-c-step-nav__link-item[href='/link8'][data-position='4.2']", text: "Link 2.2.2"
  end

  it "renders optional steps, sub steps and optional sub steps" do
    render_component(steps: stepnav)

    assert_select ".gem-c-step-nav__step#step-1.gem-c-step-nav__step--optional"
    assert_select step1 + " .gem-c-step-nav__substep .gem-c-step-nav__paragraph", text: "This paragraph is inside a required substep"
    assert_select step2 + " .gem-c-step-nav__substep.gem-c-step-nav__substep--optional .gem-c-step-nav__paragraph", text: "This paragraph is inside an optional substep"
  end

  it "renders get help links back to the main step nav" do
    render_component(steps: stepnav, step_nav_url: "/learn-to-drive", step_nav_link_text: "Get help")

    assert_select step1 + " .gem-c-step-nav__help-link[href='/learn-to-drive#step-1']", text: "Get help"
    assert_select step2 + " .gem-c-step-nav__help-link[href='/learn-to-drive#step-2']", false
  end

  it "displays step numbering and step logic correctly" do
    render_component(steps: stepnav)

    assert_select step1 + " .gem-c-step-nav__circle--number .gem-c-step-nav__circle-inner .gem-c-step-nav__circle-background", text: "Step 1"
    assert_select step1and + " .gem-c-step-nav__circle--logic .gem-c-step-nav__circle-inner .gem-c-step-nav__circle-background", text: "and"
    assert_select step2 + " .gem-c-step-nav__circle--number .gem-c-step-nav__circle-inner .gem-c-step-nav__circle-background", text: "Step 2"
    assert_select step2or + " .gem-c-step-nav__circle--logic .gem-c-step-nav__circle-inner .gem-c-step-nav__circle-background", text: "or"
  end

  it "applies the correct styles to lists" do
    render_component(steps: stepnav)

    assert_select step2 + " .gem-c-step-nav__links.gem-c-step-nav__links--choice"
  end

  it "allows steps to be open on page load" do
    render_component(steps: stepnav, show_step: 3)

    assert_select ".gem-c-step-nav__step#step-2[data-show]"
  end

  it "can set active states on steps and links" do
    render_component(steps: stepnav, highlight_step: 1)

    assert_select ".gem-c-step-nav__step--active#step-1"
    assert_select step2 + " .gem-c-step-nav__link.gem-c-step-nav__link--active .gem-c-step-nav__link-item[href='#content']", text: "You are currently viewing: Link 2.1.2"
  end

  it "renders a small stepnav" do
    render_component(steps: stepnav, small: true)

    assert_select ".gem-c-step-nav"
    assert_select ".gem-c-step-nav.gem-c-step-nav--large", false
  end

  it "adds a tracking id" do
    render_component(steps: stepnav, tracking_id: "harold")

    assert_select ".gem-c-step-nav[data-id='harold']"
  end
end
