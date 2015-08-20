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

      def entity(text)
        case text
        when "&gt;"  then ">"
        when "&lt;"  then "<"
        when "&amp;" then "&"
        else              text
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

      def block_code(code, language)
        code.split("\n").map { |line| "    #{line}\n"}.join("")
      end

      def codespan(code)
        "`#{code}`"
      end

      def strikethrough(text)
        Rainbow(text).hide.to_s
      end
    end
  end
end
