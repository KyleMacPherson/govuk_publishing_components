module GovukPublishingComponents
  module Components
    module TaskListHelper
      def render_task_list_element(element, options)
        @options = options
        @link_index = options[:link_index]

        case element[:type]
        when "paragraph"
          paragraph(element[:text])
        when "heading"
          heading(element[:text])
        when "list"
          list(element)
        end
      end

      # id should be lowercase, contain only numbers and letters and replace spaces with dashes
      def generate_task_list_id(step_title)
        step_title.downcase.tr(" ", "-").gsub(/[^a-z0-9\-\s]/i, '')
      end

    private

      def paragraph(text)
        content_tag(
          :p,
          text,
          class: 'gem-c-task-list__paragraph'
        )
      end

      def heading(text)
        content_tag(
          "h#{@options[:heading_level] + 1}",
          text,
          class: 'gem-c-task-list__heading'
        )
      end

      def list(element)
        content_tag(
          get_list_element(element[:style]),
          class: "gem-c-task-list__links #{get_list_style(element[:style])}",
          data: {
            length: element[:contents].length
          }
        ) do
          element[:contents].collect { |contents|
            concat(
              content_tag(
                'li',
                class: "gem-c-task-list__link js-list-item #{link_active(contents[:active])}"
              ) do
                concat(create_list_item_content(contents))
              end
            )
          }
        end
      end

      def create_list_item_content(link)
        if link[:href]
          @link_index += 1
          link_position = "data-position=\"#{@options[:group_index] + 1}.#{@options[:step_index] + 1}.#{@link_index}\""
          href = link_href(link[:active], link[:href])
          link_rel = href.start_with?('http') ? 'rel=external' : ''
          "<a href=\"#{href}\"
            class=\"gem-c-task-list__link-item js-link\"
            #{link_position}
            #{link_rel}>
            #{link_text(link[:active], link[:text])}
          </a>
          #{create_context(link[:context])}".html_safe
        else
          link[:text]
        end
      end

      def create_context(context)
        "<span class=\"gem-c-task-list__context\">#{context}</span>" if context
      end

      def get_list_style(style)
        if style == 'required'
          'gem-c-task-list__links--required'
        elsif style == 'choice'
          'gem-c-task-list__links--choice'
        end
      end

      def get_list_element(style)
        style == 'choice' ? 'ul' : 'ol'
      end

      def link_href(active, href)
        active ? "#content" : href
      end

      def link_text(active, text)
        active ? '<span class="visuallyhidden">You are currently viewing:</span> '.html_safe + text : text
      end

      def link_active(active)
        'gem-c-task-list__link--active' if active
      end
    end
  end
end
