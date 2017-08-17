# GOV.UK Publishing Components

A gem to document components in GOV.UK frontend applications.

![Screenshot of component guide](docs/screenshot.png)

## Write components in your application

Components are packages of template, style, behaviour and documentation that live in your application.

A component must:
* [meet the component principles](docs/component_principles.md)
* [follow component conventions](docs/component_conventions.md)

A lead paragraph component would be included in a template like this:

```erb
<%= render 'components/lead-paragraph', text: "A description is one or two leading sentences" %>
```

## Set up a component guide

This gem creates a component guide for all your application’s components.

An example guide this gem created for government-frontend:
https://government-frontend.herokuapp.com/component-guide

The guide includes your application’s `application.scss` and `application.js` files by default. This is [configurable](#configuration).

### Install gem

Add this line to your application's Gemfile in the [development and test groups](http://bundler.io/v1.12/groups.html#grouping-your-dependencies):

```ruby
gem 'govuk_publishing_components'
```

And then execute:
```bash
$ bundle
```

### Mount the component guide

Mount the component guide in your application:

```ruby
# config/routes.rb
unless Rails.env.production?
  mount GovukPublishingComponents::Engine, at: "/component-guide" if defined?(GovukPublishingComponents)
end
```

If your application was government-frontend the component guide would be at:
http://government-frontend.dev.gov.uk/component-guide

### Configure the gem

Use a config block in an initializer:

```ruby
# config/initializers/govuk_publishing_components.rb
if defined?(GovukPublishingComponents)
  GovukPublishingComponents.configure do |c|
    c.component_guide_title = "My component guide"

    c.application_stylesheet = "custom_stylesheet" # Defaults to "application"
    c.application_print_stylesheet = "print" # Not included by default
    c.application_javascript = "custom_javascript" # Defaults to "application"
  end
end
```

## Component generator

The gem includes a component generator to stub the minimal files required for a component.

```ruby
rails generate govuk_publishing_components:component [component_name]
```

This will create a template, scss file and yml documentation file for a new component. It will not create a test file as this cannot be reliably done automatically across applications, but a test file will be necessary.

## Licence

[MIT Licence](LICENCE.md)

## Development
For documentation on how to update and develop this gem see [DEVELOPMENT.md](./DEVELOPMENT.md)
