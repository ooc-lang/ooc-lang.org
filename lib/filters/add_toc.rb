# Happily sourced from https://github.com/nanoc/nanoc-site/tree/master/lib

require 'nokogiri'

class AddTOCFilter < Nanoc::Filter

  identifier :add_toc

  def run(content, params={})
    content.gsub('{{TOC}}') do
      toc_items = nil

      if @item[:custom_toc]
        toc_items = @item[:custom_toc].map do |item|
          {
            level: 2,
            title: item[0],
            link: item[1]
          }
        end
      end

      if @item[:glossary]
        toc_items = @item[:glossary].sort.map do |symbol, text|
          term = symbol.to_s
          {
            level: 2,
            title: term.capitalize,
            link: "#glossary-#{term}"
          }
        end
      end

      if @item[:index]
        # Find all top-level sections
        doc = Nokogiri::HTML(content)
        toc_items = doc.xpath('//article/descendant::ol/li/descendant::a').map do |link|
          {
            level: 2,
            title: link.inner_html,
            link: "#{link[:href]}"
          }
        end
      end

      unless toc_items
        # Find all top-level sections
        doc = Nokogiri::HTML(content)
        toc_items = doc.xpath('//article/descendant::h2|//article/descendant::h3').map do |header|
          {
            level: header.name[-1..-1].to_i,
            title: header.inner_html,
            link: "##{header['id']}"
          }
        end
      end

      if toc_items.empty?
        next ''
      end

      # Build table of contents
      res = '<ol class="toc">'
      level = 2

      toc_items.each do |toc_item|
        if level < toc_item[:level]
          res << '<ol>'
        elsif level > toc_item[:level]
          res << '</ol>'
        end
        level = toc_item[:level]

        res << %[<li><a href="#{toc_item[:link]}">#{toc_item[:title]}</a></li>]
      end
      res << '</ol>'

      res
    end
  end

end