include Nanoc::Helpers::Tagging
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Rendering

def sidebar_items
  items.select { |item| item[:type] == 'page' } \
       .sort_by { |item| item[:order] || 2**31 }
end