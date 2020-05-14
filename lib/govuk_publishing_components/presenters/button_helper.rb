require "action_view"

module GovukPublishingComponents
  module Presenters
    class ButtonHelper
      attr_reader :href,
                  :text,
                  :title,
                  :info_text,
                  :info_text_classes,
                  :rel,
                  :data_attributes,
                  :margin_bottom,
                  :inline_layout,
                  :target,
                  :type,
                  :start,
                  :secondary,
                  :secondary_quiet,
                  :destructive,
                  :name,
                  :value,
                  :classes,
                  :aria_label

      def initialize(local_assigns)
        @href = local_assigns[:href]
        @text = local_assigns[:text]
        @title = local_assigns[:title]
        @info_text = local_assigns[:info_text]
        @info_text_classes = %w[gem-c-button__info-text]
        if local_assigns[:margin_bottom]
          @info_text_classes << "gem-c-button__info-text--bottom-margin"
        end
        @rel = local_assigns[:rel]
        @data_attributes = local_assigns[:data_attributes]
        @margin_bottom = local_assigns[:margin_bottom]
        @inline_layout = local_assigns[:inline_layout]
        @target = local_assigns[:target]
        @type = local_assigns[:type]
        @start = local_assigns[:start]
        @secondary = local_assigns[:secondary]
        @secondary_quiet = local_assigns[:secondary_quiet]
        @destructive = local_assigns[:destructive]
        @name = local_assigns[:name]
        @value = local_assigns[:value]
        if local_assigns.include?(:classes)
          @classes = local_assigns[:classes].split(" ")
          unless @classes.all? { |c| c.start_with?("js-") }
            raise(ArgumentError, "The button component expects classes to be prefixed with `js-`")
          end
        end
        @aria_label = local_assigns[:aria_label]
      end

      def link?
        href.present?
      end

      def html_options
        options = { class: css_classes }
        options[:role] = "button" if link?
        options[:type] = button_type
        options[:rel] = rel if rel
        options[:data] = data_attributes if data_attributes
        options[:title] = title if title
        options[:target] = target if target
        options[:name] = name if name.present? && value.present?
        options[:value] = value if name.present? && value.present?
        options[:aria] = { label: aria_label } if aria_label
        options
      end

      def button_type
        type || "submit" unless link?
      end

    private

      def css_classes
        css_classes = %w[gem-c-button govuk-button]
        css_classes << "govuk-button--start" if start
        css_classes << "gem-c-button--secondary" if secondary
        css_classes << "gem-c-button--secondary-quiet" if secondary_quiet
        css_classes << "govuk-button--warning" if destructive
        css_classes << "gem-c-button--bottom-margin" if margin_bottom && !info_text
        css_classes << "gem-c-button--inline" if inline_layout
        css_classes << classes if classes
        css_classes.join(" ")
      end
    end
  end
end
