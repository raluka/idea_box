require 'yaml/store'

class IdeaStore

  class << self
    def database
      return @database if @database

      @database ||= YAML::Store.new('db/ideabox')
      @database.transaction do
        @database['ideas'] ||=[]
      end
      @database
    end

    def raw_ideas
      database.transaction do |db|
        db['ideas'] || []
      end
    end

    def create(data)
      database.transaction do
        database['ideas'] << data
      end
    end

    def all
      ideas = []
      raw_ideas.each_with_index do |data, i|
        ideas << Idea.new(data.merge('id' => i))
      end
      ideas
    end

    def find_raw_idea(id)
      database.transaction do
        database['ideas'].at(id)
      end
    end

    def find(id)
      raw_idea = find_raw_idea(id)
      Idea.new(raw_idea.merge('id' => id))
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
