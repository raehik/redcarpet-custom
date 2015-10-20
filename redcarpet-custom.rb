#!/usr/bin/env ruby
#
# Render Markdown to HTML with some special syntax & features.
#

require "redcarpet"
require "pygments"

class HTMLCustom < Redcarpet::Render::HTML

  # use SmartyPants postprocessing
  # renders things a little cooler e.g. double hyphen -> dash
  include Redcarpet::Render::SmartyPants

  # override block code method to do syntax highlighting
  # requires Pygments (Python) and pygments.rb
  # try `pip install pygments` and `gem install pygments.rb`
  #
  # syntax:
  # ```language
  # code
  # ```
  def block_code(code, language)
    if language.to_s.empty?
      # if no language supplied, assume normal text
      lang = "text"
    else
      lang = language
    end

    Pygments.highlight(code, lexer: lang)
  end

  # helper methods, not overriding anything
  def url(link, title, content)
    "<a href=\"#{link}\" title=\"#{title}\">#{content}</a>"
  end

  def url_no_title(link, content)
    "<a href=\"#{link}\">#{content}</a>"
  end

  # override link method to check for shortlinks
  # EDIT: disabled. Shortlinks lose meaning without this renderer, so
  # I'm trying to work around the problem instead of solving it like
  # this.
  def link(link, title, content)
    # if no link, link = absolute content
    if link.to_s.empty?
      #return url_no_title(content, content)
      # emulate Gwern's setup
      #return url("/#{content}", "Go to page: #{content}", content)
      # just make a basic link
      return url_no_title(content, content)
    end

    if title.to_s.empty?
      return url_no_title(link, content)
    else
      return url(link, title, content)
    end
  end
end

# old shortlinks method
=begin
  def link(link, title, content)
    identifier = "!"
    shortlinks = {
      Wikipedia: "http://en.wikipedia.org/wiki/",
      GitHub: "https://github.com/"
    }

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

    # set page name from title if it exists, else content
    if title.to_s.empty?
      # You would think we need to capitalise the first letter of the
      # page, but Wikipedia at least is smart enough to recognise 'Word'
      # and 'word' as the same page, even though any other
      # capitalisation makes Wikipedia treat it as a separate page. So
      # it makes our job easier.
      page = content
    else
      page = title
    end

    shortlink = "#{link_url}#{page}"
    page_title = "#{link_name}: #{page}"

    url(shortlink, page_title, content)
  end
=end
