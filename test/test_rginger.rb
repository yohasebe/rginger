#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$:.unshift(File::join(File::dirname(File.expand_path(File::dirname(__FILE__))), "lib"))

require 'test/unit'
require 'rginger'
require 'pp'

class TestRGinger < Test::Unit::TestCase
  def setup
    @ginger = RGinger::Parser.new
    @text   = 'I wke up to teh poring rain.'
    @corrected = 'I woke up to the pouring rain.'
    @alternative = 'I woke up to pouring rain.'
  end

  def test_correcting_sentence
    result = @ginger.correct(@text)

    assert_equal @text, result['original']
    assert_equal @corrected, result['corrected']
    assert_equal 3, result['data'].size
    assert_equal 2, result['data'].first['from']
    assert_equal 4, result['data'].first['to']
    assert_equal -26, result['data'].first['reverse_from']
    assert_equal -24, result['data'].first['reverse_to']
    assert_equal "wke", result['data'].first['old']
    assert_equal "woke", result['data'].first['new']
  end

  # def test_rephrasing_sentence
  #   result = @ginger.rephrase(@corrected)
    
  #   assert_equal @corrected, result['original']
  #   assert_equal 4, result['alternatives'].size
  #   assert_equal @alternative, result['alternatives'].first
  # end

end
