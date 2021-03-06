require 'idea_box'

class IdeaBoxApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  set :method_override, true
  set :root, 'lib/app'

  not_found do
    erb :error
  end

  get '/' do
    erb :index, locals: { ideas: IdeaStore.all.sort, idea: Idea.new(params) }
  end

  # Create new idea
  post '/' do
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  # Delete an idea
  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect('/')
  end

  # Edit idea
  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: { idea: idea }
  end

  # Update idea after editing
  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect'/'
  end

  # Rank idea
  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end
end
