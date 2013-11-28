#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$:.unshift(File::join(File::dirname(__FILE__)))

require 'pp'

module RGinger
  API_ENDPOINT      = 'http://services.gingersoftware.com/Ginger/correct/json/GingerTheText'
  REPHRASE_ENDPOINT = 'http://ro.gingersoftware.com/rephrase/rephrase'
  API_VERSION       = '2.0'
  API_KEY           = '6ae0c3a0-afdc-4532-a810-82ded0054236'
  DEFAULT_LANG      = 'US'
end

require 'rginger/parser'
require 'rginger/version'