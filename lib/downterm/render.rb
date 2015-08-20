require 'highline'
require 'rainbow'
require 'redcarpet'

module Downterm
  module Render
    class Terminal < Redcarpet::Render::Base
      def paragraph(text)
        text
      end

      def normal_text(text)
        text
      end

      def linebreak
        "\n"
      end

      def header(text, header_level)
        "#{'#' * header_level} #{text}\n"
      end

      def entity(text)
        case text
        when "&gt;"  then return ">"
        when "&lt;"  then return "<"
        when "&amp;" then return "&"
        else              return text
        end
      end

      def emphasis(text)
        Rainbow(text).underline.to_s
      end

      def double_emphasis(text)
        Rainbow(text).bright.to_s
      end

      def link(link, link_title, content)
        "#{Rainbow(content).underline} <#{link}>"
      end

      def autolink(link, link_type)
        Rainbow(link).underline.to_s
      end

      def image(link, title, content)
        Rainbow(link).underline.to_s
      end

      def codespan(code)
        "`#{code}`"
      end

      def block_code(code, language)
        code.split("\n").map { |line| "    #{line}\n"}.join("")
      end

      def block_quote(quote)
        quote.split("\n").map { |line| "> #{line}" }.join("\n") + "\n"
      end

      def block_html(raw_html)
        raw_html
      end

      def strikethrough(text)
        Rainbow(text).hide.to_s
      end

      def list(contents, list_type)
        case list_type
        when :unordered then return contents
        when :ordered   then return number_list(contents.split("\n")).join("\n") + "\n"
        end
      end

      def list_item(text, list_type)
        case list_type
        when :unordered then return "* #{text}"
        when :ordered   then return "#{text}"
        end
      end

      def hrule
        '-' * HighLine::SystemExtensions.terminal_size[0] + "\n"
      end

      private

      def number_list(items)
        width = items.count.to_s.length
        (1..items.count).zip(items).map { |e| sprintf("%*d. %s", width, e[0], e[1]) }
      end
    end
  end
end
