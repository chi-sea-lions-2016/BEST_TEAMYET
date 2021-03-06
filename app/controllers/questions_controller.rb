get '/questions' do
  @questions = Question.all
  erb :"questions/index"
end

get '/questions/new' do
  erb :"questions/new"
end

post '/questions' do
 question = current_user.questions.new(title: params[:title], content: params[:content])
  if question.save
    if params[:tags] != nil
      tags_array = params[:tags].split(",")
      tags_array.each do |tag|
        question.tags << Tag.create(name: tag)
      end
    end
    redirect "/questions/#{question.id}"
  else
    @errors = question.errors.full_messages
    erb :"questions/new"
  end
end

get '/questions/:id' do
  @question = Question.find(params[:id])
  erb :'questions/show'
end

get '/questions/:id/edit' do
  @question = Question.find(params[:id])
  erb :'questions/edit'
end

put '/questions/:id' do
  @question = Question.find(params[:id])
  @question.assign_attributes(title: params[:title], content: params[:content])
  if @question.save
    if params[:tags] != nil
      @question.tags.delete
      tags_array = params[:tags].split(",")
      tags_array.each do |tag|
        @question.tags << Tag.create(name: tag)
      end
    end
    redirect "/questions/#{@question.id}"
  else
    erb :"questions/edit"
  end
end

delete '/questions/:id' do
  @question = Question.find(params[:id])
  @question.destroy
  redirect '/questions'
end
