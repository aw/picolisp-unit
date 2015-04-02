# reporters/plain.l
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Alexander Williams, Unscramble <license@unscramble.jp>

(local print-report)

[de print-report ()
  (mapcar println *Results)

  (if (get-results)
      (bye 1)
      (bye) ]
