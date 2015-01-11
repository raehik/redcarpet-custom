#!/usr/bin/env ruby
#
# gfd, need a Ruby wrapper for this BS
#

require '/home/raehik/bin/redcarpet-shortlink.rb'

puts Redcarpet::Markdown.new(HTMLWithShortlinks, extensions = {
  no_intra_emphasis: true,
  strikethrough: true,
  footnotes: true,
  autolink: true
}).render(ARGF.read)
