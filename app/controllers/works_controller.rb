class WorksController < ApplicationController
  before_action :works_all, only: [:index, :main]
  before_action :find_work, only: [:show, :edit, :update]

  def index; end

  def main; end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)

    if @work.save
      flash[:success] = "Successfully created #{@work.category} #{@work.id}"
      redirect_to work_path(@work)
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    @work.assign_attributes(work_params)

    if @work.save
      flash[:success] = "Successfully updated #{@work.category} #{@work.id}"
      redirect_to work_path(@work)
    else
      render :edit
    end
  end

  def destroy
    @work = Work.find(params[:id])
    @work.votes.each do |v|
      v.delete
    end

    @work.delete
    flash[:success] = "Successfully destroyed #{@work.category} #{@work.id}"

    redirect_to root_path
  end

  def upvote
    @work = Work.find(params[:id])

    if session[:user_id] != nil
      @user = User.find(session[:user_id])
      if @user
        @voted_works = []
        @user.votes.each do |v|
          @voted_works << v.work_id
        end
        if @voted_works.include?(@work.id)
          flash[:error] = "Could not upvote"
        else
          vote = Vote.create(work_id: @work.id, user_id: @user.id, created_at: Time.now)
          flash[:success] = "Successfully upvoted!"
        end
        redirect_back fallback_location: root_path
      end

    else
      flash[:error] = "You must log in to do that"
      redirect_to work_path(@work)
    end
  end


  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end

  def works_all
    @works = Work.all
  end

  def find_work
    @work = Work.find(params[:id])
  end

end
