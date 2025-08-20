# Named subsets for current and previous releases.
# Note that these set are static, i.e. they can not be augmented
# anymore with further overlays.
#

self: super:

import ./default.nix { inherit super; }
