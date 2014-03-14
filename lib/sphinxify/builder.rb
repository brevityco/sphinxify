module Sphinxify
  class Builder
    attr_reader :filters, :sphinx_options
    TS_OPTIONS = [:with, :conditions, :field_weights, :order, :select, :ranker, :page, :per_page, :max_matches, :sort_mode, :group_by]

    delegate :select, :with, :conditions, :order, :geo, :field_weights, :page, :per_page, :to_search_options, :to_facet_options, to: :sphinx_options

    def initialize(options={}, &block)
      options = ActiveSupport::HashWithIndifferentAccess.new(options)
      @sphinx_options = Sphinxify::Options.new(options.slice(*TS_OPTIONS).symbolize_keys)

      @filters = options[:filters] || {}
      @sort = options[:sort]
      @geo  = options[:geo]

      instance_eval(&block)
    end

    def range_filter(name)
      name_low, name_high = "#{name}_low", "#{name}_high"
      if filters[name_low].present? && filters[name_high].present?
        with(name => filters[name_low].to_i..filters[name_high].to_i)
      end
    end

    def date_range_filter(name)
      name_start, name_end = "#{name}_start", "#{name}_end" 
      if filters[name_start].present? && filters[name_end].present?
        with(name => filters[name_start].to_date..filters[name_end].to_date)
      end
      rescue ArgumentError => e
        raise e unless e.to_s == 'invalid date'
    end

    def category_filter(name)
      if filters[name] && Array(filters[name]).delete_if(&:blank?).present?
        with(name => filters[name])
      end
    end

    def distance_filter(name)
      geoify
      if filters[name] && filters[name].present? && to_search_options[:geo].present?
        distance = filters[name].to_i
        distance = 5 if distance.zero?
        distance *= 1609.34 # miles to meters
        with(geodist: 0.0..distance)
      end
    end

    def bounding_box_filter
      if filters && filters[:upper_left_latitude]
        upper_left_latitude = filters[:upper_left_latitude].to_f
        upper_left_longitude = filters[:upper_left_longitude].to_f
        lower_right_latitude = filters[:lower_right_latitude].to_f
        lower_right_longitude = filters[:lower_right_longitude].to_f
        with(latitude: radians(lower_right_latitude)..radians(upper_left_latitude), longitude: radians(upper_left_longitude)..radians(lower_right_longitude))
      end
    end

    def sort(sorting)
      if @sort.present?
        ordering = sorting.stringify_keys![@sort]
        order(ordering) if ordering
      end
    end

    def weight(field, weight)
      field_weights(field => weight)
    end

    def ranker(ranker)
      sphinx_options.ranker(ranker)
    end

    def present?
      options = to_search_options

      [:with, :conditions, :select, :order].any? { |value| options[value].present? }
    end

    private
    def geoify
      return unless @geo
      geo([radians(@geo.first), radians(@geo.last)])
    end

    def radians(degrees)
      degrees * (Math::PI / 180.0)
    end
  end
end
