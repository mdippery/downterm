require 'spec_helper'

module Downterm
  module Render
    describe Terminal do
      let(:terminal) { Terminal.new }
      let(:markdown) { Redcarpet::Markdown.new(terminal, :autolink => true) }

      describe 'emphasized text' do
        it 'is underlined' do
          md = 'the word *italicized* is italicized'
          expected = "the word #{Rainbow("italicized").underline} is italicized"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'is underlined when delineated by underscores' do
          md = 'the word _italicized_ is italicized'
          expected = "the word #{Rainbow("italicized").underline} is italicized"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'is bolded when it is doubly emphasized' do
          md = 'the word **emphasized** is bolded'
          expected = "the word #{Rainbow("emphasized").bright} is bolded"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'a list' do
        it 'is rendered verbatim when ordered' do
          md = <<MD
1. Item 1
2. Item 2
MD
          expected = md
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'is rendered verbatim when unordered' do
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
        it 'is indented by four spaces' do
          md = '    import antigravity'
          expected = md
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'a link' do
        it 'is formatted when it has a title' do
          md = 'check out [my blog](http://monkey-robot.com/) please!'
          expected = "check out #{Rainbow("my blog").underline} <http://monkey-robot.com/> please!"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'is formatted when it is created automatically' do
          md = 'check out http://monkey-robot.com/'
          expected = "check out #{Rainbow("http://monkey-robot.com/").underline}"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'an entity' do
        it 'is converted from &gt; to >' do
          md = '-&gt; look at this!'
          expected = '-> look at this!'
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'is converted from &lt; to <' do
          md = 'left &lt;&lt; shift'
          expected = 'left << shift'
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'is converted from &amp; to &' do
          md = 'i like cake &amp; ice cream'
          expected = 'i like cake & ice cream'
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end
    end
  end
end
