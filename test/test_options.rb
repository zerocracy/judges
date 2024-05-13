# frozen_string_literal: true

# Copyright (c) 2024 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'minitest/autorun'
require_relative '../lib/judges'
require_relative '../lib/judges/options'

# Test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024 Yegor Bugayenko
# License:: MIT
class TestOptions < Minitest::Test
  def test_basic
    opts = Judges::Options.new(['token=a77', 'max=42'])
    assert_equal('a77', opts.token)
    assert_equal(42, opts.max)
  end

  def test_stips_spaces
    opts = Judges::Options.new(['  token=a77   ', 'max  =  42'])
    assert_equal('a77', opts.token)
    assert_equal(42, opts.max)
  end

  def test_with_nil
    opts = Judges::Options.new(nil)
    assert(opts.foo.nil?)
  end

  def test_with_string
    opts = Judges::Options.new('a=1,b=42')
    assert_equal(1, opts.a)
    assert_equal(42, opts.b)
  end

  def test_with_hash
    opts = Judges::Options.new('foo' => 42, 'bar' => 'hello')
    assert_equal(42, opts.foo)
    assert_equal('hello', opts.bar)
    assert(opts.xxx.nil?)
  end

  def test_converts_to_string
    opts = Judges::Options.new('foo' => 44, 'bar' => 'long-string-maybe-secret')
    assert_equal("foo=44\nbar=long********************", opts.to_s)
  end
end