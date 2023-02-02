# frozen_string_literal: true
require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require_relative './lib/scrapper'

scrapper = Scrapper.new('http://annuaire-des-mairies.com/val-d-oise.html')
scrapper.perform(@page_url_scrap)
