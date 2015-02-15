#!/usr/bin/env ruby
#
# gfd, need a Ruby wrapper for this BS
#

require '/home/raehik/bin/redcarpet-shortlink.rb'

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
