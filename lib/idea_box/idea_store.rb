require 'yaml/store'

class IdeaStore

  class << self
    def database
      @database ||= YAML::Store.new('db/ideabox')
    end

    def raw_ideas
      database.transaction do |db|
        db['ideas'] || []
      end
    end

    def create(attributes)
      database.transaction do
        database['ideas'] ||= []
        database['ideas'] << attributes
      end
    end

    def all
      raw_ideas.map do |data|
        Idea.new(data)
      end
    end

    def find_raw_idea(id)
      database.transaction do
        database['ideas'].at(id)
      end
    end

    def find(id)
      Idea.new(find_raw_idea(id))
    end

    def update(id, data)
      database.transaction do
        database['ideas'][id] = data
      end
    end

    def delete(position)
      database.transaction do
        database['ideas'].delete_at(position)
      end
    end
  end
end
