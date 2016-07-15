class TopicsController < ApplicationController

   before_action :require_sign_in, except: [:index, :show]
   before_action :authorize_user, except: [:index, :show]

  def index
    @topics = Topic.all
  end
  def new
    @topic = Topic.new
  end
  def create
    @topic = Topic.new
    # @topic.comments = params[:topic][:comments]
    # @topic.id = params[:topic][:id]
    # @topic.name = params[:topic][:name]
    # @topic.description = params[:topic][:description]
     
    @topic = Topic.new(topic_params)
    
    
    
    if @topic.save || comment.save
      @topic.labels = Label.update_labels(params[:topic][:labels])
      
      flash[:notice] = "Topic was saved successfully."
      redirect_to @topic
    else
       flash.now[:alert] = "Error creating topic. Please try again."
       render :new
    end
  end
  def show
    @topic = Topic.find(params[:id])
    # @topic.comments = params[:topic][:comments] unless params[:topic].nil?
    # unless params[:topic].nil?
    #     comment = @topic.comments.new(comment_params) 
    #     comment.user = current_user 
    
    #     if comment.save
    #         flash[:notice] = "Comment saved successfully."
    #         redirect_to @topic
    #     else
    #         flash[:alert] = "Comment failed to save."
    #         redirect_to @topic
    #     end
    # end
  end
  def edit
    @topic = Topic.find(params[:id])
  end
  def update
      @topic = Topic.find(params[:id])
 
    # @topic.name = params[:topic][:name]
    # @topic.description = params[:topic][:description]
    # @topic.public = params[:topic][:public]
     @topic.assign_attributes(topic_params)
 
     if @topic.save
        @topic.labels = Label.update_labels(params[:topic][:labels])
        flash[:notice] = "Topic was updated successfully."
        redirect_to @topic
     else
       flash.now[:alert] = "Error saving topic. Please try again."
       render :edit
     end
  end
  def destroy
     @topic = Topic.find(params[:id])
 
     if @topic.destroy
       flash[:notice] = "\"#{@topic.name}\" was deleted successfully."
       redirect_to action: :index
     else
       flash.now[:alert] = "There was an error deleting the topic."
       render :show
     end
  end
  private
 
   def topic_params
    params.require(:topic).permit(:name, :description, :public)
   end

   def authorize_user
     unless current_user.admin?
       flash[:alert] = "You must be an admin to do that."
       redirect_to topics_path
     end
   end
   def comment_params
     params.require(:comment).permit(:body)
   end
end
