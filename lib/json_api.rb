module JsonApi
  class ResponseParser
    attr_reader :body

    def initialize(body)
      @body = body
    end

    def more?
      !!json.fetch('links'){{}}['next']
    end

    def data
      json['data']
    end

    def errors
      json['errors']
    end

    def json
      @json ||= JSON.parse(body)
    end
  end

  class PaginatedCollection
    attr_reader :domain, :path

    def initialize(domain:, path:)
      @domain = domain
      @path   = path
      @data   = []
    end

    def fetch(page = 1)
      res = parsed_body(page)
      return puts(res.errors) if res.errors
      @data = @data + res.data
      return @data unless res.more?
      fetch page + 1
    end

    private

    def parsed_body(page)
      ResponseParser.new(get(page).body)
    end

    def get(page)
      puts "Fetching #{path} page:#{page}"
      conn.get(path, { page: { size: 100, number: page }})
    end

    def conn
      @conn ||= Faraday.new(url: domain) do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
