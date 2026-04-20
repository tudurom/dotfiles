;; improve startup time by pausing garbage collection during init
(set-variable 'gc-cons-threshold most-positive-fixnum)
