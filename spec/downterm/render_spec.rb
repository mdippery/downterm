require 'spec_helper'

module Downterm
  module Render
    describe Terminal do
      let(:terminal) { Terminal.new }
      let(:markdown) { Redcarpet::Markdown.new(terminal, :autolink => true) }

      describe 'emphasis' do
        it 'renders emphasized text to underlines' do
          md = 'the word *italicized* is italicized'
          expected = "the word #{Rainbow("italicized").underline} is italicized"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'renders emphasized text marked by underscores to underlines' do
          md = 'the word _italicized_ is italicized'
          expected = "the word #{Rainbow("italicized").underline} is italicized"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'renders double-emphasized text to boldface' do
          md = 'the word **emphasized** is bolded'
          expected = "the word #{Rainbow("emphasized").bright} is bolded"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'lists' do
        it 'does not touch ordered lists' do
          md = <<MD
1. Item 1
2. Item 2
MD
          expected = md
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'does not touch unordered lists' do
          md = <<MD
* Item 1
* Item 2
MD
          expected = md
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'code' do
        it 'indents code by four spaces' do
          md = '    import antigravity'
          expected = md
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'links' do
        it 'formats manually-created links' do
          md = 'check out [my blog](http://monkey-robot.com/) please!'
          expected = "check out #{Rainbow("my blog").underline} <http://monkey-robot.com/> please!"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'highlights autolinks' do
          md = 'check out http://monkey-robot.com/'
          expected = "check out #{Rainbow("http://monkey-robot.com/").underline}"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'entities' do
        it 'converts &gt; to >' do
          md = '-&gt; look at this!'
          expected = '-> look at this!'
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'converts &lt; to <' do
          md = 'left &lt;&lt; shift'
          expected = 'left << shift'
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'converts &amp; to &' do
          md = 'i like cake &amp; ice cream'
          expected = 'i like cake & ice cream'
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end
    end
  end
end
