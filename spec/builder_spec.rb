# encoding: utf-8
require 'spec_helper'

describe Sphinxify::Builder do


  it 'should do something' do
    params = {
      'food_id' => %w(1 2)
    }

    builder = Sphinxify::Builder.new(filters: params) do
      category_filter(:food_id)
    end

    builder.to_search_options.should be == { with: { food_id: %w(1 2) } }
  end

  it 'should do something else' do
    params = {
      'quantity_low' => '100',
      'quantity_high' => '200'
    }

    builder = Sphinxify::Builder.new(filters: params) do
      range_filter(:quantity)
    end

    builder.to_search_options.should be == { with: { quantity: 100..200 } }
  end

  it 'should ignore empty and malformed parameters' do
    params = {
      'food_id' => '',
      'quantity_low' => '100'
    }

    builder = Sphinxify::Builder.new(filters: params) do
      category_filter(:food_id)
      range_filter(:quantity)
    end

    builder.to_search_options.should be == {}
  end
end
