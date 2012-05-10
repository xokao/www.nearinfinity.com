module Jekyll
  module ContentFilters
    private
    def include_template(template, context_hash)
      @context.stack do
        context_hash.each do |key, value|
          @context[key] = value
        end
        return Jekyll::IncludeTag.new(nil, template, nil).render(@context)
      end
    end
  end
end