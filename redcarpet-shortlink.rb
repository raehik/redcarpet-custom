#!/usr/bin/env ruby
#
# Render Markdown to HTML with some special syntax.
#

require "redcarpet"

class HTMLWithShortlinks < Redcarpet::Render::HTML
  # use SmartPants postprocessing
  include Redcarpet::Render::SmartyPants

  # override link method to check for shortlinks
  def link(link, title, content)
    identifier = "!"
    shortlinks = {
      Wikipedia: "http://en.wikipedia.org/wiki/",
    }

    # if no link, link = content
    if link.to_s.empty?
      return url_no_title(content, content)
    end

    # if no identifier at start, normal link
    # Annoyingly, we can't use `super`, due to redcarpet being coded in
    # C with a Ruby API, so we have to approximate the URL-making
    # ourselves. Luckily no biggy, but TODO: Check *all* normal links
    # render correctly! Do a few experiments.
    # TODO: what about HTML escapes??? >:(
    if link.to_s[0] != identifier
      if title.to_s.empty?
        return url_no_title(link, content)
      else
        return url(link, title, content)
      end
    end

    # remove identifier at start
    link_name = link.to_s[identifier.length..-1].to_sym

    # if key doesn't exist, assume normal link
    if shortlinks.key?(link_name) == false
      return url(link, title, content)
    end

    # retrieve URL of shortlink
    link_url = shortlinks[link_name]

    # set title
    if title.to_s.empty?
      page = content
    else
      page = title
    end

    shortlink = "#{link_url}#{page}"
    page_title = "#{link_name}: #{page}"

    url(shortlink, page_title, content)
  end

  def url(link, title, content)
    "<a href=\"#{link}\" title=\"#{title}\">#{content}</a>"
  end

  def url_no_title(link, content)
    "<a href=\"#{link}\">#{content}</a>"
  end
end

default = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
wiki = Redcarpet::Markdown.new(HTMLWithShortlinks, extensions = {
                              no_intra_emphasis: true,
                              strikethrough: true,
                              footnotes: true
                              })

# magic ARGF
puts wiki.render(ARGF.read)