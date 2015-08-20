require 'spec_helper'

module Downterm
  module Render
    describe Terminal do
      let(:terminal) { Terminal.new }
      let(:markdown) { Redcarpet::Markdown.new(terminal, :autolink => true,
                                                         :strikethrough => true) }

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

        it 'is right-aligned' do
          md = <<MD
1. Item 1
2. Item 2
3. Item 3
4. Item 4
5. Item 5
6. Item 6
7. Item 7
8. Item 8
9. Item 9
10. Item 10
11. Item 11
MD
          expected = <<EXP
 1. Item 1
 2. Item 2
 3. Item 3
 4. Item 4
 5. Item 5
 6. Item 6
 7. Item 7
 8. Item 8
 9. Item 9
10. Item 10
11. Item 11
EXP
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'code' do
        it 'is rendered verbatim when inline' do
          md = '`import antigravity`'
          expected = md
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'is rendered verbatim when in a block' do
          md = <<CODE
    import antigravity
    puts "I'm using Python!"
CODE
          expected = md
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'a horizontal rule' do
        it 'is rendered as a series of dashes across the terminal' do
          md = '---'
          expected = '-' * HighLine::SystemExtensions.terminal_size[0] + "\n"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'a quote' do
        it 'is rendered verbatim' do
          md = <<QUOTE
> One, two! One, two! And through and through
> The vorpal blade went snicker-snack!
> He left it dead, and with its head
> He went galumphing back
QUOTE
          expected = md
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'strikethrough text' do
        it 'is rendered dimmer than surrounding text' do
          md = 'today is ~~beautiful~~ grey'
          expected = "today is #{Rainbow('beautiful').hide} grey"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'an image' do
        it 'is printed as a link to the image file' do
          md = '![Michael](http://monkey-robot.com/static/images/michael.png)'
          expected = "#{Rainbow('http://monkey-robot.com/static/images/michael.png').underline}"
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

      describe 'HTML' do
        it 'is rendered verbatim' do
          md = '<div><p><strong>This is HTML!</strong></p></div>'
          expected = md + "\n"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'a header' do
        it 'is rendered verbatim' do
          md = '## Header 2'
          expected = md + "\n"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'a linebreak' do
        it 'is rendered as a new line' do
          md = "Line 1  \nLine 2"
          expected = "Line 1\nLine 2"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end
    end
  end
end
