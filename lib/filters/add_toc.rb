# Happily sourced from https://github.com/nanoc/nanoc-site/tree/master/lib

require 'nokogiri'

class AddTOCFilter < Nanoc::Filter

  identifier :add_toc

  def run(content, params={})
    content.gsub('{{TOC}}') do
      toc_items = @item[:custom_toc]

      unless toc_items
        # Find all top-level sections
        doc = Nokogiri::HTML(content)
        toc_items = doc.xpath('//h2').map do |header|
          [header.inner_html, "##{header['id']}"]
        end
      end

      if toc_items.empty?
        next ''
      end

      # Build table of contents
      res = '<ol class="toc">'
      toc_items.each do |toc_item|
        res << %[<li><a href="#{toc_item[1]}">#{toc_item[0]}</a></li>]
      end
      res << '</ol>'

      res
    end
  end

end