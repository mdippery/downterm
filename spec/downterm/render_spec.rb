require 'spec_helper'

module Downterm
  module Render
    describe Terminal do
      let(:terminal) { Terminal.new }
      let(:markdown) { Redcarpet::Markdown.new(terminal, :autolink => true,
                                                         :strikethrough => true,
                                                         :superscript => true) }

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

        it 'is bolded and underlined when triply emphasized' do
          md = 'the word ***emphasized*** is emphatic'
          expected = "the word #{Rainbow("emphasized").bright.underline} is emphatic"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'superscript text' do
        it 'is rendered verbatim' do
          md = 'e = mc^2'
          expected = md
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'is rendered verbatim even when consisting of multiple characters' do
          md = 'this gem is really cool^(not)'
          expected = md
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'a list' do
        it 'is rendered verbatim when ordered' do
          md = [
            'This is a list:',
            '',
            '1. Item 1',
            '2. Item 2',
          ].join("\n")
          expected = md
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'is rendered verbatim when unordered' do
          md = [
            'This is a list:',
            '',
            '* Item 1',
            '* Item 2',
          ].join("\n")
          expected = md
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'is right-aligned' do
          md = [
            'This is a list:',
            '',
            '1. Item 1',
            '2. Item 2',
            '3. Item 3',
            '4. Item 4',
            '5. Item 5',
            '6. Item 6',
            '7. Item 7',
            '8. Item 8',
            '9. Item 9',
            '10. Item 10',
            '11. Item 11',
          ].join("\n")
          expected = [
            'This is a list:',
            '',
            ' 1. Item 1',
            ' 2. Item 2',
            ' 3. Item 3',
            ' 4. Item 4',
            ' 5. Item 5',
            ' 6. Item 6',
            ' 7. Item 7',
            ' 8. Item 8',
            ' 9. Item 9',
            '10. Item 10',
            '11. Item 11',
          ].join("\n")
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
          md = [
            %q(This is some code:),
            %q(),
            %q(    import antigravity),
            %q(    puts "I'm using Python!"),
          ].join("\n")
          expected = md
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'a horizontal rule' do
        it 'is rendered as a series of dashes across the terminal' do
          md = [
            'This is some text',
            '',
            '---',
            '',
            'This is some more text',
          ].join("\n")
          expected = [
            'This is some text',
            '',
            '-' * HighLine::SystemExtensions.terminal_size[0],
            '',
            'This is some more text',
          ].join("\n")
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'a quote' do
        it 'is rendered verbatim' do
          md = [
            'This is a cool quote:',
            '',
            '> One, two! One, two! And through and through',
            '> The vorpal blade went snicker-snack!',
            '> He left it dead, and with its head',
            '> He went galumphing back',
          ].join("\n")
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
        it 'is rendered verbatim when in a block' do
          md = [
            'This is some HTML:',
            '',
            '<div><p><strong>This is HTML!</strong></p></div>',
            '',
            "And now we're back to plaintext.",
          ].join("\n")
          expected = md + "\n"
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end

        it 'is rendered verbatim when inline' do
          md = '<strong>This is HTML!</strong>'
          expected = md
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'a header' do
        it 'is rendered verbatim' do
          md = [
            "Here's some text",
            '',
            '## Header 2',
            '',
            'And now a new section',
          ].join("\n")
          expected = md
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end

      describe 'a linebreak' do
        it 'is rendered as a new line' do
          md = [
            'Line 1  ',
            'Line 2',
          ].join("\n")
          expected = [
            'Line 1',
            'Line 2',
          ].join("\n")
          actual = markdown.render(md)
          expect(actual).to eq(expected)
        end
      end
    end
  end
end
