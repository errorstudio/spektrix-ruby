# The MIT License (MIT)
#
# Copyright (c) 2015 Oleg Ivanov http://github.com/morhekil
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Symbolizes all of hash's keys and subkeys.
# Also allows for custom pre-processing of keys (e.g. downcasing, etc)
# if the block is given:
#
# somehash.deep_symbolize { |key| key.downcase }
#
# Usage: either include it into global Hash class to make it available to
#        to all hashes, or extend only your own hash objects with this
#        module.
#        E.g.:
#        1) class Hash; include DeepSymbolizable; end
#        2) myhash.extend DeepSymbolizable

module DeepSymbolizable
  def deep_symbolize(&block)
    method = self.class.to_s.downcase.to_sym
    syms = DeepSymbolizable::Symbolizers
    syms.respond_to?(method) ? syms.send(method, self, &block) : self
  end

  module Symbolizers
    extend self

    # the primary method - symbolizes keys of the given hash,
    # preprocessing them with a block if one was given, and recursively
    # going into all nested enumerables
    def hash(hash, &block)
      hash.inject({}) do |result, (key, value)|
        # Recursively deep-symbolize subhashes
        value = _recurse_(value, &block)

        # Pre-process the key with a block if it was given
        key = yield key if block_given?
        # Symbolize the key string if it responds to to_sym
        sym_key = key.to_sym rescue key

        # write it back into the result and return the updated hash
        result[sym_key] = value
        result
      end
    end

    # walking over arrays and symbolizing all nested elements
    def array(ary, &block)
      ary.map { |v| _recurse_(v, &block) }
    end

    # handling recursion - any Enumerable elements (except String)
    # is being extended with the module, and then symbolized
    def _recurse_(value, &block)
      if value.is_a?(Enumerable) && !value.is_a?(String)
        # support for a use case without extended core Hash
        value.extend DeepSymbolizable unless value.class.include?(DeepSymbolizable)
        value = value.deep_symbolize(&block)
      end
      value
    end
  end

end