class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.unique_ratings
    
    redirection = false
    
    if params.key?(:ratings)
      @checked_ratings = params[:ratings]
    elsif session.key?(:ratings)
      @checked_ratings = session[:ratings]
      redirection = true
    else
      @checked_ratings = {}
      @all_ratings.each do |rating|
        @checked_ratings[rating] = 1
      end
    end
    session[:ratings] = @checked_ratings
    
    if params.key?(:sort_by)
      sort_by = params[:sort_by]
    elsif session.key?(:sort_by)
      sort_by = session[:sort_by]
      redirection = true
    else
      sort_by = nil
    end
    session[:sort_by] = params[:sort_by]
    
    if redirection
      flash.keep
      redirect_to :sort_by => sort_by, :ratings => @checked_ratings
    end
    if sort_by == "title" 
      @movies = Movie.where(rating: @checked_ratings.keys).order("title ASC")
      @title_style = "hilite"
    elsif sort_by == "release_date"
      @movies = Movie.where(rating: @checked_ratings.keys).order("release_date ASC")
      @release_date_style = "hilite"
    else
      @movies = Movie.where(rating: @checked_ratings.keys)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
