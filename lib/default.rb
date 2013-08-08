# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.
require "nanoc/toolbox"

include Nanoc::Helpers::Tagging
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Rendering
include Nanoc::Toolbox::Helpers::Navigation