require 'rainbow'
require 'redcarpet'
require 'ttycaca'

module Downterm
  module Render
    class Terminal < Redcarpet::Render::Base
      def paragraph(text)
        "#{text}\n\n"
      end

      def normal_text(text)
        text
      end

      def linebreak
        "\n"
      end

      def header(text, header_level)
        "#{Rainbow(text).bright}\n\n"
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

      def triple_emphasis(text)
        Rainbow(text).bright.underline.to_s
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
        block = code.split("\n")
                    .map { |line| "    #{line}" }
                    .map { |line| line.gsub(/&gt;/, '>') }
                    .map { |line| line.gsub(/&lt;/, '<') }
                    .map { |line| line.gsub(/&amp;/, '&') }
                    .join("\n")
        "#{block}\n\n"
      end

      def block_quote(quote)
        trailing = quote[quote.rstrip.length..-1]
        quote.split("\n").map { |line| "    | #{line}" }.join("\n") + trailing
      end

      def block_html(raw_html)
        raw_html
      end

      def raw_html(raw_html)
        raw_html
      end

      def strikethrough(text)
        text
      end

      def superscript(text)
        if text.length > 1
          "^(#{text})"
        else
          "^#{text}"
        end
      end

      def list(contents, list_type)
        case list_type
        when :unordered then return contents + "\n"
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
        '-' * Ttycaca::Terminal.new.width + "\n\n"
      end

      def postprocess(full_document)
        full_document.rstrip
      end

      private

      def number_list(items)
        width = items.count.to_s.length
        (1..items.count).zip(items).map { |e| sprintf("%*d. %s", width, e[0], e[1]) }
      end
    end
  end
end
