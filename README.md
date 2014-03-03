# Sphinxify

Sphinxify maps request params into a suitable Thinking Sphinx query hash for filtering, sorting, and field weighting.

For example, take a params hash that looks like the following:

```ruby
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
  'lower_right_longitude' => '7.185'
}

# Point location must be in radians.
geo = [90.0 * (Math::PI / 180.0), 30.0 * (Math::PI / 180.0)]

```

Using a Sphinxify Builder that looks like:

```ruby
builder = Sphinxify::Builder.new(filters: params, geo: geo) do
  category_filter(:food_id)
  category_filter(:color)
  category_filter(:size)
  range_filter(:quantity)
  distance_filter(:distance)
  bounding_box_filter

  weight(:color, 2)
  weight(:size, 4)
end
```

Sphinxify will produce the following Thinking Sphinx options:

```ruby
builder.to_search_options # =>
  {
    with: {
      food_id: ['1', '2'],
      color: ['3', '4'],
      size: '32',
      quantity: 100..200,
      geodist: 0.0..40233.5,
      latitude: 1.4974924982111346..0.4384790679785354,
      longitude: 0.17667968017938596..0.12540190675579257
    },
    field_weights: {
      color: 2,
      size: 4
    },
    geo: [1.5707963267948966, 0.5235987755982988]
  }
```

## Contributing to sphinxify
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 Brevity Co. See LICENSE.txt for
further details.

