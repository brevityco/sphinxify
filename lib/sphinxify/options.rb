module Sphinxify
  class Options

    def initialize(options={})
      @options = { with: {}, without: {}, with_all: {}, sql: {}, conditions: {}, field_weights: {}, order: nil, select: nil, ranker: nil, page: nil, per_page: nil }
      @options.merge!(options)
    end

    # Sets the select value. Calling again replaces the
    # select value. Expects a string, else does nothing.
    def select(select=nil)
      @options[:select] = select if select.kind_of?(String)
    end

    # Adds one or more conditions to the conditions hash.
    # Calling again merges additional keys into the
    # conditions. Expects a hash, else does nothing.
    def conditions(conditions={})
      @options[:conditions].merge!(conditions) if conditions.kind_of?(Hash)
    end

    # Adds one or more 'with' to the 'with' hash
    # Calling again merges additional keys into the
    # with option. Expects a hash, else does nothing.
    def with(with={})
      @options[:with].merge!(with) if with.kind_of?(Hash)
    end

    def without(without={})
      @options[:without].merge!(without) if without.kind_of?(Hash)
    end

    def with_all(with_all={})
      @options[:with_all].merge!(with_all) if with_all.kind_of?(Hash)
    end

    def sql(sql={})
      @options[:sql].merge!(sql) if sql.kind_of?(Hash)
    end

    # Sets the order value. Calling again replaces the
    # value. Expects a string, else does nothing.
    def order(ordering=nil)
      @options[:order] = ordering if ordering.kind_of?(String)
    end

    # Sets the ranker value. Calling again replaces the
    # value. Expects a string, else does nothing.
    def ranker(ranker=nil)
      @options[:ranker] = ranker if ranker.kind_of?(String)
    end

    # Sets the geo value. Calling again replace the
    # value. Expects an array, else does nothing.
    def geo(coordinates=nil)
      @options[:geo] = coordinates if coordinates.kind_of?(Array)
    end

    # Adds one or more field_weights to the field_weights hash
    # Calling again merges additional keys into the
    # with option. Expects a hash, else does nothing.
    def field_weights(field_weight)
      @options[:field_weights].merge!(field_weight) if field_weight.kind_of?(Hash)
    end

    # Sets the current pagination page.
    def page(page)
      @options[:page] = page
    end

    # Sets the number of results to paginate per page.
    def per_page(per_page)
      @options[:per_page] = per_page
    end

    # Produces the appropriate options search hash for Thinking Sphinx.
    def to_search_options
      @options.select { |key, value| value.present? }
    end

    # Produces the appropriate options facet hash for Thinking Sphinx.
    def to_facet_options
      to_search_options.slice(:select, :with, :conditions, :geo)
    end
  end
end
