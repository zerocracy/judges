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

require 'time'
require_relative '../../judges'
require_relative '../../judges/impex'
require_relative '../../judges/elapsed'

# Trim.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024 Yegor Bugayenko
# License:: MIT
class Judges::Trim
  def initialize(loog)
    @loog = loog
  end

  def run(opts, args)
    raise 'Exactly one argument required' unless args.size == 1
    impex = Judges::Impex.new(@loog, args[0])
    fb = impex.import
    query = opts['query']
    if query.nil?
      days = opts['days']
      day = Time.now - (days * 60 * 60 * 24)
      query = "(lt time #{day.utc.iso8601})"
      @loog.info("Deleting facts that are older than #{days} days")
    else
      raise 'Specify either --days or --query' unless opts['days'].nil?
    end
    elapsed(@loog) do
      deleted = fb.query(query).delete!
      throw :'No facts deleted' if deleted.zero?
      impex.export(fb)
      throw :"🗑 #{deleted} fact(s) deleted"
    end
  end
end
