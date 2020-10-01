

class AddGlossary < Nanoc::Filter

  identifier :add_glossary

  def run(content, params={})
    content.gsub('{{GLOSSARY}}') do
      return "" unless @item[:glossary]

      terms = @item[:glossary]

      res = '<dl class="glossary">'
      terms.sort.each do |symbol, text|
        term = symbol.to_s
        res << '<dt id="glossary-'
        res << term
        res << '">'
        res << term
        res << '</dt><dd>'
        res << text.gsub(/\[([\w ]+)\]/) do
          '<a href="#glossary-' + $1 + '">' + $1 + '</a>'
        end.gsub(/`(.*?)`/) do
          "<code>#{CGI.escapeHTML($1)}</code>"
        end
        res << '</dd>'
      end
      res << '</dl>'

      res
       end
    end

    end
