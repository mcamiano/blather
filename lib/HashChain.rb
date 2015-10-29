# The MIT License (MIT)
# 
# Copyright (c) 2015 Mitchell C. Amiano
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
class HashChain
    attr_accessor  :vertices

    def initialize(parser, hash={})

        if hash.has_key?(:from)
            @vertices = hash[:from].vertices
        else
            @vertices={ 
                :start_sentence => {},
                ".".to_sym => { :end_sentence => 1 },
                "!".to_sym => { :end_sentence => 1 },
                "?".to_sym => { :end_sentence => 1 },
            }
        end

        most_recent_token = :start_sentence

        parser.parse.each_with_index do |chunk, index| 
            next if chunk.empty?

            token = chunk
                .downcase
                .to_sym

            @vertices[most_recent_token][token] ||= 0
            @vertices[most_recent_token][token] += 1 

            @vertices[token] ||= { } 

            most_recent_token = token
            most_recent_token = :start_sentence if is_sentence_end?(most_recent_token) 
        end

        # If the stream ended without punctuation, 
        # pretend a period was present.
        @vertices[most_recent_token][".".to_sym] ||= 1
    end

    def sentences()
        most_recent_token = :start_sentence

        sentence=[]

        while true
            selected_option = selection(@vertices[most_recent_token])
            break if selected_option == :end_sentence
            sentence.push(selected_option.to_s)
            most_recent_token = selected_option
        end

        sentence.join(" ")
            .capitalize
            .gsub(/\s+([“".\?\!\,])/,'\1')
            .gsub(/\s([-’'])\s/,'\1')
    end

    def word(most_recent_token=:start_sentence)
        return "" if ! @vertices.has_key? most_recent_token

        loop do 
          selected_option = selection(@vertices[most_recent_token])
          break if selected_option != :end_sentence
        end

        selected_option.to_s
            .gsub(/\s+([“".\?\!\,])/,'\1')
            .gsub(/\s([-’'])\s/,'\1')
    end


    protected
    def selection(options)
        current = 0
        max = options.values.reduce(0,:+)
        random_value = rand(max) + 1
        options.each do |key,val|
            current += val
            return key if random_value <= current
        end
    end

    def is_sentence_end?(token)
        token == ".".to_sym || token == "!".to_sym || token == "?".to_sym
    end
end


