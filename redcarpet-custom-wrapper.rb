#!/usr/bin/env ruby
#
# Ruby wrapper for my custom Redcarpet renderer.
#
# Required to use render options in Jekyll.
#

require ENV['HOME'] + '/bin/redcarpet-custom.rb'

puts Redcarpet::Markdown.new(
  HTMLWithShortlinks.new(
    render_options = { with_toc_data: true}),
  extensions = {
    no_intra_emphasis: true,
    strikethrough: true,
    footnotes: true,
    autolink: true,
    fenced_code_blocks: true,
    superscript: true
}).render(ARGF.read)
