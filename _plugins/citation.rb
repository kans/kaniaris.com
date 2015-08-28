require 'set'
$citations = {}

module Jekyll
  class CiteInit < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      page_id = context.environments.first['page']['id']
      $citations[page_id] = []
      ""
    end
  end

  class CiteCite < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      site = context.registers[:site]
      converter = site.getConverterImpl(::Jekyll::Converters::Markdown)
      converted = converter.convert(@text)
      page_id = context.environments.first['page']['id']
      $citations[page_id].push(converted)
      id = $citations[page_id].length - 1

      return "<sup><a href='\#citation-#{id}'>[#{id}]</a></sup>"
    end
  end

  class CiteDump < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)

      page_id = context.environments.first['page']['id']
      text = $citations[page_id]
      return "" if not text

      shit = '<ol start="0">'
      text.each_with_index do |marked_down, index|
        shit += "<li id='citation-#{index}'>#{marked_down}</li>"
      end
      shit += "</ol>"
      shit
      # "#{@text} #{Time.now}"
    end
  end
end

Liquid::Template.register_tag('cite_init', Jekyll::CiteInit)
Liquid::Template.register_tag('cite', Jekyll::CiteCite)
Liquid::Template.register_tag('cite_dump', Jekyll::CiteDump)
