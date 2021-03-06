module Blacklight
  class JsonPresenter
    include Blacklight::Facet

    # @param [Solr::Response] response raw solr response.
    # @param [Array<SolrDocument>] documents a list of documents
    # @param [Array] facets list of facets
    def initialize(response, documents, facets, blacklight_config)
      @response = response
      @documents = documents
      @facets = facets
      @blacklight_config = blacklight_config
    end

    attr_reader :documents, :blacklight_config

    def search_facets_as_json
      @facets.as_json.each do |f|
        f.delete "options"
        f["label"] = facet_configuration_for_field(f["name"]).label
        f["items"] = f["items"].as_json.each do |i|
          i['label'] ||= i['value']
        end
      end
    end


    # extract the pagination info from the response object
    def pagination_info
      h = {}

      [:current_page, :next_page, :prev_page, :total_pages,
       :limit_value, :offset_value, :total_count,
       :first_page?, :last_page?].each do |k|
        h[k] = @response.send(k)
      end

      h
    end
  end
end
