# encoding: utf-8
require 'spec_helper'

describe Sphinxify::Builder do


  it 'should convert a properly formed category param into a catergory filter query' do
    params = {
      'food_id' => %w(1 2)
    }

    builder = Sphinxify::Builder.new(filters: params) do
      category_filter(:food_id)
    end

    builder.to_search_options.should be == {
      with: {
        food_id: %w(1 2)
      }
    }
  end

  it 'should convert a properly formed range param into a range filter query' do
    params = {
      'quantity_low' => '100',
      'quantity_high' => '200'
    }

    builder = Sphinxify::Builder.new(filters: params) do
      range_filter(:quantity)
    end

    builder.to_search_options.should be == {
      with: {
        quantity: 100..200
      }
    }
  end

  it 'should convert a properly formed date param into a date range filter query' do
    params = {
      'created_at_start' => '2013-01-01',
      'created_at_end' => '2014-01-01'
    }

    builder = Sphinxify::Builder.new(filters: params) do
      date_range_filter(:created_at)
    end

    builder.to_search_options.should be == {
      with: {
        created_at: '2013-01-01'.to_date..'2014-01-01'.to_date
      }
    }
  end

  it 'should discard bad dates' do
    params = {
      'created_at_start' => 'asdf',
      'created_at_end' => 'asdf'
    }

    builder = Sphinxify::Builder.new(filters: params) do
      date_range_filter(:created_at)
    end

    builder.to_search_options.should be == {}
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

  it 'should do something' do
    params = {
      'distance' => '25' # miles
    }

    builder = Sphinxify::Builder.new(filters: params, geo: [40.75, 111.88]) do
      distance_filter(:distance)
    end

    builder.to_search_options.should be == {
      with: {
        geodist: 0.0..40233.5
      },
      geo: [0.7112216701876893, 1.9526743671312559]
    }
  end

  it 'should convert a properly formed bounding box filter to a geographic query' do
    params = {
      'upper_left_latitude' => '25.123', # decimal degrees
      'upper_left_longitude' => '10.123',
      'lower_right_latitude' => '85.8',
      'lower_right_longitude' => '7.185'
    }

    builder = Sphinxify::Builder.new(filters: params) do
      bounding_box_filter
    end

    builder.to_search_options.should be == {
      with: {
        latitude: 1.4974924982111346..0.4384790679785354,
        longitude: 0.17667968017938596..0.12540190675579257
      }
    }
  end

  it 'should set field weights' do
    builder = Sphinxify::Builder.new do
      weight(:color, 2)
      weight(:size, 3)
    end

    builder.to_search_options.should be == {
      field_weights: {
          color: 2,
          size: 3
        }
      }
  end

  it 'should handle a comprehensive set of params' do
    params = {
      'food_id' => %w(1 2),
      'quantity_low' => '100',
      'quantity_high' => '200',
      'distance' => '25',
      'color' => %w(3 4),
      'size' => '32',
      'upper_left_latitude' => '25.123', # decimal degrees
      'upper_left_longitude' => '10.123',
      'lower_right_latitude' => '85.8',
      'lower_right_longitude' => '7.185',
      'created_at_start' => '2013-01-01',
      'created_at_end' => '2014-01-01'
    }

    builder = Sphinxify::Builder.new(filters: params, geo: [40.75, 111.88], sort_mode: :desc, per_page: 5_000, max_matches: 5_000) do
      category_filter(:food_id)
      category_filter(:color)
      category_filter(:size)
      range_filter(:quantity)
      distance_filter(:distance)
      date_range_filter(:created_at)
      bounding_box_filter

      weight(:color, 2)
      weight(:size, 4)
    end

    builder.to_search_options.should be == {
      with: {
        food_id: ['1', '2'],
        color: ['3', '4'],
        size: '32',
        quantity: 100..200,
        geodist: 0.0..40233.5,
        latitude: 1.4974924982111346..0.4384790679785354,
        longitude: 0.17667968017938596..0.12540190675579257,
        created_at: '2013-01-01'.to_date..'2014-01-01'.to_date
      },
      field_weights: {
        color: 2,
        size: 4
      },
      geo: [0.7112216701876893, 1.9526743671312559],
      per_page: 5000,
      max_matches: 5000,
      sort_mode: :desc
    }
  end
end
