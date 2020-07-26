# reporters/plain.l
#
# The MIT License (MIT)
#
# Copyright (c) 2020 Alexander Williams, Unscramble <license@unscramble.jp>

[de print-report ()
  (mapcar println *Results)

  (if (get-results)
      (bye 1)
      (bye) ]
